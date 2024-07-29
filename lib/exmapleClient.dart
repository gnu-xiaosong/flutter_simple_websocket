import 'dart:convert';
import 'package:flutter_simple_websocket/flutter_simple_websocket.dart';

void main() {
  // 配置参数
  String ip = "192.168.1.5";
  int port = 1314;

  ChatWebsocketClient chatWebsocketClient =
      ChatWebsocketClient(ip: ip, port: port);
  // 连接server
  chatWebsocketClient.connServer();

  // 先进行身份认证
  // 获取用户输入
  // String? text = stdin.readLineSync();
  // 封装消息
  String? plait_text = "vsdvsbvsavsdvdxbdbdxbfdbsbvdfbd";
  String key = "this is auth key for encode";
  Map msg = {
    "type": "AUTH",
    "deviceId": "123456789",
    "info": {
      "plait_text": plait_text,
      "key": key,
      "encrypte": chatWebsocketClient.generateMd5Secret(key + plait_text)
    }
  };

  // 发送消息
  chatWebsocketClient.websocketClientManager.sendText(jsonEncode(msg));
/*
  // 循环获取输入: MESSAGE测试
  // print("请输入消息:");
  // 获取用户输入
  String? text = "vdvdvdvdv";
  // 封装消息实体模型
  CommunicationModel communicationModel = CommunicationModel(
      type: MsgType.MESSAGE,
      info: MessageInfoModel(
        msgType: "text",
        content: ContentMetaModel(text: text),
        // sender: SenderMetaModel(),
        // recipient: RecipientMetaModel(),
      ));
  // 发送消息
  msg = communicationModel.toJson();
  print("发送消息: $msg");
  chatWebsocketClient.websocketClientManager
      .sendText(jsonEncode(communicationModel.toJson()));

      *
   */
}
