import 'dart:io';

import 'package:flutter_simple_websocket/flutter_simple_websocket.dart';

void main() {
  // 配置参数
  String? ip = InternetAddress.anyIPv4.address.toString();
  int port = 1314;
  ChatWebsocketServer chatWebsocketServer =
      ChatWebsocketServer(ip: ip, port: port);
  // 启动server
  chatWebsocketServer.bootServer();
}
