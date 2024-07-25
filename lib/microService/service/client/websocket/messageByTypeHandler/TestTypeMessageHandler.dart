/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../server/common/OtherMsgType.dart';
import 'TypeMessageClientHandler.dart';

class TestTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.TEST;
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    //处理逻辑
  }
}
