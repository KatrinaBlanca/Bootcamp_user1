({
	submitModify : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        component.set("v.caseRecord.Application_Type_Subtype__c", "Modification of Electric Service");
        var caseRec = component.get("v.caseRecord");
                
        var action = component.get("c.submitServiceApplication");

        console.log("JSON:" + JSON.stringify(caseRec));

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Modification_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            // helper.toggleSpinner(component, event, helper);
            console.log("state:", state);
            console.log("a.getReturnValue():", a.getReturnValue());
            if(state == "SUCCESS"){
                var response = a.getReturnValue();

                if (!response.hasError) {
                    component.upload(response.caseRecordId);
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    helper.pushEvent(component, "5");
                    helper.pushSubmittedCaseEvent(component, component.get("v.caseRecord"));
                } else {
                    helper.pushEvent(component, "4");
                    helper.toggleSpinner(component, event, helper);
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
                helper.toggleSpinner(component, event, helper);
                var errors = a.getError();
                // alert("errorMsg" + errors); //CSM-13020 Melvin Corbes 10-02-17
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
                    helper.toggleSpinner(component, event, helper);
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
    },

    pushSubmittedCaseEvent : function (component, caseRec) {
        var setEvent = component.getEvent("submittedCaseEvt");
        setEvent.setParams({
            "submittedCase" : caseRec
        });
        setEvent.fire();
    }
})