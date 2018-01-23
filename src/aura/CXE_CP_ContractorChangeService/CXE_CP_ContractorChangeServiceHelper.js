({
	initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseRecord", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },
    
    getServiceModificationOptions : function(component, event, helper){
        var action = component.get("c.getServiceModificationsContractor");
        action.setCallback(this, function(response) {
            var state = response.getState();
          
            if(state == "SUCCESS"){
                var pickListHolderService = response.getReturnValue();
                console.log('Mike_pickListHolder: '+pickListHolderService);

                //alert(pickListHolder.pop(4)); 
                
                var popRelocate = pickListHolderService.pop(4);
                var popRemodel = pickListHolderService.pop(3);
                
                pickListHolderService.push(popRelocate);
                pickListHolderService.push(popRemodel);
                
                //component.set("v.serviceModifications", response.getReturnValue());
                component.set("v.serviceModifications", pickListHolderService);
                
            } else {
                console.log('>>>>>>>>>>>>>>>>>> something went wrong.');
            }
        });
        
        $A.enqueueAction(action);
    },

    getContractModificationOptions : function(component, event, helper) {
        var action = component.get("c.getContractModificationsContractor");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var pickListHolderContract = response.getReturnValue();
                console.log('pickListHolderContract: '+pickListHolderContract);
                
                var popUpdate = pickListHolderContract.pop(2);
                var popChange = pickListHolderContract.pop(1);
                
                pickListHolderContract.push(popUpdate);
                 pickListHolderContract.push(popChange);
                 
               
                //component.set("v.contractModifications", response.getReturnValue());
                
                component.set("v.contractModifications", pickListHolderContract);
                
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
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.toggleClass(component.find(cmpTarget), "slds-show");
        $A.util.toggleClass(component.find(cmpTarget), "slds-hide");
    },
    
    validateTab1 : function(component, event, helper) {
        
        var list;
        var isServiceMod = component.get("v.isServiceMod");
        var persona = component.get("v.persona");
		
        if(!isServiceMod) {
          
                list = ["contractorSIN","con_firstname", "con_lastname", "con_emailAddress", "con_mobileNumber"];

        } else {
            
                list = ["contractorSIN"];
        }
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        
        return hasError;
    },
    
    validateTab2 : function(component, event, helper) {
        var list;
        list = ["con_fname_t2", "con_lname_t2", "con_company_t2", "con_pEmail_t2", "con_mobile_t2"];
        
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },
    
    hasErrorOnFieldList: function(component, helper, list) {
        var ctr = 0;
		
        if(helper.hasNoServiceRequest(component, helper)) {
            
            ctr++;
        }

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
        // var regexLandlineFormat = /(\+632)[0-9]{7}/;
        var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/;
        // var errorMessage = "Please input your landline in the format +632XXXXXXX.";
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
        if(auraId === "con_emailAddress"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "con_pEmail_t2"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "con_mobileNumber"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
        
         if(auraId === "con_mobile_t2"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }

        if(auraId === "businessLandline"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
        return isInvalid;
    },
    
    hasNoServiceRequest : function (component, helper) {
       
        var serviceReq = component.get("v.caseRecord.CXE_Service_Request_s__c");
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
     
       // $A.util.removeClass(currentActive[0], "slds-is-active");

       //$A.util.addClass(setActiveTab[0], "slds-is-active");
       //
       var classId = "marks";
        var actClassId = classId + activeTab;
      
        var activateClassId = component.find(actClassId);
      
        $A.util.addClass(activateClassId, "slds-is-active");

        helper.toggleTab(component, activeTab);
        helper.toggleTab(component, deactivateTab);
    },
    
    displayTabFromButton2 : function(component, event, helper) {
       
        var className = "slds-progress__item ";
        var activeTab = 4;
        var deactivateTab = activeTab - 1;
        var activateClassName = className + activeTab;
        var deactiveClassName = className + deactivateTab;

        var currentActive = document.getElementsByClassName(deactiveClassName);
       
        var setActiveTab = document.getElementsByClassName(activateClassName);
     
       // $A.util.removeClass(currentActive[0], "slds-is-active");

        $A.util.addClass(setActiveTab[0], "slds-is-active");

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
    
    submitModify : function(component, event, helper) {
     	var tabName = 4;
        helper.toggleSpinner(component, event, helper);
        component.set("v.caseRecord.Application_Type_Subtype__c", "Modification of Electric Service");
        var caseRec = component.get("v.caseRecord");
                
        var action = component.get("c.submitServiceApplication");

        console.log(caseRec);
        
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
				
                    component.set("v.caseId", response.caseRecordId);
                    //component.find("fileUploadCmp1").uploadFile(response.caseRecordId);
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    console.log('v.caseRecord.CaseNumber: >>>>>>>>>>>>>>>>>>> '+ response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseRecordAccountName", response.caseRecord.Account.Name);
                    
                    
                    
                    console.log('response.caseRecord: >>>>>>>>>>>>>>>>>>> '+ response.caseRecord);
                    console.log('response_Mike: >>>>>>>>>>>>>>>>>>> '+ JSON.stringify(response));
                    //helper.displaySpecific(component, event, helper, "5");

                    component.set("v.stepNumber", tabName);
            		helper.displayTabFromButton2(component, event, helper);
                    
                } else {
                  
                   
                    //helper.toggleSpinner(component, event, helper);
                    //component.find("modifySubmitBtn").set("v.disabled", false);
                    // helper.pushEvent(component, "4");
                    // helper.toggleSpinner(component, event, helper);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "error",
                                          "duration" : 6000
                                         });
                    toastEvent.fire();
                }
            } else {
               
                
                component.find("modifySubmitBtn").set("v.disabled", false);
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
                    // helper.toggleSpinner(component, event, helper);
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
   
   displayTab : function(component, event, helper, auraId) {  

        var activeTabNumber = component.get("v.activeTabNumber");   
        var stepNumber = component.get("v.stepNumber");
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;
        var tabDisplay = activeTabNumber;
        var selectedService = component.get("v.appForResAndBusReact")
        var classId = "marks";
        var actClassId = classId + clickedTab;
        var deactClassId = classId + activeTabNumber;
        var isSame = component.get("v.isSame"); 
        var marks1 = component.find("marks1");
        var marks2 = component.find("marks2");
        var marks3 = component.find("marks3");
        var marks4 = component.find("marks4");
        var marks5 = component.find("marks5");

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
                   $A.util.addClass(marks2, "slds-is-active"); 
                   component.set("v.isDisabledModTab3", false);
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
            
            if(clickedTab > activeTabNumber){
                hasError = helper.validateTab2(component, event, helper);
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
        }
        
        else if(activeTabNumber == '3') {

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
                        
                        $A.util.removeClass(marks3, "slds-is-active"); 
                    }
                    
                    if(clickedTab == 1){
                        $A.util.removeClass(marks3, "slds-is-active"); 
                        $A.util.removeClass(marks2, "slds-is-active"); 
                    }
                    tabDisplay = clickedTab;
                

            tabDisplay = clickedTab;
            
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
                    
                    $A.util.removeClass(marks4, "slds-is-active"); 
                }
                
                if(clickedTab == 2){
                    
                    $A.util.removeClass(marks4, "slds-is-active"); 
                    $A.util.removeClass(marks3, "slds-is-active"); 
                }
                
                if(clickedTab == 1){
                    
                    $A.util.removeClass(marks4, "slds-is-active"); 
                    $A.util.removeClass(marks3, "slds-is-active"); 
                    $A.util.removeClass(marks2, "slds-is-active");
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
        
        //$A.util.removeClass(currentActive[0], "slds-is-active");
        
        $A.util.addClass(setActiveTab[0], "slds-is-active");
        
        helper.hideTab(component, component.get("v.activeTabNumber"));
        helper.showTab(component, target);
        
        
        component.set("v.activeTabNumber", target);
        component.set("v.tabToShow", target);        
    },
    
    hideTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
        $A.util.removeClass(component.find(cmpTarget), "slds-show");
        $A.util.addClass(component.find(cmpTarget), "slds-hide");
    },
    
    showTab : function(component, auraId) {
        var cmpTarget = "cmpTabDiv" + auraId;
       
        $A.util.addClass(component.find(cmpTarget), "slds-show");
        $A.util.removeClass(component.find(cmpTarget), "slds-hide");
    },

})