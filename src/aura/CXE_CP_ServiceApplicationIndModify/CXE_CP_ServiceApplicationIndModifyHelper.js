({
    initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecord", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },
    
    displayTab : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;

        if(component.get("v.hasSubmitted")){
            return;
        }


        if(activeTabNumber <  3 && clickedTab > 2){
            var hasError1 = helper.validateTab1(component, event, helper);
            var hasError2 = helper.validateTab2(component, event, helper);

            var tabName = (!hasError1 ? "2" : "1");
            
            if(!hasError2) {
                tabName = clickedTab;
            }
            
            helper.displaySpecific(component, event, helper, tabName);

            return;               
        }


        if(activeTabNumber ==  2 && clickedTab > activeTabNumber){
            hasError = helper.hasErrorOnTab2(component, event, helper);            
        } 

        if(activeTabNumber ==  1 && clickedTab != activeTabNumber){
            hasError = helper.hasErrorOnTab1(component, event, helper);
        } 
       
        if(!hasError) {
            var className = "biz-modify-tab-";
            helper.displaySpecific(component, event, helper, clickedTab);
            component.set("v.activeTabNumber", clickedTab);
        }        
    },

    hasErrorOnTab1 : function(component, event, helper) {
        var hasError = helper.validateTab1(component, event, helper);
        return hasError;
    },

    hasErrorOnTab2 : function(component, event, helper) {
        var hasError = helper.validateTab2(component, event, helper);
        return hasError;
    },

    display : function(component, event, helper, className) {
        //get data-aura-id of event Source
        var auraId = event.currentTarget.dataset.auraId;
        
        //set clicked tab to active
        var setActiveTab = event.currentTarget.parentNode;
        // alert(setActiveTab);
        var activeTabNumber = component.get("v.activeTabNumber");
        var className = className + activeTabNumber;

        //get current active tabs
        var currentActive = document.getElementsByClassName(className);
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        component.set("v.tabToShow", auraId);
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], "slds-is-active");
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab[0], "slds-is-active");

        helper.toggleTab(component, activeTabNumber);
        helper.toggleTab(component, auraId);
    },

    displaySpecific : function(component, event, helper, target) {
        var className = "biz-modify-tab-";
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

    displayTabFromButton : function(component, event, helper) {
        var className = "biz-modify-tab-";
        var activeTab = component.get("v.activeTabNumber");
        // var deactivateTab = (component.get("v.activeTabNumber") != component.get("v.tabToShow")) ? activeTab - 1 : activeTab;
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        //get current active tabs
        var currentActive = document.getElementsByClassName(deactiveClassName);
        // alert
        var setActiveTab = document.getElementsByClassName(activateClassName);
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], "slds-is-active");
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab[0], "slds-is-active");

        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },

    toggleTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
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

    getServiceModificationOptions : function(component, event, helper){
        var action = component.get("c.getServiceModifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.serviceModifications", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        
        $A.enqueueAction(action);
    },

    getContractModificationOptions : function(component, event, helper) {
        var action = component.get("c.getContractModifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.contractModifications", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        $A.enqueueAction(action);
    },

    getRelationshipToCustomer : function(component, event, helper) {
        var action = component.get("c.getRelationToCustomer");
        action.setParams({
            "persona": component.get("v.persona")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                component.set("v.relationToCustomerPicklist", response); 
            } else {
                console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": a.getReturnValue(),
                                      "type": "error",
                                      "duration": 6000
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    validateTab1 : function(component, event, helper) {
        var list;
        // var isOnBehalfOf = component.get("v.isApplyingOnBehalfOf");
        // component.set("v.caseRecord.Has_Applied_for_Someone__c", isOnBehalfOf);
        var isServiceMod = component.get("v.isServiceMod");
        var persona = component.get("v.persona");

        if(!isServiceMod) {
            if(persona === "Biz") {
                list = ["businessSIN", "businessName", "businessLandline", "bizfirstname", "bizlastname", "emailAddress", "mobileNumber", "businessDesignation1"];
            } else {
                list = ["businessSIN", "firstname", "lastname", "emailAddress", "mobileNumber"];
            }
        } else {
            list = ["businessSIN"];
        }
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },

    validateTab2 : function(component, event, helper) {
        var list;
        list = ["repFirstName", "repLastName", "repEmail", "repMobile"];
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },

    

    hasErrorOnFieldList: function(component, helper, list) {
        var ctr = 0;

        if(helper.hasNoServiceRequest(component, helper)) {
            ctr++;
        }

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
        if(auraId === "emailAddress" || auraId === "repEmail"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "mobileNumber" || auraId === "repMobile"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }

        if(auraId === "businessLandline"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
        return isInvalid;
    },

    hasNoServiceRequest : function (component, helper) {
        // alert("hasNoServiceRequest");
        var serviceReq = component.get("v.caseRecord.CXE_Service_Request_s__c");
        // alert(serviceReq);
        var isUndefined = ($A.util.isEmpty(serviceReq) || $A.util.isUndefined(serviceReq));
        // alert("isUndefined-" + isUndefined);
        if(isUndefined) {
            helper.fireError("Please select service request.");
        }
        return isUndefined;
    },

    fireError : function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": "Please check your input.",
                              "message": msg,
                              "type": "error",
                              "duration" : 6000
                             });
        toastEvent.fire();
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

    submitModify : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        component.set("v.caseRecord.Application_Type_Subtype__c", "Modification of Electric Service");
        var caseRec = component.get("v.caseRecord");
                
        var action = component.get("c.submitServiceApplication");


        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Modification_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {
                    component.set("v.caseId", response.caseRecordId);
                    component.find("fileUploadCmp1").uploadFile(response.caseRecordId);
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    console.log('v.caseRecord.CaseNumber: >>>>>>>>>>>>>>>>>>> '+ response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    //helper.displaySpecific(component, event, helper, "5");
                } else {
                    helper.toggleSpinner(component, event, helper);
                    component.find("modifySubmitBtn").set("v.disabled", false);
                    // helper.pushEvent(component, "4");
                    // helper.toggleSpinner(component, event, helper);
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
                component.find("modifySubmitBtn").set("v.disabled", false);
                // helper.pushEvent(component, "4");
                // helper.toggleSpinner(component, event, helper);
                var errors = a.getError();
                // alert("errorMsg" + errors);
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
                    // helper.toggleSpinner(component, event, helper);
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
    },

    toggleCollapse : function(component, event, secId) {
        var acc = component.find(secId);
        $A.util.toggleClass(acc, "show");
        $A.util.toggleClass(acc, "hide");
    },
    //START Breadcrumb-task Rabayon SEPT-25-17
    goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    goToRequests : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/trackapp';
        window.location.assign(pageUrl);
    }
    //END Breadcrumb-task Rabayon SEPT-25-17
})