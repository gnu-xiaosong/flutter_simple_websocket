/*
  消息加密和解密算法
 */

import 'dart:io';
import '../../service/client/common/tool.dart';
import '../../service/server/common/tool.dart';
import '../../service/server/model/ClientModel.dart';
import '../common/Console.dart';
import '../common/tools.dart';
import 'TextEncryption.dart';

class MessageEncrypte with Console, CommonTool, ClientTool, ServerTool {
  // auth 加解密key
  String auth_key = "5eb63bbbe01eeed093cb22bb8f5acdc3";
  int shift = 3; //移位
  //**********************************消息文本加解密******************************************************

  /*
   为map的每一个键值进行加密
   */
  Map encodeMessage(ClientModel clientObject, Map<String, dynamic> data_map) {
    return data_map;
    // 加密
    // TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    // Map endata_map =
    //     textEncryptionForJson.encryptJson(data_map, shift, key_secret);
    //
    // return endata_map;
  }

  /*
   为map的每一个键值进行解密
   */
  Map? decodeMessage(ClientModel clientObject, Map<String, dynamic> data_map) {
    return data_map;
    // 加密
    // TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    // Map endata_map =
    //     textEncryptionForJson.decryptJson(data_map, shift, key_secret);
    //
    // return endata_map;
  }

  // 认证消息加密算法
  Map encodeAuth(Map<String, dynamic> data_map) {
    // 加密
    TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    Map endata_map =
        textEncryptionForJson.encryptJson(data_map, shift, auth_key);

    return endata_map;

    // // return data_map;
    // data_map.forEach((key, value) {
    //   data_map[key] = TextEncryption()
    //       .encrypt(value.toString(), shift, auth_key.toString());
    // });
    //
    // return data_map;
  }

  // 认证消息解密算法
  Map decodeAuth(Map<String, dynamic> data_map) {
    TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    Map endata_map =
        textEncryptionForJson.decryptJson(data_map, shift, auth_key);

    return endata_map;

    // data_map.forEach((key, value) {
    //   String text = TextEncryption()
    //       .decrypt(value.toString(), shift, auth_key.toString());
    //   data_map[key] = text;
    // });
    // return data_map;
  }

  //*****************************************************************************************
  /*
   client客户端有效性认证认证
   */
  Map clientInitAuth(Map data_) {
    bool result = false;
    String msg = "AUTH: 该client客户端认证成功!";

    try {
      String? key = data_["info"]["key"];
      String? plainText = data_["info"]["plait_text"];
      String? encrypte = data_["info"]["encrypte"];

      if (key == null || plainText == null || encrypte == null) {
        print("缺失info的关键字段: key or plait_text or encrypte");
      }

      String computedHash = generateMd5Secret(key! + plainText!);

      if (computedHash == encrypte) {
        result = true;
      } else {
        msg = "AUTH: 认证失败，秘钥不匹配";
      }
    } catch (e) {
      msg = "AUTH: 认证失败，$e";
    }

    return {"result": result, "msg": msg};
  }

  /*
  确保该客户端client已进行AUTH认证通过
  客户端client通信秘钥认证：判断该请请求信息是否已认证过，比较ip和port
   */
  Map clientAuth(String deviceId, HttpRequest request, WebSocket webSocket) {
    // deviceId和ip+port验证
    ClientModel? clientObject = getClientObjectByDeviceId(deviceId);
    String tip;
    bool result;
    if (request.connectionInfo?.remoteAddress.address.toString() ==
            clientObject?.ip &&
        request.connectionInfo?.remotePort.toInt() == clientObject?.port) {
      // 检查该client是否在线
      if (clientObject?.status == 3) {
        tip =
            "This client device is banned! status code=${clientObject?.status}";
        result = true;
      } else {
        tip = "This client is pass for check";
        result = true;
      }
    } else {
      // 程序异常：该client不在线
      tip = "this client device is not online";
      result = false;
    }

    return {"result": result, "tip": tip};
  }

  String? encrypte(String data) {
    // String randomString32 = generateRandomKey();
    //
    // // 加上本机特征
    // String data_ = (AppConfig.ip.toString() +
    //     data +
    //     randomString32.toString() +
    //     AppConfig.port.toString());
    // // 计算 MD5 哈希值
    // String md5Hash = md5.convert(utf8.encode(data_)).toString();
    //
    // return md5Hash;
  }
}
