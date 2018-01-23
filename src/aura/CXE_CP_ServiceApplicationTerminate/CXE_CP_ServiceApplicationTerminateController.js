({
    /*setTab : function(component, event, helper) {
       
        var tabAv = component.get("v.tabNumAvailable");
        console.log(">>>>>>>>>>>>>>>>>status of "+tabAv);
        var childCmp1 = component.find("cmpTab1");
        childCmp1.validateTab1();
    },*/

    changeTab: function(component, event, helper)
    {
        var tabAv = component.get("v.tabNumAvailable");
        var eventParam= event.getParam("param1");
        if(tabAv<eventParam){
            component.set("v.tabNumAvailable", eventParam);
            helper.changeActiveTab(component, component.get("v.tabNumAvailable"), eventParam);
        }
        
    }
   
})