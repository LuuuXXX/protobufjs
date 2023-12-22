/**
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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

import { describe, expect, it, TestType } from '@ohos/hypium'
import protobuf from '@ohos/protobufjs'
import { Context } from '@ohos.abilityAccessCtrl';
import { GlobalContext } from '../testability/GlobalContext';
import { userLogin } from './Util'

export default function InterfaceTime() {
  describe("InterfaceTime", () => {

    const BASE_COUNT = 2000
    const BASELINE_CREATEHTTP = 2000

    const protoStr: string = 'syntax = "proto3";package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}'

    it("protobuf.loadProto", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let builder = protobuf.newBuilder();
      for (let index = 0; index < BASE_COUNT; index++) {
        protobuf.loadProto(protoStr, builder, "user.proto");
      }
      let endTime = new Date().getTime()
      console.log("protobuf.loadProto:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("protobuf.loadProto:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });

    it("protobuf.newBuilder", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      for (let index = 0; index < BASE_COUNT; index++) {
        protobuf.newBuilder();
      }
      let endTime = new Date().getTime()
      console.log("protobuf.newBuilder:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("protobuf.newBuilder:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });

    it("root.build", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let builder: ESObject = protobuf.newBuilder();
      let root: ESObject = await protobuf.loadProto(protoStr, builder, "user.proto");
      for (let index = 0; index < BASE_COUNT; index++) {
        root.build("com.user.UserLoginResponse");
      }
      let endTime = new Date().getTime()
      console.log("root.build:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("root.build:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });

    it("msg.toArrayBuffer", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let builder = protobuf.newBuilder();
      let root: ESObject = await protobuf.loadProto(protoStr, builder, "user.proto");
      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");
      let msg: ESObject = new UserLoginResponse(userLogin)
      for (let index = 0; index < BASE_COUNT; index++) {
        msg.toArrayBuffer();
      }
      let endTime = new Date().getTime()
      console.log("msg.toArrayBuffer:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("msg.toArrayBuffer:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });

    it("UserLoginResponse.encode", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let builder = protobuf.newBuilder();
      let root: ESObject = await protobuf.loadProto(protoStr, builder, "user.proto");
      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");
      for (let index = 0; index < BASE_COUNT; index++) {
        UserLoginResponse.encode(userLogin);
      }
      let endTime = new Date().getTime()
      console.log("UserLoginResponse.encode:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("UserLoginResponse.encode:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });

    it("UserLoginResponse.decode", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let builder = protobuf.newBuilder();
      let root: ESObject = await protobuf.loadProto(protoStr, builder, "user.proto");
      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");
      let msg: ESObject = new UserLoginResponse(userLogin)
      for (let index = 0; index < BASE_COUNT; index++) {
        UserLoginResponse.decode(msg.toArrayBuffer());
      }
      let endTime = new Date().getTime()
      console.log("UserLoginResponse.decode:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("UserLoginResponse.decode:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });

    it("builder.build", TestType.PERFORMANCE, async (done: Function) => {
      let startTime = new Date().getTime()
      let context: Context = GlobalContext.getContext().getObject("context") as Context;
      let builder: ESObject = await protobuf.loadProtoFile("example1.proto", null, null, context.resourceManager);
      for (let index = 0; index < BASE_COUNT; index++) {
        builder.build("Test1");
      }
      let endTime = new Date().getTime()
      console.log("builder.build:" + endTime);
      let averageTime = ((endTime - startTime) * 1000) / BASE_COUNT
      console.log("builder.build:" + averageTime + "μs");
      expect(averageTime < BASELINE_CREATEHTTP).assertTrue();
      done()
    });
  });
}