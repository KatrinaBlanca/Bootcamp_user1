({
	hideModal : function(component, event, helper) {
        //component.set("v.modalPopUp", null);
        var setEvent = component.getEvent("closeModal");
        setEvent.setParams({"attributeValue":'fire'});
        setEvent.fire();
    },
    proceedModal: function(component, event, helper) {
        var setEvent = component.getEvent("closeModal");
        setEvent.setParams({"attributeValue":'proceed'});
        setEvent.fire();
    }
})