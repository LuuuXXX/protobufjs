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
// @ts-nocheck
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import ByteBuffer from '@ohos/protobufjs/src/main/ets/dist/bytebuffer'

export default function writerReaderTest() {
  describe('ByteBufferTest', function () {
    var type = ByteBuffer.type() // Buffer or ArrayBuffer
    var accessor = ByteBuffer.accessor()
    var Long = ByteBuffer.Long;

    it('test_constructor', 0, function () {
      for (var i = 0; i < 10; ++i) {
        expect(!!new ByteBuffer()).assertTrue();
      }
    })

    it('test_static', 0, function () {
      for (var i = 0; i < 10; ++i) {
        expect(ByteBuffer.type()).assertEqual(ArrayBuffer);
        expect(ByteBuffer.accessor()).assertEqual(Uint8Array);

        expect(ByteBuffer.allocate(5).limit).assertEqual(5);

      }
    })
    it('test_init', 0, function () {
      for (var i = 0; i < 10; ++i) {
        expect(type).assertEqual(ArrayBuffer);
        expect(typeof ByteBuffer).assertEqual('function');
      }
    })

    it('test_base_allocate', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer();
        expect(bb.buffer instanceof type).assertTrue();
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(ByteBuffer.DEFAULT_CAPACITY);
        expect(bb.littleEndian).assertEqual(ByteBuffer.DEFAULT_ENDIAN);
        expect(bb.noAssert).assertEqual(ByteBuffer.DEFAULT_NOASSERT);

        expect(bb.buffer.byteLength).assertEqual(bb.capacity());
        expect(bb.capacity()).assertEqual(ByteBuffer.DEFAULT_CAPACITY);
        bb = ByteBuffer.allocate(undefined,!ByteBuffer.DEFAULT_ENDIAN,!ByteBuffer.DEFAULT_NOASSERT);
        expect(bb.capacity()).assertEqual(ByteBuffer.DEFAULT_CAPACITY);
        expect(bb.littleEndian).assertEqual(!ByteBuffer.DEFAULT_ENDIAN);
        expect(bb.noAssert).assertEqual(!ByteBuffer.DEFAULT_NOASSERT);

        // __isByteBuffer__
        expect(bb.__isByteBuffer__).assertTrue();
        expect(ByteBuffer.isByteBuffer(bb)).assertTrue();
      }
    })

    it('test_base_clone', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer(1, true, false);
        var bb2 = bb.clone();
        expect(bb.buffer).assertEqual(bb2.buffer);
        expect(bb.offset).assertEqual(bb2.offset);
        expect(bb.limit).assertEqual(bb2.limit);
        expect(bb.markedOffset).assertEqual(bb2.markedOffset);
        expect(bb.littleEndian).assertEqual(bb2.littleEndian);
        expect(bb.noAssert).assertEqual(bb2.noAssert);
        expect(bb != bb2).assertTrue();
      }
    })

    it('test_base_assert', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer();
        expect(bb.noAssert).assertFalse();
        expect(bb.assert(false)).assertEqual(bb);
        expect(bb.noAssert).assertTrue();
        expect(bb.assert(true)).assertEqual(bb);
        expect(bb.noAssert).assertFalse();
      }
    })

    it('test_wrap_ArrayBuffer', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ArrayBuffer(1);
        var bb = ByteBuffer.wrap(buf);
        expect(bb.capacity()).assertEqual(1);
        expect(bb.buffer).assertEqual(buf);
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(1);
      }
    })

    it('test_wrap_Uint8Array', 0, function () {
      for (var i = 0; i < 10; ++i) {
        // Full view
        var buf = new Uint8Array(1);
        buf[0] = 0x01;
        var bb = ByteBuffer.wrap(buf);
        expect(bb.capacity()).assertEqual(1);
        expect(bb.buffer).assertEqual(buf.buffer);
        expect(bb.toDebug()).assertEqual("<01>");

        // Partial view (not on node, node copies)
        if (type === ArrayBuffer) {
          buf = new Uint8Array(3);
          buf[0] = 0x01;
          buf[1] = 0x02;
          buf[2] = 0x03;
          buf = new Uint8Array(buf.buffer, 1, 1);
          bb = ByteBuffer.wrap(buf);
          expect(bb.capacity()).assertEqual(3);
          expect(bb.toDebug()).assertEqual("01<02>03");
        }
      }
    })

    it('test_wrap_Array', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var arr = [1, 255, -1];
        var bb = ByteBuffer.wrap(arr);
        expect(bb.capacity()).assertEqual(3);
        expect(bb.toDebug()).assertEqual("<01 FF FF>");
      }
    })

    it('test_wrap_ByteBuffer', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb2 = ByteBuffer.wrap("\x12\x34\x56\x78", "binary");
        bb2.offset = 1;
        var bb = ByteBuffer.wrap(bb2);
        expect(bb2.offset).assertEqual(bb.offset);
        expect(bb2.limit).assertEqual(bb.limit);
        expect(bb2.capacity()).assertEqual(bb.capacity());
        expect(bb2.toString("debug")).assertEqual(bb.toString("debug"));
      }
    })

    it('test_wrap_string', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\u0061\u0062");
        expect(bb.toDebug()).assertEqual("<61 62>");
      }
    })

    it('test_encodings_UTF8', 0, function () {
      expect(ByteBuffer.fromUTF8("aäöüß€b").toUTF8()).assertEqual('aäöüß€b')
      expect(ByteBuffer.fromUTF8("nihao").toUTF8()).assertEqual('nihao')
      expect(ByteBuffer.fromUTF8("你好").toUTF8()).assertEqual('你好')
      expect(ByteBuffer.fromUTF8("").toUTF8()).assertEqual('')
      expect(ByteBuffer.fromUTF8("안녕하세요").toUTF8()).assertEqual('안녕하세요')
      for (var i = 0; i < 10; ++i) {
        ["aäöüß€b", ""].forEach(function (str) {
          var bb = ByteBuffer.wrap(str, "utf8"); // Calls ByteBuffer#fromUTF8
          expect(bb.toUTF8()).assertEqual(str);
          if (str.length > 2) {
            bb.offset = 1;
            bb.limit = bb.capacity() - 1;
            expect(bb.toUTF8()).assertEqual(str.substring(1, str.length - 1));
          }
        });
      }
    })

    it('test_encodings_UTF8_2', 0, function () {
      for (var i = 0; i < 10; ++i) {
        ["aäöüß€b", ""].forEach(function (str) {
          var bb = ByteBuffer.fromUTF8(str); // Calls ByteBuffer#fromUTF8
          expect(bb.toUTF8()).assertEqual(str);
          if (str.length > 2) {
            bb.offset = 1;
            bb.limit = bb.capacity() - 1;
            expect(bb.toUTF8()).assertEqual(str.substring(1, str.length - 1));
          }
        });
      }
    })

    it('test_encodings_debug', 0, function () {
      expect(ByteBuffer.fromDebug("60<61 62]63").toDebug()).assertEqual("60<61 62]63");
      expect(ByteBuffer.fromDebug("<60 61 62 63]").toDebug()).assertEqual("<60 61 62 63]");
      expect(ByteBuffer.fromDebug("|").toDebug()).assertEqual("|");
      expect(ByteBuffer.fromDebug("|61").toDebug()).assertEqual("|61");
      expect(ByteBuffer.fromDebug("<61>").toDebug()).assertEqual("<61>");
      expect(ByteBuffer.fromDebug("!12").toDebug()).assertEqual("!12");

      for (var i = 0; i < 10; ++i) {
        ["60<61 62]63", "<60 61 62 63]", "|", "|61", "<61>", "!12"].forEach(function (str) {
          var bb = ByteBuffer.wrap(str, "debug"); // Calls ByteBuffer#fromDebug
          expect(bb.toDebug()).assertEqual(str);
        });
      }
    })

    it('test_encodings_binary', 0, function () {
      for (var i = 0; i < 10; ++i) {
        ["\x61\x62\x63\x64", "", "  "].forEach(function (str) {
          var bb = ByteBuffer.wrap(str, "binary"); // Calls ByteBuffer#fromBinary
          expect(bb.toBinary()).assertEqual(str);
          if (str.length > 2) {
            bb.offset = 1;
            bb.limit = bb.capacity() - 1;
            expect(bb.toBinary()).assertEqual(str.substring(1, str.length - 1));
          }
        });
      }
    })

    it('test_encodings_hex', 0, function () {

      expect(ByteBuffer.fromHex("61626364").toHex()).assertEqual('61626364')
      expect(ByteBuffer.fromHex("67").toHex()).assertEqual('67')
      expect(ByteBuffer.fromHex("61").toHex()).assertEqual('61')
      expect(ByteBuffer.fromHex("").toHex()).assertEqual('')
      expect(ByteBuffer.fromHex("35").toHex()).assertEqual('35')
      for (var i = 0; i < 10; ++i) {
        ["61626364", "61", ""].forEach(function (str) {
          var bb = ByteBuffer.wrap(str, "hex"); // Calls ByteBuffer#fromHex
          expect(bb.toHex()).assertEqual(str);
          if (str.length > 2) {
            bb.offset = 1;
            bb.limit = bb.capacity() - 1;
            expect(bb.toHex()).assertEqual(str.substring(2, str.length - 2));
          }
        });
      }
    })

    it('test_encodings_base64', 0, function () {
      for (var i = 0; i < 10; ++i) {
        ["", "YWI=", "YWJjZGVmZw==", "YWJjZGVmZ2g=", "YWJjZGVmZ2hp"].forEach(function (str) {
          var bb = ByteBuffer.wrap(str, "base64"); // Calls ByteBuffer#fromBase64
          expect(bb.toBase64()).assertEqual(str);
          if (str.length > 8) {
            bb.offset = 3;
            bb.limit = bb.offset + 3;
            expect(bb.toBase64()).assertEqual(str.substr(4, 4));
          }
        });
      }
    })

    it('test_encodings_fromBase64', 0, function () {
      expect(ByteBuffer.fromBase64("").toBase64()).assertEqual("");
      expect(ByteBuffer.fromBase64("YWI=").toBase64()).assertEqual("YWI=");
      expect(ByteBuffer.fromBase64("YWJjZGVmZw==").toBase64()).assertEqual("YWJjZGVmZw==");
      expect(ByteBuffer.fromBase64("YWJjZGVmZ2g=").toBase64()).assertEqual("YWJjZGVmZ2g=");
      expect(ByteBuffer.fromBase64("YWJjZGVmZ2hp").toBase64()).assertEqual("YWJjZGVmZ2hp");
    })

    it('test_methods_concat', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bbs = [
          new ArrayBuffer(1),
        ByteBuffer.fromDebug('00<01 02>'),
        ByteBuffer.fromDebug('00 01 02<03>00'),
        ByteBuffer.fromDebug('00|'),
        ByteBuffer.fromDebug('<04>'),
          new ArrayBuffer(0),
          new Uint8Array(0),
          '05'
        ];
        var bb = ByteBuffer.concat(bbs, 'hex',!ByteBuffer.DEFAULT_ENDIAN,!ByteBuffer.DEFAULT_NOASSERT);
        expect(bb.littleEndian).assertEqual(!ByteBuffer.DEFAULT_ENDIAN);
        expect(bb.noAssert).assertEqual(!ByteBuffer.DEFAULT_NOASSERT);
        expect(bb.toDebug()).assertEqual('<00 01 02 03 04 05>');
        bb = ByteBuffer.concat([]);
        expect(bb.buffer).assertEqual(new ByteBuffer(0).buffer); // EMPTY_BUFFER
      }
    })

    it('test_methods_resize', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer(1);
        bb.offset = 1;
        bb.resize(2);
        bb.fill(0, 0, 2);
        expect(bb.capacity()).assertEqual(2);
        expect(bb.toDebug()).assertEqual("00|00");
      }
    })

    it('test_methods_ensureCapacity', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer(5);
        expect(bb.capacity()).assertEqual(5);
        bb.ensureCapacity(6); // Doubles
        expect(bb.capacity()).assertEqual(10);
        bb.ensureCapacity(21); // Uses 21
        expect(bb.capacity()).assertEqual(21);
      }
    })

    it('test_methods_slice', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer.wrap("\x12\x34\x56"),
          bb2 = bb.slice(1, 2);
        expect(bb.buffer).assertEqual(bb2.buffer);
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(3);
        expect(bb2.offset).assertEqual(1);
        expect(bb2.limit).assertEqual(2);
      }
    })

    it('test_methods_flip', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap('\x12\x34\x56\x78');
        bb.offset = 4;
        expect(bb.offset).assertEqual(4);
        expect(bb.limit).assertEqual(4);

        bb.flip();
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(4);
      }
    })

    it('test_methods_mark', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap('\x12\x34\x56\x78');
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(4);
        expect(bb.markedOffset).assertEqual(-1);
        bb.mark();
        expect(bb.markedOffset).assertEqual(0);
      }
    })

    it('test_methods_reset', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap('\x12\x34\x56\x78');
        bb.reset();
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(4);
        bb.offset = 1;
        bb.mark();
        expect(bb.markedOffset).assertEqual(1);
        bb.reset();
        expect(bb.offset).assertEqual(1);
        expect(bb.markedOffset).assertEqual(-1);
      }
    })

    it('test_methods_copy', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x01",!ByteBuffer.DEFAULT_ENDIAN),
          bb2 = bb.copy();
        expect(bb.offset).assertEqual(0);
        expect(JSON.stringify(bb)).assertEqual(JSON.stringify(bb2));
        expect(JSON.stringify(bb.buffer)).assertEqual(JSON.stringify(bb2.buffer));
        expect(bb2.offset).assertEqual(bb.offset);
        expect(bb2.limit).assertEqual(bb.limit);
        expect(bb2.markedOffset).assertEqual(bb.markedOffset);
        expect(bb2.littleEndian).assertEqual(bb.littleEndian);
        expect(bb2.noAssert).assertEqual(bb.noAssert);
      }
    })

    it('test_methods_copyTo', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x01"),
          bb2 = new ByteBuffer(2).fill(0).flip();
        expect(bb.toDebug()).assertEqual("<01>");
        // Modifies source and target offsets
        bb.copyTo(bb2 /* all offsets omitted */
        );
        expect(bb.toDebug()).assertEqual("01|"); // Read 1 byte
        expect(bb2.toDebug()).assertEqual("01<00>"); // Written 1 byte
        bb.reset();
        expect(bb.toDebug()).assertEqual("<01>");
        // Again, but with bb2.offset=1
        bb.copyTo(bb2 /* all offsets omitted */
        );
        expect(bb.toDebug()).assertEqual("01|"); // Read 1 byte
        expect(bb2.toDebug()).assertEqual("01 01|"); // Written 1 byte at 2
        bb.reset();
        bb2.clear().fill(0).flip();
        // Modifies source offsets only
        bb.copyTo(bb2, 0 /* source offsets omitted */
        );
        expect(bb.toDebug()).assertEqual("01|"); // Read 1 byte
        expect(bb2.toDebug()).assertEqual("<01 00>"); // Written 1 byte (no change)
        // Modifies no offsets at all
        bb.reset();
        bb2.fill(0).flip();
        bb.copyTo(bb2, 1, 0, bb.capacity() /* no offsets omitted */
        );
        expect(bb.toDebug()).assertEqual("<01>"); // Read 1 byte (no change)
        expect(bb2.toDebug()).assertEqual("<00 01>"); // Written 1 byte (no change)
      }
    })

    it('test_methods_compact', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x01\x02");
        bb.limit = 1;
        bb.markedOffset = 2;
        var prevBuffer = bb.buffer,
          prevView = bb.view;
        bb.compact();
        expect(bb.buffer !== prevBuffer).assertTrue();
        if (type === ArrayBuffer) {
          expect(bb.buffer === prevView).assertFalse();
        }
        expect(bb.capacity()).assertEqual(1);
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(1);
        expect(bb.markedOffset).assertEqual(2); // Actually out of bounds

        // Empty region
        bb.offset = 1;
        prevBuffer = bb.buffer;
        bb.compact();
        expect(bb.buffer === prevBuffer).assertFalse();
        expect(bb.buffer === new ByteBuffer(0).buffer).assertTrue(); // EMPTY_BUFFER
        if (type === ArrayBuffer) {
          expect(bb.view === null).assertTrue();
        }
        expect(bb.capacity()).assertEqual(0);
        expect(bb.offset).assertEqual(0);
        expect(bb.limit).assertEqual(0);
      }
    })

    it('test_methods_reverse', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x12\x34\x56\x78");
        bb.reverse(1, 3);
        expect(bb.toString("debug")).assertEqual("<12 56 34 78>");
        bb.reverse();
        expect(bb.toString("debug")).assertEqual("<78 34 56 12>");
        bb.offset = 1;
        bb.limit = 3;
        bb.reverse();
        expect(bb.toString("debug")).assertEqual("78<56 34>12");
        bb.reverse(0, 4).clear();
        expect(bb.toString("debug")).assertEqual("<12 34 56 78>");
      }
    })

    it('test_methods_readBytes', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = new ByteBuffer("\x12\x34");
        var bb2 = new ByteBuffer("\x56\x78");
        bb.offset = 2;
        bb.noAssert = true;
        bb.append(bb2); // Modifies offsets of both
        expect(bb.readBytes(4).limit).assertEqual(6);
        expect(bb.readBytes(2).limit).assertEqual(8);
      }
    })

    it('test_methods_appendTo', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb2 = new ByteBuffer("\x12\x34");
        var bb = new ByteBuffer("\x56\x78");
        bb.noAssert = true;

        bb2.offset = 2;
        bb2.noAssert = true;
        bb2.appendTo(bb); // Modifies offsets of both
        expect(bb.readBytes(4).limit).assertEqual(4);
        expect(bb.readBytes(2).limit).assertEqual(6);
      }
    })

    // int8:[-128-127]
    it('test_methods_writeInt8', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeInt8(-128);
        buf.writeInt8(-129);
        buf.writeInt8(127);
        buf.writeInt8(128);
        buf.writeInt8(256);
        buf.writeInt8(-257);
        expect(buf.readInt8(0)).assertEqual(-128);
        expect(buf.readInt8(1)).assertEqual(127);
        expect(buf.readInt8(2)).assertEqual(127);
        expect(buf.readInt8(3)).assertEqual(-128);
        expect(buf.readInt8(4)).assertEqual(0);
        expect(buf.readInt8(5)).assertEqual(-1);
      }
    })

    it('test_methods_writeByte', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeByte(5);
        buf.writeByte(10);
        buf.writeByte(20);
        buf.writeByte(30);
        buf.writeByte(40);
        expect(buf.readByte(0)).assertEqual(5);
        expect(buf.readByte(1)).assertEqual(10);
        expect(buf.readByte(2)).assertEqual(20);
        expect(buf.readByte(3)).assertEqual(30);
        expect(buf.readByte(4)).assertEqual(40);
      }
    })

    // uint8：[0,255]
    it('test_methods_writeUint8', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeUint8(-1, 0);
        buf.writeUint8(127, 1);
        buf.writeUint8(128, 2);
        buf.writeUint8(255, 3);
        buf.writeUint8(256, 4);
        buf.writeUint8(-257, 5);
        expect(buf.readUint8(0)).assertEqual(255);
        expect(buf.readUint8(1)).assertEqual(127);
        expect(buf.readUint8(2)).assertEqual(128);
        expect(buf.readUint8(3)).assertEqual(255);
        expect(buf.readUint8(4)).assertEqual(0);
        expect(buf.readUint8(5)).assertEqual(255);
      }
    })

    // uint8：[0,255]
    it('test_methods_writeUInt8', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeUInt8(3, 0);
        buf.writeUInt8(4, 1);
        buf.writeUInt8(23, 2);
        buf.writeUInt8(128, 3);
        buf.writeUInt8(256, 4);
        expect(buf.readUInt8(0)).assertEqual(3);
        expect(buf.readUInt8(1)).assertEqual(4);
        expect(buf.readUInt8(2)).assertEqual(23);
        expect(buf.readUInt8(3)).assertEqual(128);
        expect(buf.readUInt8(4)).assertEqual(0);
      }
    })

    // int16: [-32768,32767]
    it('test_methods_writeInt16', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeInt16(-32769);
        buf.writeInt16(-32768);
        buf.writeInt16(-32767);
        buf.writeInt16(32767);
        buf.writeInt16(32768);
        expect(buf.readInt16(0)).assertEqual(32767);
        expect(buf.readInt16(2)).assertEqual(-32768);
        expect(buf.readInt16(4)).assertEqual(-32767);
        expect(buf.readInt16(6)).assertEqual(32767);
        expect(buf.readInt16(8)).assertEqual(-32768);
      }
    })

    // int16: [-32768,32767]
    it('test_methods_writeShort', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeShort(0x3, 0);
        buf.writeShort(0x4, 1);
        buf.writeShort(0x23, 2);
        buf.writeShort(0x42, 3);
        buf.writeShort(0x55, 4);
        expect(buf.readShort(0)).assertEqual(0x0);
        expect(buf.readShort(1)).assertEqual(0x0);
        expect(buf.readShort(2)).assertEqual(0x0);
        expect(buf.readShort(3)).assertEqual(0x0);
        expect(buf.readShort(4)).assertEqual(0x55);
      }
    })

    // uint16:[0-65535]
    it('test_methods_writeUInt16', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeUInt16(-1);
        buf.writeUInt16(0);
        buf.writeUInt16(50);
        buf.writeUInt16(65535);
        buf.writeUInt16(65536);
        expect(buf.readUInt16(0)).assertEqual(65535);
        expect(buf.readUInt16(2)).assertEqual(0);
        expect(buf.readUInt16(4)).assertEqual(50);
        expect(buf.readUInt16(6)).assertEqual(65535);
        expect(buf.readUInt16(8)).assertEqual(0);
      }
    })

    // uint16:[0-65535]
    it('test_methods_writeUint16', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.writeUint16(0x3, 0);
        buf.writeUint16(0x4, 1);
        buf.writeUint16(0x23, 2);
        buf.writeUint16(0x42, 3);
        buf.writeUint16(0x55, 4);
        expect(buf.readUint16(0)).assertEqual(0x0);
        expect(buf.readUint16(1)).assertEqual(0x0);
        expect(buf.readUint16(2)).assertEqual(0x0);
        expect(buf.readUint16(3)).assertEqual(0x0);
        expect(buf.readUint16(4)).assertEqual(0x55);
      }
    })

    // int32 [-2147483648-2147483647]
    it('test_methods_writeInt32', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeInt32(-2147483649);
        buf.writeInt32(-2147483648);
        buf.writeInt32(0);
        buf.writeInt32(2147483647);
        buf.writeInt32(2147483648);

        expect(buf.readInt32(0)).assertEqual(2147483647);
        expect(buf.readInt32(4)).assertEqual(-2147483648);
        expect(buf.readInt32(8)).assertEqual(0);
        expect(buf.readInt32(12)).assertEqual(2147483647);
        expect(buf.readInt32(16)).assertEqual(-2147483648);
      }
    })

    // int32 [-2147483648-2147483647]
    it('test_methods_writeInt', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeInt(-2147483649);
        buf.writeInt(-2147483648);
        buf.writeInt(0);
        buf.writeInt(2147483647);
        buf.writeInt(2147483648);

        expect(buf.readInt(0)).assertEqual(2147483647);
        expect(buf.readInt(4)).assertEqual(-2147483648);
        expect(buf.readInt(8)).assertEqual(0);
        expect(buf.readInt(12)).assertEqual(2147483647);
        expect(buf.readInt(16)).assertEqual(-2147483648);
      }
    })

    // uint32 [0-4294967295]
    it('test_methods_writeUint32', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeUint32(-1);
        buf.writeUint32(0);
        buf.writeUint32(4294967295);
        buf.writeUint32(4294967296);
        buf.writeUint32(-4294967296);

        expect(buf.readUint32(0)).assertEqual(4294967295);
        expect(buf.readUint32(4)).assertEqual(0);
        expect(buf.readUint32(8)).assertEqual(4294967295);
        expect(buf.readUint32(12)).assertEqual(0);
        expect(buf.readUint32(16)).assertEqual(0);
      }
    })

    // uint32 [0-4294967295]
    it('test_methods_writeUInt32', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeUInt32(-1);
        buf.writeUInt32(0);
        buf.writeUInt32(4294967295);
        buf.writeUInt32(4294967296);
        buf.writeUInt32(-4294967296);

        expect(buf.readUInt32(0)).assertEqual(4294967295);
        expect(buf.readUInt32(4)).assertEqual(0);
        expect(buf.readUInt32(8)).assertEqual(4294967295);
        expect(buf.readUInt32(12)).assertEqual(0);
        expect(buf.readUInt32(16)).assertEqual(0);
      }
    })

    // int64 [-9223372036854775808-9223372036854775807]
    it('test_methods_writeInt64', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeInt64(-9223372036854775807);
        buf.writeInt64(-9223372036854775808);
        buf.writeInt64(0);
        buf.writeInt64(9223372036854775807);
        buf.writeInt64(9223372036854775808);

        expect(buf.readInt64(0).toString()).assertEqual('-9223372036854775808');
        expect(buf.readInt64(8).toString()).assertEqual('-9223372036854775808');
        expect(buf.readInt64(16).toString()).assertEqual('0');
        expect(buf.readInt64(24).toString()).assertEqual('9223372036854775807');
        expect(buf.readInt64(32).toString()).assertEqual('9223372036854775807');
      }
    })

    // int64 [-9223372036854775808-9223372036854775807]
    it('test_methods_writeLong', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeLong(-9223372036854775807);
        buf.writeLong(-9223372036854775808);
        buf.writeLong(0);
        buf.writeLong(9223372036854775807);
        buf.writeLong(9223372036854775808);

        expect(buf.readLong(0).toString()).assertEqual('-9223372036854775808');
        expect(buf.readLong(8).toString()).assertEqual('-9223372036854775808');
        expect(buf.readLong(16).toString()).assertEqual('0');
        expect(buf.readLong(24).toString()).assertEqual('9223372036854775807');
        expect(buf.readLong(32).toString()).assertEqual('9223372036854775807');
      }
    })


    it('test_methods_writeUint64', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeUint64(-1);
        buf.writeUint64(-2);
        buf.writeUint64(256);
        buf.writeUint64(0);
        buf.writeUint64(18446744073709551615);

        expect(buf.readUint64(0).toString()).assertEqual('18446744073709551615');
        expect(buf.readUint64(8).toString()).assertEqual('18446744073709551614');
        expect(buf.readUint64(16).toString()).assertEqual('256');
        expect(buf.readUint64(24).toString()).assertEqual('0');
        expect(buf.readUint64(32).toString()).assertEqual('9223372036854775807');
      }
    })

    it('test_methods_writeUInt64', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeUInt64(-1);
        buf.writeUInt64(-2);
        buf.writeUInt64(256);
        buf.writeUInt64(0);
        buf.writeUInt64(18446744073709551615);

        expect(buf.readUInt64(0).toString()).assertEqual('18446744073709551615');
        expect(buf.readUInt64(8).toString()).assertEqual('18446744073709551614');
        expect(buf.readUInt64(16).toString()).assertEqual('256');
        expect(buf.readUInt64(24).toString()).assertEqual('0');
        expect(buf.readUInt64(32).toString()).assertEqual('9223372036854775807');
      }
    })

    it('test_methods_writeFloat32', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeFloat32(50.06666666666);
        buf.writeFloat32(-2.3);
        buf.writeFloat32(-3.66666666);
        buf.writeFloat32(-256.0);
        buf.writeFloat32(128);

        expect(buf.readFloat32(0).toString()).assertEqual('50.06666564941406');
        expect(buf.readFloat32(4).toString()).assertEqual('-2.299999952316284');
        expect(buf.readFloat32(8).toString()).assertEqual('-3.6666667461395264');
        expect(buf.readFloat32(12).toString()).assertEqual('-256');
        expect(buf.readFloat32(16).toString()).assertEqual('128');
      }
    })

    it('test_methods_writeFloat', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeFloat(50.06666666666);
        buf.writeFloat(-2.3);
        buf.writeFloat(-3.66666666);
        buf.writeFloat(-256.0);
        buf.writeFloat(128);

        expect(buf.readFloat(0).toString()).assertEqual('50.06666564941406');
        expect(buf.readFloat(4).toString()).assertEqual('-2.299999952316284');
        expect(buf.readFloat(8).toString()).assertEqual('-3.6666667461395264');
        expect(buf.readFloat(12).toString()).assertEqual('-256');
        expect(buf.readFloat(16).toString()).assertEqual('128');
      }
    })


    it('test_methods_writeFloat64', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeFloat64(50.06666666666);
        buf.writeFloat64(-2.3);
        buf.writeFloat64(-3.66666666);
        buf.writeFloat64(-256.0);
        buf.writeFloat64(128);

        expect(buf.readFloat64(0).toString()).assertEqual('50.06666666666');
        expect(buf.readFloat64(8).toString()).assertEqual('-2.3');
        expect(buf.readFloat64(16).toString()).assertEqual('-3.66666666');
        expect(buf.readFloat64(24).toString()).assertEqual('-256');
        expect(buf.readFloat64(32).toString()).assertEqual('128');
      }
    })

    it('test_methods_writeDouble', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var buf = new ByteBuffer();
        buf.noAssert = true
        buf.writeDouble(50.06666666666);
        buf.writeDouble(-2.3);
        buf.writeDouble(-3.66666666);
        buf.writeDouble(-256.0);
        buf.writeDouble(128);

        expect(buf.readDouble(0).toString()).assertEqual('50.06666666666');
        expect(buf.readDouble(8).toString()).assertEqual('-2.3');
        expect(buf.readDouble(16).toString()).assertEqual('-3.66666666');
        expect(buf.readDouble(24).toString()).assertEqual('-256');
        expect(buf.readDouble(32).toString()).assertEqual('128');
      }
    })

    it('test_methods_append', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x12\x34");
        var bb2 = ByteBuffer.wrap("\x56\x78");
        bb.offset = 2;
        bb.append(bb2); // Modifies offsets of both
        expect(bb.toString("debug")).assertEqual("12 34>56 78<");
        expect(bb2.toString("debug")).assertEqual("56 78|");
        bb2.reset();
        bb.append(bb2, 1); // Modifies offsets of bb2 only
        expect(bb.toString("debug")).assertEqual("12 56>78 78<");
        expect(bb2.toString("debug")).assertEqual("56 78|");
      }
    })

    it('test_methods_prepend', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x12\x34"),
          bb2 = ByteBuffer.wrap("\x56\x78");
        expect(bb.prepend(bb2) === bb).assertTrue(); // Relative prepend at 0, 2 bytes (2 overflow)
        expect(bb.toDebug()).assertEqual("<56 78 12 34>");
        expect(bb2.toDebug()).assertEqual("56 78|");
        bb.offset = 4;
        bb2.offset = 1;
        bb.prepend(bb2, 3); // Absolute prepend at 3, 1 byte
        expect(bb.toDebug()).assertEqual("56 78 78 34|");
        expect(bb2.toDebug()).assertEqual("56 78|");
        bb2.offset = 0;
        bb.prepend(bb2); // Relative prepend at 4, 2 bytes
        expect(bb.toDebug()).assertEqual("56 78<56 78>");
        expect(bb2.toDebug()).assertEqual("56 78|");
        bb.offset = 3;
        bb2.offset = 0;
        bb.prepend("abcde", "utf8"); // Relative prepend at 3, 5 bytes (1 overflow)
        expect(bb.toDebug()).assertEqual("<61 62 63 64 65 78>");
      }
    })

    it('test_methods_prependTo', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x12\x34"),
          bb2 = ByteBuffer.wrap("\x56\x78");
        expect(bb2.prependTo(bb) === bb2).assertTrue();
        expect(bb.toDebug()).assertEqual("<56 78 12 34>");
        expect(bb2.toDebug()).assertEqual("56 78|");
      }
    })

    it('test_methods_remaining', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x12\x34");
        expect(bb.remaining() === 2).assertTrue();
        bb.offset = 2;
        expect(bb.remaining() === 0).assertTrue();
        bb.offset = 3;
        expect(bb.remaining() === -1).assertTrue();
      }
    })

    it('test_methods_skip', 0, function () {
      for (var i = 0; i < 10; ++i) {
        var bb = ByteBuffer.wrap("\x12\x34\x56");
        expect(bb.offset === 0).assertTrue();
        bb.skip(3);
        expect(bb.offset === 3).assertTrue();
        expect(bb.noAssert === false).assertTrue();
        bb.noAssert = true;
        bb.skip(1);
        expect(bb.offset === 4).assertTrue();
      }
    })

    it('test_methods_order', 0, function () {
      for (var i = 0; i < 10; ++i) {
        expect(ByteBuffer.LITTLE_ENDIAN).assertTrue();
        expect(ByteBuffer.BIG_ENDIAN).assertFalse();
        var bb = new ByteBuffer(2);
        expect(bb.littleEndian === false).assertTrue();
        bb.writeInt32(0x12345678);
        bb.flip();
        expect(bb.toHex() === "12345678").assertTrue();
        bb.clear();
        expect(bb.LE() === bb).assertTrue();
        expect(bb.littleEndian === true).assertTrue();
        bb.writeInt32(0x12345678);
        bb.flip();
        expect(bb.toHex() === "78563412").assertTrue();
        expect(bb.BE() === bb).assertTrue();
        expect(bb.littleEndian === false).assertTrue();
        expect(bb.order(ByteBuffer.LITTLE_ENDIAN) === bb).assertTrue();
        expect(bb.littleEndian === true).assertTrue();
        expect(bb.order(ByteBuffer.BIG_ENDIAN) === bb).assertTrue();
        expect(bb.littleEndian === false).assertTrue();
      }
    })


    var types = [
    // name          | alias   | size | input                                   | output                                  | BE representation
      ["Int8", "Byte", 1, 0xFE, -2, "fe"],
      ["Uint8", null, 1, -2, 0xFE, "fe"],
      ["Int16", "Short", 2, 0xFFFE, -2, "fffe"],
      ["Uint16", null, 2, -2, 0xFFFE, "fffe"],
      ["Int32", "Int", 4, 0xFFFFFFFE, -2, "fffffffe"],
      ["Uint32", null, 4, -2, 0xFFFFFFFE, "fffffffe"],
      ["Float32", "Float", 4, 0.5, 0.5, "3f000000"],
      ["Float64", "Double", 8, 0.1, 0.1, "3fb999999999999a"],
      ["Int64", "Long", 8, new Long(0xFFFFFFFE, 0xFFFFFFFF, true), new Long(0xFFFFFFFE, 0xFFFFFFFF, false), "fffffffffffffffe"],
      ["Uint64", null, 8, new Long(0xFFFFFFFE, 0xFFFFFFFF, false), new Long(0xFFFFFFFE, 0xFFFFFFFF, true), "fffffffffffffffe"],

      // name          | alias   | size | input                                   | output                                  | representation
      ["Varint32", null, 5, 0xFFFFFFFE, -2, "feffffff0f"],
      ["Varint32ZigZag", null, 1, -1, -1, "01"],
      ["Varint64", null, 10, new Long(0xFFFFFFFE, 0xFFFFFFFF, true), new Long(0xFFFFFFFE, 0xFFFFFFFF, false), "feffffffffffffffff01"],
      ["Varint64ZigZag", null, 1, Long.fromNumber(-1), Long.fromNumber(-1), "01"]
    ];

    it('test_methods_types', 0, function () {
      types.forEach(function (type) {
        var name = type[0],
          varint = name.indexOf("Varint") >= 0,
          alias = type[1],
          size = type[2],
          input = type[3],
          output = type[4],
          be = type[5],
          le = "";
        for (var i = be.length; i > 0; i -= 2) {
          le += be.substr(i - 2, 2);
        }

        var bb = new ByteBuffer(size);
        // Relative BE (always LE for varints)
        expect(bb["write"+name](input) === bb).assertTrue();
        bb.flip();
        var val = bb["read"+name]();
        expect(JSON.stringify(val) == JSON.stringify(output)).assertTrue();
        bb.flip();
        expect(bb.toHex() === be).assertTrue();
        if (!varint) {
          // Relative LE
          bb.LE();
          bb["write"+name](input);
          bb.flip();
          val = bb["read"+name]();
          expect(JSON.stringify(val) === JSON.stringify(output)).assertTrue();
          bb.flip();
          expect(JSON.stringify(bb.toHex()) === JSON.stringify(le)).assertTrue();
        }
        try {
          bb.offset = bb.capacity() - size + 1;
          bb["read"+name](input);
        } catch (error) {

        }
        // test.doesNotThrow(function() { // OOB, automatic resizing * 2
        bb["write"+name](input);
        // });
        expect(bb.capacity() === size * 2).assertTrue();
        // Absolute
        bb.clear();
        if (!varint)
          expect(bb["write"+name](input, 1) === bb).assertTrue();
        else
          expect(bb["write"+name](input, 1) === size).assertTrue();
        val = bb["read"+name](1);
        if (output instanceof Long) {
          if (!varint)
            expect(JSON.stringify(val) == JSON.stringify(output)).assertTrue();
          else
            expect(JSON.stringify(val)).assertEqual(JSON.stringify({
              value: output, length: size
            }));
        } else {
          if (!varint)
            expect(val === output).assertTrue();
          else
            expect(JSON.stringify(val)).assertEqual(JSON.stringify({
              value: output, length: size
            }));
        }
        // Alias
        if (alias) {
          expect(bb["write"+name] === bb["write"+alias]).assertTrue();
          expect(bb["read"+name] === bb["read"+alias]).assertTrue();
        }
      });
    })

    it('test_types_bitset', 0, function () {
      var bb = new ByteBuffer(2);

      function run(data) {
        bb.reset();
        bb.writeBitSet(data);
        bb.reset();
        expect(JSON.stringify(bb.readBitSet())).assertEqual(JSON.stringify(data));
      };

      run([]);
      run([true]);
      run([false]);
      run([false, true]);
      run([false, false, false, false, false, false, false, false]);
      run([true, false, true, false, true, false, true, false]);
      run([true, true, true, true, true, true, true, true]);
      run([true, false, true, false, true, false, true, false]);
      run([true, false, true, false, true, false, true, false, true]);

      bb.reset();
      bb.writeBitSet([, null, "", 0, 42, "hello world", new Date(0), {}, []]);
      bb.reset();
      expect(JSON.stringify(bb.readBitSet()))
        .assertEqual(JSON.stringify([false, false, false, false, true, true, true, true, true]));
    })

    it('test_types_calculateVarint', 0, function () {
      expect(ByteBuffer.MAX_VARINT32_BYTES).assertEqual(5);
      expect(ByteBuffer.MAX_VARINT64_BYTES).assertEqual(10);
      var values = [
        [0, 1],
        [-1, 5, 10],
        [1 << 7, 2],
        [1 << 14, 3],
        [1 << 21, 4],
        [1 << 28, 5],
        [0x7FFFFFFF | 0, 5],
        [0xFFFFFFFF, 5],
        [0xFFFFFFFF | 0, 5, 10]
      ];
      for (var i = 0; i < values.length; i++) {
        expect(ByteBuffer.calculateVarint32(values[i][0])).assertEqual(values[i][1]);
        expect(ByteBuffer.calculateVarint64(values[i][0]))
          .assertEqual(values[i].length > 2 ? values[i][2] : values[i][1]);
      }
      var Long = ByteBuffer.Long;
      values = [
        [Long.fromNumber(1).shiftLeft(35), 6],
        [Long.fromNumber(1).shiftLeft(42), 7],
        [Long.fromNumber(1).shiftLeft(49), 8],
        [Long.fromNumber(1).shiftLeft(56), 9],
        [Long.fromNumber(1).shiftLeft(63), 10],
        [Long.fromNumber(1, true).shiftLeft(63), 10]
      ];
      for (i = 0; i < values.length; i++) {
        expect(ByteBuffer.calculateVarint64(values[i][0])).assertEqual(values[i][1]);
      }
    })

    it('test_types_zigZagVarint', 0, function () {
      var Long = ByteBuffer.Long;
      var values = [
        [0, 0],
        [-1, 1],
        [1, 2],
        [-2, 3],
        [2, 4],
        [-3, 5],
        [3, 6],
        [2147483647, 4294967294],
        [-2147483648, 4294967295]
      ];
      for (var i = 0; i < values.length; i++) {
        expect(ByteBuffer.zigZagEncode32(values[i][0])).assertEqual(values[i][1]);
        expect(ByteBuffer.zigZagDecode32(values[i][1])).assertEqual(values[i][0]);
        expect(ByteBuffer.zigZagEncode64(values[i][0]).toNumber()).assertEqual(values[i][1]);
        expect(ByteBuffer.zigZagDecode64(values[i][1]).toNumber()).assertEqual(values[i][0]);
      }
      values = [
        [Long.MAX_VALUE, Long.MAX_UNSIGNED_VALUE.subtract(Long.ONE)],
        [Long.MIN_VALUE, Long.MAX_UNSIGNED_VALUE]
      ];
      // NOTE: Even 64bit doubles from toNumber() fail for these values so we are using toString() here
      for (i = 0; i < values.length; i++) {
        expect(ByteBuffer.zigZagEncode64(values[i][0]).toString()).assertEqual(values[i][1].toString());
        expect(ByteBuffer.zigZagDecode64(values[i][1]).toString()).assertEqual(values[i][0].toString());
      }

      // 32 bit ZZ
      var values2 = [
        0,
        1,
        300,
        -300,
        2147483647,
        -2147483648
      ];
      bb = new ByteBuffer(10);
      for (i = 0; i < values2.length; i++) {
        var encLen = bb.writeVarint32ZigZag(values2[i], 0);
        bb.limit = encLen;
        var dec = bb.readVarint32ZigZag(0);
        expect(dec['value']).assertEqual(values2[i]);
        expect(encLen).assertEqual(dec['length']);
        bb.clear();
      }

      // 64 bit ZZ
      values = [
      Long.ONE, 1,
      Long.fromNumber(-3),
      Long.fromNumber(300),
      Long.fromNumber(-300),
      Long.fromNumber(0x7FFFFFFF),
      Long.fromNumber(0x8FFFFFFF),
      Long.fromNumber(0xFFFFFFFF),
      Long.fromBits(0xFFFFFFFF, 0x7FFFFFFF),
      Long.fromBits(0xFFFFFFFF, 0xFFFFFFFF)
      ];
      var bb = new ByteBuffer(10);
      for (i = 0; i < values.length; i++) {
        encLen = bb.writeVarint64ZigZag(values[i], 0);
        dec = bb.readVarint64ZigZag(0);
        expect(values[i].toString()).assertEqual(dec['value'].toString());
        expect(encLen).assertEqual(dec['length']);
      }
    })

    it('test_types_utf8string', 0, function () {
      for (let i = 0; i < 10; i++) {
        var bb = new ByteBuffer(2);
        // Aliases
        expect(bb.writeUTF8String === bb.writeString).assertTrue();
        expect(bb.readUTF8String === bb.readString).assertTrue();
        var str = "ä☺𠜎️☁️", str2;
        // Writing
        expect(bb.writeUTF8String(str) === bb).assertTrue();
        bb.flip();
        // bb.printDebug();
        // Reading
        str2 = bb.readUTF8String(ByteBuffer.calculateUTF8Chars(str), ByteBuffer.METRICS_CHARS);
        // bb.printDebug();
        expect(str2.length === str.length).assertTrue();
        expect(str2 === str).assertTrue();
        bb.reset();
        str2 = bb.readUTF8String(bb.limit, ByteBuffer.METRICS_BYTES);
        expect(str2 === str).assertTrue();
      }
    })

    it('test_types_writeString', 0, function () {
      for (let i = 0; i < 10; i++) {
        var bb = new ByteBuffer(2);
        // Aliases
        expect(bb.writeUTF8String === bb.writeString).assertTrue();
        expect(bb.readUTF8String === bb.readString).assertTrue();
        var str = "ä☺𠜎️☁️", str2;
        // Writing
        expect(bb.writeString(str) === bb).assertTrue();
        bb.flip();
        // bb.printDebug();
        // Reading
        str2 = bb.readString(ByteBuffer.calculateUTF8Chars(str), ByteBuffer.METRICS_CHARS);
        // bb.printDebug();
        expect(str2.length === str.length).assertTrue();
        expect(str2 === str).assertTrue();
        bb.reset();
        str2 = bb.readString(bb.limit, ByteBuffer.METRICS_BYTES);
        expect(str2 === str).assertTrue();
      }
    })

    it('test_types_istring', 0, function () {
      var bb = new ByteBuffer(2);
      expect(bb.writeIString("ab") === bb).assertTrue(); // resizes to 4+2=6
      expect(bb.capacity() === 6).assertTrue();
      expect(bb.offset === 6).assertTrue();
      expect(bb.limit === 2).assertTrue();
      bb.flip();
      expect(bb.toString("debug")).assertEqual("<00 00 00 02 61 62>");
      expect(JSON.stringify(bb.readIString(0))).assertEqual(JSON.stringify({
        "string": "ab", "length": 6
      }));
      expect(bb.readIString() === "ab").assertTrue();
      bb.reset();
      expect(bb.toString("debug")).assertEqual("<00 00 00 02 61 62>");
      expect(bb.readIString() === "ab").assertTrue();
      expect(bb.toString("debug")).assertEqual("00 00 00 02 61 62|");
    })
    it('test_types_vstring', 0, function () {
      for (let index = 0; index < 5; index++) {
        var bb = new ByteBuffer(2);
        bb.writeVString("ab"); // resizes to 2*2=4
        expect(bb.capacity() === 4).assertTrue();
        expect(bb.offset === 3).assertTrue();
        expect(bb.limit === 2).assertTrue();
        bb.flip();
        expect(bb.toString("debug").substr(0, 10)).assertEqual("<02 61 62>");
        expect(JSON.stringify(bb.readVString(0))).assertEqual(JSON.stringify({
          "string": "ab", "length": 3
        }));
        expect(bb.toString("debug").substr(0, 10)).assertEqual("<02 61 62>");
        expect(bb.readVString()).assertEqual("ab");
        expect(bb.toString("debug").substr(0, 9)).assertEqual("02 61 62|");
      }
    })

    it('test_types_cstring', 0, function () {
      for (let i = 0; i < 5; i++) {
        var bb = new ByteBuffer(2);
        bb.writeCString("a");
        expect(bb.capacity()).assertEqual(2);
        expect(bb.offset).assertEqual(2);
        expect(bb.limit).assertEqual(2);
        bb.offset = 1;
        bb.writeCString("b"); // resizes to 4
        expect(bb.capacity()).assertEqual(4);
        expect(bb.offset).assertEqual(3);
        expect(bb.limit).assertEqual(2);
        bb.flip();
        expect(bb.toString("debug").substr(0, 10)).assertEqual("<61 62 00>");
        expect(JSON.stringify(bb.readCString(0))).assertEqual(JSON.stringify({
          "string": "ab", "length": 3
        }));
        expect(bb.toString("debug").substr(0, 10)).assertEqual("<61 62 00>");
        expect(bb.readCString()).assertEqual("ab");
        expect(bb.toString("debug").substr(0, 9)).assertEqual("61 62 00|");
      }
    })

    it('test_convert_toHex', 0, function () {
      for (let i = 0; i < 10; i++) {
        var bb = new ByteBuffer(4);
        bb.writeUint16(0x1234);
        bb.writeUint8(0x56);
        bb.flip();
        // expect(bb.readUint16()).assertEqual(0x1234)
        // expect(bb.readUint8()).assertEqual(0x56)
        // expect(bb.readUInt8()).assertEqual(0x12)
        expect(bb.toHex()).assertEqual("123456");
        expect(bb.offset === 0).assertTrue();
        expect(bb.toHex(1)).assertEqual("3456");
        expect(bb.toHex(1, 2)).assertEqual("34");
        expect(bb.toHex(1, 1)).assertEqual("");
      }
    })

    it('test_convert_toHex2', 0, function () {
      for (let i = 0; i < 10; i++) {
        var bb = new ByteBuffer(4);
        bb.writeUInt16(0x1234);
        bb.writeUInt8(0x56);
        bb.flip();
        expect(bb.toHex()).assertEqual("123456");
        expect(bb.offset === 0).assertTrue();
        expect(bb.toHex(1)).assertEqual("3456");
        expect(bb.toHex(1, 2)).assertEqual("34");
        expect(bb.toHex(1, 1)).assertEqual("");
      }
    })

    it('test_convert_toBase64', 0, function () {
      var bb = new ByteBuffer(8);
      bb.writeUTF8String("abcdefg"); // 7 chars
      bb.flip();
      expect(bb.toBase64()).assertEqual("YWJjZGVmZw==");
      expect(bb.offset === 0).assertTrue();
      expect(bb.toBase64(3)).assertEqual("ZGVmZw==");
      expect(bb.toBase64(3, 6)).assertEqual("ZGVm");
      expect(bb.toBase64(3, 3)).assertEqual("");
    })
    it('test_convert_toBinary', 0, function () {
      for (let i = 0; i < 5; i++) {
        var bb = new ByteBuffer(5);
        bb.writeUint32(0x001234FF);
        bb.flip();
        expect(bb.toBinary() === "\x00\x12\x34\xFF").assertTrue();
        expect(ByteBuffer.fromBinary("\x00\x12\x34\xFF").toBinary() === "\x00\x12\x34\xFF").assertTrue();
        expect(bb.offset === 0).assertTrue();
      }
    })

    it('test_methods_btoa', 0, function () {
      expect(ByteBuffer.btoa('0x001234FF')).assertEqual('MHgwMDEyMzRGRg==');
      expect(ByteBuffer.btoa('0x00123456')).assertEqual('MHgwMDEyMzQ1Ng==');
      expect(ByteBuffer.btoa('0x123456FF')).assertEqual('MHgxMjM0NTZGRg==');
      expect(ByteBuffer.btoa('0x12345678')).assertEqual('MHgxMjM0NTY3OA==');
      expect(ByteBuffer.btoa('0x1234FFFF')).assertEqual('MHgxMjM0RkZGRg==');
    })

    it('test_methods_atob', 0, function () {
      expect(ByteBuffer.atob('MHgwMDEyMzRGRg==')).assertEqual('0x001234FF');
      expect(ByteBuffer.atob('MHgwMDEyMzQ1Ng==')).assertEqual('0x00123456');
      expect(ByteBuffer.atob('MHgxMjM0NTZGRg==')).assertEqual('0x123456FF');
      expect(ByteBuffer.atob('MHgxMjM0NTY3OA==')).assertEqual('0x12345678');
      expect(ByteBuffer.atob('MHgxMjM0RkZGRg==')).assertEqual('0x1234FFFF');
    })

    it('test_convert_toString', 0, function () {
      var bb = new ByteBuffer(3);
      bb.writeUint16(0x6162).flip();
      expect(bb.toString("hex")).assertEqual("6162");
      expect(bb.toString("base64")).assertEqual("YWI=");
      expect(bb.toString("utf8")).assertEqual("ab");
      expect(bb.toString("debug").substr(0, 7)).assertEqual("<61 62>");
      expect(bb.toString())
        .assertEqual((type === ArrayBuffer ? (accessor === DataView ? "ByteBufferAB_DataView" : "ByteBufferAB") : "ByteBufferNB") + "(offset=0,markedOffset=-1,limit=2,capacity=3)");
      expect(bb.offset === 0).assertTrue();
    })

    it('test_convert_toBuffer', 0, function () {
      for (let i = 0; i < 5; i++) {

        var bb = new ByteBuffer(2);
        bb.writeUint16(0x1234).flip();
        var buf = bb.toBuffer();
        expect(buf === bb.buffer).assertTrue();
        if (type == ArrayBuffer) {
          expect(buf instanceof ArrayBuffer).assertTrue();
          expect(buf.byteLength === 2).assertTrue();
        } else {
          expect(buf.length === 2).assertTrue();
        }
        bb.limit = 1;
        buf = bb.toBuffer();

        if (type === ArrayBuffer) {
          expect(buf instanceof ArrayBuffer).assertTrue();
          expect(buf.byteLength === 1).assertTrue();
        } else {
          expect(buf.length === 1).assertTrue();
        }
      }
    })

    it('test_convert_toArrayBuffer', 0, function () {
      for (let i = 0; i < 5; i++) {
        var bb = new ByteBuffer(3);
        expect(bb.toArrayBuffer === bb.toBuffer).assertTrue();
      }
    })

    it('test_misc_pbjsi19', 0, function () {
      var bb = new ByteBuffer(9); // Trigger resize to 18 in writeVarint64
      bb.writeVarint32(16);
      bb.writeVarint32(2);
      bb.writeVarint32(24);
      bb.writeVarint32(0);
      bb.writeVarint32(32);
      bb.writeVarint64(ByteBuffer.Long.fromString("1368057600000"));
      bb.writeVarint32(40);
      bb.writeVarint64(ByteBuffer.Long.fromString("1235455123"));
      bb.flip();
      expect(bb.toString("debug").substr(0, 52)).assertEqual("<10 02 18 00 20 80 B0 D9 B4 E8 27 28 93 99 8E CD 04>");
    })

    it('test_misc_readVarint32', 0, function () {
      var bb = new ByteBuffer(9);
      bb.writeVarint32(16);
      bb.writeVarint32(2);
      bb.writeVarint32(24);
      bb.writeVarint32(0);
      bb.writeVarint32(32);
      bb.writeVarint64(ByteBuffer.Long.fromString("1368057600000"));
      bb.writeVarint64(ByteBuffer.Long.fromString("1235455123"));
      bb.writeVarint64(ByteBuffer.Long.fromString("1234567810"));
      bb.writeVarint64(ByteBuffer.Long.fromString("1234566666"));
      bb.writeVarint64(ByteBuffer.Long.fromString("1234555555"));
      bb.flip();
      expect(JSON.stringify(bb.readVarint32(0))).assertEqual(JSON.stringify({
        "value": 16, "length": 1
      }))
      expect(JSON.stringify(bb.readVarint32(1))).assertEqual(JSON.stringify({
        "value": 2, "length": 1
      }))
      expect(JSON.stringify(bb.readVarint32(2))).assertEqual(JSON.stringify({
        "value": 24, "length": 1
      }))
      expect(JSON.stringify(bb.readVarint32(3))).assertEqual(JSON.stringify({
        "value": 0, "length": 1
      }))
      expect(JSON.stringify(bb.readVarint32(4))).assertEqual(JSON.stringify({
        "value": 32, "length": 1
      }))

      expect(JSON.stringify(bb.readVarint64(5))).assertEqual(JSON.stringify({
        "value": {
          "low": -2036967424, "high": 318, "unsigned": false
        }, "length": 6
      }))
      expect(JSON.stringify(bb.readVarint64(6))).assertEqual(JSON.stringify({
        "value": {
          "low": 2098015408, "high": 2, "unsigned": false
        }, "length": 5
      }))
      expect(JSON.stringify(bb.readVarint64(7))).assertEqual(JSON.stringify({
        "value": {
          "low": 83499609, "high": 0, "unsigned": false
        }, "length": 4
      }))
      expect(JSON.stringify(bb.readVarint64(8))).assertEqual(JSON.stringify({
        "value": {
          "low": 652340, "high": 0, "unsigned": false
        }, "length": 3
      }))
      expect(JSON.stringify(bb.readVarint64(9))).assertEqual(JSON.stringify({
        "value": {
          "low": 5096, "high": 0, "unsigned": false
        }, "length": 2
      }))
    })

    it('test_misc_NaN', 0, function () {
      var bb = new ByteBuffer(4);
      expect(!!isNaN(bb.writeFloat(NaN).flip().readFloat(0))).assertTrue();
      expect(bb.writeFloat(+Infinity).flip().readFloat(0) === +Infinity).assertTrue();
      expect(bb.writeFloat(-Infinity).flip().readFloat(0) === -Infinity).assertTrue();
      bb.resize(8);
      expect(!!isNaN(bb.writeDouble(NaN).flip().readDouble(0))).assertTrue();
      expect(bb.writeDouble(+Infinity).flip().readDouble(0) === +Infinity).assertTrue();
      expect(bb.writeDouble(-Infinity).flip().readDouble(0) === -Infinity).assertTrue();

      // Varints, however, always need a cast, which results in the following:
      expect(NaN >>> 0 === 0).assertTrue();
      expect((NaN | 0) === 0).assertTrue();
      expect((Infinity >>> 0) === 0).assertTrue();
      expect((Infinity | 0) === 0).assertTrue();
      expect((-Infinity >>> 0) === 0).assertTrue();
      expect((-Infinity | 0) === 0).assertTrue();
    })

    it('test_debug_printDebug', 0, function () {
      for (let i = 0; i < 5; i++) {
        var bb = new ByteBuffer(3);

        function callMe() {
          callMe['called'] = true;
        }

        bb.printDebug(callMe);
        expect(!!callMe['called']).assertTrue();

        if (type === ArrayBuffer) {
          var bb = ByteBuffer.wrap("Hello world! from byteBuffer.js. This is just a last visual test of ByteBuffer#printDebug.");
          bb.printDebug(console.log);
        }
      }
    })

    var bench = {};

    bench["allocate"] = function (ByteBuffer, n) {
      n = n || 10;
      for (var i = 0; i < n; ++i)
        new ByteBuffer();
      return n;
    };

    bench["writeInt32"] = function (ByteBuffer, n) {
      n = n || 10;
      var bb = new ByteBuffer(4);
      for (var i = 0; i < n; ++i)
        bb.writeInt32(0x7fffffff, 0);
      return n;
    };

    bench["readInt32"] = function (ByteBuffer, n) {
      n = n || 10;
      var bb = new ByteBuffer(4).writeInt32(0x7fffffff).flip();
      for (var i = 0; i < n; ++i)
        bb.readInt32(0);
      return n;
    };

    bench["writeVarint32"] = function (ByteBuffer, n) {
      n = n || 10;
      var bb = new ByteBuffer(6);
      for (var i = 0; i < n; ++i)
        bb.writeVarint32(0x7fffffff, 0);
      return n;
    };

    bench["readVarint32"] = function (ByteBuffer, n) {
      n = n || 10;
      var bb = new ByteBuffer(6).writeInt32(0x7fffffff).flip();
      for (var i = 0; i < n; ++i)
        bb.readVarint32(0);
      return n;
    };

    bench["writeString"] = function (ByteBuffer, n) {
      n = n || 10;
      var bb = new ByteBuffer(26);
      for (var i = 0; i < n; ++i)
        bb.writeString("abcdefghijklmnopqrstuvwxyz", 0);
      return n;
    };

    bench["readString"] = function (ByteBuffer, n) {
      n = n || 10;
      var bb = new ByteBuffer(26).writeString("abcdefghijklmnopqrstuvwxyz").flip();
      for (var i = 0; i < n; ++i)
        bb.readString(26, ByteBuffer.METRICS_BYTES, 0);
      return n;
    };

    bench["calculateString"] = function (ByteBuffer, n) {
      n = n || 10;
      for (var i = 0; i < n; ++i)
        ByteBuffer.calculateString("abcdefghijklmnopqrstuvwxyz");
      return n;
    };

    it('test_bench', 0, function () {
      Object.keys(bench).forEach(function (key) {
        var func = bench[key];
        func(ByteBuffer);
      });
    })

    it('TestWriteInt64', 0, function () {
      var byteBufferInt64 = new ByteBuffer()
        .writeInt64(188888888, 1).flip();
      expect(byteBufferInt64.readInt64(1)).assertContain("188888888");
    })

    it('TestWriteUint64', 0, function () {
      var byteBufferUint64 = new ByteBuffer()
        .writeUint64(366, 2)
        .flip();
      expect(byteBufferUint64.readUint64(2)).assertContain(366);
    })

    it('TestWriteDouble', 0, function () {
      for (let index = 0; index < 10; index++) {
        var byteBufferDouble = new ByteBuffer()
          .writeDouble(1.344, 6)
          .flip();
        expect(byteBufferDouble.readDouble(6) + "").assertContain(1.344 + "");
      }
    })

    it('TestWriteIString', 0, function () {
      for (let index = 0; index < 10; index++) {
        var byteBufferString = new ByteBuffer()
          .writeIString("hello world")
          .flip();
        expect(byteBufferString.readIString()).assertContain("hello world");
      }
    })
  })
}