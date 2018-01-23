({
	doInit : function(component, event, helper) {
		helper.initiateBreadcrumbs(component, event, helper);
	},

	redirectToPage : function(component, event, helper) {
		helper.goToPage(component, event, helper);
	}
})