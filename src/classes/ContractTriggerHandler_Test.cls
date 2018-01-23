/* Description: ContractTriggerHandler test class
 * Author: Von Pernicia
 * Date Created: MAR-07-17
*/
@isTest
private class ContractTriggerHandler_Test {

    static testMethod void picklistTransformation() {
        
        Id foRecTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();
        
        Account acct = createAccount(true);
        Case createdCase = createCase(true);
    
        createdCase.Status = CXE_Constants.CASE_APPLICATION_EVALUATED;
        createdCase.AccountId = acct.Id;
        update createdCase;
        test.startTest();
        createdCase.Status = CXE_Constants.CASE_MS_ISSUED;
        update createdCase;
              
        List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Account Type Code');
        insert referenceRecord;
        
        //List<Field_Order__c> foList = CXE_TestDataFactory.createFieldOrder(1)[0];
        Field_Order__c foRecord = CXE_TestDataFactory.createFieldOrder(1)[0];
        foRecord.RecordTypeId = foRecTypeId;
        foRecord.Case__c = createdCase.Id;
        
        insert foRecord;
        
        Contract createdContract = CXE_TestDataFactory.createContract(1, acct.Id, createdCase.Id)[0];
        createdContract.Type__c = 'Name0';
        insert createdContract;
       
        Contract c = [Select Code_Type__c from Contract where id=:createdContract.id];
        system.assertequals(c.Code_Type__c, '0');
        
        createdContract.Type__c = 'Name1';
        update createdContract;
        test.stopTest();

        Contract c2 = [Select Code_Type__c from Contract where id=:createdContract.id];
        system.assertequals(c2.Code_Type__c, '1');

        ContractTriggerHandler cth = new ContractTriggerHandler();
        cth.BeforeDelete(null);
        cth.AfterDelete(null);
        cth.AfterUndelete(null);

    }
    
    static testMethod void updateCaseSERVICE_REQ_CHANGE_IN_NAME() {

        Account acct = createAccount(false);
        Case caseRecord = createCase(false);

        test.startTest();


        Case caseModifRecord = CXE_TestDataFactory.createModificationCase(1, caseRecord.CXE_Service__c, CXE_Constants.SERVICE_REQ_CHANGE_IN_NAME)[0];
        caseModifRecord.Status  = CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK;
        caseModifRecord.CXE_isRequireArrears__c = true;
        caseModifRecord.Arrears_Tag__c = false;
        caseModifRecord.CXE_isClickBillDepositButton__c = false;
        caseModifRecord.Last_Name_Business_Name__c = 'sample';
        caseModifRecord.First_Name__c = 'a';
        caseModifRecord.Last_Name__c = 'b';
        insert caseModifRecord;

        Contract createdContract = CXE_TestDataFactory.createContract(1, acct.Id, caseModifRecord.Id)[0];
        createdContract.Type__c = 'Name0';
        insert createdContract;

        test.stopTest();

    }

    static testMethod void updateCaseSERVICE_REQ_TRANSFER() {

        Account acct = createAccount(true);
        Case caseRecord = createCase(true);

        test.startTest();


        Case caseModifRecord = CXE_TestDataFactory.createModificationCase(1, caseRecord.CXE_Service__c, CXE_Constants.SERVICE_REQ_TRANSFER)[0];
        caseModifRecord.Status  = CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK;
        caseModifRecord.CXE_isRequireArrears__c = true;
        caseModifRecord.Arrears_Tag__c = false;
        caseModifRecord.CXE_isClickBillDepositButton__c = false;
        caseModifRecord.Last_Name_Business_Name__c = 'sample';
        caseModifRecord.First_Name__c = 'a';
        caseModifRecord.Last_Name__c = 'b';
        caseModifRecord.Service_Wire_Length__c = 1;
        //caseModifRecord.CXE_Pending_Requirement_count__c = 0;
        insert caseModifRecord;

        Contract createdContract = CXE_TestDataFactory.createContract(1, acct.Id, caseModifRecord.Id)[0];
        createdContract.Type__c = 'Name0';
        insert createdContract;

        test.stopTest();

    }

