/*
数据元发送者content模型实体,支持自定义拓展字段
 */
// 角色枚举类型
import 'dart:io';

import '../../common/tools.dart';
import 'AttachmentMetaModel.dart.dart';

class ContentMetaModel with CommonTool {
  // 文本
  String? text;
  // 附件
  List? attachments;
  // 自定义插入字段插入位置:不能删掉下行的注释，他作为插入位置
  //@addFiled@//

  // 通过自动代码生成添加字段:在编译之前运行

  ContentMetaModel({this.text, this.attachments});
  // toJson
  Map toJson() {
    Map jsonMap = {
      "text": text,
      "attachments": attachments as List
      // 自定义插入字段插入位置:不能删掉下行的注释，他作为插入位置
      //@addFiledToJson@//
    };
    return jsonMap;
  }
}
