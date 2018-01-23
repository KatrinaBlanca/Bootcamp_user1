({
    doInit : function(component, event, helper) {
        helper.initializeForm(component, event);
    },
    
    changeTab: function(component, event, helper) {
        // @CSM 12961 (gibs - start)
        var clickedTab = event.currentTarget.dataset.tab;
        //var clickedTab = helper.getContainerDiv(event, null);
        //clickedTab.getAttribute("title").val();
        
        component.set("v.tabToShow", event.currentTarget.dataset.tab);
        
        var tabs =  component.find('tabpage');
        
        for (var idx = 0; idx < tabs.length; idx++)
        {
            var tab = tabs[idx].getElement();
            $A.util.removeClass(tab.children[0], 'active');
            $A.util.removeClass(component.find(tab.children[0].getAttribute('aria-controls')), 'slds-show');
            $A.util.addClass(component.find(tab.children[0].getAttribute('aria-controls')), 'slds-hide');
        }
        
        //$A.util.addClass(clickedTab.children[0], 'active');
        //$A.util.addClass(clickedTab, 'active');
        document.querySelector('[data-tab="'+clickedTab+'"]').className += " active";
        //document.querySelector('[data-tab="'+clickedTab+'"]').className += " active";
        //$A.util.addClass(component.find(clickedTab.getAttribute('aria-controls')), 'slds-show');
        $A.util.addClass(component.find(clickedTab), 'slds-show');
        $A.util.removeClass(component.find(clickedTab), 'slds-hide');
        //$A.util.removeClass(component.find(clickedTab.getAttribute('aria-controls')), 'slds-hide');
        // @CSM 12961 (gibs - end)
    },
    
    //START CSM-13026 JRances - Change implementation to show Terms and Conditions Modal
    showTerms : function(component, event, helper) {       
        var returnData =  event.getParam("checkBox");
        console.log('returnData: '+returnData);
        component.set('v.checkBox' , returnData);
        helper.showTermsHelper(component, event, helper);
    }
    //END CSM-13026 JRances
})