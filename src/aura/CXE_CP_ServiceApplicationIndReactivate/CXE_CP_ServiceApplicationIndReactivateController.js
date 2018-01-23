({
    // changeTabUsingButton: function(component, event, helper) {
    //     var eventValue= event.getParam("param1");
    //     if(component.get("v.activeTabNumber") != eventValue) {
    //         component.set("v.activeTabNumber", eventValue);
    //         component.set("v.tabToShow", eventValue);
    //         helper.displayTabFromButton(component, event, helper);
    //     }
    // },

    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },

    onClickNext : function(component, event, helper) {
        helper.displayTabByButton(component, event, helper);
        
        // Start R2C CSM-15051 Von Pernicia
        var isPaperless = component.find("paperless").getElement().checked;
        console.log('ispaperless: '+isPaperless);
        component.set("v.caseRecord.CXE_Enroll_to_Paperless_Billing__c", isPaperless);
        // End R2C CSM-15051 Von Pernicia
    },

    doInit: function(component, event, helper) {
        helper.getRelationshipToCustomer(component, event, helper);
    },

    onClickApplyingOnBehalfOf : function(component, event, helper) {
        var selected = component.find("onBehalfOf").getElement().checked;
        component.set("v.isApplyingOnBehalfOf", selected);
    },

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseRecord.Relationship__c", selected);
    },

    onClickSameAsService : function(component, event) {        
        var selected = component.find("isSameAsService").getElement().checked;
        component.set("v.caseRecord.Same_As_Service_Address__c", selected);
        component.set("v.isSame", selected);
    },

    getControllingPicklistService : function(cmp, event) {        
        console.log("controllingPicklist Service>> " + event.getParam("controllingPicklist"));
        cmp.set("v.caseRecord.Service_Address_Province__c", event.getParam("controllingPicklist"));
    },

    getDependentPicklistService : function(cmp, event) {
        console.log("dependentPicklist Service>> " + event.getParam("dependentPicklist"));
        cmp.set("v.caseRecord.Service_Address_City_Municiple__c", event.getParam("dependentPicklist"));
    },

    getControllingPicklistBusiness : function(cmp, event) {        
        console.log("controllingPicklist Business>> " + event.getParam("businessProvince"));
        cmp.set("v.caseRecord.Billing_Address_Province__c", event.getParam("businessProvince"));
    },

    getDependentPicklistBusiness : function(cmp, event) {
        console.log("dependentPicklist Business>> " + event.getParam("businessCity"));
        cmp.set("v.caseRecord.Billing_Address_City_Municipal__c", event.getParam("businessCity"));
    },

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

    onSubmit : function(component, event, helper) {
        helper.submitRecontract(component, event, helper);
    },

    enableSubmitBtn : function(component, event, helper) {
        
        var yes =document.getElementById("agreeChkbx").checked; 
        
        if(yes == true){           
            component.find("termsACBtn").set("v.disabled", false);           
        } else {        
            component.find("termsACBtn").set("v.disabled", true);    
        }
    },

    upload_file_change: function(c, e, h){
        c.set("v.invalid_file", e.getParam("invalid"));
    },
    
    upload_progress_change: function(c, e, h){
        c.set("v.upload_progress", e.getParam("progress"));

        if(e.getParam("complete")){
            c.find("termsACBtn").set("v.disabled", false);
            // h.displayTab3(c, e, h);
            h.displaySpecific(c, e, h, "5");
        }
    }

})