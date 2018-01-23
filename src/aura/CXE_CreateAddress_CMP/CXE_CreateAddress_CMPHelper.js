({
	/* Description: Get Service Address count for Service (Agreement__c)
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-04-17
     */
     queryServiceAddress : function(component, event, helper) {

        var action = component.get("c.getServiceAddressCount");

        action.setParams({"serviceId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('queryServiceAddress: '+response.getReturnValue());

                if(response.getReturnValue()>0){

                    //Display info
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Oops!",
                                              "message": "You cannot add more than one service address for a service.",
                                              "type": "info"
                    });
                    toastEvent.fire();

                } else {

                    //Display account search modal
                    helper.openModalHelper(component, 'backGroundSectionId');
                    helper.openModalHelper(component, 'accountSearchDiv');

                    //Focus on search field
                    helper.setFocus(component, helper, 'accountSearch');
                }

            } else {
                console.log('queryServiceAddress error: '+state);
                console.log('queryServiceAddress '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    
    /* Description: Close Search Account modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
     closeAccountSearchModalHelper : function(component, event, helper) {

     	//Clear account search value, account and account address results
    	component.find("accountSearch").set("v.value", "");
        component.set("v.accountSearchResults", []);
        component.set("v.addressSearchResults", []);

        //Hide account address results
        helper.closeModalHelper(component, 'accountAddressDiv');

		//Close account search modal
        helper.closeModalHelper(component, 'backGroundSectionId');
        helper.closeModalHelper(component, 'accountSearchDiv');
    },

	/* Description: Display addresses of selected account
     * Parameters: Account Id
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
	displayAccountAddresses : function(component, event, helper, accountId) {

		//Display loader
        // helper.modalHelper('spinnerId', 'block');

		var action = component.get("c.getAccountAddresses");

        action.setParams({"accountId": accountId, 
	    				  "sobjectId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('displayAccountAddresses: '+JSON.stringify(response.getReturnValue()));

                if(response.getReturnValue().length>0){

                    //Assign address list to component
                    component.set("v.addressSearchResults", response.getReturnValue());

                    //Display address list
                    helper.openModalHelper(component, 'accountAddressDiv');

            		//Hide loader
            		// helper.modalHelper('spinnerId', 'none');
                } else {

                    //Clear address list
                    component.set("v.addressSearchResults", []);

                    //Display toast if no addresses found
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Oops!",
                                          "message": "No addresses found.",
                                          "type": "info"
                    }); 
                    toastEvent.fire();
                }
            } else {
                console.log('displayAccountAddresses error: '+state);
                console.log('displayAccountAddresses '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
	}, 

	/* Description: Display record name
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
	setObject : function(component, event, helper) {
		var action = component.get("c.getObject");

        action.setParams({"sobjectId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setObject: '+JSON.stringify(response.getReturnValue()));

			    //Set value on object field
			    var lookupField = component.find("lookupField");
			    lookupField.set("v.label", response.getReturnValue()[0]);
			    lookupField.set("v.value", response.getReturnValue()[1]);

			    //Set Owner field
     			helper.setOwner(component, event, helper);

            } else {
                console.log('setObject error: '+state);
                console.log('setObject '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
	}, 

	/* Description: Display Owner Name
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
	setOwner : function(component, event, helper) {
		var action = component.get("c.getUser");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('setOwner: '+JSON.stringify(response.getReturnValue()));
                
                //Set value on Owner field
			    component.find("owner").set("v.value", response.getReturnValue());

            } else {
                console.log('setOwner error: '+state);
            }
        });
        $A.enqueueAction(action);

        //Set default Address Type
    	helper.setAddressType(component, helper);

        //Hide spinner
        // helper.modalHelper('spinnerId', 'none');
	}, 

	/* Description: Hide/show element
     * Parameters: Element Id, Block/None
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
     //STILL NEEDED?
    modalHelper : function(elementId, display) {
        document.getElementById(elementId).style.display = display;
    },

    /* Description: Show Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    openModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-hide');
    },

    /* Description: Hide Modal
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    closeModalHelper : function(component, elementId) {
        var modal = component.find(elementId); 
        $A.util.addClass(modal, 'slds-fade-in-hide'); 
        $A.util.removeClass(modal, 'slds-backdrop--open'); 
    },

    /* Description: Clear Address values
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
    clearAddress : function(component, helper) {
	    component.find("Province").set("v.value", "");
		component.find("City").set("v.value", "");
		component.find("Barangay").set("v.value", "");
		component.find("Subdivision").set("v.value", "");
		component.find("streetNumber").set("v.value", "");
        component.find("unitNumber").set("v.value", "");
		component.find("landmark").set("v.value", "");
		
		component.set("v.provinceId", null);
		component.set("v.cityId", null);
		component.set("v.barangayId", null);
		component.set("v.subdivisionId", null);
		component.set("v.streetId", null);

        //Show street input
        component.set("v.isStreetInput", true);
        component.find("Street").set("v.value", "");
        helper.clearError(component, helper, "Street");
        
        helper.clearError(component, helper, "addressType");
        helper.clearError(component, helper, "premiseType");
        helper.clearError(component, helper, "Barangay");
        helper.clearError(component, helper, "Subdivision");
        helper.clearError(component, helper, "streetNumber");
    },

	/* Description: Filter reference records based on address type
     * Parameters: Address Map, Address Type, Search Filter, Address Code
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
	filterRecords : function(addressMap, addressType, filter, addressCode){
		// console.log('filterRecords parentCode: '+parentCode);
		var addressList = [];
        
		for(var i=0; i<addressMap.length; i++){
            
        	//Filter out records by address type
        	if(addressMap[i].Field__c == addressType){

		        //Filer out records based on search text
		        // if(addressMap[i].Name.substring(0, searchFilterValue.length) === searchFilterValue.toUpperCase()){
		        // if(addressMap[i].Name.match(searchFilterValue.toUpperCase())){
		        // if(addressMap[i].Name.indexOf(searchFilterValue.toUpperCase()) != -1){
		        if(addressMap[i].Name.indexOf(filter.toUpperCase()) !== -1){

		        	//Filter by address by code for Barangay, City and Province
		        	if(addressCode != ''){
		        		if(addressMap[i].Name_Code__c == addressCode){
		        			addressList.push(addressMap[i]);
	    					console.log('with parentcode: '+JSON.stringify(addressMap[i]));
		        		}
		        	} else {	//No filtering needed for Province as it is the top level

	    				addressList.push(addressMap[i]);
	    				console.log('no parent code: '+JSON.stringify(addressMap[i]));
	    			}
		        }
        	}
        }
        return addressList;
	}, 

    /* Description: Query Street
     * Parameters: Street
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    queryStreet : function(component, event, helper, street){

        var streetId = component.get("v.streetId");

        if(!$A.util.isEmpty(streetId) && 
           !$A.util.isUndefinedOrNull(streetId)){

            //Insert address record
            helper.saveAddressHelper(component, event, helper);

        //Validate street value
        } else if(!$A.util.isEmpty(street) && 
                  !$A.util.isUndefinedOrNull(street) && 
                  street != ''){

            // var action = component.get("c.getStreet");

            var action = component.get("c.getStreets");

            action.setParams({"street": street,
                              "subdivisionId": component.get("v.subdivisionId")});

            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state == "SUCCESS"){
                    var streetList = response.getReturnValue();
                    console.log('queryStreet: '+streetList.length);

                    if(streetList.length == 1 && 
                       street.toUpperCase() == response.getReturnValue()[0].Name){
                        
                        // Assign street lookup id and clear errors
                        component.set("v.streetId", response.getReturnValue()[0].Id);
                        component.find("Street").set("v.errors", null);

                        //Insert address record
                        helper.saveAddressHelper(component, event, helper);

                    } else if(streetList.length == 0){

                        //Show street input
                        component.set("v.isStreetInput", true);
                        component.find("Street").set("v.errors", [{message: "No Streets found under selected Subdivision. Please contact System Administrator."}]);
                        
                        helper.toggleElement(component, helper, 'saveAddress', false);

                        helper.displayErrorToast(component, helper);

                    // } else if(streetList.length>1){
                    } else {

                        var opts=[];

                        //Hide street input
                        component.set("v.isStreetInput", false);

                        //Iterate over picklist values
                        for(var i=0; i<streetList.length; i++){

                            //Push values as select options
                            opts.push({"class": "optionClass", label: streetList[i].Name, value: streetList[i].Id});
                        }
                        component.find("streetList").set("v.options", opts);

                        //Assign first street result for street lookup value
                        component.set("v.streetId", streetList[0].Id);

                        //Display error message
                        component.find("streetList").set("v.errors", [{message: "Street not found, please select from the list."}]);

                        //Enable save button
                        helper.toggleElement(component, helper, 'saveAddress', false);
                        
                        helper.displayErrorToast(component, helper);
                    }
                    //  else {

                    //     //Display error that street doesn't exist based on Subdivision
                    //     component.find("Street").set("v.errors", [{message: "Street not found under the Subdivision."}]);

                    //     //Enable save button
                    //     helper.toggleElement(component, helper, 'saveAddress', false);
                    // }
                } else {
                    console.log('queryStreet error: '+state);
                    console.log('queryStreet '+helper.extractError(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }
        //  else {
        //     //Display error for null street value
        //     component.find("Street").set("v.errors", [{message: "You must enter a Street."}]);
            
        //     //Enable save button
        //     helper.toggleElement(component, helper, 'saveAddress', false);
        // }
    }, 
    
    /* Description: Query Subdivison
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    querySubdivision : function(component, event, helper){

        var action = component.get("c.getSubdivisions");

        action.setParams({"subdivision": component.find("referenceSearch").get("v.value")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                var addressResults = response.getReturnValue();
                console.log('querySubdivision: '+addressResults.length);

                var subdivisionList = [];
                
                //Iterate over subdivisions
                for(var i=0; i<addressResults.length; i++){

                    //Filter out subdivision records based on search value and other address records (Barangay, City and Province)
                    if(addressResults[i].Field__c == 'Subdivision' && 
                       addressResults[i].Name.indexOf(component.find("referenceSearch").get("v.value").toUpperCase()) !== -1){

                        //Add to array to be displayed as search results
                        subdivisionList.push(response.getReturnValue()[i]);
                        // console.log('i: '+JSON.stringify(response.getReturnValue()[i]));
                    }
                }

                //Set subdivision results
                component.set("v.searchResults", subdivisionList);
                console.log('querySubdivision v.searchResults: '+subdivisionList.length);
				//Assign temporary search results for retrieving values for Barangay, City and Province
                component.set("v.tempSearchResults", response.getReturnValue());

            } else {
                console.log('querySubdivision error: '+state);
                console.log('querySubdivision '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }, 

	/* Description: Validate address fields
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
	validateAddress : function(component, helper){
		var isValid = false;
		
		//Get field values
        var typeValue = component.find("addressType").get("v.value");
		var premiseValue = component.find("premiseType").get("v.value");
    	// var provinceValue = component.get("v.provinceId");
		// var cityValue = component.get("v.cityId");
		var barangayValue = component.get("v.barangayId");
        var subdivisionValue = component.get("v.subdivisionId");
		var streetNumberValue = component.get("v.streetNumber");      //Michael Lasala MAR-29-17 CSM-2049

        //Validate required fields
        var isTypeValid = helper.validateField(component, helper, typeValue, 'addressType', 'select an Address Type');

        var isPremiseValid = true;

        //Address type is only mandatory for service address
        if(typeValue == 'Service'){
            isPremiseValid = helper.validateField(component, helper, premiseValue, 'premiseType', 'select a Premise Type');
        } else {
            component.find("premiseType").set("v.errors", null);
        }

        // var isProvinceValid = helper.validateField(component, helper, provinceValue, 'Province', 'enter a Province');
        // var isCityValid = helper.validateField(component, helper, cityValue, 'City', 'enter a City');
        var isBarangayValid = helper.validateField(component, helper, barangayValue, 'Barangay', 'enter a Barangay');
        var isSubdivisionValid = helper.validateField(component, helper, subdivisionValue, 'Subdivision', 'enter a Subdivision');

        var streetValue;
        var isStreetValid = true;

        if(component.get("v.isStreetInput") == true){
            streetValue = component.find("Street").get("v.value");
            isStreetValid = helper.validateField(component, helper, streetValue, 'Street', 'enter a Street');
        }

        //Michael Lasala MAR-29-17 CSM-2049
        var isStreetNumberValid = helper.validateField(component, helper, component.find("streetNumber").get("v.value"), 'streetNumber', 'enter a Street #');
        
        if(isTypeValid &&
           isPremiseValid && 
           // isProvinceValid && 
           // isCityValid && 
           isBarangayValid && 
           isSubdivisionValid &&
           isStreetValid && 
           isStreetNumberValid){    //Michael Lasala MAR-29-17 CSM-2049

            isValid = true;
        
        } else {

            //Enable save button
            helper.toggleElement(component, helper, 'saveAddress', false);
        }
        console.log('validateFields isValid: '+isValid);
        return isValid;
	}, 

	/* Description: Validate each field
     * Parameters: Field value, Field id, Error message
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
	validateField : function(component, helper, fieldValue, elementId, errorMessage){

		if(($A.util.isEmpty(fieldValue) && 
		    $A.util.isUndefinedOrNull(fieldValue)) || 
           fieldValue == 'Please Select' || 
           fieldValue == '' || 
           fieldValue.trim() == ''){

			//Set error
			component.find(elementId).set("v.errors", [{message: "You must "+errorMessage+"."}]);
			return false;

    	} else {

    		//Clear error
			component.find(elementId).set("v.errors", null);
			return true;
		}
	}, 

    /* Description: Save Address record
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
    saveAddressHelper : function(component, event, helper) {
        
        var action = component.get("c.insertAddress");

        //Set parameters
        action.setParams({"objectId": component.get("v.recordId"), 
                          "addressType": component.find("addressType").get("v.value"), 
                          "premiseType": component.find("premiseType").get("v.value"), 
                          "landmark": component.find("landmark").get("v.value"), 
                          "unitNo": component.find("unitNumber").get("v.value"), 
                          "streetNo": component.find("streetNumber").get("v.value"), 
                          "streetId": component.get("v.streetId"),
                          "subdivisionId": component.get("v.subdivisionId"),
                          "barangayId": component.get("v.barangayId"),
                          "cityId": component.get("v.cityId"), 
                          "provinceId": component.get("v.provinceId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('saveAddress: '+JSON.stringify(response.getReturnValue()));

                if(response.getReturnValue() == 'Success'){
                    //Display toast on successful create of Address
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Success!",
                                          "message": "Address has been created.",
                                          "type": "success"
                    });
                } else {
                    //Display toast if error occurred
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({"title": "Oops!",
                                          "message": response.getReturnValue(),
                                          "type": "error"
                    });
                }
            } else {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && 
                       errors[0].message){
                        
                        console.log('saveAddress error: '+state+' '+errors[0].message);
                    }
                } else {
                    console.log('saveAddress unknown error');
                }

                //Display toast if error occurred
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({"title": "Error!",
                                      "message": "Error creating Address.",
                                      "type": "error"
                });             
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);

        //Clear all Address fields
        helper.clearAddress(component, helper);
        
        //Set default Address Type
        helper.setAddressType(component, helper);

        //Close Address modal
        helper.closeModalHelper(component, 'addressDiv');
        helper.closeModalHelper(component, 'backGroundSectionId');

        //Refresh detail page to reflect Address on related list
        $A.get('e.force:refreshView').fire();

        //Enable save button
        helper.toggleElement(component, helper, 'saveAddress', false);
    },

	/* Description: Populate Address Type picklist values
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
	setTypeValues : function(component, event, helper) {
		
		var action = component.get("c.getAddressType");
	    var opts=[];

        action.setParams({"sobjectId": component.get("v.recordId")});

	    action.setCallback(this, function(response) {
            console.log('Address Types: '+response.getReturnValue());

            //Iterate over picklist values
	        for(var i=0; i<response.getReturnValue().length; i++){

	        	//Push values as select options
	            opts.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
	        }
	        component.find("addressType").set("v.options", opts);
	    });
	    $A.enqueueAction(action);

	    //Set Premise Type picklist values
        helper.setPremiseValues(component, event, helper);
	}, 

    /* Description: Populate Premise Type picklist values
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-04-17
     */
    setPremiseValues : function(component, event, helper) {
        
        var action = component.get("c.getPremiseType");
        var opts=[];

        action.setCallback(this, function(response) {
            console.log('Premise Types: '+response.getReturnValue());

            //Iterate over picklist values
            for(var i=0; i<response.getReturnValue().length; i++){

                //Push values as select options
                opts.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
            }
            component.find("premiseType").set("v.options", opts);
        });
        $A.enqueueAction(action);

        //Set Object value
        helper.setObject(component, event, helper);
    }, 

	/* Description: Extract error message
     * Parameters: Error
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
	extractError : function(error) {
		var errorMessage = error;
        if(error){
            if(error[0] && 
               error[0].message){
                
                console.log('error: '+error[0].message);
            }
        } else {
            console.log('unknown error');
        }
	},

	/* Description: Set default Address Type based on sobject type
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-02-17
     */
	setAddressType : function(component, helper) {
        var objectLabel = component.find("lookupField").get("v.label");
        var addressType = component.find("addressType");
        helper.toggleElement(component, helper, 'addressType', true);

		if(objectLabel == 'Contract'){    //Restrict billing type for Contract
			addressType.set("v.value", "Billing");

        } else if(objectLabel == 'Connection'){    //Restrict meter type for Connection
            addressType.set("v.value", "Meter");

        //BEGIN Michael Lasala MAR-27-17 CSM-1980
        } else if(objectLabel == 'Contact'){    //Restrict customer type for Contact
            addressType.set("v.value", "Customer");

        } else {
        //END Michael Lasala MAR-27-17 
            addressType.set("v.value", "Service");

            if(objectLabel != 'Service'){        //Restrict service type for Service
                helper.toggleElement(component, helper, 'addressType', false);
			}
        }
	},

    /* Description: Set focus on search
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: MAR-04-17
     */
    setFocus : function(component, helper, elementId) {
        setTimeout(function() {
            component.find(elementId).focus();
        }, 100);
    }, 

    /* Description: Enable/disable an element
     * Parameters: Element Id, Boolean
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    toggleElement : function(component, helper, elementId, state) {
        component.find(elementId).set("v.disabled", state);
    }, 

    /* Description: Display error toast
     * Parameters: 
     * Author: Michael Lasala
     * Date Created: APR-08-17
     */
    displayErrorToast : function(component, helper) {
        //Display toast if error occurred
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": "Error!",
                              "message": 'Review the errors on this page.',
                              "type": "error"
        });
        toastEvent.fire();
    }, 

    /* Description: Clear error messages
     * Parameters: Element Id
     * Author: Michael Lasala
     * Date Created: APR-08-17
     */
    clearError : function(component, helper, elementId) {
        component.find(elementId).set("v.errors", null);
    },

    /* Description: Get Billing Address count for Contract - CSM-6137, CSM-6135
     * Parameters: None
     * Author: Jerome To
     * Date Created: JUN-01-17
     */
     queryBillingAddress : function(component, event, helper) {

        var action = component.get("c.getBillingAddressCount");
        console.log('contract Id: '+component.get("v.recordId"));
        action.setParams({"contractId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('queryBillingAddress: '+response.getReturnValue());

                if(response.getReturnValue()>0){

                    //Display info
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Oops!",
                                              "message": "You cannot add more than one billing address for a contract.",
                                              "type": "info"
                    });
                    toastEvent.fire();

                } else {

                    //Display account search modal
                    helper.openModalHelper(component, 'backGroundSectionId');
                    helper.openModalHelper(component, 'accountSearchDiv');

                    //Focus on search field
                    helper.setFocus(component, helper, 'accountSearch');
                }

            } else {
                console.log('queryBillingAddress error: '+state);
                console.log('queryBillingAddress '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }

})