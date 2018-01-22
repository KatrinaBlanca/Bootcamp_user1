({
    //START CSM-13781 JRances - Internet Explorer - System validates that the fields in login page are empty though they were not
    passPasswordValue : function(component, event, helper) {
        
    },
    pressEnter : function(component, event, helper) {
        
        var loginEmail = component.find("input_email");
        var loginEmailValue = loginEmail.get("v.value");
        var loginPass = component.find("input_password");
        var loginPassValue = loginPass.get("v.value");

        var key = event.keyCode;
        if (key == 13) {
            console.log("Email: >>>>>>"+loginEmailValue);
            console.log("Password: >>>>>>"+loginPassValue);
            helper.submitForm(component);
        }
        
    },
    //END CSM-13781 JRances
    
    submitForm : function(component, event, helper) {
        helper.setCookie(component);
        helper.submitForm(component);
    },
    
    forgotPassLink: function(component, event, helper) {
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
        
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/forgotpass';
        
        if(isMove == true) {
            pageUrl += '?' + startURL;
        }
        
        console.log('isMove ' + isMove);
        console.log('sPageURL ' + sPageURL);
        console.log('pageUrl ' + pageUrl);
        window.location.assign(pageUrl);
    },

    signInThruFacebook  : function (component, event, helper){
        var fbLinking;
        var fbLink;
        var community = '?community=';
        
        var url = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/dashboard';
        
        var action = component.get("c.getFbLink");
        
        action.setCallback(this, function(response){
            
            if(response.getState() == 'SUCCESS'){
                fbLink = response.getReturnValue();
            }
            fbLinking = fbLink+community+url;
            var startURL = helper.getStartURL(component);
            //Retain the startURL parameter
            if(startURL != null)
                fbLinking += '&startURL='+startURL;
            window.location.assign(fbLinking);
            
        });
        $A.enqueueAction(action);
    },

    signInThruGoogle  : function (component, event, helper){
        
        var googleLinking;
        var googleLink;
        var community = '?community=';
        var url = window.location.protocol + '//' + window.location.hostname + '/'
                                 + location.pathname.split('/')[1] + '/' 
                                 + location.pathname.split('/')[2] + '/dashboard';
        
        var action = component.get("c.getGoogleLink");
        
        action.setCallback(this, function(response){
            
            if(response.getState() == 'SUCCESS'){
                googleLink = response.getReturnValue();
            }
            googleLinking = googleLink+community+url;
            //Retain the startURL parameter
            var startURL = helper.getStartURL(component);
            if(startURL != null)
                googleLinking += '&startURL='+startURL;
            window.location.assign(googleLinking);
            
        });
        
        $A.enqueueAction(action);
        
    },

    mobileReg: function(component, event, helper) {
        var pageUrl = 'mymeralcoapp://register';  
        window.location.assign(pageUrl);
        
    },
    
    //START CSM-13053 GGrandea 10.05.2017
    doInit : function(component, event, helper) {
        //START CSM-14664 JRances [R2B WARRANTY] - User is not redirected to the correct page.
        //START CSM-14200 JRances / UAT, Bills link from Marketing Cloud does not automatically direct to Viewbills
        var query = helper.url_param(); 

        query.page = query.page || ''; //set query.page to '' if it is undefined(null)
        
        console.log(navigator.userAgent);
        console.log(navigator.appName);
        console.log(location.pathname);
        
        helper.initializeForm(component);
        
        //if IE and has session, redirect to /login page
        if (location.pathname.search('/splash') >= 0 && 
                (navigator.userAgent.search('MSIE') >= 0 
                    || navigator.userAgent.search('Trident') >= 0
                    || navigator.userAgent.search('Edge') >= 0 ) 
            ){
        
                var action = component.get("c.checkUserSession");
                
                action.setCallback(this, function(response){
                    console.log(response.getState());
                    console.log(response.getReturnValue());
                    if(response.getState() == 'SUCCESS'){
                        if(response.getReturnValue() == 'WITH_SESSION'){
                            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                                            + location.pathname.split('/')[1] + '/'
                                            + location.pathname.split('/')[2] + '/dashboard';
                            window.location.assign(pageUrl);
                        }
                    }
                    
                });
                $A.enqueueAction(action);
        } else if (location.pathname.search('/splash') >= 0 && query.page != '' ){
            helper.goForRedirection(component, helper);    
        } 
        //END CSM-14200 JRances
        //END CSM-14664

    }
    //END CSM-13053 GGrandea 10.05.2017
})