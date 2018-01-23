({
    getContainerDiv1: function(event, element) {
        var elem;
        if (!element) {
            elem = event.srcElement;
        }
        else {
            elem = element;
        }

        if (elem.classList.contains('slds-tabs--default__item')) {
            return elem;
        }
        else {
            return this.getContainerDiv1(event, elem.parentElement);
        }
    },

    getContainerDiv: function(event, element) {
        var elem;
        if (!element) {
            elem = event.srcElement;
        }
        else {
            elem = element;
        }

        if (elem.classList.contains('slds-tabs_scoped__item')) {
            return elem;
        }
        else {
            return this.getContainerDiv(event, elem.parentElement);
        }
    },

    trackApplication : function (component, event, helper) {
        helper.toggleSpinner(component, event, helper);
        var action = component.get("c.trackApplication");
        action.setParams({
            "referenceNumber": component.get("v.referenceNumber"),
            "lastName": component.get("v.lastName")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {
                    component.set("v.caseHistoryList", response.caseStatusHistoryList);
                    component.set("v.caseNumber", response.caseNumber);
                    component.set("v.isTerminate", response.isTerminate);
                    helper.toggleCmp(component, "searchPage");
                    helper.toggleCmp(component, "results");
                    if(response.statusJourney) {
                        $A.util.addClass(component.find(response.statusJourney), 'slds-is-active');
                    }                    
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Oops!",
                                          "message": response.errorMessage,
                                          "type": "Error"
                                         });
                    toastEvent.fire();
                }
            } else {
                console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Oops!",
                                      "message": a.getReturnValue(),
                                      "type": "Error"
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    toggleCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    }
})