global function SwitchInit
global function CommandSwitch

bool switchEnabled = true // true: users can use !switch | false: users cant use !switch
bool adminSwitchPlayerEnabled = true // true: admins can switch users | false: admins cant switch users
int maxPlayerDiff = 1 // how many more players one team can have over the other.
int maxSwitches = 2 // how many times a player can switch teams per match. should be kept low so players cant spam to get an advantage
bool matchBalanceEnabeld = true

array<string> switchedPlayers = [] // array of players who have switched their team. does not include players switched by admin

const string ANSI_COLOR_ERROR = "\x1b[38;5;196m"
const string ANSI_COLOR_TEAM = "\x1b[38;5;81m"
const string ANSI_COLOR_ENEMY = "\x1b[38;5;208m"

void function SwitchInit(){
    // add commands here. i added some varieants for accidents, however not for brain damage. do whatever :P
    AddClientCommandCallback("!switch", CommandSwitch)
    AddClientCommandCallback("!SWITCH", CommandSwitch)
    AddClientCommandCallback("!Switch", CommandSwitch)

    // ConVars
    switchEnabled = GetConVarBool( "pv_switch_enabled" )
    adminSwitchPlayerEnabled = GetConVarBool( "pv_switch_admin_switch_enabled" )
    maxPlayerDiff = GetConVarInt( "pv_switch_max_player_diff" )
    maxSwitches = GetConVarInt( "pv_max_switches" )

    // new adding: balance before match
    AddCallback_GameStateEnter( eGameState.Prematch, BalanceTeam )
    matchBalanceEnabeld = GetConVarBool( "pv_balance_before_match" )

    AddCallback_OnClientDisconnected( CheckPlayerDisconnect )
}

// balance before match
void function BalanceTeam()
{
    // fix balance think
	if ( matchBalanceEnabeld )
	{
		bool disabledClassicMP = !GetClassicMPMode() && !ClassicMP_ShouldTryIntroAndEpilogueWithoutClassicMP()
		//print( "disabledClassicMP: " + string( disabledClassicMP ) )
		if ( disabledClassicMP )
		{
			WaitFrame() // do need wait before shuffle
			TeamBalance()
		}
		else if( ClassicMP_GetIntroLength() < 1 )
		{
			TeamBalance()
			WaitFrame() // do need wait to make things shuffled
		}
		else if( ClassicMP_GetIntroLength() >= 5 )
			thread TeamBalance( ClassicMP_GetIntroLength() - 0.5 )
	}
}

void function TeamBalance( float delay = 0 )
{
	if( delay > 0 )
		wait delay

	int mltTeamSize = GetPlayerArrayOfTeam( TEAM_MILITIA ).len()
	int imcTeamSize = GetPlayerArrayOfTeam( TEAM_IMC ).len()
	int teamSizeDifference = abs( mltTeamSize - imcTeamSize )
  	if( teamSizeDifference <= maxPlayerDiff )
		return
	
	if ( GetPlayerArray().len() == 1 )
		return

	int timeShouldBeDone = teamSizeDifference - maxPlayerDiff
	int largerTeam = imcTeamSize > mltTeamSize ? TEAM_IMC : TEAM_MILITIA
	array<entity> largerTeamPlayers = GetPlayerArrayOfTeam( largerTeam )
	
	int largerTeamIndex = 0
	entity poorGuy
	int oldTeam
	// fix shuffle is done before match start, no need to use PlayerTrySwitchTeam()
	for( int i = 0; i < timeShouldBeDone; i ++ )
	{
		poorGuy = largerTeamPlayers[ largerTeamIndex ]
		largerTeamIndex += 1

		if( IsAlive( poorGuy ) ) // poor guy
		{
			poorGuy.Die( null, null, { damageSourceId = eDamageSourceId.team_switch } ) // better
			if ( poorGuy.GetPlayerGameStat( PGS_DEATHS ) >= 1 ) // reduce the death count
				poorGuy.AddToPlayerGameStat( PGS_DEATHS, -1 )
		}
		int oldTeam = poorGuy.GetTeam()
		SetTeam( poorGuy, GetOtherTeam( largerTeam ) )
		if( !RespawnsEnabled() ) // do need respawn the guy if respawnsdisabled
			RespawnAsPilot( poorGuy )
	}
	if( IsValid( poorGuy ) )
	{
		// only notify once
		Chat_ServerPrivateMessage( poorGuy, ANSI_COLOR_TEAM + "由于队伍人数不平衡，你已被重新分队", false )
		NotifyClientsOfTeamChange( poorGuy, oldTeam, poorGuy.GetTeam() ) 
	}
}

/*
 *  COMMAND LOGIC
 */

