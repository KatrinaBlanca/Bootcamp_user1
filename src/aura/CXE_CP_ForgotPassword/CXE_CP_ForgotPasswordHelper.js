({
	getContainerDiv: function(event, element) {
        var elem;
        if (!element) {
            elem = event.srcElement;
        }
        else {
            elem = element;
        }

        if (elem.classList.contains('slds-tabs_default__item')) {
            return elem;
        }
        else {
            return this.getContainerDiv(event, elem.parentElement);
        }
    },
    
    initializeForm: function(component) {
        //Check "Is From Move App"
        if(location.href.search('RemoteAccessAuthorizationPage') >= 0)
            component.set("v.isMoveApp", true);
    }
})