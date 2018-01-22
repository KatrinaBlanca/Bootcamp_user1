/* 
* Description: This class contains the creation of test records for of all objects 
 * Parameters: If present 
 * Returns: List of object record
 * Author: Von Pernicia
 * Date Created: FEB-10-17
*/

@isTest
public class CXE_TestDataFactory {

    public static List<Case> createCase(Integer numOfRecord, String sTypeOfApplication, String sMultimetering, String sStatus
                            , String sCustomerType) {
        
        List<Case> listCase = new List<Case>();
        Id newServRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            
            Case caseRecord = new Case(
                            RecordTypeId = newServRecTypeId, //START/END RReyes - added recordTypeId
                            Application_Type_Subtype__c = sTypeOfApplication,
                            //Multimetering__c = sMultimetering,
                            Status = sStatus,
                            Customer_Type__c = sCustomerType,
                            Last_Name_Business_Name__c = 'LastName BusinessName' + recordCount,
                            Mobile_No__c = '+631111111111',
                            Service_Address_Province__c = 'RIZAL',
                            Service_Address_City_Municiple__c = 'ANGONO',
                            Service_Address_Barangay__c = 'KALAYAAN',
                            Service_Address_Subdivision__c = 'SUB' + recordCount,
                            Service_Address_Street_Name__c = 'STREETNAME',
                            Service_Address_Street_No__c = 'STREETNO',
                            Same_As_Service_Address__c = true,
                            Salutation__c = 'Mr.',
                            First_Name__c = 'Firstname' + recordCount,
                            Date_of_Birth__c = system.today() - 2,
                            Preliminary_survey_result_is_feasible__c = true,
                            Application_for_Business_Customer__c = true,
                            // Start ----- Energization Requirements fields -----
                            Target_Energization_Date__c = system.today() + 30,
                            Project_Type__c = 'Simple Connection',
                            TLN__c = '1',
                            Pole_Code__c = '11',
                            Service_Wire_Type__c = 'Aerial Alum.,Bundled',
                            Service_Wire_Length__c = 1,
                            Wire_Size__c = '1000 MCM',
                            Material__c = 'Aluminum',
                            Metering_Scheme__c = 'NORMAL',
                            Mode_of_Retrieval__c = 'REMOTE',
                            Applied_Load__c = 1,
                            Phase__c = 'Single Phase (1Ø), Two (2)-Wire',
                            Voltage__c = '115/66 kV',
                            Demand_Factor__c = .80,
                            Load_Factor__c = .35,
                            Contracted_Capacity__c = 0.800,
                            Service_Supply_Type__c = 'Normal with meter',
                            // End ----- Energization Requirements fields -----
                            Service_Rate_Type__c = 'General Service A (GSA)',
                            Billing_Class__c = 'General Service A (GSA)',
                            Deposit_Amount__c = 1000,
                            //START - for newly created validation rules
                            Application_for_Business_Service__c = true,
                            Tax_Identification_No__c = '122222111111',
                            Home_Ownership__c = 'Owned'
                            //END
                            );
            
            listCase.add(caseRecord);
        }
        
