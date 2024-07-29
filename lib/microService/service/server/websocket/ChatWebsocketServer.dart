/*
基于WebsocketServerManager的chat聊天实现
 */
import 'dart:io';

import 'package:flutter_simple_websocket/microService/service/server/module/ServerWebsocketModule.dart';

import '../../../module/manager/GlobalManager.dart';
import '../common/CommunicationTypeServerModulator.dart';
import '../model/ClientModel.dart';
import '../model/ErrorModel.dart';
import 'WebsocketServer.dart';
import 'WebsocketServerManager.dart';

class ChatWebsocketServer extends ServerWebsocketModule {
  // 实例化WebsocketServerManager
  WebsocketServerManager websocketServerManager = WebsocketServerManager();
  CommunicationTypeServerModulator communicationTypeServerModulator =
      CommunicationTypeServerModulator();
  ChatWebsocketServer({String ip = '127.0.0.1', int port = 1314}) {
    // 调用配置参数函数
    websocketServerManager.setConfig(
        // server绑定ip地址
        ip: InternetAddress(ip),
        // server绑定端口port
        port: port,
        //******配置周期性回调函数***********
        // 1.启动前的初始化操作
        initial: initial,
        // 2.当server绑定地址成功后调用
        whenServerBindAddrSuccess: whenServerBindAddrSuccess,
        // 3.当client连接成功时调用
        whenClientConnSuccess: whenClientConnSuccess,
        // 4.当存在client断开与server连接时调用
        whenHasClientConnInterrupt: whenHasClientConnInterrupt,
        // 5.当出现异常或错误时调用：错误类型见ErrorType枚举类型
        whenServerError: whenServerError,
        // 消息处理调用
        handlerMessage: handlerMessage);
  }

  //******配置周期性回调函数***********
  /*
  1.启动前的初始化操作
   */
  initial(WebSocketServer webSocketServer) {
    print("initial handler");
  }

  /*
   2.当server绑定地址成功后调用
   */
  whenServerBindAddrSuccess(WebSocketServer webSocketServer) {
    print("bind addr is successful to handler");
  }

  /*
   3.当client连接成功时调用
   */
  whenClientConnSuccess(HttpRequest request, WebSocket webSocket) {
    print("client connect is successful ");
    // 添加进全局变量中
    /// 1.封装clientObject对象
    ClientModel clientObject = ClientModel(
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
  }

  /*
   4.当存在client断开与server连接时调用
   */
  whenHasClientConnInterrupt(HttpRequest request, WebSocket webSocket) {
    //****************连接中断处理逻辑**************
    // 客户端信息
    String? ip = request.connectionInfo?.remoteAddress.address.toString();
    int? port = request.connectionInfo?.remotePort.toInt();
    GlobalManager.onlineClientList.removeWhere((clientObject) =>
        clientObject.socket == webSocket ||
        (clientObject.ip == ip && clientObject.port == port)); //在线连接
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
  }

  /*
   5.当出现异常或错误时调用：错误类型见ErrorType枚举类型
   */
  whenServerError(WebSocketServer webSocketServer, ErrorObject errorObject) {
    print("exist server error ");
  }

  /*
   消息处理调用
   */
  handlerMessage(HttpRequest request, WebSocket webSocket, Map message) {
    print("+message handler");

    // 第一层处理:调用调制器函数处理事先定义好的不同类型消息处理类
    communicationTypeServerModulator.handler(request, webSocket, message);

    // 第二层处理
  }

  /*
  启动server
   */
  bootServer() {
    print("start boot server service.....");
    websocketServerManager.boot();
  }
}
