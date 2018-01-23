({
    doInit : function(component, event, helper) {
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
    },
    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        component.set("v.caseApplication.CXE_Service_Request_s__c", selected);
    },
    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        component.set("v.caseApplication.CXE_Service_Request_s__c", selected);
    },
    onYesNoRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        component.set("v.caseApplication.AMC_Service_Tag__c", selected == "Yes");
    },
    onNotificationRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.label");
        var modeOfNotification = '';
        component.set("v.caseApplication.Automatically_receive_SMS__c", (selected == "SMS" || selected == "Both"));
        component.set("v.caseApplication.Automatically_receive_an_e_mail__c", (selected == "Email" || selected == "Both"));
        if (selected == 'Both')
            component.set("v.caseApplication.Preferred_Mode_of_Notification__c", "SMS & Email");
        else {
            component.set("v.caseApplication.Preferred_Mode_of_Notification__c", selected);
        }
    },
    onSubmitModification: function(component, event, helper) {
        helper.submitModification(component, event, helper);
    }
    
})