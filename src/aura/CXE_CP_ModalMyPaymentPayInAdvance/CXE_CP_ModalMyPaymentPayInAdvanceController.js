({
	hideModal : function(component, event, helper) {
		component.set("v.modalPopUpChild", null);
        //Start R2C CSM-14708 Von Pernicia 11-28-17
        component.find('accountSelected').set('v.value' , 'Select an Account Number');  
        component.find('sinSelected').set('v.value' , 'Select a Service ID Number');
        component.find('accountSelected').set('v.errors' , null);  
        component.find('sinSelected').set('v.errors' , null);  
        component.find('amount-to-pay').set('v.errors' ,null);  
        //End R2C CSM-14708 Von Pernicia 11-28-17    
	},

	doInit : function(component, event, helper) {
		helper.setPicklistOptions(component, event);
        //helper.initializeBillingDetails(component, event); //START/END CSM-10913 RReyes JUL-24-17
    },
    /*Start R2C CSM-14703 Von Pernicia: Comment-out*/
    /*changeAccount: function(component, event, helper) {
        //alert('here');
        component.find('sinSelected').set('v.value' , 'Select a Service ID Number');
    },
    changeSin: function(component, event, helper) {
        //alert('here1');
        component.find('accountSelected').set('v.value' , 'Select an Account Number');
        
    },*/
    /*End R2C CSM-14703 Von Pernicia: Comment-out*/
    nextButton : function(component, event, helper) {
        
        helper.nextButton(component, event);
    },
    /*Start R2C CSM-14703 Von Pernicia*/
    enableFieldAccount : function(component, event, helper) {
        
        component.set("v.serviceField", true);
        component.set("v.serviceRadio", false);
        component.set("v.accountField", false);
        component.set("v.accountRadio", true);
        component.find('sinSelected').set('v.value' , 'Select a Service ID Number');
    },
    enableFieldService : function(component, event, helper) {
        
        component.set("v.serviceField", false);
        component.set("v.serviceRadio", true);
        component.set("v.accountField", true);
        component.set("v.accountRadio", false);
        component.find('accountSelected').set('v.value' , 'Select an Account Number');
    }
    /*End R2C CSM-14703 Von Pernicia*/
})