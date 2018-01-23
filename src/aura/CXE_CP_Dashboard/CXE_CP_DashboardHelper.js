({
	showCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
    },

    hideCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },

    goToBills : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/mybills';
        window.location.assign(pageUrl);     
    },

    goToPaperlessBilling : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/paperlessbilling';
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
                             + location.pathname.split('/')[2] + '/startservice?previousPage=dashboard';
        window.location.assign(pageUrl);
    },
    
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
    
    
    
    linkFeedbackHelper  : function (component, event, helper){
         
        var action = component.get("c.getFeedbackLink");
        action.setCallback(this, function(response){
           
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                
                //window.location.href = response.getReturnValue();
                window.open(response.getReturnValue());
                
            }
            
        });
        
        $A.enqueueAction(action);
        

    }

    //START CSM-14628 RReyes NOV-23-17
    , goToAPAEnroll : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/autopayenroll';
        window.location.assign(pageUrl);     
    }
    //END CSM-14628 RReyes NOV-23-17
    // START CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.
    ,goToMyProfile : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/profile?getInfo=1';
        console.log(pageUrl);
        window.location.assign(pageUrl);     
    },
    // END CSM-14554 Jerome To 11/20/2017 Prompt that the user can edit the profile information but it doesn’t tell where the user can edit it.

    //START R2C CSM-14812 Shayne 12/06/2017 
    goToAPASubscription : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/autopayenroll';
        window.location.assign(pageUrl);     
    },
    //END R2C CSM-14812 Shayne 12/06/2017 

})