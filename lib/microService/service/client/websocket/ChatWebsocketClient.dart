/*
单例设计： websocketClient
 */
import 'package:flutter_simple_websocket/flutter_simple_websocket.dart';
import 'package:flutter_simple_websocket/microService/service/client/module/ClientWebsocketModule.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../server/model/ErrorModel.dart';
import '../common/CommunicationTypeClientModulator.dart';

class ChatWebsocketClient extends ClientWebsocketModule {
  WebsocketClientManager websocketClientManager = WebsocketClientManager();
  CommunicationTypeClientModulator communicationTypeClientModulator =
      CommunicationTypeClientModulator();

  ChatWebsocketClient(
      {required String ip, required int port, String type = "ws"}) {
    // 配置参数
    websocketClientManager.setConfig(
        ip: ip,
        port: port,
        type: type,
        initialBeforeConn: initialBeforeConn,
        whenConnInterrupt: whenConnInterrupt,
        whenConnSuccessWithServer: whenConnSuccessWithServer,
        messageHandler: messageHandler,
        whenClientError: whenClientError);
  }

  /*
  在连接server前的初始化操作
   */
  initialBeforeConn(WebsocketClient websocketClient) {
    print("initial handler");
  }

  /*
  当与server连接中断时
   */
  whenConnInterrupt(WebsocketClient websocketClient) {
    print("conn server is disconnected!");
  }

  /*
  当与server端连接成功时
   */
  whenConnSuccessWithServer(WebsocketClientManager websocketClientManager) {
    printSuccess("conn server is successful");
  }

  /*
  消息处理程序
   */
  messageHandler(WebSocketChannel webSocketChannel, Map message) {
    print("+message hanlder");
    // 调用处理程序
    communicationTypeClientModulator.handler(webSocketChannel, message);
  }

  /*
  错误处理程序
   */
  whenClientError(ErrorObject errorObject) {
    print("client error: $errorObject");
  }

  /*
  启动连接server
   */
  connServer() {
    print("connecting server.......");
    websocketClientManager.conn();
  }
}
