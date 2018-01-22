({
	submitContactInfo : function(component, event, helper) {	
        helper.checkFieldsError(component, event);
	},
    
    onBlurSin : function(component, event, helper) {		
        helper.checkOnBlurSin(component, event); 
	},
    
    onBlurFirstName : function(component, event, helper) {		
        helper.checkOnBlurFirstName(component, event); 
	},
    
    onBlurLastName : function(component, event, helper) {		
        helper.checkOnBlurLastName(component, event); 
	},
    
    onBlurEmail : function(component, event, helper) {		
        helper.checkOnBlurEmail(component, event); 
	},
    
    onBlurMobile : function(component, event, helper) {		
        helper.checkOnBlurMobile(component, event); 
	},
    
    onBlurBirthday : function(component, event, helper) {		
        helper.checkOnBlurBirthday(component, event); 
	},  
    
    onBlurLandline : function(component, event, helper) {		
        helper.checkOnBlurLandline(component, event); 
	},

    radioClick : function(component, event, helper) {	
        
        helper.handleRadioClick(component, event);
        
	},
    
    onBlurRelFirstName : function(component, event, helper) {		
        helper.checkOnBlurRelFirstName(component, event); 
	},
    
    onBlurRelLastName : function(component, event, helper) {		
        helper.checkOnBlurRelLastName(component, event); 
	},
    
    onBlurRelEmail : function(component, event, helper) {		
        helper.checkOnBlurRelEmail(component, event); 
	},
    
    onBlurRelMobile : function(component, event, helper) {		
        helper.checkOnBlurRelMobile(component, event); 
	},
    
    onBlurRelRelationship : function(component, event, helper) {		
        helper.checkOnBlurRelRelationship(component, event); 
	}
    
})