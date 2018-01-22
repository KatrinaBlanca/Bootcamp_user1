({
    hideModal : function(component, event, helper) {
        //component.set("v.modalPopUpChild", "null");
        var checkBox = component.find("termCheck").get("v.value");
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":checkBox});
        setEvent.fire();
        document.getElementById("mov-modal_lboxTerms").style.display = "none";
    }
})