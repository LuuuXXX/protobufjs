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

export const userLogin = {
   sessionId: "loadProto",
   userPrivilege: "Jhon123",
   isTokenType: false,
   formatTimestamp: "xxxxxx"
}

export const protoJson = JSON.stringify({
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

export const mapInt64Value = {
  "9223372036854775807": "asdf"
}

export const mapInt32Value = {
  42: "asdf"
}

export const rawValue = {
  a: 1, b: 2, c: "YWJj"
}

export const vendorValue = {
  "name": "Iron Inc.",
  // Address from object
  "address": {
    "country": "US"
  },
  "models": ["m1"]
}

export const floatValue = [
// hex values are shown here in big-endian following IEEE754 notation
// protobuf is little-endian
// { f: -0.0 , b: "80 00 00 00" },
  {
    f: +0.0, b: "00 00 00 00"
  },
  {
    f: -1e-10, b: "AE DB E6 FF"
  },
  {
    f: +1e-10, b: "2E DB E6 FF"
  },
  {
    f: -2e+10, b: "D0 95 02 F9"
  },
  {
    f: +2e+10, b: "50 95 02 F9"
  },
  {
    f: -3e-30, b: "8E 73 63 90"
  },
  {
    f: +3e-30, b: "0E 73 63 90"
  },
  {
    f: -4e+30, b: "F2 49 F2 CA"
  },
  {
    f: +4e+30, b: "72 49 F2 CA"
  },
  {
    f: -123456789.0, b: "CC EB 79 A3"
  },
  {
    f: +123456789.0, b: "4C EB 79 A3"
  },
  {
    f: -0.987654321, b: "BF 7C D6 EA"
  },
  {
    f: +0.987654321, b: "3F 7C D6 EA"
  },
  {
    f: Number.NEGATIVE_INFINITY, b: "FF 80 00 00"
  },
  {
    f: Number.POSITIVE_INFINITY, b: "7F 80 00 00"
  }
// { f: -NaN , b: "FF C0 00 00>" },
// { f: +NaN , b: "7F C0 00 00" }
]

export const inTolerance = function (reference, actual) {
  let tol = 1e-6;
  let scale = 1.0;
  if (reference != 0.0) {
    scale = reference;
  }
  ;
  let err = Math.abs(reference - actual) / scale;
  return err < tol;
};

export function getKeys(obj: Object): string[] {
  let keys: string[] = Object.keys(obj);
  return keys;
}

export function getBitSet(): Boolean[] {
  let values: Boolean[] = [Boolean(), false, Boolean(""), Boolean(0), Boolean(42), Boolean("hello world"), Boolean(new Date(0)), Boolean({
  }), Boolean([])]
  return values;
}

export function getResult(): string[] {
  let result: Array<string> = ["TestC", "{", "required", "int32", "a", "=", "1", ";", "}", null, null];
  return result;
}
