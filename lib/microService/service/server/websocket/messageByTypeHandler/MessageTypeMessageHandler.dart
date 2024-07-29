/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'dart:convert';
import 'dart:io';

import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/CommunicationTypeClientModulator.dart';
import '../../model/ClientModel.dart';
import 'TypeMessageServerHandler.dart';

class MessageTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.MESSAGE;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 获取ClientObject
    ClientModel clientObject = getClientObject(request, webSocket);

    // 获取秘钥通讯加解密key
    String secret = clientObject.secret.toString();

    // 解密info字段
    msgDataTypeMap["info"] = deSecretMessage(secret, msgDataTypeMap["info"]);

    // 调用
    message(request, webSocket, msgDataTypeMap);
  }

  /*
    消息类型
   */
  void message(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    print("type: MESSAGE");
    print("receive msg: ${msgDataTypeMap}");
    // 1.客户端验证检查: deviceId为发送者的设备id，认证该client是否存在于全局在线list ClientObject中
    Map clientCheck =
        clientAuth(msgDataTypeMap["info"]["sender"]["id"], request, webSocket);

    if (clientCheck["result"]) {
      // 2.如果认证成功，将该消息添加进client的消息队列中
      print("ip: ${request.connectionInfo?.remoteAddress.address}");
      print("length:${GlobalManager.onlineClientList.length}");
      GlobalManager.onlineClientList =
          GlobalManager.onlineClientList.map((websocketClientObj) {
        // print("weboscket: ${websocketClientObj.ip}");
        if (websocketClientObj.socket == webSocket ||
            request.connectionInfo?.remoteAddress.address ==
                websocketClientObj.ip) {
          printInfo("----------------中断处理：找到了目标websocket----------------");
          // 算法加密
          msgDataTypeMap["info"] =
              encodeMessage(websocketClientObj, msgDataTypeMap["info"]);
          //添加新消息进入消息队列中
          websocketClientObj.messageQueue.enqueue(msgDataTypeMap);
          // 返回
          return websocketClientObj;
        } else {
          // 返回原来的
          return websocketClientObj;
        }
      }).toList();
    } else {
      // 3.1 客户端client检查失败返回数据相应给客户端
      Map re = {
        "type": "AUTH",
        "info": {"code": 400, "msg": clientCheck["result"]}
      };
      // 加密消息:采用auth加密
      re["info"] = encodeAuth(re["info"]);

      print(">> send:$re");
      // 发送消息
      webSocket.add(json.encode(re));
      // 主动关闭连接
      webSocket.close();
    }
  }
}
