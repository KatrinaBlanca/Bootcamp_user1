({
    doInit : function(component, event, helper) {
        var action = component.get("c.LoginDetails");
        action.setCallback(this,function(response){          
            var state = response.getState();
            var Total = 0;
            
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                component.set("v.LastLogin" , response.getReturnValue().LastLoginDate);
                component.set("v.FirstName" , response.getReturnValue().FirstName);
                
                console.log(response.getReturnValue().UserAccounts.Id);
                console.log(response.getReturnValue().LastLoginDate);
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action); 
    }
    
    /* logout : function(component, event, helper) {
        window.location.replace("/customers/secur/logout.jsp");
    } */
})