({
	// submitContactInfo : function(component, event, helper) {
 //        helper.helperSubmitContactInfo(component, event);      
	// },
    
 //    onBlurSin : function(component, event, helper) {
 //        helper.handleOnBlurSin(component, event);      
	// },
 //    onBlurCompName : function(component, event, helper) {
 //        helper.handleOnBlurCompName(component, event);      
	// },
 //    onBlurEmail : function(component, event, helper) {
 //        helper.handleOnBlurEmail(component, event);      
	// },
 //    onBlurFirstName : function(component, event, helper) {
 //        helper.handleOnBlurFirstName(component, event);      
	// },
 //    onBlurLastName : function(component, event, helper) {
 //        helper.handleOnBlurLastName(component, event);      
	// },
 //    onBlurEmailAdd : function(component, event, helper) {
 //        helper.handleOnBlurEmailAdd(component, event);      
	// },
 //    onBlurMobile : function(component, event, helper) {
 //        helper.handleOnBlurMobile(component, event);      
	// },
 //     onBlurRelationship : function(component, event, helper) {
 //        helper.handleOnBlurRelationship(component, event);      
	// },
 //    submitContactInfo2 : function(component, event, helper) {
 //        helper.helperSubmitContactInfo2(component, event);      
	// },
    
    /////

    doPageValidation : function(component, event, helper) {   
        var hasError = helper.validate(component, event, helper);
        component.set("v.hasErrorOnPage", hasError);
    },

    onClickNext : function(component, event, helper) {   
        helper.displayTab2(component, event, helper);
    }
})