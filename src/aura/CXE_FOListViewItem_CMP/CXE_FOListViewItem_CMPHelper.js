({
	fireEvent : function(component) {
		var eventHandler = component.getEvent("listViewItemEventHandler");
        
        eventHandler.fire()
	}
})