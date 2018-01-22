({
    sendPasswordReset : function(component, event, helper) {
		console.log('Send password reset email.');
        
        //START CSM-14906 12/19/2017 JRances - Error prompt of Reset password for Invalid Email Address and Unregistered Email Address is still under discussion
        var errorMessageInvalidEmail = 'Please enter a valid email address.'; 
        var errorMessageEnterEmail   = 'Please enter email address.';
        //var errorMessageInvalidEmail = 'Please Enter a valid Email Address'; 
        //var errorMessageEnterEmail   = 'Please Enter Email Address';
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
        
        console.log('Is email valid?: '+isValidEmail);
        
        if(isValidEmail){
            var action = component.get("c.sendMailMethod");
            action.setParams({"eMail":emailFieldValue });
            
            action.setCallback(this,function(response){          
                var state = response.getState();
                
                console.log('component.isValid: >>>>>'+component.isValid());
                console.log('response.getReturnValue: >>>>>'+response.getReturnValue);
                console.log('state: >>>>>'+state);
                
                if(component.isValid() && (state === "SUCCESS") && response.getReturnValue != null){
                    console.log('success');
                    var cmpTarget = component.find('divSendEmail');
                    var cmpTarget2 = component.find('emailConfirm');
                    
                    $A.util.addClass(cmpTarget, 'slds-hide');
                    $A.util.removeClass(cmpTarget2, 'slds-hide');
                    
                }else{
                    console.log('response: >>>>>>>>>>>>'+response.getReturnValue());
                }
            });  
            $A.enqueueAction(action);    
        }
    },
    
    
    cancelPasswordReset : function(component, event, helper) {
        // START OF CSM-14543 12/01/2017 Corbes Melvin
        component.set("v.showCancelModal", true);
        
        /*comment out CSM-14543
        var returnValue = confirm('Cancel password reset?');
        
        var isMove = component.get("v.isMoveApp");
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //get whole URL of the page
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        var startURL;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.

            if(sParameterName[0]=='startURL'){
                startURL = sURLVariables[i];
            }
        }
        console.log('isMoveApp ' + isMove);
        console.log('returnValue ' + returnValue);
        console.log('startURL ' + startURL);
        if(returnValue == true){
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/' 
            + location.pathname.split('/')[2] + '/splash';
            
            if(isMove == true) {
                pageUrl += '?' + startURL;
            }
            
            window.location.assign(pageUrl);
        }
    }
    End OF CSM-14543 12/01/2017 Corbes Melvin*/
}
 
 })