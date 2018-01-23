({
	submitRecontract : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        var caseRec = component.get("v.caseRecord");
                
        var action = component.get("c.submitServiceApplication");

        console.log("JSON:" + JSON.stringify(caseRec));

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Recontract_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {
                    helper.pushEvent(component, "5");
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                } else {
                    helper.pushEvent(component, "4");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration" : 6000
                                         });
                    toastEvent.fire();
                }
            } else {
                helper.pushEvent(component, "4");
                var errors = a.getError();
                // CSM-13020 Melvin Corbes 10-02-17 alert("errorMsg" + errors);
                console.log(errors);
                if (errors) {

                    if (errors[0] && errors[0].message) {

                        console.log("Error message: " + 
                                 errors[0].message);

                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Please validate your application.",
                                              "message": errors[0].message,
                                              "type": "error",
                                              "duration" : 6000
                                             });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }                
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    pushEvent : function (component, tabName) {
        var setEvent = component.getEvent("changeTabUsingButtonEvent");
        setEvent.setParams({
            "param1" : tabName
        });
        setEvent.fire();
    }
})