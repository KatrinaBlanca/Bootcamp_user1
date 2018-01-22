({
	hideCmp : function (component, event, helper){
        
        var action = component.get("c.UpdateAutoEnrollment");
        
        action.setCallback(this,function(response){          
            var state = response.getState();
            var Total = 0;
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                
                var mmm = response.getReturnValue().CXE_Auto_Enrolled_Services__c;
                //alert(mmm);
                component.set("v.getValue", false);
                
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action);

    },
    
    redirectMyAccounts : function (component, event, helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/myaccounts"
        });
        urlEvent.fire();
    }
})