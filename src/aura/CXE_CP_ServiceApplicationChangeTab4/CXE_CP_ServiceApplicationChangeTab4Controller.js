({
    goToHome : function (component, event, helper){
        var home = window.location.protocol + '//' + window.location.hostname + '/'
        					 + location.pathname.split('/')[1] + '/' 
        					 + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(home);     
    },
    
     checkDetails : function(component, event, helper) {
		
       var emm = component.get("v.caseRecord.AMC_Service_Tag__c");
        console.log('amc: '+emm);
        var emm2 = component.get("v.caseRecord.Preferred_Mode_of_Notification__c");
        console.log('notif: '+emm2);
    }
})