        return listCase;
    }
    
    public static List<Contact> createContact(Integer numOfRecord) {
        
        List<Contact> listContact = new List<Contact>();
        
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            
            Contact contactRecord = new Contact(
                            Firstname = 'Firstname' + recordCount,
                            Lastname = 'Lastname',
                            MobilePhone = '+639221231234',
                            Phone = '+6321231234',
                            Email = 'aa@aa.com'
                            );
            
            listContact.add(contactRecord);
        }
        
        return listContact;
    }
    
    public static List<PSIC__c> createPSIC(Integer numOfRecord) {
        
        List<PSIC__c> listPSCI = new List<PSIC__c>();
        
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            
            PSIC__c psciRecord = new PSIC__c(
                            Name = recordCount == 1 ? 'Residential' : 'Name' + recordCount,
                            Demand_Factor__c = recordCount == 1 ? .50 : .85,
                            Load_Factor__c = .35,
                            PSIC_Code__c = recordCount == 1 ? '1' : '7777' + string.valueOf(recordCount)
                            );
            
            listPSCI.add(psciRecord);
        }
        
        return listPSCI;
    }
    
    public static List<Schedule__c> createSchedule(Integer numOfRecord) {
        
        List<Schedule__c> listSchedule = new List<Schedule__c>();
        
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            
            Schedule__c scheduleRecord = new Schedule__c(
                            Non_Residential_Rate__c = 11,
                            Residential_Rate__c = 22,
                            Schedule_Decsription__c = 'AL <= 1.00kW' + 1,
                            Schedule_Selector__c = 'S-' + (recordCount + 1)
                            );
            
            listSchedule.add(scheduleRecord);
        }
        
        return listSchedule;
    }

    /* Description: Create Account
     * Parameters: Integer - number of records to be created
     * Returns: List<Account>
     * Author: Michael Lasala
     * Date Created: FEB-15-17
     */
    public static List<Account> createBusinessAccount(Integer count){
        List<Account> accountList = new List<Account>();
        
        Id businessAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_BUSINESS).getRecordTypeId();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Account acc = new Account();
            acc.RecordTypeId = businessAccountRecordTypeId;
            acc.Tax_Identification_No__c = '1231';
            acc.Name = 'Test'+recordCount;
            acc.Email__c = 'test@test.com';
            acc.Mobile_Phone__c = '+631234567890';
            acc.Phone='+6356748321';
            acc.V10_Customer_No__c = '3242527182';//START/END RReyes - added V10 Customer Number to prevent validation on case
            acc.Customer_Type__c = 'Private';
            accountList.add(acc);
            
        }
        return accountList;
    }

     /* Description: Create Account
     * Parameters: Integer - number of records to be created
     * Returns: List<Account>
     * Author: Von Pernicia
     * Date Created: JUL-12-17
     */
    public static List<Account> createExecutingPersonel(Integer count){
        List<Account> accountList = new List<Account>();
        
        Id executingPerAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_EXECUTING_PERSONEL).getRecordTypeId();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Account acc = new Account();
            acc.RecordTypeId = executingPerAccountRecordTypeId;
            acc.FirstName = 'FName: ' + recordCount;
            acc.MiddleName = 'MName: '+recordCount;
            acc.LastName = 'LName: '+recordCount;
            accountList.add(acc);
        }
        return accountList;
    }

    /* Description: Create Person Account
     * Parameters: Integer - number of records to be created
     * Returns: List<Account>
     * Author: Michael Lasala
     * Date Created: FEB-15-17
     */
    public static List<Account> createPersonAccount(Integer count){
        List<Account> accountList = new List<Account>();

        Id personAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_PERSON).getRecordTypeId();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = 'FName: ' + recordCount;
            acc.MiddleName = 'MName: '+recordCount;
            acc.LastName = 'LName: '+recordCount;
            acc.PersonBirthdate = System.today() - 30;
            acc.Phone = '+6300000000';
            acc.PersonHomePhone = '+6300000000';
            acc.PersonMobilePhone = '+630000000000'; 
            acc.PersonEmail = 'test@test.com';
            acc.Tax_Identification_No__c = '123456789012';
            acc.Mobile_Phone__c = '+630000000000';
            acc.Email__c = 'test@test.com';
            acc.V10_Customer_No__c = '32425271' + count;//START/END RReyes - added V10 Customer Number to prevent validation on case
            acc.Customer_Type__c = 'Private';
            accountList.add(acc);
        }
        return accountList;
    }
    
      /* Description: Create Contact
     * Parameters: contract Id
                   Account Id
                   Case Id
     * Returns: List<Address__c>
     * Author: Vincent Mandolado
     * Date Created: Aug-31-17
     */
    public static Contact createContact(string accountId){
         Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = accountId,
                Email = System.now().millisecond() + 'test@test.com',
                CXE_isPortalContact__c =False
            );
        return contact1;
    }
      
    
      /* Description: Create Contract
     * Parameters: contract Id
                   Account Id
                   Case Id
     * Returns: List<Address__c>
     * Author: Vincent Mandolado
     * Date Created: AUG-30-17
     */
    public static Address__c createAddress(String accountId, 
                                                 String caseId, 
                                                 String contractId){
                                                       
          Address__c testAddress = new Address__c(Type__c = 'Billing', 
          Account__c = accountId,
          Case__c = caseId,
          Contract__c = contractId,
          Address_Street_No__c = '1'); 
               
           return testAddress;                                              
   }

    /* Description: Create Portal User
     * Returns: List<Address__c>
     * Author: Vincent Mandolado
     * Date Created: AUG-30-17
     */
  
    public static User createAdminUser(){
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User adminUseracct = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        return adminUseracct;
    }
    
    public static user createPortalUser(string contactId){
        Profile portalProfile = [SELECT Id FROM Profile Limit 1];
        User user1 = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ContactId = contactId,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        
        return user1;
    }
    
   /*Description: Create Biz Account
    * Returns: List<Account>
    * Author: Melvin Corbes
    * Date Created: Aug-22-2017
    */ 
    public static List<Account> createPersonAccountBiz(Integer count){
        List<Account> accountList = new List<Account>();

        Id personAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_BUSINESS).getRecordTypeId();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Account acc = new Account();
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = 'FName: ' + recordCount + 'Biz';
            acc.MiddleName = 'MName: '+recordCount + 'Biz';
            acc.LastName = 'LName: '+recordCount + 'Biz';
            acc.PersonBirthdate = System.today() - 30;
            acc.Phone = '+6300000000';
            acc.PersonMobilePhone = '+630000000000'; 
            acc.PersonEmail = 'test@test.com';
            acc.Tax_Identification_No__c = '123456789012';
            acc.Mobile_Phone__c = '+630000000000';
            acc.Email__c = 'test@testBiz.com';
            acc.V10_Customer_No__c = '3242527182';//START/END RReyes - added V10 Customer Number to prevent validation on case
            acc.Customer_Type__c = 'Private';
            accountList.add(acc);
        }
        return accountList;
    }
    
    
    
    /* Description: Create Partner Roles
     * Parameters: Integer - number of records to be created
     * Returns: List<Partner Roles>
     * Author: Von Pernicia
     * Date Created: FEB-15-17
     */
     public static List<Partner__c> createPartnerRole(Integer count, Id Partners, Id Accounts){
        List<Partner__c> partnerList = new List<Partner__c>();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Partner__c partnerRecord = new Partner__c(
                            Partners__c = Partners,
                            Account_Name__c = Accounts,
                            Role__c = 'Landlord'
                            );
            
            partnerList.add(partnerRecord);
        }
        return partnerList;
    }

    /* Description: Create Contact Role
     * Parameters: Account Id
                   Contact Id
                   Role
     * Returns: Contact_Role__c
     * Author: Michael Lasala
     * Date Created: FEB-15-17
     */
    public static Contact_Role__c createContactRole(Id accountId, Id contactId, String roleText){
        Contact_Role__c contactRole = new Contact_Role__c();

        contactRole.Account__c = accountId;
        contactRole.ContactName__c = contactId;
        contactRole.Role__c = roleText;

        return contactRole;
    }

    /* Description: Create Sample References    
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * Batangas
     */
    private static Reference__c createSampleProvince(){
        Reference__c refRec =  new Reference__c (  Block__c='BATANGAS',                                  
                                                   Field__c='Province',                                   
                                                   Name='BATANGAS',
                                                   Name_Code__c='01000000000000',                                   
                                                   //Type_CodeID__c='GEOC-PROV-001000000000000',
                                                   Type__c='Geo');
        return refRec;
    }

    /* Description: Create Sample References    
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * SAN ROQUE
     */
    private static Reference__c createSampleBarangay(){
        Reference__c refRec =  new Reference__c (  Block__c='BATANGAS',                                  
                                                   Field__c='Barangay',                                   
                                                   Name='SAN ROQUE',
                                                   Name_Code__c='01029001700000',                                   
                                                   //Type_CodeID__c='GEOC-BARA-001029001700000',                                   
                                                   Type__c='Geo');
        return refRec;
    }

    /* Description: Create Sample References    
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * STO. TOMAS
     */
    private static Reference__c createSampleCity(){
        Reference__c refRec =  new Reference__c (  Block__c='BATANGAS',                                  
                                                   Field__c='City',                                   
                                                   Name='STO. TOMAS',
                                                   Name_Code__c='01029000000000',                                   
                                                   //Type_CodeID__c='GEOC-CITY-001029000000000',
                                                   Type__c='Geo');
        return refRec;
    }

    /* Description: Create Sample References    
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * SAN ROQUE SUBD
     */
    private static Reference__c createSampleStreet(){
        Reference__c refRec =  new Reference__c (  Block__c='BATANGAS',                                  
                                                   Field__c='Street',                                   
                                                   Name='SAN ROQUE SUBD',
                                                   Name_Code__c='1363',                                   
                                                   //Type_CodeID__c='GEOC-STRE-000000000001363',
                                                   Type__c='Geo');
        return refRec;
    }

    /* Description: Create Sample References    
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * SAN ROQUE SUBD
     */
    private static Reference__c createSampleSubdivision(){
        Reference__c refRec = new Reference__c (   Block__c='BATANGAS',                                  
                                                   Field__c='Subdivision',                                   
                                                   Name='SAN ROQUE SUBD',
                                                   Name_Code__c='01029001700007',                                   
                                                   //Type_CodeID__c='GEOC-SUBD-001029001700007',
                                                   Type__c='Geo');
        return refRec;
    }
    /* Description: Create Sample References    
     * Returns: List<Refrence__c>
     * Author: Jerson Poblete
     * Date Created: MAR-23-17
     * 
     */
    private static Reference__c createBillingClass(){
        Reference__c refRec =  new Reference__c (                                   
                                                   Field__c='Billing Class',
                                                Name_Code__c='01029001700007',
                                                   Name='Billing Class Ref'
                                                   );
        return refRec;
    }

    /* Description: Create Sample Address Reference
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * SAN ROQUE SUBD, SAN ROQUE SUBD SAN ROQUE, STO. TOMAS, BATANGAS
     */
    public static List<Reference__c> createSampleReferenceListForAddress(){
        List<Reference__c> addressRef = new List<Reference__c>();
        addressRef.add(createSampleProvince());
        addressRef.add(createSampleCity());
        addressRef.add(createSampleBarangay()); 
        addressRef.add(createSampleSubdivision());       
        addressRef.add(createSampleStreet());
        return addressRef;
    }

    /* Description: Create Address__c
     * Returns: List<Refrence__c>
     * Author: Jerome To
     * Date Created: MAR-06-17
     * SAN ROQUE SUBD, SAN ROQUE SUBD SAN ROQUE, STO. TOMAS, BATANGAS
     */
    public static Address__c createAddress(Map<String, Reference__c> addressReference, Boolean isLookUp){
        Address__c addressRec = new Address__c();
        if(isLookUp) {
            addressRec.Address_Province__c = addressReference.get('Province').Id;
            addressRec.Address_City_Municipality__c = addressReference.get('City').Id;
            addressRec.Address_Barangay__c = addressReference.get('Barangay').Id;
            addressRec.Address_Street_Name__c = addressReference.get('Street').Id;
            addressRec.Address_Subdivision__c =  addressReference.get('Subdivision').Id;
        } else {
            addressRec.Code_Address_Province__c = addressReference.get('Province').Name_Code__c;
            addressRec.Code_Address_City_Municipality__c = addressReference.get('City').Name_Code__c;
            addressRec.Code_Address_Barangay__c = addressReference.get('Barangay').Name_Code__c;
            addressRec.Code_Address_Street_Name__c = addressReference.get('Street').Name_Code__c;
            addressRec.Code_Address_Subdivision__c =  addressReference.get('Subdivision').Name_Code__c;
        }
        addressRec.Premise_Type__c = 'High-rise Building';
        addressRec.Address_Street_No__c = '123';
        return addressRec;
    }

    /* Description: Create Address__c
     * Returns: Address__c
     * Author: Rom Edison Reyes
     * Date Created: MAR-29-17
     * SAN ROQUE SUBD, SAN ROQUE SUBD SAN ROQUE, STO. TOMAS, BATANGAS
     */
    public static Address__c createAddressWithoutReference(String addressType, String caseId, String acctId, String contractId, String serviceId, String contactId, String connectionId){
        Address__c addressRec = new Address__c(Type__c = addressType, 
                                                Account__c = acctId,
                                                Case__c = caseId);
        if(addressType == 'Billing'){
            addressRec.Contract__c = contractId;
            addressRec.Service__c = null;
            addressRec.Contact__c = null;
            addressRec.Connection__c = null;
        }else if(addressType == 'Service'){
            addressRec.Contract__c = null;
            addressRec.Service__c = serviceId;
            addressRec.Contact__c = null;
            addressRec.Connection__c = null;
        }else if(addressType == 'Customer'){
            addressRec.Contract__c = null;
            addressRec.Service__c = null;
            addressRec.Contact__c = contactId;
            addressRec.Connection__c = null;
        }else if(addressType == 'Meter'){
            addressRec.Contract__c = null;
            addressRec.Service__c = null;
            addressRec.Contact__c = null;
            addressRec.Connection__c = connectionId;
        }
        addressRec.Premise_Type__c = 'High-rise Building';
        addressRec.Address_Street_No__c = '123';
        return addressRec;
    }

    public testMethod static void createAddressReference(){
        List<Reference__c> testReferenceList = new List<Reference__c>();

        Reference__c provinceReference = new Reference__c(Block__c='BATANGAS', 
                                                          Field__c='Province', 
                                                          Name='BATANGAS', 
                                                          Name_Code__c='01000000000000', 
                                                          Type__c='Geo');

        Reference__c cityReference = new Reference__c(Block__c='BATANGAS', 
                                                      Field__c='City', 
                                                      Name='STO. TOMAS',
                                                      Name_Code__c='01029000000000', 
                                                      Parent_Code__c='01000000000000', 
                                                      Type__c='Geo');

        Reference__c barangayReference = new Reference__c(Block__c='BATANGAS', 
                                                          Field__c='Barangay', 
                                                          Name='SAN ROQUE', 
                                                          Name_Code__c='01029001700000', 
                                                          Parent_Code__c='01029000000000', 
                                                          Type__c='Geo');

        Reference__c subdivisionReference = new Reference__c(Block__c='BATANGAS', 
                                                             Field__c='Subdivision', 
                                                             Name='SAN ROQUE SUBD', 
                                                             Name_Code__c='01029001700007', 
                                                             Parent_Code__c='01029001700000', 
                                                             Type__c='Geo');
        

        Reference__c streetReference = new Reference__c(Block__c='BATANGAS', 
                                                        Field__c='Street', 
                                                        Name='SAN ROQUE SUBD', 
                                                        Name_Code__c='1363', 
                                                        Parent_Code__c='01029001700007', 
                                                        Type__c='Geo');
        testReferenceList.add(provinceReference);
        testReferenceList.add(cityReference);
        testReferenceList.add(barangayReference);
        testReferenceList.add(subdivisionReference);
        testReferenceList.add(streetReference);
        insert testReferenceList;

    }

    public static Address__c createAddress(String parentField, String parentId){
        createAddressReference();
        
        Reference__c createdProvince = [SELECT Id FROM Reference__c WHERE Field__c = 'Province' LIMIT 1];
        Reference__c createdCity = [SELECT Id FROM Reference__c WHERE Field__c = 'City' LIMIT 1];
        Reference__c createdBaranagay = [SELECT Id FROM Reference__c WHERE Field__c = 'Barangay' LIMIT 1];
        Reference__c createdSubdivision = [SELECT Id FROM Reference__c WHERE Field__c = 'Subdivision' LIMIT 1];
        Reference__c createdStreet = [SELECT Id FROM Reference__c WHERE Field__c = 'Street' LIMIT 1];
        
        createdStreet.Parent__c = createdSubdivision.Id;
        createdSubdivision.Parent__c = createdBaranagay.Id;
        createdBaranagay.Parent__c = createdCity.Id;
        createdCity.Parent__c = createdProvince.Id;

        List<Reference__c> updateReferenceList = new List<Reference__c>();
        updateReferenceList.add(createdStreet);
        updateReferenceList.add(createdSubdivision);
        updateReferenceList.add(createdBaranagay);
        updateReferenceList.add(createdCity);
        update updateReferenceList;

        Address__c testAddress = new Address__c(Type__c = 'Service', 
                                                Premise_Type__c = 'Single-Detached Residential', 
                                                Address_Unit_No__c = '1', 
                                                Address_Street_No__c = '2', 
                                                Address_Street_Name__c = createdStreet.Id,
                                                Address_Subdivision__c = createdSubdivision.Id, 
                                                Address_Barangay__c = createdBaranagay.Id, 
                                                Address_City_Municipality__c = createdCity.Id,
                                                Address_Province__c = createdProvince.Id);
        testAddress.put(parentField, parentId);
        if(parentField == 'Contract__c'){
            testAddress.Type__c = 'Billing';
        }else if(parentField == 'Contact__c'){
            testAddress.Type__c = 'Customer';
        }else if(parentField == 'Connection__c'){
            testAddress.Type__c = 'Meter';
        }

        return testAddress;
    }

    /* Description: Create Contract
     * Parameters: Integer - number of records to be created
                   Account Id
                   Case Id
     * Returns: List<Contract>
     * Author: Michael Lasala
     * Date Created: MAR-06-17
     */
    public static List<Contract> createContract(Integer count, String accountId, String caseId){
        List<Contract> contractList = new List<Contract>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            Contract con = new Contract();
            con.AccountId = accountId;
            con.Case__c = caseId;
            con.Status = 'Draft'; //START/END JUL-12-17 RReyes
            contractList.add(con);
        }
        return contractList;
    }
    
    
    //Start Rabayon 10/19/2017
        
     public static List<CXE_Service_Enrollment__c> ServiceEnrollment(Integer count, String Service, String PortalUser){
        List<CXE_Service_Enrollment__c> serviceEnrollmentList = new List<CXE_Service_Enrollment__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            CXE_Service_Enrollment__c servE = new CXE_Service_Enrollment__c();
            servE.CXE_ServiceId__c = Service;
            servE.CXE_IsActive__c = True;
            servE.CXE_UserId__c = PortalUser;

            serviceEnrollmentList.add(servE);
        }
        return serviceEnrollmentList;
    }
    
    
    //End Rabayon 10/19/2017
    
    

    /* Description: Create Service (Agreement__c)
     * Parameters: Integer - number of records to be created
     * Returns: List<Agreement__c>
     * Author: Michael Lasala
     * Date Created: MAR-06-17
     * Updated: Vincent Mandolado - R2B
     * Date Updated: Aug-31-17
     */
    public static List<Agreement__c> createServiceWithLessDetails(Integer count, 
                                                   String accountId, 
                                                   String caseId, 
                                                   String contractId, 
                                                   String psicId){

        List<Agreement__c> serviceList = new List<Agreement__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            Agreement__c service = new Agreement__c();
            service.Account__c = accountId;
            service.Case__c = caseId;
            service.Contract__c = contractId;
            service.Payor__c = contractId;
            //service.PSIC__c = psicId;
            service.Rate__c = 'General Service A (GSA)';
            service.Segment__c = 'Home and Micro Business';
            service.Service_Status__c = 'Active';
            //service.Phase__c = 'Single Phase (1Ø), Network'; //vincent
            service.Service_Supply_Type__c = 'Normal with meter';
            service.Service_Wire_Material__c = 'Copper';
            service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            //service.Service_Wire_Size__c = '#1/0';
            //service.Service_Wire_Pole_Number__c = '1'; //vincent
            //service.Load_Factor__c = 0.25; //vincent
            //service.Demand_Factor__c = 0.50; //vincent
            //service.Contracted_Capacity__c = 0.500; //vincent
            //service.Service_Wire_Length__c = 1;
            //service.Service_Wire_Type__c = 'Under Copper,Lateral';
            //service.Voltage_Level__c = '4.8 kV';
            //service.Applied_Load__c = 50;
            serviceList.add(service);
        }
        return serviceList;
    }
    
    /* Description: Create Service (Agreement__c)
     * Parameters: Integer - number of records to be created
     * Returns: List<Agreement__c>
     * Author: Michael Lasala
     * Date Created: MAR-06-17
     */
    public static List<Agreement__c> createService(Integer count, 
                                                   String accountId, 
                                                   String caseId, 
                                                   String contractId, 
                                                   String psicId){

        List<Agreement__c> serviceList = new List<Agreement__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            Agreement__c service = new Agreement__c();
            service.Account__c = accountId;
            service.Case__c = caseId;
            service.Contract__c = contractId;
            service.Payor__c = contractId;
            service.PSIC__c = psicId;
            service.Rate__c = 'General Power (GP)';
            service.Segment__c = 'Home and Micro Business';
            service.Service_Supply_Type__c = 'Normal with meter';
            service.Service_Wire_Material__c = 'Copper';
            service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
            service.Service_Wire_Size__c = '#1/0';
            service.Service_Wire_Type__c = 'Under Copper,Lateral';
            service.Voltage_Level__c = '4.8 kV';
            service.Applied_Load__c = 50; //START/END RReyes JUL-08-17 changed to prevent validation
            serviceList.add(service);
        }
        return serviceList;
    }
    
    /* Description: Create Reference Picklist 
     * Parameters: Integer - number of records to be created
     * Returns: List<Reference__c>
     * Author: Von Pernicia (Accenture)
     * Date Created: MAR-07-17
     */
    public static List<Reference__c> createReferencePicklist(Integer count, String field){

        List<Reference__c> refList = new List<Reference__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
          Reference__c r = new Reference__c(
                Name = 'Name' + string.ValueOf(recordCount),
                Type__c = 'Picklist',
                Name_Code__c = string.ValueOf(recordCount),
                Field__c = field
                );
           
            refList.add(r);
        }
        return refList;
    }
    
    /* Description: Create User
     * Parameters: Integer - number of records to be created
     * Returns: List<User>
     * Author: Von Pernicia (Accenture)
     * Date Created: MAR-07-17
     */
    public static List<User> createUser(Integer count, String profileName){

        List<User> userList = new List<User>();
        
        Profile ProfileID = [select ID from Profile where Name =: profileName];
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
        User u = new User(
                    Alias = 'stndrd',
                    Email = 'UserRecordTest' + recordCount + '@test.com', 
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'LastName' + recordCount,
                    LanguageLocaleKey = 'en_US', 
                    LocaleSidKey = 'en_US',
                    ProfileId = ProfileID.Id, 
                    TimeZoneSidKey = 'America/Los_Angeles',
                    UserName = 'UserRecordTest' + recordCount + '@test.com'
                    );
           
            userList.add(u);
        }
        return userList;
    }
   
    public static List<Connection__c> createConnection(Integer count){
        List<Connection__c> connectionList = new List<Connection__c>();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Connection__c con = new Connection__c();
            con.Utility_type__c = 'Electricity';
            connectionList.add(con);
        }
        return connectionList;
    }
    
    public static List<Field_Order__c> createFieldOrder(Integer count){
        List<Field_Order__c> fieldOrderList = new List<Field_Order__c>();

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Field_Order__c fo = new Field_Order__c();
            fieldOrderList.add(fo);
        }
        return fieldOrderList;
    }
    
    public static List<Reference__c> createReference(Integer count, String field){
        List<Reference__c> referenceList = new List<Reference__c>();
        String fieldValue = field;

        for(Integer recordCount=0; recordCount<count; recordCount++){
            Reference__c ref = new Reference__c();
            ref.Name = 'Sample Reference ' + recordCount;
            ref.Type__c = 'Geo';
            ref.Field__c = fieldValue;
            referenceList.add(ref);
        }
        return referenceList;
    }
    
    public static List<Office__c> createOffice(Integer count)
    {
        List<Office__c> officeList = new List<Office__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            Office__c off = new Office__c();
            off.Level__c = 'G4';
            off.Remarks__c = 'Sample Remarks';
            
            officeList.add(off);
        }
        return officeList;
        
    }
    
    public static List<Office_Jurisdiction__c> createOfficeJurisdiction(Integer count)
    {
        List<Office_Jurisdiction__c> officeJurList = new List<Office_Jurisdiction__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            Office_Jurisdiction__c offJur = new Office_Jurisdiction__c();
            
            officeJurList.add(offJur);
        }
        return officeJurList;
        
    }

    public static List<Lead> createCreateLead(Integer count)
    {
        List<Lead> leadList = new List<Lead>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            Lead leadRecord = new Lead(
            Firstname = 'FirstName' + recordCount,
            Lastname = 'Lastname' + recordCount,
            LeadSource = 'Web',
            Status = 'Open',
            Email = 'test1234abc@gmail.com'        
            );
            
            leadList.add(leadRecord);
        }
        return leadList;
        
    }

    public static Rate__c createRate() {
        Rate__c rateRecord = new Rate__c();
        rateRecord.Base_Fixed_Metering_Charge__c = 1;
        rateRecord.Base_Fixed_Supply_Charge__c = 1;
        rateRecord.Cross_Subsidy_Charge__c = 0;
        rateRecord.DC_General_Service_B_Per_kWh__c = 0.1368;
        rateRecord.DC_General_Service_B_Per_kW__c = 237.15;
        rateRecord.DC_GHMSCI__c = 0.8667;
        rateRecord.DC_GP_Secondary_per_kWh__c = 0.1368;
        rateRecord.DC_GP_Secondary_per_kW__c = 237.15;
        rateRecord.DC_GP_Type_AB_per_kWh__c = 0.0513;
        rateRecord.DC_GP_Type_AB_per_kW__c = 143.32;
        rateRecord.DC_GP_Type_C_per_kWh__c = 0.0513;
        rateRecord.DC_GP_Type_C_per_kW__c = 182.66;
        rateRecord.DC_GP_Type_D_per_kWh__c = 0.0513;
        rateRecord.DC_GP_Type_D_per_kW__c = 182.66;
        rateRecord.DC_GP_Type_E_per_kWh__c = 0.0513;
        rateRecord.DC_GP_Type_E_per_kW__c = 182.66;
        rateRecord.DC_Res_Gen_Service_A_201_300_Per_kWh__c = 1.3183;
        rateRecord.DC_Res_Gen_Service_A_301_400_Per_kWh__c = 1.6175;
        rateRecord.DC_Res_Gen_Service_A_401_kWh_and_Up__c = 2.1387;
        rateRecord.DC_Res_Gen_Service_A_Up_to_200_Per_k__c = 1.0012;
        rateRecord.DUs_Stranded_Contract_Cost_kWh__c = 0;
        rateRecord.Equalization_Taxes_and_Royalties_kWh__c = 0;
        rateRecord.Fit_All__c = 0.124;
        rateRecord.Generation_Charge_for_Non_TOU__c = 4.3212;
        rateRecord.Gen_Charge_for_TOU_GCA__c = 2;
        rateRecord.Gen_Charge_for_TOU_Weekday_Offpeak_DO__c = 2;
        rateRecord.Gen_Charge_for_TOU_Weekday_Peak_DP__c = 2;
        rateRecord.Gen_Charge_for_TOU_Weekend_Offpeak_EO__c = 2;
        rateRecord.Gen_Charge_for_TOU_Weekend_Peak_DP__c = 2;
        rateRecord.Lifeline_Discount_0_20__c = 2;
        rateRecord.Lifeline_Discount_21_50__c = 2;
        rateRecord.Lifeline_Discount_51_70__c = 2;
        rateRecord.Lifeline_Discount_71_100__c = 2;
        rateRecord.Lifeline_Subsidy__c = 0.089;
        rateRecord.MCPC_Gen_Service_B_Per_Cust_Month__c = 2;
        rateRecord.MCPC_Residential_Per_Cust_Month__c = 2;
        rateRecord.MC_General_Service_B_Per_Cust_month__c = 362.34;
        rateRecord.MC_GHMSCI_Per_Cust_month__c = 278.46;
        rateRecord.MC_GP_LARGE_Per_Cust_month__c = 3525.12;
        rateRecord.MC_GP_MEDIUM_Per_Cust_month__c = 849.44;
        rateRecord.MC_GP_VERY_LARGE_Per_Cust_month__c = 12075.11;
        rateRecord.MC_Res_Gen_Service_A_Per_Cust_month__c = 5;
        rateRecord.MC_Res_Gen_Service_A_Per_kWh__c = 0.3377;
        rateRecord.Metering_Charge_Per_Customer__c = 2;
        //rateRecord.Month_Code__c = 5;
        rateRecord.Month__c = 'May';
        rateRecord.NPC_Stranded_Debts_kWh__c = 0;
        rateRecord.Power_Act_Reduction__c = 2;
        rateRecord.Power_Factor_Adjustment__c = 0;
        rateRecord.Previous_Month_s_Adjustment_on_Generatio__c = 2;
        rateRecord.SCPC_General_Service_Per_Cust_Month__c = 2;
        rateRecord.SCPC_Residential_Per_Cust_Month__c = 2;
        rateRecord.SC_General_Service_B_Per_Cust_month__c = 371.48;
        rateRecord.SC_GHMSCI_Per_Cust_month__c = 278.59;
        rateRecord.SC_GP_LARGE_Per_Cust_month__c = 3505.46;
        rateRecord.SC_GP_MEDIUM_Per_Cust_month__c = 845.17;
        rateRecord.SC_GP_VERY_LARGE_Per_Cust_month__c = 12726.3;
        rateRecord.SC_Res_Gen_Service_A_Per_Cust_month__c = 16.73;
        rateRecord.SC_Res_Gen_Service_A_Per_kWh__c = 0.5085;
        rateRecord.Senior_Citizen_Discount_Household__c = 2;
        rateRecord.Senior_Citizen_Discount_Institution__c = 2;
        rateRecord.Senior_Citizen_Subsidy__c = 0.000100;
        rateRecord.SLC_General_Service_B__c = 0.4381;
        rateRecord.SLC_GHMSCI__c = 0.4381;
        rateRecord.SLC_GP_Secondary__c = 0.4381;
        rateRecord.SLC_GP_Type_AB__c = 0.0418;
        rateRecord.SLC_GP_Type_C__c = 0.1705;
        rateRecord.SLC_GP_Type_D__c = 0.1705;
        rateRecord.SLC_GP_Type_E__c = 0.1705;
        rateRecord.SLC_Res_Gen_Services_A_P_kWh__c = 0.4381;
        rateRecord.Special_Discount_5_kW__c = 2;
        rateRecord.Special_Discount_M5_kW__c = 2;
        rateRecord.SPKI_Gen_Service_B_Per_kWh__c = 2;
        rateRecord.SPKI_Residential_Per_kWh__c = 2;
        rateRecord.Supply_per_kWh_Incremental__c = 2;
        rateRecord.TC_General_Service_B__c = 267.4385;
        rateRecord.TC_GHMS__c = 1.0361;
        rateRecord.TC_GP_Secondary__c = 296.062;
        rateRecord.TC_GP_Type_AB__c = 281.2775;
        rateRecord.TC_GP_Type_C__c = 364.328;
        rateRecord.TC_GP_Type_D__c = 319.8357;
        rateRecord.TC_GP_Type_E__c = 319.8357;
        rateRecord.TC_Residential_General_Service_A__c = 0.9051;
        rateRecord.TC_Transmission_Charge_non_VAT__c = 94.78;
        rateRecord.TC_Transmission_Charge_VATable__c = 5.22;
        rateRecord.TOU_Coverage_End_Date__c = null;
        rateRecord.TOU_Coverage_Start_Date__c = null;
        rateRecord.Universal_Charge_Environmental_Charge__c = 0.0025;
        rateRecord.Universal_Charge_Missionary_Electrific__c = 0.1561;
        rateRecord.Universal_Charge_Stranded_Contract_Cos__c = 0.1938;
        rateRecord.VAT_Adjustment_on_Generation_Cost__c = 0;
        rateRecord.VAT_Generation_Charge__c = 11.18;
        rateRecord.VAT_Lifeline_Rate_Subsidy__c = 12;
        rateRecord.VAT_Other_Charges__c = 12;
        rateRecord.VAT_Power_Act_Reduction__c = 0;
        rateRecord.VAT_System_Loss_Charge__c = 9.32;
        rateRecord.VAT_Transmission_Charge_VATable__c = 12;
        rateRecord.Year__c = '2017';
        return rateRecord;        
    }
    
    /* Description: Create VIP Contact
     * Parameters: Integer - number of records to be created
     * Returns: List<VIP_Contact__c>
     * Author: GGrandea (Accenture)
     * Date Created: JUN-29-17 (CSM-7202)
     */
    public static List<VIP_Contact__c> createVIPContact(Integer count)
    {
        List<VIP_Contact__c> recList = new List<VIP_Contact__c>();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            VIP_Contact__c rec = new VIP_Contact__c();

            rec.First_Name__c = 'FirstName';
            rec.Last_Name__c = 'LastName';
            rec.Primary_Mobile__c = '+630102224444';
            
            recList.add(rec);
        }
        return recList;
        
    }
    
    /* Description: Create Modification of Electric Service Case
     * Parameters: Integer numOfRecord - number of records to be created
     * Parameters: String serviceId - Id of the related service
     * Parameters: String serviceRequests - values in the Service Request/s field separated by semi-colon. ex. 'Change in Name; Additional Load'
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: JUL-07-17
     */
    public static List<Case> createModificationCase(Integer numOfRecord, String serviceId, String serviceRequests) 
    {    
        List<Case> listCase = new List<Case>();
        Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
        
        if(serviceRequests == null){
            serviceRequests = '';
        }
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            Case caseRecord = new Case();
            caseRecord.RecordTypeId = modifyRecTypeId;
            caseRecord.Origin = 'Walk in';
            caseRecord.CXE_Service_Request_s__c = serviceRequests;
            caseRecord.CXE_Service__c = serviceId;
            caseRecord.Target_Energization_Date__c = system.today() + 30;
            listCase.add(caseRecord);
        }       
        return listCase;
    }

    /* Description: Create Termination of Electric Service Case
     * Parameters: Integer numOfRecord - number of records to be created
     * Parameters: String serviceId - Id of the related service
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: JUL-07-17
     */
    public static List<Case> createTerminationCase(Integer numOfRecord, String serviceId) 
    {       
        List<Case> listCase = new List<Case>();
        Id terminateRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_TERMINATION_OF_ELECTRIC_SERVICE).getRecordTypeId();

        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            Case caseRecord = new Case();
            caseRecord.RecordTypeId = terminateRecTypeId;
            caseRecord.Origin = 'Walk in';
            caseRecord.CXE_Service__c = serviceId;
            caseRecord.Target_Energization_Date__c = system.today() + 30;
            listCase.add(caseRecord);
        }       
        return listCase;
    }
    
    /* Description: Create Recontract of Electric Service Case
     * Parameters: Integer numOfRecord - number of records to be created
     * Parameters: String previousSIN - SIN of the terminated service to be retrieved
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: JUL-07-17
     */
    public static List<Case> createRecontractCase(Integer numOfRecord, String previousSIN)
    {       
        List<Case> listCase = new List<Case>();
        Id recontractRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();
        
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            Case caseRecord = new Case();
            caseRecord.RecordTypeId = recontractRecTypeId;
            caseRecord.Origin = 'Walk in';
            caseRecord.CXE_Previous_SIN__c = previousSIN;
            caseRecord.Target_Energization_Date__c = system.today() + 30;
            listCase.add(caseRecord);
        }       
        return listCase;
    }

    /* Description: Create Integration Settings (Custom Setting)
     * Parameters: Integer numOfRecord - number of records to be created
     * Parameters: String previousSIN - SIN of the terminated service to be retrieved
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: JUL-07-17
     */
    public static List<Integration_Settings__c> createIntegrationSettings()
    {       
        List<Integration_Settings__c> lstIntegSettings = new List<Integration_Settings__c>();

        Integration_Settings__c getArrears = new Integration_Settings__c();
        getArrears.Name = 'getArrears';
        getArrears.Endpoint__c = 'https://api-dev.test.com.ph/dummy';
        getArrears.Username__c = 'getArrearsUname';
        getArrears.Password__c = 'getArrearsPWord';

        Integration_Settings__c retrieveTerminatedService = new Integration_Settings__c();
        retrieveTerminatedService.Name = 'retrieveTerminatedService';
        retrieveTerminatedService.Endpoint__c = 'https://api-dev.test.com.ph/dummy';
        retrieveTerminatedService.Username__c = 'retrieveTerminatedService';
        retrieveTerminatedService.Password__c = 'retrieveTerminatedService';

        Integration_Settings__c updateBillPrintMode = new Integration_Settings__c();
        updateBillPrintMode.Name = 'updateBillPrintMode';
        updateBillPrintMode.Endpoint__c = 'https://api-dev.test.com.ph/dummy';
        updateBillPrintMode.Username__c = 'updateBillPrintMode';
        updateBillPrintMode.Password__c = 'updateBillPrintMode';

        lstIntegSettings.add(getArrears);
        lstIntegSettings.add(retrieveTerminatedService);
        lstIntegSettings.add(updateBillPrintMode);

        return lstIntegSettings;
    }

    /* Description: Create Rate
     * Parameters: Integer numOfRecord - number of records to be created
     * Returns: List<Rate__c>
     * Author: Von Pernicia (Accenture)
     * Date Created: JUL-12-17
     */
    public static List<Rate__c> createIntegrationSettings(Integer numOfRecord)
    {       
        List<Rate__c> listCase = new List<Rate__c>();
        
        DateTime d = datetime.now();
        String monthName= d.format('MMMMM');
        String nYear = String.valueOf(System.Today().year());

        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            Rate__c caseRecord = new Rate__c(
                VAT_Adjustment_on_Generation_Cost__c = 1,
                Base_Fixed_Metering_Charge__c = 1,
                Base_Fixed_Supply_Charge__c = 1,
                Cross_Subsidy_Charge__c = 1,
                DC_General_Service_B_Per_kW__c = 1,
                DC_General_Service_B_Per_kWh__c = 1,
                DC_GHMSCI__c = 1,
                DC_GP_Secondary_per_kW__c = 1,
                DC_GP_Secondary_per_kWh__c = 1,
                DC_GP_Type_AB_per_kW__c = 1,
                DC_GP_Type_AB_per_kWh__c = 1,
                DC_GP_Type_C_per_kW__c = 1,
                DC_GP_Type_C_per_kWh__c = 1,
                DC_GP_Type_D_per_kW__c = 1,
                DC_GP_Type_D_per_kWh__c = 1,
                DC_GP_Type_E_per_kW__c = 1,
                DC_GP_Type_E_per_kWh__c = 1,
                DC_Res_Gen_Service_A_201_300_Per_kWh__c = 1,
                DC_Res_Gen_Service_A_301_400_Per_kWh__c = 1,
                DC_Res_Gen_Service_A_401_kWh_and_Up__c = 1,
                DC_Res_Gen_Service_A_Up_to_200_Per_k__c = 1,
                DUs_Stranded_Contract_Cost_kWh__c = 1,
                Equalization_Taxes_and_Royalties_kWh__c = 1,
                Fit_All__c = 1,
                Gen_Charge_for_TOU_GCA__c = 1,
                Gen_Charge_for_TOU_Weekday_Offpeak_DO__c = 1,
                Gen_Charge_for_TOU_Weekday_Peak_DP__c = 1,
                Gen_Charge_for_TOU_Weekend_Offpeak_EO__c = 1,
                Gen_Charge_for_TOU_Weekend_Peak_DP__c = 1,
                VAT_Generation_Charge__c = 1,
                Generation_Charge_for_Non_TOU__c = 1,
                Lifeline_Discount_0_20__c = 1,
                Lifeline_Discount_21_50__c = 1,
                Lifeline_Discount_51_70__c = 1,
                Lifeline_Discount_71_100__c = 1,
                VAT_Lifeline_Rate_Subsidy__c = 1,
                Lifeline_Subsidy__c = 1,
                MC_General_Service_B_Per_Cust_month__c = 1,
                MC_GHMSCI_Per_Cust_month__c = 1,
                MC_GP_LARGE_Per_Cust_month__c = 1,
                MC_GP_MEDIUM_Per_Cust_month__c = 1,
                MC_GP_VERY_LARGE_Per_Cust_month__c = 1,
                MC_Res_Gen_Service_A_Per_Cust_month__c = 1,
                MC_Res_Gen_Service_A_Per_kWh__c = 1,
                MCPC_Gen_Service_B_Per_Cust_Month__c = 1,
                MCPC_Residential_Per_Cust_Month__c = 1,
                Metering_Charge_Per_Customer__c = 1,
                Month__c = monthName,
                NPC_Stranded_Debts_kWh__c = 1,
                VAT_Other_Charges__c = 1,
                VAT_Power_Act_Reduction__c = 1,
                Power_Act_Reduction__c = 1,
                Power_Factor_Adjustment__c = 1,
                Previous_Month_s_Adjustment_on_Generatio__c = 1,
                SC_General_Service_B_Per_Cust_month__c = 1,
                SC_GHMSCI_Per_Cust_month__c = 1,
                SC_GP_LARGE_Per_Cust_month__c = 1,
                SC_GP_MEDIUM_Per_Cust_month__c = 1,
                SC_GP_VERY_LARGE_Per_Cust_month__c = 1,
                SC_Res_Gen_Service_A_Per_Cust_month__c = 1,
                SC_Res_Gen_Service_A_Per_kWh__c = 1,
                SCPC_General_Service_Per_Cust_Month__c = 1,
                SCPC_Residential_Per_Cust_Month__c = 1,
                Senior_Citizen_Discount_Household__c = 1,
                Senior_Citizen_Discount_Institution__c = 1,
                Senior_Citizen_Subsidy__c = 1,
                SLC_General_Service_B__c = 1,
                SLC_GHMSCI__c = 1,
                SLC_GP_Secondary__c = 1,
                SLC_GP_Type_C__c = 1,
                SLC_GP_Type_D__c = 1,
                SLC_GP_Type_E__c = 1,
                SLC_Res_Gen_Services_A_P_kWh__c = 1,
                SLC_GP_Type_AB__c = 1,
                Special_Discount_M5_kW__c = 1,
                Special_Discount_5_kW__c = 1,
                SPKI_Gen_Service_B_Per_kWh__c = 1,
                SPKI_Residential_Per_kWh__c = 1,
                Supply_per_kWh_Incremental__c = 1,
                VAT_System_Loss_Charge__c = 1,
                TC_General_Service_B__c = 1,
                TC_GHMS__c = 1,
                TC_GP_Secondary__c = 1,
                TC_GP_Type_AB__c = 1,
                TC_GP_Type_C__c = 1,
                TC_GP_Type_D__c = 1,
                TC_GP_Type_E__c = 1,
                TC_Residential_General_Service_A__c = 1,
                TC_Transmission_Charge_non_VAT__c = 1,
                TC_Transmission_Charge_VATable__c = 1,
                TOU_Coverage_End_Date__c = system.today(),
                TOU_Coverage_Start_Date__c = system.today(),
                VAT_Transmission_Charge_VATable__c = 1,
                Universal_Charge_Environmental_Charge__c = 1,
                Universal_Charge_Missionary_Electrific__c = 1,
                Universal_Charge_Stranded_Contract_Cos__c = 1,
                Year__c = nYear
            );
            
            listCase.add(caseRecord);
        }       
        return listCase;
    }

    /* Description: Create Integration Settings (Custom Setting)
     * Parameters: Integer numOfRecord - number of records to be created
     * Parameters: String previousSIN - SIN of the terminated service to be retrieved
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: JUL-07-17
     */
    public static LFT_TRAC_Table__c createLFT_TRAC_Table()
    {       
        
        LFT_TRAC_Table__c getLFT = new LFT_TRAC_Table__c();
        getLFT.Name = 'ALAMINOS';
        getLFT.LFT_Rate__c = 2;
        getLFT.TRAC_Rate__c = 2;
        
        return getLFT;
    }

    /* Description: Retrieve Guest Portal User
     * Returns: User
     * Author: Gavi Grandea (Accenture)
     * Date Created: AUG-18-17
     */
    public static User getPortalGuestUser(){
        return [SELECT Id, Name FROM User WHERE Profile.Name =: CXE_Constants.PORTAL_GUEST_PROFILE LIMIT 1];
    }
    
    /* Description: Create Integration Settings (Custom Setting)
     * Parameters: Integer numOfRecord - number of records to be created
     * Parameters: String previousSIN - SIN of the terminated service to be retrieved
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: AUG-30-17
     */
    public static List<Service_Request_Fields__c> createServReFieldsCS()
    {       
        List<Service_Request_Fields__c> lstSRF = new List<Service_Request_Fields__c>();
        Map<String, String> mapReqTypeToName = new Map<String, String>();
        Service_Request_Fields__c srf = new Service_Request_Fields__c();
        mapReqTypeToName.put('Add/Reduction Load', 'Applied_Load__c');
        mapReqTypeToName.put('Change in Contract Name', 'First_Name__c');
        mapReqTypeToName.put('Remodel', 'CXE_Service_Supply_Phase__c');
        mapReqTypeToName.put('Remodel/Relocation', 'TLN__c');

        for(String srfType: mapReqTypeToName.keySet()){
            srf = new Service_Request_Fields__c();
            srf.Request_Type__c = srfType;
            srf.Name = mapReqTypeToName.get(srfType);
            lstSRF.add(srf);
        }
        
        return lstSRF;
    }

   //test create portal user
    public static List<User> createPortalUser(Integer count,Id AccountOwner){
        
        Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = AccountOwner,
                Phone = '+63021234567',
                Tax_Identification_No__c = '123456789012',
                Mobile_Phone__c = '+630000000000',
                Email__c = 'test@test.com'
               
            );
            Database.insert(portalAccount1);
        
        //Create contact
            Contact portalContact = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com',
                CXE_isPortalContact__c =False
            );
        
        List<User> userList = new List<User>();
        Profile portalProfile = [SELECT Id FROM Profile Limit 1];
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
            User u = new User(
                Alias = 'stndrd',
                Email = 'UserRecordTest' + recordCount + '@test.com', 
                EmailEncodingKey = 'UTF-8',
                LastName = 'LastName' + recordCount,
                LanguageLocaleKey = 'en_US', 
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'UserRecordTest' + recordCount + '@test.com',
                ProfileId = portalProfile.Id,
                ContactId =portalContact.Id
            );
            
            userList.add(u);
        }
        return userList;
    }
    
  
 
   
    
    /* Description: [CSM-13922] Setup Settings for Test Classes
     * Parameters: none
     * Author:  (Accenture)
     * Date Created: OCT-17-2017
     */
    public static void setOrgSettings(){
        //User adminUser = CXE_TestDataFactory.createAdminUser();
        //insert adminUser;

        List<User> migrationUser = [SELECT Id FROM User 
                                            WHERE Name = 'Meralco' 
                                        AND Profile.Name = 'System Administrator' 
                                        AND UserRole.Name = 'CRS Head'];


        OrganizationSettings__c orgSet = new OrganizationSettings__c();
        orgSet.Heroku_Basic_Auth__c = '123456';
        orgSet.HerukoEndpointGetBills__c = 'https://domain.sample';
        orgSet.HerukoEndpointGetPayments__c = 'https://domain.sample';
        orgSet.HerokuEndpointGetConsumption__c = 'https://domain.sample';
        orgSet.HerukoEndpointGetPDFUrl__c = 'https://domain.sample';
        orgSet.Heroku_Url__c = 'https://domain.sample';
       
        if(!migrationUser.isEmpty()){
            orgSet.Default_Account_Owner__c = migrationUser[0].Id;
        }
        //orgSet.Default_Account_Owner__c = adminUser.Id;
        insert orgSet;
    }


    /* Description: [CSM-13922] Create a DMS_Document__c record
     * Parameters: none
     * Author:  (Accenture)
     * Date Created: OCT-17-2017
     */
    public static void createDMSDocument(){
        DMS_Document__c dmsDoc = new DMS_Document__c();
        insert dmsDoc;
    }
    
    /* Description: CSM-13922 setup portal data
     * Parameters: none
     * Author: Jerome To (Accenture)
     * Date Created: OCT-19-2017
     */
    public static void setupPortalData(String segment, Boolean isPersonAccount){
        CXE_TestDataFactory.setOrgSettings(); 

        //Create PSIC
        List<PSIC__c> psicLst = CXE_TestDataFactory.createPSIC(1);
        psicLst[0].Name = 'Non-Residential';
        psicLst[0].Demand_Factor__c = .80;
        psicLst[0].PSIC_Code__c = '77770';
        insert psicLst;

        //Create account
        List<Account> acctList = new List<Account>();
        if(ispersonAccount) {
            acctList = CXE_TestDataFactory.createPersonAccount(1);
            acctList[0].FirstName = 'first';
            acctList[0].MiddleName = 'middle';
            acctList[0].LastName = 'last';
            acctList[0].Email__c = 'first_last_name@yopmail.com';
        } else {
            acctList = CXE_TestDataFactory.createBusinessAccount(1);
        }

        insert acctList;

        Account acct = [SELECT Id, PersonContactId FROM Account WHERE Id =: acctList[0].Id ];
        //Create Case
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();  
        List<Case> createCase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        createCase[0].RecordTypeId = newServiceApplicationRecordTypeId;
        createCase[0].PSIC__c = psicLst[0].id;
        if(isPersonAccount) {
            createCase[0].ContactId = acct.PersonContactId;
        }
        createCase[0].AccountId = acct.Id;
        createCase[0].Applied_Load__c = 6;
        createCase[0].Demand_Factor__c = 0.50;
        createCase[0].Load_Factor__c = 0.25;
        createCase[0].Phase__c = 'Single Phase (1Ø), Network';
        createCase[0].Service_Supply_Type__c = 'Normal with meter';
        createCase[0].Service_Wire_Length__c = 1;
        createCase[0].Material__c = 'Copper';
        createCase[0].Pole_Code__c = '1';
        createCase[0].Wire_Size__c = '#1/0';
        createCase[0].Service_Wire_Type__c = 'Under Copper,Lateral';
        createCase[0].Voltage__c = '2.0 kV';
        createCase[0].Application_for_Business_Customer__c = !isPersonAccount;
        createCase[0].Application_for_Residential_Customer__c = isPersonAccount;        
        insert createCase;

        
        //Create Contract
        List<Contract> createContract = CXE_TestDataFactory.createContract(1,acct.id,createCase[0].id);
        createContract[0].V10_Account_No__c = '584950609109';
         createContract[0].Contract_External_ID__c ='16367';
        insert createContract;


        List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert addressRefList;
        for(Integer i=0 ; i<addressRefList.size() ; i++) {
            if(i>0){
                addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
            }
        }
        update addressRefList;      
        //Id webRecTypeId = Schema.Sobjecttype.Office__c.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_OFFICE_WEB).getRecordTypeId();
        //Office__c off = CXE_TestDataFactory.createOffice(1)[0];
        //off.RecordTypeId = webRecTypeId;
        
        //Office_Jurisdiction__c oj = CXE_TestDataFactory.createOfficeJurisdiction(1)[0];
        //oj.Office__c = off.Id;


        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }

        Id offRecTypeId = Schema.Sobjecttype.Office__c.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_OFFICE_HMB).getRecordTypeId();
        Office__c officeRec = CXE_TestDataFactory.createOffice(1)[0];
        officeRec.RecordTypeId = offRecTypeId;
        
        insert officeRec;
        
        Office_Jurisdiction__c officeJurRec = CXE_TestDataFactory.createOfficeJurisdiction(1)[0];
        officeJurRec.Province__c = addressReference.get('Province').Id;
        officeJurRec.City__c = addressReference.get('City').Id;
        officeJurRec.Barangay__c = addressReference.get('Barangay').Id;
        officeJurRec.Street_Name__c = addressReference.get('Street').Id;
        officeJurRec.Subdivision__c = addressReference.get('Subdivision').Id;
        officeJurRec.Office__c = officeRec.Id;        
        insert officeJurRec;
        
        Address__c createAddress = CXE_TestDataFactory.createAddress(addressReference, true);
        createAddress.Type__c = 'Billing';
        createAddress.Account__c = acct.Id;
        createAddress.Case__c = createCase[0].Id;
        createAddress.Contract__c = createContract[0].Id;
        createAddress.Address_Street_No__c = '1'; 
        insert createAddress;

        //Create Service
        //Modified by Rom - changed method call from createService() to createServiceWithLessDetails()
        List<Agreement__c> createService = CXE_TestDataFactory.createServiceWithLessDetails(10,acct.id,createCase[0].id,
                                                                createContract[0].id,psicLst[0].id);
        
              
        createService[0].Payor__c = createContract[0].id;
        
        if(segment == '1') {
            createService[0].Code_Segment__c = '1';
            createService[0].Segment__c = 'Corporate Business Group';
        } else if(segment == '2') {
            createService[0].Code_Segment__c = '2';
            createService[0].Segment__c = 'Home and Micro Business';
        } else if(segment == '3') {
            createService[0].Code_Segment__c = '3';
            createService[0].Segment__c = 'SME Business Group';
        }

        createService[0].SIN__c = '293028374839';
        insert createService;
    }
    /*Corbes Melvin
     * Creation of Portal Account 
     * 10-26-2017
     */ 
    public static Account createSingleAccountForPortalUser(Id OwnedById){

        Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = OwnedById,
                Phone = '+63021234567',
                Tax_Identification_No__c = '123456789012',
                Mobile_Phone__c = '+630000000000',
                Email__c = 'test@test.com'
               
            );
          return portalAccount1;
    }
    
    /* Description: Create Modification of Electric Service Case
     * Returns: List<Case>
     * Author: Rom Edison Reyes (Accenture)
     * Date Created: JAN-06-18
     */
    public static List<Case> createAPACase(Integer numOfRecord, Boolean isEnroll, Id contractId) 
    {    
        List<Case> listCase = new List<Case>();
        Id apaRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_APA).getRecordTypeId();
        
        for(Integer recordCount=0; recordCount < numOfRecord; recordCount++){
            Case caseRecord = new Case();
            caseRecord.RecordTypeId = apaRecTypeId;
            caseRecord.Origin = 'Customer';
            caseRecord.Status = 'Open';
            caseRecord.Contract__c = contractId;
            if(isEnroll){
                caseRecord.Application_Type_Subtype__c = 'APA Enrollment';
                caseRecord.CXE_APA_Scheme__c = 'Auto-Debit';
                caseRecord.CXE_APA_Agent__c = 'BDO';
            }else{
                caseRecord.Application_Type_Subtype__c = 'APA Cancellation';
            }
            listCase.add(caseRecord);
        }       
        return listCase;
    }
}