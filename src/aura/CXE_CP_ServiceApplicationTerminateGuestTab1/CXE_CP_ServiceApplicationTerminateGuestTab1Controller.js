({
    doInit : function(component, event, helper) {
        helper.getRelationshipToCustomer(component, event, helper);
    },

    doPageValidation : function(component, event, helper) {   
        var hasError = helper.validate(component, event, helper);
        component.set("v.hasErrorOnPage", hasError);
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTab2(component, event, helper);
    },

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseApplication.Relationship__c", selected);
    }
        
})