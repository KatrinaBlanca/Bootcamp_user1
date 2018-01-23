({  
    uploadFile : function(component, event, helper) {
        helper.save(component);
    },

    isValidFileSize : function(component, event, helper) {
        helper.isValidFileSize(component);
    },

    remove : function(component, event, helper) {
        helper.removeFile(component);
    },

    showSystemError: function(cmp, event) {
       // Handle system error
       console.log("^^^^^^^^^^^^^^^^^ cmp : " + cmp);
       console.log("^^^^^^^^^^^^^^^^^ errors : " + event.getParam("message"));
    }
    
})