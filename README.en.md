# protobuf

#### Description

Protobufets is a simple version that adapts to the ETS of openharmony system. The main adaptation version is protobufjs@5.0.1 。 Protobufjs's main function is serialization and deserialization, which is more efficient. The volume after serialization is also very small, which is loved by the majority of developers.

#### Software Architecture

```
|-ets
|   |-MainAbility
|           |-page
|               |-index.ets        #主页面 
|               |-serialized.ets   #序列化和反序列化simple页面

```


#### Installation

1.If nodejs is already installed, enter the following command protobufjs
```
npm install protobufjs@5.0.1
```
2.Import protobufjs on the page you need to use
```
import ProtoBuf from 'protobufjs'
```

#### Instructions

1. Set a proto format protocol first
```
const proto = " message Sample {" +
    "required uint32 id = 1;" +
    "required string name = 2;" +
    "required string password = 3;" +
    "}";
```
2. Load and parse the protocol through the loadproto method
```
var builder = ProtoBuf.newBuilder();
    ProtoBuf.loadProto(proto,builder,"bench.proto");
```
3. After finding the protocol name through the builder, a message will be generated, and a data object with the same protocol structure will be created and put into the instanced message
```
var Sample = builder.build("Sample");

    const sample = {
      id: 1,
      name: "John123",
      password: "helloworld"
    };

    var msg = new Sample(sample);
```
4. Serialize the message for delivery or storage
```
var arrayBuffer = msg.toArrayBuffer();
```
5. The other party gets the transmitted or stored data and deserializes it
```
 var decodeMsg = Sample.decode(arrayBuffer);
```
#### Version
```
1.0.0
```