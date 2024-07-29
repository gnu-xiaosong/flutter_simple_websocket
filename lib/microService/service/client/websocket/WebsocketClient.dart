/*
desc: 这是封装好的websocket客户端
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../module/common/enum.dart';
import '../../server/model/ErrorModel.dart';
import '../module/ClientWebsocketModule.dart';

class WebsocketClient extends ClientWebsocketModule {
  Uri? wsUrl;

  // IP地址
  String? ip;

  // 端口port
  int port = 1314;

  WebSocketChannel? channel;

  String type = "ws";

  /*
  连接前的出初始化操作
   */
  void initialBeforeConn(WebsocketClient websocketClient) {}

  // 连接websocketServer
  void connnect() {
    // 连接前的出初始化操作
    initialBeforeConn(this);
    try {
      // 开始连接
      channel = WebSocketChannel.connect(Uri.parse("$type://${ip}:${port}"));
      channel!.ready;
      //*****************连接成功回调处理函数*********************
      printSuccess("this websocket is connected for $type://${ip}:${port}");
      conn_success(channel);
    } catch (e) {
      print(
          "-WARN:connect is error, this client is interrupted! more detail: $e");
      // 连接异常: 调用异常处理函数
      ErrorObject errorObject =
          ErrorObject(type: ErrorType.connWebsocketServer);
      handlerClientError(errorObject);
      // 关闭连接
      channel!.sink.close(status.goingAway);
    }

    // 监听信息
    channel!.stream.listen((message) {
      // print("received: $message");
      // 处理监听信息
      listenMessageHandler(channel!, message);
    }, onError: (e) {
      // 调用异常处理函数
      // 调用异常处理函数
      ErrorObject errorObject =
          ErrorObject(type: ErrorType.websocketClientListen);
      handlerClientError(errorObject);

      // 连接错误
      print("+INFO:connect is error!more detail:$e");
    }, onDone: () {
      // websocket连接中断
      print('WebSocket client disconnected.');
      // ***************连接中断**************
      this.interruptHandler(channel!);
      // 调用异常处理函数
      ErrorObject errorObject =
          ErrorObject(type: ErrorType.connWebsocketServer);
      handlerClientError(errorObject);
      //****************连接中断**************
    });
  }

  // 连接中断处理
  void interruptHandler(WebSocketChannel channel) {
    /*
      desc: 对于连接中断的处理操作,用户继承该类并重写该方法来实现
      parameters:
          channel  WebSocketChannel  中断的WebSocket
     */
  }

  // 处理监听的信息处理程序
  void listenMessageHandler(WebSocketChannel channel, String message) {
    // 发送信息给服务器
    // print("Broadcast: $message");
    // channel!.sink.add(message);
    // 关闭
    // channel!.sink.close(status.goingAway);
  }

  // 发送消息
  void send(String message) {
    print("send msg: ${message}");
    // 发送消息
    channel?.sink.add(message);
  }

  /*
  客户端异常处理
   */
  void handlerClientError(ErrorObject errorObject) {
    print("异常: ${errorObject}");
  }

  /*
  连接成功回调函数
   */
  void conn_success(WebSocketChannel? channel) {
    // 连接成功可以处理AUTH认证等操作
  }
}
