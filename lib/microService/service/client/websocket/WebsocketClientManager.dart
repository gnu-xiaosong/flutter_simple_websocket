library flutter_simple_websocket;

/*
管理websocketServer
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../module/common/enum.dart';
import '../../server/model/ErrorObject.dart';
import 'ChatWebsocketClient.dart';

class WebsocketClientManager extends ChatWebsocketClient {
  WebsocketClientManager._internal();
  static final WebsocketClientManager _instance =
      WebsocketClientManager._internal();
  // 回调函数: 处理当连接中断 参数为中断连接的client信息 this = WebsocketClientManager
  late Function whenConnInterrupt;
  // 回调函数：server异常
  late Function whenClientError;

  // 初始化 操作
  void initialize() {}
  // Factory constructor
  factory WebsocketClientManager() {
    return _instance;
  }

  /*
  配置参数
   */
  setConfig(
      {
      // ip地址
      String? ip,
      // port端口
      int? port,
      // 回调函数: 处理当连接中断 参数为中断连接的client信息
      Function? whenConnInterrupt,
      // 回调函数: 处理当客户端异常
      Function? whenClientError}) {
    // 初始化参数
    super.ip = ip;
    super.port = port!;
    // 设置回调
    this.whenConnInterrupt = whenConnInterrupt!;
    this.whenClientError = whenClientError!;
  }

  /*
  重载server异常
   */
  @override
  void handlerClientError(ErrorObject errorObject) {
    // 调用回调
    whenClientError(errorObject);
    // 调用父
    super.handlerClientError(errorObject);
  }

  /*
  重载中断异常处理
   */
  @override
  void interruptHandler(WebSocketChannel channel) {
    // 处理
    whenConnInterrupt(this);
    // 父亲
    super.interruptHandler(channel);
  }

  /*
  发送文本消息
  text: 文本内容  json的info字段已加密
   */
  sendText(String text) {
    try {
      send(text);
      return true;
    } catch (e) {
      // 封装错误体
      ErrorObject errorObject =
          ErrorObject(type: ErrorType.clientSendText, content: e.toString());
      // 调用回调
      whenClientError(errorObject);
      print("发送消息失败：$e");
      return false;
    }
  }

  // 启动websocketClient 连接
  void conn() {
    // 启动
    super.connnect();
  }
}
