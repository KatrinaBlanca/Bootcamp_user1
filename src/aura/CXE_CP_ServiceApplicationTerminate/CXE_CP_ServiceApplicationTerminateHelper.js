({
    changeActiveTab : function(component, tabAv, selectedTab) {
        
        if(tabAv>=selectedTab){
            
            var setActiveTab;
            component.set("v.tabToShow", "serviceAppTermTab"+selectedTab);
            setActiveTab = document.getElementById("tab"+selectedTab); 
            var currentActive = document.getElementsByClassName('active');
            $A.util.removeClass(currentActive[0], 'active');
            $A.util.addClass(setActiveTab, 'active');
        } 
    }
})