({
	OpenMiniAddsBillSummary  : function (component, event, helper){
        var action = component.get("c.MiniAddsPaperlessBillingUnsubscribe"); // CSM-14499 Mike Verdad 12/06/2017
        action.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})