({
    doInit : function(component, event, helper) {
        
    },
    cancelButton : function(component, event, helper) {
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"successValue":false});
        setEvent.fire();
    },
    nextButton : function(component, event, helper) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var newEmail = component.find("secondary-email-address");
        //alert(newEmail.get("v.value")); //CSM-12551 remove alerts
        if(newEmail.get("v.value") != ''){
            if(!newEmail.get("v.value").match(regExpEmailformat)){
                newEmail.set("v.errors", [{message:"Invalid Email Format"}]);
            }else{
                var action = component.get("c.updateEmail");
                action.setParams({"emailadd":newEmail.get("v.value") ,"accountid":component.get('{!v.acctId}')});
                action.setCallback(this,function(response){          
                    var state = response.getState();
                    
                    //FOR ACCOUNT LIST PART DROPDOWN
                    
                    if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                        var setEvent = component.getEvent("setAttribute");
                        setEvent.setParams({"successValue":true});
                        setEvent.setParams({"reference":response.getReturnValue()});
                        setEvent.fire();
                        console.log(response.getReturnValue());
                        
                    }else{
                        
                        //alert('yow');
                        console.log("Failed With state: " + state);
                        console.log("Returned:");
                        console.log(response.getReturnValue());
                    }
                });  
                $A.enqueueAction(action); 
            }
        }
        //Start CSM-12551 Emandolado 9/13/2017
        else{
            var newEmail = component.find("secondary-email-address");
            var action = component.get("c.updateEmail");
            action.setParams({"emailadd":newEmail.get("v.value") ,"accountid":component.get('{!v.acctId}')});
            action.setCallback(this,function(response){          
                var state = response.getState();
                
                //FOR ACCOUNT LIST PART DROPDOWN
                
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    var setEvent = component.getEvent("setAttribute");
                    setEvent.setParams({"successValue":true});
                    setEvent.setParams({"reference":response.getReturnValue()});
                    setEvent.fire();
                    console.log(response.getReturnValue());
                    
                }else{
                    
                    //alert('yow');
                    console.log("Failed With state: " + state);
                    console.log("Returned:");
                    console.log(response.getReturnValue());
                }
            });  
            $A.enqueueAction(action); 
        }
        //End CSM-12551 Emandolado 9/13/2017
    }
})