    static testMethod void updateCaseSERVICE_REQ_RELOCATION() {

        Account acct = createAccount(true);
        Case caseRecord = createCase(true);

        test.startTest();


        Case caseModifRecord = CXE_TestDataFactory.createModificationCase(1, caseRecord.CXE_Service__c, CXE_Constants.SERVICE_REQ_RELOCATION)[0];
        caseModifRecord.Status  = CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK;
        caseModifRecord.CXE_isRequireArrears__c = true;
        caseModifRecord.Arrears_Tag__c = false;
        caseModifRecord.CXE_isClickBillDepositButton__c = false;
        caseModifRecord.Last_Name_Business_Name__c = 'sample';
        caseModifRecord.First_Name__c = 'a';
        caseModifRecord.Last_Name__c = 'b';
        caseModifRecord.CXE_Service_Wire_Phase__c = 'Single Phase (1Ø), Two (2)-Wire';
        caseModifRecord.CXE_Service_Wire_Voltage__c = '69/39 kV';
        caseModifRecord.Pole_Code__c = '1';
        caseModifRecord.Service_Wire_Type__c = 'Aerial Alum.,Bundled';
        caseModifRecord.Wire_Size__c = '#1/0';
        caseModifRecord.Material__c = 'Aluminum';
        caseModifRecord.Metering_Scheme__c = 'NORMAL';
        caseModifRecord.TLN__c = '1';
        caseModifRecord.Service_Wire_Length__c = 1;
        //caseModifRecord.CXE_Pending_Requirement_count__c = 0;
        insert caseModifRecord;

        Contract createdContract = CXE_TestDataFactory.createContract(1, acct.Id, caseModifRecord.Id)[0];
        createdContract.Type__c = 'Name0';
        insert createdContract;

        test.stopTest();

    }

    static testMethod void updateCaseSERVICE_REQ_REMODEL() {

        Account acct = createAccount(true);
        Case caseRecord = createCase(true);

        test.startTest();


        Case caseModifRecord = CXE_TestDataFactory.createModificationCase(1, caseRecord.CXE_Service__c, CXE_Constants.SERVICE_REQ_REMODEL + ';' + CXE_Constants.SERVICE_REQ_TRANSFER)[0];
        caseModifRecord.Status  = CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK;
        caseModifRecord.CXE_isRequireArrears__c = true;
        caseModifRecord.Arrears_Tag__c = false;
        caseModifRecord.CXE_isClickBillDepositButton__c = false;
        caseModifRecord.Last_Name_Business_Name__c = 'sample';
        caseModifRecord.First_Name__c = 'a';
        caseModifRecord.Last_Name__c = 'b';
        caseModifRecord.Service_Rate_Type__c = 'General Service A (GSA)';
        caseModifRecord.Billing_Class__c = 'General Service A (GSA)';
        caseModifRecord.Phase__c = 'Single Phase (1Ø), Two (2)-Wire';
        caseModifRecord.Voltage__c = '69/39 kV';
        caseModifRecord.CXE_Service_Wire_Phase__c = 'Single Phase (1Ø), Two (2)-Wire';
        caseModifRecord.CXE_Service_Wire_Voltage__c = '69/39 kV';
        caseModifRecord.Pole_Code__c = '1';
        caseModifRecord.Service_Wire_Type__c = 'Aerial Alum.,Bundled';
        caseModifRecord.Wire_Size__c = '#1/0';
        caseModifRecord.Material__c = 'Aluminum';
        caseModifRecord.Metering_Scheme__c = 'NORMAL';
        caseModifRecord.Mode_of_Retrieval__c = 'REMOTE';
        caseModifRecord.TLN__c = '1';
        caseModifRecord.Service_Wire_Length__c = 1;
        caseModifRecord.Applied_Load__c = 1;
        caseModifRecord.Application_for_Business_Service__c = true;
        //caseModifRecord.CXE_Pending_Requirement_count__c = 0;
        insert caseModifRecord;

        Contract createdContract = CXE_TestDataFactory.createContract(1, acct.Id, caseModifRecord.Id)[0];
        createdContract.Type__c = 'Name0';
        insert createdContract;

        test.stopTest();

    }

