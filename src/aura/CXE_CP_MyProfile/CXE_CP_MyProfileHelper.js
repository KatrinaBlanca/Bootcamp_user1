({
    editInfoHelper : function() {
        
        
        
    },
    
    // START Breadcrumb-task RBellalba SEPT-25-17
    goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    
    goToProfile : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/profile';
        window.location.assign(pageUrl);
    },
    // END Breadcrumb-task RBellalba SEPT-25-17
    // 

    

    // START CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    getParam : function (component, event, helper){
        var sURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sURL.split("&");
        var sParamNameAndValue, sParameterName, i, sParameterValue;

        for (i = 0; i < sURLVariables.length; i++) {    
            sParamNameAndValue = sURLVariables[i].split("=");
            sParameterName = sParamNameAndValue[0];
            if(sParameterName === "getInfo") {
                sParameterValue = sParamNameAndValue[1];
            }
        }

        if(sParameterValue || sParameterValue == "1") {            
            component.set("v.tabToShow","myProfileTab4"); 
            component.set("v.tabChecker", "myProfileTab4");    
            component.set("v.isInEditMode", true);       
        }     
    }
   // END CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    
    
})