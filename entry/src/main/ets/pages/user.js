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

/*eslint-disable block-scoped-var, id-length, no-control-regex, no-magic-numbers, no-prototype-builtins, no-redeclare, no-shadow, no-var, sort-vars*/
import * as $protobuf from "protobufjs";

// Common aliases
const $Reader = $protobuf.Reader, $Writer = $protobuf.Writer, $util = $protobuf.util;

// Exported root namespace
const $root = $protobuf.roots["default"] || ($protobuf.roots["default"] = {});

export const user = $root.user = (() => {

    /**
     * Namespace user.
     * @exports user
     * @namespace
     */
    const user = {};

    user.UserLoginResponse = (function() {

        /**
         * Properties of a UserLoginResponse.
         * @memberof user
         * @interface IUserLoginResponse
         * @property {string|null} [sessionId] UserLoginResponse sessionId
         * @property {string|null} [userPrivilege] UserLoginResponse userPrivilege
         * @property {boolean|null} [isTokenType] UserLoginResponse isTokenType
         * @property {string|null} [formatTimestamp] UserLoginResponse formatTimestamp
         */

        /**
         * Constructs a new UserLoginResponse.
         * @memberof user
         * @classdesc Represents a UserLoginResponse.
         * @implements IUserLoginResponse
         * @constructor
         * @param {user.IUserLoginResponse=} [properties] Properties to set
         */
        function UserLoginResponse(properties) {
            if (properties)
                for (let keys = Object.keys(properties), i = 0; i < keys.length; ++i)
                    if (properties[keys[i]] != null)
                        this[keys[i]] = properties[keys[i]];
        }

        /**
         * UserLoginResponse sessionId.
         * @member {string} sessionId
         * @memberof user.UserLoginResponse
         * @instance
         */
        UserLoginResponse.prototype.sessionId = "";

        /**
         * UserLoginResponse userPrivilege.
         * @member {string} userPrivilege
         * @memberof user.UserLoginResponse
         * @instance
         */
        UserLoginResponse.prototype.userPrivilege = "";

        /**
         * UserLoginResponse isTokenType.
         * @member {boolean} isTokenType
         * @memberof user.UserLoginResponse
         * @instance
         */
        UserLoginResponse.prototype.isTokenType = false;

        /**
         * UserLoginResponse formatTimestamp.
         * @member {string} formatTimestamp
         * @memberof user.UserLoginResponse
         * @instance
         */
        UserLoginResponse.prototype.formatTimestamp = "";

        /**
         * Creates a new UserLoginResponse instance using the specified properties.
         * @function create
         * @memberof user.UserLoginResponse
         * @static
         * @param {user.IUserLoginResponse=} [properties] Properties to set
         * @returns {user.UserLoginResponse} UserLoginResponse instance
         */
        UserLoginResponse.create = function create(properties) {
            return new UserLoginResponse(properties);
        };

        /**
         * Encodes the specified UserLoginResponse message. Does not implicitly {@link user.UserLoginResponse.verify|verify} messages.
         * @function encode
         * @memberof user.UserLoginResponse
         * @static
         * @param {user.IUserLoginResponse} message UserLoginResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        UserLoginResponse.encode = function encode(message, writer) {
            if (!writer)
                writer = $Writer.create();
            if (message.sessionId != null && Object.hasOwnProperty.call(message, "sessionId"))
                writer.uint32(/* id 1, wireType 2 =*/10).string(message.sessionId);
            if (message.userPrivilege != null && Object.hasOwnProperty.call(message, "userPrivilege"))
                writer.uint32(/* id 2, wireType 2 =*/18).string(message.userPrivilege);
            if (message.isTokenType != null && Object.hasOwnProperty.call(message, "isTokenType"))
                writer.uint32(/* id 3, wireType 0 =*/24).bool(message.isTokenType);
            if (message.formatTimestamp != null && Object.hasOwnProperty.call(message, "formatTimestamp"))
                writer.uint32(/* id 4, wireType 2 =*/34).string(message.formatTimestamp);
            return writer;
        };

        /**
         * Encodes the specified UserLoginResponse message, length delimited. Does not implicitly {@link user.UserLoginResponse.verify|verify} messages.
         * @function encodeDelimited
         * @memberof user.UserLoginResponse
         * @static
         * @param {user.IUserLoginResponse} message UserLoginResponse message or plain object to encode
         * @param {$protobuf.Writer} [writer] Writer to encode to
         * @returns {$protobuf.Writer} Writer
         */
        UserLoginResponse.encodeDelimited = function encodeDelimited(message, writer) {
            return this.encode(message, writer).ldelim();
        };

        /**
         * Decodes a UserLoginResponse message from the specified reader or buffer.
         * @function decode
         * @memberof user.UserLoginResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @param {number} [length] Message length if known beforehand
         * @returns {user.UserLoginResponse} UserLoginResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        UserLoginResponse.decode = function decode(reader, length) {
            if (!(reader instanceof $Reader))
                reader = $Reader.create(reader);
            let end = length === undefined ? reader.len : reader.pos + length, message = new $root.user.UserLoginResponse();
            while (reader.pos < end) {
                let tag = reader.uint32();
                switch (tag >>> 3) {
                case 1: {
                        message.sessionId = reader.string();
                        break;
                    }
                case 2: {
                        message.userPrivilege = reader.string();
                        break;
                    }
                case 3: {
                        message.isTokenType = reader.bool();
                        break;
                    }
                case 4: {
                        message.formatTimestamp = reader.string();
                        break;
                    }
                default:
                    reader.skipType(tag & 7);
                    break;
                }
            }
            return message;
        };

        /**
         * Decodes a UserLoginResponse message from the specified reader or buffer, length delimited.
         * @function decodeDelimited
         * @memberof user.UserLoginResponse
         * @static
         * @param {$protobuf.Reader|Uint8Array} reader Reader or buffer to decode from
         * @returns {user.UserLoginResponse} UserLoginResponse
         * @throws {Error} If the payload is not a reader or valid buffer
         * @throws {$protobuf.util.ProtocolError} If required fields are missing
         */
        UserLoginResponse.decodeDelimited = function decodeDelimited(reader) {
            if (!(reader instanceof $Reader))
                reader = new $Reader(reader);
            return this.decode(reader, reader.uint32());
        };

        /**
         * Verifies a UserLoginResponse message.
         * @function verify
         * @memberof user.UserLoginResponse
         * @static
         * @param {Object.<string,*>} message Plain object to verify
         * @returns {string|null} `null` if valid, otherwise the reason why it is not
         */
        UserLoginResponse.verify = function verify(message) {
            if (typeof message !== "object" || message === null)
                return "object expected";
            if (message.sessionId != null && message.hasOwnProperty("sessionId"))
                if (!$util.isString(message.sessionId))
                    return "sessionId: string expected";
            if (message.userPrivilege != null && message.hasOwnProperty("userPrivilege"))
                if (!$util.isString(message.userPrivilege))
                    return "userPrivilege: string expected";
            if (message.isTokenType != null && message.hasOwnProperty("isTokenType"))
                if (typeof message.isTokenType !== "boolean")
                    return "isTokenType: boolean expected";
            if (message.formatTimestamp != null && message.hasOwnProperty("formatTimestamp"))
                if (!$util.isString(message.formatTimestamp))
                    return "formatTimestamp: string expected";
            return null;
        };

        /**
         * Creates a UserLoginResponse message from a plain object. Also converts values to their respective internal types.
         * @function fromObject
         * @memberof user.UserLoginResponse
         * @static
         * @param {Object.<string,*>} object Plain object
         * @returns {user.UserLoginResponse} UserLoginResponse
         */
        UserLoginResponse.fromObject = function fromObject(object) {
            if (object instanceof $root.user.UserLoginResponse)
                return object;
            let message = new $root.user.UserLoginResponse();
            if (object.sessionId != null)
                message.sessionId = String(object.sessionId);
            if (object.userPrivilege != null)
                message.userPrivilege = String(object.userPrivilege);
            if (object.isTokenType != null)
                message.isTokenType = Boolean(object.isTokenType);
            if (object.formatTimestamp != null)
                message.formatTimestamp = String(object.formatTimestamp);
            return message;
        };

        /**
         * Creates a plain object from a UserLoginResponse message. Also converts values to other types if specified.
         * @function toObject
         * @memberof user.UserLoginResponse
         * @static
         * @param {user.UserLoginResponse} message UserLoginResponse
         * @param {$protobuf.IConversionOptions} [options] Conversion options
         * @returns {Object.<string,*>} Plain object
         */
        UserLoginResponse.toObject = function toObject(message, options) {
            if (!options)
                options = {};
            let object = {};
            if (options.defaults) {
                object.sessionId = "";
                object.userPrivilege = "";
                object.isTokenType = false;
                object.formatTimestamp = "";
            }
            if (message.sessionId != null && message.hasOwnProperty("sessionId"))
                object.sessionId = message.sessionId;
            if (message.userPrivilege != null && message.hasOwnProperty("userPrivilege"))
                object.userPrivilege = message.userPrivilege;
            if (message.isTokenType != null && message.hasOwnProperty("isTokenType"))
                object.isTokenType = message.isTokenType;
            if (message.formatTimestamp != null && message.hasOwnProperty("formatTimestamp"))
                object.formatTimestamp = message.formatTimestamp;
            return object;
        };

        /**
         * Converts this UserLoginResponse to JSON.
         * @function toJSON
         * @memberof user.UserLoginResponse
         * @instance
         * @returns {Object.<string,*>} JSON object
         */
        UserLoginResponse.prototype.toJSON = function toJSON() {
            return this.constructor.toObject(this, $protobuf.util.toJSONOptions);
        };

        /**
         * Gets the default type url for UserLoginResponse
         * @function getTypeUrl
         * @memberof user.UserLoginResponse
         * @static
         * @param {string} [typeUrlPrefix] your custom typeUrlPrefix(default "type.googleapis.com")
         * @returns {string} The default type url
         */
        UserLoginResponse.getTypeUrl = function getTypeUrl(typeUrlPrefix) {
            if (typeUrlPrefix === undefined) {
                typeUrlPrefix = "type.googleapis.com";
            }
            return typeUrlPrefix + "/user.UserLoginResponse";
        };

        return UserLoginResponse;
    })();

    return user;
})();

export { $root as default };
