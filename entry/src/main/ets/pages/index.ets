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
import router from '@ohos.router';

import { Protobuf } from "@ohos/protobufjs"

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  private readonly TAG: string = 'protobufjsinfo'

  build() {
    Row() {
      Column() {
        Button() {
          Text('核心功能：序列化和反序列化')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .onClick(async (event?: ClickEvent) => {
          // router.pushUrl({url: 'pages/serialized' })

          console.info(this.TAG, "start loadProtoFile ")
          let builder = await Protobuf.loadProtoFile("inner.proto", null, null, getContext(this).resourceManager)

          try {
            // @ts-ignore
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


            let decode = JS.decode(encode)

            console.info(this.TAG, "decode = " + JSON.stringify(decode))

          } catch (e) {
            console.error(this.TAG, "error:" + e)
          }
        });
        Button() {
          Text('buffer读写示例')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          router.pushUrl({ url: 'pages/writer_reader' })
        });
        Button() {
          Text('rpc接口样例')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          router.pushUrl({ url: 'pages/rpc' })
        });
        Button() {
          Text('websocket配合使用样例')
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }.type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          router.pushUrl({ url: 'pages/websocket' })
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}