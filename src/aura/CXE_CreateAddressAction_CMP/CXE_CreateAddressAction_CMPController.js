({
	/* Description: Display Search Account modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
     doInit : function(component, event, helper) {

        //Get sobject type of record which invoked the button
 		var action = component.get("c.getSobjectType");

        action.setParams({"sobjectId": component.get("v.recordId")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('doInit: '+JSON.stringify(response.getReturnValue()));

                //No account search for Connection
                if(response.getReturnValue() == 'Connection__c'){

                	//Populate Address Type picklist values
			        helper.setTypeValues(component, event, helper);

			        //Display spinner
			        // helper.modalHelper('spinnerId', 'block');

			        //Display address modal
			        helper.openModalHelper(component, 'backGroundSectionId');
			        helper.openModalHelper(component, 'addressDiv');

                } else {
			        
                    //Check Address count for service (Agreement__c)
                    if(response.getReturnValue() == 'Agreement__c'){

                        helper.queryServiceAddress(component, event, helper);

                    } else {
                    	//Display spinner
    			        // helper.modalHelper('spinnerId', 'block');

    			        //Display search account modal
    			        helper.openModalHelper(component, 'backGroundSectionId');
                        helper.openModalHelper(component, 'accountSearchDiv');

                        //Focus on search field
    			        helper.setFocus(component, helper, 'accountSearch');
                    }
                }
            } else {
                console.log('doInit error: '+state);
                console.log('doInit '+helper.extractError(response.getError()));
            }
        });
        $A.enqueueAction(action);
        
	},

	/* Description: Close Search Account modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
     closeAccountSearchModal : function(component, event, helper) {
     	helper.closeAccountSearchModalHelper(component, event, helper);
    },

    /* Description: Search Account on keyup
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    searchAccount : function(component, event, helper) {

    	//Hide address list on re-search
		helper.closeModalHelper(component, 'accountAddressDiv');

    	//Get search value
    	var searchFilter = component.find("accountSearch");

    	//Validate minimum characters for search filter
    	if(searchFilter.get("v.value").length>=3){

    		searchFilterValue = searchFilter.get("v.value");
    			
			console.log('searchAccount searchFilterValue: '+searchFilterValue+' query');

			//Clear all fields on query
			helper.clearAddress(component, helper);

			//Retrieve accounts
			var action = component.get("c.getAccounts");

	        action.setParams({"accountName": searchFilterValue});

	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if(state == "SUCCESS"){
	                // console.log('searchAccount: '+JSON.stringify(response.getReturnValue()));

	                //Assign accounts list to component
	                component.set("v.accountSearchResults", response.getReturnValue());
	                
	            } else {
	                console.log('searchAccount error: '+state);
	            }
	        });
	        $A.enqueueAction(action);

    	} else {
    		console.log('searchAccount: minimum characters for search');

    		//Clear account and address records
    		component.set("v.accountSearchResults", []);
    	}
    },

    /* Description: Display Account Address/es
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    displayAccountAddress : function(component, event, helper) {

        component.set("v.noneSelectedMessage", null);
        component.set("v.noAddressMessage", null);
        
    	//Get Id for query filter
    	var selectedId = event.currentTarget.dataset.id

    	//Get Name for value mapping
    	var selectedName = event.currentTarget.dataset.name

    	console.log('displayAccountAddress: '+selectedId+', '+selectedName);

    	//Put selected account name into search box
    	component.find("accountSearch").set("v.value", selectedName);

    	//Clear account search results
		component.set("v.accountSearchResults", []);

		//Display account addresses
		helper.displayAccountAddresses(component, event, helper, selectedId);
    }, 

	/* Description: Display Address modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
     displayAddressModal : function(component, event, helper) {

     	//Close account search modal
        helper.closeAccountSearchModalHelper(component, event, helper);

     	//Populate Address Type picklist values
        helper.setTypeValues(component, event, helper);

        //Display spinner
        // helper.modalHelper('spinnerId', 'block');

        //Display address modal
        helper.openModalHelper(component, 'backGroundSectionId');
        helper.openModalHelper(component, 'addressDiv');
	},

	/* Description: Close Address modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
    closeAddressModal : function(component, event, helper) {

    	//Clear Address values
        helper.clearAddress(component, helper);

        //Set default Address Type
        helper.setAddressType(component, helper);
        
        //Close Address modal
        helper.closeModalHelper(component, 'addressDiv');
        helper.closeModalHelper(component, 'backGroundSectionId');
    },

    /* Description: Select all addresses
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    checkAll : function(component, event, helper) {
    	
    	//Get select all/none value
    	var parentCheck = document.getElementById('parentCheckbox').checked;
    	
    	//Check/uncheck all checkboxes
    	var checkboxes = document.getElementsByClassName('check');
    	for(var i=0; i<checkboxes.length; i++){
			checkboxes[i].checked = parentCheck;
    	}
    },

    /* Description: Relate sobject to selected address/es
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    updateAddress : function(component, event, helper) {

        //Disable update button
        helper.toggleElement(component, helper, 'updateAddress', true);

    	var checkboxes = document.getElementsByClassName('check');

		var addressList = [];

        //Get selected address ids
    	for(var i=0; i<checkboxes.length; i++){
    		if(checkboxes[i].checked){
				addressList.push(checkboxes[i].id);
			}
    	}
    	console.log('updateAddress addressList: '+addressList);

    	//Call server side method only when there are selected address/es
    	if(addressList.length>0){

            component.set("v.noneSelectedMessage", null);

            //Relate selected address to record
	    	var action = component.get("c.updateSelectedAddresses");

	        action.setParams({"sobjectId": component.get("v.recordId"), 
	    					  "addressIdList": addressList});

	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if(state == "SUCCESS"){
	                console.log('updateAddress: '+JSON.stringify(response.getReturnValue()));

                    //Close account search modal
	     			helper.closeAccountSearchModalHelper(component, event, helper);

                    if(response.getReturnValue() == 'Success'){
                        //Display toast on successful update of Address
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Success!",
                                              "message": "Address has been related.",
                                              "type": "success"
                        });
                    } else {
                        //Display toast if error occurred
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({"title": "Error!",
                                              "message": response.getReturnValue(),
                                              "type": "error"
                        });
                    }
	            } else {
	                console.log('updateAddress error: '+state);
	                console.log('updateAddress '+helper.extractError(response.getError()));

	                //Display toast if error occurred
		            var toastEvent = $A.get("e.force:showToast");
		            toastEvent.setParams({"title": "Error!",
		                                  "message": "Error updating Address.",
		                                  "type": "error"
		            });	
	            }
	            toastEvent.fire();
	        });
	     	$A.enqueueAction(action);

        	//Refresh detail page to reflect Address on related list
	        $A.get('e.force:refreshView').fire();   

            //Enable update button
            helper.toggleElement(component, helper, 'updateAddress', false);
            
            helper.closeAction(component, event, helper);

	    } else {	//Display info message when no address is selected

            //Enable update button
            helper.toggleElement(component, helper, 'updateAddress', false);

            component.set("v.noneSelectedMessage", "Please select at least one Address.");
        }
    },

    /* Description: Get is Same for Billing Address checkbox value
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
     //STILL NEEDED?
    getSameAddress : function(component, event, helper) {
        var isSameBillingAddress = component.find("isSameBillingAddress").get("v.value");
        // console.log('isSameBillingAddress: '+isSameBillingAddress);
    }, 

    /* Description: Save Address record
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: FEB-28-17
     */
    saveAddress : function(component, event, helper) {
        //Disable save button
        helper.toggleElement(component, helper, 'saveAddress', true);

    	//Validate required fields
    	if(helper.validateAddress(component, helper)){

            //Query street reference record
            helper.queryStreet(component, event, helper, component.find("Street").get("v.value"));
       	}
    },

    /* Description: Display Search modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-01-17
     */
     displaySearchModal : function(component, event, helper) {

     	//Display search modal
    	helper.openModalHelper(component, 'searchDiv');

        var searchReference = component.find("referenceSearch");

        //Update ui:inputText placeholder based on trigger event
        searchReference.set("v.placeholder", "Search "+event.getSource().getLocalId());

        //Focus on search field
        helper.setFocus(component, helper, 'referenceSearch');
	},

	/* Description: Close Search modal
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-01-17
     */
    closeSearchModal : function(component, event, helper) {
    	
        //Clear search text and results
    	component.find("referenceSearch").set("v.value", "");
        component.set("v.searchResults", []);

    	helper.closeModalHelper(component, 'searchDiv');
    }, 

    /* Description: Search Reference on keyup
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-01-17
     */
    searchAddress : function(component, event, helper) {
    	
        //Get search value
    	var searchFilter = component.find("referenceSearch");

    	//Validate minimum characters for search filter
    	if(searchFilter.get("v.value").length>=3){

    		searchFilterValue = searchFilter.get("v.value");

            //Get placeholder to identify which address field changed (Subdivision/Barangay/City/Province)
    		var searchPlaceholder = searchFilter.get("v.placeholder");
            var addressType = searchPlaceholder.split(" ")[1];
			console.log('searchAddress searchFilterValue: '+addressType+' = '+searchFilterValue);

			var addressList = [];

            //Get block results
			var addressMap = component.get("v.tempSearchResults");

            if(addressType == 'Subdivision'){

                //Retrieve subdivision and related block records
                helper.querySubdivision(component, event, helper);

    		} //Filter records based on search value
            else if(addressType == 'Barangay'){
				addressList = helper.filterRecords(addressMap, searchPlaceholder.split(" ")[1], searchFilterValue, component.get("v.barangayCode"));
            } else if(addressType == 'City'){
                addressList = helper.filterRecords(addressMap, searchPlaceholder.split(" ")[1], searchFilterValue, component.get("v.cityCode"));
            } else if(addressType == 'Province'){
                addressList = helper.filterRecords(addressMap, searchPlaceholder.split(" ")[1], searchFilterValue, '');
            }

    		//Assign filtered records to component
            component.set("v.searchResults", addressList);
    	} else {
    		//console.log('searchAddress: minimum characters for search');

    		//Clear filetered records
    		component.set("v.searchResults", []);
    	}
    },

    /* Description: Assign address value, lookup id and parent code
     * Parameters: None
     * Author: Michael Lasala
     * Date Created: MAR-01-17
     */
    mapValue : function(component, event, helper) {

    	//Get Id for lookup mapping
    	var selectedId = event.currentTarget.dataset.id

    	//Get Parent Code for address filtering
    	var parentCode = event.currentTarget.dataset.code

    	//Get Name for value mapping
    	var selectedName = event.currentTarget.dataset.name

    	console.log('mapValue: '+selectedId+', '+selectedName+', '+parentCode);

        //Get placeholder to identify which address field to map (Subdivision/Barangay/City/Province)
    	var searchValue = component.find("referenceSearch");
        var addressType = searchValue.get("v.placeholder").split(" ")[1];

    	//1. Set name of selected address to field
        //2. Assign Lookup Id to attribute for lookup mapping
        //3. Assign Parent Code to attribute for address filtering
        //4. Focus search on next address type
    	if(addressType == 'Subdivision'){
            
            component.find("Subdivision").set("v.value", selectedName);
            component.set("v.subdivisionId", selectedId);
            component.set("v.barangayCode", parentCode);
            helper.setFocus(component, helper, 'Barangay');
            console.log('mapValue subdivisionId: '+component.get("v.subdivisionId"));

    	} else if(addressType == 'Barangay'){
    		
            component.find("Barangay").set("v.value", selectedName);
    		component.set("v.barangayId", selectedId);
            component.set("v.cityCode", parentCode);
            helper.setFocus(component, helper, 'City');
            console.log('mapValue barangayId: '+component.get("v.barangayId"));

        } else if(addressType == 'City'){
            
            component.find("City").set("v.value", selectedName);
            component.set("v.cityId", selectedId);
            helper.setFocus(component, helper, 'Province');
            console.log('mapValue cityId: '+component.get("v.cityId"));
        
        } else if(addressType == 'Province'){
            
            component.find("Province").set("v.value", selectedName);
            component.set("v.provinceId", selectedId);
            console.log('mapValue provinceId: '+component.get("v.provinceId"));
    	}

    	//Clear search text and results
    	searchValue.set("v.value", "");
        component.set("v.searchResults", []);

        //Close Search modal
    	helper.closeModalHelper(component, 'searchDiv');
    }
})