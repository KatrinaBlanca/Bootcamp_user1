({
	doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);    
    },

    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTabByButton(component, event, helper);
    },

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

    enableSubmitBtn : function(component, event, helper) {        
        var yes =document.getElementById("agreeChkbx").checked;         
        if(yes == true){            
            component.find("termsACBtn").set("v.disabled", false);             
        } else {            
            component.find("termsACBtn").set("v.disabled", true);             
        }
    },

    onSubmit : function(component, event, helper) {
        component.find("termsACBtn").set("v.disabled", true);
        helper.submitRecontract(component, event, helper);
    },

    upload_file_change: function(c, e, h){
        c.set("v.invalid_file", e.getParam("invalid"));
    },
    
    upload_progress_change: function(c, e, h){
        c.set("v.upload_progress", e.getParam("progress"));

        if(e.getParam("complete")){
            c.find("termsACBtn").set("v.disabled", false);
            // h.displayTab3(c, e, h);
            h.displaySpecific(c, e, h, "4");
        }
    }
})