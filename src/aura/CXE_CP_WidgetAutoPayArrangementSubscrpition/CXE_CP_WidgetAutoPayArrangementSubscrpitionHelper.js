({
    ////Start CSM-13084 of Rabayon 10/05/17
	  goToAutopayenroll : function(component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/'
        + location.pathname.split('/')[2] + '/autopayenroll';
        window.location.assign(pageUrl);
    }
    ////End CSM-13084 of Rabayon 10/05/17
})