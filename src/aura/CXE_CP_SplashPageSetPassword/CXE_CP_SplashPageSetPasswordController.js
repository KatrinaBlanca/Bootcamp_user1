({
    
    validateInput : function(component, event, helper) {
    	
        
        //DECLARATION OF VARIABLES NEEDED
        var isValid = true;
        var up_isValid = false;
        var lw_isValid = false;
        var num_isValid = false;
        var sp_isValid = false;
        var specialChar = /[^a-zA-Z0-9]/;
        
        var attributeValue = component.find("cp_initpass").get("v.value");
       	//console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>> attributeValue: ' + attributeValue);
        var attributeLength = attributeValue.length;

        console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>>> attributeValue: " + attributeValue);
		
        //CHECKING IF THE PASSWORD IS LESS THAN 8 CHAR
        if(attributeLength <= 7){
            
            isValid = false;
            
            //SHOW ERROR MESSAGE FOR CHAR LIMIT
            var errorHolder = component.find('le-error');
            $A.util.removeClass(errorHolder, 'lengthError');
            $A.util.addClass(errorHolder, 'le-error');
            
        } else {//CHECKING IF THE PASSWORD IS GREATER THAN 8 CHAR
            
            //HIDING ERROR MESSAGE FOR CHAR LIMIT
            var errorHolder = component.find('le-error');
            $A.util.addClass(errorHolder, 'lengthError');
            $A.util.removeClass(errorHolder, 'le-error');
            
            //CHECK IF IT DOES NOT HAVE AT LEAST ONE UPPER CASE LETTER
            if(!attributeValue.match("[A-Z]")){
                
                console.log("Mali upper case");
                isValid = false;
                up_isValid= false;

                //HIDE CHECK ICON
                var changeElement = component.find("up_check");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                
                //SHOW UNCHECK ICON
                var changeElement = component.find("up_uncheck");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');

                
            } else {//GOES HERE IF IT DOES HAVE AT LEAST ONE UPPER CASE LETTER
                
                console.log("TAMA upper case");
                isValid = true;
                up_isValid = true;
                
                
                //SHOW CHECK ICON
                var changeElement = component.find("up_check");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                //$A.util.toggleClass(changeElement, "slds-show");
                
                //HIDE UNCHECK ICON
                var changeElement = component.find("up_uncheck");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                //$A.util.toggleClass(changeElement, "slds-hide");
           		
            }
            
            //Checking for Lower Case Letter
            if(!attributeValue.match("[a-z]")){
                
                console.log("Mali lower case");
                isValid = false;                
                lw_isValid= false;
                
                //HIDE CHECK ICON
                var changeElement = component.find("lw_check");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                
                //SHOW UNCHECK ICON
                var changeElement = component.find("lw_uncheck");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                
                
            } else {
                
                console.log("TAMA lower case");
                isValid = true;
                lw_isValid = true;
                
                //SHOW CHECK ICON
                var changeElement = component.find("lw_check");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                //$A.util.toggleClass(changeElement, "slds-show");
                
                //HIDE UNCHECK ICON
                var changeElement = component.find("lw_uncheck");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                //$A.util.toggleClass(changeElement, "slds-hide");
                
            }
            
            //Checking for Numbers
            if(!attributeValue.match("[0-9]")){
                
                console.log("Mali number");
                isValid = false;
                num_isValid= false;
                
                //HIDE CHECK ICON
                var changeElement = component.find("num_check");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                
                //SHOW UNCHECK ICON
                var changeElement = component.find("num_uncheck");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                
            } else {
                
                console.log("TAMA number");
                isValid = true;
                num_isValid = true;
                
                //SHOW CHECK ICON
                var changeElement = component.find("num_check");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                //$A.util.toggleClass(changeElement, "slds-show");
                
                //HIDE UNCHECK ICON
                var changeElement = component.find("num_uncheck");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                //$A.util.toggleClass(changeElement, "slds-hide");
                
            }
            
            //Checking for Special Character
            if(!attributeValue.match(specialChar)){
                console.log("Mali SpecChar");
                isValid = false;
                sp_isValid= false;
                
                //HIDE CHECK ICON
                var changeElement = component.find("sp_check");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                
                //SHOW UNCHECK ICON
                var changeElement = component.find("sp_uncheck");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                
            } else {
                
                console.log("TAMA spec char");
                isValid = true;
                sp_isValid = true;
                
                //SHOW CHECK ICON
                var changeElement = component.find("sp_check");
                $A.util.addClass(changeElement, 'slds-show');
                $A.util.removeClass(changeElement, 'slds-hide');
                //$A.util.toggleClass(changeElement, "slds-show");
                
                //HIDE UNCHECK ICON
                var changeElement = component.find("sp_uncheck");
                $A.util.addClass(changeElement, 'slds-hide');
                $A.util.removeClass(changeElement, 'slds-show');
                //$A.util.toggleClass(changeElement, "slds-hide");
                
            }//ELSE END
            
 
        }//END ELSE
        
    },//END VALIDATE INPUT
    
    submitPassword  : function(component, event, helper) {
		
        helper.ToggleSubmitPassword(component, event);

    },
    
    clearField  : function(component, event, helper) {
		
        var attributeValue = component.find("cp_initpass").get("v.value");
        

    }
})