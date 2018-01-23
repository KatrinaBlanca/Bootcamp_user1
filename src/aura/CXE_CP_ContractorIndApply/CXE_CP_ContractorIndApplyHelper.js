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
            component.set("v.caseRecord", a.getReturnValue());
        });
        $A.enqueueAction(initAction);
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
    
    displaySpecific2 : function(component, event, helper, target) {
        
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

    

    displayTabByButton : function(component, event, helper) {
        var activeTabNumber = component.get("v.activeTabNumber");
        var activeTabNumber2 = parseInt(activeTabNumber) + 1;
        var stepNumber = component.get("v.stepNumber");
        var hasError = false; 
        var selectedService = component.get("v.appForResAndBusStart")
        var tabDisplay = activeTabNumber;
        var flag = false;
        var classId = "marker";
        var isSame = component.get("v.isSame");
        
        if(component.get("v.hasSubmitted")){
            return;
        }
        
        if(activeTabNumber == '1') {
           
            hasError = helper.validateTab1(component, event, helper);
            if(!hasError) {
                
                var classNumber = parseInt(activeTabNumber) + 1;
                var actClassId = classId + classNumber;
                var activateClassId = component.find(actClassId);
                
                $A.util.addClass(activateClassId, "slds-is-active");
               
                tabDisplay = +activeTabNumber + 1;
                
                
                if(activeTabNumber < activeTabNumber2 && stepNumber < activeTabNumber2){
                   component.set("v.isDisabledTab3", false);
                   component.set("v.stepNumber", 2);
                }
                
                //component.set("v.stepNumber", activeTabNumber + 1);
              
                
            }
           
        } 
        if(activeTabNumber == '2' && selectedService == false) {
           
            hasError = helper.validateTab2Residential(component, event, helper);
            if(!hasError) {
                
                var classNumber = parseInt(activeTabNumber) + 1;
                var actClassId = classId + classNumber;
                var activateClassId = component.find(actClassId);

                $A.util.addClass(activateClassId, "slds-is-active");
          
                tabDisplay = +activeTabNumber + 1;
                
                if(activeTabNumber < activeTabNumber2 && stepNumber < activeTabNumber2){
                   component.set("v.isDisabledTab4", false);
                   component.set("v.stepNumber", 3);
                }
            }
           
        }
    
        
        if(activeTabNumber == '2' && selectedService == true) {
            hasError = helper.validateTab2Business(component, event, helper);
            if(!hasError) {
                
                var classNumber = parseInt(activeTabNumber) + 1;
                var actClassId = classId + classNumber;
                var activateClassId = component.find(actClassId);
                
                $A.util.addClass(activateClassId, "slds-is-active");
                
                tabDisplay = +activeTabNumber + 1;
                
                if(activeTabNumber < activeTabNumber2 && stepNumber < activeTabNumber2){
                   component.set("v.isDisabledTab3", false);
                   component.set("v.stepNumber", 3);
                }
            }
           
        }
        
        if(activeTabNumber == '3') {
			
            hasError = helper.validateTab3(component, event, helper);

            if(!hasError) {
                var classNumber = parseInt(activeTabNumber) + 1;
                var actClassId = classId + classNumber;
                var activateClassId = component.find(actClassId);
                
                $A.util.addClass(activateClassId, "slds-is-active");
                
                tabDisplay = +activeTabNumber + 1;
                
                if(activeTabNumber < activeTabNumber2 && stepNumber < activeTabNumber2){
                    component.set("v.isDisabledTab4", false);
                    component.set("v.stepNumber", 4);
                }
            }
        }
        
        if(activeTabNumber == '4') {
        
                var classNumber = parseInt(activeTabNumber) + 1;
                var actClassId = classId + classNumber;
                var activateClassId = component.find(actClassId);
               
                $A.util.addClass(activateClassId, "slds-is-active");
                
                tabDisplay = +activeTabNumber + 1;
                
                if(activeTabNumber < activeTabNumber2 && stepNumber < activeTabNumber2){
                   
                   component.set("v.stepNumber", 5);
                }
  
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
    
            list = ["con_fname", "con_lname","con_pEmail", "con_mobile", "con_contractorName"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);
        return hasError;
    },
    
     validateTab2Residential : function(component, event, helper) {

        var list;
        var conRes_landline       = component.find("conRes_landline").get("v.value");
        var conRes_birthday       = component.find("dateField").get("v.value");
        var conRes_pEmail       = component.find("conRes_pEmail").get("v.value"); //CSM-14438 Mike Verdad 11/14/2017
      
            list = ["conRes_fname", "conRes_lname", "conRes_pEmail","dateField", "conRes_mobileTab2"]; //CSM-14440 Mike Verdad 11/14/2017 added "dateField" in the list
         	
        var hasError = this.hasErrorOnFieldList(component, helper, list);
        
         if (!$A.util.isEmpty(conRes_landline)){ 
            var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/; //CSM-14453 Mike Verdad 11/14/2017
            var isValid = false;
            
            if(!conRes_landline.match(regexLandlineFormat)){
                var sampp = component.find("conRes_landline");             
                    sampp.set("v.errors", [{message:($A.get("$Label.c.LandlineValidationErrorMsg"))}]); 
                hasError = true;
            }
        }
        
         if (!$A.util.isEmpty(conRes_birthday)){  
             var date = conRes_birthday;
             var varDate = new Date(date); //dd-mm-YYYY
             var today = new Date();
             
             if(varDate >= today) {
                 var sampp = component.find("dateField");             
                 sampp.set("v.errors", [{message:($A.get("$Label.c.BirthdateValidationErrorMsg"))}]);   
                 hasError = true;
             }
         }
         //Start CSM-14438 Mike Verdad 11/14/2017
         if (!$A.util.isEmpty(conRes_pEmail)){  
             
             var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
             var errorMessage = $A.get("$Label.c.ValidEmailErrorMessage");
             
             if(!conRes_pEmail.match(regExpEmailformat)){
                 var conRes_pEmailErr = component.find("conRes_pEmail");             
                     conRes_pEmailErr.set("v.errors", [{message:($A.get("$Label.c.ValidEmailErrorMessage"))}]); 
                 hasError = true;
             } 
         }
 		 //End CSM-14438 Mike Verdad 11/14/2017
        return hasError;
    },
    
   
    validateTab2Business : function(component, event, helper) {
		var conBus_companyEmailBusiness       = component.find("conBus_companyEmailBusiness").get("v.value");
        var list;
    
            list = ["conBus_companyNameBusiness", "conBus_companyEmailBusiness", "conBus_landlineBusiness"];

        var hasError = this.hasErrorOnFieldList(component, helper, list);
        
        if (!$A.util.isEmpty(conBus_companyEmailBusiness)){ 
            var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
            
            if(!conBus_companyEmailBusiness.match(regExpEmailformat)){
                var emailBus = component.find("conBus_companyEmailBusiness");             
                    emailBus.set("v.errors", [{message:($A.get("$Label.c.ValidEmailErrorMessage"))}]);   
                hasError = true;
            }
        }
        
        return hasError;
    },
    
    validateTab3 : function(component, event, helper) {
        
        var isResidential = component.get("v.isResidential");
		var isSame = component.get("v.isSame");
        var list;
        

        if(isSame == true){

            list = ["newContractorServiceAddress"]; 
            var hasError = this.hasErrorOnFieldList(component, helper, list);
            
            if(isResidential == true){
               var ind_homeowneship = component.find("ind_homeowneship").get("v.value");  
            }
            
            
            var provincePicklistValueService = component.get("v.caseRecord.Service_Address_Province__c");
            var dependentPicklistValueService = component.get("v.caseRecord.Service_Address_City_Municiple__c");

            component.set("v.isNextClickedStart",true); 
            component.set("v.isNextClickedStart2",true); 
            
            if(((($A.util.isUndefined(provincePicklistValueService)) || ($A.util.isUndefined(dependentPicklistValueService))) || provincePicklistValueService == 'Select One') || dependentPicklistValueService == 'Select One'){

                hasError = true;  
            }
            
            if(ind_homeowneship == 'Select One'){
                var errMsg = component.find("ind_homeowneship");             
                errMsg.set("v.errors", [{message: "Please indicate your Home Ownership."}]);  
                hasError = true; 
                
            }
              return hasError;
            
        }else{

            list = ["newContractorServiceAddress", "newBusinessBillingAddress"]; 
            var hasError = this.hasErrorOnFieldList(component, helper, list);
            var provincePicklistValueService = component.get("v.caseRecord.Service_Address_Province__c");
            var dependentPicklistValueService = component.get("v.caseRecord.Service_Address_City_Municiple__c");
            var provincePicklistValue = component.get("v.provincePicklistValue");
            var dependentPicklistValue = component.get("v.caseRecord.Billing_Address_City_Municipal__c");
            component.set("v.isNextClickedStart",true); 
            component.set("v.isNextClickedStart2",true);  

            if(((($A.util.isUndefined(provincePicklistValue)) || ($A.util.isUndefined(dependentPicklistValue))) || provincePicklistValue == 'Select One') || dependentPicklistValue == 'Select One'){
                hasError = true;  
            }
              return hasError;
        }

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
        var error = cmpTarget.get("v.value");
        if($A.util.isEmpty(cmpTarget.get("v.value")) || $A.util.isUndefined(cmpTarget.get("v.value"))){            
            cmpTarget.set("v.errors", [{message:($A.get("$Label.c.PleaseIndicateField")+ " ") + cmpTarget.get("v.label") + "."}]);
            return true;        
        } else {
            cmpTarget.set("v.errors",null);
            return false;
        }
    },    

    hasInvalidEmailFormat : function (cmpTarget) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var errorMessage = $A.get("$Label.c.ValidEmailErrorMessage");
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
        var errorMessage = $A.get("$Label.c.MobileNumFormatErrorMsg"); 
        if(!cmpTarget.get("v.value").match(regexMobileFormat)){
            cmpTarget.set("v.errors", [{message:errorMessage}]);
            return true;
        } else {
            cmpTarget.set("v.errors", null);
            return false;
        }
    },

    hasInvalidLandlineFormat : function (cmpTarget) {
        var regexLandlineFormat = /(\+63)[0-9]?[0-9]{8}/; //CSM-14453 Mike Verdad 11/14/2017
        var errorMessage = $A.get("$Label.c.LandlineFormatErrorMsg");  
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
        var errorMessage = $A.get("$Label.c.BirthdateValidationErrorMsg");
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
 
        var arg = {
            fname: component.get("v.caseRecord.CXE_Web_First_Name__c")
            , mname: component.get("v.caseRecord.CXE_Web_Middle_Name__c")
            , lname: component.get("v.caseRecord.CXE_Web_Last_Name__c")
            , email: component.get("v.caseRecord.CXE_Web_Primary_Email__c")
            , mobile: component.get("v.caseRecord.CXE_Web_Primary_Mobile__c")
            , phone: component.get("v.caseRecord.CXE_Web_Primary_Phone__c")
            , birthday: component.get("v.caseRecord.CXE_Web_Date_of_Birth__c")
        }
        console.log(arg);
        
        helper.toggleSpinner(component, event, helper);
       
        if(component.get("v.appForResAndBusStart") == true) {
			
            component.set("v.caseRecord.Tax_Identification_No__c", $A.get("$Label.c.TINValue")); 
            component.set("v.caseRecord.Application_for_Business_Service__c", true);
            component.set("v.caseRecord.Application_for_Business_Customer__c", true);

            var bizEmail = component.get("v.caseRecord.CXE_Web_Business_Primary_Email__c");
            component.set("v.caseRecord.Business_Email__c", bizEmail);
            console.log('>>bizEmail: ' + bizEmail);

        }
        else{ 
           
            component.set("v.caseRecord.Application_for_Residential_Service__c", true);
            component.set("v.caseRecord.Application_for_Residential_Customer__c", true);
            component.set("v.caseRecord.First_Name__c", arg.fname);
            component.set("v.caseRecord.Middle_Name__c", arg.mname);
            component.set("v.caseRecord.Last_Name__c", arg.lname);
            component.set("v.caseRecord.Email_Address__c", arg.email);
            component.set("v.caseRecord.Mobile_No__c", arg.mobile);
            component.set("v.caseRecord.Telephone_No__c", arg.phone);
            component.set("v.caseRecord.Date_of_Birth__c", arg.birthday);
            component.set("v.caseRecord.Individual_Email__c", arg.email);//START/END CSM-12544
            console.log('>> indEmail: ' + component.get("v.caseRecord.Individual_Email__c"));
        }
		
        component.set("v.caseRecord.Application_Type_Subtype__c", "New Electric Service");
        
        var caseRecord = component.get("v.caseRecord");
        
        var action = component.get("c.submitServiceApplication");
       

        action.setParams({
            "jsonCaseApplication": JSON.stringify(caseRecord),
            "serviceApplicationType": "New_Service_Application"
        });
       
        action.setCallback(this, function(a) {
           
            var state = a.getState();

            helper.toggleSpinner(component, event, helper);
          
            if(state == "SUCCESS"){
                
                var response = a.getReturnValue();

                console.log("RESPONSE", response);

                if (!response.hasError) {
					
                    component.set("v.caseRecord.CaseNumber", response.caseNumber);
                    component.set("v.hasSubmitted", true);
                    component.set("v.caseId", response.caseRecordId);

                     	var classId = "marker";
                        var tabDisplay      = 4;
                        var activeTabNumber = 4;
                        var classNumber = activeTabNumber + 1;
                        var actClassId = classId + classNumber;
                        var activateClassId = component.find(actClassId);

                        $A.util.addClass(activateClassId, "slds-is-active");

                        tabDisplay = +activeTabNumber + 1;
                        component.set("v.stepNumber", activeTabNumber + 1);
                  
                       
                        
                    
                    
                    helper.displaySpecific(component, event, helper, tabDisplay);
                } 
                else {
					
                    //helper.toggleSpinner(component, event, helper);
                    component.find("termsACButton").set("v.disabled", false);
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
        
         component.set("v.appForResAndBusStart", false);
        
         $A.util.addClass(changeElementResidential, 'slds-show');
         $A.util.removeClass(changeElementResidential, 'slds-hide');
        
         $A.util.addClass(changeElementBusiness, 'slds-hide');
         $A.util.removeClass(changeElementBusiness, 'slds-show');
    },
    
    onChangeBusinessHelper : function(component, event, helper) {
       
         var changeElementResidential = component.find("cmpTabDiv2Residential");
         var changeElementBusiness    = component.find("cmpTabDiv2Business");
        
         component.set("v.appForResAndBusStart", true);
        
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
    },
    
   
    
    displayTab : function(component, event, helper, auraId) {        
        var activeTabNumber = component.get("v.activeTabNumber");  
        var stepNumber = component.get("v.stepNumber");  
        var hasError = false;
        var clickedTab = event.currentTarget.dataset.auraId;
        var tabDisplay = activeTabNumber;
        var selectedService = component.get("v.appForResAndBusStart")
        var classId = "marker";
        var actClassId = classId + clickedTab;
        var deactClassId = classId + activeTabNumber;
        
        var marker1 = component.find("marker1");
        var marker2 = component.find("marker2");
        var marker3 = component.find("marker3");
        var marker4 = component.find("marker4");
        var marker5 = component.find("marker5");
        
        var clickedTab = event.currentTarget.dataset.auraId;
        
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
                   $A.util.addClass(marker2, "slds-is-active"); 
                   component.set("v.isDisabledTab3", false);
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(marker2, "slds-is-active"); 
                   $A.util.addClass(marker3, "slds-is-active"); 
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(marker2, "slds-is-active"); 
                   $A.util.addClass(marker3, "slds-is-active"); 
                   $A.util.addClass(marker4, "slds-is-active");
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
                   $A.util.addClass(marker2, "slds-is-active"); 
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(marker2, "slds-is-active"); 
                   $A.util.addClass(marker3, "slds-is-active"); 
                    component.set("v.isDisabledTab4", false);
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(marker2, "slds-is-active"); 
                   $A.util.addClass(marker3, "slds-is-active"); 
                   $A.util.addClass(marker4, "slds-is-active");
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(marker2, "slds-is-active"); 
                   
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
                   $A.util.addClass(marker2, "slds-is-active"); 
                }
                
                if(clickedTab == 3 && clickedTab > activeTabNumber){
                   $A.util.addClass(marker2, "slds-is-active"); 
                   $A.util.addClass(marker3, "slds-is-active"); 
                }
                
                if(clickedTab == 4 && clickedTab > activeTabNumber){
                   $A.util.addClass(marker2, "slds-is-active"); 
                   $A.util.addClass(marker3, "slds-is-active"); 
                   $A.util.addClass(marker4, "slds-is-active");
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(marker2, "slds-is-active"); 
                   
                }

                tabDisplay = clickedTab;
            }
           
        }else if(activeTabNumber == '3') {
            
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
                    var marker1 = component.find("marker1");
                    var marker2 = component.find("marker2");
                    var marker3 = component.find("marker3");
                    var marker4 = component.find("marker4");
                    var marker5 = component.find("marker5");
                    $A.util.removeClass(marker3, "slds-is-active"); 
                }
                
                if(clickedTab == 1){
                   $A.util.removeClass(marker3, "slds-is-active"); 
                   $A.util.removeClass(marker2, "slds-is-active"); 
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
                    
                    $A.util.removeClass(marker4, "slds-is-active"); 
                }
                
                if(clickedTab == 2){
                    
                    $A.util.removeClass(marker4, "slds-is-active"); 
                    $A.util.removeClass(marker3, "slds-is-active"); 
                }
                
                if(clickedTab == 1){
                    
                    $A.util.removeClass(marker4, "slds-is-active"); 
                    $A.util.removeClass(marker3, "slds-is-active"); 
                    $A.util.removeClass(marker2, "slds-is-active");
                }
                
                tabDisplay = clickedTab;

        }else {
            tabDisplay = clickedTab;
        }

        helper.displaySpecific(component, event, helper, tabDisplay);
             
    },
    
    goToHomePage : function(component, event, helper) {
        var pageUrl = window.location.href;
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": pageUrl
        });
        urlEvent.fire();	
	},
    
    
    onSelectChangeHelper : function(component, event, helper) {
        
        var ownershipErrorMsg = component.find("ind_homeowneship");             
        ownershipErrorMsg.set("v.errors", null);   
        
    },
   
})