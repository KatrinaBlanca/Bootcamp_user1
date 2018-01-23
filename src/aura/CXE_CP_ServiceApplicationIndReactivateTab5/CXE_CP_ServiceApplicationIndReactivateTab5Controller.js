({
	backToHomeBtn : function(component, event, helper) {
		
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/dashboard"
        });
        urlEvent.fire();
	}/*,
    checkDetails : function(component, event, helper) {
		
       var emm = component.get("v.caseRecord.AMC_Service_Tag__c");
        console.log('amc: '+emm);
        var emm2 = component.get("v.caseRecord.Preferred_Mode_of_Notification__c");
        console.log('notif: '+emm2);
    }*/
})