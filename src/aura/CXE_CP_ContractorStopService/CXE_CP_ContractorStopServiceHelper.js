({
	initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecsStop", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },
    
    getServiceModificationOptions : function(component, event, helper){
        var action = component.get("c.getServiceModifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.serviceModifications", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        
        $A.enqueueAction(action);
    },

    getContractModificationOptions : function(component, event, helper) {
        var action = component.get("c.getContractModifications");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.contractModifications", response.getReturnValue());
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        $A.enqueueAction(action);
    },

    getRelationshipToCustomer : function(component, event, helper) {
        var action = component.get("c.getRelationToCustomer");
        action.setParams({
            "persona": component.get("v.persona")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                component.set("v.relationToCustomerPicklist", response); 
            } else {
                console.log('>>>>>>>>>>>>>>>>>> Error.' + a.getReturnValue());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Please validate your application.",
                                      "message": a.getReturnValue(),
                                      "type": "error",
                                      "duration": 6000
                                     });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    toggleTab : function(component, auraId) {
        var cmpTarget = "conIndStopForm" + auraId;
        console.log(cmpTarget + ' >>> auraId = ' + auraId );
        console.log('activetabnumber >>>>> ' + component.get("v.activeTabNumber"));
       	
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
    },
    
    validateTab1 : function(component, event, helper) {
		var con_stop_mobile       = component.find("con_stop_mobile").get("v.value");
        var con_stop_pEmail       = component.find("con_stop_pEmail").get("v.value");
        var list;
    
            list = ["contractorSINStop", "con_stop_fname", "con_stop_lname", "con_stop_company", "con_stop_pEmail", "con_stop_mobile"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);
      
        
        if (!$A.util.isEmpty(con_stop_mobile)){ 
           
            var regexMobileFormat = /(\+639)[0-9]{9}/;
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			
            if(!con_stop_mobile.match(regexMobileFormat)){
               
                var lndlne = component.find("conRes_landlineReact"); 
                lndlne.set("v.errors", [{message:"Please input your mobile number in the format +639XXXXXXXXX."}]);   
                hasError = true;
            }
            
            if(!con_stop_pEmail.match(regExpEmailformat)){
               
                
                con_stop_pEmail.set("v.errors", [{message:"Please enter a valid email address."}]);   
                hasError = true;
            }
            
        }
        
        return hasError;
    },

    hasErrorOnFieldList: function(component, helper, list) {
        var ctr = 0;
		
        if(list) {
            var i = 0;
            for (i = 0; i < list.length; i++) {                
                if(this.isFieldUndefined(component.find(list[i])) ) {
                    ctr++;
                    continue;
                }
                if(this.hasInvalidFormat(component.find(list[i]), list[i])) {
                    ctr++;
                }
            }
        }
        
        

        return (ctr > 0);
    },
    
    isFieldUndefined : function(cmpTarget) {
        
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){   
           
            cmpTarget.set("v.errors", [{message:"Please indicate your  " + cmpTarget.get("v.label") + "."}]);
            return true;        
        } else {
            
            cmpTarget.set("v.errors",null);
            return false;
        }
    },    

    hasInvalidEmailFormat : function (cmpTarget) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var errorMessage = "Please enter a valid email address.";
        if(!cmpTarget.get("v.value").match(regExpEmailformat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidMobileFormat : function (cmpTarget) {
        var regexMobileFormat = /(\+639)[0-9]{9}/;
        var errorMessage = "Please input your mobile number in the format +639XXXXXXXXX.";
        if(!cmpTarget.get("v.value").match(regexMobileFormat)){
             
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
             
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidLandlineFormat : function (cmpTarget) {
        var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/;
        var errorMessage = "Phone should start with +63 then followed by 1 to 2-digit area code and 7-digit number.";
        var isUndefined = ($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")));
        if(!isUndefined && !cmpTarget.get("v.value").match(regexLandlineFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
          
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidFormat : function (cmpTarget, auraId) {
      
        var isInvalid = false;

        if(auraId === "con_stop_mobile"){
           
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
           
        }
        
        if(auraId === "con_stop_pEmail"){
            
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
            
        }
        
    },
    
    hasNoServiceRequest : function (component, helper) {
       
        var serviceReq = component.get("v.caseRecsStop.CXE_Service_Request_s__c");
        var isUndefined = ($A.util.isEmpty(serviceReq) || $A.util.isUndefined(serviceReq));
  
        if(isUndefined) {
            helper.fireError("Please select service request.");
        }
        return isUndefined;
    },

    fireError : function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": "Please check your input.",
                              "message": msg,
                              "type": "error",
                              "duration" : 6000
                             });
        toastEvent.fire();
    },
    
    displayTabFromButton : function(component, event, helper) {
      
        var className = "slds-progress__item ";
        var activeTab = component.get("v.activeTabNumber");
        console.log('activeTab >> ' + activeTab);
        var deactivateTab = activeTab - 1;
        console.log('deactivateTab >> ' + deactivateTab);
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        var currentActive = document.getElementsByClassName(deactiveClassName);
        var setActiveTab  = document.getElementsByClassName(activateClassName);
        
        var classId = "marks";
        var actClassId = classId + activeTab;
      
        var activateClassId = component.find(actClassId);
      
        $A.util.addClass(activateClassId, "slds-is-active");
        
        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },
    
    displayTabFromButton2 : function(component, event, helper) {
       
        var className = "slds-progress__item ";
        var activeTab = 3;
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        var currentActive = document.getElementsByClassName(deactiveClassName);
        var setActiveTab = document.getElementsByClassName(activateClassName);
     
        var classId = "marks";
        var actClassId = classId + activeTab;
      
        var activateClassId = component.find(actClassId);
        
        var tabName = 3;
        component.set("v.stepNumberStop", tabName);
      
        $A.util.addClass(activateClassId, "slds-is-active");
        
        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },
    
    goToHomePage : function(component, event, helper) {
        var pageUrl = window.location.href;
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": pageUrl
        });
        urlEvent.fire();	
	},
    
    
    
    submitTermination : function(component, event, helper) {
       
        helper.toggleSpinner(component, event, helper);
        component.set("v.caseRecsStop.Application_Type_Subtype__c", "Termination of Electric Service");
        var caseRec = component.get("v.caseRecsStop");
                
        var action = component.get("c.submitServiceApplication");
        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "CXE_Termination_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            console.log("SIN:" + component.get("v.caseRecsStop.Account_No__c"));
            if(state == "SUCCESS"){
               
                var response = a.getReturnValue();
                if (!response.hasError) {
                    
                    component.set("v.caseRecsStop.CaseNumber", response.caseNumber);
                    
                    component.set("v.hasSubmitted", true);
                   
        			component.set("v.caseRecordAccountNameStop", response.caseRecord.Account.Name);
                    //var setEvent = component.getEvent("callTabEvent");
                   
                    //setEvent.setParams({"param1":2});

                    helper.displayTabFromButton2(component, event, helper);
                   
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
        $A.util.toggleClass(component.find("progress_bar"), 'slds-hide');
    },
    
    
   
	onChangeResidentialHelper : function(component, event, helper) {
         var changeElementResidential = component.find("cmpTabDiv2Residential");
         var changeElementBusiness    = component.find("cmpTabDiv2Business");
        
         var addInd    = component.find("addInd");
         var addBiz    = component.find("addBiz");
        
          component.set("v.appForResAndBusReact", false);
        
         $A.util.addClass(changeElementResidential, 'slds-show');
         $A.util.removeClass(changeElementResidential, 'slds-hide');
        
         $A.util.addClass(addInd, 'slds-hide');
         $A.util.removeClass(addInd, 'slds-show');
        
         $A.util.addClass(changeElementResidential, 'slds-show');
         $A.util.removeClass(changeElementResidential, 'slds-hide');
        
         $A.util.addClass(addBiz, 'slds-hide');
         $A.util.removeClass(addBiz, 'slds-show');
    },
    
    onChangeBusinessHelper : function(component, event, helper) {
         var changeElementResidential = component.find("cmpTabDiv2Residential");
         var changeElementBusiness    = component.find("cmpTabDiv2Business");
        
         var addInd    = component.find("addInd");
         var addBiz    = component.find("addBiz");
        
         component.set("v.appForResAndBusReact", true);
        
         $A.util.addClass(changeElementResidential, 'slds-hide');
         $A.util.removeClass(changeElementResidential, 'slds-show');
        
         $A.util.removeClass(changeElementBusiness, 'slds-hide');
         $A.util.addClass(changeElementBusiness, 'slds-show');
        
         $A.util.addClass(addInd, 'slds-hide');
         $A.util.removeClass(addInd, 'slds-show');
        
         $A.util.removeClass(addBiz, 'slds-hide');
         $A.util.addClass(addBiz, 'slds-show');
        
    },

    displayTab : function(component, event, helper, auraId) {  
      
        var activeTabNumber = component.get("v.activeTabNumber"); 
        var stepNumberStop = component.get("v.stepNumberStop");  
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;
        var tabDisplay = activeTabNumber;
        var classId = "marks";
        var actClassId = classId + clickedTab;
        var deactClassId = classId + activeTabNumber;
        var isSame = component.get("v.isSame"); 
        
        var marks1 = component.find("marks1");
        var marks2 = component.find("marks2");
        var marks3 = component.find("marks3");
        
        if(component.get("v.hasSubmitted")){
            return;
        }
       

        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
               
                $A.util.addClass(activateClassId, "slds-is-active");
                
                 if(activeTabNumber < clickedTab && stepNumberStop < clickedTab){
                   
                    component.set("v.stepNumberStop", 2);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                if(clickedTab == 2 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active");  
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                   $A.util.addClass(marks3, "slds-is-active"); 
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                   $A.util.addClass(marks3, "slds-is-active"); 
                   $A.util.addClass(marks4, "slds-is-active");
                }

                tabDisplay = clickedTab;
            }
        }else if(activeTabNumber == '2') {
            
           
                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
             
                $A.util.addClass(activateClassId, "slds-is-active");
                
                 if(activeTabNumber < clickedTab && stepNumberStop < clickedTab){
                    component.set("v.stepNumberStop", 3);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                 if(clickedTab == 2 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                   $A.util.addClass(marks3, "slds-is-active"); 
                    component.set("v.isDisabledReactTab4", false);
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                   $A.util.addClass(marks3, "slds-is-active"); 
                   $A.util.addClass(marks4, "slds-is-active");
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(marks2, "slds-is-active"); 
                   
                }

                tabDisplay = clickedTab;
        }
        
        else if(activeTabNumber == '2' && selectedService == true) {
            hasError = helper.validateTab2Business(component, event, helper);
            if(!hasError) {
                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
                
                $A.util.addClass(activateClassId, "slds-is-active");
                
                 if(activeTabNumber < clickedTab && stepNumberStop < clickedTab){
                    component.set("v.stepNumberStop", 3);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                 if(clickedTab == 2 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                   $A.util.addClass(marks3, "slds-is-active"); 
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(marks2, "slds-is-active"); 
                   $A.util.addClass(marks3, "slds-is-active"); 
                   $A.util.addClass(marks4, "slds-is-active");
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(marks2, "slds-is-active"); 
                   
                }

                tabDisplay = clickedTab;
            }
           
        }else {
            tabDisplay = clickedTab;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
             
    },
    
    displaySpecific : function(component, event, helper, target) {

        var className = "slds-progress__item ";
        var activateClassName = className + target;
        var currentActive = document.getElementsByClassName(className + component.get("v.activeTabNumber"));
        var setActiveTab = document.getElementsByClassName(activateClassName);
        
        $A.util.removeClass(currentActive[0], "slds-is-active");
        
        $A.util.addClass(setActiveTab[0], "slds-is-active");
        
        helper.hideTab(component, component.get("v.activeTabNumber"));
        helper.showTab(component, target);
        
        
        component.set("v.activeTabNumber", target);
        component.set("v.tabToShow", target);        
    },
    
    hideTab : function(component, auraId) {

        var cmpTarget = "conIndStopForm" + auraId;
        $A.util.removeClass(component.find(cmpTarget), "slds-show");
        $A.util.addClass(component.find(cmpTarget), "slds-hide");
    },
    
    showTab : function(component, auraId) {

        var cmpTarget = "conIndStopForm" + auraId;
       
        $A.util.addClass(component.find(cmpTarget), "slds-show");
        $A.util.removeClass(component.find(cmpTarget), "slds-hide");
    },


})
})