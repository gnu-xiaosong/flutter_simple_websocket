import 'dart:io';
import 'package:flutter_simple_websocket/example.dart';

void main() {
  // test('test websocket server boot', () {
  // 实例化一个类
  ChatWebsocketManager chatWebsocketManager =
      ChatWebsocketManager.getInstance();

  // 启动方法
  InternetAddress ip = InternetAddress("127.0.0.1");
  int port = 1314;

  chatWebsocketManager.bootServer(ip: ip, port: port);
}
