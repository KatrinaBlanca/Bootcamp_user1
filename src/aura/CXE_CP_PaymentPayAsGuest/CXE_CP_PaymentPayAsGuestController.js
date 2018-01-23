({
    eventClose: function(component, event, helper) {
        var eventValue= event.getParam("attributeValue");
        if(eventValue=="proceed"){
            component.set("v.activePay", true);
        }
        component.set("v.errorTerminated", false);
        component.set("v.errorDisconnected", false);
        component.set("v.errorOverdue", false);
    },
    doInit: function(component, event, helper) {
        /*
        var query = helper.url_param();
        query.totalAmt = query.totalAmt || 'none';
        query.refNum = query.refNum || 'none';
        query.feeAmt = query.feeAmt || 'none';
        query.status = query.status || 'none';
        
        if(query.status =="success"){
            var totalAmountForMeralco;
            totalAmountForMeralco = parseInt(query.totalAmt) - parseInt(query.feeAmt);
            component.set('v.confirmationPay' ,true);
             component.set("v.billDetails" , true);
            component.set('v.paymentReferenceNumber',query.refNum);
            component.set('v.totalAmountPaid' , totalAmountForMeralco);
            component.set('v.convenienceFee' , query.feeAmt);
            component.set('v.totalAmountForSettlement' ,query.totalAmt);
        }else if(query.status == "failed"){
             component.set('v.isFailed' ,true);
             component.set("v.billDetails" , true);
        } */
        
    },
    EventFireTotalAmount : function(component, event, helper) {
        var eventValue= event.getParam("tabToNavigate");
        //alert('eventValue: '+eventValue);
        component.set("v.errorOverdue" , false);
        //alert('eventValue2: '+eventValue);
        if(eventValue == "tab2"){
            //alert('tab2');
            console.log('123');
            component.set("v.activePay" , true);
            console.log('1234');
            component.set("v.billDetails" , false);
            console.log('1235');
        }/*else if(eventValue =="tab3"){
            component.set("v.activePay" , false);
            component.set("v.billDetails" , true);
            var convenienceFee = event.getParam("convenienceFee");
            component.set("v.convenienceFee", convenienceFee);
            var totalAmountForSettlement = event.getParam("totalAmountForSettlement");
            component.set("v.totalAmountForSettlement", totalAmountForSettlement);
            var ccCardName = event.getParam("ccCardName");
            component.set("v.ccCardName" , ccCardName);
            var paymentTokenId = event.getParam("paymentTokenId");
            component.set("v.paymentTokenId", paymentTokenId);
        } else if(eventValue == "tab4"){
            var referenceNumber= event.getParam("referenceNumber");
            component.set("v.confirmationPay" , true);
            component.set("v.paymentReferenceNumber" , referenceNumber);
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
            
        } */
    },
    
    showModal : function(component, event, helper) {
        //component.set("v.modalPopUp", 'terms-and-condition');
        //component.set("v.popUpModal", 'agreeToTerms');
        //component.set("v.popUpModal", 'settleFull');
        //component.set("v.modalPopUp", 'payDisconnected');
		
        var isProceed = true;
        var checkBox = component.find("cmp_termsAndConditions").get("v.value");
        //var currentTextType = component.get('v.textEnabled');
        var currentValue;
        var currentTextType;
        
        var accountField = component.get("v.accountField");
        var serviceField = component.get("v.serviceField");
        var invoiceField = component.get("v.invoiceField");
        
        var amountHolder = component.find('amountText').get('v.value');
        var emailHolder = component.find('emailText').get('v.value');
        
        var accountHolder = component.find('accountText').get('v.value');
        var serviceHolder =   component.find('serviceText').get('v.value');
        var invoiceHolder =    component.find('invoiceText').get('v.value'); 
        
        component.set("v.emailPass" , emailHolder);
        console.log('v.emailPass >>> ' + component.get("v.emailPass"));
        var amountError = component.find('amountError');
        var contactError = component.find('contactError');
         
        if(accountField == false){
            currentValue = accountHolder;
            currentTextType = 'accountRadio';
        }else if(serviceField == false){
            currentValue = serviceHolder;
            currentTextType = 'serviceRadio';
        }else if(invoiceField == false){
            currentValue =invoiceHolder;
            currentTextType = 'invoiceRadio';
        }
        
        var errorAccount = component.find("accountError");
        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var regexMobileFormat = /(\+63)[0-9]{10}/;
        helper.resetValidation(component, event, helper); 
        
        if(checkBox){
            console.log('if checkbox >>> ' + checkBox);
            if(!accountHolder && !serviceHolder && !invoiceHolder && currentTextType == 'none'){
                component.find('accountError').set('v.value' , "Please input required fields.");
                $A.util.removeClass(errorAccount, "slds-hide");
                isProceed = false;
            }else{
                if(currentTextType == 'serviceRadio' && !serviceHolder){
                    component.find('serviceText').set('v.errors' , [{message:''}]);  
                    component.find('accountError').set('v.value' , "Please input required fields.");
                    $A.util.removeClass(errorAccount, "slds-hide");
                    isProceed = false;
                }
                if(currentTextType == 'accountRadio' && !accountHolder){
                    component.find('accountText').set('v.errors' , [{message:''}]);  
                    component.find('accountError').set('v.value' , "Please input required fields.");
                    $A.util.removeClass(errorAccount, "slds-hide");
                    isProceed = false;
                }
                if(currentTextType == 'invoiceRadio' && !invoiceHolder){
                    component.find('invoiceText').set('v.errors' , [{message:''}]); 
                    component.find('accountError').set('v.value' , "Please input required fields.");
                    $A.util.removeClass(errorAccount, "slds-hide");
                    isProceed = false;
                }
            }
            
            if(serviceHolder && serviceHolder.length != 12){
                component.find('serviceText').set('v.errors' , [{message:''}]);
                isProceed = false;
                component.find('accountError').set('v.value' , "Please input a valid reference.");
                $A.util.removeClass(errorAccount, "slds-hide");
            }
            if(!amountHolder){
                component.find('amountText').set('v.errors' ,  [{message:''}]);
                component.find('amountError').set('v.value' , "Please input required fields.");
                $A.util.removeClass(amountError, "slds-hide");
                isProceed = false;
            }
            var isEmailEmpty = false;
            if(!emailHolder){
                component.find('emailText').set('v.errors' , [{message:''}]);
                $A.util.removeClass(contactError, "slds-hide");
                component.find('contactError').set('v.value' , "Please input required fields.");
                isProceed = false;
                isEmailEmpty = true;
            }
      
            var isEmailError = false;
            if(emailHolder && !emailHolder.match(regExpEmailformat)){
                component.find('emailText').set('v.errors' , [{message:''}]);
                $A.util.removeClass(contactError, "slds-hide");
                component.find('contactError').set('v.value' , "Please input a valid email address.");
                isProceed = false;
                isEmailError = true;
            }
            
            if(component.find('mobileNum').get('v.value')){
                if(!component.find('mobileNum').get('v.value').match(regexMobileFormat)){
                    component.find('mobileNum').set('v.errors' , [{message:''}]);
                    isProceed = false;
                    if(isEmailError){
                        component.find('contactError').set('v.value' , "Please input a valid email address and mobile number.");
                    }else{
                        $A.util.removeClass(contactError, "slds-hide");
                        component.find('contactError').set('v.value' , "Please input a valid mobile number.");
                    }
                    
                    if(isEmailEmpty){
                        component.find('contactError').set('v.value' , "Please input required fields and a valid mobile number.");
                    }
                }
            }
          
            console.log('currentValue >>> ' + currentValue);
            
            if(isProceed){
                console.log('if isProceed >>> ' + isProceed);
                var cmpTarget = component.find("appSpinner");
                $A.util.toggleClass(cmpTarget, 'slds-hide');
                var action = component.get("c.validateData");
                action.setParams({"validationType":currentTextType,"valuePass":currentValue,"amountPass":amountHolder,"emailPass":emailHolder});
                action.setCallback(this,function(response){ 
                    
                    var cmpTarget = component.find("appSpinner");
                    $A.util.toggleClass(cmpTarget, 'slds-hide');
                    
                    console.log('response.getReturnValue >>> ' + JSON.stringify(response.getReturnValue()));
                    var state = response.getState();
                    console.log(response.getReturnValue().errorMessage);
                    console.log('checkTotalAmount >>> ' + response.getReturnValue().checkTotalAmount);
                    console.log('hasAnyTerminated >>> ' + response.getReturnValue().hasAnyTerminated);
                    console.log('hasAnyDisconnected >>> ' + response.getReturnValue().hasAnyDisconnected);
                    if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){   
                        //START CSM-14526 JFERNANDEZ 11-20-2017
                        if(response.getReturnValue().payment_status == 'Partial'){
                            console.log('ABC');
                            component.set("v.errorOverdue", true);
                        }else if(response.getReturnValue().payment_status == 'Exact' || response.getReturnValue().payment_status == 'Over' || response.getReturnValue().pay_advance == true){
                            console.log('ABC');
                            if(response.getReturnValue().paymentReferences == 'Service'){
                                console.log('ABC1');
                                if(response.getReturnValue().hasAnyDisconnected == true){
                                    console.log('ABC2');
                                    component.set("v.errorDisconnected", true);
                                }else if(response.getReturnValue().hasAnyTerminated == true){
                                    console.log('ABC3');
                                    component.set("v.errorTerminated", true);
                                }else{
                                    console.log('ABC4');
                                    component.set("v.activePay", true);
                                }
                            }else if(response.getReturnValue().paymentReferences == 'Account'){
                                if(response.getReturnValue().isDisconnected == true){
                                    component.set("v.errorDisconnected", true);
                                }else if(response.getReturnValue().isTerminated == true){
                                    component.set("v.errorTerminated", true);
                                }else{
                                    component.set("v.activePay", true);
                                }
                            }else if(response.getReturnValue().paymentReferences == 'Invoice'){
                                if(response.getReturnValue().hasAnyDisconnected == true){
                                    component.set("v.errorDisconnected", true);
                                }else if(response.getReturnValue().hasAnyTerminated == true){
                                    component.set("v.errorTerminated", true);
                                }else{
                                    component.set("v.activePay", true);
                                }
                            }
                        }
                        /*}else if(response.getReturnValue().errorMessage == 'reactivate pending'){
                            component.set("v.errorTerminated", true);
                        }else if(response.getReturnValue().errorMessage == 'reactivate pending 2'){
                            component.set("v.errorDisconnected", true);
                        }else if(response.getReturnValue().errorMessage == 'overdue'){
                            component.set("v.errorOverdue", true);
                        else if(response.getReturnValue().pay_advance == true){
                            if(response.getReturnValue().isDisconnected == true){
                            	component.set("v.errorDisconnected", true);
                            }else if(response.getReturnValue().isTerminated == true){
                            	component.set("v.errorTerminated", true);
                            }else if(response.getReturnValue().isOverdue == true){
                            	component.set("v.errorOverdue", true);
                            }else{
                                component.set("v.activePay", true);
                            }
                        }*/
                         //END CSM-14526 JFERNANDEZ 11-20-2017
                            else if(response.getReturnValue().errorMessage =='Invalid Account'){
                                component.find('accountText').set('v.errors' , [{message:''}]);
                                
                                component.find('accountError').set('v.value' , "Please input a valid reference.");
                                $A.util.removeClass(errorAccount, "slds-hide");
                            }else if(response.getReturnValue().errorMessage =='active'){
                                console.log(response.getReturnValue().totalPaidAmount);
                                component.set("v.activePay", true);
                                
                            }else if(response.getReturnValue().errorMessage =='Invalid Invoice No.'){
                                component.find('invoiceText').set('v.errors' , [{message:''}]);
                                
                                component.find('accountError').set('v.value' , "Please input a valid reference.");
                                $A.util.removeClass(errorAccount, "slds-hide");
                                
                            }else if(response.getReturnValue().errorMessage =='Invalid Service ID No.'){
                                component.find('serviceText').set('v.errors' , [{message:''}]);
                                
                                component.find('accountError').set('v.value' , "Please input a valid reference.");
                                $A.util.removeClass(errorAccount, "slds-hide");
                            }
                                else{
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "",
                                        "type": "Error",
                                        "message": response.getReturnValue().errorMessage
                                    });
                                    toastEvent.fire();   
                                }
                        component.set("v.billListRaw",response.getReturnValue().billList);
                        console.log('sample' + response.getReturnValue().billList[0]);
                 	    console.log('sample2' + response.getReturnValue().billList.length);
                        console.log('sample3' + response.getReturnValue().invoice_number);
                        console.log('sample4' + response.getReturnValue().invoice_id);
                        helper.groupBills(component,response.getReturnValue().billList);
                        
                        var filteredBillingSummary = component.get('v.billListRaw');
                        var billIds;
                        
                        if(filteredBillingSummary.length == 0){
                            billIds=response.getReturnValue().invoice_id;
                        }
                        component.set('v.account_number' , response.getReturnValue().account_number);
                        console.log('actnmbr >>> ' + component.get('v.account_number'));
                        component.set('v.overPaid_Amount' , response.getReturnValue().overPaid_Amount);
                        component.set('v.billId' , billIds);
                        
                        
                        
                        console.log("here" + response.getReturnValue().totalPendingAmount);
                        component.set("v.payment_status" , response.getReturnValue().payment_status);
                        component.set("v.totalPending" , response.getReturnValue().totalPendingAmount);
                        component.set("v.paymentReference" , response.getReturnValue().paymentReferences);
                        component.set("v.paymentReferenceNumber" , response.getReturnValue().paymentReferenceNumber);
                
                        component.set("v.advanceState" , response.getReturnValue().advanceState);
                        component.set("v.external_ID" , response.getReturnValue().external_Id);
						component.set('v.advancePayment' ,response.getReturnValue().pay_advance);
                        component.set('v.service_number' , response.getReturnValue().service_number);
                        console.log(component.get("v.billListRaw"));
                        component.set("v.totalAmountPaid" , response.getReturnValue().totalPaidAmount);
                        document.body.scrollTop = 0;
                        document.documentElement.scrollTop = 0;
                        
                    }else{
                        console.log("Failed With state: " + state);
                        console.log("Returned:");
                        console.log(response.getReturnValue());
                    }
                });
                $A.enqueueAction(action); 
            }else{
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
            }
        }else{
            //START CSM-15052 RReyes JAN-09-18
            console.log("show prompt!");
            component.set("v.isShowTNCPrompt", true);
            //document.getElementById("mov-proceed-modal").style.display = "block";
            //END CSM-15052 RReyes JAN-09-18         
        }
    },
    
    //Emandolado
    closeModalProceed : function(component, event, helper) {
        //START CSM-15052 RReyes JAN-09-18
        component.set("v.isShowTNCPrompt", false);
        //document.getElementById("mov-proceed-modal").style.display = "none";
        //END CSM-15052 RReyes JAN-09-18
    },
    showTerms : function(component, event, helper) {
        component.set("v.isOpen", true);
        document.getElementById("mov-modal_lboxTerms").style.display = "block";
    }, 
    EventFire : function (component, event){    
        var eventValue= event.getParam("attributeValue");
        component.set("v.changeBox", eventValue);
    },
    creditReturn: function (component, event){    
        component.set("v.activePay", false);
        component.set("v.billDetails", true);
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
    },
    privacyPolicy: function (component, event, helper) {
        helper.privacyPolicyHelper(component, event, helper);  
    },
    //Emandolado
    /*
    enableField : function(component, event, helper) {
        
        var selectedValue = event.getSource().get('v.name');
        var selectedState = event.getSource().get('v.value');
        console.log('selectedValue >>> ' + selectedValue);
        var radioButtons = component.find("radioSelect");
        for (var i = 0; i < radioButtons.length; i++){
            radioButtons[i].set("v.value",false);
        }
        if(selectedState){
            component.set("v.textEnabled" , 'none');
            selectedValue ="none";
        }else{
            component.set("v.textEnabled" , selectedValue);
        }
        if(selectedValue == "accountRadio"){
            component.find('accountText').set('v.disabled' , false);
            component.find('serviceText').set('v.disabled' , true);
            component.find('invoiceText').set('v.disabled' , true);
        }else if(selectedValue == "serviceRadio"){
            component.find('accountText').set('v.disabled' , true);
            component.find('serviceText').set('v.disabled' , false);
            component.find('invoiceText').set('v.disabled' , true);
        }else if(selectedValue =="invoiceRadio"){
            component.find('accountText').set('v.disabled' , true);
            component.find('serviceText').set('v.disabled' , true);
            component.find('invoiceText').set('v.disabled' , false);
        }else{
            component.find('accountText').set('v.disabled' , true);
            component.find('serviceText').set('v.disabled' , true);
            component.find('invoiceText').set('v.disabled' , true);
        }
        component.find('accountText').set('v.value' , '');
        component.find('serviceText').set('v.value' , '');
        component.find('invoiceText').set('v.value' , '');
    }
    */
    enableFieldAccount : function(component, event, helper) {
        var selectedValue = event.getSource().get('v.name');
        var selectedState = event.getSource().get('v.value');
        
        if(selectedState){
            component.set("v.textEnabled" , 'none');
            selectedValue ="none";
        }else{
            component.set("v.textEnabled" , selectedValue);
        }
        
        component.find("serviceText").set("v.value", null);
        component.find("invoiceText").set("v.value", null);

        
        component.set("v.accountField", false);
        component.set("v.serviceField", true);
        component.set("v.invoiceField", true);
        component.set("v.serviceRadio", false);
        component.set("v.invoiceRadio", false);
    },
    
    enableFieldService : function(component, event, helper) {
        var selectedValue = event.getSource().get('v.name');
        var selectedState = event.getSource().get('v.value');
        
        if(selectedState){
            component.set("v.textEnabled" , 'none');
            selectedValue ="none";
        }else{
            component.set("v.textEnabled" , selectedValue);
        }
        
        component.find("accountText").set("v.value", null);
        component.find("invoiceText").set("v.value", null);
        
        component.set("v.accountField", true);
        component.set("v.serviceField", false);
        component.set("v.invoiceField", true);
        
        component.set("v.accountRadio", false);
        component.set("v.invoiceRadio", false);
    },
 
    enableFieldInvoice : function(component, event, helper) {
        var selectedValue = event.getSource().get('v.name');
        var selectedState = event.getSource().get('v.value');
        
        if(selectedState){
            component.set("v.textEnabled" , 'none');
            selectedValue ="none";
        }else{
            component.set("v.textEnabled" , selectedValue);
        }
        
        component.find("serviceText").set("v.value", null);
        component.find("accountText").set("v.value", null);
        
        component.set("v.accountField", true);
        component.set("v.serviceField", true);
        component.set("v.invoiceField", false);
        
        component.set("v.accountRadio", false);
        component.set("v.serviceRadio", false);
    }
    
})