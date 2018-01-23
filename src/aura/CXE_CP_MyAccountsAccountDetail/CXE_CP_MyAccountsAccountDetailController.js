({	
        
    onWithSinChange : function(component, event, helper) {
        var returnData =  event.getParam("value");
        if(returnData=="WithSin"){
            var SinForm = component.find('SinForm');
            $A.util.removeClass(SinForm, 'Hideme');
            
            //Rj --> Added code for showing UnEnroll btn if there is a sin selected
            var unEnrollBtn = component.find('unEnrollBtn');
            $A.util.removeClass(unEnrollBtn, 'Hideme');
            
        }
    },
    
    GoBack : function(component, event, helper) {
        var SinForm = component.find('SinForm');
        $A.util.addClass(SinForm, 'Hideme');
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":'Fire'});
        setEvent.fire()
    },
    
    unEnrollService : function(component, event, helper) {
		//START R2C CSM-14840 Shayne 12/08/2017 modal for conglo user
		if(component.get("v.isConglomerate")){
			var message= $A.get("$Label.c.CONGLOMERATE_ERROR_PAGE");
			component.set('v.congloMessage', message);
			component.set('v.isCongloModal', true);
		}else{
        var action = component.get("c.checkSinToDelete");
        
        var sinAccount = component.get("v.dataReceived.AccountNumber");
        var sinToUnEnroll = component.get("v.dataReceived.SIN");
        action.setParams({ "myAccount" : sinAccount,
                          "mySin" : sinToUnEnroll
                         });
        
        action.setCallback(this,function(response){          
            var state = response.getState();

            if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                //alert(response.getReturnValue());
                
                if(response.getReturnValue()=='PAPERLESS'){

                    component.set("v.showSINPaperlessModal", true);
                    
                } else if(response.getReturnValue()=='PAYOR'){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({                        
                        "type": "error",
                        //Start R2C CSM-14986 Von Pernicia
                        //"message": "You can't unenroll this service. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance", // CSM-14039 LISEN : update error message
                        "message": "This request is not available through Meralco Online. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.",
                        //End R2C CSM-14986 Von Pernicia
                        "duration": 6000 //CSM-14489 11.16.2017 adding 6 seconds duration
                    });
                    toastEvent.fire();
                    
                } else if(response.getReturnValue()=='SUCCESS'){
                    
                    component.set("v.showUnenrollmentSuccessfulModal", true);
                   
                }
                
            }else{
                
                //alert('Sorry, failed!');
                console.log("Failed With state: " + state);
                console.log("Returned:");
                console.log(response.getReturnValue());
            }
        });  
        $A.enqueueAction(action); 
         }
	    //END R2C CSM-14840 Shayne 12/08/2017

    }
})