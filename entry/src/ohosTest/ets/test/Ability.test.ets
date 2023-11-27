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
import { describe, it, expect } from '@ohos/hypium'
import { RnRouteNotFound } from './tracker_apm_rn'

export default function abilityTest() {
    describe('protobufTest', () => {
        it('create', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                firstPageUrl: string = ""
                prevRoutePath: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://example.com",
                firstPageUrl: "ws://example.com",
                prevRoutePath: "https://test.com",
                targetRouteName: "https://target.com"
            }

            let startTime=new Date().getMilliseconds()
            let msg = RnRouteNotFound.create(rnRoute)
            console.info("protobuf create consuming time"+(new Date().getMilliseconds()-startTime))
            expect(JSON.stringify(msg)).assertEqual(JSON.stringify(rnRoute))
        })

        it('encode', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                firstPageUrl: string = ""
                prevRoutePath: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://example.com",
                firstPageUrl: "ws://example.com",
                prevRoutePath: "https://test.com",
                targetRouteName: "https://target.com"
            }

            let msg = RnRouteNotFound.create(rnRoute)
            let startTime=new Date().getMilliseconds()
            let arrayBuffer: Uint8Array = RnRouteNotFound.encode(msg).finish()
            console.info("protobuf encode consuming time"+(new Date().getMilliseconds()-startTime))
            let expectValue = "10,18,104,116,116,112,58,47,47,101,120,97,109,112,108,101,46,99,111,109,18,16,119,115,58,47,47,101,120,97,109,112,108,101,46,99,111,109,26,16,104,116,116,112,115,58,47,47,116,101,115,116,46,99,111,109,34,18,104,116,116,112,115,58,47,47,116,97,114,103,101,116,46,99,111,109"
            expect(arrayBuffer.toString()).assertEqual(expectValue)
        })

        it('encodeDelimited', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                firstPageUrl: string = ""
                prevRoutePath: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://example.com",
                firstPageUrl: "ws://example.com",
                prevRoutePath: "https://test.com",
                targetRouteName: "https://target.com"
            }

            let msg = RnRouteNotFound.create(rnRoute)
            let startTime=new Date().getMilliseconds()
            let arrayBuffer: Uint8Array = RnRouteNotFound.encodeDelimited(msg).finish()
            console.info("protobuf encodeDelimited consuming time"+(new Date().getMilliseconds()-startTime))
            let expectValue = "76,10,18,104,116,116,112,58,47,47,101,120,97,109,112,108,101,46,99,111,109,18,16,119,115,58,47,47,101,120,97,109,112,108,101,46,99,111,109,26,16,104,116,116,112,115,58,47,47,116,101,115,116,46,99,111,109,34,18,104,116,116,112,115,58,47,47,116,97,114,103,101,116,46,99,111,109"
            expect(arrayBuffer.toString()).assertEqual(expectValue)
        })

        it('decode', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://www.baidu.com",
                targetRouteName: "https://welcom.com"
            }

            let msg = RnRouteNotFound.create(rnRoute)
            let arrayBuffer: Uint8Array = RnRouteNotFound.encode(msg).finish()

            let startTime=new Date().getMilliseconds()
            let decodeMsg = RnRouteNotFound.decode(arrayBuffer);
            console.info("protobuf decode consuming time"+(new Date().getMilliseconds()-startTime))
            expect(JSON.stringify(decodeMsg)).assertEqual(JSON.stringify(rnRoute))
        })


        it('decodeDelimited', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://www.baidu.com",
                targetRouteName: "https://welcom.com"
            }

            let msg = RnRouteNotFound.create(rnRoute)
            let arrayBuffer: Uint8Array = RnRouteNotFound.encodeDelimited(msg).finish()

            let startTime=new Date().getMilliseconds()
            let decodeMsg = RnRouteNotFound.decodeDelimited(arrayBuffer);
            console.info("protobuf decodeDelimited consuming time"+(new Date().getMilliseconds()-startTime))
            expect(JSON.stringify(decodeMsg)).assertEqual(JSON.stringify(rnRoute))
        })

        it('verify', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://www.baidu.com",
                targetRouteName: "https://welcom.com"
            }
            let startTime=new Date().getMilliseconds()
            let result = RnRouteNotFound.verify(rnRoute)
            console.info("protobuf verify consuming time"+(new Date().getMilliseconds()-startTime))
            expect(result).assertNull()
        })

        it('verifyFalse', 0, () => {
            class RnRoute {
                prevPageUrl: number = 0
            }

            let rnRoute: RnRoute = {
                prevPageUrl: 8,
            }
            let result = RnRouteNotFound.verify(rnRoute)
            expect(result != null).assertTrue()
        })

        it('toObject', 0, () => {
            class RnRoute {
                prevPageUrl: string = ""
                firstPageUrl: string = ""
                prevRoutePath: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                prevPageUrl: "http://example.com",
                firstPageUrl: "ws://example.com",
                prevRoutePath: "https://test.com",
                targetRouteName: "https://target.com"
            }

            let msg = RnRouteNotFound.create(rnRoute)
            let startTime=new Date().getMilliseconds()
            let obj = RnRouteNotFound.toObject(msg)
            console.info("protobuf toObject consuming time"+(new Date().getMilliseconds()-startTime))
            expect(JSON.stringify(obj)).assertEqual(JSON.stringify(rnRoute))
        })

        it('fromObject', 0, () => {
            class RnRoute {
                firstPageUrl: string = ""
                prevRoutePath: string = ""
                targetRouteName: string = ""
            }

            let rnRoute: RnRoute = {
                firstPageUrl: "ws://example.com",
                prevRoutePath: "https://test.com",
                targetRouteName: "https://target.com"
            }

            let startTime=new Date().getMilliseconds()
            let msg = RnRouteNotFound.fromObject(rnRoute)
            console.info("protobuf fromObject consuming time"+(new Date().getMilliseconds()-startTime))
            expect(JSON.stringify(msg)).assertEqual(JSON.stringify(rnRoute))
        })
    })
}