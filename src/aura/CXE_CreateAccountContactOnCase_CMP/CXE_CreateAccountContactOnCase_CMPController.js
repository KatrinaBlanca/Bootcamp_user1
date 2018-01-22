({
	//BEGIN Account methods ----------------------------------------------------
	doInit : function(component, event, helper) {
        component.set("v.myCaseId", component.get("v.recordId"));
    },
    
    relateAccount: function(component,event, helper){
      //CSM-1925
      component.find("createAccount").set("v.disabled", true);
      helper.getCase(component, event, helper);
    },
    
    getSelectedAcct: function(component,event, helper){
      helper.getSelectedAccount(component, event, helper);
    },
    
    saveSelectedAccount: function(component,event, helper){
      helper.saveSelectedAccount(component, event, helper);
    },
    
    hideModal : function(component, event, helper){
        helper.hideModal(component, event, helper);

        component.find("createAccount").set("v.disabled", false);
    },
    //END Account methods ------------------------------------------------------

    //BEGIN Contact Methods ----------------------------------------------------
    /* Description: Validate Case details before retrieving similar contacts or auto creating the Contact
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-15-17
     */
    validateCaseDetails : function(component, event, helper) {
        //CSM-1925
        component.find("createContactButton").set("v.disabled", true);
        helper.retrieveCase(component, event, helper);
    },
    
    /* Description: Close Contact list modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-08-17
     */
    closeModal : function(component, event, helper) {
        document.getElementById("backGroundSectionId").style.display = "none";
        document.getElementById("contactListDiv").style.display = "none";
    }, 

    /* Description: Assign selected Contact Id to attribute
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-14-17
     */
    selectedContact : function(component, event, helper) {
        var contactId = event.target;
        console.log('selectedContactId: '+contactId.value);
        component.set("v.selectedContactId", contactId.value);
    }, 

    /* Description: Update Case Contact on save
     * Parameters: Selected Contact Id
                   Case Id
     * Author: Michael Lasala
     * Date Created: FEB-14-17
     */
    updateContact : function(component, event, helper) {
        var contactId = component.get("v.selectedContactId");
        console.log('selectedContactId: '+contactId);

        if(contactId === undefined){
            
            //Display toast if Contact has not been selected
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "Oops!",
                                  "message": "Please select a Contact.",
                                  "type": "info"
            });
            toastEvent.fire();
            console.log('TOAST: Please select a contact.');
        } else {
            var action = component.get("c.updateSelectedContact");

            action.setParams({"newContactId": component.get("v.selectedContactId"), 
                              "caseId": component.get("v.recordId")});

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state == "SUCCESS"){
                    console.log('Updated Contact: '+JSON.stringify(response.getReturnValue()));
                    
                    //Display toast on update of Contact
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Success!",
                                          "message": "Contact has been updated.",
                                          "type": "success"
                    });
                    toastEvent.fire();
                    console.log('TOAST: Contact has been updated.');
                } else {
                    console.log('updateContact error: '+state);
                }
            });
            //Close modal
            document.getElementById("backGroundSectionId").style.display = "none";
            document.getElementById("contactListDiv").style.display = "none";
            
            $A.enqueueAction(action);

            //Refresh detail page to reflect updated Contact
            $A.get('e.force:refreshView').fire();
        }
    }
    //END Contact Methods ------------------------------------------------------
})