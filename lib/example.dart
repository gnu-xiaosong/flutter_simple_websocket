/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 聊天websocket管理器类
 */
import 'dart:io';
import 'package:flutter_simple_websocket/microService/module/encryption/MessageEncrypte.dart';
import 'microService/service/client/websocket/WebsocketClientManager.dart';
import 'microService/service/server/model/ClientObject.dart';
import 'microService/service/server/model/ErrorObject.dart';
import 'microService/service/server/websocket/WebsocketServerManager.dart';
import 'microService/module/common/Console.dart';
import 'microService/module/common/tools.dart';

class ChatWebsocketManager extends MessageEncrypte with Console, CommonTool {
  // websocket client instance
  WebsocketClientManager websocketClientManager = WebsocketClientManager();
  // websocket server instance
  WebsocketServerManager websocketServerManager = WebsocketServerManager();
  // 静态属性，存储唯一实例
  static ChatWebsocketManager? _instance;

  // 私有的命名构造函数，确保外部不能实例化该类
  ChatWebsocketManager._internal() {
    // 初始化逻辑
    // printInfo("-------chatWebsocket instance-----");
  }

  // 提供一个静态方法来获取实例
  static ChatWebsocketManager getInstance() {
    _instance ??= ChatWebsocketManager._internal();
    return _instance!;
  }

  /*
    启动websocket服务
   */
  void bootServer({required InternetAddress ip, required int port}) async {
    // 启动server
    websocketServerManager.setConfig(
        ip: ip,
        port: port,
        whenHasClientConnInterrupt:
            (WebsocketServerManager websocketServerManager,
                ClientObject clientObject) {
          // websocketServerManager  WebsocketServerManager对象
          // clientObject 中断的ClientObject对象
          printError("whenHasClientConnInterrupt: ${clientObject}");
        },
        whenServerError: (WebsocketServerManager websocketServerManager,
            ErrorObject errorObject) {
          // websocketServerManager  WebsocketServerManager对象
          // errorObject 错误异常ErrorObject对象
          printError("whenServerError: ${errorObject}");
        });
    // 启动server
    websocketServerManager.boot();
    // 将是否是server的结果发送回主线程
    printSuccess("启动server成功!");
  }

  /*
  启动client服务websocket
   */
  connServer({required String ip, required int port}) {
    // 启动client
    websocketClientManager.setConfig(
        ip: ip,
        port: port,
        whenConnInterrupt: (WebsocketClientManager websocketClientManager) {
          //  当client与server连接中断时调用
          printError("whenConnInterrupt: ${websocketClientManager}");
        },
        whenClientError: (ErrorObject errorObject) {
          // errorObject 错误异常ErrorObject对象,聚体枚举参数见ErrorObject类
          printError("whenClientError: ${errorObject}");
        });
    // 连接
    try {
      websocketClientManager.conn();
      // 将是否是server的结果发送回主线程
      printSuccess("启动client成功!");
    } catch (e) {
      printCatch("启动client失败!more detail:$e");
    }
  }
}
