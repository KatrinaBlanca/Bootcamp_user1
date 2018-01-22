({
	onClickAMC : function(component, event, helper) {
		var hasAMC = component.find("amcModify").getElement().checked;
		if(hasAMC) {
			helper.showCmp(component, "amcNotifModify");
		} else {
			helper.hideCmp(component, "amcNotifModify");
		}
		component.set("v.caseRecord.AMC_Service_Tag__c", hasAMC);
	},

	onSelectNotification : function(component, event, helper) {
		var isSMS = component.find("smsModify").getElement().checked;
		var isEmail = component.find("emailModify").getElement().checked;
		var isBoth = component.find("bothModify").getElement().checked;
		var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "SMS & Email" : "" ) ) );
		component.set("v.caseRecord.Automatically_receive_SMS__c", (isSMS || isBoth ));
		component.set("v.caseRecord.Automatically_receive_an_e_mail__c", (isEmail || isBoth));		
		component.set("v.caseRecord.Preferred_Mode_of_Notification__c", preferredMode);
	},

	onClickNext : function(component, event, helper) {   
        helper.displayTab4(component, event, helper);
    }

	
})