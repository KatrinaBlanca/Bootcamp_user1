({
	initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecs", a.getReturnValue());
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
        var cmpTarget = "conIndReactivateForm" + auraId;
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
    },
    
    validateTab1 : function(component, event, helper) {
        var list;
        var con_react_mobile = component.find("con_react_mobile").get("v.value");

            list = ["con_react_fname", "con_react_lname", "con_react_company", "con_react_pEmail"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);
        if ($A.util.isEmpty(con_react_mobile)){ 
                var mobile = component.find("con_react_mobile"); 
                mobile.set("v.errors", [{message:"Please indicate your Mobile Number."}]);   
                hasError = true;
            
        }if(!$A.util.isEmpty(con_react_mobile)){ 
            var mobile = component.find("con_react_mobile"); 
            var regexMobileFormat = /(\+639)[0-9]{9}/;
            
            if(!con_react_mobile.match(regexMobileFormat)){
                var mobile = component.find("con_react_mobile"); 
                mobile.set("v.errors", [{message:"Please input your mobile number in the format +639XXXXXXXXX."}]);   
                hasError = true;
            } else {
                mobile.set("v.errors", null);
                hasError = false;
            } 
            
        }

        return hasError;
    },
    
    validateTab2Residential : function(component, event, helper) {
        
        var list;
        var conRes_landlineReact = component.find("conRes_landlineReact").get("v.value");
        var dateFieldReact       = component.find("dateFieldReact").get("v.value");

        list = ["contractorSINReact","conRes_fnameReact", "conRes_lnameReact", "conRes_pEmailReact" ,"conRes_mobileTab2React"];
        
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        
    
        if (!$A.util.isEmpty(conRes_landlineReact)){ 
           
            var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/;
			
            if(!conRes_landlineReact.match(regexLandlineFormat)){
               
                var lndlne = component.find("conRes_landlineReact"); 
                lndlne.set("v.errors", [{message:"Please input your landline in the format +632xxxxxxx."}]);   
                hasError = true;
            }
            
        }
        
        if (!$A.util.isEmpty(dateFieldReact)){  
            var date = dateFieldReact;
            var varDate = new Date(date); //dd-mm-YYYY
            var today = new Date();
            
            if(varDate >= today) {
                var sampp = component.find("dateFieldReact");             
                sampp.set("v.errors", [{message:"Birthdate cannot be future date."}]);   
                hasError = true;
            }
             
        }
        
        return hasError;
    },
    
    validateTab2Business : function(component, event, helper) {
		
        var list;
    
            list = ["contractorSINReact","conBus_companyNameBusinessReact", "conBus_landlineBusinessReact", "conBus_companyEmailBusinessReact"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);

        return hasError;
    },
    
    validateTab3 : function(component, event, helper) {

        var list;
        
            list = ["newBusinessBillingAddress"];
        
        var hasError = this.hasErrorOnFieldList(component, helper, list);
       
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
        var errorMessage = "Please input your landline in the format +632XXXXXXX.";
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
        if(auraId === "conRes_pEmailReact"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
              
        if(auraId === "conRes_mobileTab2React"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
        
        if(auraId === "con_react_mobile"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
        
        if(auraId === "conBus_companyEmailBusinessReact"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
         if(auraId === "conBus_landlineBusinessReact"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
        
     	if(auraId === "con_react_pEmail"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
       
		/*
        if(auraId === "conRes_landlineReact"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
        return isInvalid;
        */
    },
    
    hasNoServiceRequest : function (component, helper) {
       
        var serviceReq = component.get("v.caseRecs.CXE_Service_Request_s__c");
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
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        var currentActive = document.getElementsByClassName(deactiveClassName);
        var setActiveTab = document.getElementsByClassName(activateClassName);
        
        var classId = "mark";
        var actClassId = classId + activeTab;
      
        var activateClassId = component.find(actClassId);
      
        $A.util.addClass(activateClassId, "slds-is-active");
        
        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },
    
    displayTabFromButton2 : function(component, event, helper) {

        var className = "slds-progress__item ";
        var activeTab = 5;
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        var currentActive = document.getElementsByClassName(deactiveClassName);
        var setActiveTab = document.getElementsByClassName(activateClassName);
     
        var classId = "mark";
        var actClassId = classId + activeTab;
      
        var activateClassId = component.find(actClassId);
      
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

    submitRecontract : function(component, event, helper) {
        var tabName = 5;
        helper.toggleSpinner(component, event, helper);
        component.set("v.caseRecs.Application_Type_Subtype__c", "Recontract of Electric Service");
        var caseRecs = component.get("v.caseRecs");
                
        var action = component.get("c.submitServiceApplication");

        console.log("JSON:" + JSON.stringify(caseRecs));
       

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRecs),
            "serviceApplicationType": "CXE_Recontract_of_Electric_Service"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();
                console.log("response: " + response);
                if (!response.hasError) {
                   
                    component.set("v.caseRecs.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    //component.find("fileUploadCmp1").uploadFile(response.caseRecordId);
                    // helper.displaySpecific(component, event, helper, "4");
                    console.log("if Unknown error");
                    component.set("v.stepNumber", tabName);
            		helper.displayTabFromButton2(component, event, helper);
                } else {
                   
                    console.log("else Unknown error");
                    
                    component.find("reactSubmitBtn").set("v.disabled", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration" : 6000
                                         });
                    toastEvent.fire();
                }
            } else {
                
                component.find("reactSubmitBtn").set("v.disabled", false);
                var errors = a.getError();
                console.log(errors);
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
          component.set("v.isResidential", true);
        
        
         $A.util.addClass(changeElementResidential, 'slds-show');
         $A.util.removeClass(changeElementResidential, 'slds-hide');
        
         $A.util.addClass(addInd, 'slds-show');
         $A.util.removeClass(addInd, 'slds-hide');
        
         $A.util.addClass(changeElementBusiness, 'slds-hide');
         $A.util.removeClass(changeElementBusiness, 'slds-show');
        
         $A.util.addClass(addBiz, 'slds-hide');
         $A.util.removeClass(addBiz, 'slds-show');
    },
    
    onChangeBusinessHelper : function(component, event, helper) {
         var changeElementResidential = component.find("cmpTabDiv2Residential");
         var changeElementBusiness    = component.find("cmpTabDiv2Business");
        
         var addInd    = component.find("addInd");
         var addBiz    = component.find("addBiz");
        
         component.set("v.appForResAndBusReact", true);
         //component.set("v.isResidential", true);
        
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
        var stepNumber = component.get("v.stepNumber");  
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;
        var tabDisplay = activeTabNumber;
        var selectedService = component.get("v.appForResAndBusReact")
        var classId = "mark";
        var actClassId = classId + clickedTab;
        var deactClassId = classId + activeTabNumber;
        
        var isSame = component.get("v.isSame"); 
        
        var mark1 = component.find("mark1");
        var mark2 = component.find("mark2");
        var mark3 = component.find("mark3");
        var mark4 = component.find("mark4");
        var mark5 = component.find("mark5");

        if(component.get("v.hasSubmitted")){
            return;
        }
       

        if(activeTabNumber == '1') {
            
            if(clickedTab > activeTabNumber){
                hasError = helper.validateTab1(component, event, helper);
            }
            
            if(!hasError) {
                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
               
                $A.util.addClass(activateClassId, "slds-is-active");
                
                 if(activeTabNumber < clickedTab && stepNumber < clickedTab){
                    component.set("v.stepNumber", 2);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                if(clickedTab == 2 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   component.set("v.isDisabledReactTab3", false);
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   $A.util.addClass(mark3, "slds-is-active"); 
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   $A.util.addClass(mark3, "slds-is-active"); 
                   $A.util.addClass(mark4, "slds-is-active");
                }

                tabDisplay = clickedTab;
            }
        }else if(activeTabNumber == '2' && selectedService == false) {
            
            if(clickedTab > activeTabNumber){
                hasError = helper.validateTab2Residential(component, event, helper);
            }
            
            if(!hasError) {
                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
             
                $A.util.addClass(activateClassId, "slds-is-active");
                
                 if(activeTabNumber < clickedTab && stepNumber < clickedTab){
                    component.set("v.stepNumber", 3);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                 if(clickedTab == 2 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   $A.util.addClass(mark3, "slds-is-active"); 
                    component.set("v.isDisabledReactTab4", false);
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   $A.util.addClass(mark3, "slds-is-active"); 
                   $A.util.addClass(mark4, "slds-is-active");
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(mark2, "slds-is-active"); 
                   
                }
                
                
                
                tabDisplay = clickedTab;
            }
        }
        
        else if(activeTabNumber == '2' && selectedService == true) {

            if(clickedTab > activeTabNumber){
                hasError = helper.validateTab2Business(component, event, helper);
            }
            
            if(!hasError) {
                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
                
                $A.util.addClass(activateClassId, "slds-is-active");
                
                 if(activeTabNumber < clickedTab && stepNumber < clickedTab){
                    component.set("v.stepNumber", 3);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                 if(clickedTab == 2 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   $A.util.addClass(mark3, "slds-is-active"); 
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(mark2, "slds-is-active"); 
                   $A.util.addClass(mark3, "slds-is-active"); 
                   $A.util.addClass(mark4, "slds-is-active");
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(mark2, "slds-is-active"); 
                   
                }

                tabDisplay = clickedTab;
            }
           
        }else if(activeTabNumber == '3') {
			
            if(isSame == false){
 				
                if(clickedTab > activeTabNumber){
                    hasError = helper.validateTab3(component, event, helper);
                }

                if(!hasError) {
                    
                    var activateClassId = component.find(actClassId);
                    var deactivateClassId = component.find(deactClassId);
                    
                    $A.util.addClass(activateClassId, "slds-is-active");
                    
                    if(activeTabNumber < clickedTab && stepNumber < clickedTab){
                        component.set("v.stepNumber", 4);
                    }
                    
                    if(activeTabNumber > clickedTab){
                        $A.util.removeClass(deactivateClassId, "slds-is-active");
                    }
                    
                    if(clickedTab == 2){
                        
                        $A.util.removeClass(mark3, "slds-is-active"); 
                    }
                    
                    if(clickedTab == 1){
                        $A.util.removeClass(mark3, "slds-is-active"); 
                        $A.util.removeClass(mark2, "slds-is-active"); 
                    }
                    tabDisplay = clickedTab;
                }

            }else{

            var activateClassId = component.find(actClassId);
            var deactivateClassId = component.find(deactClassId);
            
            $A.util.addClass(activateClassId, "slds-is-active");
            
            if(activeTabNumber < clickedTab && stepNumber < clickedTab){
                component.set("v.stepNumber", 4);
            }
            
            if(activeTabNumber > clickedTab){
                $A.util.removeClass(deactivateClassId, "slds-is-active");
            }
            
            if(clickedTab == 2){
                
                $A.util.removeClass(mark3, "slds-is-active"); 
            }
            
            if(clickedTab == 1){
                $A.util.removeClass(mark3, "slds-is-active"); 
                $A.util.removeClass(mark2, "slds-is-active"); 
            }
            tabDisplay = clickedTab;
            }   
        }else if(activeTabNumber == '4') {

                var activateClassId = component.find(actClassId);
                var deactivateClassId = component.find(deactClassId);
             
                $A.util.addClass(activateClassId, "slds-is-active");
                
                if(activeTabNumber < clickedTab && stepNumber < clickedTab){
                    component.set("v.stepNumber", 5);
                }
                
                if(activeTabNumber > clickedTab){
                    $A.util.removeClass(deactivateClassId, "slds-is-active");
                }
                
                if(clickedTab == 3){
                    
                    $A.util.removeClass(mark4, "slds-is-active"); 
                }
                
                if(clickedTab == 2){
                    
                    $A.util.removeClass(mark4, "slds-is-active"); 
                    $A.util.removeClass(mark3, "slds-is-active"); 
                }
                
                if(clickedTab == 1){
                    
                    $A.util.removeClass(mark4, "slds-is-active"); 
                    $A.util.removeClass(mark3, "slds-is-active"); 
                    $A.util.removeClass(mark2, "slds-is-active");
                }
                
                tabDisplay = clickedTab;
            
           
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

        var cmpTarget = "conIndReactivateForm" + auraId;
        $A.util.removeClass(component.find(cmpTarget), "slds-show");
        $A.util.addClass(component.find(cmpTarget), "slds-hide");
    },
    
    showTab : function(component, auraId) {

        var cmpTarget = "conIndReactivateForm" + auraId;
       
        $A.util.addClass(component.find(cmpTarget), "slds-show");
        $A.util.removeClass(component.find(cmpTarget), "slds-hide");
    },


})