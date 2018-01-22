({
    initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecord", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },
    
    // hasErrorOnTab1 : function(component, event, helper) {
    //     var childCmp = component.find("cmpTab1");
    //     childCmp.doPageValidation();
    //     var hasError = component.get("v.hasErrorOnPage");
    //     return hasError;
    // },

    display : function(component, event, helper, className) {
        //get data-aura-id of event Source
        var auraId = event.currentTarget.dataset.auraId;
        
        //set clicked tab to active
        var setActiveTab = event.currentTarget.parentNode;
        
        var activeTabNumber = component.get("v.activeTabNumber");
        var className = className + activeTabNumber;

        //get current active tabs
        var currentActive = document.getElementsByClassName(className);
        // alert
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        component.set("v.tabToShow", auraId);
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], "slds-is-active");
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab, "slds-is-active");

        helper.toggleTab(component, activeTabNumber);
        helper.toggleTab(component, auraId);
    },

    displaySpecific : function(component, event, helper, target) {
        var className = "biz-reactivate-tab-";
        // var deactivateTab = (component.get("v.activeTabNumber") != component.get("v.tabToShow")) ? activeTab - 1 : activeTab;
        
        var activateClassName = className + target;
        
        //get current active tabs
        var currentActive = document.getElementsByClassName(className + component.get("v.activeTabNumber"));
        
        // alert
        var setActiveTab = document.getElementsByClassName(activateClassName);
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], "slds-is-active");
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab[0], "slds-is-active");
        helper.hideTab(component, component.get("v.activeTabNumber"));
        helper.showTab(component, target);
        component.set("v.activeTabNumber", target);
        component.set("v.tabToShow", target);        
    },

    displayTab : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;

        var tabDisplay = activeTabNumber;

        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                tabDisplay = clickedTab;
            }
        } else {
            tabDisplay = clickedTab;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
             
    },

    displayTabByButton : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;

        var tabDisplay = activeTabNumber;

        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                tabDisplay = +activeTabNumber + 1;
            }
        } else {
            tabDisplay = +activeTabNumber + 1;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
    },

    showTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.addClass(component.find(cmpTarget), "slds-show");
        $A.util.removeClass(component.find(cmpTarget), "slds-hide");
    },

    hideTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.removeClass(component.find(cmpTarget), "slds-show");
        $A.util.addClass(component.find(cmpTarget), "slds-hide");
    },


    toggleTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
    },

    validateTab1 : function(component, event, helper) {
        var list = ["biz_Sin", "biz_CompName", "biz_landline", "biz_FirstName", "biz_LastName", "biz_EmailAdd", "biz_Mobile", "biz_Designation"];
        var hasError = this.hasErrorOnFieldList(component, list);
        return hasError;
    },

    hasErrorOnFieldList: function(component, list) {
        var ctr = 0;
        if(list) {
            var i = 0;
            for (i = 0; i < list.length; i++) {    

                if(this.isFieldUndefined(component.find(list[i])) ) {
                    ctr++;
                    continue;
                }
                if(this.hasInvalidFormat(component.find(list[i]), list[i])) {
                    ctr++;
                }
            }
        }
        return (ctr > 0);
    },

    isFieldUndefined : function(cmpTarget) {
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){            
            cmpTarget.set("v.errors", [{message:"Please indicate your  " + cmpTarget.get("v.label") + "."}]);
            return true;        
        } else {
            cmpTarget.set("v.errors",null);
            return false;
        }
    },    

    hasInvalidEmailFormat : function (cmpTarget) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var errorMessage = "Please enter a valid email address.";
        if(!cmpTarget.get("v.value").match(regExpEmailformat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidMobileFormat : function (cmpTarget) {
        var regexMobileFormat = /(\+639)[0-9]{9}/;
        var errorMessage = "Please input your mobile number in the format +639XXXXXXXXX.";
        if(!cmpTarget.get("v.value").match(regexMobileFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidLandlineFormat : function (cmpTarget) {
        // var regexLandlineFormat = /(\+632)[0-9]{7}/;
        // var errorMessage = "Please input your landline in the format +632XXXXXXX.";
        var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/;
        var errorMessage = "Phone should start with +63 then followed by 1 to 2-digit area code and 7-digit number.";
        var isUndefined = ($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")));
        if(!isUndefined && !cmpTarget.get("v.value").match(regexLandlineFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidFormat : function (cmpTarget, auraId) {
        var isInvalid = false;
        if(auraId === "biz_EmailAdd"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "biz_Mobile"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }

        if(auraId === "biz_landline"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
        return isInvalid;
    },

    showCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
    },

    hideCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },

    submitRecontract : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        component.set("v.caseRecord.Application_Type_Subtype__c", "Recontract of Electric Service");
        var caseRec = component.get("v.caseRecord");
                
        var action = component.get("c.submitServiceApplication");

        console.log("JSON:" + JSON.stringify(caseRec));

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Recontract_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.find("fileUploadCmp1").uploadFile(response.caseRecordId);
                    // helper.displaySpecific(component, event, helper, "4");
                } else {
                    helper.toggleSpinner(component, event, helper);
                    component.find("termsACBtn").set("v.disabled", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration" : 6000
                                         });
                    toastEvent.fire();
                }
            } else {
                helper.toggleSpinner(component, event, helper);
                component.find("termsACBtn").set("v.disabled", false);
                var errors = a.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);

                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Please validate your application.",
                                              "message": errors[0].message,
                                              "type": "error",
                                              "duration" : 6000
                                             });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }                
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        $A.util.toggleClass(component.find("progress_bar"), 'slds-hide');
    }
})