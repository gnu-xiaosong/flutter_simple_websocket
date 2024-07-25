/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../server/common/OtherMsgType.dart';
import 'TypeMessageClientHandler.dart';

class AuthTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.AUTH;

  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 解密info字段
    msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);
    //处理逻辑
    auth(channel, msgDataTypeMap);
  }

  /*
    客户端client 第一次请求认证服务端server
   */
  void auth(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 被动接受消息业务操作
  }
}
