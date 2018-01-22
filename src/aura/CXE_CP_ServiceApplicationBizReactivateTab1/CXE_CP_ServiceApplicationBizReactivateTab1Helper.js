({
    validate : function(component, event, helper) {
        var list = ["biz_Sin", "biz_CompName", "biz_landline", "biz_FirstName", "biz_LastName", "biz_EmailAdd", "biz_Mobile", "biz_Designation"];
        var hasError = this.hasErrorOnFieldList(component, list);
        return hasError;
    },

    displayTab2 : function(component, event, helper) {
        
        var hasError = helper.validate(component, event, helper);

        // alert("hasError:" + hasError);
        var tabName;
        if(hasError) {
            tabName = "1";
        } else {
            tabName = "2";
        }
        helper.pushEvent(component, tabName);

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

    pushEvent : function (component, tabName) {
        var setEvent = component.getEvent("changeTabUsingButtonEvent");
        setEvent.setParams({
            "param1" : tabName
        });
        setEvent.fire();
    }
 
})