({
    doInit : function(component, event, helper) {
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
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

    onServiceRequestRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.serviceRequest", selected);
        component.set("v.caseApplication.CXE_Service_Request_s__c", null);
        console.log(component.get("v.serviceRequest"))
        component.set("v.selectedModification", selected);
        if(selected == "Service Modification") {
            helper.uncheckRadioList(component, event, helper,component.find("serviceReqForContract"));
            helper.removeFieldValuesOnTab1(component, event, helper);
            $A.util.removeClass(component.find("serviceRequestContractOption"), "slds-show");
            $A.util.addClass(component.find("serviceRequestContractOption"), "slds-hide");
            $A.util.removeClass(component.find("serviceRequestServiceOption"), "slds-hide");
            $A.util.addClass(component.find("serviceRequestServiceOption"), "slds-show");            
        } else if (selected == "Contract Modification") {
            helper.uncheckRadioList(component, event, helper,component.find("serviceReqForService"));
            $A.util.removeClass(component.find("serviceRequestServiceOption"), "slds-show");
            $A.util.addClass(component.find("serviceRequestServiceOption"), "slds-hide");
            $A.util.removeClass(component.find("serviceRequestContractOption"), "slds-hide");
            $A.util.addClass(component.find("serviceRequestContractOption"), "slds-show");   
        }        
    },

    onYesNoRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseApplication.AMC_Service_Tag__c", selected == "Yes");
    },

    onNotificationRadio: function(component, event, helper) {
        component.set("v.hasPreferredNotification", true);
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
            helper.submitModification(component, event, helper);
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
        console.log("activeTabBefore:" ,component.get("v.activeTab"));        
        helper.selectTab1(component, event, helper);
        console.log("activeTab:" ,component.get("v.activeTab"));
    },

    goToTab2: function(component, event, helper) {  
        console.log("activeTabBefore:" ,component.get("v.activeTab"));      
        helper.selectTab2(component, event, helper);
        console.log("activeTabAfter:" ,component.get("v.activeTab"));
    },
    goToTab3: function(component, event, helper) {  
        console.log("activeTabBefore:" ,component.get("v.activeTab"));            
        helper.selectTab3(component, event, helper);
        console.log("activeTab:" ,component.get("v.activeTab"));
    },
    goToTab4: function(component, event, helper) {  
        console.log("activeTabBefore:" ,component.get("v.activeTab"));            
        helper.selectTab4(component, event, helper);
        console.log("activeTab:" ,component.get("v.activeTab"));
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