({
    doInit : function(component, event, helper){
        helper.initializeCase(component, event, helper);
        helper.getRelationshipToCustomer(component, event, helper);

    },

    // changeTabUsingButton: function(component, event, helper) {
//     var eventValue= event.getParam("param1");
    //     if(component.get("v.activeTabNumber") != eventValue) {
    //         component.set("v.activeTabNumber", eventValue);
    //         component.set("v.tabToShow", eventValue);
    //         helper.displayTabFromButton(component, event, helper);
    //     }
    // },
    upload_file_change: function(c, e, h){
        c.set("v.invalid_file", e.getParam("invalid"));
    },
    upload_progress_change: function(c, e, h){
        c.set("v.upload_progress", e.getParam("progress"));

        if(e.getParam("complete")){
            c.find("terminateSubmitBtn").set("v.disabled", false);
            h.displayTab3(c, e, h);            
        }
    },
    getSubmittedCase: function(component, event, helper) {
        var eventValue= event.getParam("submittedCase");
        component.set("v.caseRecord", eventValue);
    },

    onClickTab : function(component, event, helper) {
        helper.displayTab(component, event, helper);
    },

    onClickNext : function(component, event, helper) {
        var activeNumber = component.get("v.activeTabNumber");
        if(activeNumber == 1) {
            helper.displayTab2(component, event, helper);
        }
    },

    onChangeRelationToOwner : function(component, event, helper) {
        var selected = component.find("selectedRelationToOwner").get("v.value");
        component.set("v.caseRecord.Relationship__c", selected); // CSM-14248 Mike Verdad 11/07/2017
    },

    onSubmit : function(component, event, helper) {
        // var childCmp = component.find("fileUploadCmp");
        // childCmp.isValidFileSize();
        // var isValidFileSize = component.get("v.isValidFileSize");
        // if(isValidFileSize) {
        //     helper.submitTerminate(component, event, helper);
        // }
        component.find("terminateSubmitBtn").set("v.disabled", true);
        helper.submitTerminate(component, event, helper);
    },

    onCheck: function(component, event, helper) {
        var cmpBtn = component.find("terminateSubmitBtn");
        cmpBtn.set("v.disabled",!event.getSource().get("v.value"));
    }

    

   
})