({
    OpenOnlineFaqs : function(component, event, helper) {
        //CSM-14314 Corbes Melvin 11.10.2017
        var action = component.get("c.MiniAddsOnlineBillingFAQs");
        action.setCallback(this, function(response){
            
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    }
})