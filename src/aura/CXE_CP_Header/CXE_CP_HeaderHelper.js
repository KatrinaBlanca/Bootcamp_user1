({
	getContainerDiv: function(event, element) {
        var elem;
        if (!element) {
            elem = event.srcElement;
        }
        else {
            elem = element;
        }

        if (elem.classList.contains('')) {
            return elem;
        }
        else {
            return this.getContainerDiv(event, elem.parentElement);
        }
    }
})