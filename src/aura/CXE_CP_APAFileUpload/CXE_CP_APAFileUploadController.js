({
    doInit : function(component, event, helper) {
        helper.initialize(component, event, helper);
        helper.getCase(component, event, helper);
        helper.getSettings(component, event, helper);
    },

    initAttr : function(component, event, helper) {
        component.find("file").getElement().value = "";
        helper.initialize(component, event, helper);
        helper.getCase(component, event, helper);
    },

    selectFile : function(component, event, helper) {
        helper.validateFile(component, event, helper);        
    },

    checkUpload : function(component, event, helper) {
        helper.validateUpload(component, event, helper);        
    }
})