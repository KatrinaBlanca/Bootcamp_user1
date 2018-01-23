/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for MoveHomeOpportunity class 
  */  
@isTest
public class MoveHomeOpportunityTest{
     
    //@testSetup static void setUp() {
    //    // create References
    //    List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
    //    insert addressRefList;
    //    for(Integer i=0 ; i<addressRefList.size() ; i++) {
    //        if(i>0){
    //            addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
    //        }
    //    }
    //    update addressRefList;      
    //}

    //private static testMethod void TestMet(){
            
    //    //inserting Account
    //    Account acc=new Account();
    //    acc.LastName = 'SanTestSan';
    //    acc.Phone = '55555555';
    //    insert acc;
        
    //    /*RecordType rtype = [SELECT id FROM RecordType WHERE sObjectType='Case' and isActive=true AND Recordtype.Developername='New_Service_Application'];
    //    //Inserting Case Record
    //    Case caseTest=new Case();
    //    caseTest.RecordtypeId=rtype.Id;
    //    caseTest.Origin='Phone';
    //caseTest.NEW_Bank_Name__c = 'Yes Bank';
    //caseTest.NEW_Terms_of_Payment__c ='30d end of month';
    //caseTest.New_Payment_Day__c='1st of month';
    //caseTest.NEW_IBAN__c ='Test';
    //    caseTest.Subject='Test Subject';
    //    caseTest.AccountId=acc.Id;
    //    insert caseTest;*/

    //    Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
    //    List<Schedule__c> scheduleRecord = CXE_TestDataFactory.createSchedule(5);
    //    insert scheduleRecord;
        
    //    Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
    //    insert contactRecord;
        
    //    PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
    //    insert psicRecord;
        
    //    Case caseTest = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
    //    caseTest.AccountId=acc.Id;
    //    caseTest.RecordTypeID = servRecTypeId;
    //    caseTest.ContactId = contactRecord.id;
    //    caseTest.Individual_Business_Tag__c = 'No';
    //    caseTest.Residential_Non_Residential_Tag__c = 'Yes';
    //    caseTest.PSIC__c = psicRecord.id;
    //    caseTest.Initial_Responsible_Office__c = 'RO1';
    //    caseTest.Date_of_Birth__c = date.newInstance(1995, 1, 1);
    //    caseTest.Tax_Identification_No__c = '123';
                
    //    insert caseTest;
        
    
    
    //    // inserting opportunity
    //    Opportunity opp=TestDataFactoryTest.createOpportunity();
    
    
    //    Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
    //    for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
    //        addressReference.put(addRef.Field__c, addRef);
    //    }  

    //      // inserting contract
    //    Contract contract = new Contract ();
    //    contract.Accountid = acc.id;
    //    contract.Name= 'TestContract';
    //    insert contract;

    //    system.Test.startTest();
    //    Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
    //    addressRec.Case__c = caseTest.Id;
    //    addressRec.Contract__c = contract.Id;
    //    addressRec.Type__c = 'Billing';
    //    insert addressRec;

        
    //    //Creating Master Product
    //    RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
    //    Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
    //    Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
    //    Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
    //    Prod.isActive=True;
    //    prod.Utility_type__c='Electricity';
    //    update Prod;
        
    //    //Query Product
    //    //Product2 prod = [select id from Product2 where isActive = true limit 1];
        
    //    //inserting Agreement
    //    agreement__C agreemt= new agreement__C();
    //    agreemt.Account__c = acc.id;
    //    //agreemt.name ='TestAgree';
    //    agreemt.Commercial_Product__c = prod.id;
    //    agreemt.Contract__c = contract.id;
    //    agreemt.Agreement_Duration_Months__c=36;
    //    agreemt.Agreement_Start_Date__c = System.today();
    //    agreemt.Agreement_End_Date__c = System.today()+1;
    //    agreemt.Advance_Frequency_months__c=20;
    //    agreemt.Advance_amount__c =100;
    //    agreemt.Case__c =caseTest.id;
    //    //agreemt.Charges_for_breach_of_contract__c=400;
    //    insert agreemt;
        
        
    //    list<agreement__c> a = [select Id from agreement__c];
    //    system.assertNotequals(a, null); 
    //    //system.assertequals(1, 2);
      
        
       
    //    //System.Test.setCurrentPageReference(new PageReference('Page.MoveHomeOpportunity'));
    //    Test.setCurrentPage(new PageReference('Page.MoveHomeOpportunity'));
    //    ApexPages.currentPage().getParameters().put('caseid', caseTest.id);                
    //    ApexPages.StandardController sc = new ApexPages.StandardController(opp);
    //    MoveHomeOpportunity oMoveHome= new MoveHomeOpportunity(sc);
    //    //PageReference pageRef = Page.MoveHomeOpportunity;       
        
    
    //    //oMoveHome.SaveOpportunity();
    //    system.Test.stopTest();
           
    
    //}
   
}