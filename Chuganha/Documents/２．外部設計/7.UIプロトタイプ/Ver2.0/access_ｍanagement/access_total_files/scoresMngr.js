(function (window, $, undefined) {
    try {

        var secret = {
            "weightsTimeout": null,
            "weightsInterval": 4000,
            "weights": null,
            "limits": null,
            "defaultWeights": {

                "default": "1.000"
            },
            "init": function () {

                try {

                    this.loadFiles();
                }

                catch (e) {


                }



            },

            "loadFiles": function () {

                try {
                    var that = this;
                    var weightsUrl = mpvInterface.getParam("weightsURL") + "?callback=scoresMngr.setWeights", limitsURL = mpvInterface.getParam("widgetsDomain") + "/scores/limits.js";
                    Logicsmngr.pushScript(weightsUrl);
                    Logicsmngr.pushScript(limitsURL);
                    // in case the weights server doesn't respond in the waitInterval timeout init the scores with the default list.
                    this.weightsTimeout = setTimeout(function () {

                        scoresMngr.setWeights(that.defaultWeights);

                    }, this.weightsInterval);
                }

                catch (e) {


                }


            },

            "checkReady": function () {

                if (this.weights && this.limits) {

                    Logicsmngr.onModuleLoaded();


                }


            },

            "isNewDay": function (date) {

                var now = new Date();
                try {
                    date = $.type(date) === "date" ? date : new Date(date);
                    // if month or year or day aren't equal than we're 100% in new day.
                    return ((date.getFullYear() !== now.getFullYear()) || (date.getMonth() !== now.getMonth()) || (date.getDate() !== now.getDate()));
                }

                catch (e) {

                    // in case of exception always return true to enable possible impression
                    return true;
                }
            },

            "getValues": function (flashObject, defaults, callback) {

                try {
                    var obj = $.extend(true, {}, defaults), saveToSrc = false;
                    if (flashObject) {
                        // merge the flash object with the object of the cloned defaults.
                        obj = $.extend(true, obj, flashObject);
                        // if we have a flash object that doesn't support the new structure signal to save the new structure to the flash store.
                        saveToSrc = flashObject.capping && flashObject.injections ? saveToSrc : true;

                    }
                    // if last injection was in a previous day update the state and save to the flash store.
                    if (secret.isNewDay(obj.injections.lastInjectionDate)) {

                        obj.injections.lastInjectionDate = null;
                        obj.injections.numOfInjections = 0;
                        saveToSrc = true;


                    }
                    // if last view was in a previous day update the state and save to the flash store.
                    if (secret.isNewDay(obj.capping.lastTimeShown)) {

                        obj.capping.lastTimeShown = null;
                        obj.capping.numberOfTimesShown = 0;
                        saveToSrc = true;


                    }

                    return callback(obj, saveToSrc);

                }

                catch (e) {

                    return callback(defaults, false);

                }


            },

            "calculate": function (name, type, count, weight) {

                try {
                    // calc the score based on the raw weight from config if weight is undefined or baed on the calculated previous call if it is defined.
                    var limit = this.limits[type], perecentStep = this.getPercentStep(limit, count);
                    weight = weight !== undefined ? weight : $.isNumeric(this.weights[name]) ? Number(this.weights[name]) : Number(secret.defaultWeights["default"]);
                    return (100 - perecentStep) / 100 * weight;

                }

                catch (e) {



                }



            },

            "getPercentStep": function (limit, count) {

                try {
                    var percent;
                    $(limit).each(function (index) {

                        var step = this;
                        percent = (count >= step.from && count < step.to) ? step.per : percent;
                        return percent === undefined;

                    });

                    // if the value wasn't found return default 0.
                    return percent !== undefined ? percent : 0;

                }

                catch (e) {


                }



            }




        },

        scoresMngr = {


            "applyScores": function (logics, callback) {

                try {
               
                    var defaults = {
                        "capping": {

                            "lastTimeShown": null,
                            "numberOfTimesShown": 0

                        },

                        "injections": {

                            "lastInjectionDate": null,
                            "numOfInjections": 0

                        }

                    };
                    $(logics).each(function () {
                        //1.get the raw logics list from the map.
                        //2. for each logic grab the number of previous injections and views from the flash. if flash doesn't exist the default is 0 views and 0 injections.
                        //   take into consideration the last view and last injections dates: if they took place  previous date reset them both to 0 and the dates to null and save
                        //   to the flash.
                        //   if flash isn't supported then use a default of 0 to both of them.
                        //   if flash is supported but the structure is old (e.g. no injections counter or last injection date, again user the defaults.
                        // 3.finally use the formula to calc the weight from the raw weight.
                        // 4.save the new score and fire the callback.

                        var logic = this, flashObjectName = logic.flashObjectName, flashObject = Logicsmngr.getLogicFlashObject(flashObjectName);
                        secret.getValues(flashObject, defaults, function (updatedValues, saveToSrc) {
                            try {

                                var score;
                                if (flashObject && saveToSrc) {
                                    Logicsmngr.setFlashObject(flashObjectName, updatedValues);
                                }


                                score = secret.calculate(logic.name, "views", updatedValues.capping.numberOfTimesShown);
                                score = secret.calculate(logic.name, "injections", updatedValues.injections.numOfInjections, score);


                            }

                            catch (e) {

                                score = 1;
                            }

                            logic.score = score;


                        });

                    });

                    callback();

                }

                catch (e) {


                }



            },

            "setWeights": function (weights) {

                try {
                    // clear the weightTimeout to prevent from the auto time to fire the callback.
                    clearTimeout(secret.weightsTimeout);
                    secret.weights = weights;
                    secret.checkReady();

                }

                catch (e) {

                }


            },

            "setLimits": function (limits) {

                try {

                    secret.limits = limits;
                    secret.checkReady();
                }

                catch (e) {


                }


            }



        };

        window.scoresMngr = scoresMngr;
        secret.init();

    }

    catch (e) {

    }



} (window, typeof mntrjQuery !== "undefined" ? mntrjQuery : jQuery));