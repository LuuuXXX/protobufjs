/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
import hilog from '@ohos.hilog'

export class Util {
  private TAG: string = 'protobuf'

  private userInfo = {
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
  }

  private userLoginData = {
    sessionId: "testAsynchronouslyLoadProtoFile",
    userPrivilege: "John123",
    isTokenType: false,
    formatTimestamp: "12342222"
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

  constructor() {
  }

  async loadProto(protoStr: string, filename: string) {
    let builder = protobuf.newBuilder();
    let root = await protobuf.loadProto(protoStr, builder, filename);
    return root
  }

  async loadJson(protoJson: Object, filename: string) {
    let builder = protobuf.newBuilder();
    let root = await protobuf.loadJson(protoJson, builder, filename);
    return root
  }

  async loadJsonFile(filename: string, resourceManager) {
    let builder = protobuf.newBuilder();
    let root = await protobuf.loadJsonFile(filename, null, builder, resourceManager);
    return root
  }

  async loadProtoFile(filename: string, resourceManager) {
    let root = await protobuf.loadProtoFile(filename, null, null, resourceManager);
    return root
  }

  /**
   * 单文件序列化
   * @param protoStr proto格式的字符串
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象编码字符串
   */
  async loadProtoBufferData(protoStr: string, filename: string): Promise<string> {
    let builder: any = await this.loadProto(protoStr, filename);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);

    let arrayBuffer = msg.toArrayBuffer();

    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer: ' + new Uint8Array(arrayBuffer));
    return new Uint8Array(arrayBuffer).toString();
  }

  /**
   * 单文件序列化
   * @param protoStr proto格式的字符串
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象解码字符串
   */
  async loadProtoMsg(protoStr: string, filename: string): Promise<string> {
    let builder: any = await this.loadProto(protoStr, filename);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);

    let arrayBuffer = msg.toArrayBuffer();

    let arrayBuffer2 = UserLoginResponse.encode(this.userLoginData).toBuffer()
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer2: ' + new Uint8Array(arrayBuffer2));

