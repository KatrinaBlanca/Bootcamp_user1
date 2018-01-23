({
    doInit : function(component, event, helper) {
        helper.checkIfConglomerateAccount(component, event);
    },
    
	displayViewConglomerateModal : function(component, event, helper) {
        var account_id =  component.get("v.recordId");
      	console.log('displayViewConglomerateModal '+account_id);
    	helper.openModalHelper(component, 'backGroundSectionId');
    	helper.openModalHelper(component, 'conglomerateDisplay');
	},
    
    closeViewConglomerate : function(component, event, helper) {
     	helper.closeAccountSearchModalHelper(component, event, helper);
    },
    
})