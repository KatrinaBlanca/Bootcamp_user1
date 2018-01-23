({
	hideModal : function(component, event, helper) {
        component.set("v.getValue", false);
    },
    discardChange : function(component, event, helper) {
        /*CSM-14543 Corbes Melvin 11:43 AM 12/4/2017
        var isMove = component.get("v.getMoveApp");
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
        
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/splash';
        
        if(isMove == true) {
            pageUrl += '?' + startURL;
        }
        
        window.location.assign(pageUrl);
        
        */
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/splash"
        });
        urlEvent.fire();
        
       
    }
})