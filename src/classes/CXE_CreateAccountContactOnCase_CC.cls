/* Description: CXE_CreateAccountContactOnCase_CMP lightning component controller (CSM-610/611)
 * Author: Michael Lasala
 * Date Created: FEB-17-17
 */
 public with sharing class CXE_CreateAccountContactOnCase_CC {
  //BEGIN Account Methods --------------------------------------------------
  /* 
   * Description: Method to query Case Details
   * Parameters: caseId - Id of the current case
   * Returns: Case
   * Author: Rom Edison Reyes
   * Date Created: FEB-08-17
   */
  @AuraEnabled
  public static Case getCaseDetails(Id caseId)
  {
        //Michael Lasala FEB-16-17 Added new custom field Last_Name__c
        //Michael Lasala FEB-28-17 Added new custom fields Salutation__c and Tax_Identification_No__c (CSM-973)
      //Michael Lasala MAR-03-17 Commented out address fields (CSM-222)
      Case myCase =  [SELECT  CaseNumber, AccountId, 
                                Application_for_Business_Customer__c, Application_for_Residential_Customer__c, 
                                Conglomerate_Tag__c, Customer_Type__c, 
                                Salutation__c, First_Name__c, 
                                Middle_Name__c, Last_Name__c, 
                                Last_Name_Business_Name__c, Telephone_No__c, 
                                Mobile_No__c, Email_Address__c, 
                                Date_of_Birth__c, //Billing_Address_Barangay__c, 
                                //Billing_Address_City_Municipal__c, Billing_Address_Street_No__c, 
                                //Billing_Address_Province__c, Billing_Address_Street_Name__c, 
                                //Billing_Address_Subdivision__c, Billing_Address_Unit_No__c, 
                                Account_Number__c, Tax_Identification_No__c
                                , Doing_Business_As__c //BEGIN/END Von Pernicia MAR-23-17 - add mapping for Doing Business As (CSM-1970)
                      FROM    Case 
                        WHERE   Id =: caseId LIMIT 1];
      return myCase;
  }

    /* Description: Retrieve Address records (CSM-222)
     * Parameters: Case Id
     * Returns: Boolean
     * Author: Michael Lasala
     * Date Created: MAR-03-17
     */
    @AuraEnabled
    public static Boolean retrieveAddress(String caseId){
        Boolean isAddressExist = false;

        List<Address__c> addressList = [SELECT Id FROM Address__c WHERE Case__c =: caseId AND Type__c = 'Billing' LIMIT 1];

        if(!addressList.isEmpty()){
            isAddressExist = true;
        }
        return isAddressExist;
    }

  /* 
   * Description: Method to query Case Related Accounts
   * Parameters: caseRec - case record
   * Returns: List<Account>
   * Author: Rom Edison Reyes
   * Date Created: FEB-09-17
   */
  @AuraEnabled
  public static List<Account> getRelatedAccounts(Case caseRec)
  {
      List<Account> accountList = new List<Account>();
      Decimal mobileNo = caseRec.Mobile_No__c != null? Decimal.valueOf(caseRec.Mobile_No__c) : null;
      //Query Business Account
      //START CSM-7272 RReyes JUL-06-17 - added condition to retrieve account with V10 Customer No only.
      if(caseRec.Application_for_Business_Customer__c){
          accountList = [SELECT Id, Name, RecordType.DeveloperName, Email__c, Phone, Mobile_Phone__c, PersonEmail, PersonMobilePhone FROM Account 
                         WHERE (RecordType.DeveloperName = 'CXE_Business_Account' 
                         AND Name=:caseRec.Last_Name_Business_Name__c 
                         AND ((Email__c != null AND Email__c =: caseRec.Email_Address__c) OR (Phone != null AND Phone =: caseRec.Telephone_No__c) OR (Mobile_Phone__c != null AND Mobile_Phone__c =: caseRec.Mobile_No__c))
                         AND (V10_Customer_No__c != null AND V10_Customer_No__c != ''))];
      }
      //Query Person Account
      else if(caseRec.Application_for_Residential_Customer__c){
        //Michael Lasala FEB-17-17 Replaced Business Name filter to Last Name
        //START CSM-11465 RReyes JUl-18-17 - changed reference from Phone >  PersonHomePhone, PersonMobilePhone > Mobile_1__pc
          accountList = [SELECT Id, Name, RecordType.DeveloperName, PersonEmail, Phone, PersonMobilePhone, PersonHomePhone, Mobile_1__pc FROM Account 
                          WHERE (RecordType.DeveloperName = 'CXE_Individual_Account' 
                          AND isPersonAccount = true 
                          AND  FirstName=:caseRec.First_Name__c AND LastName=:caseRec.Last_Name__c 
                          AND ((PersonEmail != null AND PersonEmail =: caseRec.Email_Address__c) OR (PersonHomePhone != null AND PersonHomePhone=: caseRec.Telephone_No__c) OR (Mobile_1__pc != null AND Mobile_1__pc =: caseRec.Mobile_No__c))
                          AND (V10_Customer_No__c != null AND V10_Customer_No__c != ''))];
        //END CSM-11465 RReyes JUl-18-17 - changed reference from Phone >  PersonHomePhone, PersonMobilePhone > Mobile_1__pc
      }
      //END CSM-7272 RReyes JUL-06-17 - added condition to retrieve account with V10 Customer No only.
      return accountList;
  }    

  /* 
   * Description: Method to create account
   * Parameters: caseRec 
   * Returns: Account
   * Author: Rom Edison Reyes
   * Date Created: FEB-10-17
   */
   //Start CSM-12129 Von Pernicia AUG-02-17
  @AuraEnabled
  public static String createAccount(Case caseRec)
  {
      Account acct = new Account();
      Boolean isAccountDetailsFilled = false;
      String status = 'Success';
      //Business Account
      if(caseRec.Application_for_Business_Customer__c){   
          RecordType businessAcctRT = [select Id, Name from RecordType where DeveloperName ='CXE_Business_Account' and SobjectType = 'Account'];  
          acct.RecordTypeId = businessAcctRT.Id;
          acct.Name = caseRec.Last_Name_Business_Name__c;     
          acct.Phone = caseRec.Telephone_No__c;
            acct.Conglomerate__c =  caseRec.Conglomerate_Tag__c;
            acct.Email__c = caseRec.Email_Address__c;
            acct.Mobile_Phone__c = caseRec.Mobile_No__c;
            acct.Customer_Type__c = caseRec.Customer_Type__c; //BEGIN/END Rom Edison Reyes MAR-07-17 - add mapping for Customer Type
            acct.Doing_Business_As__c = caseRec.Doing_Business_As__c; //BEGIN/END Von Pernicia MAR-23-17 - add mapping for Doing Business As (CSM-1970)
            //BEGIN Michael Lasala MAR-03-17
            //Comment out address fields mapping as it will be stored in the Address__c object (CSM-222)
            //acct.Billing_Address_Unit_No__c = caseRec.Billing_Address_Unit_No__c;
            //acct.Billing_Address_Street_No__c = caseRec.Billing_Address_Street_No__c;
            //acct.Billing_Address_Street_Name__c = caseRec.Billing_Address_Street_Name__c;
            //acct.Billing_Address_Subdivision__c = caseRec.Billing_Address_Subdivision__c;
            //acct.Billing_Address_Barangay__c = caseRec.Billing_Address_Barangay__c;
            //acct.Billing_Address_City_Municipal__c = caseRec.Billing_Address_City_Municipal__c;
            //acct.Billing_Address_Province__c = caseRec.Billing_Address_Province__c;
            //END Michael Lasala MAR-03-17

            //BEGIN Michael Lasala FEB-28-17
            //Add mapping of tax number (CSM-973)
            acct.Tax_Identification_No__c = caseRec.Tax_Identification_No__c;   
            //END Michael Lasala FEB-28-17

          isAccountDetailsFilled = true;
      }
      //Person Account
      else if(caseRec.Application_for_Residential_Customer__c){
          RecordType personAcctRT = [select Id, Name from RecordType where DeveloperName ='CXE_Individual_Account' and SobjectType = 'Account'];
          acct.RecordTypeId = personAcctRT.Id;
          //acct.IsPersonAccount = true; - (Read-only) 
          //START CSM-11465 RReyes JUl-18-17 - changed reference from Phone - PersonHomePhone, added Mobile_1__pc
          acct.PersonHomePhone = caseRec.Telephone_No__c;
          acct.Mobile_1__pc = caseRec.Mobile_No__c;
          //END CSM-11465 RReyes JUl-18-17 - changed reference from Phone - PersonHomePhone, added Mobile_1__pc
            acct.PersonBirthdate = caseRec.Date_of_Birth__c;
            acct.PersonEmail = caseRec.Email_Address__c;
            acct.FirstName = caseRec.First_Name__c;
            acct.Customer_Type__c = caseRec.Customer_Type__c; //BEGIN/END Rom Edison Reyes MAR-07-17 - add mapping for Customer Type
            //BEGIN Michael Lasala FEB-16-17
            //Change mapping of last name to new custom field
            //acct.LastName = caseRec.Last_Name_Business_Name__c;
            acct.LastName = caseRec.Last_Name__c;
            //END Michael Lasala FEB-16-17

            acct.MiddleName = caseRec.Middle_Name__c;
            acct.PersonMobilePhone = caseRec.Mobile_No__c;

            //START CSM-7231 - GGrandea 07.03.2017
            acct.Mobile_Phone__c = caseRec.Mobile_No__c; 
            acct.Email_1__pc = caseRec.Email_Address__c;
            //END   CSM-7231
      
            acct.Email__c = caseRec.Email_Address__c; // Start/End CSM-1931: Von Pernicia
      
            //BEGIN Michael Lasala MAR-03-17
            //Comment out address fields mapping as it will be stored in the Address__c object (CSM-222)
          //acct.Billing_Address_Unit_No__c = caseRec.Billing_Address_Unit_No__c;   
            //acct.Billing_Address_Street_No__c = caseRec.Billing_Address_Street_No__c;
            //acct.Billing_Address_Street_Name__c = caseRec.Billing_Address_Street_Name__c;
            //acct.Billing_Address_Subdivision__c = caseRec.Billing_Address_Subdivision__c;
            //acct.Billing_Address_Barangay__c = caseRec.Billing_Address_Barangay__c;
            //acct.Billing_Address_City_Municipal__c = caseRec.Billing_Address_City_Municipal__c;
            //acct.Billing_Address_Province__c = caseRec.Billing_Address_Province__c;
            //END Michael Lasala MAR-03-17

            //BEGIN Michael Lasala FEB-28-17
            //Add mapping of salutation and tax number (CSM-973)
            acct.Salutation = caseRec.Salutation__c;   
            acct.Tax_Identification_No__c = caseRec.Tax_Identification_No__c;   
            //END Michael Lasala FEB-28-17

          isAccountDetailsFilled = true;
      }
      if(isAccountDetailsFilled)
      {
          //START CSM-12250 Zhu Wenjun AUG-11-17 : Create a savepoint for rollback
          Savepoint sp = Database.setSavepoint();
          try{
              Database.SaveResult sr = Database.insert(acct);
              if (sr.isSuccess()){
                  Case caseToUpdate = new Case();
                  caseToUpdate.Id = caseRec.Id;
                  caseToUpdate.AccountId = acct.id;
                  
                  CaseTriggerHandler.isCreateNewAcct = true; //Set indicator to TRUE 
                  
                  update caseToUpdate;
              }
            }catch(DMLException e){
              Database.rollback(sp); //Rollback Account Creation
              status = e.getdmlMessage(0).Replace('&quot;','"');
              ErrorHandlerException.recordException(caseRec.Id, true, 'CXE_CreateAccountOnCase_CC', 'createAccount', status);
            }
           //END CSM-12250 Zhu Wenjun AUG-11-17

            //BEGIN Michael Lasala MAR-03-17 (CSM-222)
            //Retrieve Case Billing Address
            //Michael Lasala MAR-12-17 Remove filter of billing address and get all types of addresses from case
            List<Address__c> addressList = new List<Address__c>();
            //START RREYES CSM-1832 03/16/17 - add Account__c in query
            for(Address__c address: [SELECT Id, Account__c FROM Address__c WHERE Case__c =: caseRec.Id]){
              //Relate Case Billing Address to Account
                address.Account__c = acct.id;
                addressList.add(address);
            }
      //END RREYES CSM-1832 03/16/17 - add Account__c in query
            if(!addressList.isEmpty()){
                //Update Address
                try {
                    update addressList;
                    System.debug('addressList: '+addressList);

                } catch (DMLException error){
                    //System.debug('update address error: '+error.getMessage());
                    status = error.getdmlMessage(0).Replace('&quot;','"');
                    ErrorHandlerException.recordException(caseRec.Id, true, 'CXE_CreateAccountOnCase_CC', 'createAccount', status);
                }
            }
            //BEGIN Michael Lasala MAR-03-17
      }
      return status;
  }
  //End CSM-12129 Von Pernicia AUG-02-17
      /* 
   * Description: Method to update case with selected account ID
   * Parameters: caseId - Id of case to update 
                 acctId - Id of account to assign to case
   * Returns: none
   * Author: Rom Edison Reyes
   * Date Created: FEB-13-17
   */
  @AuraEnabled
  public static void relateExistingAccount(Id caseId, Id acctId)
  {
      if(caseId != null && acctId != null){
          Case caseToUpdate = new Case();
          caseToUpdate.Id = caseId;
          caseToUpdate.AccountId = acctId;
          try{
              update caseToUpdate;
          }catch(Exception e){
              system.debug('Error in updating case: ' + e.getMessage());
              ErrorHandlerException.recordException(caseToUpdate.Id, true, 'CXE_CreateAccountOnCase_CC', 'relateExistingAccount', e.getMessage());
          }
      }      
  }



  /* Description: Retrieve Billing and Service Address types related to Account
   * Parameters: Case Id
   * Returns: Set<String>
   * Author: Jerome To
   * Date Created: MAR-10-17
   * Update - 
   * MAR-14-17  Jerome To CSM-1832
   * - Upon creation of Account from Case record, an associated customer address in case is required.
   * - Removed filter of Billing adn Service Address types
   */
  @AuraEnabled
  public static List<String> retrieveRelatedCaseAddressTypes(String caseId){
      List<String> addressTypes = new List<String>();
      Set<String> setAddressTypes = new Set<String>();
      for (Address__c addressRec : [SELECT Id,Type__c 
                                  FROM Address__c 
                                  WHERE Case__c =: caseId 
                                  AND Type__c =:CXE_Constants.ADDRESS_TYPE_CUSTOMER]) {
          setAddressTypes.add(addressRec.Type__c);
      }
      if(!setAddressTypes.isEmpty()) {
        addressTypes.addAll(setAddressTypes);  
      }
      return addressTypes;
  }

    //END Account Methods ----------------------------------------------------

    //BEGIN Contact Methods --------------------------------------------------
  /* Description: Validate Case details
     * Parameters: Case Id
     * Returns: String
     * Author: Michael Lasala
     * Date Created: FEB-14-17
     */
    @AuraEnabled
    public static String validateCase(String caseId){
        String errorMessage = '';

        if(caseId != null){

            //Retrieve Case details
            List<Case> caseList = [SELECT   Id, 
                                            AccountId, 
                                            Account.IsPersonAccount, 
                                            ContactId, 
                                            Application_for_Residential_Customer__c,
                                            First_Name__c,    //Michael Lasala FEB-16-17 Added for full name validation
                                            Last_Name__c,     //Michael Lasala FEB-16-17 Added for full name validation
                                            //Middle_Name__c,   //Michael Lasala MAR-21-17 Added for middle name validation (CSM-1946)
                                            Date_of_Birth__c  //Michael Lasala MAR-21-17 Added for birth date validation (CSM-1946)
                                   FROM     Case
                                   WHERE    Id =: caseId LIMIT 1];
            System.debug('caseList: '+caseList);


            if(!caseList.isEmpty()){

                Case caseRecord = caseList.get(0);

                // Return error toast for the following criteria:
                // 1. Contact exists
                // 2. No Account related
                // 3. Related Account is a Person Account
                // 4. Residential Customer
                // 5. No First Name and Last Name
                //Define error message for each condition
                if(caseRecord.ContactId != null){
                    errorMessage = CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_EXISTING_CONTACT;
                } else if(caseRecord.AccountId == null){
                    errorMessage = CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_NO_ACCOUNT;
                } else if(caseRecord.Account.IsPersonAccount == true){
                    errorMessage = CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_PERSON_ACCOUNT;
                } else if(caseRecord.Application_for_Residential_Customer__c){
                    errorMessage = CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_RESIDENTIAL_CUSTOMER;
                } else if(caseRecord.First_Name__c == null ||   //Michael Lasala FEB-16-17 Added for full name validation
                          caseRecord.Last_Name__c == null || 
                          //caseRecord.Middle_Name__c == null ||    //Michael Lasala MAR-21-17 Added for middle name validation
                          caseRecord.Date_of_Birth__c == null){   //Michael Lasala MAR-21-17 Added for date of birth validation
                    errorMessage = CXE_Constants.CREATE_CONTACT_ERROR_MESSAGE_FULL_NAME;
                }
            }
        }
        return errorMessage;
    }

    /* Description: Retrieves Contacts that have similar information to the Case
                    If none, creates a Contact based on Case details and relates 
                    it to the Case
     * Parameters: Case Id
     * Returns: List<Contact>
     * Author: Michael Lasala
     * Date Created: FEB-14-17
     */
    @AuraEnabled
    public static List<Contact> searchContacts(String caseId){
        List<Contact> contactList = new List<Contact>();

        if(caseId != null){

            //Retrieve Case details for Contact query filter and field mapping
            List<Case> caseList = [SELECT   Id, 
                                            AccountId, 
                                            First_Name__c, 
                                            Middle_Name__c, 
                                            //BEGIN Michael Lasala FEB-16-17
                                            //Change mapping of last name to new custom field
                                            //Last_Name_Business_Name__c, 
                                            Last_Name__c, 
                                            //END Michael Lasala FEB-16-17
                                            Date_of_Birth__c, 
                                            Telephone_No__c, 
                                            Mobile_No__c, 
                                            Email_Address__c, 
                                            Salutation__c  //Michael Lasala MAR-27-17 CSM-1996
                                            //BEGIN Michael Lasala MAR-03-17 (CSM-222)
                                            //Remove address mapping as values will come from Address record
                                            //Billing_Address_Barangay__c, 
                                            //Billing_Address_City_Municipal__c, 
                                            //Billing_Address_Street_No__c, 
                                            //Billing_Address_Province__c, 
                                            //Billing_Address_Street_Name__c, 
                                            //Billing_Address_Subdivision__c, 
                                            //Billing_Address_Unit_No__c
                                            //END Michael Lasala MAR-03-17
                                   FROM     Case
                                   WHERE    Id =: caseId LIMIT 1];
            System.debug('caseList: '+caseList);

            if(!caseList.isEmpty()){

                Case caseRecord = caseList.get(0);

                //Retrieve Contacts with the same:
                //1. First Name
                //2. Last Name
                //3. Mobile Phone or Email
                contactList = [SELECT   Id, 
                                        FirstName, 
                                        LastName, 
                                        MobilePhone, 
                                        Email
                               FROM     Contact 
                               WHERE    Account.IsPersonAccount = false 
                               AND      FirstName =: caseRecord.First_Name__c 
                               //BEGIN Michael Lasala FEB-16-17
                               //Change mapping of last name to new custom field
                               //AND      LastName =: caseRecord.Last_Name_Business_Name__c 
                               AND      LastName =: caseRecord.Last_Name__c 
                               //END Michael Lasala FEB-16-17
                               AND      (MobilePhone =: caseRecord.Mobile_No__c 
                               OR        Email =: caseRecord.Email_Address__c)];

                if(contactList.isEmpty()){
                    //No similar Contacts
                    Contact caseContact = new Contact();

                    //Map Case details
                    caseContact.AccountId =                 caseRecord.AccountId;
                    caseContact.Salutation =                 caseRecord.Salutation__c;       //Michael Lasala MAR-27-17 CSM-1996
                    caseContact.FirstName =                 caseRecord.First_Name__c;
                    caseContact.MiddleName =                caseRecord.Middle_Name__c;

                    //BEGIN Michael Lasala FEB-16-17
                    //Change mapping of last name to new custom field
                    //caseContact.LastName =                  caseRecord.Last_Name_Business_Name__c;
                    caseContact.LastName =                  caseRecord.Last_Name__c;
                    //END Michael Lasala FEB-16-17

                    caseContact.Birthdate =                 caseRecord.Date_of_Birth__c;
                    caseContact.Phone =                     caseRecord.Telephone_No__c;
                    caseContact.MobilePhone =               caseRecord.Mobile_No__c;
                    caseContact.Email =                     caseRecord.Email_Address__c;

                    //Insert Contact
                    try {
                        insert caseContact;
                        System.debug('caseContact: '+caseContact);
                    } catch (DMLException error){
                        System.debug('insert contact error: '+error.getMessage());
                        ErrorHandlerException.recordException(caseRecord.Id, true, 'CXE_CreateAccountOnCase_CC', 'searchContacts', error.getMessage());
                    }

                    //Relate Contact to Case
                    caseRecord.ContactId = caseContact.Id;
                    
                    try {
                        update caseRecord;
                        System.debug('caseRecord: '+caseRecord);

                    } catch (DMLException error){
                        System.debug('update case error: '+error.getMessage());
                        ErrorHandlerException.recordException(caseRecord.Id, true, 'CXE_CreateAccountOnCase_CC', 'searchContacts', error.getMessage());
                    }

                    //BEGIN Michael Lasala MAR-03-17 (CSM-222)
                    //Retrieve Case Billing Address
                    List<Address__c> addressList = [SELECT  Id, 
                                                            Address_Unit_No__c, 
                                                            Address_Street_No__c, 
                                                            Address_Street_Name__r.Name, 
                                                            Address_Subdivision__r.Name, 
                                                            Address_Barangay__r.Name, 
                                                            Address_City_Municipality__r.Name, 
                                                            Address_Province__r.Name 
                                                    FROM    Address__c 
                                                    WHERE   Case__c =: caseRecord.Id 
                                                    //AND     Type__c = 'Billing' LIMIT 1];
                                                    AND     Type__c =: CXE_Constants.ADDRESS_TYPE_CUSTOMER LIMIT 1];

                    //BEGIN Michael Lasala MAR-27-17 commented out (CSM-1980c)
                    if(!addressList.isEmpty()){
                        Address__c customerAddress = addressList.get(0);

                        //Map Address values
                        //caseContact.Unit_No__c =                address.Address_Unit_No__c;
                        //caseContact.House_No__c =               address.Address_Street_No__c;
                        //caseContact.Street_Name__c =            address.Address_Street_Name__r.Name;
                        //caseContact.Subdivision_Bldg_Name__c =  address.Address_Subdivision__r.Name;
                        ////caseContact.Barangay__c =               address.Address_Barangay__r.Name;
                        //caseContact.City_Municipal__c =         address.Address_City_Municipality__r.Name;
                        //caseContact.Province__c =               address.Address_Province__r.Name;
                        //BEGIN Michael Lasala MAR-27-17 CSM-1980
                        //Relate Account Customer Address
                        customerAddress.Contact__c = caseContact.Id;

                        try {
                            update customerAddress;
                            System.debug('customerAddress: '+customerAddress);
                        } catch (DMLException error){
                            System.debug('update address error: '+error.getMessage());
                            ErrorHandlerException.recordException(caseRecord.Id, true, 'CXE_CreateAccountOnCase_CC', 'searchContacts', error.getMessage());
                        }
                        //END Michael Lasala MAR-27-17
                    }
                    //END Michael Lasala MAR-27-17
                }
            }
        }
        System.debug('contactList: '+contactList);
        return contactList;
    }

    /* Description: Relate selected Contact to the Case record
     * Parameters: Contact Id
                   Case Id
     * Returns: Contact
     * Author: Michael Lasala
     * Date Created: FEB-14-17
     */
    @AuraEnabled
    public static Case updateSelectedContact(String newContactId, String caseId){
        Case caseRecord;
        
        if(caseId != null){

            //Retrieve Case
            List<Case> caseList = [SELECT   Id 
                                   FROM     Case 
                                   WHERE    Id =: caseId LIMIT 1];
            System.debug('caseList: '+caseList);


            if(!caseList.isEmpty() && 
               newContactId != null){

                caseRecord = caseList.get(0);
                
                //Update Case Contact
                caseRecord.ContactId = newContactId;

                //Update Case
                try {
                    update caseRecord;
                    System.debug('caseRecord: '+caseRecord);

                } catch (DMLException error){
                    System.debug('update case error: '+error.getMessage());
                    ErrorHandlerException.recordException(caseRecord.Id, true, 'CXE_CreateAccountOnCase_CC', 'updateSelectedContact', error.getMessage());
                }
            }
        }
        return caseRecord;
    }   
    //END Contact Methods ----------------------------------------------------
}