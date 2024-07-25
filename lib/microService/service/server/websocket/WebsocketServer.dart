/*
websocket server 模块 ：处理有关server websocket有关逻辑
 */
import 'dart:io';
import 'package:flutter_simple_websocket/microService/module/manager/GlobalManager.dart';
import 'package:flutter_simple_websocket/microService/service/server/model/ClientObject.dart';
import '../../../module/common/enum.dart';
import '../module/ServerWebsocketModule.dart';

class WebSocketServer extends ServerWebsocketModule {
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

  // websocket server启动
  Future<void> start() async {
    try {
      // 绑定ip和端口
      _server = await HttpServer.bind(ip, port, shared: true);
      printWarn(
          "WebSocket server running on ${_server.address}:${_server.port}");

      // 遍历处理与之连接的websocket client客户端
      await for (var request in _server) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          //  判断接收到的请求是否是WebSocket升级请求。如果是的话，说明客户端希望将HTTP连接升级为WebSocket连接
          _handleWebSocket(request);
        } else {
          // 处理普通的HTTP请求
          _handleRegularHttpRequest(request);
        }
      }
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
    print('服务器遇到错误: $error');
    //
  }

  // 处理websocket client客户端的请求
  void _handleWebSocket(HttpRequest request) async {
    try {
      WebSocket webSocket = await WebSocketTransformer.upgrade(request);
      printError(
          'WebSocket client connected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
      // 连接成功添加进列表中
      _clients.add(webSocket); // 添加进该类变量中
      // 添加进全局变量中
      /// 1.封装clientObject对象
      ClientObject clientObject = ClientObject(
        // deviceId: null, // 唯一标识符: 该
        socket: webSocket, // socket对象
        ip: request.connectionInfo!.remoteAddress.address
            .toString(), // 客户端client ip
        port: request.connectionInfo!.remotePort.toInt(),
        retryConnCount: 0, // 客户端client port
        // secret: secret // 认证秘钥
      );
      GlobalManager.onlineClientList.add(clientObject); // 添加进在线全局变量中
      GlobalManager.allConnectedClientList
          .add(clientObject); // 运行期间添加进存在过连接的所有client客户端对象

      // 监听消息
      webSocket.listen((message) {
        // ***************监听消息并处理**************
        this.messageHandler(request, webSocket, message);
        //****************监听消息并处理**************
      }, onDone: () {
        // websocket连接中断
        printError(
            'WebSocket client disconnected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
        // ***************连接中断**************
        this.interruptHandler(request, webSocket);
        //****************连接中断**************
        // 移除当前中断的websocket
        _clients.remove(webSocket);
        GlobalManager.onlineClientList
            .removeWhere((clientObject) => clientObject.socket == webSocket);
        GlobalManager.allConnectedClientList =
            GlobalManager.allConnectedClientList.map((clientObject) {
          // 找出对应存储的client
          if (clientObject.socket == webSocket) {
            // 更改信息
            clientObject..connected = false;
            // 增加断线重连次数
            clientObject.retryConnCount += 1;
            // 更改最近一次断线时间
            clientObject.disconnRecentTime = DateTime.now();
            // 消息队列依然保存，作为离线存储未接受消息

            return clientObject;
          }

          return clientObject;
        }).toList();
      });
    } catch (e, stackTrace) {
      // 处理server端异常: 启动监听异常
      handleServerError(e, stackTrace, ErrorType.websocketClientListen);
    }
  }

  void messageHandler(
      HttpRequest request, WebSocket webSocket, dynamic message) {
    /*
      desc: 对于监听到消息进行处理操作,用户继承该类并重写该方法来实现
      parameters:
          request
          webSocket  WebSocket  中断的WebSocket
          message    dict  对象字典
     */

    // 向所有客户端广播消息
    // broadcast('$message');
  }

  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    /*
      desc: 对于连接中断的处理操作,用户继承该类并重写该方法来实现
      parameters:
          webSocket  WebSocket  中断的WebSocket
     */

    printError(
        'WebSocket client disconnected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
    ;
  }

  // 处理普通http请求
  void _handleRegularHttpRequest(HttpRequest request) {
    printError("this request is htttp ! WebSocket connections only");
    // 默认提示websocket请求
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('WebSocket connections only')
      ..close();
  }

  // server向client广播消息
  void broadcast(String message) {
    printSuccess("broadcast msg to all client ! msg: ${message}");
    for (var client in _clients) {
      // 返回数据给client客户端
      client.add(message);
    }
  }

  // websocket server停止
  Future<void> stop() async {
    await _server.close();
    printWarn('WebSocket server stopped.');
  }
}
