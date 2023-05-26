# protobuf

## 介绍

ProtoBuf(protocol buffers) 是一种语言无关、平台无关、可扩展的序列化结构数据的方法，它可用于（数据）通信协议、数据存储等。,是一种灵活，高效，自动化机制的结构数据序列化方法比XML更小,更快,更为简单。

本项目主要是OpenHarmony系统下以[protobufjs 5.0.3](https://github.com/protobufjs/protobuf.js)为主要依赖开发，主要接口针对OpenHarmony系统进行合理的适配研发。

## 下载安装

1.安装

```
ohpm install protobufjs@^1.3.0
```

2.在需要使用的页面导入protobufjs

```
import  protobuf  from 'protobufjs'
```

## 使用说明

1.  在resources->rawfile下按照proto格式定义basic.proto文件

```
message Test1 {
    required int32 a = 1;
}
```

2.读取protofile

```
 let builder = await Protobuf.loadProtoFile("basic.proto", null, null, getContext(this).resourceManager)
```


3.对象编码

```
let JS = builder.build("js.ResultResponse");
console.info(this.TAG, " builder:" + JS)

let json = {
  result: [{
    url: "1111",
    title: "title1111",
    spinner: ["arr11", "arr12"]
  }, {
    url: "2222",
    title: "title2222",
    spinner: ["arr21", "arr22"]
  }]
}

console.info(this.TAG, "origin json = " + JSON.stringify(json))

let encode = JS.encode(json)
console.info(this.TAG, "encode = " + encode.toBuffer())
```

4.对象解码

```
let decode = JS.decode(encode)

console.info(this.TAG, "decode = " + JSON.stringify(decode))
```

## 接口说明

1， public static newBuilder(): any 

Constructs a new empty Builder.

2， .loadProtoFile(path, (err, root) => {}

异步解析proto文件的方式

3.loadJson(json, builder, fileName);

异步解析json字符串方式

4，loadJsonFile(path, (err, root) => {}
异步解析json文件的方式

5，.encode; 　　

编码

6，.decode(); 

解码

## 约束与限制
在下述版本验证通过：

DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## 目录结构

```javascript
|---- protobuf
|     |---- AppScrope  # 示例代码文件夹
|     |---- entry  # 示例代码文件夹
|     |---- screenshots #截图
|     |---- protobufjs  # protobufjs库文件夹
|           |---- build  # axios模块打包后的文件
|           |---- src  # 模块代码
|                |---- ets/   # 模块代码
|                     |---- dist     # 打包文件
|                     |---- docs     # 文档
|                     |---- script   # 打包脚本
|                     |---- src      # 源码文件
|                     |---- test     # 源码测试文件
|            |---- index.js          # 入口文件
|            |---- *.json5      # 配置文件
|     |---- README.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/protobuf/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/protobuf/pulls) 。

## 开源协议

本项目基于 [BSD License](https://gitee.com/openharmony-tpc/protobuf/blob/master/LICENSE) ，请自由地享受和参与开源。
