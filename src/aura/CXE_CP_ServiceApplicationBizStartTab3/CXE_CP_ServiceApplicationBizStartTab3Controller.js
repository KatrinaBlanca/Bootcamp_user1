({
	submitTab : function(component, event, helper) {

        console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab3: ');

		//PLACE VALIDATION HERE


		//var servReq = component.get("v.caseRecord.CXE_Service_Request_s__c");
		var servReq = true;
        if(servReq){ //if no errors
            var setEvent = component.getEvent("callTabEvent");
            setEvent.setParams({"param1":4});
            setEvent.fire();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Please check your input.",
                                  "message": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Please select a service modification.",
                                  "type": "error",
                                  "duration" : 6000
                                 });
            toastEvent.fire();
        }
	},

    onClickAMC : function(component, event, helper) {
        var hasAMC = component.find("amcModify").getElement().checked;
        if(hasAMC) {
            helper.showCmp(component, "amcNotifModify");
        } else {
            helper.hideCmp(component, "amcNotifModify");
        }
        component.set("v.caseVar.AMC_Service_Tag__c", hasAMC);
    },

    onSelectNotification : function(component, event, helper) {
        var isSMS = component.find("smsModify").getElement().checked;
        var isEmail = component.find("emailModify").getElement().checked;
        var isBoth = component.find("bothModify").getElement().checked;
        var preferredMode = ( isSMS ? "SMS" : ( isEmail ? "Email" : ( isBoth ? "SMS & Email" : "" ) ) );
        component.set("v.caseVar.Automatically_receive_SMS__c", (isSMS || isBoth ));
        component.set("v.caseVar.Automatically_receive_an_e_mail__c", (isEmail || isBoth));      
        component.set("v.caseVar.Preferred_Mode_of_Notification__c", preferredMode);
    },

    onClickPaperless : function(component, event, helper) {
        var isPaperless = component.find("paperlessTag").getElement().checked;
        component.set("v.caseVar.CXE_Enroll_to_Paperless_Billing__c", isPaperless);
    },

    onClickAPA : function(component, event, helper) {
        var isAPA = component.find("apaRadio").getElement().checked;
        component.set("v.caseVar.CXE_Interested_in_Other_Payment_Methods__c", isPaperless);
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTab4(component, event, helper);
    }
    , files: function(cmp, evt, h){
        debugger;
    }
})