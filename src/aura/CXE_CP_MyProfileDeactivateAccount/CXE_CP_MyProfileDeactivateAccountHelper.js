({
    //START IPenaflor 10/18/17 CSM-13818
	submit : function() {
		//this.fireError("We'd like to learn about how we can improve our services.");
		this.fireError("We'd like to know how we can improve our services."); // CSM-14674 Red 11-24-2017
	},
    
    fireError : function(message) {
        this.createToast("Please select a reason for your account deactivation.", message, "error");
    },
    
    createToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": title,
                              "message": message,
                              "type": type,
                              "duration": 6000
                             });
        toastEvent.fire();
    }
    //END IPenaflor 10/18/17 CSM-13818
})