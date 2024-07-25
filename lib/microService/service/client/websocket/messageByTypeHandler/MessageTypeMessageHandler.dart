/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../server/common/OtherMsgType.dart';
import 'TypeMessageClientHandler.dart';

class MessageTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.MESSAGE;

  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 从缓存中取出secret 通讯秘钥
    // String? secret = GlobalManager.appCache.getString("chat_secret");
    // 解密info字段
    // msgDataTypeMap["info"] = decodeMessage(secret!, msgDataTypeMap["info"]);
    // 接收消息
    // printSuccess("receive msg: ${msgDataTypeMap}");
    // 处理
    message(msgDataTypeMap);
  }

  /*
    消息类型:已解密
   */
  void message(Map msgDataTypeMap) {}
}
