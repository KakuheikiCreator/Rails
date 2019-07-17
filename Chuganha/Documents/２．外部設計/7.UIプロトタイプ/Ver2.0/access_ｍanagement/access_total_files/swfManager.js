(function (window, undefined) {
    var $ = typeof mntrjQuery !== "undefined" ? mntrjQuery : jQuery;
    var private = {

        "fcookies": null,
        "supported": null,
        "flashInjected": false,
        "loadScript": function (url, objectToSearch, underwhichObject, callback) {
            try {
                if (objectToSearch) {
                    underwhichObject = underwhichObject || window;
                    if (!underwhichObject[objectToSearch]) {

                        var scrpt = document.createElement("script");
                        scrpt.setAttribute("type", "text/javascript");
                        scrpt.setAttribute("src", url);
                        document.getElementsByTagName("head")[0].appendChild(scrpt);


                    }

                    if (typeof callback === "function") {
                        (function onScriptLoaded() {
                            try {
                                var searchObj = underwhichObject || window;
                                typeof underwhichObject[objectToSearch] !== "undefined" ? callback() : setTimeout(onScriptLoaded, 50);

                            }

                            catch (e) {

                            }

                        } ());

                    }

                }

                else {

                    var scrpt = document.createElement("script");
                    scrpt.setAttribute("type", "text/javascript");
                    scrpt.setAttribute("src", url);
                    document.getElementsByTagName("head")[0].appendChild(scrpt);

                }

            }

            catch (e) {

            }


        }


    };





    window.mpvSwfManager = {


        "init": function (domain, callback) {

            try {

                if (!private.flashInjected) {
                    private.flashInjected = true;
                    var caller = typeof mpvInterface !== "undefined" ? mpvInterface : montieraPageManager;
                    var url = domain + "/3rdparty/swfstore/swfstore.min.js?random=" + (caller.getParam("r") || caller.getParam("random"));
                    if (!this.isFlashInstalled()) {
                        private.supported = false;
                        private.fcookies = null;

                        return callback({ "supported": false, "fcookies": null });
                    }
                    private.loadScript(url, "SwfStore", window, function () {

                        private.flashInjected = true;
                        var mySwfStore = new SwfStore({

                            // Optional but recommended. Try to choose something unique.
                            namespace: 'maxPerViewSwfStore',

                            // To work cross-domain, only one of your sites should have the
                            // .swf, all other sites should load it from the first one
                            swf_url: domain + '/3rdparty/swfstore/storage.swf',

                            // Logs messages to the console if available, a div at the
                            // bottom of the page otherwise. 
                            debug: false,

                            onready: function () {
                                // Now that the swfStore was loaded successfully, re-enable
                                try {
                                    try {
                                        mySwfStore.set("validate", "test");
                                        if (mySwfStore.get("validate") != "test") {
                                            mySwfStore.clear("validate");
                                            return callback({ "supported": false, "fcookies": null });
                                        }
                                        mySwfStore.clear("validate");
                                    }
                                    catch (e) {
                                        return callback({ "supported": false, "fcookies": null });
                                    }
                                    private.fcookies = mySwfStore;
                                    private.supported = true;
                                    callback({ "supported": true, "fcookies": mySwfStore });

                                }

                                catch (e) {

                                    callback({ "supported": false, "fcookies": null });
                                    try {
                                        mpvInterface.errorReport({

                                            "err_desc": e,
                                            "err_location": "mpvSwfManager.init.onready()",
                                            "extra": "swfManager.js"

                                        });

                                    }

                                    catch (e) {

                                    }
                                }
                            },

                            onerror: function () {
                                // In case we had an error. (The most common cause is that 
                                try {// the user disabled flash cookies.)
                                    private.supported = false;
                                    callback({ "supported": false, "fcookies": null });

                                }

                                catch (e) {
                                    try {
                                        mpvInterface.errorReport({

                                            "err_desc": e,
                                            "err_location": "mpvSwfManager.init.onerror()",
                                            "extra": "swfManager.js"

                                        });

                                    }

                                    catch (e) {

                                    }
                                }

                            }
                        });



                    });


                }

                else {

                    callback({ "supported": private.supported, "fcookies": private.fcookies });

                }

            }

            catch (e) {

                callback({ "supported": false, "fcookies": null });
                try {
                    mpvInterface.errorReport({

                        "err_desc": e,
                        "err_location": "mpvSwfManager.init()",
                        "extra": "swfManager.js"

                    });

                }

                catch (e) {

                }
            }


        },

        "isFlashInstalled": function () {

            try {
             
                var flashInstalled;
                flashInstalled = mpvInterface.getParam("flashFlag");
                // if the boot flash check contains a value convert it to bolean;
                if (flashInstalled) {

                    flashInstalled = flashInstalled === "true" ? true : false;
                }
                // if the boot indicates that the flash is installed make the double check
                // because for a  flash plugin disabled situation the bootfile indicates it is installed. 
                if (flashInstalled || typeof flashInstalled === "undefined") {

                    if ($.browser.msie) {

                        try {

                            var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
                            if (fo) flashInstalled = true;

                        }

                        catch (e) {

                            if (navigator.mimeTypes["application/x-shockwave-flash"] != undefined) {
                                flashInstalled = true;

                            }

                            else {

                                flashInstalled = false;
                            }

                        }


                    }

                    else {

                        if (navigator.mimeTypes["application/x-shockwave-flash"] !== undefined) {
                            flashInstalled = true;

                        }

                        else {

                            flashInstalled = false;
                        }

                    }

                }


            }

            catch (e) {


            }
            return flashInstalled;



        }




    };


} (window));