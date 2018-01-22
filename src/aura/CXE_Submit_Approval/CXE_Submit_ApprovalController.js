({
    /* Description: Submit for Approval
     * Parameters: None
     * Author: Jerson Poblete
     * Date Created: MAR-20-17
     */
	submitApprovalController : function(component, event, helper) {
        console.log('!: '+component.get("v.comments")+', '+component.get("v.recordId"));
        var action = component.get("c.submitApproval");
        action.setParams({"caseId": component.get("v.recordId"),
                         "comments": component.get("v.comments")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                 if(response.getReturnValue() == 'Success')
                 {
                 	var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({"title": "Approval Submitted",
                                                  "message": "Case submitted for approval",
                                                  "type": "info"
                            });
                	toastEvent.fire();
                 }else{
                     console.log('error:' + response.getReturnValue());
		            	//Display toast if error occurred
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({"title": "Error!",
                                           "message": "Case cannot be submitted for approval. Make sure that you have the right to submit for approval or entry criteria is met for the request.",
                                           "type": "error"
                                          });
                     toastEvent.fire();
		          }
                
            }
            else 
            {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && 
                       errors[0].message){
                        
                        console.log('submit approval error: '+state+' '+errors[0].message);
                    }
                } else {
                    console.log('submit approval unknown error');
                }
                
                //Display toast if error occurred
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!",
                                      "message": "Error submitting approval.",
                                      "type": "error"
                                     });	
                toastEvent.fire();
            }
        });
		$A.enqueueAction(action);
        helper.closeModalHelper(component, 'setCommentDiv');
	},
    closeCommentModal : function(component, event, helper) {
      //Hide modal
        var modal = component.find("setCommentDiv"); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },
    //START RReyes - 05/17/2017 - added logic for checking if user has office and role
    checkUser : function(component, event, helper) {    
		var action = component.get("c.getUserDetails");
        //action.setParams({"caseId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var userRec = response.getReturnValue();
                 if((userRec.UserRoleId == '' || userRec.UserRoleId == null) || (userRec.Office__c == '' || userRec.Office__c == null))
                 {
                 	var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({"title": "Oops!",
                                          "message": "Submitter should have values on both Role and Office to determine the approver.",
                                          "type": "info"
                            });
                	toastEvent.fire();
                 }else{
                     //displaySubmitApprovalModal')
                     helper.submitApprovalOnCase(component, event, helper);
		         } 
            }
        });
		$A.enqueueAction(action);
    },
    //END RReyes - 05/17/2017


    /* Description: Submit for Approval
     * Parameters: None
     * Author: Jerson Poblete
     * Date Created: MAR-20-17
     */
    submitApprovalControllerR2 : function(component, event, helper) {
        console.log('!: '+component.get("v.comments")+', '+component.get("v.recordId"));
        var action = component.get("c.submitApprovalR2");
        action.setParams({"caseId": component.get("v.recordId"),
                         "comments": component.get("v.comments")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                 if(response.getReturnValue() == 'Success')
                 {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Approval Submitted",
                                                  "message": "Case submitted for approval",
                                                  "type": "info"
                            });
                    toastEvent.fire();
                 }else{
                     console.log('error:' + response.getReturnValue());
                        //Display toast if error occurred
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({"title": "Error!",
                                           "message": "Case cannot be submitted for approval. Make sure that you have the right to submit for approval or entry criteria is met for the request.",
                                           "type": "error"
                                          });
                     toastEvent.fire();
                  }
                
            }
            else 
            {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && 
                       errors[0].message){
                        
                        console.log('submit approval error: '+state+' '+errors[0].message);
                    }
                } else {
                    console.log('submit approval unknown error');
                }
                
                //Display toast if error occurred
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!",
                                      "message": "Error submitting approval.",
                                      "type": "error"
                                     });    
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        helper.closeModalHelper(component, 'setCommentDiv');
    }

})