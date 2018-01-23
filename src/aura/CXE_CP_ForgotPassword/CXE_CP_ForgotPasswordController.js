({
    doInit : function(component, event, helper) {
        helper.initializeForm(component, event);
    },
    
    changeTab: function(component, event, helper) {
        var clickedTab = helper.getContainerDiv(event, null);
        component.set("v.tabToShow", event.currentTarget.dataset.tab);
        
        var tabs =  component.find('tabpage');
        
        for (var idx = 0; idx < tabs.length; idx++)
        {
            var tab = tabs[idx].getElement();
            $A.util.removeClass(tab.children[0], 'active');
            $A.util.removeClass(component.find(tab.children[0].getAttribute('aria-controls')), 'slds-show');
            $A.util.addClass(component.find(tab.children[0].getAttribute('aria-controls')), 'slds-hide');
        }
        
        $A.util.addClass(clickedTab.children[0], 'active');
        $A.util.addClass(component.find(clickedTab.children[0].getAttribute('aria-controls')), 'slds-show');
        $A.util.removeClass(component.find(clickedTab.children[0].getAttribute('aria-controls')), 'slds-hide');
        
        
    }
})