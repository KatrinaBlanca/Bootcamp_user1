({

    submit : function (component, event, helper) {
        var list;
        if(component.get("v.isNew")) {
            list = ["cmp_emailField", "cmp_firstName", "cmp_lastName", "cmp_MobileNum", "cmp_servIdNum", "cmp_amountBill", "cmp_transactionDatePayment"];
        } else {
            list = ["cmp_emailField", "cmp_firstName", "cmp_lastName", "cmp_MobileNum", "cmp_servIdNum", "cmp_amountKwH", "cmp_transactionDateBill"];
        }

        var hasError = this.hasErrorOnFieldList(component, list);

        var isChecked = this.hasAgreed(component, event, helper);
        if(this.isLessThanTwoMonths(component, event, helper) && !component.get("v.isNew") ) { //CSM-14051 GGrandea 10.23.2017
            if(!component.get("v.isNew")) {
              //Start CSM-13469 Rabayon -update error message 10/05/17
              this.fireError("You've entered an invalid bill date. Please check your bill from the past 2 months and enter the correct bill date.");
              //End CSM-13469 Rabayon
            } 
            // else {
            //     this.fireError("Sorry, but you\'ve entered an invalid payment date. Please check your receipt and enter the correct payment date.");
            // }            
        } else {
            if(!hasError && isChecked) {
                this.createUser(component, event, helper);
            }
        }
    },

    createUser : function(component, event, helper) {        
        var amount = component.get("v.isNew") ? component.find("cmp_amountBill").get("v.value") : component.find("cmp_amountKwH").get("v.value");
        var num = component.find("cmp_servIdNum").get("v.value");
        var sin = num.toString();
        //alert("Bill-" + component.find("cmp_transactionDateBill").get("v.value"));
        // alert("Payment-" + component.find("cmp_transactionDatePayment").get("v.value"));
        // alert(component.get("v.transactionDate"));
        // var transactionDate = component.get("v.isNew") ? component.find("cmp_transactionDatePayment").get("v.value") : component.find("cmp_transactionDateBill").get("v.value");
        var transactionDate = component.get("v.transactionDate");
        console.log("transactionDate:" + transactionDate);
        var self = this;
        self.toggleSpinner(component, event, helper);
        var action = component.get("c.createUser");
        action.setParams({
            "email": component.find("cmp_emailField").get("v.value"),
            "firstname": component.find("cmp_firstName").get("v.value"),
            "middlename": component.find("cmp_middleName").get("v.value"),
            "lastname": component.find("cmp_lastName").get("v.value"),
            "suffix": '', //START/END CSM-15012 RReyes JAN-02-18
            "mobile": component.find("cmp_MobileNum").get("v.value"),
            "sin": sin,
            "amount": amount,
            "transactionDate": transactionDate,
            "isNew" : component.get("v.isNew")
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
        //START CSM-1400 JRances / UAT, Remove 'Please validate your application' statement on the prompts returned (Registration page)
        //this.createToast("Please validate your application.", message, "error");
        this.createToast("", message, "error");
        //END CSM-1400 JRances 
    },

    fireNotice : function(message) {
        //START CSM-14104 JRances / UAT, Remove the statement 'Notice' from the prompt
        //this.createToast("Notice.", message, "info");
        this.createToast("", message, "info");
        //END CSM-14104 JRances
    },

    fireSuccess : function(message) {
        this.createToast("Success!", message, "success");
    },
    
    isFieldUndefined : function(cmpTarget) {
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){            
            // cmpTarget.set("v.errors", [{message:"Please enter " + cmpTarget.get("v.label") + "."}]);
            // START Rabayon 11/27/2017 CSM-13469
            cmpTarget.set("v.errors", [{message:"Please input all required fields."}]);
            //END Rabayon 11/27/2017 CSM-13469
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
            //Start CSM-13469 Rabayon -update error message 10/05/17
            var errorMessage = "Please read and agree to the Meralco Online Terms & Conditions and Privacy Policy.";
            //End  CSM-13469 Rabayon
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
        //Start CSM-13469 Rabayon -update error message 10/05/17
        var errorMessage = "You've entered an invalid Service ID Number. Please check your bill or receipt and enter the correct Service ID Number.";
        //End CSM-13469 Rabayon 
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
        //START CSM-13668 JRances - Update error message based from R2A Requirements per Lisen
        //Start CSM-13469 Rabayon -update error message 10/05/17
            var errorMessage = "Please input your mobile number in the format +63xxx xxxxxxx."; // CSM-14655 Red 11-23-2017
        //End CSM-13469 Rabayon 
        //var errorMessage = "Please input your mobile number in the format +639XXXXXXXX.";
        //END CS-13668 JRances
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

        if(auraId === "cmp_transactionDatePayment" || auraId === "cmp_transactionDateBill") {            
            isInvalid = this.hasInvalidDate(cmpTarget, auraId);
        }

        if(auraId === "cmp_amountKwH" || auraId === "cmp_amountBill"){            
            isInvalid = this.hasInvalidAmt(cmpTarget);
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

    isLessThanTwoMonths : function(component, event, helper) {
        var dateInput = component.get("v.transactionDate");
        if($A.util.isEmpty(dateInput) || $A.util.isUndefined(dateInput)){ 
            return false;
        } else {
            var targetDate = new Date(dateInput);
            var dateToday = new Date();
            dateToday.setMonth(dateToday.getMonth() - 2);        
            var twoMonthsAgo = new Date(dateToday.getFullYear(), dateToday.getMonth(), 1);
            return (targetDate < twoMonthsAgo);
        }
    },
   
    //---- Mike Verdad - Getting policy link from custom settings ----//
    privacyPolicyHelper : function(component, event, helper) {
     	
        //START - CSM-13001 JRances - Removing alert, open window, display Privacy Policy on a New Tab
        var action = component.get("c.getHiearchySettings");
            action.setCallback(this, function(response) {
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){  
                //alert(response.getReturnValue())
                // window.open(
                //   response.getReturnValue(),
                //   '_blank' // <- This is what makes it open in a new window.
                // ); 
                component.set("v.privacyAndPolicyLink", response.getReturnValue());
            }            
        });
        $A.enqueueAction(action);   
        //END - CSM-13001 JRances
    },
    
    //---- Mike Verdad 8/22/2017 - For Terms and conditions ----// 
    
    //START CSM-13026 JRances - Change implementation to show Terms and Conditions Modal
    /*
    changeboxChangeHelper : function(component, event, helper) {
        var checkBox = component.find("cmp_termsAndConditions").get("v.value");
        component.set("v.changeBox", checkBox);
        //alert('CXE_CP_SplashPageLoginForm: checkbox value is '+ checkBox);
    },

    showTermsHelper : function(component, event, helper) {       
        component.set("v.isOpen", true);
        document.getElementById("mov-modal_lboxTerms").style.display = "block";
    }, 
    */
    //END CSM-13026 JRances
    
    EventFireHelper : function (component, event, helper){
        var eventValue= event.getParam("attributeValue");
        component.set("v.changeBox", eventValue);
    },

    hasInvalidDate : function (cmpTarget, auraId) {
        //Start Rabayon 11/27/2017 CSM-13469
        var errorMessage = "You\'ve entered an invalid bill date. Please check your bill from the past 2 months and enter the correct bill date.";
        if(auraId === "cmp_transactionDatePayment" ) {
            errorMessage = "You\'ve entered an invalid payment date. Please check your receipt and enter the correct payment date.";
        }
        //End Rabayon 11/27/2017 CSM-13469
        var valid = true;
        var today = new Date();
        var d = new Date(cmpTarget.get("v.value"));   
        if (Object.prototype.toString.call(d) === "[object Date]") {
            valid = (!isNaN(d) && d <= today);
        } else {
            valid = false;
        }

        
        if(!valid){
            // cmpTarget.set("v.errors", [{message:errorMessage}]);
            this.fireError(errorMessage);
        } 
        // else {
        //      cmpTarget.set("v.errors", null);
        // }

        return !valid;
    },

    hasInvalidAmt  : function(cmpTarget) {
        var inp = cmpTarget.get("v.value");
        // var decimal=  /^[-+]?[0-9]+\.[0-9]+$/; 
        var isValid = !isNaN(inp);
        if((!$A.util.isEmpty(cmpTarget.get("v.value")) || !$A.util.isUndefined(cmpTarget.get("v.value"))) && !isValid) {
            this.fireError("Please input only numbers.");
        }
        return !isValid;
    }
    // d instanceof Date && isFinite(d)
    
    //-- end of Mike Verdad 8/22/2017 - For Terms and conditions -- //
})