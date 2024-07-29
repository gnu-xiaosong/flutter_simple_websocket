import 'package:web_socket_channel/web_socket_channel.dart';
import '../websocket/WebsocketClient.dart';
import '../websocket/messageByTypeHandler/AuthTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/MessageTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/TestTypeMessageHandler.dart';
// 枚举消息类型
enum MsgType { 
AUTH,
MESSAGE,
TEST,
}

// Map访问：通过string访问变量
Map<String, dynamic> msgTypeByString = {
 "AUTH": MsgType.AUTH,
 "MESSAGE": MsgType.MESSAGE,
 "TEST": MsgType.TEST,
};

// Map访问：通过string访问变量
Map<dynamic, String> stringByMsgType = {
 MsgType.AUTH: "AUTH",
 MsgType.MESSAGE: "MESSAGE",
 MsgType.TEST: "TEST",
};

class CommunicationTypeClientModulator  {
  List classNames = [AuthTypeMessageHandler(), MessageTypeMessageHandler(), TestTypeMessageHandler()];
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    for (var item in classNames) {
      String messageTypeStr = msgDataTypeMap["type"].toUpperCase();
      MsgType? messageType = msgTypeByString[messageTypeStr] as MsgType;
      
      if (messageType == null) {
              print("Unknown message type: messageType==null");
              return;
      }
      
      if (messageType.toString() == item.type.toString()) {
        item.handler(channel, msgDataTypeMap);
        return;
      }
    }
  }
}
