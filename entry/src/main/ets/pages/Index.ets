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
import hilog from '@ohos.hilog';

import { Util } from "./Util";
import { GlobalContext } from '../entryability/GlobalContext';

@Entry
@Component
struct Index {
  @State bufferData: string = "";
  @State decodeData: string = "";
  private TAG: string = 'protobuf'
  private protoStr: string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';
  private util: Util = new Util()

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
              this.bufferData = await this.util.loadProtoBufferData(this.protoStr, "user.proto")
              this.decodeData = await this.util.loadProtoMsg(this.protoStr, "user.proto")
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
              this.bufferData = await this.util.loadJsonBufferData("user.json")
              this.decodeData = await this.util.loadJsonMsg("user.json")
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.bufferData = await this.util.loadJsonFileBufferData("user.json", context.resourceManager)
              this.decodeData = await this.util.loadJsonFileMsg("user.json", context.resourceManager)
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.bufferData = await this.util.loadProtoFileBufferData('userproto.proto', context.resourceManager)
              this.decodeData = await this.util.loadProtoFileMsg('userproto.proto', context.resourceManager)
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.bufferData = await this.util.importLoadProtoFileBufferData('imports.proto', context.resourceManager)
              this.decodeData = await this.util.importLoadProtoFileMsg('imports.proto', context.resourceManager)
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.bufferData = await this.util.innerLoadProtoFileBufferData('inner.proto', context.resourceManager)
              this.decodeData = await this.util.innerLoadProtoFileMsg('inner.proto', context.resourceManager)
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.util.loadProtoFileCallBack('userproto.proto', context.resourceManager, (bufferData: string, decodeData: string) => {
                this.bufferData = bufferData;
                this.decodeData = decodeData;
              })
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.util.importLoadProtoFileCallBack('imports.proto', context.resourceManager, (bufferData: string, decodeData: string) => {
                this.bufferData = bufferData;
                this.decodeData = decodeData;
              })
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
              let context: Context = GlobalContext.getContext().getObject("context") as Context;
              this.util.innerLoadProtoFileCallBack('inner.proto', context.resourceManager, (bufferData: string, decodeData: string) => {
                this.bufferData = bufferData;
                this.decodeData = decodeData;
              })
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
}