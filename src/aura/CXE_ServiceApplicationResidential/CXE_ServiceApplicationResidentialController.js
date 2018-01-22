({
    doInit : function(component, event, helper) {    	
        var addressRec = component.get("v.addressRecord",true);
        var cmpTarget = component.find("CXE_serviceResidential-applyOnBehalf");
        $A.util.addClass(cmpTarget, 'slds-hide');    
        helper.getHomeOwnershipPicklistValues(component, event, helper);
        helper.getSalutations(component, event, helper);
	},
    
	makeFileList : function(component, event, helper) {
        //alert();
		helper.makeFileListHelper(component, event, helper);
	},
    
	toggleProxy : function(component, event, helper) {
        var cmpTarget = component.find("CXE_serviceResidential-applyOnBehalf");
        $A.util.toggleClass(cmpTarget, 'slds-hide');          
	}, 
    
    toggleAmcNotif : function(component, event, helper) {
        var cmpTarget = component.find("amc_notif");
        $A.util.toggleClass(cmpTarget, 'slds-hide');          
	}, 
    
    toggleSMS : function(component, event, helper) {        
        var caseRec = component.get("v.caseApplication");
        if(caseRec.Automatically_receive_SMS__c) {
			caseRec.Automatically_receive_SMS__c = false;
        } else {
            caseRec.Automatically_receive_SMS__c = true;
        }        
        component.set("v.caseApplication", caseRec);        
	},
    
    toggleEmail : function(component, event, helper) {        
        var caseRec = component.get("v.caseApplication");
        if(caseRec.Automatically_receive_an_e_mail__c) {
			caseRec.Automatically_receive_an_e_mail__c = false;
        } else {
            caseRec.Automatically_receive_an_e_mail__c = true;
        }        
        component.set("v.caseApplication", caseRec);        
	},
    
    isSameAsBilling : function (component, event, helper) {
        var caseRec = component.get("v.caseApplication");
        if(caseRec.Same_As_Service_Address__c) {
			caseRec.Same_As_Service_Address__c = false;
        } else {
            caseRec.Same_As_Service_Address__c = true;
        }        
        component.set("v.caseApplication", caseRec);
    },
    
    getCity : function(component, event, helper) {
        component.set('v.filterGroup', 'City');        
        helper.displaySearchModal(component, event, helper);     	
	},    
    
    searchAddress : function(component, event, helper) {    	
        //Get search value
    	var searchFilter = component.find("referenceSearch");
    	//Validate minimum characters for search filter
    	if(searchFilter.get("v.value").length>=3) {
            searchFilterValue = searchFilter.get("v.value");            
            helper.getAddressReference(component, event, helper, searchFilterValue);
    	} else {    		
    		component.set("v.searchResults", []);
    	}
    },
    
    closeSearchModal : function(component, event, helper) {    	
        //Clear search text and results
    	component.find("referenceSearch").set("v.value", "");
        component.set("v.searchResults", []);

    	helper.closeModalHelper(component, 'searchDiv');
    }, 
    
    mapValue : function(component, event, helper) {
    	//Get Id for lookup mapping
        
		var addressCityCmp = component.find('City');    
        addressCityCmp.set("v.value", event.currentTarget.dataset.name);
        var provinceCmp = component.find('Province');            
        provinceCmp.set("v.value", event.currentTarget.dataset.parentname);
        component.set('v.cityId', event.currentTarget.dataset.id);
        component.set("v.selectedCityParentCode", event.currentTarget.dataset.parentcode);
        component.set("v.provinceId", event.currentTarget.dataset.parentid); 
        
        
    	var searchValue = component.find("referenceSearch");
    	
    	searchValue.set("v.value", "");
        component.set("v.searchResults", []);
        
        //Close Search modal
    	helper.closeModalHelper(component, 'searchDiv');
        
    },
                
    onSubmit : function(component, event, helper) {
        helper.validateCaptcha(component, event, helper);
        
        helper.toggleSpinner(component, event, helper);
        
        var caseRec = component.get("v.caseApplication");
        
        var firstname = component.find("firstname").get("v.value"); 
        var middlename = component.find("middlename").get("v.value"); 
        var lastname = component.find("lastname").get("v.value");
        var birthdate = component.find("birthdate").get("v.value");
        var phone = component.find("phoneNumber").get("v.value");
        var mobile = component.find("mobileNumber").get("v.value");
        var email = component.find("emailAddress").get("v.value");
        
        var repFirstname = component.find("repFirstname").get("v.value"); 
        var repMiddlename = component.find("repMiddlename").get("v.value"); 
        var repLastname = component.find("repLastname").get("v.value");        
        var repPhone = component.find("primaryContactNumber").get("v.value");
        var repEmail = component.find("repEmailAddress").get("v.value");
        
        var addressString = component.find("unitBlockNumber").get("v.value");
        
        caseRec.First_Name__c = firstname;
        caseRec.Middle_Name__c = middlename;
        caseRec.Last_Name__c = lastname;
        caseRec.Date_of_Birth__c = birthdate;
        caseRec.Telephone_No__c = phone;
        caseRec.Mobile_No__c = mobile;
        caseRec.Email_Address__c = email;        
        
        caseRec.Authorized_Representative_First_Name__c = repFirstname;
        caseRec.Authorized_Representative_Middle_Name__c = repMiddlename;
        caseRec.Authorized_Representative_Last_Name__c = repLastname;
        caseRec.Authorized_Rep_Primary_Contact_Number__c = repPhone;
        caseRec.Authorized_Representative_Email__c = repEmail;
        
        caseRec.Application_for_Residential_Customer__c = true;
        
        caseRec.address_1__c = addressString;
        
        //caseRec.Service_Address_Street_Name__c = '';
        //caseRec.Service_Address_Subdivision__c = '';
        //caseRec.Service_Address_Unit_No__c = '';
        //caseRec.Service_Address_Barangay__c = '';
        //caseRec.Service_Address_City_Municiple__c = '';
        //caseRec.Service_Address_Province__c = '';
        console.log('>>>> ' + component.get('v.provinceId'));
        var addressRec = component.get("v.addressRecord");
        console.log('>>>> ' + JSON.stringify(addressRec));
        if(component.get('v.provinceId') != '' && component.get('v.cityId') != '') {
            addressRec.Address_Province__c = component.get('v.provinceId');
            addressRec.Address_City_Municipality__c = component.get('v.cityId');
            component.set("v.item",a);
        } else {
            addressRec = null;
        }
        
        var action = component.get("c.submitCaseApplication");    
        action.setParams({
            "caseApplication": caseRec,
            "addressRecord" : addressRec
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            helper.toggleSpinner(component, event, helper);
            if(state == "SUCCESS"){                 
				var response = a.getReturnValue();                
                if (!response.hasError) {
                    var evtCaseNumber = $A.get("e.c:CaseNumberEvent");
                    evtCaseNumber.setParams({ "caseNumber": response.caseNumber});
                    evtCaseNumber.fire();
                    
                    var cmpHide = "CXE_ServiceApplicationResidential";
                    var evtHide = $A.get("e.c:HideTargetComponentEvent");
                    evtHide.setParams({ "hideCmpTarget": cmpHide});
                    evtHide.fire();        
                    
                    var cmpShow = "CXE_ServiceApplicationResidentialThankYou";        
                    var evtShow = $A.get("e.c:ShowTargetComponentEvent");
                    evtShow.setParams({ "showCmpTarget": cmpShow});
                    evtShow.fire();
                    
                    helper.attachFile(component, response.caseRecordId);
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Please validate your application.",
                                          "message": response.errorMessage,
                                          "type": "Warning",
                                          "mode": "sticky"
                    });
                    toastEvent.fire();                    
                }
                
            } else {
                console.log('err >>>>>>>>>>>>>>>' + a.getReturnValue());
            }
        });
        $A.enqueueAction(action);        
    },
    
    captchaCallback : function (response) {
        console.log('>>>>>>>>>>>>> captcha response ');
    }
    
    
})