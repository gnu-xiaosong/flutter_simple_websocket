/*
数据元发送者metadata模型实体,支持自定义拓展字段
 */
// 角色枚举类型
import 'dart:io';

import '../../common/tools.dart';
import 'AttachmentMetaModel.dart.dart';

enum MessageStatus {
  sending, // 正在发送
  sent, // 发送成功，已送达对方
  delivered, // 已送达server端，但未送达对方
  read // 对方已查阅
}

Map<MessageStatus, String> messageStatusToString = {
  MessageStatus.sending: "sending",
  MessageStatus.sent: "sent",
  MessageStatus.delivered: "delivered",
  MessageStatus.read: "read"
};

Map<String, MessageStatus> stringToMessageStatus = {
  "sending": MessageStatus.sending,
  "sent": MessageStatus.sent,
  "delivered": MessageStatus.delivered,
  "read": MessageStatus.read
};

class MetadataModel with CommonTool {
  // 该消息的唯一标识符：系统回自动生成，或者自己实现必须唯一
  String? messageId;
  // 消息状态，例如 sending(正在发送), sent(发送成功，已送达对方), delivered(已送达server端，但未送达对方), read(对方已查阅)
  MessageStatus? status;
  // 自定义插入字段插入位置:不能删掉下行的注释，他作为插入位置
  //@addFiled@//

  // 通过自动代码生成添加字段:在编译之前运行

  // toJson
  Map toJson() {
    Map jsonMap = {
      "messageId": "msg123",
      "status": messageStatusToString[status].toString()
    };
    return jsonMap;
  }
}
