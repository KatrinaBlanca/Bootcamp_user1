({
    
    doInit : function(component, event, helper) {
        
          
        function getQueryParam(param) {
            var result =  window.location.search.match(
                new RegExp("(\\?|&)" + param + "(\\[\\])?=([^&]*)")
            );
            
            return result ? result[3] : false;
        }
        
        component.set("v.LabelIndicator", getQueryParam("action"));
        //START CSM-13900 GGrandea 10.13.2017
        component.set("v.user_id", getQueryParam("id"));
        component.set("v.guid", getQueryParam("guid")); // CSM-14898 LISEN

        helper.verifyPortalUserId(component, event);
        //END CSM-13900
		
    },

    onBlurInitPass : function(component, event, helper) {
        var p1 = component.find("cp_initpass").get("v.value");
        
        var string = p1;
        //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^)
        var re = new RegExp("[!#$%=_+<>-]");
        //var re = new RegExp("[!@#$%^&]");
        //END CSM-13945 JRances
        if (re.test(string)) {
            console.log("Valid");
        } else {
            console.log("Invalid");
        }
        
        if(!p1.match("[A-Z]")){                
			helper.uncheckUP(component, event);
        } else {
            helper.checkUP(component, event);
        }
        if(!p1.match("[a-z]")){                    
            helper.uncheckLW(component, event);
        } else{
            helper.checkLW(component, event);
        } 
        if(!p1.match("[0-9]")){       
            helper.uncheckNum(component, event);
        } else {
            helper.checkNum(component, event);
        }
        //START CSM-14670 11.24.2017 GGrandea remove special characters from password pages
        //START CSM-13945 JRances / UAT, Include in Special Character for 'Change Password', (!@#$%&^)
        /*if(!p1.match("[!#$%=_+<>-]")){     //(!p1.match("[!#$%=_+<>-]")) "[!@#$%^&*]"
			helper.uncheckChar(component, event);
        } else {
            helper.checkChar(component, event);
        }*/
        //END CSM-13945 JRances
        //END CSM-14670 11.24.2017 GGrandea
    },
    
    clearAllErrorMsgs : function(component, event, helper) {
        helper.helperClearAllErrorMsgs(component, event, helper);
    },
    
    resetPassword : function(component, event, helper) {
        helper.helperResetPassword(component, event, helper);
    },
    
    //[20170915 - Joebhelle Rances]
    //Adding code for Enter function - send email
    //CSM 12590 - set password
    pressEnter : function(component, event, helper) {
        if (event.keyCode === 13) {
            console.log('Enter key is pressed.');
            helper.helperResetPassword(component, event, helper);
        }
    }
    //End CSM 12590
})