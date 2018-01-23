({
	checkIfConglomerateAccount : function(component, event) {
        console.log('checkIfConglomerateAccount');
       var account_id =  component.get("v.recordId");
       console.log('account_id'+account_id);
       var action = component.get("c.checkAccountIfConglomerate");
        action.setParams({"AccountId":account_id});
        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('checkIfConglomerateAccount state' + state +' and result '+result);
            
            if(state === "SUCCESS"){
                component.set('v.isConglomerate', result);
            }
            
        });  
        $A.enqueueAction(action);  
    },
   
     openModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-hide');
    },
    
       closeAccountSearchModalHelper : function(component, event, helper) {
		//Close account search modal
        helper.closeModalHelper(component, 'backGroundSectionId');
        helper.closeModalHelper(component, 'conglomerateDisplay');
    },
    
      closeModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },

    
})