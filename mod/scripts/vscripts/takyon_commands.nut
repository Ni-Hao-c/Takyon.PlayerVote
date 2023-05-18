global function CommandsInit

global struct Command{
    array<string> names // allows for more variants like !sendrules and !sr being the same
    bool blockMessage // if chat message should be blocked, good for admin commands or anonymous votes
    string usage // this is for help
    bool functionref(entity, array<string>) func
}

global array<Command> commandArr

void function CommandsInit(){
    commandArr.append(new_CommandStruct(["skip", "rtv","!skip", "!rtv"],                               false, "!skip -> 跳过当前游玩的地图", CommandSkip))
    commandArr.append(new_CommandStruct(["extend", "elongate", "ext","!extend", "!elongate", "!ext"],  false, "!extend -> 延长当前地图的游玩时间", CommandExtend)) // elongate is for Sye <3
    commandArr.append(new_CommandStruct(["kick","!kick"],                                              false, "!kick -> 移出某位玩家", CommandKick))
    commandArr.append(new_CommandStruct(["yes","!yes"],                                                true, "!yes -> 赞成对玩家的移出动议", CommandYes))
    commandArr.append(new_CommandStruct(["no","!no"],                                                  true, "!no -> 否定对玩家的移出动议", CommandNo))
    commandArr.append(new_CommandStruct(["switch","!switch"],                                          false, "!switch -> 切换您的队伍", CommandSwitch))
    commandArr.append(new_CommandStruct(["help"],                                                      false, "", CommandHelp))
    commandArr.append(new_CommandStruct(["discord", "dc"],                                             false, "!discord -> to display the link to the discord server", CommandDiscord))
    commandArr.append(new_CommandStruct(["getuid", "gu","!getuid", "!gu"],                             true, "!getuid name -> [特权命令] 获取某位玩家的Uid", CommandGetUid))
    commandArr.append(new_CommandStruct(["ping","!ping"],                                              true, "!ping (name) -> 获取您或者某位玩家的延迟", CommandPing))
    commandArr.append(new_CommandStruct(["balance", "bal","!balance", "!bal"],                         false, "!balance -> 投票以使用 K/D 平衡队伍", CommandBalance))
    commandArr.append(new_CommandStruct(["rules","!rules"],                                            false, "!rules -> 获取服务器规则", CommandRules))
    commandArr.append(new_CommandStruct(["sendrules", "sr","!sendrules", "!sr"],                       true, "!sr -> [特权命令] 将规则发送至某位玩家", CommandSendRules))
    commandArr.append(new_CommandStruct(["msg", "message","!msg", "!message"],                         true, "!msg -> !msg player message", CommandMsg))
    commandArr.append(new_CommandStruct(["announce", "ann","announce", "ann"],                         true, "!announce -> !announce message", CommandAnnounce))
    commandArr.append(new_CommandStruct(["vote", "maps","vote", "maps"],                               false, "!vote -> !vote [地图序号] 选出下一张地图", CommandVote))
}

/*
 *  HELPER FUNCTIONS
 */

Command function new_CommandStruct(array<string> names, bool blockMessage, string usage, bool functionref(entity, array<string>) funkyFunc)
{
  Command newStruct
  newStruct.names = names
  newStruct.blockMessage = blockMessage
  newStruct.usage = usage
  newStruct.func = funkyFunc
  return newStruct
}