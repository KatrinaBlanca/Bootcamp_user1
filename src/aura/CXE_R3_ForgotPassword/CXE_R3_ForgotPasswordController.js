({
	sendEmailForgotPasswordThruEnter : function(component, event, helper) {
	    if (event.keyCode === 13) {
            console.log('Enter key is pressed. Proceed to sending email confirmation!');
            helper.sendEmail(component, event, helper);
        }
    },//END - sendEmailForgotPasswordThruEnter
    
    sendEmailForgotPassword : function(component, event, helper) {
        helper.sendEmail(component, event, helper);
    },//END - sendEmailForgotPassword
    
    cancelForgotPassword : function(component, event, helper) {
        /*<!-- start CSM-14845 - JIntal [12/11/17] -->*/
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/CXE_splashMeralcoMobile';
        
        window.location.assign(pageUrl);
		/*
        var returnValue = confirm('Cancel password reset?'); //Displays a pop-up message, value is TRUE or FALSE
        
        var isMove = component.get("v.isMoveApp");

        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        var sParameterName;
        var i;
        var startURL;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            
            if(sParameterName[0]=='startURL'){
                startURL = sURLVariables[i];
            }
        }
        console.log('isMoveApp ' + isMove);
        console.log('returnValue ' + returnValue);
        console.log('startURL ' + startURL);
        
        if(returnValue == true){
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/CXE_splashMeralcoMobile';
            
            if(isMove == true) {
                pageUrl += '?' + startURL;
            }
            window.location.assign(pageUrl);
        } */
        
        /*<!-- end CSM-14845 - JIntal [12/11/17] -->*/
    }//END - cancelForgotPassword
    
})