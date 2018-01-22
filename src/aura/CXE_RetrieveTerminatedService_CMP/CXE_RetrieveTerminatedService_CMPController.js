({
	   
    validateStatus : function(component, event, helper) {
		
        var action = component.get("c.validateCaseStatus");
        //Set parameters
	    action.setParams({"caseId":  component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var status = response.getReturnValue();
            if(state == 'SUCCESS'){
                if (status == 'Success'){
					helper.retrieveService(component, event, helper);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Error!",
                                          "message": status,
                                          "type": "info"  
                                         });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!",
                                      "message": status,
                                      "type": "info"  
                                     });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);        
	}
})