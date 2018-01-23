({
    
    doInit: function(component, event, helper) {
        helper.getRelationshipToCustomer(component, event, helper);
        // helper.prepareFileUpload(component, event, helper);
    },

    onSubmit: function(component, event, helper) {
        var childCmp = component.find("fileUploadCmp");
        childCmp.isValidFileSize();
        var isValid = component.get("v.isValidFileSize");
        if (isValid) {
            helper.submitTermination(component, event, helper);
        }
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("submitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
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

    onComplete : function(component, event, helper) {  
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