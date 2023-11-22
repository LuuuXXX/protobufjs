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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import protobuf, { ByteBuffer, Long } from '@ohos/protobufjs'
import { GlobalContext } from '../TestAbility/GlobalContext'
import {
  getResult,
  protoJson,
  mapInt64Value,
  mapInt32Value,
  rawValue,
  vendorValue,
  floatValue,
  inTolerance
} from './Util'

const protoStr: string = 'syntax = "proto3"; package com.user;message UserLoginResponse{string sessionId = 1;string userPrivilege = 2;bool isTokenType = 3;string formatTimestamp = 4;}';

export default function serializedTest() {
  describe('protobufTest', () => {
    it('testLoadProtoInterface', 0, async () => {
      let builder: ESObject = protobuf.newBuilder();
      let root: ESObject = await protobuf.loadProto(protoStr, builder, "user.proto");

      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");

      const userLogin: UserLogin = {
        sessionId: "testSynchronouslyLoadProtoFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      let msg: ESObject = new UserLoginResponse(userLogin);
      let arrayBuffer: ArrayBuffer = msg.toArrayBuffer();

      let encodeMsg: ESObject = UserLoginResponse.encode(userLogin);
      expect(new Uint8Array(arrayBuffer) + '')
        .assertEqual(new Uint8Array(encodeMsg.toBuffer()) + '');
      expect(msg.encode().toBuffer() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encodeAB() + '').assertEqual(encodeMsg.toArrayBuffer() + '');
      expect(msg.encodeNB() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encode64() + '').assertEqual(encodeMsg.toBase64() + '');
      expect(msg.encodeHex() + '').assertEqual(encodeMsg.toHex() + '');
      expect(msg.calculate()).assertEqual(51);
      expect(msg.encodeJSON())
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(msg.toRaw(true, true)))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}');
      expect(JSON.stringify(UserLoginResponse.decode64(msg.encode64())))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeHex(msg.encodeHex())))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeJSON(msg.encodeJSON())))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')

      let decodeMsg: ESObject = UserLoginResponse.decode(arrayBuffer);
      expect(decodeMsg.sessionId).assertContain("testSynchronouslyLoadProtoFile")
      expect(decodeMsg.userPrivilege).assertContain("John123")
      expect(decodeMsg.isTokenType).assertFalse()
      expect(decodeMsg.formatTimestamp).assertContain("12342222")
    })

    it('testLoadProtoFile', 0, async () => {
      let builder: ESObject = protobuf.newBuilder();
      let context: Context = GlobalContext.getContext().getObject("context") as Context;
      let root: ESObject = await protobuf.loadProtoFile('userproto.proto', null, builder, context.resourceManager);
      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");

      const userLogin: UserLogin = {
        sessionId: "testSynchronouslyLoadProtoFile",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      let msg: ESObject = new UserLoginResponse(userLogin);
      let arrayBuffer: ArrayBuffer = msg.toArrayBuffer();
      let encodeMsg: ESObject = UserLoginResponse.encode(userLogin);
      expect(new Uint8Array(arrayBuffer) + '')
        .assertEqual(new Uint8Array(encodeMsg.toBuffer()) + '');
      expect(msg.encode().toBuffer() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encodeAB() + '').assertEqual(encodeMsg.toArrayBuffer() + '');
      expect(msg.encodeNB() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encode64() + '').assertEqual(encodeMsg.toBase64() + '');
      expect(msg.encodeHex() + '').assertEqual(encodeMsg.toHex() + '');
      expect(msg.calculate()).assertEqual(51);
      expect(msg.encodeJSON())
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(msg.toRaw(true, true)))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}');
      expect(JSON.stringify(UserLoginResponse.decode64(msg.encode64())))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeHex(msg.encodeHex())))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeJSON(msg.encodeJSON())))
        .assertEqual('{"sessionId":"testSynchronouslyLoadProtoFile","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')

      let decodeMsg: ESObject = UserLoginResponse.decode(arrayBuffer);
      expect(decodeMsg.sessionId).assertContain("testSynchronouslyLoadProtoFile")
      expect(decodeMsg.userPrivilege).assertContain("John123")
      expect(decodeMsg.isTokenType).assertFalse()
      expect(decodeMsg.formatTimestamp).assertContain("12342222")
    })

    it('testLoadJsonInterface', 0, async () => {
      let builder: ESObject = protobuf.newBuilder();
      let root: ESObject = await protobuf.loadJson(protoJson, builder, "user.json");
      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");

      const userLogin: UserLogin = {
        sessionId: "testMethodLoadProto",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      let msg: ESObject = new UserLoginResponse(userLogin);
      let arrayBuffer: ArrayBuffer = msg.toArrayBuffer();
      let encodeMsg: ESObject = UserLoginResponse.encode(userLogin);
      expect(new Uint8Array(arrayBuffer) + '')
        .assertEqual(new Uint8Array(encodeMsg.toBuffer()) + '');
      expect(msg.encode().toBuffer() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encodeAB() + '').assertEqual(encodeMsg.toArrayBuffer() + '');
      expect(msg.encodeNB() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encode64() + '').assertEqual(encodeMsg.toBase64() + '');
      expect(msg.encodeHex() + '').assertEqual(encodeMsg.toHex() + '');
      expect(msg.calculate()).assertEqual(40);
      expect(msg.encodeJSON())
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(msg.toRaw(true, true)))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}');
      expect(JSON.stringify(UserLoginResponse.decode64(msg.encode64())))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeHex(msg.encodeHex())))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeJSON(msg.encodeJSON())))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')

      let decodeMsg: ESObject = UserLoginResponse.decode(arrayBuffer);
      expect(decodeMsg.sessionId).assertContain("testMethodLoadProto")
      expect(decodeMsg.userPrivilege).assertContain("John123")
      expect(decodeMsg.isTokenType).assertFalse()
      expect(decodeMsg.formatTimestamp).assertContain("12342222")
    })

    it('testLoadJsonFile', 0, async () => {
      let builder: ESObject = protobuf.newBuilder();
      let context: Context = GlobalContext.getContext().getObject("context") as Context;
      let root: ESObject = await protobuf.loadJsonFile('userproto.json', null, builder, context.resourceManager);
      let UserLoginResponse: ESObject = root.build("com.user.UserLoginResponse");

      const userLogin: UserLogin = {
        sessionId: "testMethodLoadProto",
        userPrivilege: "John123",
        isTokenType: false,
        formatTimestamp: "12342222"
      };

      let msg: ESObject = new UserLoginResponse(userLogin);
      let arrayBuffer: ArrayBuffer = msg.toArrayBuffer();
      let encodeMsg: ESObject = UserLoginResponse.encode(userLogin);
      expect(new Uint8Array(arrayBuffer) + '')
        .assertEqual(new Uint8Array(encodeMsg.toBuffer()) + '');
      expect(msg.encode().toBuffer() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encodeAB() + '').assertEqual(encodeMsg.toArrayBuffer() + '');
      expect(msg.encodeNB() + '').assertEqual(encodeMsg.toBuffer() + '');
      expect(msg.encode64() + '').assertEqual(encodeMsg.toBase64() + '');
      expect(msg.encodeHex() + '').assertEqual(encodeMsg.toHex() + '');
      expect(msg.calculate()).assertEqual(40);
      expect(msg.encodeJSON())
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(msg.toRaw(true, true)))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}');
      expect(JSON.stringify(UserLoginResponse.decode64(msg.encode64())))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeHex(msg.encodeHex())))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')
      expect(JSON.stringify(UserLoginResponse.decodeJSON(msg.encodeJSON())))
        .assertEqual('{"sessionId":"testMethodLoadProto","userPrivilege":"John123","isTokenType":false,"formatTimestamp":"12342222"}')

      let decodeMsg: ESObject = UserLoginResponse.decode(arrayBuffer);
      expect(decodeMsg.sessionId).assertContain("testMethodLoadProto")
      expect(decodeMsg.userPrivilege).assertContain("John123")
      expect(decodeMsg.isTokenType).assertFalse()
      expect(decodeMsg.formatTimestamp).assertContain("12342222")
    })

    it('init', 0, () => {
      for (let i = 0; i < 5; i++) {
        expect(typeof protobuf == "object").assertTrue();
        expect(typeof protobuf.Reflect == "object").assertTrue();

        expect(typeof protobuf.loadProto == "function").assertTrue();
        expect(typeof protobuf.loadProtoFile == "function").assertTrue();
        expect(protobuf.loadProto === protobuf.protoFromString).assertTrue();
        expect(protobuf.loadProtoFile === protobuf.protoFromFile).assertTrue();
        let byteBuffer: ESObject = protobuf.ByteBuffer;
        expect(!!byteBuffer).assertTrue();
      }
    })

    it('example1', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example1.proto", null, null, context.resourceManager);
        let Test1: ESObject = builder.build("Test1");
        expect(typeof Test1 == 'function').assertTrue();
        let inst: ESObject = new Test1(150);
        expect(inst instanceof protobuf.Builder.Message).assertTrue();
        expect(inst.a).assertEqual(150);
        expect(inst.getA()).assertEqual(150);
        expect(inst.get_a()).assertEqual(150);
        inst.setA(151);
        expect(inst.a).assertEqual(151);
        expect(inst.getA()).assertEqual(151);
        expect(inst.get_a()).assertEqual(151);
        inst.set_a(152);
        expect(inst.a).assertEqual(152);
        expect(inst.toString()).assertEqual(".Test1");
        try {
          (() => {
            inst.setA(null); // required
          })();
        } catch (error) {
          expect(!!error).assertTrue();
        }
        try {
          (() => {
            inst.setA([]); // required
          })();
        } catch (error) {
          expect(!!error).assertTrue();
        }
        let size: number = inst.calculate();
        let bb: ByteBuffer = new ByteBuffer(3);
        inst.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<08 98 01>");
        let instDec: ESObject = Test1.decode(bb);
        expect(instDec.a).assertEqual(152);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('example1u', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example1u.proto", null, null, context.resourceManager);
        let Test1u: ESObject = builder.build("Test1u");
        expect(typeof Test1u == 'function').assertTrue();
        let inst: ESObject = new Test1u(-1);
        expect(inst.a === 4294967295).assertTrue();
        let bb: ByteBuffer = new ByteBuffer(6);
        let size: number = inst.calculate();
        inst.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<08 FF FF FF FF 0F>");
        let instDec: ESObject = Test1u.decode(bb);
        expect(instDec.a === 4294967295).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('example2', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example2.proto", null, null, context.resourceManager);
        let Test2: ESObject = builder.build("Test2");
        let inst: ESObject = new Test2("testing");
        let bb: ByteBuffer = new ByteBuffer(9);
        let size: number = inst.calculate();
        inst.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<12 07 74 65 73 74 69 6E 67>");
        let instDec: ESObject = Test2.decode(bb);
        expect(instDec.b).assertEqual("testing");
      } catch (e) {
        expect().assertFail();
      }
    })

    it('example3', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example3.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build();
        let Test1: ESObject = root.Test1;
        let Test3: ESObject = root.Test3;
        let inst: ESObject = new Test3(new Test1(150));
        let bb: ByteBuffer = new ByteBuffer(5);
        expect(inst.c.a).assertEqual(150);
        let size: number = inst.calculate();
        inst.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<1A 03 08 96 01>");
        let instDec: ESObject = Test3.decode(bb);
        expect(instDec.c.a).assertEqual(150);
      } catch (e) {
        console.info('---------------example3: ' + e)
        expect().assertFail();
      }
    })

    it('example4', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example4.proto", null, null, context.resourceManager);
        let Test4: ESObject = builder.build("Test4");
        let inst: ESObject = new Test4([3, 270, 86942]);
        let bb: ByteBuffer = new ByteBuffer(8);
        expect(inst.d.length).assertEqual(3);
        let size: number = inst.calculate();
        inst.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<22 06 03 8E 02 9E A7 05>");
        let instDec: ESObject = Test4.decode(bb);
        expect(bb.toString("debug")).assertEqual("22 06 03 8E 02 9E A7 05|");
        expect(instDec.d.length).assertEqual(3);
        expect(instDec.d[2]).assertEqual(86942);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('example5', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example5.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build();
        expect(!!root).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('constructor', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example1.proto", null, null, context.resourceManager);
        let Test1: ESObject = builder.build("Test1");
        let t2Value: T2 = {
          a: 123
        }
        let t1: ESObject = new Test1(123),
          t2: ESObject = new Test1(t2Value),
          t3: ESObject = new Test1(t1);
        expect(t1).assertDeepEquals(t2);
        expect(t2).assertDeepEquals(t3);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('constructorWithOneofs', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("oneof.proto", null, null, context.resourceManager);
        let MyOneOf: ESObject = builder.build("MyOneOf");
        let TOneOf: ESObject = builder.lookup(".MyOneOf");
        expect(TOneOf.getChild("my_oneof").name).assertEqual('my_oneof');

        let myOneOf: ESObject = new MyOneOf();
        expect(myOneOf.my_oneof === null).assertTrue();
        myOneOf.set("id", 1);
        expect(myOneOf.my_oneof === "id").assertTrue();
        myOneOf.set("name", "me");
        expect(myOneOf.my_oneof === "name").assertTrue();
        expect(myOneOf.id === null).assertTrue();

        let copy: ESObject = new MyOneOf(myOneOf); // this line is what was failing
        // Error: .MyOneOf#my_oneof is not a field: undefined

        expect(myOneOf).assertDeepEquals(copy);

        // Test same things are there
        expect(copy.my_oneof === "name").assertTrue();
        expect(copy.name === "me").assertTrue();
        expect(copy.id === null).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('numberFormats', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("numberformats.proto", null, null, context.resourceManager);
        let Formats: ESObject = builder.build("Formats");
        expect(Formats.DEC === 1).assertTrue();
        expect(Formats.HEX === 31).assertTrue();
        expect(Formats.OCT === 15).assertTrue();
        let Msg: ESObject = builder.build("Msg");
        let msg: ESObject = new Msg();
        expect(msg.dec === -1).assertTrue();
        expect(msg.hex === -31).assertTrue();
        expect(msg.hexUC === 521).assertTrue();
        expect(msg.oct === -15).assertTrue();
        expect(msg.exp === 0.1e5).assertTrue();
        expect(msg.nod === 1.).assertTrue();
        expect(msg.exn === 1e8).assertTrue();
        expect(msg.sp1 === Number.POSITIVE_INFINITY).assertTrue();
        expect(msg.sp2 === Number.NEGATIVE_INFINITY).assertTrue();
        expect(Number.isNaN(msg.sp3)).assertTrue()
      } catch (e) {
        expect().assertFail();
      }
    })

    it('float', 0, async () => {
      try {
        let str_proto = "message Float {"
          + " required float f = 1;"
          + "}";
        let builder: ESObject = await protobuf.loadProto(str_proto);
        let root: ESObject = builder.build();
        let Float: ESObject = root.Float;


        let f_vals = floatValue;

        f_vals.map((x) => {
          // check encode
          let m1: ESObject = new Float();
          let b1: ByteBuffer = new ByteBuffer();
          m1.f = x.f;
          m1.encode(b1);
          let q1 = b1.slice(1, 5).compact().reverse();
          expect('<' + x.b + '>' === q1.toString("debug")).assertTrue();

          // check decode
          let b2: ByteBuffer = new ByteBuffer();
          let s1 = x.b + ' 0D';
          let s2 = s1.split(" ");
          let s3 = s2.reverse();
          let i1 = s3.map((y) => {
            return Number(Number(y).toString(16))
          });
          i1.map((y) => {
            if (!Number.isNaN(y)) {
              b2.writeUint8(y)
            }
          });
          b2.limit = b2.offset;
          b2.offset = 0;
          // let m2: ESObject = root.Float.decode(b2);
          // if (Number.isNaN(x.f)) {
          //   expect(Number.isNaN(m2.f)).assertTrue();
          // }
          // else if (!Number.isFinite(x.f)) {
          //   expect(x.f === m2.f).assertTrue();
          // }
          // else {
          //   expect(inTolerance(x.f, m2.f)).assertTrue();
          // }
        });
      } catch (e) {
        expect().assertFail();
      }
    })

    it('bytes', 0, async () => {
      try {
        let str_proto: string = "message Test { required bytes b = 1; }";
        let builder: ESObject = await protobuf.loadProto(str_proto);
        let Test: ESObject = builder.build("Test");
        let bb: ByteBuffer = new ByteBuffer(4).writeUint32(0x12345678).flip();
        let myTest: ESObject = new Test(bb);
        expect(myTest.b.buffer === bb.buffer).assertTrue();
        let bb2: ByteBuffer = new ByteBuffer(6);
        let size: number = myTest.calculate();
        myTest.encode(bb2);
        expect(bb2.offset === size).assertTrue();
        expect(bb2.flip().toString("debug")).assertEqual("<0A 04 12 34 56 78>");
        myTest = Test.decode(bb2);
        expect(myTest.b.BE().readUint32()).assertEqual(0x12345678);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('bytesFromFile', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Image { required bytes data = 1; }");
        let Image: ESObject = builder.build("Image")
        let resource: ResourceValue = {
          bundleName: "com.protobufjs",
          moduleName: "entry",
          id: $r('app.media.icon').id
        };
        try {
          let context: Context = GlobalContext.getContext().getObject("context") as Context;
          let imageData: ESObject = await context.resourceManager.getMediaContent(resource);
          console.info('--------------------imageData: ' + imageData)
          console.info('--------------------imageData2: ' + imageData)
          let imageDataBuffer: ImageDataBuffer = {
            data: imageData.buffer
          }
          let image: ESObject = new Image(imageDataBuffer);
          let bb: ESObject = image.encode();
          // let imageDec = Image.decode(bb);
          // let dataDec = imageDec.data.toBuffer();
          // expect(imageData.length === dataDec.length).assertTrue();
          // expect(imageData).assertDeepEquals(dataDec);
        } catch (error) {
          console.error(`promise getMediaContent failed, error code: ${error.code}, message: ${error.message}.`)
        }

      } catch (e) {
        console.info('------------------------e: ' + e)
        expect().assertFail();
      }
    })
    it('notEnoughBytes', 0, async () => {
      let builder: ESObject = await protobuf.loadProto("message Test { required bytes b = 1; }");
      let Test: ESObject = builder.build("Test");
      let bb: ESObject = new ByteBuffer().writeUint32(0x12345678).flip();
      let encoded: ByteBuffer = new ByteBuffer(6);
      new Test(bb).encode(encoded);
      expect(encoded.flip().toString("debug")).assertEqual("<0A 04 12 34 56 78>");
      encoded = encoded.slice(0, 5); // chop off the last byte
      let err: Error = new Error();
      try {
        Test.decode(encoded);
      } catch (caught) {
        err = caught;
      }
      expect(err && err.message && err.message.indexOf(": 4 required but got only 3") >= 0).assertTrue();
    })

    it('bool', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Test { optional bool ok = 1 [ default = false ]; }"),
          Test: ESObject = builder.build("Test"),
          t: ESObject = new Test();
        expect(t.ok === null).assertTrue(); // Not set as it is optional
        t.setOk(true);
        expect(t.ok === true).assertTrue();
        expect(Test.decode(t.encode()).ok === true).assertTrue();
        t.setOk(false);
        expect(t.ok === false).assertTrue();
        t.setOk(null); // Not set
        expect(Test.decode(t.encode()).ok === false).assertTrue(); // = default when missing
      } catch (err) {
        expect().assertFail();
      }
    })

    it('T139', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("T139.proto", null, null, context.resourceManager);
        let T139: ESObject = builder.build("T139");
        expect(typeof T139 == 'function').assertTrue();
        let inst: ESObject = new T139(139, 139);
        expect(inst.a).assertEqual(139);
        expect(inst.b).assertEqual(139);
        inst.setA(139);
        inst.setB(139);
        expect(inst.a).assertEqual(139);
        expect(inst.b).assertEqual(139);
        let bb: ESObject = new ByteBuffer(3);
        inst.encode(bb);
        expect(bb.flip().toString("debug")).assertEqual("<08 8B 01 10 8B 01>");
        let instDec: ESObject = T139.decode(bb);
        expect(instDec.a).assertEqual(139);
        expect(instDec.b).assertEqual(139);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('emptyDefaultString', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Test1 { required string test = 1 [default = \"\"]; }");
        let Test1: ESObject = builder.build("Test1");
        let test1: ESObject = new Test1();
        expect(test1.test === "").assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('trailingSemicolon', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Test1 { optional string test = 1; };");
        let Test1: ESObject = builder.build("Test1");
        expect(!!Test1).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('inner_longstr', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Test { required Inner a = 1; message Inner { required string b = 1; } }");
        let Test: ESObject = builder.build("Test");
        let t: ESObject = new Test();
        let data: string = "0123456789"; // 10: 20, 40, 80, 160, 320 bytes
        for (let i = 0; i < 5; i++) data += data;
        expect(data.length).assertEqual(320);
        t.a = new Test.Inner(data);
        let bb: ESObject = t.encode();
        let t2: ESObject = Test.decode(bb);
        expect(t2.a.b.length).assertEqual(320);
        expect(data).assertEqual(t2.a.b);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('inner_multiple', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let str: string = "";
        for (let i = 0; i < 200; i++) str += 'a';
        let builder: ESObject = await protobuf.loadProtoFile("inner.proto", null, null, context.resourceManager);
        let fooCls: ESObject = builder.build("Foo");
        let barCls: ESObject = builder.build("Bar");
        let bazCls: ESObject = builder.build("Baz");
        let foo: ESObject = new fooCls(new barCls(str), new bazCls(str));
        let fooEncoded: ESObject = foo.encode();
        fooCls.decode(fooEncoded);
        expect().not().assertFail();
      } catch (e) {
        expect().assertFail();
      }
    })


    it('inner_float', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Foo { required Bar bar = 1; } message Bar { required float baz = 1; }");
        let root: ESObject = builder.build();
        let foo: ESObject = new root.Foo(new root.Bar(4));
        let bb: ESObject = foo.encode();
        let foo2: ESObject = root.Foo.decode(bb);
        expect(foo.bar.baz).assertEqual(4);
        expect(foo2.bar.baz).assertEqual(foo.bar.baz);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('truncated', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Test { required int32 a = 1; required int32 b = 2; }");
        let Test: ESObject = builder.build("Test");
        let t: ESObject = new Test(), bb: ByteBuffer = new ByteBuffer(2);
        t.setA(1);
        try {
          bb = t.encode(bb).flip();
        } catch (e) {
          let encoded: ESObject = e.encoded
          expect(!!encoded).assertTrue();
          bb = e.encoded.flip();
          expect(bb.toString("debug")).assertEqual("<08 01>");
        }
        let t2: ESObject;
        try /* to decode truncated message */
        {
          t2 = Test.decode(bb);
        } catch (e) {
          // But still be able to access the rest
          let t3: ESObject = e.decoded;
          expect(t3.a === 1).assertTrue();
          expect(t3.b === null).assertTrue();
        }
        expect(t2 === undefined).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('options_parse', 0, async () => {
      try {
        let value: ESObject = await protobuf.Util.fetch("options.proto");
        let parser: ESObject = new protobuf.DotProto.Parser(value);
        let root: ESObject = parser.parse();
        expect(root["package"]).assertEqual("My");
        expect(root["options"]["(toplevel_1)"] === 10).assertTrue();
        expect(root["options"]["(toplevel_2)"]).assertEqual("Hello world!");
        let opt: ESObject = root["messages"][0]["fields"][0]["options"];
        expect(opt["default"]).assertEqual("Max");
        opt = root["messages"][0]["options"];
        expect(opt["(inmessage)"] === "My.Test").assertTrue();
        expect(opt["(foo.my_option).bar"] === false).assertTrue();
        opt = root["messages"][0]["fields"][1]["options"];
        expect(opt["default"] === "Shouldn't mix quotes").assertTrue();
        opt = root["messages"][0]["fields"][2]["options"];
        expect(opt["default"] === 'Shouldn"t mix quotes').assertTrue();
        opt = root["messages"][0]["fields"][3]["options"];
        expect(opt["(foo_options).opt1"] === 123).assertTrue();
        expect(opt["(foo_options).opt2"] === "baz").assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('options_export', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("options.proto", null, null, context.resourceManager);
        let My: ESObject = builder.build("My");
        expect(My.$options).assertDeepEquals({
          "(toplevel_1)": 10,
          "(toplevel_2)": "Hello world!"
        });
        expect(My.$options['(toplevel_1)'] === 10).assertTrue();
        expect(My.Test.$options).assertDeepEquals({
          "(inmessage)": "My.Test",
          "(foo.my_option).bar": false
        });
      } catch (e) {
        expect().assertFail();
      }
    })

    it('comments', 0, async () => {
      try {
        let value: ESObject = await protobuf.Util.fetch('comments.proto');
        let tn: ESObject = new protobuf.DotProto.Tokenizer(value);
        let token: ESObject, tokens: Array<ESObject> = [];
        do {
          token = tn.next();
          tokens.push(token);
        } while (token !== null);
        expect(tokens).assertDeepEquals(['message', 'TestC', '{', 'required', 'int32', 'a', '=', '1', ';', '}', null]);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('complexProto', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("complex.proto", null, null, context.resourceManager);
        validateComplex(builder.build("Game"));
        let TCars: ESObject = builder.lookup("Game.Cars");
        expect(TCars.fqn() === ".Game.Cars").assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('complexJSON', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadJsonFile("complex.json", null, null, context.resourceManager);
        validateComplex(builder.build("Game"));
      } catch (e) {
        console.info('----------------------json: ' + e)
        expect().assertFail();
      }
    })

    it('errorMessage', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadJsonFile("complex.json", null, null, context.resourceManager);
        let Game: ESObject = builder.build("Game");
        let car: ESObject = new Game.Cars.Car();
        car.speed = "hello";
        car.encode();
      } catch (e) {
        expect(!!e).assertTrue();
      }
    })

    it('multiBuilder', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("example1.proto", null, null, context.resourceManager);
        await protobuf.loadProtoFile("example2.proto", builder, null, context.resourceManager);
        let ns: ESObject = builder.build();
        let Test1: ESObject = ns.Test1;
        let Test2: ESObject = ns.Test2;
        expect(!!Test1).assertTrue();
        expect(!!Test2).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('inner', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("repeated.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build(),
          Outer: ESObject = root.Outer,
          Inner: ESObject = root.Inner;
        // Empty
        let outer: ESObject = new Outer();
        let bb: ByteBuffer = new ByteBuffer(1).fill(0).flip();
        outer.encode(bb);
        expect(bb.flip().toString("debug")).assertEqual("|00");
        let douter: ESObject = Outer.decode(bb);
        expect(douter.inner instanceof Array).assertTrue();
        expect(douter.inner.length).assertEqual(0);
        let outerInner: OuterInner = {
          inner: [new Inner(1), new Inner(2)]
        }
        // Multiple
        outer = new Outer(outerInner);
        bb = new ByteBuffer(8);
        let size: number = outer.calculate();
        outer.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<0A 02 08 01 0A 02 08 02>");
        douter = Outer.decode(bb);
        expect(douter.inner instanceof Array).assertTrue();
        expect(douter.inner.length).assertEqual(2);
        expect(douter.inner[0].inner_value).assertEqual(1);
        expect(douter.inner[1].inner_value).assertEqual(2);
      } catch (e) {
        expect(!!e).assertTrue();
      }
    })

    it('packed', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("packed.proto", null, null, context.resourceManager);
        let Message: ESObject = builder.build("Message");
        // Both empty
        let message: ESObject = new Message();
        let bb: ByteBuffer = new ByteBuffer(1).fill(0).flip();
        let size: number = message.calculate();
        message.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("|00");
        message = Message.decode(bb);
        expect(message.a instanceof Array).assertTrue();
        expect(message.a.length).assertEqual(0);
        expect(message.b instanceof Array).assertTrue();
        expect(message.b.length).assertEqual(0);
        // Both non-empty
        message = new Message([1, 2, 3], [1, 2, 3]);
        size = message.calculate();
        message.encode(bb.resize(11));
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<0A 03 01 02 03 10 01 10 02 10 03>");
        message = Message.decode(bb);
        expect(message.a instanceof Array).assertTrue();
        expect(message.a.length).assertEqual(3);
        expect(message.a).assertDeepEquals([1, 2, 3]);
        expect(message.b instanceof Array).assertTrue();
        expect(message.b.length).assertEqual(3);
        expect(message.b).assertDeepEquals([1, 2, 3]);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('groups', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("groups.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build();
        let Outer: ESObject = root.Outer;
        let TOuter: ESObject = builder.ns.getChild("Outer");
        let TInner: ESObject = TOuter.getChild("MyInner");
        let reflectMessage: ESObject = protobuf.Reflect.Message;
        expect(TInner instanceof reflectMessage).assertTrue();
        expect(TInner.isGroup === true).assertTrue();
        let Tinner: ESObject = TOuter.getChild("myinner");
        expect(Tinner instanceof reflectMessage.Field).assertTrue();
        expect(Tinner.id === 2).assertTrue();
        expect(Tinner.options).assertDeepEquals({
          "deprecated": true
        });
        let Inner: ESObject = root.Outer.MyInner;
        let outer: ESObject = new Outer("a", [new Inner("hello")], "b", new Inner("world"));
        let bb: ByteBuffer = new ByteBuffer();
        let size: number = outer.calculate();
        outer.encode(bb);
        expect(bb.offset === size).assertTrue();
        bb.flip().compact();
        let wiredMsg = [
          "0A", // 1|010 = id 1, wire type 2 (ldelim)
          "01", // length 1
          "61", // "a"
          "13", // 10|011 = id 2, wire type 3 (start group)
          "1A", // 11|010 = id 3, wire type 2 (ldelim)
          "05", // length 5
          "68 65 6C 6C 6F", // "hello"
          "14", // 10|100 = id 2, wire type 4 (end group)
          "22", // 100|010 = id 4, wire type 2 (ldelim)
          "01", // length 1
          "62", // "b"
          "2B", // 101|011 = id 5, wire type = 3 (start group)
          "1A", // 11|010 = id 3, wire type = 2 (ldelim)
          "05", // length 5
          "77 6F 72 6C 64", // "world"
          "2C"// 101|100 = id 5, wire type = 4 (end group)
        ];
        expect(bb.toString("debug")).assertEqual("<" + wiredMsg.join(" ") + ">");
        let douter: ESObject = Outer.decode(bb);
        expect(douter.before === "a").assertTrue();
        expect(douter.myinner.length === 1).assertTrue();
        expect(douter.myinner[0].a === "hello").assertTrue();
        expect(douter.after === "b").assertTrue();
        bb.offset = 0;
        douter = root.OuterSparse.decode(bb);
        expect(bb.offset === bb.limit).assertTrue();
        expect(douter.before === "a").assertTrue();
        expect(douter.after === "b").assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('x64Fixed', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("x64.proto", null, null, context.resourceManager);
        let Test: ESObject = builder.build("Test");
        let myTest: ESObject = new Test();
        expect(myTest.val instanceof Long).assertTrue();
        expect(myTest.val.unsigned).assertEqual(false);
        expect(myTest.val.toNumber()).assertEqual(-1);
        expect(myTest.uval instanceof Long).assertTrue();
        expect(myTest.uval.unsigned).assertEqual(true);
        expect(myTest.uval.toNumber()).assertEqual(1);
        myTest.setVal(-2);
        myTest.setUval(2);
        let bb: ByteBuffer = new ByteBuffer(18); // 2x tag + 2x 64bit
        let size: number = myTest.calculate();
        myTest.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<09 FE FF FF FF FF FF FF FF 11 02 00 00 00 00 00 00 00>");
        //                         ^ wireType=1, id=1         ^ wireType=1, id=2
        myTest = Test.decode(bb);
        expect(myTest.val instanceof Long).assertTrue();
        expect(myTest.val.unsigned).assertEqual(false);
        expect(myTest.val.toNumber()).assertEqual(-2);
        expect(myTest.uval instanceof Long).assertTrue();
        expect(myTest.uval.unsigned).assertEqual(true);
        expect(myTest.uval.toNumber()).assertEqual(2);
      } catch (e) {
        expect().assertFail();
      }

    })


    it('x64Varint', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("x64.proto", null, null, context.resourceManager);
        let Test: ESObject = builder.build("Test2");
        let myTest: ESObject = new Test();
        expect(myTest.val instanceof Long).assertTrue();
        expect(myTest.val.unsigned).assertEqual(false);
        expect(myTest.val.toNumber()).assertEqual(-1);
        expect(myTest.uval instanceof Long).assertTrue();
        expect(myTest.uval.unsigned).assertEqual(true);
        expect(myTest.uval.toNumber()).assertEqual(1);
        expect(myTest.sval instanceof Long).assertTrue();
        expect(myTest.sval.unsigned).assertEqual(false);
        expect(myTest.sval.toNumber()).assertEqual(-2);

        myTest.setVal(-2);
        myTest.setUval(2);
        myTest.setSval(-3);
        let bb: ByteBuffer = new ByteBuffer(3 + 10 + 2); // 3x tag + 1x varint 10byte + 2x varint 1byte
        let size: number = myTest.calculate();
        myTest.encode(bb);
        expect(bb.offset === size).assertTrue();
        expect(bb.flip().toString("debug")).assertEqual("<08 FE FF FF FF FF FF FF FF FF 01 10 02 18 05>");
        // 08: wireType=0, id=1, 18: wireType=0, id=2, ?: wireType=0, id=3
        myTest = Test.decode(bb);
        expect(myTest.val instanceof Long).assertTrue();
        expect(myTest.val.unsigned).assertEqual(false);
        expect(myTest.val.toNumber()).assertEqual(-2);
        expect(myTest.uval instanceof Long).assertTrue();
        expect(myTest.uval.unsigned).assertEqual(true);
        expect(myTest.uval.toNumber()).assertEqual(2);
        expect(myTest.sval instanceof Long).assertTrue();
        expect(myTest.sval.unsigned).assertEqual(false);
        expect(myTest.sval.toNumber()).assertEqual(-3);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('keywords', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Reserved { optional string get = 1; }");
        let My: ESObject = builder.build();
        let myTest: ESObject = new My.Reserved("a");
        let encode: ESObject = myTest.encode();
        expect(!!encode).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('imports', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("imports.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build();
        let Test1: ESObject = root.Test1;
        let Test2: ESObject = root.Test2;
        let MyTest3: ESObject = root.My.Test3;
        expect(!!Test1).assertTrue();
        expect(!!Test2).assertTrue();
        expect(!!MyTest3).assertTrue();
        expect(root.Test2).not().assertEqual(root.My.Test2);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('weakImports', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("imports-weak.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build();
        expect(!!root).assertTrue();
      } catch (e) {
        expect(e.message.indexOf("unresolvable type reference") >= 0).assertTrue();
        return;
      }
      let e: Error = new Error("Weak import was imported.");
      expect().assertFail();
    })


    it('importExtensions', 0, async () => {
      let x: string = `package x; \
            message Test { \
                extensions 1 to 10; \
            } \
            extend Test { \
                optional int32 first_val = 1; \
            }`;
      let y: string = `package y; \
            extend x.Test { \
                optional int32 second_val = 2; \
            }`;
      let builder: ESObject = protobuf.newBuilder();
      await protobuf.loadProto(x, builder);
      await protobuf.loadProto(y, builder);
      let Test: ESObject = builder.build('x.Test');
      let inst: ESObject = new Test();
      expect(inst[".x.first_val"] === null).assertTrue();
      expect(inst[".y.second_val"] === null).assertTrue();
    })

    it('toplevel', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("toplevel.proto", null, null, context.resourceManager);
        let My: ESObject = builder.build("My");
        let MyEnum: ESObject = My.MyEnum;
        let ONE: ESObject = My.MyEnum.ONE;
        let TWO: ESObject = My.MyEnum.TWO;
        let Test: ESObject = My.Test;
        expect(!!MyEnum).assertTrue();
        expect(ONE).assertEqual(1);
        expect(TWO).assertEqual(2);
        expect(!!Test).assertTrue();
        let myTest: ESObject = new My.Test();
        expect(myTest.num).assertEqual(My.MyEnum.ONE);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('importsToplevel', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("imports-toplevel.proto", null, null, context.resourceManager);
        let My: ESObject = builder.build("My");
        let MyEnum: ESObject = My.MyEnum;
        let ONE: ESObject = My.MyEnum1.ONE;
        let TWO: ESObject = My.MyEnum1.TWO;
        let Test1: ESObject = My.Test1;
        expect(!!MyEnum).assertTrue();
        expect(ONE).assertEqual(1);
        expect(TWO).assertEqual(2);
        expect(!!Test1).assertTrue();
        let myTest: ESObject = new My.Test1();
        expect(myTest.num).assertEqual(My.MyEnum.ONE);
        expect(myTest.num1).assertEqual(My.MyEnum1.ONE);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('importDuplicate', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("import_a.proto", null, null, context.resourceManager);
        await protobuf.loadProtoFile("import_b.proto", builder, null, context.resourceManager);
        let root: ESObject = builder.build();
        let A: ESObject = root.A;
        let B: ESObject = root.B;
        let Common: ESObject = root.Common;
        expect(!!A).assertTrue();
        expect(!!B).assertTrue();
        expect(!!Common).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('importDuplicateDifferentBuilder', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builderA: ESObject = await protobuf.loadProtoFile("import_a.proto", null, null, context.resourceManager);
        let builderB: ESObject = await protobuf.loadProtoFile("import_b.proto", null, null, context.resourceManager);

        let rootA: ESObject = builderA.build();
        let rootB: ESObject = builderB.build();
        let A: ESObject = rootA.A;
        let B: ESObject = rootB.B;
        let CommonA: ESObject = rootA.Common;
        let CommonB: ESObject = rootB.Common;
        expect(!!A).assertTrue();
        expect(!!B).assertTrue();
        expect(!!CommonA).assertTrue();
        expect(!!CommonB).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('importRoot', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile({
          root: "importRoot",
          file: "file1.proto"
        }, null, null, context.resourceManager);

        let Test: ESObject = builder.build("Test");
        expect(new Test() instanceof protobuf.Builder.Message).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('extend', 0, async () => {
      try {
        let extendProto: string = `import "google/protobuf/descriptor.proto"; // Ignored
// import "./google/protobuf/descriptor.proto"; // Not ignored

extend google.protobuf.MessageOptions {
  optional int32 foo = 1001;
}

message Foo {
    extensions 2 to max;
}

extend Foo {
    optional string bar = 2;
}

message Bar {
    message Foo {
    }

    extend .Foo {
        optional Foo foo = 3; // references Bar.Foo
    }
}
`;
        let extendObject: ESObject = new protobuf.DotProto.Parser(extendProto);
        let ast: ESObject = extendObject.parse();
        expect(ast).assertDeepEquals({
          package: null,
          messages:
          [{
            ref: 'google.protobuf.MessageOptions',
            fields:
            [{
              rule: 'optional',
              type: 'int32',
              name: 'foo',
              options: {},
              id: 1001
            }]
          },
            {
              name: 'Foo',
              fields: [],
              enums: [],
              messages: [],
              options: {},
              services: [],
              oneofs: {},
              extensions: [[2, 536870911]]
            },
            {
              ref: 'Foo',
              fields:
              [{
                rule: 'optional',
                type: 'string',
                name: 'bar',
                options: {},
                id: 2
              }]
            },
            {
              name: 'Bar',
              fields: [],
              enums: [],
              messages:
              [{
                name: 'Foo',
                fields: [],
                enums: [],
                messages: [],
                options: {},
                services: [],
                oneofs: {}
              },
                {
                  ref: '.Foo',
                  fields: [{
                    rule: 'optional',
                    type: 'Foo',
                    name: 'foo',
                    options: {},
                    id: 3
                  }]
                }],
              options: {},
              services: [],
              oneofs: {}
            }],
          enums: [],
          imports: ['google/protobuf/descriptor.proto'],
          options: {},
          services: []
        }
        );
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("extend.proto", null, null, context.resourceManager);
        let reflectMessage: ESObject = protobuf.Reflect.Message;
        let TFoo: ESObject = builder.lookup(".Foo"),
          TBar: ESObject = builder.lookup(".Bar"),
          TBarFoo: ESObject = builder.lookup(".Bar.Foo"),
          fields: ESObject = TFoo.getChildren(reflectMessage.Field);
        expect(fields.length === 2).assertTrue();
        expect(fields[0].name === ".bar").assertTrue();
        expect(fields[0].id === 2).assertTrue();
        expect(fields[1].name === ".Bar.foo").assertTrue();
        expect(fields[1].id === 3).assertTrue();
        expect(TFoo.extensions).assertDeepEquals([[2, protobuf.ID_MAX]]); // explicitly defined
        expect(TBar.extensions === undefined).assertTrue(); // none defined
        expect(TBar.getChild("foo") == '.Bar.foo').assertTrue();
        expect(TBar.getChildren(reflectMessage.Field).length === 0).assertTrue();
        let root: ESObject = builder.build();
        expect(TFoo.getChild(".Bar.foo").resolvedType).assertEqual(TBarFoo); // .Bar.Foo, not .Foo
        let foo: ESObject = new root.Foo(),
          bar: ESObject = new root.Bar();
        foo['.bar'] = "123";
        foo['.Bar.foo'] = bar;
        expect(foo.encode().compact().toString("debug")).assertEqual("<12 03 31 32 33 1A 00>");
      } catch (e) {
        expect().assertFail();
      }
    })

    // Custom options on all levels
    // victorr (https://github.com/victorr)
    it('customOptions', 0, async () => {
      try {
        let value: ESObject = await protobuf.Util.fetch("custom-options.proto");
        let parser: ESObject = new protobuf.DotProto.Parser(value);
        let root: ESObject = parser.parse();
        expect(root["options"]["(my_file_option)"]).assertEqual("Hello world!");
        expect(root["messages"][7]["options"]["(my_message_option)"]).assertEqual(1234);
        expect(root["messages"][7]["fields"][0]["options"]["(my_field_option)"]).assertEqual(4.5);
        // expect(root["services"]["MyService"]["options"]["my_service_option"], "FOO");
        // TODO: add tests for my_enum_option, my_enum_value_option
      } catch (e) {
        expect().assertFail();
      }
    })

    it('oneofs', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("oneof.proto", null, null, context.resourceManager),
          MyOneOf: ESObject = builder.build("MyOneOf"),
          TOneOf: ESObject = builder.lookup(".MyOneOf");
        expect(!!TOneOf.getChild("my_oneof")).assertTrue();
        let myOneOf: ESObject = new MyOneOf();
        expect(myOneOf.my_oneof === null).assertTrue();
        myOneOf.set("id", 1);
        expect(myOneOf.my_oneof === "id").assertTrue();
        myOneOf.set("name", "me");
        expect(myOneOf.my_oneof === "name").assertTrue();
        expect(myOneOf.id === null).assertTrue();
        let bb: ESObject = myOneOf.encode().compact();
        expect(bb.toString("debug") === "<12 02 6D 65>").assertTrue(); // id 2, wt 2, len 2
        myOneOf = MyOneOf.decode(bb);
        expect(myOneOf.my_oneof === "name").assertTrue();
        expect(myOneOf.name === "me").assertTrue();
        expect(myOneOf.id === null).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })


    it('services', 0, async () => {
      try {
        let value: ESObject = await protobuf.Util.fetch("custom-options.proto");
        let parser: ESObject = new protobuf.DotProto.Parser(value);
        let root: ESObject = parser.parse();
        expect(root["services"]).assertDeepEquals([{
          "name": "MyService",
          "rpc": {
            "MyMethod": {
              "request": "RequestType",
              "response": "ResponseType",
              "request_stream": false,
              "response_stream": false,
              "options": {
                "(my_method_option).foo": 567,
                "(my_method_option).bar": "Some string"
              }
            }
          },
          "options": {
            "(my_service_option)": "FOO"
          }
        }]);
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("custom-options.proto", null, null, context.resourceManager);
        let rootBuilder: ESObject = builder.build(),
          MyService: ESObject = rootBuilder.MyService,
          RequestType: ESObject = rootBuilder.RequestType,
          ResponseType: ESObject = rootBuilder.ResponseType,
          called: boolean = false;

        expect(MyService.$options).assertDeepEquals({
          "(my_service_option)": "FOO"
        });
        expect(MyService.MyMethod.$options).assertDeepEquals({
          "(my_method_option).foo": 567,
          "(my_method_option).bar": "Some string"
        });

        // Provide the service with your actual RPC implementation based on whatever framework you like most.
        let myService: ESObject = new MyService((method: ESObject, req: ESObject, callback: Function) => {
          expect(method === ".MyService.MyMethod").assertTrue();
          expect(req instanceof RequestType).assertTrue();
          called = true;

          // In this case we just return no error and our pre-built response. This must be properly async!
          setTimeout(callback(null, (new ResponseType()).encode() /* as raw bytes for debugging */));
        });

        expect(myService.$options).assertDeepEquals(MyService.$options);
        expect(myService.MyMethod.$options).assertDeepEquals(MyService.MyMethod.$options);

        // Call the service with your request message and provide a callback. This will call your actual service
        // implementation to perform the request and gather a response before calling the callback. If the
        // request or response type is invalid i.e. not an instance of RequestType or ResponseType, your
        // implementation will not be called as protobuf.js handles this case internally and directly hands the
        // error to your callback below.
        myService.MyMethod(new RequestType(), (err: ESObject, res: ESObject) => {
          // We get: err = null, res = our prebuilt response. And that's it.
          if (err !== null) {
            expect().assertFail();
          }
          expect(called === true).assertTrue();
          expect(res instanceof ResponseType).assertTrue();

        });
        myService.MyMethod(new RequestType().encode(), (err: ESObject, res: ESObject) => {
          // We get: err = null, res = our prebuilt response. And that's it.
          if (err !== null) {
            expect().assertFail()
          }
          expect(called === true).assertTrue();
          expect(res instanceof ResponseType).assertTrue();
        });
      } catch (e) {
        expect().assertFail();
      }
    })

    // Properly ignore "syntax" and "extensions" keywords
    // The corresponding .proto file has been removed upon request
    /* "gtfs-realtime": function(test) {
        try {
            test.doesNotThrow(function() {
                protobuf.loadProtoFile(__dirname+"/gtfs-realtime.proto");
            });
        } catch (e) {
             expect().assertFail();
        }

    }, */


    it('delimited', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Position { required int32 x = 1; required int32 y = 2; }");
        let Position: ESObject = builder.build("Position");
        let bb: ByteBuffer = new ByteBuffer();
        for (let i = 0; i < 5; i++) {
          let position: ESObject = new Position(10, 10);
          position.encodeDelimited(bb);
        }
        bb.flip();
        for (let i = 0; i < 5; i++) {
          let position: ESObject = Position.decodeDelimited(bb);
          expect(position.x === 10).assertTrue();
          expect(position.y === 10).assertTrue();
        }
      } catch (e) {
        expect().assertFail();
      }
    })


    it('stringify', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Position { required int32 x = 1; required int64 y = 2; }");
        let Position: ESObject = builder.build("Position");
        let protobufLong: ESObject = protobuf.Long
        let position: ESObject = new Position(1, protobufLong.fromNumber(2));
        let json: string = JSON.stringify(position);
        expect(json === '{"x":1,"y":{"low":2,"high":0,"unsigned":false}}').assertTrue();
        position = new Position(JSON.parse(json));
        expect(position.x === 1).assertTrue();
        expect(position.y instanceof protobufLong).assertTrue();
        let positionValue: PositionValue = {
          low: 2, high: 0, unsigned: false
        }
        expect(JSON.stringify(position.y)).assertDeepEquals(JSON.stringify(positionValue));
        // Also test if this encodes and decodes properly
        position = Position.decode(position.encode());
        expect(position.y instanceof protobufLong).assertTrue();

        expect(JSON.stringify(position.y)).assertDeepEquals(JSON.stringify(positionValue));
      } catch (e) {
        expect().assertFail();
      }
    })


    it('fields', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("optional.proto", null, null, context.resourceManager);
        let Test1: ESObject = builder.build("Test1");
        let test1: ESObject = new Test1();
        expect(test1.a === null).assertTrue();
        expect(Object.keys(test1)).assertDeepEquals(['a', 'b']);
        let bb: ESObject = test1.encode();
        test1 = Test1.decode(bb);
        expect(test1.a === null).assertTrue();
        expect(Object.keys(test1)).assertDeepEquals(['a', 'b']);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('fieldsToCamelCase', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        protobuf.convertFieldsToCamelCase = true;
        let builder: ESObject = await protobuf.loadProtoFile("camelcase.proto", null, null, context.resourceManager);
        let Test: ESObject = builder.build("Test"),
          TTest: ESObject = builder.lookup("Test");
        let msg: ESObject = new Test();

        // Reverted collision on 1st
        expect(msg.some_field === null).assertTrue();
        expect(msg.someField === null).assertTrue();
        expect(TTest.getChild("some_field").id).assertEqual(1);
        expect(TTest.getChild("someField").id).assertEqual(2);


        // Reverted collision on 2nd
        expect(msg.aField === null).assertTrue();
        expect(msg.a_field === null).assertTrue();
        expect(TTest.getChild("aField").id).assertEqual(3);
        expect(TTest.getChild("a_field").id).assertEqual(4);

        // No collision
        expect(msg.itsAField === null).assertTrue();
        expect(TTest.getChild("itsAField").id).assertEqual(5);

        expect(typeof msg.set_its_a_field === "function").assertTrue();
        expect(typeof msg.setItsAField === "function").assertTrue();

        protobuf.convertFieldsToCamelCase = false;
      } catch (e) {
        protobuf.convertFieldsToCamelCase = false;
        expect().assertFail();
      }
    })

    it('setarray', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("setarray.proto", null, null, context.resourceManager);
        let root: ESObject = builder.build(),
          Outer: ESObject = root.Outer,
          Inner: ESObject = root.Inner,
          inners: Array<ESObject> = [];

        // Array of repeated messages
        inners.push(new Inner("a"), new Inner("b"), new Inner("c"));
        let outer: ESObject = new Outer();
        outer.setInners(inners);
        expect(JSON.stringify(outer.inners)).assertDeepEquals(JSON.stringify(inners));

        // Array of repeated message objects
        inners = [];
        let a: InnerString = {
          str: 'a'
        };
        let b: InnerString = {
          str: 'b'
        };
        let c: InnerString = {
          str: 'c'
        };
        inners.push(a, b, c);
        outer.setInners(inners); // Converts
        expect(outer.inners[0] instanceof Inner).assertTrue();
        expect(JSON.stringify(outer.inners)).assertDeepEquals(JSON.stringify(inners));
      } catch (e) {
        expect().assertFail();
      }
    })


    // Make sure that our example at https://github.com/dcodeIO/protobuf.js/wiki is not nonsense
    it('pingexample', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("PingExample.proto", null, null, context.resourceManager);
        let Message: ESObject = builder.build("Message");
        let msg: ESObject = new Message();
        msg.ping = new Message.Ping(123456789);
        let Ping: ESObject = msg.ping;
        let bb: ESObject = msg.encode();
        expect(bb.limit === 7).assertTrue();
        msg = Message.decode(bb);
        expect(Ping == '.Message.Ping').assertTrue();
        expect(!!Ping).assertTrue();
        expect(msg.ping.time === 123456789).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('negInt32', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Test { required int32 value = 2; }");
        let Test: ESObject = builder.build("Test");
        let t: ESObject = new Test(-1);
        let size: number = t.calculate();
        let bb: ESObject = t.encode(); // flips
        expect(bb.remaining() === size).assertTrue();
        expect(bb.toBase64() === "EP///////////wE=").assertTrue();
        t = Test.decode(bb);
        expect(t.value === -1).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })


    it('negEnumId', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("negid.proto", null, null, context.resourceManager);
        let Test: ESObject = builder.build("Test");
        expect(Test.LobbyType.INVALID === -1).assertTrue();
        let t: ESObject = new Test(Test.LobbyType.INVALID);
        expect(t.type === -1).assertTrue();
        let size: number = t.calculate();
        let bb: ESObject = t.encode(); // flips
        expect(bb.remaining() === size).assertTrue();
        t = Test.decode(bb);
        expect(t.type === -1).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('base64', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Message { required string s = 1; }")
        let Message: ESObject = builder.build("Message");
        let msg: ESObject = new Message("ProtoBuf.js");
        let b64: string = msg.toBase64();
        expect(b64 === "CgtQcm90b0J1Zi5qcw==").assertTrue();
        let msg2: ESObject = Message.decode64(b64);
        expect(msg).assertDeepEquals(msg2);
        msg2 = Message.decode(b64, "base64");
        expect(msg).assertDeepEquals(msg2);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('hex', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Message { required string s = 1; }")
        let Message: ESObject = builder.build("Message");
        let msg: ESObject = new Message("ProtoBuf.js");
        let hex: ESObject = msg.toHex();
        expect(hex === "0a0b50726f746f4275662e6a73").assertTrue();
        let msg2: ESObject = Message.decodeHex(hex);
        expect(msg).assertDeepEquals(msg2);
        msg2 = Message.decode(hex, "hex");
        expect(msg).assertDeepEquals(msg2);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('forwardComp', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message Message { required int32 a = 1; required string b = 2; required float c = 3; }");
        let Message: ESObject = builder.build("Message");
        let msg: ESObject = new Message(123, "abc", 0.123);
        let bb: ESObject = msg.encode();
        builder = await protobuf.loadProto("message Message {}");
        Message = builder.build("Message");

        Message.decode(bb);
        expect(bb.offset === bb.limit).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('tokenizerLine', 0, async () => {
      try {
        let parser: ESObject = new protobuf.DotProto.Parser("package test;\n\nmessage Message {\n\trequired string invalid = 1;}ERROR\n"),
          ast: ESObject = null, err: ESObject = null;
        try {
          ast = parser.parse();
        } catch (caught) {
          err = caught;
        }
        expect(!!err).assertTrue();
        expect(ast).not().assertTrue();
        expect(err.message.indexOf("line 4:") >= 0).assertTrue();
      } catch (e) {
        expect(e).assertFail();
      }
    })

    it('parser_parse', 0, () => {
      try {
        let ast: ESObject;
        let err: ESObject;
        try {
          ast = protobuf.DotProto.Parser.parse("package test;\n\nmessage Message {\n\trequired string invalid = 1;}ERROR\n");
          err = null;
        } catch (caught) {
          err = caught;
        }
        expect(!!err).assertTrue();
        expect(ast).not().assertTrue();
        expect(err.message.indexOf("line 4:") >= 0).assertTrue();
      } catch (e) {
        expect(e).assertFail();
      }
    })

    it('excludeFields', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message A { required int32 i = 1; } message B { required A A = 1; }");
        let message: ESObject = builder.build();
        expect(!!message).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('proto2jsExtend', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadJsonFile("proto2js/Bar.json", null, null, context.resourceManager);
        let message: ESObject = builder.build();
        expect(!!message).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('emptyMessage', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message EmptyMessage {}"),
          EmptyMessage: ESObject = builder.build("EmptyMessage");

        let msg: ESObject = new EmptyMessage(),
          ab: ESObject = msg.toArrayBuffer();
        expect(ab.byteLength === 0).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('toRaw', 0, async () => {
      try {
        let builder: ESObject = await protobuf.loadProto("message MyMessage { required int32 a = 1; required int32 b = 2; required bytes c = 3; }"),
          MyMessage: ESObject = builder.build("MyMessage");
        let raw = rawValue;
        let myMessage: ESObject = new MyMessage(raw);
        expect(myMessage.c.toBase64()).assertDeepEquals(raw.c);
        expect(myMessage.toRaw(true)).assertDeepEquals(raw);
      } catch (e) {
        expect().assertFail();
      }
    })

    it('singleQuotedString', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("string_single_quote.proto", null, null, context.resourceManager);
        let TestSingleQuoteString: ESObject = builder.build("TestSingleQuoteString");
        expect(typeof TestSingleQuoteString == 'function').assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('importDuplicateSingleQuote', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("import_a_single_quote.proto", null, null, context.resourceManager);
        await protobuf.loadProtoFile("import_b.proto", builder, null, context.resourceManager);

        let root: ESObject = builder.build();
        let A: ESObject = root.A;
        let B: ESObject = root.B;
        let Common: ESObject = root.Common;
        expect(!!A).assertTrue();
        expect(!!B).assertTrue();
        expect(!!Common).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('importStringSuccessively', 0, async () => {
      try {
        let proto1: ESObject = "message A { required string a = 1; };";
        let proto2: ESObject = "import \"proto1.proto\"; message B { required A a = 1; };";
        let builder: ESObject = await protobuf.loadProto(proto1, "proto1.proto");
        await protobuf.loadProto(proto2, builder, "proto2.proto");
        let root: ESObject = builder.build();
        let A: ESObject = root.A;
        let B: ESObject = root.B;
        expect(!!A).assertTrue();
        expect(!!B).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('multilineString', 0, async () => {
      try {
        let proto: ESObject = "message TestMessage { required string test = 1 [default = \"1\"   \"2\"\n\"3\"];}";
        let builder: ESObject = await protobuf.loadProto(proto, "multilineString.proto");
        let TestMessage: ESObject = builder.build("TestMessage"),
          testMessage: ESObject = new TestMessage();
        expect(testMessage.test === "123").assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('packable', 0, async () => {
      try {
        let proto: string = 'message Inner { required int32 id=2; }\nmessage Outer { repeated Inner inner = 1 [packed=true]; }';
        let builder: ESObject = await protobuf.loadProto(proto);
        let root: ESObject = builder.build();
        let inner: ESObject = new root.Inner(1),
          outer: ESObject = new root.Outer(inner);
        let bb: ESObject = outer.encode().compact();
        expect(bb.toDebug() === "<0A 02 10 01>").assertTrue();
        // 0A: wt 2, id 1
        // 02: len 2
        // 10: wt 0, id 2
        // 01: 1
        let outer2: ESObject = root.Outer.decode(bb);
        expect(outer2.inner.id === 1).assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })


    it('test_type', 0, async () => {
      let builder: ESObject = await protobuf.loadProto("message Test {}");
      let Test: ESObject = builder.build("Test"),
        TTest: ESObject = builder.lookup("Test");
      expect(new Test().$type === TTest).assertTrue();
    })

    it('mismatchedNesting', 0, async () => {
      try {
        let proto: string = "message Child { optional uint32 foo = 1; } message FakeChild { optional uint32 foo = 1; } message Parent { optional Child child = 1; }";
        let builder: ESObject = await protobuf.loadProto(proto, "tests/mismatchedNesting.proto");
        let root: ESObject = builder.build();
        let fakeValue: FakeValue = {
          foo: 1
        }
        let fakeObject: FakeObject = {
          child: new root.FakeChild(fakeValue)
        }
        let foo: ESObject = new root.Parent(fakeObject);
      } catch (e) {
        expect(!!e).assertTrue();
      }
    })

    it('builderOptions', 0, async () => {

      try {
        let proto: string = "message Foo { optional uint32 foo_bar = 1; }";
        let convertField: ConvertField = {
          convertFieldsToCamelCase: true
        }
        let builder: ESObject = await protobuf.newBuilder(convertField);
        await protobuf.loadProto(proto, builder, "tests/builderOptions.proto");
        let Foo: ESObject = builder.build("Foo");
        expect(protobuf.convertFieldsToCamelCase === false).assertTrue();
        expect(builder.options.convertFieldsToCamelCase === true).assertTrue();
        let foo: ESObject = new Foo();
        expect(typeof foo.fooBar !== 'undefined').assertTrue();
        expect(typeof foo.foo_bar === 'undefined').assertTrue();

      } catch (e) {
        expect().assertFail();
      }
    })

    it('proto3', 0, async () => {
      try {
        let context: Context = GlobalContext.getContext().getObject("context") as Context;
        let builder: ESObject = await protobuf.loadProtoFile("proto3.proto", null, null, context.resourceManager);
        await protobuf.loadProtoFile("proto3.proto", builder, null, context.resourceManager);
        let root: ESObject = builder.build();
        expect(root.test.Foo.$type.syntax === 'proto3').assertTrue();
      } catch (e) {
        expect().assertFail();
      }
    })

    it('proto3FieldPresence', 0, async () => {
      let proto: string =
        "syntax = \"proto3\";\n" +
          "message Test {\n" +
          "  int32 field_int32 = 1;\n" +
          "  int64 field_int64 = 2;\n" +
          "  string field_str = 3;\n" +
          "  bytes field_bytes = 4;\n" +
          "  Test field_msg = 5;\n" +
          "  Enum field_enum = 6;\n" +
          "  repeated int32 rpt_int32 = 11;\n" +
          "  repeated int64 rpt_int64 = 12;\n" +
          "  repeated string rpt_str = 13;\n" +
          "  repeated bytes rpt_bytes = 14;\n" +
          "  repeated Test rpt_msg = 15;\n" +
          "  repeated Enum rpt_enum = 16;\n" +
          "  oneof oneof_type { bool oneof_bool = 17; };\n" +
          "}\n" +
          "enum Enum { Default = 0; A = 1; B = 2; }\n";
      let builder: ESObject = protobuf.newBuilder();
      await protobuf.loadProto(proto, builder, "test/proto3FieldPresence.proto");
      let Test: ESObject = builder.build('Test'),
        Enum: ESObject = builder.build('Enum');

      expect(protobuf.Builder.isMessage(Test)).assertTrue()
      expect(protobuf.Builder.isMessageField({
        "rule": "optional",
        "type": "string",
        "name": "sessionId",
        "id": 1,
      })).assertTrue()
      expect(protobuf.Builder.isEnum(Enum)).assertFalse()
      expect(protobuf.Builder.isEnum(Enum.A)).assertFalse()
      expect(protobuf.Builder.isService(Enum)).assertFalse()
      expect(protobuf.Builder.isExtend(Enum)).assertFalse()

      let testMsg: ESObject = new Test();
      expect(testMsg.field_int32 === 0).assertTrue();
      expect(testMsg.field_int64.low === 0).assertTrue();
      expect(testMsg.field_int64.high === 0).assertTrue();
      expect(testMsg.field_str === "").assertTrue();
      expect(testMsg.field_msg === null).assertTrue();
      expect(testMsg.field_bytes instanceof ByteBuffer).assertTrue();
      expect(testMsg.field_bytes.remaining() === 0).assertTrue();
      expect(testMsg.rpt_int32.length === 0).assertTrue();
      expect(testMsg.oneof_type === null).assertTrue();
      expect(testMsg.oneof_bool === false).assertTrue();

      // No fields should go on the wire, even though they're set
      let encoded: ESObject = testMsg.encode();
      expect(encoded.remaining() === 0).assertTrue();
      testMsg.field_int32 = 42;
      encoded = testMsg.encode();
      expect(encoded.remaining() === 2).assertTrue();
      testMsg.field_int32 = 0;
      encoded = testMsg.encode();
      expect(encoded.remaining() === 0).assertTrue();

      // Enum fields should be able to carry arbitrary values.
      testMsg.field_enum = 42;
      expect(testMsg.field_enum === 42).assertTrue();
      encoded = testMsg.encode();
      testMsg = Test.decode(encoded);
      expect(testMsg.field_enum === 42).assertTrue();

      // Explicitly set fields that are part of an oneof should
      // be encoded even if set to their default value
      testMsg = new Test();
      testMsg.set("oneof_bool", false);
      expect(testMsg.oneof_type === "oneof_bool").assertTrue();
      encoded = testMsg.encode().compact();
      expect(encoded.toString("debug") === "<88 01 00>").assertTrue(); // 17|varint (0term) + varint 0
      let decoded: ESObject = Test.decode(encoded);
      expect(decoded.oneof_type === "oneof_bool").assertTrue();
      expect(decoded.oneof_bool === false).assertTrue();
    })


    it('mapContainer', 0, async () => {
      let proto: string =
        "message Test {\n" +
          "  map<string, int32> map_string_int32 = 1;\n" +
          "  map<string, int64> map_string_int64 = 2;\n" +
          "  map<string, string> map_string_string = 3;\n" +
          "  map<string, Test> map_string_msg = 4;\n" +
          "  map<string, Enum> map_string_enum = 5;\n" +
          "  map<int32, string> map_int32_string = 6;\n" +
          "  map<int64, string> map_int64_string = 7;\n" +
          "  map<bool, string> map_bool_string = 9;\n" +
          "}\n" +
          "enum Enum { Default = 0; A = 1; B = 2; }\n";
      let builder: ESObject = protobuf.newBuilder();
      await protobuf.loadProto(proto, builder, "test/mapContainer.proto");

      let map_string_int32: ESObject =
        new protobuf.Map(builder.lookup("Test.map_string_int32"));

      expect(map_string_int32.size === 0).assertTrue();
      expect(map_string_int32.has("asdf") === false).assertTrue();
      expect(map_string_int32.get("asdf") === undefined).assertTrue();
      map_string_int32.set("asdf", 42);
      expect(map_string_int32.has("asdf") === true).assertTrue();
      expect(map_string_int32.get("asdf") === 42).assertTrue();
      map_string_int32.forEach((value: ESObject, key: ESObject) => {
        expect(key).assertEqual('asdf')
        expect(value).assertEqual(42)
      });
      let it: ESObject = map_string_int32.keys();
      let itVal: ESObject = it.next();
      expect(itVal.done === false).assertTrue();
      expect(itVal.value === "asdf").assertTrue();
      itVal = it.next();
      expect(itVal.done === true).assertTrue();

      it = map_string_int32.values();
      itVal = it.next();
      expect(itVal.done === false).assertTrue();
      expect(itVal.value === 42).assertTrue();
      itVal = it.next();
      expect(itVal.done === true).assertTrue();

      it = map_string_int32.entries();
      itVal = it.next();
      expect(itVal.done === false).assertTrue();
      expect(itVal.value).assertDeepEquals(["asdf", 42]);
      itVal = it.next();
      expect(itVal.done === true).assertTrue();

      map_string_int32.set("jkl;", 84);
      expect(map_string_int32.has("jkl;") === true).assertTrue();
      expect(map_string_int32.has("asdf") === true).assertTrue();
      expect(map_string_int32.size === 2).assertTrue();
      map_string_int32.delete("jkl;");
      expect(map_string_int32.has("jkl;") === false).assertTrue();
      expect(map_string_int32.get("jkl;") === undefined).assertTrue();
      expect(map_string_int32.size === 1).assertTrue();

      map_string_int32.clear();
      expect(map_string_int32.size === 0).assertTrue();

      try {
        map_string_int32.set("asdf", 42.1);
      } catch (e) {
        let reg: RegExp = new RegExp("not an integer")
        expect(!!e.message.match(reg)).assertTrue();
      }

      try {
        map_string_int32.set(42, 42);
      } catch (e) {
        let reg: RegExp = new RegExp("not a string")
        expect(!!e.message.match(reg)).assertTrue();
      }

      // Test various key types to ensure that value->string->value
      // conversion works.
      let map_int32_string: ESObject =
        new protobuf.Map(builder.lookup("Test.map_int32_string"));
      expect(map_int32_string.size === 0).assertTrue();
      map_int32_string.set(12345678, "asdf");
      expect(map_int32_string.size === 1).assertTrue();
      expect(map_int32_string.has(12345678) === true).assertTrue();
      expect(map_int32_string.get(12345678) === "asdf").assertTrue();

      let map_int64_string: ESObject =
        new protobuf.Map(builder.lookup("Test.map_int64_string"));
      expect(map_int64_string.size === 0).assertTrue();
      map_int64_string.set("9223372036854775807", "asdf");
      expect(map_int64_string.size === 1).assertTrue();
      expect(map_int64_string.has("9223372036854775807") === true).assertTrue();
      expect(map_int64_string.get("9223372036854775807") === "asdf").assertTrue();

      // Ensure that initialization from a raw object works.
      map_int32_string =
        new protobuf.Map(builder.lookup("Test.map_int32_string"),
          mapInt32Value);
      expect(map_int32_string.size === 1).assertTrue();
      expect(map_int32_string.keys().next().value === 42).assertTrue();

      map_int64_string = new protobuf.Map(builder.lookup("Test.map_int64_string"), mapInt64Value);
      expect(map_int64_string.size === 1).assertTrue();
      let i64: ESObject = map_int64_string.keys().next().value;
      let protobufLong: ESObject = protobuf.Long
      expect(i64 instanceof protobufLong).assertTrue();
      expect(i64.toString() === "9223372036854775807").assertTrue();
    })

    it('mapField', 0, async () => {
      let proto: string =
        "message Test {\n" +
          "  map<string, int32> map_string_int32 = 1;\n" +
          "  map<string, int64> map_string_int64 = 2;\n" +
          "  map<string, string> map_string_string = 3;\n" +
          "  map<string, Test> map_string_msg = 4;\n" +
          "  map<string, Enum> map_string_enum = 5;\n" +
          "  map<int32, string> map_int32_string = 6;\n" +
          "  map<int64, string> map_int64_string = 7;\n" +
          "  map<bool, string> map_bool_string = 9;\n" +
          "}\n" +
          "enum Enum { Default = 0; A = 1; B = 2; }\n";
      let builder: ESObject = protobuf.newBuilder();
      await protobuf.loadProto(proto, builder, "test/mapField.proto");
      let Test: ESObject = builder.build('Test');
      let testMsg: ESObject = new Test();
      expect(testMsg.map_string_int32.size === 0).assertTrue();
      expect(testMsg.map_string_int64.size === 0).assertTrue();
      expect(testMsg.map_string_string.size === 0).assertTrue();
      expect(testMsg.map_string_msg.size === 0).assertTrue();
      expect(testMsg.map_string_enum.size === 0).assertTrue();
      expect(testMsg.map_int32_string.size === 0).assertTrue();
      expect(testMsg.map_int64_string.size === 0).assertTrue();
      expect(testMsg.map_bool_string.size === 0).assertTrue();

      testMsg.$set('map_string_int32', {
        'asdf': 42
      });

      try {
        testMsg.$set('map_string_int32', {
          'asdf': 42.1
        });
      } catch (e) {
        let reg: RegExp = new RegExp("Illegal")
        expect(!!e.message.match(reg)).assertTrue();
      }
    })

    it('mapEncodeDecode', 0, async () => {
      let proto: string =
        "message Test {\n" +
          "  map<string, int32> map_string_int32 = 1;\n" +
          "  map<string, int64> map_string_int64 = 2;\n" +
          "  map<string, string> map_string_string = 3;\n" +
          "  map<string, Test> map_string_msg = 4;\n" +
          "  map<string, Enum> map_string_enum = 5;\n" +
          "  map<int32, string> map_int32_string = 6;\n" +
          "  map<int64, string> map_int64_string = 7;\n" +
          "  map<bool, string> map_bool_string = 9;\n" +
          "}\n" +
          "enum Enum { Default = 0; A = 1; B = 2; }\n";
      let builder: ESObject = protobuf.newBuilder();
      await protobuf.loadProto(proto, builder, "test/mapField.proto");
      let Test: ESObject = builder.build('Test'),
        Enum: ESObject = builder.build('Enum');

      let testMsg: ESObject = new Test();
      testMsg.map_string_int32.set("a", 1);
      testMsg.map_string_int32.set("b", 2);
      testMsg.map_string_int64.set("c", "12345678901234");
      testMsg.map_string_int64.set("d", "98765432109876");
      testMsg.map_string_string.set("e", "asdf");
      testMsg.map_string_string.set("f", "jkl;");
      testMsg.map_string_enum.set("g", Enum.A);
      testMsg.map_string_enum.set("h", Enum.B);
      testMsg.map_int32_string.set(9, "a");
      testMsg.map_int32_string.set(10, "b");
      testMsg.map_int64_string.set("12345678901234", "a");
      testMsg.map_int64_string.set("98765432109876", "b");
      testMsg.map_bool_string.set(false, "a");
      testMsg.map_bool_string.set(true, "b");

      let encoded: ESObject = testMsg.encode();
      testMsg = Test.decode(encoded);

      expect(testMsg.map_string_int32.get("a") === 1).assertTrue();
      expect(testMsg.map_string_int32.get("b") === 2).assertTrue();
      expect(testMsg.map_string_int64.get("c").toString() === "12345678901234").assertTrue();
      expect(testMsg.map_string_int64.get("d").toString() === "98765432109876").assertTrue();
      expect(testMsg.map_string_string.get("e") === "asdf").assertTrue();
      expect(testMsg.map_string_string.get("f") === "jkl;").assertTrue();
      expect(testMsg.map_string_enum.get("g") === Enum.A).assertTrue();
      expect(testMsg.map_string_enum.get("h") === Enum.B).assertTrue();
      expect(testMsg.map_int32_string.get(9) === "a").assertTrue();
      expect(testMsg.map_int32_string.get(10) === "b").assertTrue();
      expect(testMsg.map_int64_string.get("12345678901234") === "a").assertTrue();
      expect(testMsg.map_int64_string.get("98765432109876") === "b").assertTrue();
      expect(testMsg.map_bool_string.get(false) === "a").assertTrue();
      expect(testMsg.map_bool_string.get(true) === "b").assertTrue();
    })

    it('proto3Json', 0, async () => {
      let proto =
        "syntax = \"proto3\";\n" +
          "message Test {\n" +
          "  int32 optional_int32 = 1;\n" +
          "  int64 optional_int64 = 2;\n" +
          "  string optional_string = 3;\n" +
          "  bytes optional_bytes = 4;\n" +
          "  bool optional_bool = 5;\n" +
          "  Enum optional_enum = 6;\n" +
          "  repeated int32 repeated_int32 = 11;\n" +
          "  repeated int64 repeated_int64 = 12;\n" +
          "  repeated string repeated_string = 13;\n" +
          "  repeated bytes repeated_bytes = 14;\n" +
          "  repeated bool repeated_bool = 15;\n" +
          "  repeated Enum repeated_enum = 16;\n" +
          "  map<string, int32> map_string_int32 = 20;\n" +
          "  map<string, int64> map_string_int64 = 21;\n" +
          "  map<string, string> map_string_string = 22;\n" +
          "  map<string, Enum> map_string_enum = 24;\n" +
          "  map<int32, string> map_int32_string = 25;\n" +
          "  map<int64, string> map_int64_string = 26;\n" +
          "  map<bool, string> map_bool_string = 27;\n" +
          "}\n" +
          "enum Enum { Default = 0; A = 1; B = 2; }\n";
      let builder: ESObject = protobuf.newBuilder();
      await protobuf.loadProto(proto, builder, "test/mapField.proto");
      let Test: ESObject = builder.build('Test'),
        Enum: ESObject = builder.build('Enum');

      let testMsg: ESObject = new Test();
      let protobufByteBuffer: ESObject = protobuf.ByteBuffer;
      testMsg.optional_int32 = 1;
      testMsg.optional_int64 = "12345678901234";
      testMsg.optional_string = "hello";
      testMsg.optional_bytes = protobufByteBuffer.fromBinary("\x00\xFF\x80");
      testMsg.optional_bool = true;
      testMsg.optional_enum = Enum.A;
      testMsg.repeated_int32.push(1);
      testMsg.repeated_int64.push("12345678901234");
      testMsg.repeated_string.push("hello");
      testMsg.repeated_bytes.push(protobufByteBuffer.fromBinary("\x00\xFF\x80"));
      testMsg.repeated_bool.push(true);
      testMsg.repeated_enum.push(Enum.A);
      testMsg.map_string_int32.set("a", 1);
      testMsg.map_string_int32.set("b", 2);
      testMsg.map_string_int64.set("c", "12345678901234");
      testMsg.map_string_int64.set("d", "98765432109876");
      testMsg.map_string_string.set("e", "asdf");
      testMsg.map_string_string.set("f", "jkl;");
      testMsg.map_string_enum.set("g", Enum.A);
      testMsg.map_string_enum.set("h", Enum.B);
      testMsg.map_int32_string.set(9, "a");
      testMsg.map_int32_string.set(10, "b");
      testMsg.map_int64_string.set("12345678901234", "a");
      testMsg.map_int64_string.set("98765432109876", "b");
      testMsg.map_bool_string.set(false, "a");
      testMsg.map_bool_string.set(true, "b");

      let jsonObj: Object = JSON.parse(testMsg.encodeJSON());
      expect(jsonObj).assertDeepEquals(
        {
          optional_int32: 1,
          optional_int64: "12345678901234",
          optional_string: "hello",
          optional_bytes: "AP+A", // base64
          optional_bool: true,
          optional_enum: "A",
          repeated_int32: [1],
          repeated_int64: ["12345678901234"],
          repeated_string: ["hello"],
          repeated_bytes: ["AP+A"], // base64
          repeated_bool: [true],
          repeated_enum: ["A"],
          map_string_int32: {
            "a": 1, "b": 2
          },
          map_string_int64: {
            "c": "12345678901234", "d": "98765432109876"
          },
          map_string_string: {
            "e": "asdf", "f": "jkl;"
          },
          map_string_enum: {
            "g": "A", "h": "B"
          },
          map_int32_string: {
            "9": "a", "10": "b"
          },
          map_int64_string: {
            "12345678901234": "a", "98765432109876": "b"
          },
          map_bool_string: {
            "false": "a", "true": "b"
          },
        });

      let testMsg2: ESObject = Test.decodeJSON(testMsg.encodeJSON());
      expect(testMsg2.encodeJSON() === testMsg.encodeJSON()).assertTrue();
    })

    it('util_fetch', 0, async () => {
      let detail: ESObject = await protobuf.Util.fetch("example1.proto")
      expect(!!detail).assertTrue()
    })

    it('util_toCamelCase', 0, () => {
      let result1: ESObject = protobuf.Util.toCamelCase('test_sample');
      expect(result1).assertEqual('testSample')
      result1 = protobuf.Util.toCamelCase('');
      expect(result1).assertEqual('')
      result1 = protobuf.Util.toCamelCase('hello_world_hello_protobuf');
      expect(result1).assertEqual('helloWorldHelloProtobuf')
      result1 = protobuf.Util.toCamelCase('protobuf');
      expect(result1).assertEqual('protobuf')
      result1 = protobuf.Util.toCamelCase('Util_to_Camel_Case');
      expect(result1).assertEqual('UtilToCamelCase')
    })

    it('Tokenizer', 0, async () => {
      try {
        let value: ESObject = await protobuf.Util.fetch("comments.proto");
        let tn: ESObject = new protobuf.DotProto.Tokenizer(value);
        let token: ESObject, tokens: Array<ESObject> = [];
        let result: Array<string> = getResult();
        let count: number = 0;
        do {
          token = tn.next();
          expect(tn.peek()).assertEqual(result[count]);
          tokens.push(token);
          count++;
        } while (token !== null);
        expect(tn.toString()).assertEqual(`Tokenizer (${value.length}/${value.length} at line 10)`)
      } catch (e) {
        expect().assertFail();
      }
    })
    it('Message_isMessage', 0, async () => {
      try {
        let value: ESObject = await protobuf.Util.fetch("comments.proto");
        let tn: ESObject = new protobuf.DotProto.Tokenizer(value);
        let token: ESObject, tokens: Array<ESObject> = [];
        let result = getResult();
        let count = 0;
        do {
          token = tn.next();
          expect(tn.peek()).assertEqual(result[count]);
          tokens.push(token);
          count++;
        } while (token !== null);
        expect(tn.toString()).assertEqual(`Tokenizer (${value.length}/${value.length} at line 10)`)
      } catch (e) {
        expect().assertFail();
      }
    })
  })
}

function validateComplex(Game: ESObject) {
  let Car: ESObject = Game.Cars.Car,
    Vendor: ESObject = Car.Vendor,
    Speed: ESObject = Car.Speed;

  let vendor: ESObject;
  // Car from class with argument list properties
  let car: ESObject = new Car(
    "Rusty",
    // Vendor from class with object properties
    vendor = new Vendor(vendorValue),
    // Speed from enum object
    Speed.SUPERFAST
  );
  expect(car.model).assertEqual("Rusty");
  expect(car.vendor.name).assertEqual("Iron Inc.");
  expect(car.vendor.address.country).assertEqual("US");
  expect(car.vendor.address.country).assertEqual(car.getVendor().get_address().country);
  let bb: ByteBuffer = new ByteBuffer(32);
  car.encode(bb);
  expect(bb.flip().toString("debug"))
    .assertEqual("<0A 05 52 75 73 74 79 12 15 0A 09 49 72 6F 6E 20 49 6E 63 2E 12 04 0A 02 55 53 1A 02 6D 31 18 02>");
  let carDec: ESObject = Car.decode(bb);
  expect(carDec.model).assertEqual("Rusty");
  expect(carDec.vendor.name).assertEqual("Iron Inc.");
  expect(carDec.vendor.address.country).assertEqual("US");
  expect(carDec.vendor.address.country).assertEqual(carDec.getVendor().get_address().country);
  expect(carDec.vendor.models[0]).assertEqual("m1");
}

interface UserLogin {
  sessionId: string,
  userPrivilege: string,
  isTokenType: boolean,
  formatTimestamp: string
}

interface T2 {
  a: number
}

interface InnerString {
  str: string
}

interface PositionValue {
  low: number,
  high: number,
  unsigned: boolean
}

interface FakeObject {
  child: ESObject
}

interface FakeValue {
  foo: number
}

interface OuterInner {
  inner: Array<ESObject>
}

interface ImageDataBuffer {
  data: ESObject
}

interface ResourceValue {
  bundleName: string,
  moduleName: string,
  id: number
}

interface ConvertField {
  convertFieldsToCamelCase: boolean
}