    let decodeMsg = UserLoginResponse.decode(arrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decode: ' + JSON.stringify(decodeMsg));
    return JSON.stringify(decodeMsg);
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象编码字符串
   */
  async loadJsonBufferData(filename: string): Promise<string> {
    let protoJson: Object = JSON.stringify(this.userInfo);
    let builder: any = await this.loadJson(protoJson, filename);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);

    let arrayBuffer = msg.toArrayBuffer();

    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer: ' + new Uint8Array(arrayBuffer));
    return new Uint8Array(arrayBuffer).toString();
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象解码字符串
   */
  async loadJsonMsg(filename: string): Promise<string> {
    let protoJson: Object = JSON.stringify(this.userInfo);
    let builder: any = await this.loadJson(protoJson, filename);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);

    let arrayBuffer = msg.toArrayBuffer();

    let arrayBuffer2 = UserLoginResponse.encode(this.userLoginData).toBuffer()
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer2: ' + new Uint8Array(arrayBuffer2));

    let decodeMsg = UserLoginResponse.decode(arrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decode: ' + JSON.stringify(decodeMsg));
    return JSON.stringify(decodeMsg);
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象编码字符串
   */
  async loadJsonFileBufferData(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadJsonFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);
    let arrayBuffer = msg.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer: ' + new Uint8Array(arrayBuffer));
    return new Uint8Array(arrayBuffer).toString();
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象解码字符串
   */
  async loadJsonFileMsg(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadJsonFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);

    let arrayBuffer = msg.toArrayBuffer();

    let arrayBuffer2 = UserLoginResponse.encode(this.userLoginData).toBuffer()
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer2: ' + new Uint8Array(arrayBuffer2));

    let decodeMsg = UserLoginResponse.decode(arrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decode: ' + JSON.stringify(decodeMsg));
    return JSON.stringify(decodeMsg);
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象编码字符串
   */
  async loadProtoFileBufferData(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadProtoFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);
    let arrayBuffer = msg.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer: ' + new Uint8Array(arrayBuffer));
    return new Uint8Array(arrayBuffer).toString();
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象解码字符串
   */
  async loadProtoFileMsg(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadProtoFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec error: builder is null|undefined.');
      return;
    }
    let UserLoginResponse = builder.build("com.user.UserLoginResponse");
    let msg = new UserLoginResponse(this.userLoginData);

    let arrayBuffer = msg.toArrayBuffer();

    let arrayBuffer2 = UserLoginResponse.encode(this.userLoginData).toBuffer()
    hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer2: ' + new Uint8Array(arrayBuffer2));

    let decodeMsg = UserLoginResponse.decode(arrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decode: ' + JSON.stringify(decodeMsg));
    return JSON.stringify(decodeMsg);
  }

  /**
   * 单文件序列化
   * @param filename 如果知道对应的文件名称，必须为导入文件指定。
   * return 对象编码字符串
   */
  loadProtoFileCallBack(filename: string, resourceManager, callback: Function): void {
    protobuf.loadProtoFile(filename, (error, builder: any) => {
      if (error) {
        hilog.error(0x0000, this.TAG, '%{public}s', ' codec catch error: ' + error);
        return;
      }
      let UserLoginResponse = builder.build("com.user.UserLoginResponse");
      let msg = new UserLoginResponse(this.userLoginData);
      let arrayBuffer = msg.toArrayBuffer();
      hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer: ' + new Uint8Array(arrayBuffer));

      let arrayBuffer2 = UserLoginResponse.encode(this.userLoginData).toBuffer()
      hilog.info(0x0000, this.TAG, '%{public}s', ' arrayBuffer2: ' + new Uint8Array(arrayBuffer2));

      let decodeMsg = UserLoginResponse.decode(arrayBuffer);
      hilog.info(0x0000, this.TAG, '%{public}s', ' decode: ' + JSON.stringify(decodeMsg));

      callback(new Uint8Array(arrayBuffer).toString(), JSON.stringify(decodeMsg))
    }, null, resourceManager);
  }

  /**
   * 引入外部文件的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  async importLoadProtoFileBufferData(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadProtoFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec: builder is null|undefined.');
      return;
    }
    let test1Entity = builder.build('Test1')
    let test2Entity = builder.build('Test2')
    let test3Entity = builder.build('js.Test3')

    let messageTest1 = new test1Entity(this.test1Data);
    let test1ArrayBuffer = messageTest1.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' test1ArrayBuffer: ' + new Uint8Array(test1ArrayBuffer));

    let decodeTest1Msg = test1Entity.decode(test1ArrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest1Msg: ' + JSON.stringify(decodeTest1Msg));

    let messageTest2 = new test2Entity(this.test2Data);
    let test2ArrayBuffer = messageTest2.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' test1ArrayBuffer: ' + new Uint8Array(test2ArrayBuffer));
    let decodeTest2Msg = test2Entity.decode(test2ArrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest2Msg: ' + JSON.stringify(decodeTest2Msg));

    let messageTest3 = new test3Entity(this.test3Data)
    hilog.info(0x0000, this.TAG, '%{public}s', ' messageTest3: ' + JSON.stringify(messageTest3));
    let test3ArrayBuffer = messageTest3.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' test3ArrayBuffer: ' + new Uint8Array(test3ArrayBuffer));
    return new Uint8Array(test3ArrayBuffer).toString();
  }

  /**
   * 引入外部文件的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  async importLoadProtoFileMsg(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadProtoFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec: builder is null|undefined.');
      return;
    }
    let test3Entity = builder.build('js.Test3')
    let messageTest3 = new test3Entity(this.test3Data)
    let test3ArrayBuffer = messageTest3.toArrayBuffer();
    let decodeTest3Msg = test3Entity.decode(test3ArrayBuffer);
    hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest3Msg: ' + JSON.stringify(decodeTest3Msg));
    return JSON.stringify(decodeTest3Msg);
  }

  /**
   * 引入外部文件的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  importLoadProtoFileCallBack(filename: string, resourceManager, callBack: Function): void {
    protobuf.loadProtoFile(filename, (error, builder: any) => {
      if (error) {
        hilog.error(0x0000, this.TAG, '%{public}s', ' codec catch error: ' + error);
        return;
      }
      let test1Entity = builder.build('Test1')
      let test2Entity = builder.build('Test2')
      let test3Entity = builder.build('js.Test3')

      let messageTest1 = new test1Entity(this.test1Data);
      let test1ArrayBuffer = messageTest1.toArrayBuffer();
      hilog.info(0x0000, this.TAG, '%{public}s', ' test1ArrayBuffer: ' + new Uint8Array(test1ArrayBuffer));

      let decodeTest1Msg = test1Entity.decode(test1ArrayBuffer);
      hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest1Msg: ' + JSON.stringify(decodeTest1Msg));

      let messageTest2 = new test2Entity(this.test2Data);
      let test2ArrayBuffer = messageTest2.toArrayBuffer();
      hilog.info(0x0000, this.TAG, '%{public}s', ' test1ArrayBuffer: ' + new Uint8Array(test2ArrayBuffer));
      let decodeTest2Msg = test2Entity.decode(test2ArrayBuffer);
      hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest2Msg: ' + JSON.stringify(decodeTest2Msg));

      let messageTest3 = new test3Entity(this.test3Data)
      hilog.info(0x0000, this.TAG, '%{public}s', ' messageTest3: ' + JSON.stringify(messageTest3));
      let test3ArrayBuffer = messageTest3.toArrayBuffer();
      hilog.info(0x0000, this.TAG, '%{public}s', ' test3ArrayBuffer: ' + new Uint8Array(test3ArrayBuffer));
      let decodeTest3Msg = test3Entity.decode(test3ArrayBuffer);
      hilog.info(0x0000, this.TAG, '%{public}s', ' decodeTest3Msg: ' + JSON.stringify(decodeTest3Msg));
      callBack(new Uint8Array(test3ArrayBuffer).toString(), JSON.stringify(decodeTest3Msg))
    }, null, resourceManager);
  }


  /**
   * 文件内部嵌套结构体的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  async innerLoadProtoFileBufferData(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadProtoFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec: builder is null|undefined.');
      return;
    }
    let InnerEntity = builder.build('js.ResultResponse');
    let resultMessage = new InnerEntity(this.innerData);
    let arrayBufferResult: ArrayBuffer = resultMessage.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' inner ArrayBuffer: ' + new Uint8Array(arrayBufferResult));
    return new Uint8Array(arrayBufferResult).toString();
  }

  /**
   * 文件内部嵌套结构体的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  async innerLoadProtoFileMsg(filename: string, resourceManager): Promise<string> {
    let builder: any = await this.loadProtoFile(filename, resourceManager);
    if (!builder) {
      hilog.error(0x0000, this.TAG, '%{public}s', ' codec: builder is null|undefined.');
      return;
    }
    let InnerEntity = builder.build('js.ResultResponse');
    let resultMessage = new InnerEntity(this.innerData);
    let arrayBufferResult: ArrayBuffer = resultMessage.toArrayBuffer();
    hilog.info(0x0000, this.TAG, '%{public}s', ' inner decode: ' + JSON.stringify(InnerEntity.decode(arrayBufferResult)));
    return JSON.stringify(InnerEntity.decode(arrayBufferResult));
  }

  /**
   * 文件内部嵌套结构体的proto文件序列化
   * @param builder protobuf序列化构建器
   */
  innerLoadProtoFileCallBack(filename: string, resourceManager, callBack: Function): void {
    protobuf.loadProtoFile(filename, (error, builder: any) => {
      if (error) {
        hilog.error(0x0000, this.TAG, '%{public}s', ' codec catch error: ' + error);
        return;
      }
      let InnerEntity = builder.build('js.ResultResponse');
      let resultMessage = new InnerEntity(this.innerData);
      let arrayBufferResult: ArrayBuffer = resultMessage.toArrayBuffer();
      hilog.info(0x0000, this.TAG, '%{public}s', ' inner ArrayBuffer: ' + new Uint8Array(arrayBufferResult));
      hilog.info(0x0000, this.TAG, '%{public}s', ' inner decode: ' + JSON.stringify(InnerEntity.decode(arrayBufferResult)));
      callBack(new Uint8Array(arrayBufferResult).toString(), JSON.stringify(InnerEntity.decode(arrayBufferResult)))
    }, null, resourceManager);

  }
}