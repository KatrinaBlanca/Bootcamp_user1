({
	doInit : function(component, event, helper) {
        
        var action = component.get("c.LoginDetails");
         action.setCallback(this,function(response){          
                var state = response.getState();
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    
                    var lname = response.getReturnValue().LastName;
                    var fname = response.getReturnValue().LastName;
                    
                    var fullname = lname + ' ' + fname;
                    component.set("v.FullName", fullname);
                    //component.set("v.LastName" , response.getReturnValue().LastName);
                    //component.set("v.FirstName" , response.getReturnValue().FirstName);
                }else{
                    console.log("Failed With state: " + state);
                    console.log("Returned:");
                    console.log(response.getReturnValue());
                }
            });  
        $A.enqueueAction(action); 
        
	}
})