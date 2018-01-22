({
    //START CSM-13026 JRances - Change implementation to show Terms and Conditions Modal
    hideModal : function(component, event, helper) {
        //component.set("v.modalPopUpChild", "null");
       /* var checkBox = component.find("termCheck").get("v.value");
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":checkBox});
        setEvent.fire(); */
        var currentChckbxValue = component.find("termCheck").get("v.value");
        var setEvent = component.getEvent("setTerms");
        setEvent.setParams({"checkBox": currentChckbxValue});
        setEvent.fire();
        document.getElementById("mov-modal_lboxTerms").style.display = "none";
    }
    //END CSM-13026 JRances
})