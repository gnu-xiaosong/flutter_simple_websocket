# flutter_simple_websocket
This is a simplified and easy to use websocket communication version, suitable for many business scenarios, only a few lines of code can set up their own websocket server and client side, easy to embed in their own projects, automatic code generation of core classes.

# 类关系图



# 模块

### Server模块

#### 新增自动处理其他类型消息

> 提示：每次在other目录下编写自定义消息类后，都要执行命令以进行自动代码生成

1. 在目录`/lib/microService/service/server/websocket/messageByTypeHandler`下编写server端消息类型处理类

   注意：文件名要与类型一致

2. 类必选函数和参数

   | 必选                                                         | 类型     | 类别 |                                                              |
      | ------------------------------------------------------------ | -------- | ---- | ------------------------------------------------------------ |
   | type                                                         | MsgType  | 属性 | 枚举类型， 具体见OtherMsgType.dart    自定义消息类别 当客户端采用如下格式传输消息文本时，type类型名要与上面生成的枚举名一样 |
   | void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) | function | 方法 | 处理消息接收处理逻辑：接受参数msgDataTypeMap, clientObject   |

   属性: String type

   方法：

   ```dart
   void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
     //
   }
   ```

   完整：

   ```dart
   /*
   websocket  server与client通讯 自定义消息处理类: TEST消息类型
    */
   import 'package:app_template/microService/service/server/websocket/other/TypeMessageClientHandler.dart';
   
   class TestTypeWebsocketCommunication extends TypeWebsocketCommunication {
     String type = "TEST";
     void handler(msgDataTypeMap, clientObject) {
       //
     }
   }
   ```

   其中**TestTypeMessageServerHandler**为实例文件类，按照该模版编写即可

3. 运行该命令生成代码：切换到项目根目录下

   `dart run .\bin\genOtherServerMsgTypeClass.dart`

**消息类型与文件命名规则说明**：

每一个文件名命名规则为: `驼峰命名消息类型 + TypeMessageHandler`

代执行带生成的时候将会将`TypeMessageHandler`删除，留下剩余部分然后会按照如下规则生成消息枚举常量：

- 单驼峰：直接转变为大写形成枚举

- 多驼峰: 每个驼峰之间增加`_`, 然后再转为大写字母

例子：

- 单驼峰: `TestTypeMessageHandler` --> `Test` -->`TEST`
- 多驼峰: `RequestInlineClientTypeMessageHandler`--> `RequestInlineClient` --> `Request_Inline_Client` -->`REQUEST_INLINE_CLIENT`

提示： 当客户端采用如下格式传输消息文本时，type类型名要与上面生成的枚举名一样

```json
{
   "type": "REQUEST_INLINE_CLIENT", //必选字段,字母不区分大小写，Test = TEST = TeST
   .....  其他可选字段
}
```

> **注意：** 对于具体的加解密算法没有提供，因为取决于client端加密的算法，如果client默认采用的本程序提供的普通消息加解密算法，可以直接调用基类TypeWebsocketCommunication中的enSecretMessage()和deSecretMessage()方法进行加解密，否则只能自己实现加解密算法。

#### 关键核心代码 WebsocketServerManager类使用

```dart
// websocket client instance
WebsocketClientManager websocketClientManager = WebsocketClientManager();


// 启动server
websocketServerManager.setConfig(
    ip: AppConfig.ip,
    port: AppConfig.port,
    whenHasClientConnInterrupt:
    (WebsocketServerManager websocketServerManager,
     ClientObject clientObject) {
        // websocketServerManager  WebsocketServerManager对象
        // clientObject 中断的ClientObject对象
        printError("whenHasClientConnInterrupt: ${clientObject}");
    },
    whenServerError: (WebsocketServerManager websocketServerManager,
                      ErrorObject errorObject) {
        // websocketServerManager  WebsocketServerManager对象
        // errorObject 错误异常ErrorObject对象
        printError("whenServerError: ${errorObject}");
    });
// 启动server
websocketServerManager.boot();
```



### Client模块

#### 新增自动处理其他类型消息

> 提示：每次在other目录下编写自定义消息类后，都要执行命令以进行自动代码生成

1. 在目录`/lib/microService/service/client/websocket/other`下编写server端消息类型处理类

   注意：文件名要与类型一致

2. 类必选函数和参数

   | 必选                                                        | 类型            | 类别 |                                                              |
      | ----------------------------------------------------------- | --------------- | ---- | ------------------------------------------------------------ |
   | type                                                        | MsgType枚举类型 | 属性 | 自定义消息类别， 当客户端采用如下格式传输消息文本时，type类型名要与上面生成的枚举名一样 |
   | void handler(WebSocketChannel? channel, Map msgDataTypeMap) | function        | 方法 | 处理消息接收处理逻辑：接受参数msgDataTypeMap                 |

   属性: String type

   方法：

   ```dart
     void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
       // 解密info字段
       msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);
       //处理逻辑
       auth(channel, msgDataTypeMap);
     }
   ```

   完整：

   ```dart
   /*
   websocket  server与client通讯 自定义消息处理类: TEST消息类型
    */
   class TestTypeMessageHandler extends TypeMessageClientHandler {
     MsgType type = MsgType.TEST;
     void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
       //处理逻辑
     }
   }
   ```

   其中**TestTypeMessageHandler**为实例文件类，按照该模版编写即可

3. 运行该命令生成代码：切换到项目根目录下

   `dart run .\bin\genOtherClientMsgTypeClass.dart`

提示： 与server类似使用

> **注意：** 对于具体的加解密算法没有提供，因为取决于client端加密的算法，如果client默认采用的本程序提供的普通消息加解密算法，可以直接调用基类TypeWebsocketCommunication中的enSecretMessage()和deSecretMessage()方法进行加解密，否则只能自己实现加解密算法

#### 关键核心类WebsocketClientManager

```dart
// websocket client instance
WebsocketClientManager websocketClientManager = WebsocketClientManager();

// 启动client
websocketClientManager.setConfig(
ip: ip,
port: AppConfig.port,
whenConnInterrupt: (WebsocketClientManager websocketClientManager) {
//  websocketClientManager  WebsocketClientManager对象
printError("whenConnInterrupt: ${websocketClientManager}");
},
whenClientError: (ErrorObject errorObject) {
// errorObject 错误异常ErrorObject对象,聚体枚举参数见ErrorObject类
printError("whenClientError: ${errorObject}");
});
// 连接
websocketClientManager.conn();
```

