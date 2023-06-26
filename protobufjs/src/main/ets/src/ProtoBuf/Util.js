/**
 * @alias ProtoBuf.Util
 * @expose
 */
ProtoBuf.Util = (function () {
    "use strict";

    /**
     * ProtoBuf utilities.
     * @exports ProtoBuf.Util
     * @namespace
     */
    var Util = {};

    /**
     * Flag if running in node or not.
     * @type {boolean}
     * @const
    * @expose
     */
    Util.IS_NODE = !!(
        typeof process === 'object' && process + '' === '[object process]' && !process['browser']
    );

    /**
     * Constructs a XMLHttpRequest object.
     * @return {XMLHttpRequest}
     * @throws {Error} If XMLHttpRequest is not supported
     * @expose
     */
    Util.XHR = function () {
        // No dependencies please, ref: http://www.quirksmode.org/js/xmlhttp.html
        var XMLHttpFactories = [
            function () {
                return new XMLHttpRequest()
            },
            function () {
                return new ActiveXObject("Msxml2.XMLHTTP")
            },
            function () {
                return new ActiveXObject("Msxml3.XMLHTTP")
            },
            function () {
                return new ActiveXObject("Microsoft.XMLHTTP")
            }
        ];
        /** @type {?XMLHttpRequest} */
        var xhr = null;
        for (var i = 0;i < XMLHttpFactories.length; i++) {
            try {
                xhr = XMLHttpFactories[i]();
            }
            catch (e) {
                continue;
            }
            break;
        }
        if (!xhr)
            throw Error("XMLHttpRequest is not supported");
        return xhr;
    };

    /**
     * Fetches a resource.
     * @param {string} path Resource path
     * @param {function(?string)=} callback Callback receiving the resource's contents. If omitted the resource will
     *   be fetched synchronously. If the request failed, contents will be null.
     * @return {?string|undefined} Resource contents if callback is omitted (null if the request failed), else undefined.
     * @expose
     */
    Util.fetch = async function (path, callback) {
        if (callback && typeof callback != 'function') {
            callback = null;
        }
        if (!ProtoBuf.resourceManager) {
            return;
        }

        if (callback) {
            try {
                ProtoBuf.resourceManager.getRawFileContent(path).then(value => {
                    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
                    let retStr = textDecoder.decodeWithStream(value, { stream: false });
                    callback(retStr);
                }).catch(error => {
                    console.error("getRawFileContent promise error is " + error);
                    callback(null)
                });
            } catch (error) {
                console.error(`promise getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`)
                callback(null)
            }
        } else {
            try {
                var fileUint8Array = await ProtoBuf.resourceManager.getRawFileContent(path);
                let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: false });
                let retStr = textDecoder.decodeWithStream(fileUint8Array, { stream: false });
                return retStr;
            } catch (err) {
                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                return null;
            }
        }
    };

    /**
     * Converts a string to camel case.
     * @param {string} str
     * @returns {string}
     * @expose
     */
    Util.toCamelCase = function (str) {
        return str.replace(/_([a-zA-Z])/g, function ($0, $1) {
            return $1.toUpperCase();
        });
    };

    return Util;
})();
