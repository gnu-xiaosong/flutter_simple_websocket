/*
消息MESSAGE类模型 继承至CommunicationModel类
 */

import 'package:flutter_simple_websocket/microService/module/model/metaModel/ContentMetaModel.dart.dart';
import 'package:flutter_simple_websocket/microService/module/model/metaModel/MetadataModel.dart';
import 'package:flutter_simple_websocket/microService/module/model/metaModel/RecipientMetaModel.dart';
import 'package:flutter_simple_websocket/microService/module/model/metaModel/SenderMetaModel.dart';

class MessageInfoModel {
  // 消息类型
  String? msgType;
  // 发送者
  SenderMetaModel? sender;
  // 接受者
  RecipientMetaModel? recipient;
  // 内容
  ContentMetaModel? content;
  // 创建时间
  DateTime timestamp = DateTime.now();
  // 消息元
  MetadataModel? metadata;

  MessageInfoModel(
      {String this.msgType = "text",
      this.sender,
      this.recipient,
      this.content,
      this.metadata});

  toJson() {
    Map message = {
      "msgType": msgType, // 消息类型: text,file,link......
      "sender": sender?.toJson(),
      "recipient": recipient?.toJson(),
      "content": content?.toJson(),
      "timestamp": timestamp, // 发送时间： string 时间格式
      "metadata": metadata?.toJson()
    };

    return message;
  }
}
