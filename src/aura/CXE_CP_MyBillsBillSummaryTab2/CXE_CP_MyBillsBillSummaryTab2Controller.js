({
    doInit : function(component, event, helper) {
        var totalAmt = component.get("v.totalAmountToPay");
        var totalConvenienceFee = component.get("v.convenienceFee");
        var totalSettlement = totalAmt + totalConvenienceFee;
        component.set("v.totalAmountForSettlement", totalSettlement);
        
    },
    Cancel: function(component, event, helper) {
        component.set("v.showLoader", true);
        location.reload();
    },
    showModal : function(component, event, helper) {
        //component.set("v.popUpModal", 'fillRequired');
        // @gibs: use codes below to show modals depending on tokenize
        //component.set("v.popUpModal", 'expiredCard');
        //component.set("v.popUpModal", 'invalidCard');
        //component.set("v.popUpModal", 'unsupportedCard');
    },
    changeSelect: function(component, event, helper) {
        var selectValue = event.getSource().get('v.value');	
        
        //START CSM-14745 RReyes DEC-12-17
        if(selectValue == 'Select Payment Option *'){
            component.set("v.booleanIf1", false);
            component.set("v.booleanIf2", false);
            component.set("v.booleanIf3", false);
            component.set("v.booleanIf4", false);
            component.set("v.booleanGrayOut", false);
        }
        //END CSM-14745 RReyes DEC-12-17
        if(selectValue == 'Credit Card'){
            component.set("v.booleanIf1", true);
            component.set("v.booleanIf2", false);
            component.set("v.booleanIf3", false);
            component.set("v.booleanIf4", false);
            component.set("v.booleanGrayOut", true);
            component.set("v.paymentOptionCode", $A.get("$Label.c.Payment_Mode_Card"));
            component.find("paymentOption").set("v.errors", null); //START/END CSM-14745 RReyes DEC-12-17
        } else if(selectValue == 'Debit Card'){
            component.set("v.booleanIf1", false);
            component.set("v.booleanIf2", true);
            component.set("v.booleanIf3", false);
            component.set("v.booleanIf4", false);
            component.set("v.booleanGrayOut", true);
            component.set("v.paymentOptionCode", $A.get("$Label.c.Payment_Mode_Card"));
            component.find("paymentOption").set("v.errors", null); //START/END CSM-14745 RReyes DEC-12-17
        } else if(selectValue == 'Prepaid Card (PayMaya, SmartMoney)'){
            component.set("v.booleanIf1", false);
            component.set("v.booleanIf2", false);
            component.set("v.booleanIf3", true);
            component.set("v.booleanIf4", false);
            component.set("v.booleanGrayOut", true);
            component.set("v.paymentOptionCode", $A.get("$Label.c.Payment_Mode_Card"));
            component.find("paymentOption").set("v.errors", null); //START/END CSM-14745 RReyes DEC-12-17
        } else if(selectValue == 'Prepaid Card (GCash)'){
            component.set("v.booleanIf1", false);
            component.set("v.booleanIf2", false);
            component.set("v.booleanIf3", false);
            component.set("v.booleanIf4", true);
            component.set("v.booleanGrayOut", true);
            component.set("v.paymentOptionCode", $A.get("$Label.c.Payment_Mode_Card"));
            component.find("paymentOption").set("v.errors", null); //START/END CSM-14745 RReyes DEC-12-17
        }
        
    },
    
    tokenize: function(component, event, helper){
        console.log('TOKENIZE');
        helper.getConvenienceFee(component,event);
        component.set("v.showLoader", true);
        var loaderr = component.find("v.showLoader");
        var cardNumber = component.find("cardNumber");
        var cardMM = component.find("cardMM"); 
        var cardYY = component.find("cardYY"); 
        var cardSecurityCode = component.find("cardSecurityCode"); 
        var paymayaTokenStartpoint = $A.get("$Label.c.paymayaTokenStartpoint");
        var paymayaToken = $A.get("$Label.c.paymayaToken");
        var totalAmt = component.get("v.totalAmountToPay").toString();
        var action = component.get("c.convenienceFee");
        action.setParams({"amount":totalAmt});
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                component.set("v.convenienceFee" , response.getReturnValue().amount);
                
                helper.tokenize(
                    paymayaTokenStartpoint
                    , paymayaToken
                    , 
                    
                    {
                        "card": {
                            "number": cardNumber.get("v.value"),
                            "expMonth": cardMM.get("v.value"),
                            "expYear": cardYY.get("v.value"),
                            "cvc": cardSecurityCode.get("v.value")
                        }
                    }
                ) // <- pass credit card object
                /*

        SAMPLE: 
        {
            "card": {
                "number": "4123450131000508",
                "expMonth": "10",
                "expYear": "2019",
                "cvc":      "123"
            }
        }

        */
                   
                   .then(function(token){
                       // success;
                       
                       var paymentTokenId = token.paymentTokenId;
                       component.set("v.showLoader", false);
                       var cCardName = component.find("paymentCardName");
                       var cAddress = component.find("paymentAddress");
                       var cNo = component.find("cardNumber");
                       var cMM = component.find("cardMM");
                       var cYY = component.find("cardYY");
                       var cYY1 = cYY.get("v.value");
                       var cSecCode = component.find("cardSecurityCode");
                       var cPaymentOption = component.find("paymentOption");
                       var caPaymentOption = cPaymentOption.get("v.value");
                       cNo.set("v.errors", null); 
                       cMM.set("v.errors", null); 
                       cYY.set("v.errors", null);
                       
                       cSecCode.set("v.errors", null);
                       cPaymentOption.set("v.errors", null); 
                       cCardName.set("v.errors", null);
                       var paymentOptionCode = component.get("v.paymentOptionCode");
                       
                       var selectValue = event.getSource().get('v.value');	
                       
                       var arrayMonth = [];
                       var today = new Date();
                       var currentYear = today.getFullYear();
                       for(x=0;x<11;x++){
                           var totalYear = currentYear + x;
                           arrayMonth.push(totalYear.toString());
                       }
                       
                       var yearString;
                       if(cYY1 != null){
                          yearString = cYY1.toString();
                       }
                       
                       if(caPaymentOption == 'Select Payment Option *'){
                           if(caPaymentOption == 'Select Payment Option *'){
                               //START CSM-14745 RReyes DEC-12-17
                               //component.set("v.errorMessageAll", $A.get("$Label.c.errMessage_PaymentInputYear"));
                               //END CSM-14745 RReyes DEC-12-17
                               cPaymentOption.set("v.errors", [{message: $A.get("$Label.c.errMessage_SelectPaymentOption")}]);
                           } else{
                               cPaymentOption.set("v.errors", null);
                               component.set("v.errorMessageAll", '');
                           }
                       }/*else if(arrayMonth.indexOf(yearString) < 0){
                           if(arrayMonth.indexOf(yearString) < 0){
                               cNo.set("v.errors", [{message:"Please input a valid month"}]); 
                               cMM.set("v.errors", [{message:"Please input a valid month"}]); 
                               cYY.set("v.errors", [{message:"Please input a valid month"}]); 
                               cSecCode.set("v.errors", [{message:"Please input a valid month"}]); 
                               component.set("v.errorMessageAll", $A.get("$Label.c.errMessage_PaymentInputYear"));
                               //component.set("v.errorMessageAll", 'TEST123');
                           }else{
                               component.set("v.errorMessageAll", '');
                           }
                       }*/
                       
                       
                       
                       var getCardNumber = cardNumber.get("v.value");
                       component.set("v.ccCardNumber", getCardNumber);
                       
                       var totalAmountPass = component.get("v.totalAmountToPay");
                       var showCardNumber = component.get("v.ccCardNumber");                       
                       var setEvent1 = component.getEvent("setToken");
                       setEvent1.setParams({"ccCardNumber" : showCardNumber});
                       setEvent1.fire();
                       
                       //START CSM-14756 RReyes DEC-27-17 - added GCash
                       if(caPaymentOption == 'Credit Card' || caPaymentOption == 'Debit Card' || caPaymentOption == 'Prepaid Card (GCash)'){
                       //END CSM-14756 RReyes DEC-27-17 - added GCash
                           var totalConvenienceFee = component.get("v.convenienceFee");
                       } else{
                           var totalConvenienceFee = '0.00';
                       }
                       
                       var subTotalMap = component.get("v.subTotalMap");
                       var overpaymentAmountArray = [];
                       
                       if(subTotalMap!=null){
                           for(var x=0; x<subTotalMap.length; x++){
                               if(subTotalMap[x].subtotal != subTotalMap[x].prevSubtotal && subTotalMap[x].isAccountSelected=="true"){
                                   var overpaymentAmount = subTotalMap[x].subtotal - subTotalMap[x].prevSubtotal;
                                   overpaymentAmountArray.push({"accountId": subTotalMap[x].key, "amount": overpaymentAmount});
                               }
                           }
                       }
                       
                       var totalAmountForSettlement = parseFloat(totalConvenienceFee) + parseFloat(totalAmountPass);
                       if(caPaymentOption != 'Select Payment Option *' && arrayMonth.indexOf(yearString) >= 0){
                           var setEvent = component.getEvent("setTotalAmount");
                           setEvent.setParams({"tabToNavigate":"tab3"});
                           //setEvent.setParams({"ccCardName": cCardName.get('v.value')});
                           //setEvent.setParams({"ccBillingAddress": cAddress.get('v.value')});
                           setEvent.setParams({"paymentTokenId": paymentTokenId});
                           setEvent.setParams({"convenienceFee": totalConvenienceFee});
                           setEvent.setParams({"totalAmountForSettlement": totalAmountForSettlement});
                           setEvent.setParams({"subTotalMap": subTotalMap});
                           setEvent.setParams({"overpaymentList": overpaymentAmountArray});
                           setEvent.setParams({"paymentOptionCode": paymentOptionCode});
                           if(cCardName.get('v.value') == null){
                               setEvent.setParams({"ccCardName": ''});
                           }else{
                               setEvent.setParams({"ccCardName": cCardName.get('v.value')});
                           }
                           if(cAddress.get('v.value') == null){
                               setEvent.setParams({"ccBillingAddress": ''});
                           }else{
                               setEvent.setParams({"ccBillingAddress": cAddress.get('v.value')});
                           }
                           console.log('ccCardName >>> ' + setEvent.getParam("ccCardName"));
                           console.log('ccBillingAddress >>> ' + setEvent.getParam("ccBillingAddress"));
                       }
                       setEvent.fire();
                       
                       //do something here
                       
                   })
                   .catch(function(error){ // <- auto display error toast
                       //alert(error.getBody());   
                       var cNo = component.find("cardNumber");
                       var cMM = component.find("cardMM");
                       var cYY = component.find("cardYY");
                       var cYY1 = cYY.get("v.value");
                       var cSecCode = component.find("cardSecurityCode");
                       var cName = component.find("paymentCardName");
                       var caName = cName.get("v.value");
                       var cPaymentOption = component.find("paymentOption");
                       var caPaymentOption = cPaymentOption.get("v.value");
                       var caMM = cMM.get("v.value");
                       cNo.set("v.errors", null); 
                       cMM.set("v.errors", null); 
                       cYY.set("v.errors", null); 
                       cSecCode.set("v.errors", null); 
                       
                       component.set("v.showLoader", false);
                       var parsed1 = JSON.parse(JSON.stringify(error.message));
                       var parsedError = JSON.stringify(error);
                       var parsedCode = JSON.parse(JSON.stringify(error.code));

                       component.set("v.errorMessageAll", parsed1);
                       
                       var selectValue = event.getSource().get('v.value');	
                       if(caPaymentOption == 'Select Payment Option *'){
                           
                           cPaymentOption.set("v.errors", [{message: $A.get("$Label.c.errMessage_SelectPaymentOption")}])
                       } else{
                           cPaymentOption.set("v.errors", null);
                       }
                       
                       if(parsedCode=='PY0036'){
                           component.set("v.errorMessageAll", $A.get("$Label.c.errMessage_PaymentNotSupported"));
                      	   cNo.set("v.errors", [{message:""}]);
                       }
                       if(parsedCode=='PY0003'){
                           component.set("v.errorMessageAll", $A.get("$Label.c.errMessage_PaymentInvalid"));
                           cNo.set("v.errors", [{message:""}]);
                       }
                       if(parsedCode=='2553'){
                           component.set("v.errorMessageAll", 'Please enter a valid card and input all required fields.');
                       }
                       
                       var arrayMonth = [];
                       for(x=1; x<13;x++){
                           arrayMonth.push(x.toString());
                       }
                                              
                       var arrayYear = [];
                       var today = new Date();
                       var currentYear = today.getFullYear();
                       var currentMonth = today.getMonth() + 1;
                       
                       for(x=0;x<11;x++){
                           var totalYear = currentYear + x;
                           arrayYear.push(totalYear.toString());
                       }
                       
                       var yearString;
                       var monthString;
                       var yearStringValidation;
                       if(cYY1!=null){
                           yearString = cYY1.toString();
                       }
                       if(caMM!=null){
                           monthString = caMM.toString();
                       }
                       
                       if(parsedCode=='PY0002'){
                           /*cMM.set("v.errors", [{message:""}]);
                           cYY.set("v.errors", [{message:""}]); 
                           cNo.set("v.errors", [{message:""}]); */
                           component.set("v.errorMessageAll", $A.get("$Label.c.errMessage_PaymentExpired"));
                       }
                       
                       // Start R2C CSM-14418 Von Pernicia 11-13-2017
                       yearStringValidation = yearString - currentYear;
                       if (yearStringValidation >= 10){
                   		    //component.set("v.errorMessageAll", $A.get("$Label.c.errMessage_PaymentInputYear"));
                            //cNo.set("v.errors", ''); 
                           	//cMM.set("v.errors", ''); 
                           	cYY.set("v.errors", [{message : $A.get("$Label.c.errMessage_PaymentInputYear")}]); 
                           	//cSecCode.set("v.errors", [{message:"Please input a valid month"}]); 
                       }
                       
                       //if(((caMM!=null && caMM!='') && arrayMonth.indexOf(monthString) < 0 && parsedCode=='PY0002')){
                       if (monthString <= 0 || monthString > 12) {                            
                           // Start R2C Von Pernicia CSM-14516 11-18-17
                           cMM.set("v.errors", [{message:"A valid 2-digit expiration month is required."}]); 
                           cSecCode.set("v.errors", null);
                           // End R2C Von Pernicia CSM-14516 11-18-17
                       }                       
                       // End R2C CSM-14418 Von Pernicia 11-13-2017
                       
                       var parsed = JSON.parse(JSON.stringify(error.parameters));
                       var result = JSON.stringify(parsed);
                       
                       for (var x=0; x < parsed.length; x++){
                           if(parsed[x].field!=null){
                               if(parsed[x].field.includes("card.number")){
                                   var errorMSG = parsed[x].description;
                                   cNo.set("v.errors", [{message:errorMSG}]); 
                               }
                               
                               if(parsed[x].field.includes("card.expMonth")){
                                   var errorMSG = parsed[x].description;
                                   cMM.set("v.errors", [{message:errorMSG}]); 
                               } 
                               
                               if(parsed[x].field.includes("card.expYear")){
                                   var errorMSG = parsed[x].description;
                                   cYY.set("v.errors", [{message:errorMSG}]); 
                               }
                               
                               if(parsed[x].field.includes("card.cvc")){
                                   var errorMSG = parsed[x].description;
                                   cSecCode.set("v.errors", [{message:errorMSG}]); 
                               } 
                           }
                       }
                       
                       component.set("v.errorMessage", error.message);
                       
                       var showError = component.get("v.errorMessage");
                   })
            }else{            
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "type": "Error",
                    "message": response.getReturnValue()
                });
                toastEvent.fire();   
            }
        });
        $A.enqueueAction(action); 
        
    },
    
    validateNumberOnly : function(component, event){
        var inputMonth = component.get("v.storeValueMonth");
        var inputYear = component.get("v.storeValueYear");
        var inputCardNumber = component.get("v.storeValueCardNumber");
        var inputCVV = component.get("v.storeValueCVV");
        if(isNaN(inputCardNumber)){
            component.set("v.storeValueCardNumber", inputCardNumber.substring(0, inputCardNumber.length - 1));
        }else if(isNaN(inputMonth)){
            component.set("v.storeValueMonth", inputMonth.substring(0, inputMonth.length - 1));
        }else if(isNaN(inputYear)){
            component.set("v.storeValueYear", inputYear.substring(0, inputYear.length - 1));
        }else if(isNaN(inputCVV)){
            component.set("v.storeValueCVV", inputCVV.substring(0, inputCVV.length - 1));
        }
    }
    
})