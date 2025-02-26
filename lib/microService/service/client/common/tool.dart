import 'dart:io';

import '../../../module/manager/GlobalManager.dart';
import '../../server/model/ClientModel.dart';

mixin ClientTool {
  //*********************以下方法都是获取在线的clientObject对象**************************
  // 根据deviceId设备ID获取对应于的clientObject对象
  ClientModel? getClientObjectByDeviceId(String deviceId) {
    // 遍历list
    for (ClientModel clientObject in GlobalManager.onlineClientList) {
      // print(clientObject.deviceId);
      if (clientObject.deviceId == deviceId) return clientObject;
    }
    return null;
  }

  /*
  由HttpRequest request, WebSocket webSocket 获取ClientObject对象
   */
  ClientModel getClientObject(HttpRequest request, WebSocket webSocket) {
    late ClientModel clientObject;
    for (ClientModel clientObject_item in GlobalManager.onlineClientList) {
      // 根据ip地址匹配查找
      if (clientObject_item.ip ==
              request.connectionInfo?.remoteAddress.address ||
          clientObject_item.socket == webSocket) {
        // 匹配成功
        clientObject = clientObject_item;
      }
    }

    return clientObject;
  }
}
