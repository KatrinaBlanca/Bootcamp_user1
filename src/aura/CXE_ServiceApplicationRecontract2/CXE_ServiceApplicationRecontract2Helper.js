({
    getServiceModificationOptions : function(component, event, helper){
        var action = component.get("c.getServiceModifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.serviceModifications", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        $A.enqueueAction(action);
    },

    getContractModificationOptions : function(component, event, helper) {
        var action = component.get("c.getContractModifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.contractModifications", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        $A.enqueueAction(action);
    },


    submitModification : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        console.log('>>>>>>>>>>>>>>>>>> submitModification.');
        var action = component.get("c.submitSAForModification");
        action.setParams({
            "caseApplication": component.get("v.caseApplication")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                console.log('>>>>>>>>>>>>>>>>>> Error.' + JSON.stringify(response));
                if (!response.hasError) {
                    component.set("v.caseNumber", response.caseNumber);

                    $('.slds-tabs_scoped__item').removeClass('slds-is-active');
                    $('#tab-scoped-5__item').parent().addClass('slds-is-active');
                    $('.slds-tabs_scoped__content').removeClass('slds-show').addClass('slds-hide');
                    $('#tab-scoped-5').removeClass('slds-hide').addClass('slds-show');

                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "Warning",
                                          "mode": "sticky"
                                         });
                    toastEvent.fire();
                }
            } else {
                console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": a.getReturnValue(),
                                      "type": "Warning",
                                      "mode": "sticky"
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    }
})