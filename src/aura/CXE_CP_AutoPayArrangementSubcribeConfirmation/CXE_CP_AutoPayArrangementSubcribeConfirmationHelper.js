({
	//START CSM-13094 RReyes OCT-09-17
	goToMyAccounts : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    }
    //END CSM-13094 RReyes OCT-09-17
})