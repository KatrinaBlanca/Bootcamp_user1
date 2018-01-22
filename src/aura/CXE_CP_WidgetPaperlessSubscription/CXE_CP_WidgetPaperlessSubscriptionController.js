({
    
	openPDfVault : function(component, event, helper) {
        //CSM-14314 Corbes Melvin 11.10.2017
        var action = component.get("c.MiniAddsOnlineBillingFAQs");
        action.setCallback(this, function(response){
            
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        // end of CSM-14314
        
		//START CSM-14015 GGrandea 10.23.2017
        /*var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":'true'});
        setEvent.fire()*/ 
	        // disable code as it messes up View Bills Page; 
	        //this mini ad is not functioning well in other pages anyway
        //END CSM-14015
	}

    
    
})