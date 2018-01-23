({
    checkLockTab : function(component, event, helper, compName) {       
        var tabNumLock = component.get("v.tabNumLock");
        var tabNumAvailable = component.get("v.tabNumAvailable");
   
        if(tabNumAvailable<tabNumLock){
            var childCmp = component.find(compName);
            childCmp.submitTab(component, event, helper);
        }
    },

    initializeCase : function(component, event, helper) {
        var initAction = component.get("c.initNewCase");
        initAction.setCallback(self, function(a) {
            component.set("v.caseVar", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
    },

    
    displaySpecific : function(component, event, helper, target) {
        
        var className = "start-tab-con-";
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

    displayTab : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");  
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;
        var tabDisplay = activeTabNumber;
        var selectedService = component.get("v.appForResAndBus")
       
        if(component.get("v.hasSubmitted")){
            return;
        }

        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                tabDisplay = clickedTab;
            }
        }else if(activeTabNumber == '2' && selectedService == false) {
            hasError = helper.validateTab2Residential(component, event, helper);
            if(!hasError) {
               tabDisplay = clickedTab;
            }
        }
        
        else if(activeTabNumber == '2' && selectedService == true) {
            hasError = helper.validateTab2Business(component, event, helper);
            if(!hasError) {
               
                tabDisplay = clickedTab;
            }
           
        }else if(activeTabNumber == '3') {
            hasError = helper.validateTab3(component, event, helper);
            if(!hasError) {
               
                tabDisplay = clickedTab;
            }
           
        }else {
            tabDisplay = clickedTab;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
             
    },

    displayTabByButton : function(component, event, helper) {        
        var activeTabNumber = component.get("v.activeTabNumber");
        var hasError = false;
        
        var selectedService = component.get("v.appForResAndBus")
		
        var tabDisplay = activeTabNumber;
        
        var flag = false;
        
       
      
        if(component.get("v.hasSubmitted")){
            return;
        }
        
        if(activeTabNumber == '1') {
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
               
                flag = true;
                tabDisplay = +activeTabNumber + 1;
            }
           
        } 
        if(activeTabNumber == '2' && selectedService == false) {
            hasError = helper.validateTab2Residential(component, event, helper);
            if(!hasError) {
          
                tabDisplay = +activeTabNumber + 1;
            }
           
        }
        
        
        if(activeTabNumber == '2' && selectedService == true) {
            hasError = helper.validateTab2Business(component, event, helper);
            if(!hasError) {
              
                tabDisplay = +activeTabNumber + 1;
            }
           
        }
        
        if(activeTabNumber == '3') {
            hasError = helper.validateTab3(component, event, helper);
                if(!hasError) {
               
                tabDisplay = +activeTabNumber + 1;
            }
 
        }
        
        if(activeTabNumber == '4') {
        
                tabDisplay = +activeTabNumber + 1;
  
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
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

    validateTab1 : function(component, event, helper) {

        var list;
    
            list = ["con_fname", "con_lname", "con_pEmail", "con_mobile", "con_relationship"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },
    
     validateTab2Residential : function(component, event, helper) {

        var list;
        var conRes_landline       = component.find("conRes_landline").get("v.value");
        var conRes_birthday       = component.find("dateField").get("v.value");
      
            list = ["conRes_fname", "conRes_lname", "conRes_pEmail" ,"conRes_mobileTab2", "dateField"];
         	
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        
         if (!$A.util.isEmpty(conRes_landline)){ 
            var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/;
            var isValid = false;
            
            if(!conRes_landline.match(regexLandlineFormat)){
                var sampp = component.find("conRes_landline");             
                    sampp.set("v.errors", [{message:"Phone should start with +63 then followed by 1 to 2-digit area code and 7-digit number."}]);   
                hasError = true;
            }
        }
        if (!$A.util.isEmpty(conRes_birthday)){  
         var date = conRes_birthday;
         var varDate = new Date(date); //dd-mm-YYYY
         var today = new Date();
            
         if(varDate >= today) {
             var sampp = component.find("dateField");             
                    sampp.set("v.errors", [{message:"Birthdate cannot be future date."}]);   
             hasError = true;
         }
        }
 
        return hasError;
    },
    
   
    validateTab2Business : function(component, event, helper) {
		var conBus_companyEmailBusiness       = component.find("conBus_companyEmailBusiness").get("v.value");
        var list;
    
            list = ["conBus_companyNameBusiness", "conBus_landlineBusiness"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);
        
        if (!$A.util.isEmpty(conBus_companyEmailBusiness)){ 
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
            
            if(!conBus_companyEmailBusiness.match(regExpEmailformat)){
                var emailBus = component.find("conBus_companyEmailBusiness");             
                    emailBus.set("v.errors", [{message:"Please enter a valid email address."}]);   
                hasError = true;
            }
        }
        
        return hasError;
    },
    
    validateTab3 : function(component, event, helper) {
		
        var list;
        
         list = ["newContractorServiceAddress"];
    
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
        if(auraId === "con_pEmail"){
            isInvalid = this.hasInvalidEmailFormat(cmpTarget);
        }
        
        if(auraId === "con_mobile"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
		
        if(auraId === "conRes_mobileTab2"){
            isInvalid = this.hasInvalidMobileFormat(cmpTarget);
        }
       
       if(auraId === "conRes_landline"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
		
        if(auraId === "conBus_landlineBusiness"){
            isInvalid = this.hasInvalidLandlineFormat(cmpTarget);
        }
       
       if(auraId === "dateField"){
            if(!($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")))) {
                isInvalid = this.hasInvalidDate(cmpTarget);
            }
        }
       
       
        
        return isInvalid;
    },

    hasInvalidBirthday : function (cmpTarget) {
        var errorMessage = "You cannot select a future date as your Birthday.";
        var isUndefined = ($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value")));

        if(!isUndefined){
            var today = new Date();
            var bday = new Date(cmpTarget.get("v.value"));
            
            if(bday > today){
                cmpTarget.set("v.errors", [{message:errorMessage}]);
                return true;
            }else{
                return false;
            } 
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    showCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget, 'slds-show');
    },

    hideCmp : function(component, auraId) {
        var cmpTarget = component.find(auraId);
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget, 'slds-show');
    },

    submitStartService : function(component, event, helper) {
        
		var tabDisplay      = activeTabNumber;
        var activeTabNumber = component.get("v.activeTabNumber");
        
        var arg = {
            fname: component.get("v.caseVar.CXE_Web_First_Name__c")
            , mname: component.get("v.caseVar.CXE_Web_Middle_Name__c")
            , lname: component.get("v.caseVar.CXE_Web_Last_Name__c")
            , email: component.get("v.caseVar.CXE_Web_Primary_Email__c")
            , mobile: component.get("v.caseVar.CXE_Web_Primary_Mobile__c")
            , phone: component.get("v.caseVar.CXE_Web_Primary_Phone__c")
            , birthday: component.get("v.caseVar.CXE_Web_Date_of_Birth__c")
        }
        console.log(arg);
        
        helper.toggleSpinner(component, event, helper);
        
        if(component.get("v.appForResAndBus") == true) {

            component.set("v.caseVar.Tax_Identification_No__c", "000000000000");
            component.set("v.caseVar.Application_for_Business_Service__c", true);
            component.set("v.caseVar.Application_for_Business_Customer__c", true);

            var bizEmail = component.get("v.caseVar.CXE_Web_Business_Primary_Email__c");
            component.set("v.caseVar.Business_Email__c", bizEmail);
            console.log('>>bizEmail: ' + bizEmail);

        }
        else{ 
            
            component.set("v.caseVar.Application_for_Residential_Service__c", true);
            component.set("v.caseVar.Application_for_Residential_Customer__c", true);
            component.set("v.caseVar.First_Name__c", arg.fname);
            component.set("v.caseVar.Middle_Name__c", arg.mname);
            component.set("v.caseVar.Last_Name__c", arg.lname);
            component.set("v.caseVar.Email_Address__c", arg.email);
            component.set("v.caseVar.Mobile_No__c", arg.mobile);
            component.set("v.caseVar.Telephone_No__c", arg.phone);
            component.set("v.caseVar.Date_of_Birth__c", arg.birthday);
            component.set("v.caseVar.Individual_Email__c", arg.email);//START/END CSM-12544
            console.log('>> indEmail: ' + component.get("v.caseVar.Individual_Email__c"));
        }

        component.set("v.caseVar.Application_Type_Subtype__c", "New Electric Service");
        var caseRec = component.get("v.caseVar");
        var action = component.get("c.submitServiceApplication");

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRec),
            "serviceApplicationType": "New_Service_Application"
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            
          
             helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){
                var response = a.getReturnValue();

                console.log("RESPONSE", response);

                if (!response.hasError) {

                    component.set("v.caseVar.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseId", response.caseRecordId);
                
                    
                    if(activeTabNumber == '4') {
                        tabDisplay = +activeTabNumber + 1;     
                    }
                    
                    helper.displaySpecific(component, event, helper, tabDisplay);
                } 
                else {

                    helper.toggleSpinner(component, event, helper);
                    component.find("termsACBtn").set("v.disabled", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Please validate your application."
                        , "message": response.errorMessage
                        , "type": "error"
                        , "duration" : 6000
                    });
                    toastEvent.fire();
                }  
            } 
            else {
                
                component.find("termsACButton").set("v.disabled", false);
                
                var errors = a.getError();

                console.error(errors);
                
                if (!!errors[0] && errors[0].message) {

                    console.log("Error message: " + errors[0].message);

                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Please validate your application."
                        , "message": errors[0].message
                        , "type": "error"
                        , "duration" : 6000
                    });

                    toastEvent.fire();
                }               
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleSpinner : function(component, event, helper) {
        var cmpTarget = component.find("appSpinners");
        $A.util.toggleClass(cmpTarget, 'slds-hide');
        $A.util.toggleClass(component.find("progress_bars"), 'slds-hide');
    },

    toggleCollapse : function(component, event, secId) {
        var acc = component.find(secId);
        $A.util.toggleClass(acc, "show");
        $A.util.toggleClass(acc, "hide");
    },
    
    onChangeResidentialHelper : function(component, event, helper) {
         var changeElementResidential = component.find("cmpTabDiv2Residential");
         var changeElementBusiness    = component.find("cmpTabDiv2Business");
        
          component.set("v.appForResAndBus", false);
        
         $A.util.addClass(changeElementResidential, 'slds-show');
         $A.util.removeClass(changeElementResidential, 'slds-hide');
        
         $A.util.addClass(changeElementBusiness, 'slds-hide');
         $A.util.removeClass(changeElementBusiness, 'slds-show');
    },
    
    onChangeBusinessHelper : function(component, event, helper) {
         var changeElementResidential = component.find("cmpTabDiv2Residential");
         var changeElementBusiness    = component.find("cmpTabDiv2Business");
        
         component.set("v.appForResAndBus", true);
        
         $A.util.addClass(changeElementResidential, 'slds-hide');
         $A.util.removeClass(changeElementResidential, 'slds-show');
        
         $A.util.removeClass(changeElementBusiness, 'slds-hide');
         $A.util.addClass(changeElementBusiness, 'slds-show');
        
    },
    
    helperHideLandNumError: function(component, event, helper) {
        var fieldValue = component.find("conRes_landline").get("v.value");
        
        if($A.util.isEmpty(fieldValue)){
            var sampp = component.find("conRes_landline");
            sampp.set("v.errors", null);
        } else {
            var sampp = component.find("conRes_landline");
            sampp.set("v.errors", null);             
        }
        
    },
    
    hasInvalidDate : function (cmpTarget) {
        var errorMessage = "Please enter valid date.";
        var valid = true;
        var inputDate = cmpTarget.get("v.value");
        var d = new Date(inputDate);   
        if (Object.prototype.toString.call(d) === "[object Date]") {
            valid =!isNaN(d);            
        }else {
            valid = false;
        }
        
        if(!valid){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
        } else {
            cmpTarget.set("v.errors", null);
        }

        return !valid;
    }
    
    
})