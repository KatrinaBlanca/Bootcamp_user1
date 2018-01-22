({
    /*
    setTab : function(component, event, helper) {
        helper.tabNavigate(component, event);
    },
    
    changeTab: function(component, event, helper)
    {
        console.log('>>>>>>>>>>>>>>>>>>>> changeTab ');
        var eventValue= event.getParam("param1");
        console.log('>>>>>>>>>>>>>>>>>>>> eventValue: ' + eventValue);
        component.set("v.tabAvailable", eventValue);
    }
    */
	setTab : function(component, event, helper) {
		//get data-aura-id of event Source
        var auraId = event.currentTarget.dataset.auraId;
		
        //set clicked tab to active
        var setActiveTab = event.currentTarget.parentNode;
        
        //get current active tabs
        var currentActive = document.getElementsByClassName('active');
        
        //set value of tabToShow attrib to id of event Source
        //this will show the contents of the tab (rendered component)
        component.set("v.tabToShow", auraId);
        
        //remove active class to tabs
        $A.util.removeClass(currentActive[0], 'active');
        
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab, 'active');

	}

})