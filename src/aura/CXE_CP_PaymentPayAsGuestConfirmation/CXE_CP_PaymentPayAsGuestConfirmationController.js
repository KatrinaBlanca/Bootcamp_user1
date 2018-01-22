({
    doInit: function(component, event, helper) {
        
        var currentURL = window.location.href;
        // Start CSM-15198  R3A JIntal 01/19/2018
        var value = currentURL.indexOf("mobile");
        if (value > 0) {
            //alert('isMobile' );
            var errorHolder = component.find('isMobile');
            $A.util.removeClass(errorHolder, 'Hideme');
            $A.util.addClass(errorHolder, 'isMobile');
        } else{
            //alert('isPortal');
            var errorHolder = component.find('isPortal');
            $A.util.removeClass(errorHolder, 'Hideme');
            $A.util.addClass(errorHolder, 'isPortal');
        }
      
        // End CSM-15198 R3A JIntal 01/19/2018
        
        if(!currentURL.indexOf("payasguest") > -1 ){
            var getLogo =  component.find('logoShow');
            var getBackground = component.find('payBackground');

            component.set('v.PayAsGuest' , false);
            //document.getElementById("logoShow").addClass("class");
            $A.util.addClass(getLogo, 'slds-hide');
            $A.util.addClass(getBackground, 'background-none');
        }else{
            var getBackground = component.find('payBackground');
            $A.util.addClass(getBackground, 'pay-pageBackground');
        }
        
        var query = helper.url_param();
        query.totalAmt = query.totalAmt || 'none';
        query.refNum = query.refNum || 'none';
        query.feeAmt = query.feeAmt || 'none';
        query.status = query.status || 'none';
        
        if(query.status =="success"){
            var totalAmountForMeralco;
            totalAmountForMeralco = parseFloat(query.totalAmt) - parseFloat(query.feeAmt);
            component.set('v.payAsGuestReference',query.refNum);
            component.set('v.totalAmountToPay' , totalAmountForMeralco);
            component.set('v.convenienceFee' , query.feeAmt);
            component.set('v.totalAmountForSettlement' ,query.totalAmt);
        }
        
    },
    
    goToDashboard:function(component,event){
        var currentURL = window.location.href;
        
        if(!currentURL.indexOf("payasguest") > -1 ){
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/' 
            + location.pathname.split('/')[2] + '/dashboard';
            window.location.assign(pageUrl);
        }else{
            window.location.href = "http://www.meralco.com.ph/";
        }
    },
    goToRegister:function(component,event){
        
        // Start CSM-14739 Von Pernicia
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/' 
            + location.pathname.split('/')[2] + '/splash';
            
        
        window.location.href = pageUrl;
        // End CSM-14739 Von Pernicia
    }
})