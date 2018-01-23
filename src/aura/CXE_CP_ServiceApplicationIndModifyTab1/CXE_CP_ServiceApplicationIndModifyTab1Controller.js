({
    doInit : function(component, event, helper) {
        helper.getServiceModificationOptions(component, event, helper);
        helper.getContractModificationOptions(component, event, helper);
        helper.getRelationshipToCustomer(component, event, helper);
        
        //var selectedRadio = document.getElementById('changeDetails').value;
        //if (selectedRadio == null) {
        /*    if (document.getElementById('changeDetails').value == 'options1') {
                document.getElementById('changeDetails')[0].setAttribute("checked", "checked");
            }
        
            if (document.getElementById('changeDetails').value == 'options2') {
                document.getElementById('changeDetails')[1].setAttribute("checked", "checked");
            }*/
        //}
    },

    doPageValidation : function(component, event, helper) {   
        var hasError = helper.validate(component, event, helper);
        component.set("v.hasErrorOnPage", hasError);
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTab2(component, event, helper);
    },

    onClickServiceMod : function(component, event, helper) {
        var selected = component.find("isServiceMod").getElement().checked;
        
        component.set("v.caseRecord.CXE_Service_Request_s__c", null);
        component.set("v.isServiceMod", selected);
        component.set("v.isShow", true);
    },

    onServiceRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
        console.log(component.get("v.caseApplication.CXE_Service_Request_s__c"));
    },

    onContractRadio: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        component.set("v.caseRecord.CXE_Service_Request_s__c", selected);
        console.log(component.get("v.caseApplication.CXE_Service_Request_s__c"));
    }
})