# protobuf

#### 介绍
protobuf 是适配openHarmony系统ETS简单的simple，主要适配版本是protobufjs@5.0.1。protobufjs主要功能是序列化和反序列化，更高效，序列化后的体积也很小，受到广大开发者的喜爱。

#### 软件架构

```
|-ets
|   |-MainAbility
|           |-page
|               |-index.ets        #主页面 
|               |-serialized.ets   #序列化和反序列化simple页面

```

#### 安装教程
1.如果已经安装好nodejs后，输入以下命令protobufjs
```
npm install protobufjs@5.0.1
```
2.在需要使用的页面导入protobufjs
```
import protobuf from 'protobufjs'
```

#### 使用说明

1. 先定一个proto的格式协议
```
const proto = " message Sample {" +
    "required uint32 id = 1;" +
    "required string name = 2;" +
    "required string password = 3;" +
    "}";
```
2. 通过loadProto方法加载并解析协议
```
var builder = protobuf.newBuilder();
    protobuf.loadProto(proto,builder,"bench.proto");
```
3. 通过builder找到协议名后会产生Message，并创建一个相同协议结构的数据对象，放入已实例的Message
```
var Sample = builder.build("Sample");

    const sample = {
      id: 1,
      name: "John123",
      password: "helloworld"
    };

    var msg = new Sample(sample);
```
4. 将Message序列化,可进行传递或存储
```
var arrayBuffer = msg.toArrayBuffer();
```
5. 对方拿到传递或存储的数据，进行反序列化
```
 var decodeMsg = Sample.decode(arrayBuffer);
```

#### 版本
```
1.0.0
```

