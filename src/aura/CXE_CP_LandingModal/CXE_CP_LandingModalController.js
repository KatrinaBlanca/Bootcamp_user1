({
	closeModel: function(component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        helper.redirect(component);
	},

	openApp: function(component, event, helper) {
        component.set("v.openApp", true);
        helper.redirect(component);
	},
})