    static testMethod void updateCaseSERVICE_REQ_ADDITIONAL_LOAD() {

        Account acct = createAccount(true);
        Case caseRecord = createCase(true);

        test.startTest();


        Case caseModifRecord = CXE_TestDataFactory.createModificationCase(1, caseRecord.CXE_Service__c, CXE_Constants.SERVICE_REQ_ADDITIONAL_LOAD + ';' + CXE_Constants.SERVICE_REQ_TRANSFER)[0];
        caseModifRecord.Status  = CXE_Constants.CASE_STATUS_SERVICE_ENTR_STILL_OK;
        caseModifRecord.CXE_isRequireArrears__c = true;
        caseModifRecord.Arrears_Tag__c = false;
        caseModifRecord.CXE_isClickBillDepositButton__c = false;
        caseModifRecord.Last_Name_Business_Name__c = 'sample';
        caseModifRecord.First_Name__c = 'a';
        caseModifRecord.Last_Name__c = 'b';
        caseModifRecord.Service_Rate_Type__c = 'General Service A (GSA)';
        caseModifRecord.Billing_Class__c = 'General Service A (GSA)';
        caseModifRecord.Applied_Load__c = 1;
        caseModifRecord.Demand_Factor__c = 1;
        caseModifRecord.Load_Factor__c = 1;
        caseModifRecord.Contracted_Capacity__c = 1;
        caseModifRecord.PSIC__c = caseRecord.PSIC__c;
        caseModifRecord.Service_Wire_Length__c = 1;
             
        caseModifRecord.Application_for_Business_Service__c = true;
        //caseModifRecord.CXE_Pending_Requirement_count__c = 0;
        insert caseModifRecord;

        Contract createdContract = CXE_TestDataFactory.createContract(1, acct.Id, caseModifRecord.Id)[0];
        createdContract.Type__c = 'Name0';
        insert createdContract;

        test.stopTest();

    }

    private static Case createCase(Boolean isBusiness){
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
        insert scheduleRecord;
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        
        List<PSIC__c> psicRecord = CXE_TestDataFactory.createPSIC(2);
        insert psicRecord;
        
        List<Reference__c> referenceRecord = CXE_TestDataFactory.createReferencePicklist(2, 'Billing Class');
        insert referenceRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord[0].id;
        caseRecord.Billing_Class__c = 'Name0';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        
        if(isBusiness){
            caseRecord.Application_for_Business_Customer__c = true;
            caseRecord.Application_for_Residential_Customer__c = false;
        }else{
            caseRecord.Application_for_Residential_Customer__c = true;
            caseRecord.Application_for_Business_Customer__c = false;
        }
        
        insert caseRecord;
        return caseRecord;
    }
    
    private static Account createAccount(Boolean isBusiness){
         List<Account> acctList = new List<Account>();
         Account acctRecord = new Account();
         
         Reference__c referenceRecord = CXE_TestDataFactory.createReferencePicklist(1, 'Customer Type')[0];
         insert referenceRecord;
         
         if(isBusiness){
            acctList = CXE_TestDataFactory.createBusinessAccount(1);
            acctRecord = acctList[0];
            
            acctRecord.Name = 'Business Account Name';
            acctRecord.Conglomerate__c = true;
            acctRecord.Email__c = 'test@test.com';
            acctRecord.Mobile_Phone__c = '+631234567890';
         }else{
            acctList = CXE_TestDataFactory.createPersonAccount(1);
            acctRecord = acctList[0];
            
            acctRecord.PersonBirthdate = System.today() - 1;
            acctRecord.PersonEmail = 'test@test.com';
            acctRecord.FirstName = 'Case';
            acctRecord.LastName = 'Test';
            acctRecord.MiddleName = 'Middle';
            acctRecord.PersonMobilePhone = '+631234567890';
         }
        acctRecord.Phone='+6356748321';
        acctRecord.Billing_Address_Barangay__c  = 'SAN LORENZO' ;
        acctRecord.Billing_Address_City_Municipal__c =  'MAKATI CITY'   ;
        acctRecord.Billing_Address_Province__c  =   'METRO MANILA'  ;
        acctRecord.Billing_Address_Street_Name__c   =   'Paseo St.' ;
        acctRecord.Billing_Address_Subdivision__c   =   'Insular Building'  ;
        acctRecord.Billing_Address_Unit_No__c   =   'Unit 2';
        acctRecord.Customer_Type__c = 'Name0';
        insert acctRecord;
        return acctRecord;
    }
    //Begin CSM-1310: Jerson Poblete MAR-10-17
  /*  static testmethod void validateContractCreation() 
    {
		List<Account> accList = CXE_TestDataFactory.createBusinessAccount(1);
        Account accRecord = accList[0];	
        List<Case> caseList = CXE_TestDataFactory.createCase(1, 'New Service', 'Single meter', 'Inspection FO Resolved - Approved', 'Private');	
        Case caseRecord = caseList[0];	
        insert accRecord;
        insert caseRecord;	
		List<Contract> contractList = CXE_TestDataFactory.createContract(2, accRecord.id, caseRecord.Id);
        Contract contract1 = contractList[0];
        Contract contract2 = contractList[1];
        insert contract1;
        try{
            insert contract2;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Cannot create more than one') ? true : false;
            system.assertEquals(expectedExceptionThrown,true);       
        } 
	}*/
    //End CSM-1310: Jerson Poblete MAR-10-17
}