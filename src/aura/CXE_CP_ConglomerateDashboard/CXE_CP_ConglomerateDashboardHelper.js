({
	getAccountIdofCurrentUser : function(component, event) {
        
       console.log('getAccountIdofCurrentUser '+component.get("v.AccountId"));
        var action = component.get("c.getAccountIDofCurrentUser");
        
        action.setCallback(this,function(response){ 
            var setEvent = component.getEvent("setLoader");
            setEvent.setParams({"loader":'success'});
            setEvent.fire();
            
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('getAccountIdofCurrentUser state' + state +' and result '+result);
            
            if(state === "SUCCESS"){
                //component.set('v.conglomerateRecords', result.conglomerateRecords);
                //component.set('v.AccountName', result.accountName);
                component.set('v.AccountId', result);
            }
            
        console.log('getAccountIdofCurrentUser '+component.get("v.AccountId"));
        });  
        $A.enqueueAction(action); 
    },
    
    goToBills : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/mybills';
         window.location.assign(pageUrl);     
    },
    
    goToProfile : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/profile';
        window.location.assign(pageUrl);     
    },

    goToMyAccounts : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    },
    
    goToStartService : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/startservice';
        window.location.assign(pageUrl);
    },
    
    //START R2C CSM-14832 Shayne 12/07/2017
    hideInfoIncompleteNotif : function (component, event, helper){
        var action = component.get("c.getProfInfoModal");         
        action.setCallback(this,function(response){ 
         
            var resp = response.getReturnValue();
           if(resp == 'true'){
                var errorHolder = component.find('incProfNotif');
                $A.util.removeClass(errorHolder, 'slds-hide');
            }else{
                var errorHolder = component.find('incProfNotif');
                $A.util.removeClass(errorHolder, 'slds-show');
            }
        });  
        $A.enqueueAction(action);
    },
    
    hideCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },
    //END R2C CSM-14832 Shayne 12/07/2017
    
})