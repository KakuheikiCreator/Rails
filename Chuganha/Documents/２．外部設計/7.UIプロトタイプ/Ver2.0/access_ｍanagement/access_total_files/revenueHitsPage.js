
(function (window) {
    var $ = typeof mntrjQuery !== "undefined" ? mntrjQuery : jQuery;
    var isActive = false;

    window.revenueHitsPage = {
        "config": null,
        "ready": false,
        "init": function (cnfg) {
            var that = this;
            this.config = cnfg;
            this.ready = true;

        },

        "start": function () {

            isActive = true;
        },

        "stop": function () {

            isActive = false;
        },

        "isAllowedByFilter": function (url) {

            return true;
        }

    };
    window.revenueHitsPage.init(Logicsmngr.getConfig("revenueHitsPage"));


})(window);
