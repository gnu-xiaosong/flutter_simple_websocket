/*
管理websocketServer
 */
import 'dart:io';
import '../model/ErrorModel.dart';
import '../../../module/common/enum.dart';
import 'WebsocketServer.dart';

class WebsocketServerManager extends WebSocketServer {
  WebsocketServerManager._internal();
  static final WebsocketServerManager _instance =
      WebsocketServerManager._internal();
  factory WebsocketServerManager() {
    return _instance;
  }

  // 回调函数: 启动前的初始化工作
  late Function initial;
  // 回调函数: 当server绑定ip:port成功后的回调函数
  late Function whenServerBindAddrSuccess;
  // 回调函数: 当client连接成功时回调
  late Function whenClientConnSuccess;
  // 回调函数: 处理当有client连接中断 参数为中断连接的client信息 this, clientObject
  late Function whenHasClientConnInterrupt;
  // 回调函数: 异常处理，具体错误类型见枚举类型
  late Function whenServerError;
  // 回调函数:消息处理函数
  late Function handlerMessage;

  /*
  配置参数
   */
  setConfig(
      {
      // ip地址
      InternetAddress? ip,
      // port端口
      int? port,
      // 回调函数: 启动前的初始化工作
      Function? initial,
      // 回调函数: 当server绑定ip:port成功后的回调函数
      Function? whenServerBindAddrSuccess,
      // 回调函数: 当client连接成功时回调
      Function? whenClientConnSuccess,
      // 回调函数: 处理当有client连接中断 参数为中断连接的client信息 this, clientObject
      Function? whenHasClientConnInterrupt,
      // 回调函数: 异常处理，具体错误类型见枚举类型
      Function? whenServerError,
      // 回调函数:消息处理函数
      Function? handlerMessage}) {
    // 初始化参数
    super.ip = ip;
    super.port = port!;
    // 回调函数
    this.initial = initial!;
    this.whenServerBindAddrSuccess = whenServerBindAddrSuccess!;
    this.whenClientConnSuccess = whenClientConnSuccess!;
    this.whenHasClientConnInterrupt = whenHasClientConnInterrupt!;
    this.whenServerError = whenServerError!;
    this.handlerMessage = handlerMessage!;
  }

  /*
  当server绑定地址成功后调用
   */
  @override
  Future<void> bindAddrSuccesshandler(WebSocketServer webSocketServer) async {
    super.bindAddrSuccesshandler(webSocketServer);

    this.whenServerBindAddrSuccess(webSocketServer);
  }

  /*
  启动前的初始化操作
   */
  @override
  void bootInitial(WebSocketServer webSocketServer) {
    super.bootInitial(webSocketServer);
    this.initial(webSocketServer);
  }

  /*
  消息处理程序
   */
  @override
  void messageHandler(HttpRequest request, WebSocket webSocket, message) {
    super.messageHandler(request, webSocket, message);

    // 转为map
    Map? msgDataTypeMap = stringToMap(message.toString());
    // 回调
    this.handlerMessage(request, webSocket, msgDataTypeMap);
  }

  /*
  重载server异常
   */
  @override
  void handleServerError(
      Object error, StackTrace stackTrace, ErrorType errorType) {
    // 封装ErrorObject实体
    ErrorObject errorObject = ErrorObject(
        // 错误内容
        content: error.toString(),
        // 类别
        type: errorType);
    // 处理回调处理
    whenServerError(this, errorObject);
    // 调用
    super.handleServerError(error, stackTrace, errorType);
  }

  /*
  重载client中断处理方法
   */
  @override
  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    // 回调函数调用:this   和 断开的clientObject
    whenHasClientConnInterrupt(request, webSocket);
    // 执行父
    super.interruptHandler(request, webSocket);
  }

  /*
  重载当client连接成功时回调
   */
  @override
  handlerClientConnSuccess(HttpRequest request, WebSocket webSocket) {
    super.handlerClientConnSuccess(request, webSocket);

    // 回调函数
    this.whenClientConnSuccess(request, webSocket);

    super.handlerClientConnSuccess(request, webSocket);
  }

  // 启动websocketServer
  void boot() {
    // 启动
    super.start();
  }
}
