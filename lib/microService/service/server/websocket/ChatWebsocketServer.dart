/*
单例设计： websocketServer
 */

import 'dart:io';
import '../../../module/common/Console.dart';
import '../../../module/common/tools.dart';
import '../common/OtherMsgType.dart';

class ChatWebsocketServer extends OtherMsgType with Console, CommonTool {
  /*
  处理客户端断开连接
   */
  @override
  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    super.interruptHandler(request, webSocket);
  }

  /*
    处理接受到的消息
   */
  @override
  void messageHandler(
      HttpRequest request, WebSocket webSocket, dynamic message) {
    // 将string重构为Map
    Map? msgDataTypeMap = stringToMap(message.toString());
    // 这里采用分层层级式处理监听的消息： 每一层逻辑单独
    /*
   针对待处理的其它层的逻辑开发: 由于不同消息类型处理层1，本身为该执行区块，因此
   因此推荐用户如果有其他业务逻辑需求时，不需要再此添加其它层, 采用super.handler处理不同消息类型进行开发
   如果不满足特别需求，可以采用继承该类，然后对该方法进行重写
   例子：
   class CustomWebsocket extends ChatWebsocketServer {
        @override
        void messageHandler(
            HttpRequest request, WebSocket webSocket, dynamic message){
         // 不影响其他逻辑，记得
         super.messageHandler(
            HttpRequest request, WebSocket webSocket, dynamic message);

         // ................其它层逻辑开发.........
        }
   }
    */

    // 1.必要层级: 调用不同消息类型处理  ——> 继承自OtherMsgType类中的handler方法
    super.handler(request, webSocket, msgDataTypeMap!);

    // 2.其他待拓展层......
  }
}