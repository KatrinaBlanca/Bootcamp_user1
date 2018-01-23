({
	onInit: function(component) {
        var action = component.get("c.getProfilePicture"); 
        action.setParams({
            parentId: component.get("v.recordId"),
        });
        action.setCallback(this, function(a) {
            var photoURL = a.getReturnValue();
            if (photoURL) {
	            component.set('v.pictureSrc', photoURL);
            }
        });
        $A.enqueueAction(action); 
    },
})