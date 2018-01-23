({
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

    validate : function(component, event, helper) {
        var list;
        // var isOnBehalfOf = component.get("v.isApplyingOnBehalfOf");
        // component.set("v.caseRecord.Has_Applied_for_Someone__c", isOnBehalfOf);
        var isServiceMod = component.get("v.isServiceMod");
        var persona = component.get("v.persona");
        if(!isServiceMod) {
            if(persona === "Biz") {
                list = ["businessSIN", "businessName", "businessLandline", "bizfirstname", "bizlastname", "emailAddress", "mobileNumber", "businessDesignation"];
            } else {
                list = ["businessSIN", "firstname", "lastname", "emailAddress", "mobileNumber"];
            }
        } else {
            list = ["businessSIN"];
        }
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },

    displayTab2 : function(component, event, helper) {
        
        var hasError = helper.validate(component, event, helper);
        var tabName;
        if(hasError) {
            tabName = "1";
        } else {
            tabName = "2";
        }
        helper.pushEvent(component, tabName);

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
        var regexLandlineFormat = /(\+632)[0-9]{7}/;
        var errorMessage = "Please input your landline in the format +632XXXXXXX.";
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
        if(auraId === "emailAddress"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "mobileNumber"){
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

    pushEvent : function (component, tabName) {
        var setEvent = component.getEvent("changeTabUsingButtonEvent");
        setEvent.setParams({
            "param1" : tabName
        });
        setEvent.fire();
    }
})