/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import protobuf from '@ohos/protobufjs'
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State bufferData: string = "";
  @State decodeData: string = "";
  private TAG: string = 'protobuf'
  private  protoStr:string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
  private  protoJson:Object = JSON.stringify({
    "package": "com.user",
    "syntax": "proto3",
    "messages": [
      {
        "name": "UserLoginResponse",
        "fields": [
          {
            "rule": "optional",
            "type": "string",
            "name": "sessionId",
            "id": 1,
          },
          {
            "rule": "optional",
            "type": "string",
            "name": "userPrivilege",
            "id": 2,
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
            "id": 4,
          }
        ]
      }
    ]
  });
  private userLoginData = {
    sessionId: "testAsynchronouslyLoadProtoFile",
    userPrivilege: "John123",
    isTokenType: false,
    formatTimestamp: "12342222"
  };
  private innerData = {
    result: [
      {
        url: 'url55555555555',
        title: "title666666666666666",
        spinner: ["array111", "array2222"]
      },
      {
        url: 'url55555555555',
        title: "title666666666666666",
        spinner: ["array111", "array2222"]
      }]
  }
  private test1Data = {
    a: 150
  }
  private test2Data = {
    b: 'this is test2 666666666666666'
  }
  private test3Data = {
    test1: { a: 150 },
    test2: { b: 'this is test2 666666666666666' }
  }

  build() {
    Row() {
      Column({ space: 10 }) {
        Text("序列化数据：" + this.bufferData)
          .fontSize(13)
          .margin({ top: 10, left: 10 })
        Text("反序列化数据：" + this.decodeData)
          .fontSize(13)
          .margin({ top: 5, left: 10 })

        Button("编解码proto字符串")
          .width('80%')
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .onClick(async () => {
            try {
              var builder = protobuf.newBuilder();
              var root = await protobuf.loadProto(this.protoStr, builder, "user.proto");
              this.codecSingleFile(root);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', ' single file catch error: ' + error);
            }
          });

        Button("编解码protoJson")
          .width('80%')
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .onClick(async () => {
            try {
              var builder = protobuf.newBuilder();
              var root = await protobuf.loadJson(this.protoJson, builder, "user.json");
              this.codecSingleFile(root);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', ' single file catch error: ' + error);
            }
          });

        Button("编解码protoJsonFile")
          .width('80%')
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .onClick(async () => {
            try {
              var builder = protobuf.newBuilder();
              var root = await protobuf.loadJsonFile('user.json', null, builder, globalThis.resourceMana);
              this.codecSingleFile(root);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', ' single file catch error: ' + error);
            }
          });

        Button("同步：单个proto文件")
          .width('80%')
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .onClick(async () => {
            try {
              var builder = await protobuf.loadProtoFile('userproto.proto', null, null, globalThis.resourceMana);
              this.codecSingleFile(builder);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', ' single file catch error: ' + error);
            }
          });

        Button('同步：import导入其他proto文件')
          .width('80%')
          .backgroundColor('#0D9FFB')
          .onClick(async () => {
            try {
              let builder = await protobuf.loadProtoFile('imports.proto', null, null, globalThis.resourceMana);
              this.codecImportsFile(builder);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', 'import nest file catch error: ' + error);
            }
          });

        Button('同步：内部嵌套')
          .backgroundColor('#0D9FFB')
          .width('80%')
          .onClick(async () => {
            try {
              var builder = await protobuf.loadProtoFile('inner.proto', null, null, globalThis.resourceMana);
              this.codecInnerNestFiles(builder);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', ' inner nest file catch error: ' + error);
            }
          })

        Button("异步：单个proto文件")
          .width('80%')
          .type(ButtonType.Capsule)
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            try {
              protobuf.loadProtoFile('userproto.proto', (error, builder) => {
                if (error) {
                  hilog.error(0x0000, this.TAG, '%{public}s', ' codec catch error: ' + error);
                  return;
                }
                this.codecSingleFile(builder);
              }, null, globalThis.resourceMana);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              hilog.error(0x0000, this.TAG, '%{public}s', ' single file catch error: ' + error);
            }
          });


        Button('异步：import导入其他proto文件')
          .width('80%')
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            try {
              protobuf.loadProtoFile('imports.proto', (error, builder) => {
                if (error) {
                  hilog.error(0x0000, this.TAG, '%{public}s', ' codec catch error: ' + error);
                  return;
                }
                this.codecImportsFile(builder);
              }, null, globalThis.resourceMana);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              console.info('protobuf import nest file catch error: ' + error)
            }
          });

        Button('异步：内部嵌套')
          .width('80%')
          .backgroundColor('#0D9FFB')
          .onClick(() => {
            try {
              protobuf.loadProtoFile('inner.proto', (error, builder) => {
                if (error) {
                  hilog.error(0x0000, this.TAG, '%{public}s', ' codec catch error: ' + error);
                  return;
                }
                this.codecInnerNestFiles(builder);
              }, null, globalThis.resourceMana);
            } catch (error) {
              this.bufferData = "";
              this.decodeData = "";
              console.info('protobuf inner nest file catch error: ' + error)
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  /**
   * 单文件序列化
   * @param builder protobuf序列化构建器
   */
  private codecSingleFile(builder) {
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    var UserLoginResponse = builder.build("com.user.UserLoginResponse");
    var msg = new UserLoginResponse(this.userLoginData);

    var arrayBuffer = msg.toArrayBuffer();
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer: ' + new Uint8Array(arrayBuffer));

    var arrayBuffer2 = UserLoginResponse.encode(this.userLoginData).toBuffer()
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer2: ' + new Uint8Array(arrayBuffer2));

    var decodeMsg = UserLoginResponse.decode(arrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decode: ' + JSON.stringify(decodeMsg));
    this.decodeData = JSON.stringify(decodeMsg);
  }

  /**
   * 引入外部文件的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  private codecImportsFile(builder) {
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec: builder is null|undefined.');
      return;
    }
    var test1Entity = builder.build('Test1')
    var test2Entity = builder.build('Test2')
    var test3Entity = builder.build('js.Test3')

    var messageTest1 = new test1Entity(this.test1Data);
    var test1ArrayBuffer = messageTest1.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' test1ArrayBuffer: ' + new Uint8Array(test1ArrayBuffer));

    var decodeTest1Msg = test1Entity.decode(test1ArrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest1Msg: ' + JSON.stringify(decodeTest1Msg));

    var messageTest2 = new test2Entity(this.test2Data);
    var test2ArrayBuffer = messageTest2.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' test1ArrayBuffer: ' + new Uint8Array(test2ArrayBuffer));
    var decodeTest2Msg = test2Entity.decode(test2ArrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest2Msg: ' + JSON.stringify(decodeTest2Msg));

    var messageTest3 = new test3Entity(this.test3Data)
    hilog.info(0x0000, this.TAG, '%{public}s', ' messageTest3: ' + JSON.stringify(messageTest3));
    var test3ArrayBuffer = messageTest3.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' test3ArrayBuffer: ' + new Uint8Array(test3ArrayBuffer));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(test3ArrayBuffer));
    var decodeTest3Msg = test3Entity.decode(test3ArrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest3Msg: ' + JSON.stringify(decodeTest3Msg));
    this.decodeData = JSON.stringify(decodeTest3Msg);
  }

  /**
   * 文件内部嵌套结构体的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  private codecInnerNestFiles(builder) {
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec: builder is null|undefined.');
      return;
    }
    var InnerEntity = builder.build('js.ResultResponse');
    var resultMessage = new InnerEntity(this.innerData);
    var arrayBufferResult = resultMessage.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' inner ArrayBuffer: ' + new Uint8Array(arrayBufferResult));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBufferResult));

    var decodeInnerMsg = InnerEntity.decode(arrayBufferResult);
    hilog.info(0x0000, this.TAG, '%{public}s', ' inner decode: ' + JSON.stringify(decodeInnerMsg));
    this.decodeData = JSON.stringify(decodeInnerMsg);
  }
}