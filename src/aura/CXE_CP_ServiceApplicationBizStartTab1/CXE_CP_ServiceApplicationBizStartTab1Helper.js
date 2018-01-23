({
	checkOnBlurSimpleFields : function(component, event, component2) {   
      
    },

    validate : function(component, event, helper) {

        var list;
        // var isOnBehalfOf = component.get("v.isApplyingOnBehalfOf");
        // component.set("v.caseRecord.Has_Applied_for_Someone__c", isOnBehalfOf);
        var persona = component.get("v.persona");
        //START RReyes - set list for Ind
        if(persona === "Biz") {
            list = ["biz_company", "biz_landline", "biz_fname", "biz_lname", "biz_pEmail", "biz_mobile", "biz_desig"];
        }
        else if(persona === "Ind") {
            var hasRep = component.get("v.isApplyingForSomeone");
            if(hasRep){
                list = ["ind_fname", "ind_lname", "ind_pEmail", "ind_mobile", "ind_landline", "ind_bday", "ind_repfname", "ind_replname", "ind_repEmail", "ind_repmobile", "ind_relationship"];
            }else{
                list = ["ind_fname", "ind_lname", "ind_pEmail", "ind_mobile", "ind_landline", "ind_bday"];
            }
        }
        //END RReyes - set list for Ind
        console.log('list: ' + list);
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },

    displayTab2 : function(component, event, helper) {
        
        //var isSuccess = helper.validate(component, event, helper);
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
        if(auraId === "biz_pEmail" || auraId === "ind_pEmail" || auraId === "ind_repEmail"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "biz_mobile" || auraId === "ind_mobile" || auraId === "ind_repmobile"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }

        if(auraId === "biz_landline" || auraId === "ind_landline"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }

        if(auraId === "ind_bday"){
            isInvalid = this.hasInvalidBirthday(cmpTarget);
        }
        return isInvalid;
    },

    hasInvalidBirthday : function (cmpTarget) {
        var errorMessage = "You cannot select a future date as your Birthday.";
        var isUndefined = ($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")));

        if(!isUndefined){
            var today = new Date();
            var bday = new Date(cmpTarget.get("v.value"));
            
            if(bday > today){
                cmpTarget.set("v.errors", [{message:errorMessage}]);
                return true;
            }else{
                return false;
            } 
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
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
        /*var setEvent = component.getEvent("changeTabUsingButtonEvent");
        setEvent.setParams({
            "param1" : tabName
        });
        setEvent.fire();*/

        if(tabName=="2"){    
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":2});
            setEvent.fire();
        }
    }
        
})