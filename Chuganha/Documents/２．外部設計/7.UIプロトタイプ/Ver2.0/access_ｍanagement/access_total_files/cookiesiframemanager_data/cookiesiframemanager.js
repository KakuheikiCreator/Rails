(function (window, undefined) {

    var secret = {
        "random": null,
        "prdct": null,
        "mapFile": null,
        "forbiddenLogics": []

    },

    dummyIframe = "<iframe src='about:blank' width='0' height='0' scrolling='no' frameborder='0' />",

    hasPostMessage = window.postMessage && !$.browser.opera,
    mngr = {

        "init": function () {

            try {

                var urlParams = this.deSerializeString(location.href);
                secret.random = urlParams.random;
                secret.prdct = urlParams.prdct;
                secret.mapFile = urlParams.mapFile;
                helper.loadScript("../maps/" + secret.mapFile);
            }

            catch (e) {



            }



        },

        "deSerializeString": function (qry_) {

            try {
                var keyValuePairs = qry_.split(/[&?]/g);
                var params = {};
                for (var i = 0, n = keyValuePairs.length; i < n; ++i) {
                    var m = keyValuePairs[i].match(/^([^=]+)(?:=([\s\S]*))?/);
                    if (m) {
                        var key = decodeURIComponent(m[1]);
                        params[key] = decodeURIComponent(m[2]);
                    }
                }
                return params;
            } catch (exc) {
                return {};
            }


        },

        "handleLogicMapResponse": function (logicMap) {

            try {
             
                var that = this;
                if (this.isLevel1Disabled()) {

                    this.handleResult("disableAllAds");


                }
                else {
                    $(logicMap).each(function () {

                        var logic = this;
                        if (that.getCookie(secret.prdct + "_" + logic.name)) {

                            that.handleResult(logic.name);

                        }


                    });

                }

                this.handleResult("ready");

            }

            catch (e) {


            }



        },

        "handleResult": function (result) {

            try {

                var message;
                if (hasPostMessage) {

                    switch (result) {

                        case "ready":
                            message = JSON.stringify(secret.forbiddenLogics);
                            parent.postMessage("mpvCookiesCheck_" + message, '*');
                            break;

                        default:
                            secret.forbiddenLogics.push(result);
                            break;

                    }

                }

                else {

                    switch (result) {

                        case "ready":
                            this.pushIframe("iframeReady");
                            break;

                        default:
                            this.pushIframe(result);
                            break;
                    }
                }


            }

            catch (e) {


            }


        },

        "loadScript": function (src) {

            try {

                var prefix = src.indexOf("?") > -1 ? "&" : "?";
                src += secret.random !== null ? (prefix + "random=" + secret.random) : "";
                var scrpt = document.createElement("script");
                scrpt.setAttribute("type", "text/javascript");
                scrpt.setAttribute("src", src);
                document.getElementsByTagName("head")[0].appendChild(scrpt);

            }

            catch (e) {


            }


        },

        "pushIframe": function (id) {
            try {

                $(dummyIframe).attr("id", id).appendTo(document.body);

            }

            catch (e) {


            }


        },

        "isLevel1Disabled": function () {

            try {
                var allLogicsDisabledCurrentProduct = this.getCookie(secret.prdct + "_disableAllAds") !== null;
                var allLogicsDisabledAllPrdcts = this.getCookie("allPrdcts_disableAllAds") !== null;
                return allLogicsDisabledCurrentProduct || allLogicsDisabledAllPrdcts;

            }

            catch (e) {


            }



        },

        "getCookie": function (cookieName) {

            try {

                return $.cookie(cookieName);
            }

            catch (e) {


            }


        }




    };


    // set the manager with the name Logicsmngr because of the map file thing... (hard coded).
    window.mpvCookiesFilter = window.Logicsmngr = mngr;

} (window));