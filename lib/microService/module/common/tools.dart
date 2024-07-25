/*
工具函数
 */
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';

mixin CommonTool {
  Map? stringToMap(String data) {
    // print("------json decode for string to map--------");
    // print("待转string: $data");
    try {
      // 检查输入字符串是否是有效的JSON格式
      if (data != null && data.isNotEmpty) {
        // 使用json.decode将JSON字符串解析为Map
        Map re = json.decode(data);
        // print("转换map: $re");
        return re;
      } else {
        print("Input data is empty or null");
      }
    } catch (e) {
      // 处理解析错误，输出错误信息并返回一个空的Map
      print('Error parsing JSON: $e');
      return {};
    }
  }

  //auth认证加密算法认证:md5算法
  String generateMd5Secret(String data) {
    var bytes = utf8.encode(data); // data being hashed
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  // 生成32字符长度的随机字符串作为密钥
  String generateRandomKey() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// 尝试将字符串转换为InternetAddress对象
  ///
  /// @param ipAddress 要转换的IP地址字符串
  /// @return 返回转换后的InternetAddress对象，如果转换失败则返回null
  InternetAddress? tryConvertToInternetAddress(String ipAddress) {
    try {
      return InternetAddress(ipAddress);
    } on FormatException {
      // 打印错误信息，也可以选择抛出异常或者返回特定的错误信息
      print('转换失败: 无效的IP地址格式');
      return null;
    }
  }

  /*
  获取调试位置
   */
  getPosition(int line) {
    List p = [];
    // 获取当前脚本的路径
    final scriptUri = Platform.script;

    // 转换为文件路径
    final scriptPath = scriptUri.toFilePath();

    // 获取文件名
    final scriptFileName = scriptUri.pathSegments.last;

    p.add(scriptPath.toString());
    p.add(scriptFileName.toString());
    p.add(line.toString());

    return p;
  }
}
