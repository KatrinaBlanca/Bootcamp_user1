({
    
    ToggleSubmitPassword : function(component, event) {
        
        var oldPassword        = component.find("cmp_currentPass").get("v.value");
        var newPassword        = component.find("cmp_newPass").get("v.value");
        var verifyNewPassword  = component.find("cmp_confirmNewPass").get("v.value");
        var sPageURL           = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        var sURLVariables      = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        var isValid = true;
        //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^)
        //var specialChar = /[!#$%=_+<>-]/; //disable CSM-14670
        //var specialChar = /[!@#$%^&]/; //[!#$%=_+<>-]
        //END CSM-13945 JRances
      
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
        }
        var UserId = sParameterName[1];
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
        }
        
        //-------------------------------------------------------- VALIDATION ----------------------------------------------------------------- 
        //CHECKS IF FIELDS ARE BLANK
        if($A.util.isEmpty(oldPassword)){
            var errorHolder = component.find('old-pw-error');
            $A.util.removeClass(errorHolder, 'hideError');
            $A.util.addClass(errorHolder, 'old-pw-error');
            
            var errorHolder2 = component.find('old-pw-incorrect');
            $A.util.removeClass(errorHolder2, 'old-pw-incorrect');
            $A.util.addClass(errorHolder2, 'hideError');
            
            var errorHolder2 = component.find('old-pw-incorrectReuse');
            $A.util.removeClass(errorHolder2, 'old-pw-incorrectReuse');
            $A.util.addClass(errorHolder2, 'hideError');
        }
        
        if($A.util.isEmpty(newPassword)){
            var errorHolder = component.find('new-pw-error');
            $A.util.removeClass(errorHolder, 'hideError');
            $A.util.addClass(errorHolder, 'new-pw-error');
            isValid = false;
        }
        
        if($A.util.isEmpty(verifyNewPassword)){
            var errorHolder = component.find('cfm-pw-error');
            $A.util.removeClass(errorHolder, 'hideError');
            $A.util.addClass(errorHolder, 'cfm-pw-error');
            isValid = false;
        }
            
        //IF NEW PASSWORD AND VERIFY NEW PASSWORD ARE NOT EMPTY    
        if (!$A.util.isEmpty(newPassword) && !$A.util.isEmpty(verifyNewPassword)){

            if(newPassword != verifyNewPassword){
                //Show password unmatched error
                var errorHolder = component.find('pw-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'pw-error');
                
            } else {

                //Hide password unmatched error
                var errorHolder = component.find('pw-error');
                $A.util.addClass(errorHolder, 'hideError');
                $A.util.removeClass(errorHolder, 'pw-error');
            }	
        }
        
        
        if(!$A.util.isEmpty(newPassword)){

            //CHECK IF NEW PASSWORD FIELD MET THE REQUIREMENTS
            if(!newPassword.match("[A-Z]")){  
                var errorHolder = component.find('passReq-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'passReq-error');           
                isValid = false;
                //alert('X UP');
            }  else if(!newPassword.match("[a-z]")){
                var errorHolder = component.find('passReq-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'passReq-error');            
                isValid = false;                
                //alert('X LW');
            } else if(!newPassword.match("[0-9]")){
                var errorHolder = component.find('passReq-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'passReq-error');
                isValid = false;                
                //alert('X #');
        //START CSM-14670 11.24.2017 GGrandea - remove special characters from password pages
            /*} else if(!newPassword.match(specialChar)){
                var errorHolder = component.find('passReq-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'passReq-error');
                isValid = false;                
                //alert('X char');*/
        //END CSM-14670 11.24.2017 GGrandea
            }else if(newPassword.length <= 7){
                var errorHolder = component.find('passReq-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'passReq-error');
                isValid = false;                
                //alert('X length');
            } else { 
                var errorHolder = component.find('passReq-error');
                $A.util.addClass(errorHolder, 'hideError');
                $A.util.removeClass(errorHolder, 'passReq-error');
                isValid = true;
            }           
            return isValid; 
        }
    },
    

    ToggleNoUpperCase : function(component, event) {
        //------ Hide Checked Spec Char Icon ------
        var changeElement = component.find("up_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Show Unchecked Spec Char Icon ------
        var changeElement = component.find("up_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    
    ToggleYesUpperCase : function(component, event) {
        
        //------ Show Checked Spec Char Icon ------
        var changeElement = component.find("up_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        //------ Hide Unchecked Spec Char Icon ------
        var changeElement = component.find("up_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Hide Error Requirement Text ------
        var errorHolder = component.find('up-error');
        $A.util.addClass(errorHolder, 'slds-hide');
        $A.util.removeClass(errorHolder, 'upperError');
    },
    
    ToggleNoLowerCase : function(component, event) {
        
        //------ Hide Checked Spec Char Icon ------
        var changeElement = component.find("lw_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Show Unchecked Spec Char Icon ------
        var changeElement = component.find("lw_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    
    ToggleYesLowerCase : function(component, event) {
        
        //------ Show Checked Spec Char Icon ------
        var changeElement = component.find("lw_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        //------ Hide Unchecked Spec Char Icon ------
        var changeElement = component.find("lw_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Hide Error Requirement Text ------
        var errorHolder = component.find('lw-error');
        $A.util.addClass(errorHolder, 'slds-hide');
        $A.util.removeClass(errorHolder, 'lowerError');
        
    },
    
    ToggleNoNumber : function(component, event) {
        
        //------ Hide Checked Spec Char Icon ------
        var changeElement = component.find("num_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Show Unchecked Spec Char Icon ------
        var changeElement = component.find("num_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    
    ToggleYesNumber : function(component, event) {
        
        //------ Show Checked Spec Char Icon ------
        var changeElement = component.find("num_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');              
        
        //------ Hide Unchecked Spec Char Icon ------
        var changeElement = component.find("num_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Hide Error Requirement Text ------
        var errorHolder = component.find('num-error');
        $A.util.addClass(errorHolder, 'slds-hide');
        $A.util.removeClass(errorHolder, 'numError');
        
    },
    
    ToggleNoSpecChar : function(component, event) {
        
        //------ Hide Checked Spec Char Icon ------
        var changeElement = component.find("sp_check");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Show Unchecked Spec Char Icon ------
        var changeElement = component.find("sp_uncheck");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
    },
    
    ToggleYesSpecChar : function(component, event) {
        
        //------ Show Checked Spec Char Icon ------
        var changeElement = component.find("sp_check");
        $A.util.addClass(changeElement, 'slds-show');
        $A.util.removeClass(changeElement, 'slds-hide');
        
        //------ Hide Unchecked Spec Char Icon ------
        var changeElement = component.find("sp_uncheck");
        $A.util.addClass(changeElement, 'slds-hide');
        $A.util.removeClass(changeElement, 'slds-show');
        
        //------ Hide Error Requirement Text ------
        var errorHolder = component.find('spec-error');
        $A.util.addClass(errorHolder, 'slds-hide');
        $A.util.removeClass(errorHolder, 'specError');
        
    },
    
    validateInputHelper : function(component, event, helper) {
        
        var isValid     = true;
        //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^)
        //var specialChar = /[!#$%=_+<>-]/; //disable CSM-14670
        //var specialChar = /[!@#$%^&]/; //[!#$%=_+<>-] /[@!#$%=_+<>^&*-]/;
        //END CSM-13945 JRances
        
        var attributeValue = component.find("cmp_newPass").get("v.value");
        var attributeLength = attributeValue.length;
        
        //-------------------------------------------------------- VALIDATION ----------------------------------------------------------------- 
        if (!$A.util.isEmpty(attributeValue)){
            
            //alert('May laman');
            
            if(attributeLength <=7){//IF CHAR IS LESS THAN 8
                
                //SHOW ERROR MESSAGE FOR CHAR LIMIT
                var errorHolder = component.find('le-error');
                $A.util.removeClass(errorHolder, 'hideError');
                $A.util.addClass(errorHolder, 'le-error');
                //alert('show error char');
                
            } else {//IF CHAR IS MORE THAN 7
                
                //HIDING ERROR MESSAGE FOR CHAR LIMIT
                var errorHolder = component.find('le-error');
                $A.util.addClass(errorHolder, 'hideError');
                $A.util.removeClass(errorHolder, 'le-error'); 
                //alert('hide error char');
                
            }//END ELSE
            
            if(!attributeValue.match("[A-Z]")){
                
                isValid = false;
                
                helper.ToggleNoUpperCase(component, event);
                
                
            } else {
                
                isValid = true;
                
                helper.ToggleYesUpperCase(component, event);
                
            }
            
            //Checking for Lower Case Letter
            if(!attributeValue.match("[a-z]")){
                
                isValid = false;                
                
                helper.ToggleNoLowerCase(component, event);
                
                
            } else {
                
                isValid = true;
                
                helper.ToggleYesLowerCase(component, event);
                
            }
            
            //Checking for Numbers
            if(!attributeValue.match("[0-9]")){
                
                isValid = false;
                
                helper.ToggleNoNumber(component, event);
                
                
            } else {
                
                isValid = true;
                
                helper.ToggleYesNumber(component, event);
                
            }
            
        //START CSM-14670 11.24.2017 GGrandea - remove special characters from password pages
            //Checking for Special Character
            /*if(!attributeValue.match(specialChar)){
                
                isValid = false;
                
                helper.ToggleNoSpecChar(component, event);
                
                
            } else {
                
                isValid = true;
                
                helper.ToggleYesSpecChar(component, event);
                
            }*/
        //END CSM-14670 11.24.2017 GGrandea
            
        }else if ($A.util.isEmpty(attributeValue)){
            helper.ToggleNoUpperCase(component, event);
            helper.ToggleNoLowerCase(component, event);
            helper.ToggleNoNumber(component, event);
            helper.ToggleNoSpecChar(component, event);
            
            
        }
            
           
    },
    
    validateMatchHelper  : function(component, event, helper, target, source) {
        
        var attributeValue         = component.find("cmp_newPass").get("v.value");
        var attributeValue2        = component.find("cmp_confirmNewPass").get("v.value");
        
        var oldPassword            = component.find("cmp_currentPass");
        var oldPasswordValue       = oldPassword.get("v.value");
        
        var newPassword            = component.find("cmp_newPass");
        var newPasswordValue       = newPassword.get("v.value");
        
        var verifyNewPassword      = component.find("cmp_confirmNewPass");
        var verifyNewPasswordValue = verifyNewPassword.get("v.value");
        
        if(!$A.util.isEmpty(attributeValue) && !$A.util.isEmpty(attributeValue2) ){
            
            if(attributeValue == attributeValue2){
                
                var action = component.get("c.ChangePasswordController");
                action.setParams({"oldpassword":oldPasswordValue, "newPassword":newPasswordValue, "verifyNewPassword":verifyNewPasswordValue });
                
                action.setCallback(this,function(response){          
                    var state = response.getState();
                    var respVal = response.getReturnValue();    

                    console.log('@@State: ', state);
                    console.log('@@respVal: ', respVal);
                    
                    if(component.isValid() && (state === "SUCCESS") && (respVal === "SUCCESS")){
                        
                        var cmpTarget = component.find('division1');
                        var cmpTarget2 = component.find('division2');
                        
                        $A.util.addClass(cmpTarget, 'hideError');
                        $A.util.removeClass(cmpTarget2, 'slds-hide');
                        
                    }else if(component.isValid() && (state === "SUCCESS") && (respVal === "Error: Your old password is invalid.")){
                        
                        var errorHolder = component.find('old-pw-incorrect');
                        $A.util.removeClass(errorHolder, 'hideError');
                        $A.util.addClass(errorHolder, 'old-pw-incorrect');
                        
             		/* start CSM-14639 - JIntal - 113017 */
                   // }else if(component.isValid() && (state === "SUCCESS") && (respVal === "Error: Please set a password that you haven't used before.")){         
					}else if(component.isValid() && (state === "SUCCESS") && (respVal === "Error: You cannot reuse this old password.")){ 
                    /* end CSM-14639 - JIntal - 113017 */
                        
                        var errorHolder = component.find('old-pw-incorrectReuse');
                        $A.util.removeClass(errorHolder, 'hideError');
                        $A.util.addClass(errorHolder, 'old-pw-incorrectReuse');
                        
                        
                        
                    }else{
                       // Alert(response.getReturnValue); // CSM-13020 Melvin Corbes 10-02-17 
                    }
                    
                });  
                $A.enqueueAction(action);    
                
                
                
            } else if(attributeValue != attributeValue2){
                
                //------ Hide Error Requirement Text ------
                var errorHolder = component.find('ma-success');
                $A.util.addClass(errorHolder, 'slds-hide');
                $A.util.rempveClass(errorHolder, 'matchSuccess');
                
            } 
            
            
        } else if ($A.util.isEmpty(attributeValue) && !$A.util.isEmpty(attributeValue2)){
            
            //------ Hide Error Requirement Text ------
            var errorHolder = component.find('ma-success');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.rempveClass(errorHolder, 'matchSuccess');
            
        } else {
            
            //------ Hide Error Requirement Text ------
            var errorHolder = component.find('ma-success');
            $A.util.addClass(errorHolder, 'slds-hide');
            $A.util.rempveClass(errorHolder, 'matchSuccess');
        }
        
        
        //Alert('Mike');
    },
    
    
    
    clearErrorMessageCurrentPassHelper : function(component, event, helper) {
        
        var errorHolder = component.find('old-pw-error');
        $A.util.removeClass(errorHolder, 'old-pw-error');
        $A.util.addClass(errorHolder, 'hideError');
        
        var errorHolder2 = component.find('old-pw-incorrect');
        $A.util.removeClass(errorHolder2, 'old-pw-incorrect');
        $A.util.addClass(errorHolder2, 'hideError');
        
    },
    
    clearErrorMessageNewPassHelper : function(component, event, helper) {
        
        var errorHolder = component.find('new-pw-error');
        var errorHolder2 = component.find('passReq-error');
        
        $A.util.removeClass(errorHolder, 'new-pw-error');
        $A.util.addClass(errorHolder, 'hideError');
        
        $A.util.removeClass(errorHolder2, 'passReq-error');
        $A.util.addClass(errorHolder2, 'hideError');
        
    },
    
    clearErrorMessageCfmNewPassHelper : function(component, event, helper) {
        
        var errorHolder = component.find('cfm-pw-error');
        var errorHolder2 = component.find('pw-error');
        
        $A.util.removeClass(errorHolder, 'cfm-pw-error');
        $A.util.addClass(errorHolder, 'hideError');
        
        $A.util.removeClass(errorHolder2, 'pw-error');
        $A.util.addClass(errorHolder2, 'hideError');
        
    }
    
}
 
 })