({
/**
* Method to close the modal
**/    
    defaultCloseAction : function(component, event, helper) {
        $A.util.addClass(component, "slds-hide");
    },
/**
* Method to open the modal
**/     
    openModal : function(component, event, helper) {
        //alert('modal controller');
        //helper.toggleVisibility(component);
        $A.util.removeClass(component, "slds-hide");
    },
/**
* Method to close the modal
**/     
    closeModal : function(component, event, helper) {
       // helper.toggleVisibility(component);
         $A.util.addClass(component, "slds-hide");
    },
})