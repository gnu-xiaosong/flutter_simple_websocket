/*
单例设计： websocketClient
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import '../common/OtherClientMsgType.dart';

class ChatWebsocketClient extends OtherClientMsgType {
  /*
  client与server连接成功时
   */
  @override
  Future<void> conn_success(WebSocketChannel? channel) async {
    // 调用
    super.conn_success(channel);
  }

  /*
  监听消息处理程序
   */
  @override
  void listenMessageHandler(message) {
    // 将string重构为Map
    Map? msgDataTypeMap = stringToMap(message.toString());
    // 根据不同消息类型处理程序
    super.handler(channel, msgDataTypeMap!);
    // 调用
    super.listenMessageHandler(message);
  }

  /*
  连接中断时
   */
  @override
  void interruptHandler(WebSocketChannel channel) {
    // 调用
    super.interruptHandler(channel);
  }
}
