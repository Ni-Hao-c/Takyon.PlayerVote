// Since there cant be localization in a sever sided mod, this will sort of be one
// Here are all the basic strings
// Change these based on your servers language

// general
global const string ALREADY_VOTED = "您已经进行了投票"
global const string MISSING_PRIVILEGES = "需要权限以进行该操作"
global const string COMMAND_DISABLED = "该命令已经被禁用"
global const string NO_PLAYERNAME_FOUND = "需要玩家昵称"
global const string CANT_FIND_PLAYER_FROM_SUBSTRING = "无法使用以下信息找到玩家 " // remember the space at the end

// vote skip
global const string ADMIN_SKIPPED = "管理员跳过了此地图"
global const string MULTIPLE_SKIP_VOTES = " 位玩家希望跳过这张地图\n在聊天框使用 !skip 以跳过此地图" // remember to keep the space in the beginning
global const string ONE_SKIP_VOTE = " 位玩家希望跳过这张地图\n在聊天框使用 !skip 以跳过此地图" // remember to keep the space in the beginning

// announce
global const string NO_ANNOUNCEMENT_FOUND = "未给定需要广播的信息\n Usage: !announce message"

// vote kick
global const string CANT_KICK_YOURSELF = "您不能移出你自己"
global const string CANT_KICK_ADMIN = "您不能移出管理员"
global const string KICKED_PLAYER = "移出了 " // remember the space at the end
global const string NOT_ENOUGH_PLAYERS_ONLINE_FOR_KICK = "服务器内没有足够的玩家进行投票"
global const string PLAYER_WANTS_TO_KICK_PLAYER = " 希望移出 " // remember to keep the space in the beginning and at the end
global const string HOW_TO_KICK = "\n在你的聊天框输入 !yes 或 !no 来进行投票(投票将会是匿名化的)"
global const string ALREADY_VOTE_GOING = "有一个移出玩家的投票请求正在进行，当前投票对象是 " // remember the space at the end
global const string NO_VOTE_GOING = "没有正在进行的投票了。可以使用 !kick"

// message
global const string HOW_TO_MESSAGE = "\nUsage: !msg playerName message"
global const string NO_MESSAGE_FOUND = "没有给定消息"
global const string PLAYER_IS_NULL = "发生了错误，玩家可能已离开服务器"
global const string MESSAGE_SENT_TO_PLAYER = "消息已发送至 " // remember the space at the end

// help
global const string HELP_MESSAGE = "在聊天框输入 !help 获取帮助"

// vote extend
global const string ADMIN_EXTENDED = "管理员增加了地图游玩时间"
global const string MAP_CANT_BE_EXTENDED_TWICE = "游玩时间不能被第二次增加"
global const string MULTIPLE_EXTEND_VOTES = " 位玩家希望延长地图的剩余时间\n在聊天框输入 !extend 来延长时间" // remember to keep the space in the beginning
global const string ONE_EXTEND_VOTE = " 位玩家希望延长地图的剩余时间\n在聊天框输入 !extend 来延长时间" // remember to keep the space in the beginning
global const string MAP_EXTENDED = "延长了对局剩余时间"

// rules
global const string HOW_TO_SENDRULES = "\nUsage: !sr playerName"
global const string RULES_SENT_TO_PLAYER = "规则已被发送至 " // remember the space at the end
global const string ADMIN_SENT_YOU_RULES = "至少一位管理员认为你应该阅读以下服务器规则\n\n" // two linebreaks to distinguish from rules

// switch
global const string SWITCH_FROM_UNASSIGNED = "您的当前队伍已被弃用，正在随机分配新的队伍"
global const string SWITCH_TOO_MANY_PLAYERS = "敌方队伍的人数太多了"
global const string SWITCHED_BY_ADMIN = "您的队伍已被管理员切换"
global const string SWITCHED_TOO_OFTEN = "您切换了太多次队伍，队伍交换将被禁用至下一回合"
global const string SWITCH_ADMIN_SUCCESS = " 切换了他的队伍" // message for admin that player has been switched. remember to keep the space in the beginning
global const string SWITCH_SUCCESS = "您已切换了您的队伍" // message for player that they have switched

// balance
global const string BALANCED = "队伍已由 K/D 进行了再分配"
global const string BALANCED_TITANDAMAGE = "队伍已由 每条命的平均泰坦伤害 进行了再分配"
global const string ONE_BALANCE_VOTE = " 位玩家希望使用 K/D 进行队伍平衡\n在聊天框输入 !balance 来平衡队伍" // remember to keep the space in the beginning
global const string MULTIPLE_BALANCD_VOTES = " 位玩家希望使用 K/D 进行队伍平衡\n在聊天框输入 !balance 来平衡队伍" // remember to keep the space in the beginning
global const string ADMIN_BALANCED = "一位管理员使用 K/D 平衡了队伍"

// map vote
global const string MAPS_NOT_PROPOSED = "该地图尚不可被指定"
global const string MAP_VOTE_USAGE = "输入 !vote <地图前数字> 以选出下一张地图"
global const string ADMIN_VOTED_MAP = "管理员将下一张地图设置为了 "
global const string MAP_NOT_GIVEN = "没有给定地图"
global const string MAP_NUMBER_NOT_FOUND = "该序号没有对应地图"
global const string MAP_YOU_VOTED = "您投票给了 " // remember the space at the end
global const string MAP_VOTE_HEADER = "投票換圖" // have to be traditional chinese to fit game font!
global const string MAP_VOTE_USAGE_PROPOSED = "在聊天框输入 !vote 地图数字 以进行投票。\x1b[38;2;0;220;220m(例：!vote 2)"