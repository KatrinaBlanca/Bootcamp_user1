({
	onClickAMC : function(component, event, helper) {
		var hasAMC = component.find("amc").getElement().checked;
		if(hasAMC) {
			helper.showCmp(component, "amcNotif");
		} else {
			helper.hideCmp(component, "amcNotif");
		}
		component.set("v.caseRecord.AMC_Service_Tag__c", hasAMC);
	},

	onSelectNotification : function(component, event, helper) {
		var isSMS = component.find("sms").getElement().checked;
		var isEmail = component.find("email").getElement().checked;
		var isBoth = component.find("both").getElement().checked;
		var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "SMS & Email" : "" ) ) );
		component.set("v.caseRecord.Automatically_receive_SMS__c", (isSMS || isBoth ));
		component.set("v.caseRecord.Automatically_receive_an_e_mail__c", (isEmail || isBoth));		
		component.set("v.caseRecord.Preferred_Mode_of_Notification__c", preferredMode);
	},

	onClickNext : function(component, event, helper) {   
        helper.displayTab3(component, event, helper);
    }

})