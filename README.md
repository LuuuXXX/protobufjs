# protobuf

## Introduction

Protocol buffers (ProtoBuf) is a language-neutral, platform-neutral extensible mechanism for serializing structured data. It is used in (data) communication protocols and for data storage. As a flexible, efficient, and automatic structured data serialization method, ProtoBuf is smaller, faster, and simpler than XML.

In this project, [protobuf.js 5.0.3](https://github.com/protobufjs/protobuf.js) has been adapted for use with OpenHarmony.

## How to Install

1. Install protobufjs.

```
ohpm install @ohos/protobufjs
```

2. Import protobuf to the target page.

```
import protobuf from '@ohos/protobufjs'
```

## How to Use

**Input Formats Supported by protobuf**

1. String in proto format

```
const protoStr = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
```

2. JSON string mapped to the .proto file

```
const protoJson = '{
      "package": "com.user",
      "messages": [
        {
          "name": "UserLoginResponse",
          "fields": [
            {
              "rule": "optional",
              "type": "string",
              "name": "sessionId",
              "id": 1
            },
            {
              "rule": "optional",
              "type": "string",
              "name": "userPrivilege",
              "id": 2
            },
            {
              "rule": "optional",
              "type": "bool",
              "name": "isTokenType",
              "id": 3
            },
            {
              "rule": "optional",
              "type": "string",
              "name": "formatTimestamp",
              "id": 4
            }
          ]
        }
      ]
}'
```

3. .proto file

Define the message body struct in a .proto file, for example, **userproto.proto** in the **resource/rawfile** directory.

```
syntax = "proto3";

package com.user;
message UserLoginResponse{
   string sessionId = 1;
   string userPrivilege = 2;
   bool isTokenType = 3;
   string formatTimestamp = 4;
}
```

4. JSON file

Choose **resource** > **rawfile**, and save the .json file mapped to the .proto file. For details, see the second point.

**Object Encoding/Decoding**

1. Define the message body struct in a .proto file, for example, **userproto.proto** in the **resource/rawfile** directory.

```
syntax = "proto3";

package com.user;
message UserLoginResponse{
   string sessionId = 1;
   string userPrivilege = 2;
   bool isTokenType = 3;
   string formatTimestamp = 4;
}
```

2. Read the .proto file.

```
let builder = await Protobuf.loadProtoFile("userproto.proto", null, null, getContext(this).resourceManager)
```

3. Encode an object.

```
// Construct a message body.
var UserLoginResponse = builder.build("com.user.UserLoginResponse");
let userLoginData = {
    sessionId: "testAsynchronouslyLoadProtoFile",
    userPrivilege: "John123",
    isTokenType: false,
    formatTimestamp: "12342222"
  };

// Two object encoding methods
// Method 1: Use the static encoding method of the message body.
var arrayBuffer = UserLoginResponse.encode(userLoginData).toArrayBuffer();

// Method 2: Use a message body instance for encoding and decoding.
var msg = new UserLoginResponse(userLoginData);
var arrayBuffer = msg.toArrayBuffer();
```

4. Decode an object.

```
let decode = UserLoginResponse.decode(arrayBuffer)
```

**Examples:**

1. proto string encoding and decoding

```
Button("proto string encoding and decoding")
  .width('80%')
  .type(ButtonType.Capsule)
  .backgroundColor('#0D9FFB')
  .onClick(async () => {
    try {
      // 1. Create a protbuf.Builder object to construct the protocol message body.
      var builder = protobuf.newBuilder();
      
      // 2. Load the proto string to parse the definition of the protocol message body.
      var root = await protobuf.loadProto(protoStr, builder, "user.proto");
      
      // 3. Construct the protocol message body.
      var UserLoginResponse = root.build("com.user.UserLoginResponse");
      
	  // Set the data to encode/decode.
      const userLogin = {
        sessionId: "loadProto",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      
	  // 4. Instantiate message body. After the protocol name is found through the builder, a message is generated. Create a data object that complies with the protocol structure as the parameter instance protocol message body.
      var msg = new UserLoginResponse(userLogin);
      
      // 5. Encode the message body, which can be further passed or stored.
      var arrayBuffer = msg.toArrayBuffer();
      
      // 6. Decode the message body to obtain the original message body content.
      var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    } catch (error) {
      console.info('protobuf single file catch error: ' + error)
    }
  });
```

2. JSON string encoding and decoding

```
Button("JSON string encoding and decoding")
  .width('80%')
  .type(ButtonType.Capsule)
  .backgroundColor('#0D9FFB')
  .onClick(async () => {
    try {
      // 1. Create a protbuf.Builder object to construct the protocol message body.
      var builder = protobuf.newBuilder();
      
      // 2. Load the JSON string to parse the definition of the protocol message body.
      var root = await protobuf.loadProto(protoJson, builder, "user.json");
      
      // 3. Construct the protocol message body.
      var UserLoginResponse = root.build("com.user.UserLoginResponse");
      
	  // Set the data to encode/decode.
      const userLogin = {
        sessionId: "loadJson",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };
      
	  // 4. Instantiate message body. After the protocol name is found through the builder, a message is generated. Create a data object that complies with the protocol structure as the parameter instance protocol message body.
      var msg = new UserLoginResponse(userLogin);
      
      // 5. Encode the message body, which can be further passed or stored.
      var arrayBuffer = msg.toArrayBuffer();
      
      // 6. Decode the message body to obtain the original message body content.
      var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    } catch (error) {
      console.info('protobuf single file catch error: ' + error)
    }
  });
```

3. Synchronous encoding and decoding of .proto files

```
Button("Synchronous encoding and decoding of .proto files")
  .width('80%')
  .type(ButtonType.Capsule)
  .backgroundColor('#0D9FFB')
  .onClick(async () => {
    try {
    	// Read files using the ResourceManager in the globalization resource subsystem, which can be obtained in following methods.
    	// Method 1: Use the GlobalContext object to save the resourceManager object in the ability context.
    	// Method 2: Use getContext().
    	// Obtain ResourceManager on pages: getContext(this).resourceManager
    	let context: Context = GlobalContext.getContext().getObject("context") as Context;
        var builder = await protobuf.loadProtoFile('userproto.proto', null, null, context.resourceManager);
        if (!builder) {
          console.error('protobuf codec: builder is null|undefined.');
          return;
        }
        var UserLoginResponse = builder.build("com.user.UserLoginResponse");
        var msg = new UserLoginResponse(this.userLogin);
        var arrayBuffer = msg.toArrayBuffer();
        console.log("protobuf arrayBuffer:" + new Uint8Array(arrayBuffer));

        var decodeMsg = UserLoginResponse.decode(arrayBuffer);
        console.log("protobuf decode:" + JSON.stringify(decodeMsg));
      } catch (error) {
        console.info('protobuf single file catch error: ' + error)
      }
  });
```

4. Asynchronous encoding and decoding of .proto files

```
Button("Asynchronous encoding and decoding of .proto files")
  .width('80%')
  .type(ButtonType.Capsule)
  .backgroundColor('#0D9FFB')
  .onClick(() => {
    try {
      let context: Context = GlobalContext.getContext().getObject("context") as Context;
      protobuf.loadProtoFile('userproto.proto', (error, builder) => {
        if (error) {
          console.error('protobuf codec catch error: ' + error);
          return;
        }
        if (!builder) {
          console.error('protobuf codec: builder is null|undefined.');
          return;
        }
        var UserLoginResponse = builder.build("com.user.UserLoginResponse");
        var msg = new UserLoginResponse(this.userLogin);
        console.log("protobuf msg:" 
        var arrayBuffer = msg.toArrayBuffer();
        console.log("protobuf arrayBuffer:" + new Uint8Array(arrayBuffer));
        this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBu
        var decodeMsg = UserLoginResponse.decode(arrayBuffer);
        console.log("protobuf decode:" + JSON.stringify(decodeMsg));
        this.decodeData = JSON.stringify(decodeMsg);
      }, null, context.resourceManager);
    } catch (error) {
      console.info('protobuf single file catch error: ' + error)
    }
  });
```

## Available APIs

**loadProto**

static loadProto(proto:string,builder?:ProtoBuf.Builder|string|{root: string, file: string},filename?:string|{root: string, file: string}) :ProtoBuf.Builder;

Loads a string in proto format, parses the content, and returns a **ProtoBuf.Builder** instance.

Parameters:

| Name  | Type                                                        | Mandatory| Description                                                  |
| -------- | ------------------------------------------------------------ | ---- | ------------------------------------------------------ |
| proto    | string                                                       | Yes  | String in proto format.                                   |
| builder  | [Builder]() &#124;string &#124; {root: string, file: string} | No  | Existing **ProtoBuf.Builder** instance or a new **ProtoBuf.Builder** instance to create.|
| filename | string &#124; {root: string, file: string}                   | No  | File name for the imported file.          |

Return value:

| Type   | Description              |
| ------- | ------------------ |
| Builder | **ProtoBuf.Builder** instance.|

**protoFromString**

static protoFromString(proto:string,builder?:ProtoBuf.Builder|string|{root: string, file: string},filename?:string|{root: string, file: string}) :ProtoBuf.Builder;

Loads and parses protobuf definitions from a string.

Parameters:

| Name  | Type                                                        | Mandatory| Description                                                  |
| -------- | ------------------------------------------------------------ | ---- | ------------------------------------------------------ |
| proto    | string                                                       | Yes  | String in proto format.                                   |
| builder  | [Builder]() &#124;string &#124; {root: string, file: string} | No  | Existing **ProtoBuf.Builder** instance or a new **ProtoBuf.Builder** instance to create.|
| filename | string &#124; {root: string, file: string}                   | No  | File name for the imported file.          |

Return value:

| Type   | Description              |
| ------- | ------------------ |
| Builder | **ProtoBuf.Builder** instance.|

**loadProtoFile**

static loadProtoFile(filename:string|{root: string, file: string}, callback?=(error?:Error,builder:Protobuf.Builder)=>void,builder?:Protobuf.Builder,resourceManager: @ohos.resourceManager.ResourceManager):ProtoBuf.Builder|undefined;

Loads a .proto file, parses the content, and returns a **ProtoBuf.Builder** instance.

| Name         | Type                                      | Mandatory| Description                                                        |
| --------------- | ------------------------------------------ | ---- | ------------------------------------------------------------ |
| filename        | string &#124; {root: string, file: string} | Yes  | Path of the file to load or an object specifying the **root** and **file** properties.|
| callback        | function                                   | No  | Callback to be invoked when the file is loaded. If the operation is successful, it receives **null** as the first parameter and **builder** as the second parameter. Otherwise, **error** is the first parameter. If this parameter is not specified, the file will be loaded synchronously.|
| builder         | Builder                                    | No  | Existing **ProtoBuf.Builder** instance or a new **ProtoBuf.Builder** instance to create.      |
| resourceManager | @ohos.resourceManager.ResourceManager      | Yes  | Capability of accessing application resources.                                        |

Table 1 callback

| Name | Type   | Description                                                    |
| ------- | ------- | -------------------------------------------------------- |
| error   | Error   | Error returned if the parsing fails. If the parsing is successful, **null** is returned.|
| builder | Builder | **ProtoBuf.Builder** instance.                                      |

Return value:

| Type               | Description              |
| ------------------- | ------------------ |
| Builder &#124; null | **ProtoBuf.Builder** instance.|

**protoFromFile**

static protoFromFile(filename:string|{root: string, file: string}, callback?=(error?:Error,builder:Protobuf.Builder)=>void,builder?:Protobuf.Builder,resourceManager: @ohos.resourceManager.ResourceManager):ProtoBuf.Builder|undefined;

Loads a .proto file, parses the content, and returns a **ProtoBuf.Builder** instance.

| Name         | Type                                      | Mandatory| Description                                                        |
| --------------- | ------------------------------------------ | ---- | ------------------------------------------------------------ |
| filename        | string &#124; {root: string, file: string} | Yes  | Path of the file to load or an object specifying the **root** and **file** properties.|
| callback        | function                                   | No  | Callback to be invoked when the file is loaded. If the operation is successful, it receives **null** as the first parameter and **builder** as the second parameter. Otherwise, **error** is the first parameter. If this parameter is not specified, the file will be loaded synchronously.|
| builder         | Builder                                    | No  | Existing **ProtoBuf.Builder** instance or a new **ProtoBuf.Builder** instance to create.      |
| resourceManager | @ohos.resourceManager.ResourceManager      | Yes  | Capability of accessing application resources.                                        |

Table 1 callback

| Name | Type   | Description                                                    |
| ------- | ------- | -------------------------------------------------------- |
| error   | Error   | Error returned if the parsing fails. If the parsing is successful, **null** is returned.|
| builder | Builder | **ProtoBuf.Builder** instance.                                      |

Return value:

| Type                    | Description              |
| ------------------------ | ------------------ |
| Builder &#124; undefined | **ProtoBuf.Builder** instance.|

**loadJson**

static loadJson(json:string|any, builder?:Protobuf.Builder|string| {root: string, file: string}, filename?: string| {root: string, file: string} ): ProtoBuf.Builder;

Parameters:

| Name  | Type                                                        | Mandatory| Description                                                  |
| -------- | ------------------------------------------------------------ | ---- | ------------------------------------------------------ |
| json     | string &#124; any                                            | Yes  | JSON string in proto format or JSON object corresponding to the .proto file.    |
| builder  | [Builder]() &#124;string &#124; {root: string, file: string} | No  | Existing **ProtoBuf.Builder** instance or a new **ProtoBuf.Builder** instance to create.|
| filename | string &#124; {root: string, file: string}                   | No  | File name for the imported file.          |

Return value:

| Type   | Description              |
| ------- | ------------------ |
| Builder | **ProtoBuf.Builder** instance.|

**loadJsonFile**

static loadJsonFile(filename:string|{root: string, file: string}, callback?=(error?:Error,builder:Protobuf.Builder)=>void,builder?:Protobuf.Builder,resourceManager: @ohos.resourceManager.ResourceManager):ProtoBuf.Builder|undefined;

Loads a .proto file, parses the content, and returns a **ProtoBuf.Builder** instance.

| Name         | Type                                      | Mandatory| Description                                                        |
| --------------- | ------------------------------------------ | ---- | ------------------------------------------------------------ |
| filename        | string &#124; {root: string, file: string} | Yes  | Path of the file to load or an object specifying the **root** and **file** properties.|
| callback        | function                                   | No  | Callback to be invoked when the file is loaded. If the operation is successful, it receives **null** as the first parameter and **builder** as the second parameter. Otherwise, **error** is the first parameter. If this parameter is not specified, the file will be loaded synchronously.|
| builder         | Builder                                    | No  | Existing **ProtoBuf.Builder** instance or a new **ProtoBuf.Builder** instance to create.      |
| resourceManager | @ohos.resourceManager.ResourceManager      | Yes  | Capability of accessing application resources.                                        |

Table 1 callback

| Name | Type   | Description                                                    |
| ------- | ------- | -------------------------------------------------------- |
| error   | Error   | Error returned if the parsing fails. If the parsing is successful, **null** is returned.|
| builder | Builder | **ProtoBuf.Builder** instance.                                      |

Return value:

| Type                    | Description              |
| ------------------------ | ------------------ |
| Builder &#124; undefined | **ProtoBuf.Builder** instance.|

**newBuilder**

static newBuilder():Protobuf.Builder;

Return value:

| Type   | Description              |
| ------- | ------------------ |
| Builder | **ProtoBuf.Builder** instance.|

**Util**

The following APIs are in the **Util** object and must be called using **Protobuf.Util**.

**fetch**

static fetch(path:string, callback?:(content?:string)=> void):string|undefined.

Fetches the content of a file. Before calling this API, you need to create a **ResourceManager** instance for reading the file content.

Parameters:

| Name  | Type                    | Mandatory| Description                                                        |
| -------- | ------------------------ | ---- | ------------------------------------------------------------ |
| path     | string                   | Yes  | Resource file path.                                              |
| callback | (content?:string)=> void | No  | Callback used to receive the content read. If it is not specified, the file content will be fetched synchronously. If the request fails, the content is empty.|

Return value:

| Type                   | Description          |
| ----------------------- | -------------- |
| string &#124; undefined | File content fetched.|

**toCamelCase**

static toCamelCase(str:string):string;

Converts a string to the Camel Case format.

Parameters:

| Name| Type  | Mandatory| Description                    |
| ------ | ------ | ---- | ------------------------ |
| str    | string | Yes  | String to convert.|

Return value:

| Type  | Description            |
| ------ | ---------------- |
| string | String in Camel Case format.|

**Builder**

Protocol message body builder.

**isMessage**

static isMessage(def:Object):boolean;

Checks whether an object is a message.

Parameters:

| Name| Type  | Mandatory| Description                      |
| ------ | ------ | ---- | -------------------------- |
| def    | Object | Yes  | Object to check.|

Return value:

| Type   | Description                  |
| ------- | ---------------------- |
| boolean | A boolean value indicating whether the object is a message.|

**isMessageField**

static isMessageField(def:Object):boolean;

Checks whether an object is a message field.

Parameters:

| Name| Type  | Mandatory| Description                            |
| ------ | ------ | ---- | -------------------------------- |
| def    | Object | Yes  | Object to check.|

Return value:

| Type   | Description                        |
| ------- | ---------------------------- |
| boolean | A boolean value indicating whether the object is a message field.|

**isEnum**

static isEnum(def:Object):boolean;

Checks whether an object is an enum.

Parameters:

| Name| Type  | Mandatory| Description                        |
| ------ | ------ | ---- | ---------------------------- |
| def    | Object | Yes  | Object to check.|

Return value:

| Type   | Description                    |
| ------- | ------------------------ |
| boolean | A boolean value indicating whether the object is an enum.|

**build**

build(path?: string | string[]) : Protobuf.Builder.Message | Object;

Builds a message type for parsing definitions.

Parameters:

| Name| Type                  | Mandatory| Description              |
| ------ | ---------------------- | ---- | ------------------ |
| path   | string &#124; string[] | No  | Path to the message type to build.|

Return value:

| Type                                  | Description        |
| -------------------------------------- | ------------ |
| Protobuf.Builder.Message &#124; Object | **Protobuf.Builder.Message** instance.|

**lookup**

lookup(path?: string, excludeNonNamespace?: boolean) : ProtoBuf.Reflect.T;

Finds a type defined in your ProtoBuf schema.

Parameters:

| Name             | Type   | Mandatory| Description                                      |
| ------------------- | ------- | ---- | ------------------------------------------ |
| path                | string  | No  | Path of the type to find.                        |
| excludeNonNamespace | boolean | No  | Whether to exclude non-namespace types, such as fields, from the lookup. The default value is **false**.|

Return value:

| Type              | Description        |
| ------------------ | ------------ |
| ProtoBuf.Reflect.T | Type found.|

**Message**

Provides methods for encoding and decoding messages.

**constructor**

new Message(values:Object);

A constructor used to create a **Message** instance.

| Name| Type  | Mandatory| Description                          |
| ------ | ------ | ---- | ------------------------------ |
| values | Object | Yes  | Object used to create a **Message** instance.|

**encode**

static encode(data: Object, buffer?: ByteBuffer | boolean, noVerify?: boolean):ByteBuffer;

Encodes a message in the ByteBuffer format.

Parameters:

| Name  | Type   | Mandatory| Description                                                        |
| -------- | ------- | ---- | ------------------------------------------------------------ |
| data     | string  | Yes  | Data to encode.                                          |
| buffer   | boolean | No  | **ByteBuffer** object used to hold the encoded data. If it is not specified, a new **ByteBuffer** object will be created.|
| noVerify | boolean | No  | Whether to verify the field value. The default value is **false**.                             |

Return value:

| Type      | Description                                  |
| ---------- | -------------------------------------- |
| ByteBuffer | **ByteBuffer** instance containing the encoded data.|

**encode**

encode(buffer?: ByteBuffer| boolean, noVerify?: boolean): ByteBuffer;

Encodes this message into the ByteBuffer format.

Parameters:

| Name  | Type   | Mandatory| Description                                                        |
| -------- | ------- | ---- | ------------------------------------------------------------ |
| buffer   | string  | Yes  | **ByteBuffer** object used to hold the encoded data. If it is not specified, a new **ByteBuffer** object will be created.|
| noVerify | boolean | No  | Whether to verify the field value. The default value is **false**.                             |

Return value:

| Type      | Description                                  |
| ---------- | -------------------------------------- |
| ByteBuffer | **ByteBuffer** instance containing the encoded data.|

**encodeAB**

encodeAB():ArrayBuffer;

Encodes this message into the ArrayBuffer format.

Return value:

| Type       | Description                                   |
| ----------- | --------------------------------------- |
| ArrayBuffer | **ArrayBuffer** instance containing the encoded data.|

**toArrayBuffer**

toArrayBuffer():ArrayBuffer;

Converts this message into the ArrayBuffer format.

Return value:

| Type       | Description                                   |
| ----------- | --------------------------------------- |
| ArrayBuffer | **ArrayBuffer** instance containing the converted data.|

**calculate**

calculate(): Number;

Calculates the message length.

Return value:

| Type  | Description              |
| ------ | ------------------ |
| Number | Message length.|

**encodeDelimited**

encodeDelimited(buffer?: ByteBuffer| boolean, noVerify?: boolean): ByteBuffer;

Encodes this message into the ByteBuffer format with a length prefix.

Parameters:

| Name  | Type   | Mandatory| Description                                                        |
| -------- | ------- | ---- | ------------------------------------------------------------ |
| buffer   | string  | Yes  | **ByteBuffer** object used to hold the encoded data. If it is not specified, a new **ByteBuffer** object will be created.|
| noVerify | boolean | No  | Whether to verify the field value. The default value is **false**.                             |

Return value:

| Type      | Description                                  |
| ---------- | -------------------------------------- |
| ByteBuffer | **ByteBuffer** instance containing the encoded data.|

**encode64**

encode64(): string;

Encodes the message into a Base64-encoded string.

Return value:

| Type  | Description                            |
| ------ | -------------------------------- |
| string | A Base64-encoded string.|

**toBase64**

toBase64(): string;

Converts the message into a Base64-encoded string.

Return value:

| Type  | Description                            |
| ------ | -------------------------------- |
| string | A Base64-encoded string.|

**encodeHex**

encodeHex(): string;

Encodes the message into a hexadecimal-encoded string.

Return value:

| Type  | Description                              |
| ------ | ---------------------------------- |
| string | A hexadecimal-encoded string.|

**toHex**

toHex(): string;

Converts the message into a hexadecimal-encoded string.

Return value:

| Type  | Description                              |
| ------ | ---------------------------------- |
| string | A hexadecimal-encoded string.|

**encodeJson**

encodeJson(): string;

Encodes the message into a JSON string.

Return value:

| Type  | Description                    |
| ------ | ------------------------ |
| string | A JSON string.|

**toRaw**

toRaw(binaryAsBase64?:boolean, longsAsStrings:boolean):Object;

Returns the original object.

Parameters:

| Name            | Type   | Mandatory| Description                                                        |
| ------------------ | ------- | ---- | ------------------------------------------------------------ |
| databinaryAsBase64 | boolean | No  | Whether to encode binary data as a Base64 string. The default value is **false**.|
| longsAsStrings     | boolean | Yes  | Whether to encode a long value as a string.                                |

Return value:

| Type  | Description                |
| ------ | -------------------- |
| Object | Original object.|

**decode**

static decode(data: ByteBuffer|ArrayBuffer|Buffer|string, length?: Number| string, enc?: string):Protobuf.Builder.Message;

Decodes the message from a specified buffer or string.

Parameters:

| Name| Type                                                     | Mandatory| Description                                                        |
| ------ | --------------------------------------------------------- | ---- | ------------------------------------------------------------ |
| data   | ByteBuffer &#124; ArrayBuffer &#124; Buffer &#124; string | Yes  | Data to decode.                                              |
| length | Number &#124; string                                      | No  | Length of the message to decode. By default, the entire message is decoded.                              |
| enc    | string                                                    | No  | A string or buffer. **hex**, **base64** (default), and **utf8** (not recommended) are supported.|

Return value:

| Type                    | Description                            |
| ------------------------ | -------------------------------- |
| Protobuf.Builder.Message | Message decoded.|

**decode64**

static decode64(str:string):Protobuf.Builder.Message;

Decodes the message from a specified Base64-encoded string.

Parameters:

| Name| Type  | Mandatory| Description                          |
| ------ | ------ | ---- | ------------------------------ |
| str    | string | Yes  | A string to decode.|

Return value:

| Type                    | Description                              |
| ------------------------ | ---------------------------------- |
| Protobuf.Builder.Message | Message decoded.|

**decodeHex**

static decodeHex(str:string):Protobuf.Builder.Message;

Decodes the message from a specified hexadecimal-encoded string.

Parameters:

| Name| Type  | Mandatory| Description                            |
| ------ | ------ | ---- | -------------------------------- |
| str    | string | Yes  | A hexadecimal-encoded string to decode.|

Return value:

| Type                    | Description                                |
| ------------------------ | ------------------------------------ |
| Protobuf.Builder.Message | Message decoded.|

**decodeJson**

static decodeJson(str:string):Protobuf.Builder.Message;

Decodes the message from a JSON string.

Parameters:

| Name| Type  | Mandatory| Description                  |
| ------ | ------ | ---- | ---------------------- |
| str    | string | Yes  | A string to decode.|

Return value:

| Type                    | Description                  |
| ------------------------ | ---------------------- |
| Protobuf.Builder.Message | Message decoded.|

**decodeDelimited**

static decodeDelimited(buffer: ByteBuffer | ArrayBuffer | Buffer | string, enc?: string):Protobuf.Builder.Message;

Decodes the length-delimited varint32 message from the specified buffer or string.

Parameters:

| Name| Type                                                     | Mandatory| Description                                                        |
| ------ | --------------------------------------------------------- | ---- | ------------------------------------------------------------ |
| buffer | ByteBuffer &#124; ArrayBuffer &#124; Buffer &#124; string | Yes  | The specified buffer or string.                                      |
| enc    | string                                                    | No  | A string or buffer. **hex**, **base64** (default), and **utf8** (not recommended) are supported.|

Return value:

| Type                    | Description                                                |
| ------------------------ | ---------------------------------------------------- |
| Protobuf.Builder.Message | Length-delimited varint32 message decoded.|

## Constraints
This project has been verified in the following versions:

- DevEco Studio: 4.0 (4.0.3.512), SDK: API 10 (4.0.10.9)
- DevEco Studio: 4.0 Release (4.0.3.413), SDK: API 10 (4.0.10.3)

## Directory Structure

```
|---- protobuf
|     |---- AppScrope  # Sample code
|     |---- entry  # Sample code
|     |---- protobufjs  # protobufjs library
|           |---- src/main  # Module code
|                |---- ets/   # Module code
|                     |---- dist     # Package file
|            |---- index.ets          # Entry file
|            |---- .ohpmignore        # Ignore files released by ohpm
|            |---- *.json5      # Configuration file
|     |---- README.md  # Readme
|     |---- README_zh.md  # Readme
|     |---- README.OpenSource  # Open source description
|     |---- CHANGELOG.md  # Changelog
```

## How to Contribute

If you find any problem when using the project, submit an [issue](https://gitee.com/openharmony-tpc/protobuf/issues) or a [PR](https://gitee.com/openharmony-tpc/protobuf/pulls).

## License

This project is licensed under [BSD License](https://gitee.com/openharmony-tpc/protobuf/blob/master/LICENSE).
