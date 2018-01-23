({  
    doInit: function(component, event, helper) {
        helper.getRelationshipToCustomer(component, event, helper);
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
            helper.submitNew(component, event, helper);
        }
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("modifySubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    },

    handleError:function(cmp,event,helper){
        var comp = event.getSource();
        $A.util.addClass(comp, "error");   
    },

    handleClearError:function(cmp,event,helper){
        var comp = event.getSource();
        $A.util.removeClass(comp, "error");   
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
    checkFile : function(component, event, helper) {
        component.set("v.isValidFileSize", event.getParam("isValid"));
    }  
    
})