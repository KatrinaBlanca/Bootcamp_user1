({ 
   displayTab3 : function(component, event, helper) {
      var setEvent = component.getEvent("callTabEvent");
      setEvent.setParams({
         "param1": 3
      });
      setEvent.fire();
    }
})