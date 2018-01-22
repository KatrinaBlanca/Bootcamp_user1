({
    initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            var _case = a.getReturnValue();

            // _case.Account_No__c = '200000000005';
            // _case.Authorized_Representative_First_Name__c = 'a';
            // _case.Authorized_Representative_Last_Name__c = 'b';
            // _case.Authorized_Representative_Email__c = 'a@b.com';
            // _case.Authorized_Rep_Primary_Contact_Number__c = '+639999999999';

            component.set("v.caseRecord", _case);
            
        });
        $A.enqueueAction(initAction);
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

    displayTab : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;

        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber ==  1 && clickedTab != activeTabNumber){
            hasError = helper.hasErrorOnTab1(component, event, helper);
        }

        if(!hasError) {
            var className = "terminate-tab-";
            helper.display(component, event, helper, className);
            component.set("v.activeTabNumber", clickedTab);
        }        
    },

    hasErrorOnTab1 : function(component, event, helper) {
        var hasError = helper.validate(component, event, helper);
        return hasError;
    },

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

    toggleTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
    },

    displayTabFromButton : function(component, event, helper) {
        var className = "terminate-tab-";
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

    validate : function(component, event, helper) {
        var list;
        list = ["terminationSIN", "terminationRepFirstname", "terminationRepLastname", "terminationRepEmailAddress", "terminationRepMobileNumber"];
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },

    displayTab2 : function(component, event, helper) {        
        var hasError = helper.validate(component, event, helper);
        var tabName = 2;
        if(!hasError) {
            component.set("v.activeTabNumber", tabName);
            component.set("v.tabToShow", tabName);
            helper.displayTabFromButton(component, event, helper);
        } 
    },

    displayTab3 : function(component, event, helper) {  
        var tabName = 3;      
        component.set("v.activeTabNumber", tabName);
        component.set("v.tabToShow", tabName);
        helper.displayTabFromButton(component, event, helper);
    },

    hasErrorOnFieldList: function(component, helper, list) {
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
        if(auraId === "terminationRepEmailAddress"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "terminationRepMobileNumber"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }

        // if(auraId === "businessLandline"){
        //     isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        // }
        return isInvalid;
    },

    submitTerminate : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        var caseRec = component.get("v.caseRecord");
        component.set("v.caseRecord.Application_Type_Subtype__c", "Termination of Electric Service");
        var action = component.get("c.submitServiceApplication");

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Termination_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();            
            
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseId", response.caseRecordId);

                    component.find("fileUploadCmp1").uploadFile(response.caseRecordId);

                    // helper.displayTab3(component, event, helper);
                    
                } else {
                    helper.toggleSpinner(component, event, helper);
                    component.find("terminateSubmitBtn").set("v.disabled", false);
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
                component.find("terminateSubmitBtn").set("v.disabled", false);
                var errors = a.getError();
                // console.log(errors);
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
//             setTimeout(function(){ 
// console.log(' >>>>>>>>>> setTimeoutB');
//                     helper.attachFile(component, event, helper);
//             }, 500);
    },
    
    toggleSpinner : function(component, event, helper) {
        $A.util.toggleClass(component.find("appSpinner"), 'slds-hide');
        $A.util.toggleClass(component.find("progress_bar"), 'slds-hide');
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

    // attachFile : function(component, event, helper, caseId) {
    //     var childCmp = component.find("fileUploadCmp");
    //     childCmp.uploadFile();
    // },

    toggleCollapse : function(component, event, secId) {
        var acc = component.find(secId);
        $A.util.toggleClass(acc, "show");
        $A.util.toggleClass(acc, "hide");
    },

    showFileUpload : function(component, event, helper, auraId) {
        var fileUploadCount = component.get("v.numberOfFileUpload");
        helper.toggleCollapse(component, event, auraId);            
        component.set("v.numberOfFileUpload", fileUploadCount + 1);             
    }
})