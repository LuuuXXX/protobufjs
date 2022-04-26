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

import protobuf from 'protobufjs'

@Entry
@Component
struct Rpc {
  @State responseData: string = "";
  @State requestData: string = "";

  private aboutToAppear() {

    const protoStr = 'syntax = "proto3";service MyService {rpc MyMethod (MyRequest) returns (MyResponse);} message MyRequest {string data = 1;} message MyResponse {int32 status = 2;}';
    var newBuild = protobuf.newBuilder();
    var root = protobuf.loadProto(protoStr, newBuild, "rpc.proto");
    var MyService = root.build("MyService");
    var MyRequest = root.build("MyRequest");
    var MyResponse = root.build("MyResponse");

    var that = this;
    var rpc = function rpc(method, requestData, callback) {
      console.log("rpc-request:" + requestData.data);
      that.requestData = requestData.data;
      setTimeout(function () {
        callback(null, new MyResponse({
          status: 200 }).encode());
      });
    }

    var service = new MyService(rpc);
    service.MyMethod(new MyRequest({
      data: "I am rpcServiceImpl"
    }), function (err, response) {
      if (err) {
        return err.message;
      }
      that.responseData = response.status;
      console.log("rpc-request:" + response.status);
    });
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("response:数据：" + this.responseData)
        .fontSize(20)
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold);
      Text("response:数据：" + this.responseData)
        .fontSize(20)
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold);
      Text("这里仅仅提供protobufjs中如何定义rpc的协议和方法使用，至于服务端和客户端需要根据自己需求去实现")
        .fontSize(20)
        .margin({ top: 10 })
        .fontWeight(FontWeight.Bold);
    }
    .width('100%')
    .height('100%')
  }
}