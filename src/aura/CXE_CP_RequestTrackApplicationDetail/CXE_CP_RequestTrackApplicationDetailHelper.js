({
    //START Breadcrumb-task GSerrano SEPT-25-17
    goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    goToRequests : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/trackapp';
        window.location.assign(pageUrl);
    }
    //END Breadcrumb-task GSerrano SEPT-25-17
})