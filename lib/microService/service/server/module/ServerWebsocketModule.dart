/*
server 不同消息类型处理模块
 */
import 'package:flutter_simple_websocket/microService/module/manager/GlobalManager.dart';

import '../../../module/encryption/MessageEncrypte.dart';

class ServerWebsocketModule extends MessageEncrypte {
  /*
  获取server在线用户:返回inline client deviceId list
   */
  List<String>? getInlineClient(String deviceId) {}

  /*
   广播在线client用户
   */
  void broadcastInlineClients() {}

  /*
   计算与该服务端连接的client的数量
   */
  Map? getClientsCount() {}

  /*
   server向所有在线client广播消息
   */
  void broadcast(String message) {
    printSuccess("broadcast msg to all client ! msg: ${message}");
    for (var client in GlobalManager.onlineClientList) {
      // 返回数据给client客户端
      client.socket.add(message);
    }
  }
}
