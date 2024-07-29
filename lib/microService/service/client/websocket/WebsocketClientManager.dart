library flutter_simple_websocket;

/*
管理websocketServer
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../module/common/enum.dart';
import '../../server/model/ErrorModel.dart';
import 'WebsocketClient.dart';

class WebsocketClientManager extends WebsocketClient {
  WebsocketClientManager._internal();
  static final WebsocketClientManager _instance =
      WebsocketClientManager._internal();
  // 回调函数: 处理当连接中断 参数为中断连接的client信息 this = WebsocketClientManager
  late Function? whenConnInterrupt;
  // 回调函数：server异常
  late Function? whenClientError;
  // 回调函数: 连接前的初始化操作
  late Function? initialBeforeConnHandler;
  // 回调函数：当与server端连接成功时
  late Function? whenConnSuccessWithServer;
  // 回调函数：消息监听处理
  late Function? messageHandler;

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
      // 协议
      String type = "ws",
      // 回调函数: 连接前的初始化操作
      required Function initialBeforeConn,
      // 回调函数: 处理当连接中断 参数为中断连接的client信息
      required Function whenConnInterrupt,
      // 回调函数：当与·server端连接成功时
      required Function? whenConnSuccessWithServer,
      //回调函数：消息监听处理
      required Function messageHandler,
      // 回调函数: 处理当客户端异常
      required Function whenClientError}) {
    // 初始化参数
    super.ip = ip;
    super.port = port!;
    super.type = type;
    // 设置回调
    this.initialBeforeConnHandler = initialBeforeConn;
    this.whenConnSuccessWithServer = whenConnSuccessWithServer;
    this.whenConnInterrupt = whenConnInterrupt;
    this.whenClientError = whenClientError;
    this.messageHandler = messageHandler;
  }

  /*
  回调函数: 连接前的初始化操作
   */
  @override
  void initialBeforeConn(WebsocketClient websocketClient) {
    super.initialBeforeConn(websocketClient);
    // 执行回调函数
    initialBeforeConnHandler!(websocketClient);
  }

  /*
  与server连接成功时
   */
  @override
  void conn_success(WebSocketChannel? channel) async {
    super.conn_success(channel);
    // 执行回调函数
    this.whenConnSuccessWithServer!(this);
  }

  /*
  监听回调消息处理函数
   */
  @override
  void listenMessageHandler(WebSocketChannel webSocketChannel, String message) {
    super.listenMessageHandler(webSocketChannel, message);
    // 转为mapJson
    Map? messageMap = stringToMap(message);

    this.messageHandler!(webSocketChannel, messageMap);
  }

  /*
  重载server异常
   */
  @override
  void handlerClientError(ErrorObject errorObject) {
    // 调用回调
    whenClientError!(errorObject);
    // 调用父
    super.handlerClientError(errorObject);
  }

  /*
  重载中断异常处理
   */
  @override
  void interruptHandler(WebSocketChannel channel) {
    // 处理
    whenConnInterrupt!(this);
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
      whenClientError!(errorObject);
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
