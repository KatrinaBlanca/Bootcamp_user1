/* 
 * Description: Handles the logic for Lead Trigger
 * Author: Jerson Poblete (Accenture)
 * Date Created: MAR-14-17
 */ 
 public with sharing class LeadTriggerHandler implements TriggerInterface {
    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c triggerControl = TriggerControl__c.getInstance();
        return triggerControl.Lead__c;
    }

    public void BeforeInsert(List<SObject> newList) {} 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {}
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){}

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    	createAddressForConvertedAccounts(newMap.values()); // CSM-1904, CSM-2029
    }
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}

	/* 
	 * Description: CSM-1904: Validate the Lead's address before converting to Account 
	 * Parameters: List of Lead
	 * Returns: N/A
	 * Author: Jerome To
	 * Date Created: MAR-19-17
	 *				 MAR-28-17	Jerome To 		CSM-2029: Added map for each geo field and update on converted account
	 */  
	private void createAddressForConvertedAccounts(List<Lead> newList) {
		List<String> fieldList = new List<String> { CXE_Constants.REFERENCE_FIELD_STREET, CXE_Constants.REFERENCE_FIELD_SUBDIVISION,
												 CXE_Constants.REFERENCE_FIELD_BARANGAY, CXE_Constants.REFERENCE_FIELD_CITY,
												 CXE_Constants.REFERENCE_FIELD_PROVINCE };
		Set<String> addressNames = new Set<String>();
		List<Address__c> addressList = new List<Address__c>();

		Set<Id> convertedLeadsWithInvalidAddress = new Set<Id>();

		//Map<String, List<Reference__c>> referenceMap = new Map<String, List<Reference__c>>();
		Set<Id> leadsToCheck = new Set<Id>();

		for (Lead leadRec : newList) {
			if(leadRec.IsConverted && String.isNotBlank(leadRec.Street_Name__c) &&
			   String.isNotBlank(leadRec.Subdivision__c) && String.isNotBlank(leadRec.Barangay__c) && 
			   String.isNotBlank(leadRec.City_Municipality__c) && String.isNotBlank(leadRec.Province__c)) {					
				addressNames.add(leadRec.Street_Name__c.toUpperCase());
				addressNames.add(leadRec.Subdivision__c.toUpperCase());
				addressNames.add(leadRec.Barangay__c.toUpperCase());
				addressNames.add(leadRec.City_Municipality__c.toUpperCase());
				addressNames.add(leadRec.Province__c.toUpperCase());
				leadsToCheck.add(leadRec.Id);
			}
		}

		if(!leadsToCheck.isEmpty()) {

			Map<String, List<Reference__c>> referenceMapStreet = new Map<String, List<Reference__c>>();
			Map<String, List<Reference__c>> referenceMapSubdivision = new Map<String, List<Reference__c>>();
			Map<String, List<Reference__c>> referenceMapBarangay = new Map<String, List<Reference__c>>();
			Map<String, List<Reference__c>> referenceMapCity = new Map<String, List<Reference__c>>();
			Map<String, List<Reference__c>> referenceMapProvince = new Map<String, List<Reference__c>>();

			for (Reference__c referenceRec : [SELECT Id, Name, Parent__c, Parent__r.Name, Field__c 
					                          FROM Reference__c 
					                          WHERE Type__c = :CXE_Constants.REFERENCE_TYPE_GEO
					                          AND Field__c IN :fieldList
					                          AND Name IN :addressNames]) {

				if(referenceRec.Field__c == CXE_Constants.REFERENCE_FIELD_STREET) {
					if(referenceMapStreet.containsKey(referenceRec.Name.toUpperCase())) {
						List<Reference__c> refList = referenceMapStreet.get(referenceRec.Name.toUpperCase());
						refList.add(referenceRec);
						referenceMapStreet.put(referenceRec.Name.toUpperCase(), refList);
					} else {
						referenceMapStreet.put(referenceRec.Name.toUpperCase(), new List<Reference__c> { referenceRec });
					}
				}

				if(referenceRec.Field__c == CXE_Constants.REFERENCE_FIELD_SUBDIVISION) {
					if(referenceMapSubdivision.containsKey(referenceRec.Name.toUpperCase())) {
						List<Reference__c> refList = referenceMapSubdivision.get(referenceRec.Name.toUpperCase());
						refList.add(referenceRec);
						referenceMapSubdivision.put(referenceRec.Name.toUpperCase(), refList);
					} else {
						referenceMapSubdivision.put(referenceRec.Name.toUpperCase(), new List<Reference__c> { referenceRec });
					}
				}

				if(referenceRec.Field__c == CXE_Constants.REFERENCE_FIELD_BARANGAY) {
					if(referenceMapBarangay.containsKey(referenceRec.Name.toUpperCase())) {
						List<Reference__c> refList = referenceMapBarangay.get(referenceRec.Name.toUpperCase());
						refList.add(referenceRec);
						referenceMapBarangay.put(referenceRec.Name.toUpperCase(), refList);
					} else {
						referenceMapBarangay.put(referenceRec.Name.toUpperCase(), new List<Reference__c> { referenceRec });
					}
				}

				if(referenceRec.Field__c == CXE_Constants.REFERENCE_FIELD_CITY) {
					if(referenceMapCity.containsKey(referenceRec.Name.toUpperCase())) {
						List<Reference__c> refList = referenceMapCity.get(referenceRec.Name.toUpperCase());
						refList.add(referenceRec);
						referenceMapCity.put(referenceRec.Name.toUpperCase(), refList);
					} else {
						referenceMapCity.put(referenceRec.Name.toUpperCase(), new List<Reference__c> { referenceRec });
					}
				}

				if(referenceRec.Field__c == CXE_Constants.REFERENCE_FIELD_PROVINCE) {
					if(referenceMapProvince.containsKey(referenceRec.Name.toUpperCase())) {
						List<Reference__c> refList = referenceMapProvince.get(referenceRec.Name.toUpperCase());
						refList.add(referenceRec);
						referenceMapProvince.put(referenceRec.Name.toUpperCase(), refList);
					} else {
						referenceMapProvince.put(referenceRec.Name.toUpperCase(), new List<Reference__c> { referenceRec });
					}
				}
			}

			for (Lead leadRec : newList) {
				if(leadRec.IsConverted) {
					if(leadsToCheck.contains(leadRec.Id)) {

					    Address__c addressRec = new Address__c();	
						Boolean isValidStreet = false;
						Boolean isValidSubdivision = false;
						Boolean isValidBarangay = false;
						Boolean isValidCity = false;
						Boolean isValidProvince = false;

						if(referenceMapStreet.containsKey(leadRec.Street_Name__c.toUpperCase())) {
							for(Reference__c ref : referenceMapStreet.get(leadRec.Street_Name__c.toUpperCase())) {
								if(leadRec.Subdivision__c == ref.Parent__r.Name) {
									isValidStreet = true;
									addressRec.Address_Street_Name__c = ref.Id;
								}
							}
						}

						if(isValidStreet && referenceMapSubdivision.containsKey(leadRec.Subdivision__c.toUpperCase())) {
							for(Reference__c ref : referenceMapSubdivision.get(leadRec.Subdivision__c.toUpperCase())) {
								if(leadRec.Barangay__c == ref.Parent__r.Name) {
									isValidSubdivision = true;
									addressRec.Address_Subdivision__c = ref.Id;
								}
							}						
						} else{
							//leadRec.addError(CXE_Constants.LEAD_CHECK_ADDRESS);
							continue;
						}

						if(isValidSubdivision && referenceMapBarangay.containsKey(leadRec.Barangay__c.toUpperCase())) {
							for(Reference__c ref : referenceMapBarangay.get(leadRec.Barangay__c.toUpperCase())) {
								if(leadRec.City_Municipality__c == ref.Parent__r.Name) {
									isValidBarangay = true;
									addressRec.Address_Barangay__c = ref.Id;
								}
							}						
						} else{
							//leadRec.addError(CXE_Constants.LEAD_CHECK_ADDRESS);
							continue;
						}

						if(isValidBarangay && referenceMapCity.containsKey(leadRec.City_Municipality__c.toUpperCase())) {
							for(Reference__c ref : referenceMapCity.get(leadRec.City_Municipality__c.toUpperCase())) {
								if(leadRec.Province__c == ref.Parent__r.Name) {
									isValidCity = true;
									isValidProvince = true;
									addressRec.Address_City_Municipality__c = ref.Id;
									addressRec.Address_Province__c = ref.Parent__c;
								}
							}						
						} else{
							//leadRec.addError(CXE_Constants.LEAD_CHECK_ADDRESS);
							continue;
						}

						if( isValidCity && isValidProvince ) {
							addressRec.Address_Unit_No__c = leadRec.Unit_No__c;
							addressRec.Address_Street_No__c = leadRec.Street_No__c;
							addressRec.Premise_Type__c = CXE_Constants.ADDRESS_PREMISE_TYPE_OTHERS;
							addressRec.Account__c =  leadRec.ConvertedAccountId;
							addressList.add(addressRec);
						} else{
							//leadRec.addError(CXE_Constants.LEAD_CHECK_ADDRESS);
							continue;
						}

					} 
				}
			} 

			// Start CSM-2029		Jerome To 		MAR-28-2017
			if(!addressList.isEmpty()) {
				Set<Id> validAddressIds = new Set<Id>();
				List<Database.SaveResult> srList = Database.insert(addressList, false);
				for (Database.SaveResult sr : srList) {
				    if (sr.isSuccess()) {
				    	validAddressIds.add(sr.getId());
				    }
				}
				if(!validAddressIds.isEmpty()) {
					Set<Id> accountIds = new Set<Id>();
					for(Address__c addressRec : [SELECT Account__c FROM Address__c WHERE Id IN:validAddressIds]){
						accountIds.add(addressRec.Account__c);
					}
					if(!accountIds.isEmpty()) {
						updateAccountCheckAddress(accountIds);
					}
				}
			}
			// End CSM-2029		Jerome To 		MAR-28-2017
		}
	}

	/* 
	 * Description: CSM-2029
	 * Parameters: List of Lead
	 * Returns: N/A
	 * Author: Jerome To
	 * Date Created: MAR-28-17
	 */ 
	private void updateAccountCheckAddress(Set<Id> accountIds){
		if(!accountIds.isEmpty()) {
			List<Account> accountList = [SELECT Check_Address__c FROM Account WHERE Id IN:accountIds];
			if(!accountList.isEmpty()) {
				for(Account acct : accountList) {
					acct.Check_Address__c = true;
				}

				//update accountList;
				List<Database.SaveResult> srList = Database.update(accountList, false);
				for (Database.SaveResult sr : srList) {
				    if (!sr.isSuccess()) {
				    	String errors = '';		    	
				    	List<String> errorList = new List<String>();
				    	errorList.add(CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING1);
				        for(Database.Error err : sr.getErrors()) {
				            //errors += err.getStatusCode() + ': ' + err.getMessage();
				            errorList.add(err.getMessage());
				            //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
				        }
				        errors += String.join(errorList, '');
				        System.debug('------- Error has occured in updating Account ------' + errors);
				    }
				}
			}
		}
	}
}