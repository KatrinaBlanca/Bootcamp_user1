({
    //FOR BUTTON VALIDATION | IF ITS BLANK OR NOT
	submitAddressInfo : function(component, event, helper) {

        helper.checkFieldsError(component, event); 
	},
    
    //FOR SHOWING BILLING ADDRESS FIELD | THRU RADION BUTTON
    radioClick : function(component, event, helper) {
		
        helper.handleRadioClick(component, event); 
	},
    
    //FOR SERVICE ADDRESS BLUR FIELD VALIDATION --------------------------------------------------------------------------------------
    onBlurServHome : function(component, event, helper) {
    
    	helper.handleOnBlurServHome(component, event); 
    
	},
    //FOR BILLING ADDRESS BLUR FIELD VALIDATION --------------------------------------------------------------------------------------
    onBlurBillHome : function(component, event, helper) {
    
    	helper.handleOnBlurBillHome(component, event); 
    
	}
})