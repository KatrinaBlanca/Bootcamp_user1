({

    submit : function (component, event, helper) {
        var list;
        if(component.get("v.isNew")) {
            list = ["cmp_emailField", "cmp_firstName", "cmp_lastName", "cmp_MobileNum"];
        } else {
            list = ["cmp_emailField", "cmp_firstName", "cmp_lastName", "cmp_MobileNum"];
        }
        var hasError = this.hasErrorOnFieldList(component, list);
        var isChecked = this.hasAgreed(component, event, helper);
        if(!hasError && isChecked) {
            this.createUser(component, event, helper);
        }
    },

    createUser : function(component, event, helper) {        
      //  var amount = component.get("v.isNew") ? component.find("cmp_amountBill").get("v.value") : component.find("cmp_amountKwH").get("v.value");
      //  var num = component.find("cmp_servIdNum").get("v.value");
      //  var sin = num.toString();
      //  var transactionDate = component.get("v.isNew") ? component.find("cmp_transactionDatePayment").get("v.value") : component.find("cmp_transactionDateBill").get("v.value");
        var self = this;
        self.toggleSpinner(component, event, helper);
        var action = component.get("c.createUser");
        action.setParams({
            "email": component.find("cmp_emailField").get("v.value"),
            "firstname": component.find("cmp_firstName").get("v.value"),
            "middlename": component.find("cmp_middleName").get("v.value"),
            "lastname": component.find("cmp_lastName").get("v.value"),
            "suffix": component.find("cmp_Suffix").get("v.value"),
            "mobile": component.find("cmp_MobileNum").get("v.value"),
          
          
        });
        action.setCallback(this, function(response) {
            self.toggleSpinner(component, event, helper);
            var state = response.getState();
            if(state == "SUCCESS"){
                var res = response.getReturnValue();
                if(res.isSuccess === true) {
                    component.set("v.isSuccess", res.isSuccess);
                    component.set("v.caseNumber", res.caseNumber);
                } else {
                    self.fireError(res.message);
                }
            } else {
                self.fireError(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    createToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": title,
                              "message": message,
                              "type": type,
                              "duration": 6000
                             });
        toastEvent.fire();
    },

    fireError : function(message) {
        //START CSM-14100 JRances / UAT, Remove 'Please validate your application' statement on the prompts returned (Registration page)
        //this.createToast("Please validate your application.", message, "error");
        this.createToast("", message, "error");
        //END CSM-14100 JRances
    },

    fireNotice : function(message) {
        this.createToast("Notice.", message, "info");
    },

    fireSuccess : function(message) {
        this.createToast("Success!", message, "success");
    },
    
    isFieldUndefined : function(cmpTarget) {
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){            
            // cmpTarget.set("v.errors", [{message:"Please enter " + cmpTarget.get("v.label") + "."}]);
            cmpTarget.set("v.errors", [{message:"Please input the required field/s."}]);
            return true;        
        } else {
            cmpTarget.set("v.errors",null);
            return false;
        }
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

    hasAgreed: function(component, event, helper) {
        var cmpTarget = component.find("cmp_termsAndConditions");
        var hasAgreed = cmpTarget.get("v.value");
        if(!hasAgreed) {
            // var errorMessage = "You cannot enroll for a portal account without agreeing to the Terms and Conditions.";
            var errorMessage = "Please read and agree to the Terms and Conditions.";
            this.fireError(errorMessage);
        }
        return hasAgreed;       
    },

    hasInvalidEmailFormat : function (cmpTarget) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        // var errorMessage = "Your email format is incorrect.";
        var errorMessage = "Please enter a valid email address.";
        if(!cmpTarget.get("v.value").match(regExpEmailformat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidSIN : function (cmpTarget) {
        // var errorMessage = "Your SIN should have 12 digits.";
        var errorMessage = "Sorry, but the SIN you entered is invalid. Please check your electric bill or receipt and enter your SIN.";
        if(cmpTarget.get("v.value").length < 12){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidMobileFormat : function (cmpTarget) {
        var regexMobileFormat = /(\+63)[0-9]{10}/;
        // var errorMessage = "Your mobile number format is incorrect.";
        var errorMessage = "Please input your mobile number in the format +639XXXXXXXXX.";
        if(!cmpTarget.get("v.value").match(regexMobileFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidFormat : function (cmpTarget, auraId) {
        var isInvalid = false;        
        if(auraId === "cmp_emailField"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }

        if(auraId === "cmp_servIdNum"){
            isInvalid = this.hasInvalidSIN(cmpTarget);
        }

        if(auraId === "cmp_MobileNum"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
        return isInvalid;
    },

    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    validateSIN : function(component, event, helper) {                
        var self = this;
        var action = component.get("c.hasBeenUsedByAnotherPortalAccount");
        var num = component.find("cmp_servIdNum").get("v.value");
        var sin = num.toString();

        action.setParams({            
            "sin": sin
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var res = response.getReturnValue();
                if(res.isSuccess === true) {                        
                    if(res.message) {
                        self.fireNotice(res.message);
                    }
                } else {
                    self.fireError(res.message);
                }
            } else {
                self.fireError(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);        
    },
    
    //Code for accessing custom setting(Terms and condition link)
    
    
    termsAndConditionsLinkHelper : function(component, event, helper) {
        
        var action = component.get("c.getHiearchySettings");
        action.setCallback(this, function(response){
            
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                //START CSM-14050 GGrandea 10.23.2017
                //window.location.href = response.getReturnValue();
                component.set("v.privacyAndPolicyLink", response.getReturnValue());
                //END CSM-14050
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    
    //---- Mike Verdad 8/22/2017 - For Terms and conditions ----//
    
    changeboxChangeHelper : function(component, event, helper) {
        var checkBox = component.find("cmp_termsAndConditions").get("v.value");
        component.set("v.changeBox", checkBox);
    },
    
    showTermsHelper : function(component, event, helper) {       
        component.set("v.isOpen", true);
        document.getElementById("mov-modal_lboxTerms").style.display = "block";
    }, 
    
    EventFireHelper : function (component, event, helper){
        var eventValue= event.getParam("attributeValue");
        component.set("v.changeBox", eventValue);
    }
    
    //-- end of Mike Verdad 8/22/2017 - For Terms and conditions -- //

        
})