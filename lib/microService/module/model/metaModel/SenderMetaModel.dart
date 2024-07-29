/*
数据元发送者sender模型实体,支持自定义拓展字段
 */
// 角色枚举类型
import 'dart:io';

import '../../common/tools.dart';

enum Role {
  admin, // 管理员
  agent, // 坐席
  moderator, // 版主
  user // 用户
}

Map<Role, String> roleToString = {
  Role.admin: "admin",
  Role.agent: "agent",
  Role.moderator: "moderator",
  Role.user: "user"
};

Map<String, Role> stringToRole = {
  "admin": Role.admin,
  "agent": Role.agent,
  "moderator": Role.moderator,
  "user": Role.user
};

class SenderMetaModel with CommonTool {
  // 唯一标识符
  String? id;
  // 发送者用户名
  String? username;
  // 角色
  Role? role;
  // 头像
  String? avatar;

  // 自定义插入字段插入位置:不能删掉下行的注释，他作为插入位置
  //@addFiled@//

  // 通过自动代码生成添加字段:在编译之前运行

  // toJson
  Map toJson() {
    Map jsonMap = {
      "id": id,
      // 发送者用户名
      "username": username,
      // 角色
      "role": roleToString[role].toString(),
      // 头像
      "avatar": avatar,
      // 自定义插入字段插入位置:不能删掉下行的注释，他作为插入位置
      //@addFiledToJson@//
    };
    return jsonMap;
  }
}

// 如果要增加filed请执行该文件: dart run 该文件
// void main() {
//   // 增加字段
//   addField(name: "test", type: "Datetime");
// }
//
// addField(
//     {required String name, required String type, String? initialValue}) async {
//   // 文件路径
//   String filePath = Directory.current.path +
//       "/lib/microService/module/model/metaModel/SenderMetaModel.dart";
//
//   print("文件: $filePath");
//
//   String? contents;
//   // 检查文件是否存在
//   var file = File(filePath);
//   if (await file.exists()) {
//     // 读取文件内容
//     contents = await file.readAsString();
//     print('文件内容:');
//     print(contents);
//   } else {
//     print('文件不存在: $filePath');
//   }
//
//   // 替换插入对应的filed
//   contents = contents?.replaceAll("//@addFiled@//",
//       '''${type} ${name} ${initialValue != null ? "=${initialValue}" : ""};
//       //@addFiled@//
//       ''');
//
//   // 替换增加toJson
//   contents = contents?.replaceAll("//@addFiledToJson@//", '''
//       "${name}": ${name},
//       //@addFiledToJson@//
//       ''');
//
//   // 写回文件
//   await file.writeAsString(contents!);
//   print('文件更新成功');
// }
