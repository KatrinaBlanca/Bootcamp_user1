({
	sendEmail : function(component, event, helper) {
        //START CSM-14906 12/21/2017 JRances - [R3A SQT] Error prompt of Reset password for Invalid Email Address and Unregistered Email Address is still under discussio
        //var errorMessageInvalidEmail = 'Please Enter a valid Email Address'; 
        //var errorMessageEnterEmail   = 'Please Enter Email Address';
        var errorMessageInvalidEmail = 'Please enter a valid email address.'; 
        var errorMessageEnterEmail   = 'Please enter email address.';
        //END CSM-14906
        var regExpEmailformat        = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        var isValidEmail             = true;   
        var emailField               = component.find("cmp_emailField");
        var emailFieldValue          = emailField.get("v.value");

        if($A.util.isEmpty(emailFieldValue)){  
            $A.util.addClass(emailField, 'slds-has-error');
            emailField.set("v.errors", [{message: errorMessageEnterEmail}]);
            isValidEmail = false;
        }else{
            if(!emailFieldValue.match(regExpEmailformat)){
                emailField.set("v.errors", [{message: errorMessageInvalidEmail}]);
                $A.util.removeClass(emailField, 'slds-has-error');
                isValidEmail = false;
            }else{
                isValidEmail = true;
            }
        }
        
        if(isValidEmail){
           
            var action = component.get("c.sendMailMethod");
            action.setParams({"eMail":emailFieldValue });
            
            action.setCallback(this,function(response){          
                var state = response.getState();
                
                console.log('component.isValid: >>>>>'+component.isValid());
                console.log('response.getReturnValue: >>>>>'+response.getReturnValue);
                console.log('state: >>>>>'+state);
                
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    console.log('Successful');
                    var cmpTarget = component.find('divSendEmail');
                    var cmpTarget2 = component.find('emailConfirm');
                    $A.util.addClass(cmpTarget, 'slds-hide');
                    $A.util.removeClass(cmpTarget2, 'slds-hide');
                }else{
                    console.log('Failed!');
                    console.log('response: >>>>>>>>>>>>'+response.getReturnValue());
                }
            });  
            $A.enqueueAction(action);    
            
        }
	}//END - sendEmail
})