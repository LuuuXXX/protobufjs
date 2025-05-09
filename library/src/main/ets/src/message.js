"use strict";
module.exports = Message;
import hilog from '@ohos.hilog';

var util = require("./util/minimal");

/**
 * Constructs a new message instance.
 * @classdesc Abstract runtime message.
 * @constructor
 * @param {Properties<T>} [properties] Properties to set
 * @template T extends object = object
 */
function Message(properties) {
    // not used internally
    if (properties)
        for (var keys = Object.keys(properties), i = 0; i < keys.length; ++i)
            this[keys[i]] = properties[keys[i]];
}

/**
 * Reference to the reflected type.
 * @name Message.$type
 * @type {Type}
 * @readonly
 */

/**
 * Reference to the reflected type.
 * @name Message#$type
 * @type {Type}
 * @readonly
 */

/*eslint-disable valid-jsdoc*/

/**
 * Creates a new message of this type using the specified properties.
 * @param {Object.<string,*>} [properties] Properties to set
 * @returns {Message<T>} Message instance
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.create = function create(properties) {
    hilog.info(0x0000, "protobuf.message", "-> create");
    return this.$type.create(properties);
};

/**
 * Encodes a message of this type.
 * @param {T|Object.<string,*>} message Message to encode
 * @param {Writer} [writer] Writer to use
 * @returns {Writer} Writer
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.encode = function encode(message, writer) {
    hilog.info(0x0000, "protobuf.message", "-> encode");
    return this.$type.encode(message, writer);
};

/**
 * Encodes a message of this type preceeded by its length as a varint.
 * @param {T|Object.<string,*>} message Message to encode
 * @param {Writer} [writer] Writer to use
 * @returns {Writer} Writer
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.encodeDelimited = function encodeDelimited(message, writer) {
    hilog.info(0x0000, "protobuf.message", "-> encodeDelimited");
    return this.$type.encodeDelimited(message, writer);
};

/**
 * Decodes a message of this type.
 * @name Message.decode
 * @function
 * @param {Reader|Uint8Array} reader Reader or buffer to decode
 * @returns {T} Decoded message
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.decode = function decode(reader) {
    hilog.info(0x0000, "protobuf.message", "-> decode");
    return this.$type.decode(reader);
};

/**
 * Decodes a message of this type preceeded by its length as a varint.
 * @name Message.decodeDelimited
 * @function
 * @param {Reader|Uint8Array} reader Reader or buffer to decode
 * @returns {T} Decoded message
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.decodeDelimited = function decodeDelimited(reader) {
    hilog.info(0x0000, "protobuf.message", "-> decodeDelimited");
    return this.$type.decodeDelimited(reader);
};

/**
 * Verifies a message of this type.
 * @name Message.verify
 * @function
 * @param {Object.<string,*>} message Plain object to verify
 * @returns {string|null} `null` if valid, otherwise the reason why it is not
 */
Message.verify = function verify(message) {
    hilog.info(0x0000, "protobuf.message", "-> verify");
    return this.$type.verify(message);
};

/**
 * Creates a new message of this type from a plain object. Also converts values to their respective internal types.
 * @param {Object.<string,*>} object Plain object
 * @returns {T} Message instance
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.fromObject = function fromObject(object) {
    hilog.info(0x0000, "protobuf.message", "-> fromObject");
    return this.$type.fromObject(object);
};

/**
 * Creates a plain object from a message of this type. Also converts values to other types if specified.
 * @param {T} message Message instance
 * @param {IConversionOptions} [options] Conversion options
 * @returns {Object.<string,*>} Plain object
 * @template T extends Message<T>
 * @this Constructor<T>
 */
Message.toObject = function toObject(message, options) {
    hilog.info(0x0000, "protobuf.message", "-> toObject");
    return this.$type.toObject(message, options);
};

/**
 * Converts this message to JSON.
 * @returns {Object.<string,*>} JSON object
 */
Message.prototype.toJSON = function toJSON() {
    hilog.info(0x0000, "protobuf.message", "-> toJSON");
    return this.$type.toObject(this, util.toJSONOptions);
};

/*eslint-enable valid-jsdoc*/