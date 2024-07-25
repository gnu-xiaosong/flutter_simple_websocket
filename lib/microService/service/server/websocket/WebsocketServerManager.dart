/*
管理websocketServer
 */
import 'dart:io';
import 'package:flutter_simple_websocket/microService/module/manager/GlobalManager.dart';

import '../model/ClientObject.dart';
import '../model/ErrorObject.dart';
import 'ChatWebsocketServer.dart';
import '../../../module/common/enum.dart';

class WebsocketServerManager extends ChatWebsocketServer {
  WebsocketServerManager._internal();
  static final WebsocketServerManager _instance =
      WebsocketServerManager._internal();
  factory WebsocketServerManager() {
    return _instance;
  }

  // 回调函数: 处理当连接中断 参数为中断连接的client信息 this, clientObject
  late Function whenHasClientConnInterrupt;
  // 回调函数：server异常
  late Function whenServerError;

  /*
  配置参数
   */
  setConfig(
      {
      // ip地址
      InternetAddress? ip,
      // port端口
      int? port,
      // 回调函数: 处理当连接中断 参数为中断连接的client信息
      Function? whenHasClientConnInterrupt,
      // 回调函数：server异常
      Function? whenServerError}) {
    // 初始化参数
    super.ip = ip;
    super.port = port!;
    this.whenHasClientConnInterrupt = whenHasClientConnInterrupt!;
    this.whenServerError = whenServerError!;
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
  重载中断处理方法
   */
  @override
  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    // 客户端信息
    var ip = request.connectionInfo?.remoteAddress.address;
    var port = request.connectionInfo?.remotePort;
    late ClientObject clientObject;
    // 更改全局 list 中 websocketClientObj 的状态，并移除具有相同 IP 的对象
    GlobalManager.onlineClientList.forEach((clientObjectItem) {
      if (clientObjectItem.ip == ip && clientObjectItem.port == port) {
        clientObject = clientObjectItem;
      }
    });
    // 回调函数调用:this   和 断开的clientObject
    whenHasClientConnInterrupt(this, clientObject);
    // 执行父
    super.interruptHandler(request, webSocket);
  }

  // 初始化 操作
  void initialize() {}

  // 启动websocketServer
  void boot() {
    // 启动
    super.start();
  }
}
