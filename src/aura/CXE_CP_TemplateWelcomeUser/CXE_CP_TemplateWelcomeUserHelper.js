({
	getLoginHistory : function(component, event, helper) {
		//START CSM-13070 GGrandea 10.02.2017
        //var action = component.get("c.LoginDetails");
        var action = component.get("c.retrieveLoginHistory");
        //END CSM-13070 GGrandea 10.02.2017
        action.setCallback(this,function(response){          
            var state = response.getState();
            var Total = 0;
            
            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                component.set("v.LastLogin" , response.getReturnValue().LastLoginDate);                
                //START CSM-13070 GGrandea 10.02.2017
                if(response.getReturnValue().loginHistoryList.length>0){
                    for(var i = 0; i < response.getReturnValue().loginHistoryList.length; i++){
                        if(response.getReturnValue().loginHistoryList[i].Status=='Success'){
                            component.set("v.LastLogin" , response.getReturnValue().loginHistoryList[i].LoginTime);
                            break;
                        }
                    }
                }
                //END CSM-13070 GGrandea 10.02.2017
                component.set("v.FirstName" , response.getReturnValue().FirstName);
                
                //console.log(response.getReturnValue().UserAccounts.Id); //CSM-13070
                console.log(response.getReturnValue().LastLoginDate);
            }else{
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action); 
	},
    
    getProfilePic : function(component, event, helper) {
		var action = component.get("c.getProfilePicture");        
        action.setCallback(this, function(a) {
            var photoURL = a.getReturnValue();
            if (photoURL) {
	            component.set('v.profilePic', photoURL);
            }
        });
        $A.enqueueAction(action); 
	}
    
    
})