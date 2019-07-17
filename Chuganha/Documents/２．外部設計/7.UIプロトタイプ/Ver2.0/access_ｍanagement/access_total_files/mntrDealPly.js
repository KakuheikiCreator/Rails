
(function (window) {
    var $ = typeof mntrjQuery !== "undefined" ? mntrjQuery : jQuery;
    
    window.mntrDealPly = {
        "config": null,
        "ready": false,
        "whiteListRegex": null,
        "init": function (cnfg) {
            try {
                var that = this;
                this.config = cnfg;
                Logicsmngr.pushScript(Logicsmngr.getMyPath("mntrDealPly") + "/js/whitelist.js");

            }

            catch (e) {

            }

        },

        "isAllowedByFilter": function (url) {
            try {

                var domain = Logicsmngr.getDomain(url);
                var babFlashCondition = mpvInterface.getParam("prdct") === "babylonmpvn" && !Logicsmngr.flashCookies;
                return (this.whiteListRegex.test(domain) && !babFlashCondition);

            }

            catch (e) {

            }

            return true;
        },

        "setWhiteListRegex": function (wlr) {

            try {

                this.whiteListRegex = wlr;
                this.ready = true;

            }

            catch (e) {


            }


        }

    };

    window.mntrDealPly.init(Logicsmngr.getConfig("mntrDealPly"));


})(window);
