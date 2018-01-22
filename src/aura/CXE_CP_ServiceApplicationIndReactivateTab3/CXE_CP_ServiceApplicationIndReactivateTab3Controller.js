({
	

	onClickPaperless : function(component, event, helper) {
		var isPaperless = component.find("paperless").getElement().checked;
        console.log('ispaperless: '+isPaperless);
		// Start R2C CSM-15051 Von Pernicia
		//component.set("v.caseRecord.Paperless_Billing__c", isPaperless);
		component.set("v.caseRecord.CXE_Enroll_to_Paperless_Billing__c", isPaperless);
		// End R2C CSM-15051 Von Pernicia
	},

	onClickAPA : function(component, event, helper) {
		var isAPA = component.find("apa").getElement().checked;
        
		component.set("v.caseRecord.CXE_Interested_in_Other_Payment_Methods__c", isAPA);
        console.log('isapa: '+isAPA);
	},

	onClickAMC : function(component, event, helper) {
		var hasAMC = component.find("amc").getElement().checked;
		if(hasAMC) {
			helper.showCmp(component, "amcNotif");
		} else {
			helper.hideCmp(component, "amcNotif");
		}
		component.set("v.caseRecord.AMC_Service_Tag__c", hasAMC);
        console.log('hasamc: '+hasAMC);
	},

	onSelectNotification : function(component, event, helper) {
		var isSMS = component.find("sms").getElement().checked;
		var isEmail = component.find("email").getElement().checked;
		var isBoth = component.find("both").getElement().checked;
		var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "SMS & Email" : "" ) ) );
		component.set("v.caseRecord.Automatically_receive_SMS__c", (isSMS || isBoth ));
		component.set("v.caseRecord.Automatically_receive_an_e_mail__c", (isEmail || isBoth));		
		component.set("v.caseRecord.Preferred_Mode_of_Notification__c", preferredMode);
        console.log('preferred mode: '+preferredMode);
	},

	onClickNext : function(component, event, helper) {   
        helper.displayTab4(component, event, helper);
    }

	
})