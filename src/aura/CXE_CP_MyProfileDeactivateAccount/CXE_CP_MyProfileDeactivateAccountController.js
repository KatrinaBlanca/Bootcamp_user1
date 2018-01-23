({
    
    doInit: function(component, event, helper){
        
        var action = component.get("c.hasSinPaperLessBilling");
        //var action = component.get("c.isAccountPortalAccountDeactivated");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var isBillingModePaperLess = response.getReturnValue();
                
                //alert("From server: " + isBillingModePaperLess);
                
                if(isBillingModePaperLess ==true){
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/profile"
                    });
                    urlEvent.fire();
                    
                }else if(isBillingModePaperLess ==false) {
                    
                    
                    var showAfter = component.find("contentMain"); 
                    var action = component.get("c.getDeactivationReason");
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            
                            var reason =response.getReturnValue();
                            /*
                    console.log(reason.DifferentEmail);
                    console.log(reason.MoveOutAddress);
                    console.log(reason.NoActiveSin);
                    console.log(reason.NoLongerUse);
                    console.log(reason.PortalDifficult);
                    console.log(reason.PortalUnuseful);
                    console.log(reason.PrivacyConcerns);
                    console.log(reason.ReceivedManyEmails);
                    console.log(reason.RegCustmerNotAssctd);
                   */
                  
                    /* Start: CSM-12470
                     * Author: Melvin Corbes
                     * Date: 09-08-2017
                     */         
                    var arrayOfReason =[reason.DifferentEmail,reason.MoveOutAddress,
                                        reason.RegCustmerNotAssctd, reason.NoActiveSin,
                                        reason.PortalUnuseful,reason.PortalDifficult,
                                        reason.ReceivedManyEmails, reason.PrivacyConcerns,
                                        reason.NoLongerUse];
                                       
                    
                    // end of CSM-12470 : Melvin Corbes
                                                           
                    var arrayOfIds =["option1value","option2value","option3value","option4value","option5value",
                                     "option6value","option7value","option8value","option9value"];
                    
                    for (var i = 0; i < arrayOfIds.length; i++) {
                        document.getElementById(arrayOfIds[i]).innerHTML =arrayOfReason[i];
                        // alert(arrayOfIds[i]);
                        
                    }
                    
                    $A.util.removeClass(showAfter, 'slds-hide');
                    
                }
                 else if (state === "INCOMPLETE") {
                     
                 }
                     else if (state === "ERROR") {
                         var errors = response.getError();
                         if (errors) {
                             if (errors[0] && errors[0].message) {
                                 console.log("Error message: " + 
                                             errors[0].message);
                             }
                         } else {
                             console.log("Unknown error");
                         }
                     }
             });
                    
                    $A.enqueueAction(action);
                    
                    
                }                
            }
              else if (state === "INCOMPLETE") {
                  
              }
                  else if (state === "ERROR") {
                      var errors = response.getError();
                      if (errors) {
                          if (errors[0] && errors[0].message) {
                              console.log("Error message: " + 
                                          errors[0].message);
                          }
                      } else {
                          console.log("Unknown error");
                      }
                  }
          });
        
        
        $A.enqueueAction(action);
        
        
    },
    showRelatedLinks : function(component, event, helper) {
        
        var arrayOfIds =["option1","option2","option3","option4","option5","option6","option7","option8","option9"];
        var buttonClicked =0;
        var button;
        for (var i = 0; i < arrayOfIds.length; i++) {
            button = document.getElementById(arrayOfIds[i]).checked;
            if(button == true){
                buttonClicked =arrayOfIds[i]; 
                
                
            }
        }
        
        if(buttonClicked ==="option1"){
            console.log("1");
            var action = component.get("c.getDifferentEmail");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var reason =response.getReturnValue();
                    
                    var data=  component.set("v.EmailLink", reason); 
                    
                }
                else if (state === "INCOMPLETE") {
                    
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);
            
        }else if(buttonClicked ==="option2"){
            
            console.log("2");
            var action = component.get("c.getMoveAddress");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var reason =response.getReturnValue();
                    var data=  component.set("v.MoveOutAdd", reason); 
                    
                }
                else if (state === "INCOMPLETE") {
                    
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);
            
            
        }else if(buttonClicked ==="option7"){
            console.log("7");
            
            var action = component.get("c.getPrivacyConcerns");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var reason =response.getReturnValue();
                    var data=  component.set("v.PrivacyConcerns", reason); 
                    
                    
                }
                else if (state === "INCOMPLETE") {
                    
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);
            
            
            
        }else if(buttonClicked ==="option8"){
            console.log("8");
            
            var action = component.get("c.getReceiveManyNoti");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {        
                    var reason =response.getReturnValue();
                    var data=  component.set("v.ReceiveEmail", reason); 
                }
                else if (state === "INCOMPLETE") {
                    
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);
            
            
            
        }
        
        
        
        
    },
    
    myAction : function(component, event, helper) {
        
        var arrayOfIds =["option1","option2","option3","option4","option5",
                         "option6","option7","option8","option9","option10"];
        var buttonClicked =0;
        var articleRelated;
        for (var i = 0; i < arrayOfIds.length; i++) {
            var button = document.getElementById(arrayOfIds[i]).checked;
            if(button == true){
                buttonClicked =arrayOfIds[i];
            }
        }
        
        
        var erroNote = component.find("notify_error");
        if( buttonClicked == 0){
            //$A.util.removeClass(erroNote, 'slds-hide');   
            //IPenaflor 10/18/17 CSM-13818
            helper.submit(component, event, helper);
        }else{
            $A.util.addClass(erroNote, 'slds-hide');
            if( buttonClicked =="option10"){
                var data = document.getElementById(buttonClicked+"value").value
                //alert('the data: '+ data);
                if(data < 1){
                    //alert('the data if: '+ data);
                    buttonClicked =0;
                    $A.util.removeClass(erroNote, 'slds-hide');
                    articleRelated= null;
                }
                articleRelated =data
                
            }else{
                var text= document.getElementById(buttonClicked+"value").innerHTML;
                articleRelated =text;
            }
        }
        
        if(buttonClicked != 0){
            //proceed  to the action callback
            var action = component.get("c.PortalAccountDeactivated");
            action.setParams({ relatedArticle : articleRelated});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var serverStatus = response.getReturnValue();    
                    if(serverStatus =="successfull"){
                        // alert('good' +serverStatus);
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/deactivatesuccess"
                        });
                        urlEvent.fire();
                        // alert('good' +serverStatus);
                    }else{
                        // alert('bad' +serverStatus);
                    }                
                }
                else if (state === "INCOMPLETE") {
                    
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);
        } 
        
    },
    navToProfile  : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/profile"
        });
        urlEvent.fire();
    }
}
 
 })