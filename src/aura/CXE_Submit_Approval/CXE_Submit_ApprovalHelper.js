({
   /* Description: Show Comment Modal
     * Parameters: Element Id
     * Author: Jerson Poblete
     * Date Created: MAR-20-17
     */
    displayCommentModal : function(component, event, helper) {
        component.set("v.comments", null);
    },
    /* Description: Show Modal
     * Parameters: Element Id
     * Author: Jerson Poblete
     * Date Created: MAR-20-17
     */
    openModalHelper : function(component, elementId) {
        //Show modal
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-hide');
    },
    /* Description: Close Modal
     * Parameters: Element Id
     * Author: Jerson Poblete
     * Date Created: MAR-20-17
     */
    closeModalHelper : function(component, elementId) {
        //Hide modal
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },
    //START RReyes - 05/17/2017 - added logic for status checking
    submitApprovalOnCase : function(component, event, helper) {    
		var action = component.get("c.getCaseDetails");
        action.setParams({"caseId": component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS')
            {
                var caseRec = response.getReturnValue();
                 if(caseRec.GSL4_Check__c && 
                   (caseRec.Status == 'Pending Energization' || 
                    caseRec.Status == 'Energized' || 
                    caseRec.Status == 'Billed' ||
                    caseRec.Status == 'Application Closed'))
                 {
                 	var toastEvent = $A.get("e.force:showToast");
                	toastEvent.setParams({"title": "Unable to Submit Case for Approval",
                                          "message": "Cases with status 'Pending Energization', 'Energized', 'Billed', or 'Application Closed' cannot be submitted for approval.",
                                          "type": "info"
                            });
                	toastEvent.fire();
                 }else{
                     //displaySubmitApprovalModal
                     helper.openModalHelper(component, 'setCommentDiv')
                     helper.displayCommentModal(component, event, helper);
		         } 
            }
            else 
            {
                var errors = response.getError();
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
    }
    //END RReyes - 05/17/2017
})