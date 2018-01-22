({
	tabNavigate : function(component, event) {
        var tabAv = component.get("v.tabAvailable");

        var childCmp1 = component.find("cmpTab1");  

        childCmp1.validateTab1();

        var tabAv = component.get("v.tabAvailable");
        if(tabAv==2){
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
	}
})