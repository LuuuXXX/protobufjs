# protobuf

### 介绍

protobuf 是OpenHarmony系统下使用[protobufjs](https://github.com/protobufjs/protobuf.js)的开发示例，此处使用的版本是protobufjs@5.0.3 。[protobufjs](https://github.com/protobufjs/protobuf.js)主要功能是序列化和反序列化，更高效，序列化后的体积也很小，受到广大开发者的喜爱。

### 下载安装

1.如果已经安装好nodejs后，输入以下命令

```
npm install protobufjs@5.0.3
```

2.在需要使用的页面导入protobufjs

```
import protobuf from 'protobufjs'
```

### 使用说明

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

### 接口说明

1，.loadProto(proto, builder, "bench.proto"); 用于解析proto协议接口，proto:string类型协议，builder:newBuilder()对象，"bench.proto"
：定义一个proto文件名称。

2，.toArrayBuffer(); 将Message序列化

3，.decode(buffer); 将buffer数据反序列化

### 兼容性

支持OpenHarmony API Version 8 及以上版本。

库版本兼容性：由于系统兼容性目前仅支持到protobufjs@5.0.3。

### 软件架构

```
|-ets
|   |-MainAbility
|           |-page
|               |-index.ets        #主页面 
|               |-serialized.ets   #序列化和反序列化simple页面
|               |-writer_reader.ets   #序列化和反序列化simple页面

```

### 版本

```
1.0.0
```

### 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-tpc/protobuf/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-tpc/protobuf/pulls) 。

### 开源协议
本项目基于 [BSD 3-Clause License](https://gitee.com/openharmony-tpc/protobuf/blob/master/LICENSE) ，请自由地享受和参与开源
