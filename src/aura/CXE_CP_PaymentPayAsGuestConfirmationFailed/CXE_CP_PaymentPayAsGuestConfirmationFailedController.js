({
    doInit: function(component, event, helper) {

        var currentURL = document.URL;

        if(!currentURL.indexOf("payasguest") > -1 ){

            var getLogo =  component.find('logoShow');
            //document.getElementById("logoShow").addClass("class");
            $A.util.addClass(getLogo, 'slds-hide');
            component.set('v.PayAsGuest' , false);
            component.set("v.isPayAsGuest" , true);
            
        }if (navigator.userAgent.indexOf('Edge') >= 0){
            var currentURL = '';
        }
    },
    
    goToMainPage: function(component, event){
        var isPayAsGuest = component.get("v.isPayAsGuest");

        if (navigator.userAgent.indexOf('Edge') >= 0){
            
           var currentUrl = window.parent.document.URL;
           var splitUrl = currentUrl.split('/');

           var protocol = splitUrl[0];
           var hostname = splitUrl[2];
           var pathname1 = splitUrl[3];
           var pathname2 = splitUrl[4];

        	console.log('hostname: '+hostname);

            if(isPayAsGuest == true){
                window.location = protocol + '//' + hostname + '/'
                + pathname1 + '/' 
                + pathname2 + '/payasguest';
                
            }else{
                window.location = protocol + '//' + hostname + '/'
                + pathname1 + '/' 
                + pathname2 + '/mybills';
            }
            
        }else{
            var currentURL = window.location.href;
            console.log('currentURL: '+currentURL);
            
            if(!currentURL.indexOf("payasguest") == -1 ){
                var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/mybills';
                window.location.assign(pageUrl);
            }else{
                var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/payasguest';
                window.location.assign(pageUrl);
            }
            
        }
    }
    
    
})