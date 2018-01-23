({
    doInitMain : function(component, event, helper) {
        
        var showButons =component.find("on_social_links");
        var action = component.get("c.getProfileInfo"); 
        
        var emailString = "Email";
        var smsString   = "SMS";
        
        var billingNotificationString;
        var billNotifEmailBoolean;
        var billNotifSmsBoolean;
        
        var paymentConfirmationString;
        var paymentConfirmationEmailBoolean;
        var paymentConfirmationSmsBoolean;
        
        var paymentReminderString;
        var paymentReminderEmailBoolean;
        var paymentReminderSmsBoolean;  
        
        var serviceApplicationString; 
        var serviceApplicationEmailBoolean; 
        var serviceApplicationSmsBoolean;
        
        var outagesString; 
        var outagesEmailBoolean;
        var outagesSmsBoolean;
        
        var promotionsString;
        var promotionsEmailBoolean;   
        var promotionsSmsBoolean;
        
        /**START CSM-13885 11/16/17 MIKE**/
        var currentURL = window.location.href ;
        var splitUrl = currentURL.split('/');
        var  miniAds = splitUrl[5];
        var compareSplit = "profile?notif=true";
		
        var getUserSessionId = component.get("c.getUserSessionId"); 
        
        //START CSM-14138 11272017 FERNANDEZ
        getUserSessionId.setCallback(this,function(response){
            
            var state = response.getState();
            console.log('state >>> ' + state);
            if (state === "SUCCESS") {
                if(response.getReturnValue() ==null){
                    console.log('getUserSessionId NULL');
                    var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
                        + location.pathname.split('/')[1] + '/' 
                        + location.pathname.split('/')[2] + '/splash';
                        window.location.assign(pageUrl);
                }else{
                    console.log('getUserSessionId NOT NULL');
                }
            }else{
                console.log('FAIL');
            }
        });
        $A.enqueueAction(getUserSessionId);
        //END CSM-14138 11272017 FERNANDEZ
        
        if(miniAds == compareSplit){

            var currentActive = component.find("tab1");
            var setActiveTab = component.find("tab2");
            $A.util.removeClass(currentActive, "slds-is-active"); 
            $A.util.addClass(setActiveTab, "slds-is-active"); 
            
            component.set("v.tabToShow", 'myProfileTab2');
            
        }
        /**END CSM-13885 11/16/17 MIKE**/

        action.setCallback(this,function(response){
            console.log(response.getState());
            
            if(response.getReturnValue().billingNotification != null){
                billingNotificationString       = response.getReturnValue().billingNotification;
                billNotifEmailBoolean           = billingNotificationString.indexOf(emailString);
                billNotifSmsBoolean             = billingNotificationString.indexOf(smsString);
                
                //START CSM-12436 Mike Verdad 09/05/2017  
                if(billNotifEmailBoolean >= 0){
                    billNotifEmailBoolean = true;
                }
                
                if(billNotifSmsBoolean >= 0){
                    billNotifSmsBoolean = true;
                }
                //END CSM-12436 Mike Verdad 09/05/2017  
                
            }else{
                billingNotificationString = false;
            }
            
            if(response.getReturnValue().paymentConfirmation != null){
                paymentConfirmationString       = response.getReturnValue().paymentConfirmation;
                paymentConfirmationEmailBoolean = paymentConfirmationString.indexOf(emailString);
                paymentConfirmationSmsBoolean   = paymentConfirmationString.indexOf(smsString);   
                
                //START CSM-12436 Mike Verdad 09/05/2017 
                if(paymentConfirmationEmailBoolean >= 0){
                    paymentConfirmationEmailBoolean = true;
                }
                
                if(paymentConfirmationSmsBoolean >= 0){
                    paymentConfirmationSmsBoolean = true;
                }
                //END CSM-12436 Mike Verdad 09/05/2017
                
            }else{
                paymentConfirmationString = false;
            }
            
            if(response.getReturnValue().paymentReminder != null){
                paymentReminderString           = response.getReturnValue().paymentReminder;
                paymentReminderEmailBoolean     = paymentReminderString.indexOf(emailString);
                paymentReminderSmsBoolean       = paymentReminderString.indexOf(smsString);    
                
                //START CSM-12436 Mike Verdad 09/05/2017 
                if(paymentReminderEmailBoolean >= 0){
                    paymentReminderEmailBoolean = true;
                }
                
                if(paymentReminderSmsBoolean >= 0){
                    paymentReminderSmsBoolean = true;
                }
                //END CSM-12436 Mike Verdad 09/05/2017
                
            }else{
                paymentReminderString = false;
            }
            if(response.getReturnValue().serviceApplication != null){   
                serviceApplicationString        = response.getReturnValue().serviceApplication;
                serviceApplicationEmailBoolean  = serviceApplicationString.indexOf(emailString);
                serviceApplicationSmsBoolean    = serviceApplicationString.indexOf(smsString);	
                
                //START CSM-12436 Mike Verdad 09/05/2017 
                if(serviceApplicationEmailBoolean >= 0){
                    serviceApplicationEmailBoolean = true;
                }
                
                if(serviceApplicationSmsBoolean >= 0){
                    serviceApplicationSmsBoolean = true;
                }
                //END CSM-12436 Mike Verdad 09/05/2017
                
            }else{
                serviceApplicationString = false;
            }
            
            if(response.getReturnValue().outages != null){
                outagesString                   = response.getReturnValue().outages;
                outagesEmailBoolean             = outagesString.indexOf(emailString);
                outagesSmsBoolean               = outagesString.indexOf(smsString);
                
                //START CSM-12436 Mike Verdad 09/05/2017 
                if(outagesEmailBoolean >= 0){
                    outagesEmailBoolean = true;
                }
                
                if(outagesSmsBoolean >= 0){
                    outagesSmsBoolean = true;
                }
                //END CSM-12436 Mike Verdad 09/05/2017
                
            }else{
                outagesString = false;
            }
            if(response.getReturnValue().promotions != null){
                promotionsString                = response.getReturnValue().promotions;
                promotionsEmailBoolean          = promotionsString.indexOf(emailString);
                promotionsSmsBoolean            = promotionsString.indexOf(smsString);
                
                //START CSM-12436 Mike Verdad 09/05/2017 
                if(promotionsEmailBoolean >= 0){
                    promotionsEmailBoolean = true;
                }
                
                if(promotionsSmsBoolean >= 0){
                    promotionsSmsBoolean = true;
                }
                //END CSM-12436 Mike Verdad 09/05/2017
                
            }else{
                promotionsString = false;
            }
            
            
            component.set('v.contactMain' , response.getReturnValue());
            
            component.set('v.billNotifEmailBoolean' , billNotifEmailBoolean);
            component.set('v.billNotifSmsBoolean' , billNotifSmsBoolean);
            
            component.set('v.paymentConfirmationEmailBoolean' , paymentConfirmationEmailBoolean);
            component.set('v.paymentConfirmationSmsBoolean' , paymentConfirmationSmsBoolean);
            
            component.set('v.paymentReminderEmailBoolean' , paymentReminderEmailBoolean);
            component.set('v.paymentReminderSmsBoolean' , paymentReminderSmsBoolean);
            
            component.set('v.serviceApplicationEmailBoolean' , serviceApplicationEmailBoolean);
            component.set('v.serviceApplicationSmsBoolean' , serviceApplicationSmsBoolean);
            
            component.set('v.outagesEmailBoolean' , outagesEmailBoolean);
            component.set('v.outagesSmsBoolean' , outagesSmsBoolean);
            
            component.set('v.promotionsEmailBoolean' , promotionsEmailBoolean);
            component.set('v.promotionsSmsBoolean' , promotionsSmsBoolean);
            //alert(response.getReturnValue().google);
            if(response.getReturnValue().google == true){
                
                component.set('v.googleLink' , 'Linked to Google');
            }else{
                
                component.set('v.googleLink' , 'Link to Google'); 
            }
            
            if(response.getReturnValue().facebook == true){
                
                component.set('v.fbLink' , 'Linked to Facebook');
            }else{
                
                component.set('v.fbLink' , 'Link to Facebook'); 
            }
            
            $A.util.removeClass(showButons, 'slds-hide');
            
        });
        $A.enqueueAction(action);
        
    },
    setTab : function(component, event, helper) {

        if(component.get("v.isInEditMode")) {
            component.set("v.showCancelModal", true);
        } else {
            //get data-aura-id of event Source
            var auraId = event.currentTarget.dataset.auraId;
            
            //component.set("v.tabSizeToggle", auraId);
            
            //set clicked tab to active
            var setActiveTab = event.currentTarget.parentNode;
            
            //get current active tabs
            var currentActive = document.getElementsByClassName('slds-is-active');
            
           
            //set value of tabToShow attrib to id of event Source
            //this will show the contents of the tab (rendered component)
            component.set("v.tabToShow", auraId);
           
            //remove active class to tabs
            $A.util.removeClass(currentActive[0], 'slds-is-active');
            
            //add active class to currently selected tab
            $A.util.addClass(setActiveTab, 'slds-is-active');
            
            
            //get Tab content div
            var changeContainer = document.getElementsByClassName('CXE_myProfileContent');
            
            //get right button links div
            var socialLink = document.getElementsByClassName('social-link');
            
            //evaluate if tab content should show full size or with links
            //full size = Edit info, Change password
            //with links = notification, profile info
            if (auraId == 'myProfileTab3' || auraId == 'myProfileTab4') {
                $A.util.addClass(changeContainer[0], 'slds-size_1-of-1');
                $A.util.removeClass(changeContainer[0], 'slds-size_4-of-5');
                $A.util.addClass(socialLink[0], 'slds-hide');
            }
            
            else {
                $A.util.removeClass(changeContainer[0], 'slds-size_1-of-1');
                $A.util.addClass(changeContainer[0], 'slds-size_4-of-5');
                $A.util.removeClass(socialLink[0], 'slds-hide');
            }
        }
        
    },
    
    editInfo : function(component, event, helper) {
        //get data-aura-id of event Source
        var auraId = event.currentTarget.dataset.auraId;
        
        //get current active tabs
        var currentActive = document.getElementsByClassName('slds-is-active');
    
    	var tabToShowHolder = event.currentTarget.dataset.auraId;
        
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        component.set("v.tabToShow", auraId);
        
        component.set("v.tabChecker", auraId);
        
        // alert('tabToShow: '+ auraId);
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], 'slds-is-active');
        
        //set clicked tab to active
        var setActiveTab = document.getElementById('defaultopen').parentNode;
        //alert(setActiveTab);
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab, 'slds-is-active');
        
        var changeContainer = document.getElementsByClassName('CXE_myProfileContent');
        var socialLink = document.getElementsByClassName('social-link');
        
        if (auraId == 'myProfileTab3' || auraId == 'myProfileTab4') {
            $A.util.addClass(changeContainer[0], 'slds-size_1-of-1');
            $A.util.removeClass(changeContainer[0], 'slds-size_4-of-5');
            $A.util.addClass(socialLink[0], 'slds-hide');
        }
        
        else {
            $A.util.removeClass(changeContainer[0], 'slds-size_1-of-1');
            $A.util.addClass(changeContainer[0], 'slds-size_4-of-5');
            $A.util.removeClass(socialLink[0], 'slds-hide');
        }
        
        component.set("v.isInEditMode", true);

        helper.editInfoHelper(component, event);
    },
    //corbes melvin
    activeSin : function(component, event, helper) {
        
        var action = component.get("c.hasSinPaperLessBilling");
        //var action = component.get("c.isAccountPortalAccountDeactivated");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var isBillingModePaperLess = response.getReturnValue();
                
                //alert("From server: " + isBillingModePaperLess);
                
                if(isBillingModePaperLess ==true){
                    
                    component.set("v.showFailDeactivationModal",true);
                    
                }else{
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/deactivate"
                    });
                    urlEvent.fire();
                    
                    
                    
                }                
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        
        $A.enqueueAction(action);
    },
    
    linkFacebook  : function (component, event, helper){
        var fbLinking;
        var fbLink;
        
        var url = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/profile';
        
        var action = component.get("c.getFbLink");
        
        action.setCallback(this, function(response){
            
            if(response.getState() == 'SUCCESS'){
                
                fbLink = response.getReturnValue();
                
            }
            
            fbLinking = fbLink+url;
            
            window.location.assign(fbLinking);
            
        });
        
        $A.enqueueAction(action);
        
        
    },
    
    linkGoogle  : function (component, event, helper){
        var googleLinking;
        var googleLink;
        var url = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/profile';
        
        var action = component.get("c.getGoogleLink");
        
        action.setCallback(this, function(response){
            
            if(response.getState() == 'SUCCESS'){
                
                googleLink = response.getReturnValue();
                
            }
            
            googleLinking = googleLink+url;
            
            window.location.assign(googleLinking);
            
        });
        
        $A.enqueueAction(action);
        
    },
    // START Breadcrumb-task RBellalba SEPT-25-17
    redirectToHome : function (component, event, helper){
        helper.goToHome(component, event, helper);
    },
    
    redirectToProfile : function (component, event, helper){
        helper.goToProfile(component, event, helper);
    }
    // END Breadcrumb-task RBellalba SEPT-25-17
    
    
    
})