({
    submit : function (component, event, helper) {
        var list;
        if(component.get("v.isNew")) {
            list = ["cmp_servIdNum", "cmp_amountBill", "cmp_transactionDatePayment"];
        } else {
            list = ["cmp_servIdNum", "cmp_amountKwH", "cmp_transactionDateBill"];
        }
        var hasError = this.hasErrorOnFieldList(component, list);
        
		//Start CSM-12592 Mike Verdad 09/15/2017
		if(this.isLessThanTwoMonths(component, event, helper)) {
            if(!component.get("v.isNew")) {
                //START CSM-13850 RBellalba OCT-13-2017
                this.fireError("You've entered an invalid bill date. Please check your bill and enter the correct bill date.");
            	  //END CSM-13850 RBellalba OCT-13-2017             
            } 
            // else {
            //     this.fireError("Sorry, but you\'ve entered an invalid payment date. Please check your receipt and enter the correct payment date.");
            // }
        } else {
		
			if(!hasError) {
				this.enrollService(component, event, helper);
			}
		}
		//End CSM-12592 Mike Verdad 09/15/2017
    },
    
    //Start CSM-12592 Mike Verdad 09/15/2017
    isLessThanTwoMonths : function(component, event, helper) {
        var dateInput = component.get("v.transactionDate");
        if(!$A.util.isEmpty(dateInput) || !$A.util.isUndefined(dateInput)){ 
            return false;
        } else {
            var targetDate = new Date(dateInput);
            var dateToday = new Date();
            dateToday.setMonth(dateToday.getMonth() - 2);        
            var twoMonthsAgo = new Date(dateToday.getFullYear(), dateToday.getMonth(), 1);
            return (targetDate < twoMonthsAgo);
        }
    },
    //End CSM-12592 Mike Verdad 09/15/2017
    
    enrollService : function(component, event, helper) {        
        var amount = component.get("v.isNew") ? component.find("cmp_amountBill").get("v.value") : component.find("cmp_amountKwH").get("v.value");
        var num = component.find("cmp_servIdNum").get("v.value");
        var sin = num.toString();
        var transactionDate = component.get("v.isNew") ? component.find("cmp_transactionDatePayment").get("v.value") : component.find("cmp_transactionDateBill").get("v.value");
        var self = this;
        self.toggleSpinner(component, event, helper);
        var action = component.get("c.enrollService");
        action.setParams({
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
                    console.log('Service Enrollment Created');
                    // START CSM-13444 RBellalba OCT-06-17
                    self.fireSuccess(res.message);
                    // END CSM-13444 RBellalba OCT-06-17
                    component.set("v.isSuccess", res.isSuccess);
                    component.set("v.caseNumber", res.caseNumber);
                    if(res.caseNumber == '' || res.caseNumber == null){
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/myaccounts"
                        });
                        urlEvent.fire();
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
    
    createToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        //Start CSM-12443 GGrandea 9/8/2017
        //Start CSM-12432 Emandolado 9/5/2017
        //toastEvent.setParams({"title": '' ,
        toastEvent.setParams({"title": title ,
                              "message":message ,
                              "type": type,
                              "duration": 6000
                             });
        //End CSM-12432 Emandolado 9/5/2017
        //End CSM-12443 GGrandea 9/8/2017
        toastEvent.fire();
    },

    fireError : function(message) {
        //this.createToast("Please validate your application.", message, "error");
        //this.createToast(message, "error");
        //Start CSM-12443 GGrandea 9/8/2017
        //this.createToast('error', message, "error"); //CSM-12451 Emandolado 9/7/2017
        this.createToast('', message, "error");
        //End CSM-12443 GGrandea 9/8/2017
    },

    fireNotice : function(message) {
        this.createToast("Notice.", message, "info");
    },

    fireSuccess : function(message) {
        this.createToast("Success!", message, "success");
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
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
            // cmpTarget.set("v.errors", [{message:"Please enter " + cmpTarget.get("v.label") + "."}]);
            cmpTarget.set("v.errors", [{message:"Please input the required field/s."}]);
            return true;        
        } else {
            cmpTarget.set("v.errors",null);
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
        // var errorMessage = "Sorry, but you've entered an invalid SIN. Please check your bill and enter the correct SIN.";
        //START CSM-13850 RBellalba OCT-12-2017
        var errorMessage = "You've entered an invalid Service ID Number. Please check your bill and enter the correct Service ID Number.";
        //END CSM-13850 RBellalba OCT-12-2017
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
    
    createStickyToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        //Start CSM-12432 Emandolado 9/5/2017
        toastEvent.setParams({"title": '',
                              "message": message,
                              "type": type,
                              //START CSM-13056 JRances - Remove Mode so Toast will disappear after 6 secs. Added timeout for toast
                              //"mode" : "sticky"
                              "duration": 6000
                              //END CSM-13056 JRances
                             });
        toastEvent.fire();
        //End CSM-12432 Emandolado 9/5/2017
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
                console.log('RES isSuccess: ' + res.isSuccess);
                console.log('RES message: ' + res.message);
                if(res.isSuccess === true) {                        
                    if(res.message) {
                        self.createStickyToast("Notice.", res.message, "info");
                    }
                } else {
                    self.fireError(res.message);
                }
            } else {
                self.fireError(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);        
    }
    
    //START Breadcrumb-task IPenaflor SEPT-25-17
    , goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    
    goToMyAccounts : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    },

    hasInvalidDate : function (cmpTarget, auraId) {
        //var errorMessage = "Sorry, but you\'ve entered an invalid bill date. Please check your bill and enter the correct bill date.";
        //START CSM-13850 RBellalba OCT-13-2017
        var errorMessage = "You've entered an invalid bill date. Please check your bill and enter the correct bill date.";
        
        if(auraId === "cmp_transactionDatePayment" ) {
            //errorMessage = "Sorry, but you\'ve entered an invalid payment date. Please check your receipt and enter the correct payment date.";
            errorMessage = "You've entered an invalid payment date. Please check your receipt and enter the correct payment date.";
        //END CSM-13850 RBellalba OCT-13-2017
        }
        
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
    },
    //END Breadcrumb-task IPenaflor SEPT-25-17
    
    //START R2C CSM-13274 Shayne 10/12/2017 
    initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
       var action = component.get("c.retrieveCheckConglomerate");
        
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state' + state +' and result '+result);
            if(state === "SUCCESS"){
                component.set('v.isConglomerate', result);
                 var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/congloaccerror';
               if(result === true) window.location.assign(pageUrl);
                else component.set('v.isLoaded',true); //R2C CSM-14773 Shayne 12/05/2017
            }
        });  
        $A.enqueueAction(action);
       
    }
    //END R2C CSM-13274 Shayne 10/12/2017 
})