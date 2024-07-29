/*
websocket server 模块 ：处理有关server websocket有关逻辑
 */
import 'dart:io';
import 'package:flutter_simple_websocket/microService/module/common/tools.dart';

import '../../../module/common/Console.dart';
import '../../../module/common/enum.dart';

class WebSocketServer with Console, CommonTool {
  // IP地址
  InternetAddress? ip = InternetAddress.anyIPv4;

  // 端口port
  int port;

  WebSocketServer({
    this.port = 1314,
  });

  // 初始化HttpServer服务
  late HttpServer _server;

  // websocket 连接的client客户端列表
  final List<WebSocket> _clients = [];
  List get clients => _clients;

  /*
  启动前的初始化操作
   */
  void bootInitial(WebSocketServer webSocketServer) {}

  /*
  server绑定地址成功后的操作
   */
  Future<void> bindAddrSuccesshandler(WebSocketServer webSocketServer) async {}

  // websocket server启动
  Future<void> start() async {
    // 启动前的初始化操作
    this.bootInitial(this);

    try {
      // 绑定ip和端口
      HttpServer.bind(ip, port, shared: true).then((server) async {
        printSuccess("WebSocket server running on ip=$ip port=$port");
        _server = server;
        bindAddrSuccesshandler(this);

        await for (var request in _server) {
          if (WebSocketTransformer.isUpgradeRequest(request)) {
            print("Handling WebSocket request");
            _handleWebSocket(request);
          } else {
            print("Handling regular HTTP request");
            _handleRegularHttpRequest(request);
          }
        }
      }).catchError((e) {
        print('Error binding server: $e');
      });
    } catch (e, stackTrace) {
      // 处理server异常: 错误类型
      handleServerError(e, stackTrace, ErrorType.websocketServerBoot);
    }
  }

  /*
   处理服务器错误
   */
  void handleServerError(
      Object error, StackTrace stackTrace, ErrorType errorType) {
    // print('服务器遇到错误: $error');
  }

  // 处理websocket client客户端的请求
  void _handleWebSocket(HttpRequest request) async {
    try {
      WebSocketTransformer.upgrade(request).then((value) {
        WebSocket webSocket = value;
        printError(
            'WebSocket client connected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
        // 连接成功添加进列表中
        _clients.add(webSocket); // 添加进该类变量中

        // 处理当存在客户端client连接成功时处理程序
        handlerClientConnSuccess(request, webSocket);
        // 监听消息
        webSocket.listen((message) {
          // ***************监听消息并处理**************
          messageHandler(request, webSocket, message);
          //****************监听消息并处理**************
        }, onDone: () {
          // 移除当前中断的websocket
          _clients.remove(webSocket);
          // ***************连接中断**************
          interruptHandler(request, webSocket);
        });
      });
    } catch (e, stackTrace) {
      // 处理server端异常: 启动监听异常
      handleServerError(e, stackTrace, ErrorType.websocketClientListen);
    }
  }

  /*
  监听有客户端client连接成功时的回调函数
   */
  void handlerClientConnSuccess(HttpRequest request, WebSocket webSocket) {}

  /*
  消息监听处理程序
   */
  void messageHandler(
      HttpRequest request, WebSocket webSocket, dynamic message) {}

  /*
  中断处理程序
   */
  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    /*
      desc: 对于连接中断的处理操作,用户继承该类并重写该方法来实现
      parameters:
          webSocket  WebSocket  中断的WebSocket
     */
    // websocket连接中断
    printError(
        'WebSocket client disconnected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
  }

  /*
  处理普通http请求
   */
  void _handleRegularHttpRequest(HttpRequest request) {
    printError("this request is htttp ! WebSocket connections only");
    // 默认提示websocket请求
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('WebSocket connections only')
      ..close();
  }

  /*
   websocket server停止
   */
  Future<void> stop() async {
    await _server.close();
    printWarn('WebSocket server stopped.');
  }
}
