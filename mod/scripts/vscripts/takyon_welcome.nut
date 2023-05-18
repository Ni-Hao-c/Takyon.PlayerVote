global function WelcomeInit
global function ShowWelcomeMessage
global function OnPlayerSpawnedWelcome
global function OnPlayerDisconnectedWelcome

global bool welcomeEnabled = true
global array<string> welcomeSpawnedPlayers = []

// ADD YOUR FUCKING SERVER NAME IN mod.json I BEG YOU
string serverName = ""

//Add your discord server link or website in mod.json
string discordLink = "kaihei.co/wsZVnX"

// TODO maybe make convar
string welcomeMsg = ""

void function WelcomeInit(){
    // ConVar
    welcomeEnabled = GetConVarBool( "pv_welcome_enabled" )
    serverName = GetConVarString( "pv_servername" )

    if(GetConVarString( "pv_group" ) != "" && GetConVarString( "pv_group" ) != "YOUR DISCORD"){
        discordLink = GetConVarString("pv_group")
    }
    // change your welcome msg here
    welcomeMsg =    "%playername% 欢迎您！\n" + // leave %playername% so the msg is personalized
                    "您现在正在 " + serverName + "中进行游玩\n"+
                    "交流群：" + discordLink + "\n" + // add your discord or website
                    "如服务器启用了 -enablechathooks ，那您可以在聊天框输入 !help 获取帮助，否则请在控制台(~)中输入指令" // add -enablechathooks to \Titanfall2\ns_startup_args_dedi.txt
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

string function WelcomeMsgBuilder(string msg, entity player){
    string playerName = "%playername%"
    string finMsg = StringReplace(msg, playerName, player.GetPlayerName())
    return finMsg
}