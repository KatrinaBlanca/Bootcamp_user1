({
    doInit : function(component, event, helper) {
        setTimeout(function(){ 
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'+ location.pathname.split('/')[1] + '/secur/logout.jsp'; 
        window.location.assign(pageUrl); 
		}, 3000); //CSM-OOOOO 12.18.2017 change 3,000 sec to 3sec

    } 
    
})