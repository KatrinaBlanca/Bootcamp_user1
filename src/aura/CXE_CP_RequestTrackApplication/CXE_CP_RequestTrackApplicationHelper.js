({
    getCaseList : function(component, event, helper) {
        var self = this;
        var action = component.get("c.getCaseList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var res = response.getReturnValue();
                console.log('conglomerate '+res.isConglomerate);
                component.set("v.isConglomerate", res.isConglomerate);
                component.set("v.response", res);
            } else {
                self.fireError(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);        
    },
    
    getCaseHistory : function(component, event, helper) {  
        helper.toggleSpinner(component, event, helper);
        var action = component.get("c.trackApplication");
        action.setParams({
            "referenceNumber": event.getSource().get("v.label"),
            "lastName": event.getSource().get("v.alt")
        });
        action.setCallback(this, function(a) {
            helper.toggleSpinner(component, event, helper);
            var state = a.getState();                
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                if (!response.hasError) {                        
                    component.set("v.caseHistoryList", response.caseStatusHistoryList);
                    component.set("v.caseRecord", response.caseRecord);
                    component.set("v.isTerminate", response.isTerminate);
                    if(response.statusJourney) {
                        component.set("v.statusJourney", response.statusJourney);
                        // $A.util.addClass(component.find(response.statusJourney), 'slds-is-active');
                    } 
                    helper.toggleCmp(component, "myRequest");
                    helper.toggleCmp(component, "caseHistory");
                    helper.toggleCmp(component, "myRequestTab");
                    
                    //@gibs - Fix miniads on requestdetail
                    helper.toggleCmp(component, "hideMainWidget");
                    
                } else {
                    helper.fireError(response.errorMessage);
                }
            } else {
                helper.fireError(a.getReturnValue());
            }
        });
        $A.enqueueAction(action);       
    },
    
    toggleCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        $A.util.toggleClass(cmpTarget, 'slds-show');
    },
    
    createToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": title,
                              "message": message,
                              "type": type,
                              "duration": 6000
                             });
        toastEvent.fire();
    },
    
    fireError : function(message) {
        this.createToast("Please validate your application.", message, "error");
    },
    
    fireNotice : function(message) {
        this.createToast("Warning.", message, "info");
    },
    
    fireSuccess : function(message) {
        this.createToast("Success!", message, "success");
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },
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
    // START CSM-13944 JRances / UAT, 'Request for a New Service' link in the Requests page is not working.
    ,goToStartServiceForm : function (component, event, helper){
        var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
        + location.pathname.split('/')[1] + '/' 
        + location.pathname.split('/')[2] + '/startservice';
        window.location.assign(pageUrl);     
    }
    // NED CSM-13944 JRances
})