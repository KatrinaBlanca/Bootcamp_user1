({
    retrieveAmount : function(component, event, helper) {
		
        var action = component.get("c.updateCase");
        //Set parameters
	    action.setParams({"caseId":  component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
                        
            console.log("Pumasok: " + response.getState());
            console.log("Response State : " + response.getState());
            console.log("Response Return Value : " + response.getReturnValue());
            var state = response.getState();
            var status = response.getReturnValue();
            if(state == 'SUCCESS'){
                
                if (status == 'Success')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Success!",
                                          "message": "Arrears has been updated",
                                          "type": "success"
                                         });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Error!",
                                          "message": response.getReturnValue(),
                                          "type": "info"  
                                         });
                    toastEvent.fire();
                }
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!",
                                      "message": response.getReturnValue(),
                                      "type": "info"  
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);        
	}   
   
})