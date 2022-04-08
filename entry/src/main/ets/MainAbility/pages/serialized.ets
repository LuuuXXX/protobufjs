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

import router from '@system.router';
import protobuf from 'protobufjs'

@Entry
@Component
struct Serialized {
  @State bufferData: string = "";
  @State decodeData: string = "";
  @State textBufferData: string = "";
  @State textDecodeData: string = "";
  private content: string = "Second Page"

  private aboutToAppear() {

    const proto = " message Sample {" +
    "required uint32 id = 1;" +
    "required string name = 2;" +
    "required string password = 3;" +
    "}";

    var builder = protobuf.newBuilder();
    protobuf.loadProto(proto, builder, "bench.proto");

    var Sample = builder.build("Sample");

    const sample = {
      id: 1,
      name: "John123",
      password: "helloworld"
    };

    var msg = new Sample(sample);
    console.log("msg:" + msg);

    var arrayBuffer = msg.toArrayBuffer();
    console.log("arrayBuffer:" + new Uint8Array(arrayBuffer));
    this.bufferData = Array.prototype.toString.call(new Uint8Array(arrayBuffer));

    var decodeMsg = Sample.decode(arrayBuffer);
    console.log("decode:" + JSON.stringify(decodeMsg));
    this.decodeData = JSON.stringify(decodeMsg);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text("原始数据：" + 'id: 1,name: "John123",password: "helloworld"')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text('序列化数据')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        this.textBufferData = this.bufferData;
      })

      Text(this.textBufferData)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Button() {
        Text('反序列化数据')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        this.textDecodeData = this.decodeData;
      })

      Text(this.textDecodeData)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .height('100%')
  }
}