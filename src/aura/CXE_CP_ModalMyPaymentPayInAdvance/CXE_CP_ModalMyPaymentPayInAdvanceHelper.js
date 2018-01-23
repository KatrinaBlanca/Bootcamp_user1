({
	ACCOUNT_SELECT_ALL: "Select an Account Number",
    SIN_SELECT_ALL: "Select a Service ID Number",
    
    setPicklistOptions : function(component, event) {
        var action = component.get("c.retrievePortalData");
        action.setParams({"hasBilling": true});
        
        action.setCallback(this,function(response){
            var state = response.getState();
            var retVal = response.getReturnValue();
            
            console.log("Von Return: " + JSON.stringify(retVal));
            
            //FOR ACCOUNT LIST PART DROPDOWN
            
            var accountList = [];
            accountList.push({ class: "optionClass", label: this.ACCOUNT_SELECT_ALL, value: this.ACCOUNT_SELECT_ALL});
            
            //FOR SIN LIST PART DROPDOWN
            var sinList = [];
            sinList.push({ class: "optionClass", label: this.SIN_SELECT_ALL, value: this.SIN_SELECT_ALL});
            if(component.isValid() && (state === "SUCCESS") && retVal != null){
                
                //Populate Account picklist
                for(var i = 0; i < retVal.AccountsWithAllSINEnrolledWithoutBill.length; i++){ 
                    //accountList.push(retVal.AccountsWithAllSINEnrolledWithoutBill[i]);
                    accountList.push({ class: "optionClass", label: retVal.AccountsWithAllSINEnrolledWithoutBill[i], value: retVal.AccountsWithAllSINEnrolledWithoutBill[i]});
                }
                //component.set("v.acctOptions" , accountList);
                  component.find("accountSelected").set("v.options", accountList);
                
                if(accountList)
                {
                    component.find("nextButton").set("v.disabled", false);
                }
                
                //Populate Service picklist
                for(var i = 0; i < retVal.ServiceWithAllSINEnrolledWithoutBill.length; i++){ 
                    // Start R2C CSM-14656 Von Pernicia 11-23-17
                    //sinList.push(retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c + '_' + retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_Alias__c);
                    if (retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_Alias__c != null)
                    {
                        sinList.push({ class: "optionClass", label: retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c + '_' + retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_Alias__c, value: retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c});
                    }
                    else
                    {
                        sinList.push({ class: "optionClass", label: retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c, value: retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c});
                    }
                    //console.log('>>CXE_Alias__c' + retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_Alias__c);
                    //sinList.push({ class: "optionClass", label: retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c + '_' + retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_Alias__c, value: retVal.ServiceWithAllSINEnrolledWithoutBill[i].CXE_ServiceId__r.SIN__c});
                    // End R2C CSM-14656 Von Pernicia 11-23-17
                }
                //component.set("v.sinOptions" , sinList);
                component.find("sinSelected").set("v.options", sinList);
                if(sinList)
                {
                    component.find("nextButton").set("v.disabled", false);
                }
            }
        });  
        $A.enqueueAction(action);
         
    },
    
    nextButton : function(component, event) {
        var isTrue = true;
        var selectedAccount = component.find("accountSelected");
        var selectedSin = component.find("sinSelected");
        var amountToPay = component.find("amount-to-pay");
        component.find('accountSelected').set('v.errors' , null);  
        component.find('sinSelected').set('v.errors' , null);  
        component.find('amount-to-pay').set('v.errors' ,null);  
        
        
        if (selectedAccount.get("v.value") == this.ACCOUNT_SELECT_ALL && selectedSin.get("v.value") == this.SIN_SELECT_ALL){
            component.find('accountSelected').set('v.errors' , [{message:'Please select reference'}]);  
            component.find('sinSelected').set('v.errors' , [{message:'Please select reference'}]);  
            
            isTrue=false;
        }
        if(!amountToPay.get("v.value")){
            component.find('amount-to-pay').set('v.errors' , [{message:'Please input amount'}]);  
            isTrue=false;
        }
        
        
        if (isTrue)
        {
        	var setEvent = component.getEvent("setAttribute");
            component.find('nextButton').set('v.disabled' , true);
            
            var action = component.get("c.getBillDetails");
            if(selectedAccount.get("v.value") != this.ACCOUNT_SELECT_ALL){
                action.setParams({"validationType": 'accountRadio',"valuePass": selectedAccount.get("v.value"),"amountPass": amountToPay.get("v.value")});
            	setEvent.setParams({"advanceState": "advanceAccount"});
            }
            
            if(selectedSin.get("v.value") != this.SIN_SELECT_ALL){
                action.setParams({"validationType": 'serviceRadio',"valuePass": selectedSin.get("v.value"),"amountPass": amountToPay.get("v.value")});
            	setEvent.setParams({"advanceState": "advanceService"});
            }
            
            action.setCallback(this,function(response){
                component.find('nextButton').set('v.disabled' , false);
                var state = response.getState();
            	var retVal = response.getReturnValue();
				
                if (state === "SUCCESS")
                {
                    //var setEvent = component.getEvent('setAttribute');
                    setEvent.setParams({"returnDetails": retVal});
                    setEvent.fire();
                    
                    component.set("v.modalPopUpChild", null);
                }
                
            });  
        	
            $A.enqueueAction(action);
        }
        
         /*
    	var selectedAccount = component.find("accountSelected");
        var selectedSIN = component.find("sinSelected");\
        //var amountToPay = component.find("amount-to-pay");
//alert(amountToPay.get("v.value"));
        if (selectedAccount.get("v.value") != this.ACCOUNT_SELECT_ALL)
        {
        	//var setEvent = component.getEvent("setAttribute");
            //setEvent.setParams({"AccountNumber":selectedAccount.get("v.value")});
            //setEvent.setParams({"AmountToPay":response.getReturnValue()});
            //setEvent.fire();
        }	
       
        if (selectedSIN.get("v.value") != this.SIN_SELECT_ALL)
        {
        	var setEvent = component.getEvent("setAttribute");
            setEvent.setParams({"SINNumber":selectedSIN.get("v.value")});
            //setEvent.setParams({"AmountToPay":response.getReturnValue()});
            //setEvent.fire();
        }*/
    }
})