({    
    doInit: function(component, event, helper) {
        helper.getRelationshipToCustomer(component, event, helper);
    },

    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.CXE_Service_Request_s__c", selected);
        console.log(component.get("v.caseApplication.CXE_Service_Request_s__c"));
    },

    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.CXE_Service_Request_s__c", selected);
        console.log(component.get("v.caseApplication.CXE_Service_Request_s__c"));
    },
    
    onYesNoRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.AMC_Service_Tag__c", selected == "Yes");
    },

    onYesNoPaperlessBilling: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.CXE_Enroll_to_Paperless_Billing__c", selected == "Yes");
    },

    onYesNoAPA: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.CXE_Interested_in_Other_Payment_Methods__c", selected == "Yes");
    },

    onNotificationRadio: function(component, event, helper) {
        component.set("v.hasPreferredNotification",true);
        var selected = event.getSource().get("v.text");
        var modeOfNotification = '';
        component.set("v.caseApplication.Automatically_receive_SMS__c", (selected == "SMS" || selected == "Both"));
        component.set("v.caseApplication.Automatically_receive_an_e_mail__c", (selected == "Email" || selected == "Both"));
        if (selected == 'Both')
            component.set("v.caseApplication.Preferred_Mode_of_Notification__c", "SMS & Email");
        else {
            component.set("v.caseApplication.Preferred_Mode_of_Notification__c", selected);
        }
    },

    onSubmit: function(component, event, helper) {
        var childCmp = component.find("fileUploadCmp");
        childCmp.isValidFileSize();
        var isValid = component.get("v.isValidFileSize");
        if (isValid) {
            helper.submitRecontract(component, event, helper);
        }
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("submitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },

    onBehalfOptions: function(component, event, helper) {
        var cmpTarget = component.find("representativePage");
        if(event.getSource().get("v.text") == "Yes") {            
            component.set("v.onBehalf", true);
            $A.util.removeClass(cmpTarget, "slds-hide");
            $A.util.addClass(cmpTarget, "slds-show");
        } else {
            helper.removeFieldValuesOnTab1(component, event, helper);
            component.set("v.caseApplication.Relationship__c", null);
            component.set("v.onBehalf", false);
            $A.util.removeClass(cmpTarget, "slds-show");
            $A.util.addClass(cmpTarget, "slds-hide");
        }
    },

    onBusinessAddressOptions: function(component, event, helper) {
        var cmpTarget = component.find("BusinessAddressPage");
        component.set("v.caseApplication.Same_As_Service_Address__c", event.getSource().get("v.text") == "Yes");
        if(event.getSource().get("v.text") == "Yes") {
            $A.util.removeClass(cmpTarget, "slds-show");
            $A.util.addClass(cmpTarget, "slds-hide");
        } else {            
            $A.util.removeClass(cmpTarget, "slds-hide");
            $A.util.addClass(cmpTarget, "slds-show");
        }
    },

    getControllingPicklistService : function(cmp, event) {        
        console.log("controllingPicklist Service>> " + event.getParam("controllingPicklist"));
        cmp.set("v.caseApplication.Service_Address_Province__c", event.getParam("controllingPicklist"));
    },

    getDependentPicklistService : function(cmp, event) {
        console.log("dependentPicklist Service>> " + event.getParam("dependentPicklist"));
        cmp.set("v.caseApplication.Service_Address_City_Municiple__c", event.getParam("dependentPicklist"));
    },

    getControllingPicklistBusiness : function(cmp, event) {        
        console.log("controllingPicklist Business>> " + event.getParam("businessProvince"));
        cmp.set("v.caseApplication.Billing_Address_Province__c", event.getParam("businessProvince"));
    },

    getDependentPicklistBusiness : function(cmp, event) {
        console.log("dependentPicklist Business>> " + event.getParam("businessCity"));
        cmp.set("v.caseApplication.Billing_Address_City_Municipal__c", event.getParam("businessCity"));
    },    

    onYesNoAMC: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.AMC_Service_Tag__c", selected == "Yes");

        var cmpTarget = component.find("yesAMCNotif");
        if(selected == "Yes") {
            $A.util.removeClass(cmpTarget, 'slds-hide');
            $A.util.addClass(cmpTarget, 'slds-show');
        } else if(selected == "No"){
            $A.util.removeClass(cmpTarget, 'slds-show');
            $A.util.addClass(cmpTarget, 'slds-hide');
        }
    },

    goToTab1: function(component, event, helper) {
        helper.selectTab1(component, event, helper);
    },

    goToTab2: function(component, event, helper) {
        helper.selectTab2(component, event, helper);
    },

    goToTab3: function(component, event, helper) {
        helper.selectTab3(component, event, helper);
    },

    goToTab4: function(component, event, helper) {
        helper.selectTab4(component, event, helper);
    },

    onComplete: function(component, event, helper) {
        helper.backToSelection(component, event, helper);
    },

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseApplication.Relationship__c", selected);
        console.log("v.caseApplication.Relationship__c:" + component.get("v.caseApplication.Relationship__c"));
    },

    checkFile : function(component, event, helper) {
        component.set("v.isValidFileSize", event.getParam("isValid"));
    }
    
})