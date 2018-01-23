({
    //Navigation thru Tab
	displayTab : function(component, event, helper) {
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;

        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber <  3 && clickedTab > 2){
            var hasError1 = helper.validateTab1(component, event, helper);
            var hasError2 = helper.validateTab2(component, event, helper);

            var tabName = (!hasError1 ? "2" : "1");
            if(!hasError1) {
                tabName = clickedTab;
            }
            helper.displaySpecific(component, event, helper, tabName);
            return;
        }

        if(activeTabNumber ==  2 && clickedTab > activeTabNumber){
            hasError = helper.hasErrorOnTab2(component, event, helper);
        }

        if(activeTabNumber ==  1 && clickedTab != activeTabNumber){
            hasError = helper.hasErrorOnTab1(component, event, helper);
        }

        if(!hasError) {
            var className = "biz-modify-tab-";
            helper.display(component, event, helper, className);
            component.set("v.activeTabNumber", clickedTab);
        }
    },

    display : function(component, event, helper, className) {
        var auraId = event.currentTarget.dataset.auraId;

        var setActiveTab = event.currentTarget.parentNode;
        var activeTabNumber = component.get("v.activeTabNumber");
        var className = className + activeTabNumber;

        //get current active tabs
        var currentActive = document.getElementsByClassName(className);
				//var currentActive = document.getElementsByClassName('slds-is-active');
        component.set("v.tabToShow", auraId);

        for(var i=0; i < currentActive.length; i++) {
					//console.log(currentActive[i].innerHTML);
            $A.util.removeClass(currentActive[i], "slds-is-active");
            //$A.util.addClass(setActiveV2[i], "slds-is-active");
			//alert(currentActive[i].classList.remove('slds-is-active'));
        }

        //$A.util.addClass(setActiveTab[0], "slds-is-active");
        //$A.util.removeClass(currentActive[0], "slds-is-active");
        $A.util.addClass(setActiveTab, "slds-is-active");

        helper.toggleTab(component, activeTabNumber);
        helper.toggleTab(component, auraId);
    },


    displaySpecific : function(component, event, helper, target) {
        var className = "biz-modify-tab-";
        var activateClassName = className + target;

        //get current active tabs
        //var currentActive = document.getElementsByClassName(className + component.get("v.activeTabNumber"));
				var currentActive = document.getElementsByClassName('slds-is-active');

        var setActiveTab = document.getElementsByClassName(activateClassName);

				for(var i=0; i < currentActive.length; i++) {
            $A.util.removeClass(currentActive[i], "slds-is-active");
						//$A.util.addClass(setActiveTab[i], "slds-is-active");
        }
        //$A.util.removeClass(currentActive[0], "slds-is-active");

				for(var i=0; i < setActiveTab.length; i++) {
					$A.util.addClass(setActiveTab[i], "slds-is-active");
				}


        helper.hideTab(component, component.get("v.activeTabNumber"));
        helper.showTab(component, target);
        component.set("v.activeTabNumber", target);
        component.set("v.tabToShow", target);
    },


    showTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.addClass(component.find(cmpTarget), "slds-show");
        $A.util.removeClass(component.find(cmpTarget), "slds-hide");
    },

    hideTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.removeClass(component.find(cmpTarget), "slds-show");
        $A.util.addClass(component.find(cmpTarget), "slds-hide");
    },


    //Navigation thru Button
     displayTabFromButtonChangeService : function(component, event, helper) {
        var className = "biz-modify-tab-";
        var activeTab = component.get("v.activeTabNumber");
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        //get current active tabs
        var currentActive = document.getElementsByClassName(deactiveClassName);
        var setActiveTab = document.getElementsByClassName(activateClassName);

        //remove active class to tabs
        $A.util.removeClass(currentActive[0], "slds-is-active");
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab[0], "slds-is-active");

        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },

    displayTabFromButtonChangeContract : function(component, event, helper) {
        var className = "biz-modify-tab-";
        var activeTab = component.get("v.activeTabNumber");
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        //get current active tabs
        var currentActive = document.getElementsByClassName(deactiveClassName);
        var setActiveTab = document.getElementsByClassName(activateClassName);

        //remove active class to tabs
        $A.util.removeClass(currentActive[1], "slds-is-active");
        //add active class to currently selected tab
        $A.util.addClass(setActiveTab[1], "slds-is-active");

        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },

    toggleTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
    },

    //Validation Code Block
    //Validation for Tab 1
    hasErrorOnTab1 : function(component, event, helper) {
        var hasError = helper.validateTab1(component, event, helper);
        return hasError;
    },

    validateTab1 : function(component, event, helper) {
        var hasError;
        console.log(' >>>>>>>>>>>>>>>>>>>>>>>>>>> submitTab1: ');
		//need validation
		var servReq = component.get("v.caseVar.CXE_Service_Request_s__c");
        if(servReq){
            hasError = false;
        }else{
            hasError = true;
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({"title": "Please check your input.",
                                  "message": "Please select a service modification.",
                                  "type": "error",
                                  "duration" : 6000
                                 });
            toastEvent.fire();
        }
        return hasError;
    },

    //Validation for Tab 2
    hasErrorOnTab2 : function(component, event, helper) {
        var hasError = helper.validateTab2(component, event, helper);
        return hasError;
    },

    validateTab2 : function(component, event, helper) {
        var hasError = false;
        return hasError;
    },

    //Going To Tab 4
    submitModification : function(component, event, helper) {
        helper.toggleSpinner(component, event, helper);

        var caseRec = component.get("v.caseVar");

        var action = component.get("c.submitServiceApplication");
        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Modification_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
			
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
               
                if (!response.hasError) {                    
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseVar.CaseNumber", response.caseNumber);
                    console.log('v.caseVar.CaseNumber: >>>>>>>>>>>'+response.caseNumber);
                    helper.displaySpecific(component, event, helper, "4");
                    
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration" : 6000
                                         });
                    toastEvent.fire();
                }
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);

                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Please validate your application.",
                                              "message": errors[0].message,
                                              "type": "error",
                                              "duration" : 6000
                                             });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinner");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
    },

    enableSubmitBtn : function(component, event, helper) {
        var yes =document.getElementById("agreeChkbx").checked;
        if(yes == true){
            component.find("termsACBtn").set("v.disabled", false);
        } else {
            component.find("termsACBtn").set("v.disabled", true);
        }
    }

})