({
    goToHome : function (component, event, helper){
        var home = window.location.protocol + '//' + window.location.hostname + '/'
        					 + location.pathname.split('/')[1] + '/' 
        					 + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(home);     
    }
})