bool function CommandSwitch(entity player, array<string> args){
    if(!IsLobby() && !IsFFAGame()){
        printl("USER USED SWITCH")

        // check if enabled
        if(!switchEnabled){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + COMMAND_DISABLED, false)
            return false
        }

        // no name or force given so it cant be an admin switch. -> switch player that requested
        if(args.len() < 1){
            // check if player has already switched too often
            if(FindAllSwitches(player) >= maxSwitches){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + SWITCHED_TOO_OFTEN, false)
                return false
            }

            switchedPlayers.append(player.GetPlayerName())
            SwitchPlayer(player)
            return true
        }

        // no player name given
        if(args.len() == 1){
            Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + NO_PLAYERNAME_FOUND, false)
            return false
        }

        // admin force switch
        if(args.len() >= 2 && args[0] == "force"){
            // Check if user is admin
            if(!IsPlayerAdmin(player)){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + MISSING_PRIVILEGES, false)
                return false
            }

            // player not on server or substring unspecific
            if(!CanFindPlayerFromSubstring(args[1])){
                Chat_ServerPrivateMessage(player, "\x1b[38;2;220;0;0m" + CANT_FIND_PLAYER_FROM_SUBSTRING + args[1], false)
                return false
            }

            // get the full player name based on substring. we can be sure this will work because above we check if it can find exactly one matching name... or at least i hope so
            string fullPlayerName = GetFullPlayerNameFromSubstring(args[1])

            // give player and admin feedback
            SendHudMessageBuilder(player, fullPlayerName + SWITCH_ADMIN_SUCCESS, 255, 200, 200)
            SendHudMessageBuilder(GetPlayerFromName(fullPlayerName), SWITCHED_BY_ADMIN, 255, 200, 200)
            SwitchPlayer(GetPlayerFromName(fullPlayerName), true)
        }
    }
    return true
}

/*
 *  HELPER FUNCTIONS
 */

void function SwitchPlayer(entity player, bool force = false)
{
    int oldTeam = player.GetTeam()
    if ( force || CanPlayerSwitch( player ) )
    {
        SetTeam( player, GetOtherTeam( player.GetTeam() ) )
	    NotifyClientsOfTeamChange( player, oldTeam, player.GetTeam() )
        SendHudMessageBuilder( player, SWITCH_SUCCESS, 200, 200, 255 )
        Chat_ServerPrivateMessage( player, ANSI_COLOR_TEAM + SWITCH_SUCCESS, false )

        if ( IsAlive( player ) )
        {
            player.Die( null, null, { damageSourceId = eDamageSourceId.team_switch } ) // kill the player
            if ( player.GetPlayerGameStat( PGS_DEATHS ) >= 1 ) // reduce the death count
                player.AddToPlayerGameStat( PGS_DEATHS, -1 )
        }
    }
}

void function CheckPlayerDisconnect( entity player )
{
	if ( !switchEnabled ) // switch disabled?
		return

	// since this player may not being destroyed, should do a new check here
	bool playerStillValid = IsValid( player )
	int team = -1
	if ( playerStillValid )
		team = player.GetTeam()

	if ( GetPlayerArray().len() == 1 )
		return
  
	// Check if difference is smaller than 2 ( dont balance when it is 0 or 1 )
	int imcTeamSize = GetPlayerArrayOfTeam( TEAM_IMC ).len()
	int mltTeamSize = GetPlayerArrayOfTeam( TEAM_MILITIA ).len()
	if ( playerStillValid ) // disconnecting player still valid
	{
		// do reduced teamsize
		if ( team == TEAM_IMC )
			imcTeamSize -= 1
		if ( team == TEAM_MILITIA )
			mltTeamSize -= 1
	}
	if( abs ( imcTeamSize - mltTeamSize ) <= maxPlayerDiff )
		return

	int weakTeam = imcTeamSize > mltTeamSize ? TEAM_MILITIA : TEAM_IMC
	foreach ( entity player in GetPlayerArrayOfTeam( GetOtherTeam( weakTeam ) ) )
		Chat_ServerPrivateMessage( player, ANSI_COLOR_ENEMY + "队伍当前不平衡，可通过聊天框输入 !switch 切换队伍。", false )
}

bool function CanPlayerSwitch( entity player )
{
    if ( IsFFAGame() )
        return false

    if ( GetPlayerArray().len() == 1 )
	{
    	Chat_ServerPrivateMessage( player, ANSI_COLOR_ERROR + "人数不足，不可切换队伍", false ) // chathook has been fucked up
		return true
	}

    if ( player.isSpawning )
	{
    	Chat_ServerPrivateMessage( player, ANSI_COLOR_ERROR + "作为泰坦复活途中，不可切换队伍", false ) // chathook has been fucked up
		return false
	}

    int teamDiff = abs ( GetPlayerArrayOfTeam( TEAM_IMC ).len() - GetPlayerArrayOfTeam( TEAM_MILITIA ).len() )
    if ( teamDiff <= maxPlayerDiff ) 
    {
        Chat_ServerPrivateMessage( player, ANSI_COLOR_ERROR + "队伍已平衡，不可切换队伍", false )
        return false
    }

    return false
}

int function FindAllSwitches(entity player){
    int amount = 0
    foreach (string name in switchedPlayers){
        if(name == player.GetPlayerName())
            amount++
    }
    return amount
}
