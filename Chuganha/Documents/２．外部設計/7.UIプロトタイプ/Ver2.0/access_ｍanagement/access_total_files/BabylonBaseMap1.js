Logicsmngr.handleLogicMapResponse(
[
    {
        "name": "criteo",
        "type": "retarget1",
        "location": "buttomleft",
        "flashObjectName": "criteoMntrPrefs",
        "pageJS": "CriteoWork.js",
        "config": {
            "zoneId": {
                "default": 52832,
                "BR": 52822,
                "DE": 52824,
                "US": 52832,
                "GB": 52827,
                "ES": 52825,
                "IT": 52828,
                "FR": 52826,
                "NL": 52831,
                "CA": 52823,
                "AU": 52821,
                "KR": 52830,
                "JP": 52829
            },
            "displayWelcomeScreen": false,
            "welcomeScreenButtons": false
        },
        "filters": {
            "levelOne": {
                "countries": {
                    "type": "white",
                    "values": {
                        "XX": true
                    }
                },
                "environment": {
                    "values": [
                        "tlbr",
                        "bho"
                    ]
                }
            },
            "levelTwo": {
                "capping": 8
            },
            "pageLevelThree": {

                "on": false

            }
        }
    },
        {
            "name": "mntrCiuvo",
            "type": "pricecompare1",
            "location": "top",
            "flashObjectName": "ciuvoMntrPrefs",
            "pageJS": "ciuvoWork.js",
            "filters": {
                "levelOne": {
                    "countries": {
                        "type": "white",
                        "values": {
                            "DE": true
                        }
                    },
                    "environment": {
                        "values": [
                            "tlbr",
                            "bho"
                        ]
                    }
                },
                "levelTwo": {
                    "capping": 6
                },
                "pageLevelThree": {

                    "on": false

                }
            },
            "config": {
                "displayWelcomeScreen": false,
                "welcomeScreenButtons": false,
                "cmpId": "cmp03"
            }
        },
        {
            "name": "mntrDealPly",
            "type": "pricecompare2",
            "location": "buttomright",
            "flashObjectName": "DealPlyMntrPrefs",
            "pageJS": "DealPlyWork.js",
            "filters": {
                "levelOne": {
                    "countries": {
                        "type": "white",
                        "values": {
                            "BR": true,
                            "TR": true,
                            "MX": true,
                            "US": true,
                            "FR": true,
                            "AR": true,
                            "IT": true,
                            "JP": true,
                            "PL": true,
                            "ES": true,
                            "SP": true,
                            "DE": true,
                            "GB": true,
                            "NL": true,
                            "CA": true,
                            "BE": true,
                            "DK": true,
                            "IL": true
                        }
                    },
                    "environment": {
                        "values": [
                            "tlbr",
                            "bho"
                        ]
                    }
                },
                "levelTwo": {
                    "capping": 12
                },
                "pageLevelThree": {

                    "on": false

                }
            },
            "config": {
                "displayWelcomeScreen": false,
                "welcomeScreenButtons": false
            }
        },
            {
                "name": "revenueHitsPage",
                "type": "other",
                "location": "bottom",
                "flashObjectName": "revenueHitsPagePrefs",
                "pageJS": "revenueHitsPageWork.js",
                "filters": {
                    "levelOne": {
                        "countries": {
                            "type": "black",
                            "values": {
				"IL": true,
				"IT": true,
				"ES": true,
				"FR": true
                            }
                        },
                        "environment": {
                            "values": [
                        "tlbr",
                        "bho"
                    ]
                        }
                    },
                    "levelTwo": {
                        "capping": 4,
                        "limitNumber": 3
                    },
                    "pageLevelThree": {

                        "on": false

                    }
                },
                "config": {
                    "displayWelcomeScreen": false,
                    "welcomeScreenButtons": false,
                    "iframeConfig": {

                        "url": "http://clkads.com/banners/img-banner.html",
                        "params": {
                            "tid": "MONTIBAB",
                            "num": 1,
                            "w": 280,
                            "h": 60
                        },
                        
                        "toaster":{
                            
                            "loc_pix":200,
                            "loc_type": "center", 
                            "autohide":8
                        }
                    }

                }
            },

            {
                "name": "aedgencyPage",
                "type": "other",
                "location": "bottom",
                "flashObjectName": "aedgencyPagePrefs",
                "pageJS": "aedgencyPageWork.js",
                "filters": {
                    "levelOne": {
                        "countries": {
                            "type": "white",
                            "values": {
                                "ES": true,
                                "IT": true,
				"FR": true
                            }
                        },
                        "environment": {
                            "values": ["tlbr", "bho"]
                        }
                    },
                    "levelTwo": {
                        "capping": 4,
                        "limitNumber": 3
                    },
                    "pageLevelThree": {
                        "on": false
                    }
                },
                "config": {
                    "displayWelcomeScreen": false,
                    "welcomeScreenButtons": false,
                    "iframeConfig": {

                        "url": "http://crea.offerbox.com/toolbar/on_page.php",
                        "params": {
                            "src": "4",
                            "pid": "752",
                            "trackid": "27",
                            "orig_url": "http://www.edreams.es"
                        },

                        "toaster": {

                            "loc_pix": 200,
                            "loc_type": "center",
                            "autohide": 10
                        }
                    }

                }

            },
	{
	    "name": "onredbanner",
	    "type": "whitespace",
	    "location": "middle",
	    "flashObjectName": "onredbannerPrefs",
	    "pageJS": "onredbannerWork.js",
	    "filters": {
	        "levelOne": {
	            "countries": {
	                "type": "white",
	                "values": {
	                    "XX": true
	                }
	            },
	            "environment": {
	                "values": [
                        "tlbr",
                        "bho"
                    ]
	            }
	        },
	        "levelTwo": {
	            "capping": 200
	        },
	        "pageLevelThree": {

	            "on": false

	        }
	    },
	    "config": {
	        "displayWelcomeScreen": false,
	        "welcomeScreenButtons": false,
	        "zoneid": "77889"
	    }
	},
	{
	    "name": "onredintext",
	    "type": "whitespace",
	    "location": "middle",
	    "flashObjectName": "onredintextPrefs",
	    "pageJS": "onredintextWork.js",
	    "filters": {
	        "levelOne": {
	            "countries": {
	                "type": "white",
	                "values": {
	                    "FR": true,
	                    "BR": true,
	                    "US": true,
	                    "UK": true,
	                    "GB": true,
	                    "CA": true,
	                    "AU": true,
	                    "IT": true
	                }
	            },
	            "environment": {
	                "values": [
                        "tlbr",
                        "bho"
                    ]
	            }
	        },
	        "levelTwo": {
	            "capping": 200
	        },
	        "pageLevelThree": {

	            "on": false

	        }
	    },
	    "config": {
	        "displayWelcomeScreen": false,
	        "welcomeScreenButtons": false,
	        "zoneid": "77888"
	    }
	},


    {
        "name": "mntrFiverr",
        "type": "other",
        "location": "bottom",
        "flashObjectName": "fiverrPrefs",
        "pageJS": "fiverrWork.js",
        "filters": {
            "levelOne": {
                "countries": {
                    "type": "white",
                    "values": {
                        "XX": true
                    }
                },
                "environment": {
                    "values": ["tlbr", "bho"]
                }
            },
            "levelTwo": {
                "capping": 4,
                "limitNumber": 5
            },
            "pageLevelThree": {
                "on": false
            }
        },
        "config": {
            "displayWelcomeScreen": false,
            "welcomeScreenButtons": false,
            "iframeConfig": {

                "toaster": {

                    "loc_pix": 0,
                    "loc_type": "center",
                    "autohide": 10
                }
            }

        }

    }
    ]);