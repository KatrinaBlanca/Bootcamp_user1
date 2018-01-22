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
    
    //START CSM-13026 JRances - Change implementation to show Terms and Conditions Modal
    showTermsHelper : function(component, event, helper) {       
        component.set("v.isOpenTA", true);
        document.getElementById("mov-modal_lboxTerms").style.display = "block";
    },
    //END CSM-13026 JRances
    
    /*<!-- ** CSM-14551 / START / JIntal / 11-28-2017 ** -->*/
    initializeForm: function(component) {
        //Check "Is From Move App"
        
        if(location.href.search('RemoteAccessAuthorizationPage') >= 0){
            component.set("v.isMoveApp", true);
            
           
            var pageUrl = window.location.protocol + '//' + window.location.hostname + '/'
            + location.pathname.split('/')[1] + '/CXE_splashMeralcoMobile' 
           // + location.pathname.split('/')[2] + '/';
            window.location.assign(pageUrl); 
        }
    }
    /*<!-- ** CSM-14551 / START / JIntal / 11-28-2017 ** -->*/
    
    
})