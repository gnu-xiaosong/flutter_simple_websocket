/*
websocket client 模块 ：处理有关client websocket有关逻辑
 */
import '../../../module/encryption/MessageEncrypte.dart';

class ClientWebsocketModule extends MessageEncrypte {
  /*
   client与server中断处理策略
   */
  void interruptRetryStrategy() {
    // Your retry strategy logic here
  }
}
