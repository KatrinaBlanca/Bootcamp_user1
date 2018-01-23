({
    doInit : function(component, event, helper) {
        helper.getSalutations(component, event, helper);
	},
    
    toggleSMS : function(component, event, helper) {        
        var caseRec = component.get("v.caseApplication");
        if(caseRec.Automatically_receive_SMS__c) {
			caseRec.Automatically_receive_SMS__c = false;
        } else {
            caseRec.Automatically_receive_SMS__c = true;
        }        
        component.set("v.caseApplication", caseRec);        
	},
    
    toggleEmail : function(component, event, helper) {        
        var caseRec = component.get("v.caseApplication");
        if(caseRec.Automatically_receive_an_e_mail__c) {
			caseRec.Automatically_receive_an_e_mail__c = false;
        } else {
            caseRec.Automatically_receive_an_e_mail__c = true;
        }        
        component.set("v.caseApplication", caseRec);        
	},
    
	onSubmit : function(component, event, helper) {
		helper.toggleSpinner(component, event, helper);
        
        var caseRec = component.get("v.caseApplication");
        
        var firstname = component.find("firstname").get("v.value"); 
        var middlename = component.find("middlename").get("v.value"); 
        var lastname = component.find("lastname").get("v.value");        
        var phone = component.find("phone").get("v.value");
        var mobile = component.find("mobile").get("v.value");
        var email = component.find("emailaddress").get("v.value");        
        var company = component.find("company").get("v.value");  
        var designation = component.find("designation").get("v.value"); 
        var tin = component.find("tin").get("v.value");
        
        caseRec.First_Name__c = firstname;
        caseRec.Middle_Name__c = middlename;
        caseRec.Last_Name__c = lastname;        
        caseRec.Telephone_No__c = phone;
        caseRec.Mobile_No__c = mobile;
        caseRec.Email_Address__c = email;   
        caseRec.Designation__c = designation;   
        caseRec.Last_Name_Business_Name__c = company;
        
        caseRec.Tax_Identification_No__c = tin;
        caseRec.Application_for_Business_Customer__c = true;
        
        var action = component.get("c.submitCaseApplication");    
        action.setParams({
            "caseApplication": caseRec,
            "addressRecord" : null
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){ 
                             
				var response = a.getReturnValue();    
                
                if (!response.hasError) {
                    var evtCaseNumber = $A.get("e.c:CaseNumberEvent");
                    evtCaseNumber.setParams({ "caseNumber": response.caseNumber});
                    evtCaseNumber.fire();        	            
                    
                    
                    var cmpHide = "CXE_ServiceApplicationBusiness";
                    var evtHide = $A.get("e.c:HideTargetComponentEvent");
                    evtHide.setParams({ "hideCmpTarget": cmpHide});
                    evtHide.fire();        
                    
                    var cmpShow = "CXE_ServiceApplicationBusinessThankYou";        
                    var evtShow = $A.get("e.c:ShowTargetComponentEvent");
                    evtShow.setParams({ "showCmpTarget": cmpShow});
                    evtShow.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "Warning",
                                          "mode": "sticky"
                    });
                    toastEvent.fire();                    
                }
                
            } else {
                console.log('err >>>>>>>>>>>>>>>' + JSON.stringify(a.getReturnValue()));
            }
        });
        $A.enqueueAction(action);         
	}
})