/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 全局管理器工具类
 */
import 'dart:async';
import '../../service/server/model/ClientObject.dart';
import '../../service/server/module/MessageQueue.dart';
import '../../service/server/module/OffLineMessageQueue.dart';
import '../../service/server/schedule/UserSchedule.dart';

class GlobalManager {
  /***************↓↓↓↓↓↓全局参数变量初始化操作↓↓↓↓↓↓↓******************/
  // 1.全局存储在线的websocket client客户端
  static List<ClientObject> onlineClientList = [];

  // 2.全局存储启动期间连接过的client客户端: 包括断线离线的
  static List<ClientObject> allConnectedClientList = [];

  // 3.全局离线消息队列初始初
  static OffLineMessageQueue offLineMessageQueue = OffLineMessageQueue();

  // 4.设置全局客户端等待好友同意消息队列
  static MessageQueue clientWaitUserAgreeQueue = MessageQueue();

  // 5.全局add user消息队列
  static MessageQueue offerUserAddQueue = MessageQueue();

  // 6. 全局监听广播流机制变量
  static final StreamController<dynamic> globalStreamController =
      StreamController<dynamic>.broadcast(); // 创建一个广播流控制
  static Stream<dynamic> get globalStream =>
      globalStreamController.stream; // 获取广播流

  // 3.单例化User schedule
  final UserSchedule _userSchedule =
      UserSchedule.getInstance(); //实例化chat websocket
  UserSchedule get GlobalUserSchedule => _userSchedule;

  /*
  初始化全局信息，会在APP启动时执行
   */
  static Future init() async {}
}
