/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'dart:convert';
import 'dart:io';
import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/OtherClientMsgType.dart';
import '../../model/ClientObject.dart';
import '../../schedule/OffLineHandler.dart';
import 'TypeMessageServerHandler.dart';

class AuthTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.AUTH;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 解密info字段
    msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);

    // 客户端client 第一次请求认证服务端server
    auth(request, webSocket, msgDataTypeMap);
    // 广播在线client用户数
    broadcastInlineClients();
  }

  /*
    客户端client 第一次请求认证服务端server
   */
  void auth(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 获取客户端 IP 和端口
    var clientIp = request.connectionInfo?.remoteAddress.address;
    var clientPort = request.connectionInfo?.remotePort;
  }
}
