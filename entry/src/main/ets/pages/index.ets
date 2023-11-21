/*
  * Copyright (c) 2022 Huawei Device Co., Ltd.
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
    *
  * http://www.apache.org/licenses/LICENSE-2.0
    *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { user } from './user.js'

@Entry
@Component
struct Index {
    @State result: string = "";
    str: string = '';
    scroller: Scroller = new Scroller()

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            Scroll(this.scroller) {
                Column() {
                    Text("proto序列化反序列化")
                        .width('90%')
                        .height(60)
                        .backgroundColor(0xFFFFFF)
                        .borderRadius(15)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                        .margin({ top: 20 })
                        .onClick(event => {
                            this.result = "";
                            let msg = user.UserLoginResponse.create({
                                sessionId: "testSynchronouslyLoadProtoFile",
                                userPrivilege: "John123",
                                isTokenType: false,
                                formatTimestamp: "12342222"
                            });

                            let arrayBuffer: Uint8Array = user.UserLoginResponse.encode(msg).finish()
                            console.log("protobuf arrayBuffer:" + arrayBuffer);
                            this.result = this.result + "序列化数据：" + JSON.stringify(arrayBuffer) + "\r\n";

                            let decodeMsg = user.UserLoginResponse.decode(arrayBuffer);
                            console.log("protobuf decode:" + JSON.stringify(decodeMsg));
                            this.result = this.result + "反序列化数据：" + JSON.stringify(decodeMsg);
                        });


                    Text("proto序列化反序列化 ( 编码为分隔符分隔的字节序列/从分隔符分隔的字节序列中解码消息 )")
                        .width('90%')
                        .height(60)
                        .backgroundColor(0xFFFFFF)
                        .borderRadius(15)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                        .margin({ top: 20 })
                        .onClick(event => {
                            this.result = "";
                            let msg = user.UserLoginResponse.create({
                                sessionId: "testSynchronouslyLoadProtoFile",
                                userPrivilege: "John123",
                                isTokenType: false,
                                formatTimestamp: "12342222"
                            });

                            let arrayBuffer: Uint8Array = user.UserLoginResponse.encodeDelimited(msg).finish()
                            console.log("protobuf arrayBuffer:" + arrayBuffer);
                            this.result = this.result + "序列化数据：" + JSON.stringify(arrayBuffer) + "\r\n";

                            let decodeMsg = user.UserLoginResponse.decodeDelimited(arrayBuffer);
                            console.log("protobuf decode:" + JSON.stringify(decodeMsg));
                            this.result = this.result + "反序列化数据：" + JSON.stringify(decodeMsg);
                        });

                    Text("使用message创建一个普通对象")
                        .width('90%')
                        .height(60)
                        .backgroundColor(0xFFFFFF)
                        .borderRadius(15)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                        .margin({ top: 20 })
                        .onClick(event => {
                            this.result = ""
                            let msg = user.UserLoginResponse.create({
                                sessionId: "testSynchronouslyLoadProtoFile",
                                userPrivilege: "John123",
                                isTokenType: false,
                                formatTimestamp: "12342222"
                            });
                            let obj = user.UserLoginResponse.toObject(msg)
                            this.result = JSON.stringify(obj)
                        });

                    Text("验证protobuf有效性(null代表有效,否则返回无效原因)")
                        .width('90%')
                        .height(60)
                        .backgroundColor(0xFFFFFF)
                        .borderRadius(15)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                        .margin({ top: 20 })
                        .onClick(event => {
                            this.result = ""
                            let msg = user.UserLoginResponse.verify({
                                sessionId: "testSynchronouslyLoadProtoFile",
                                userPrivilege: "zhansgan",
                                isTokenType: false,
                                formatTimestamp: "687568"
                            })
                            this.result = JSON.stringify(msg)
                        });

                    Text("纯对象创建消息")
                        .width('90%')
                        .height(60)
                        .backgroundColor(0xFFFFFF)
                        .borderRadius(15)
                        .fontSize(16)
                        .textAlign(TextAlign.Center)
                        .margin({ top: 20 })
                        .onClick(event => {
                            this.result = ""
                            let msg = user.UserLoginResponse.fromObject({
                                sessionId: "testSynchronouslyLoadProtoFile",
                                userPrivilege: "John123",
                                isTokenType: false,
                                formatTimestamp: "8976796"
                            })
                            this.result = JSON.stringify(msg)
                        });

                    Text("结果 :\r\n  " + this.result)
                        .fontSize(15)
                        .margin({ top: 5, left: 20 })

                }.width('100%');
            }
            .scrollable(ScrollDirection.Vertical).scrollBar(BarState.On)
            .scrollBarColor(Color.Gray).scrollBarWidth(30);
            Button('重置显示', { type: ButtonType.Capsule, stateEffect: true })
                .backgroundColor(0x317aff)
                .margin({ top: 200, left: 5 })
                .width(110)
                .onClick(event => {
                    this.result = "";
                });
        }.width('100%').height('100%').backgroundColor(0xDCDCDC)
    }
}