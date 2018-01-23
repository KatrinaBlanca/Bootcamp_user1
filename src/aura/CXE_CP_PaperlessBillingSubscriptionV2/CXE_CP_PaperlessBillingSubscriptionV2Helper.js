({
	
    backToAccountListHelper : function (component, event, helper) { 
       
        var paperlessPage = component.find("paperlessBillSubCmp");
        var mainPage = component.find("MainForm");
        var mainPageNav = component.find("MainFormNav");
       
        $A.util.addClass(paperlessPage, "slds-hide");
        
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
		//  alert('helper end' + paperlessPage); //CSM-13020 Melvin Corbes 10-02-17
    },
    
    //Start CSM-12548 Mike Verdad 09/26/2017
    goBackToAcctList : function(component, event, helper) {
        //START CSM-13656 JRances - Validation message remains after navigating back to Accounts page
        var selected = component.find("myAccountData");
        selected.set("v.errors", null);
        document.getElementById('checkIfAccountIsSelected').classList.add("slds-hide");
        //END CSM-13656 JRances
        
        var setEvent = component.getEvent("setAttribute2");
        var currentPageURL = window.location.href;
        var comparePageURL = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/paperlessbilling';

        if(currentPageURL == comparePageURL){
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                             + location.pathname.split('/')[1] + '/' 
                             + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
            
        }else{
        setEvent.setParams({"attributeValue":'Fire'});
        setEvent.fire()
        }
    },
    //End CSM-12548 Mike Verdad 09/26/2017
    
    // START Breadcrumb-task RBellalba SEPT-26-17
    goToHome : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/dashboard';
        window.location.assign(pageUrl);
    },
    
    goToAccount : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/myaccounts';
        window.location.assign(pageUrl);
    },
    // END Breadcrumb-task RBellalba SEPT-26-17
  
   
    // START R2C CSM-13274 Shayne 10/13/2017
	 initializeCheckConglomerate : function(component, event) {
        console.log('initializeCheckConglomerate');
        var action = component.get("c.retrieveCheckConglomerate");
        
        action.setCallback(this,function(response){             
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('initializeCheckConglomerate state' + state +' and result '+result);
            if(state === "SUCCESS"){
                var endpoint = component.get('v.isEndpoint');
                component.set('v.isConglomerate', result);
                 var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                + location.pathname.split('/')[1] + '/' 
                + location.pathname.split('/')[2] + '/congloaccerror';
               if(result==true && endpoint===true)  window.location.assign(pageUrl);
                else component.set('v.isLoaded',true); //R2C CSM-14773 Shayne 12/05/2017
            }
        });  
        $A.enqueueAction(action); 
    },
    // END R2C CSM-13274 Shayne 10/13/2017
    
    //Start CSM-14653 Mike Verdad 11/23/2017
    redirectMERALCOSiteHelper : function(component, event, helper) {
        var action = component.get("c.RedirectToMeralcoWebsite");
        action.setCallback(this, function(response){
            
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
       
	},
    //End CSM-14653 Mike Verdad 11/23/2017
    
   //Start CSM-14772 Corbes Melvin 12/5/2017
    redirectMERALCOSitePBHelper : function(component, event, helper) {
        var action = component.get("c.ImageInPaperlessBilling");
        action.setCallback(this, function(response){
            
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                window.open(response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
       
	}
    //End CSM-14772 Corbes Melvin 12/5/2017    
})