({
    //Melvin Corbes
    //CSM-14185
   
    
    linkPrivacyPolicy  : function (component, event, helper){
        
        var action = component.get("c.PrivacyPolicyLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    linkTermsAndCondition  : function (component, event, helper){
        
        var action = component.get("c.TermsAndConditionLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },
    
})