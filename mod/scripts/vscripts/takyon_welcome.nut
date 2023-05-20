global function WelcomeInit
global function ShowWelcomeMessage
global function ShowChatWelcomeMessage
global function OnPlayerSpawnedWelcome
global function OnPlayerDisconnectedWelcome

global bool welcomeEnabled = true
global array<string> welcomeSpawnedPlayers = []

// ADD YOUR FUCKING SERVER NAME IN mod.json I BEG YOU
string serverName = ""

//Add your discord server link or website in mod.json
string groupLink = "kaihei.co/wsZVnX"

// TODO maybe make convar
string welcomeMsg = ""
string welcomeMsgChat = ""

const string ANSI_COLOR_END = "\x1b[0m"
const string ANSI_COLOR_YELLOW = "\x1b[38;5;11m"
const string ANSI_COLOR_RED = "\x1b[38;5;196m"
const string ANSI_COLOR_BLUE = "\x1b[38;5;81m"
const string ANSI_COLOR_ORANGE = "\x1b[38;5;208m"

void function WelcomeInit(){
    // ConVar
    welcomeEnabled = GetConVarBool( "pv_welcome_enabled" )
    serverName = GetConVarString( "pv_servername" )

    if(GetConVarString( "pv_group" ) != "" && GetConVarString( "pv_group" ) != "YOUR QQGROUP NUM"){
        groupLink = GetConVarString("pv_group")
    }
    // change your welcome msg here
    welcomeMsg =     "欢迎您！%playername%\n" + // leave %playername% so the msg is personalized
                    "您现在正在 " + serverName + "中进行游玩\n"+
                    "交流群：" + groupLink + "\n" + // add your discord or website
                    "您可以在聊天框输入 !help 获取帮助" // add -enablechathooks to \Titanfall2\ns_startup_args_dedi.txt
    
    welcomeMsgChat = "欢迎您！" + ANSI_COLOR_BLUE + " %playername%" + ANSI_COLOR_END + "\n" + 
                    "您现在正在 " + ANSI_COLOR_YELLOW + serverName + ANSI_COLOR_END + " 中进行游玩\n" +
                    "交流群：" + ANSI_COLOR_YELLOW + groupLink + ANSI_COLOR_END + "\n" + 
                    ANSI_COLOR_ORANGE + "您可以在聊天框输入 !help 获取帮助" + ANSI_COLOR_END 
}

/*
 *  WELCOME MESSAGE LOGIC
 */

void function OnPlayerSpawnedWelcome(entity player){
    if(!mapsHaveBeenProposed && welcomeEnabled && welcomeSpawnedPlayers.find(player.GetPlayerName()) == -1){ // prioritizing the vote instead of showing help
        //ShowWelcomeMessage(player)
        welcomeSpawnedPlayers.append(player.GetPlayerName())
    }
}

void function OnPlayerDisconnectedWelcome(entity player){
    // remove player from list so on reconnect they get the message again
    while(welcomeSpawnedPlayers.find(player.GetPlayerName()) != -1){
        try{
            welcomeSpawnedPlayers.remove(welcomeSpawnedPlayers.find(player.GetPlayerName()))
        } catch(exception){} // idc abt error handling
    }
}

/*
 *  HELPER FUNCTIONS
 */

void function ShowWelcomeMessage(entity player){
    SendHudMessageBuilder(player, WelcomeMsgBuilder(welcomeMsg, player), 255, 255, 255) // Message that gets displayed on respawn
}

void function ShowChatWelcomeMessage( entity player )
{
    Chat_ServerPrivateMessage( player, WelcomeMsgBuilder( welcomeMsgChat, player ), false ) // message player on connection
}

string function WelcomeMsgBuilder(string msg, entity player){
    string playerName = "%playername%"
    string finMsg = StringReplace(msg, playerName, player.GetPlayerName())
    return finMsg
}