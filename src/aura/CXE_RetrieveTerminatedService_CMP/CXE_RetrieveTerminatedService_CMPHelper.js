({
	retrieveService : function(component, event, helper) {
		
        var action = component.get("c.updateCase");
        //Set parameters
	    action.setParams({"caseId":  component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            
            console.log("Pumasok" + response.getState());
            var state = response.getState();
            var status = response.getReturnValue();
            console.log("Pumasok2" + response.getReturnValue());
            if(state == 'SUCCESS'){
                
                if (status == 'Success')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Success!",
                                          "message": "Case has been updated",
                                          "type": "success"   
                                         });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else
                {
                    console.log("May Error" + status);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Error!",
                                          "message": status,
                                          "type": "info"  
                                         });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    console.log('Error>>>' + status);
                }
            }
            else
            {
                console.log("May Error" + status);
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