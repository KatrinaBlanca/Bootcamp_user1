({
/**
* Method to toggle the modal
**/     
	toggleVisibility : function(component) {
        alert('modal helper');
        var modal = component.find("sldsModal");
        $A.util.toggleClass(modal, "slds-fade-in-open");
        var modalBackdrop = component.find("sldsModalBackdrop");
        $A.util.toggleClass(modalBackdrop, "slds-modal-backdrop--open");
         alert('modal helper2');
	}
})