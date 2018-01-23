/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for NewCaseControllerExt class 
  */  
@isTest(seeAllData=true)
public class NewCaseControllerExtTest{
     
    //private static testMethod void TestMet(){
            
    //    //inserting Account
    //    Account acc=new Account();
    //    acc.LastName = 'SanTestSan';
    //    acc.Phone = '55555555';
    //    insert acc;
        
    //    //RecordType rtype = [SELECT id FROM RecordType WHERE sObjectType='Case' and isActive=true AND Recordtype.Developername='Handle_a_Contract_Termination'];
    //    //Inserting Case Record
    //    //Case caseTest=new Case();
    //    //caseTest.RecordtypeId=rtype.Id;
    //    List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
    //    Case caseTest = testCaseList.get(0);

    //    caseTest.Origin='Phone';
    //    caseTest.Subject='Test Subject';
    //    caseTest.AccountId=acc.Id;
    //    insert caseTest;
        
    //      // inserting contract
    //    Contract contract = new Contract ();
    //    contract.Accountid = acc.id;
    //    contract.Name= 'TestContract';
    //    insert contract;
    //    Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', caseTest.Id, acc.Id, contract.Id, null, null, null);
    //    Address__c testAddress = new Address__c(Type__c = 'Billing', 
    //                                            Account__c = acc.Id,
    //                                            Case__c = caseTest.Id,
    //                                            Contract__c=contract.Id);
    //    insert testAddress;
        
    //    //inserting Agreement
    //    agreement__C agreemt= new agreement__C();
    //    agreemt.Account__c = acc.id;
    //    //agreemt.name ='TestAgree';
    //    //agreemt.Commercial_Product__c = '';
    //    agreemt.Contract__c = contract.id;
    //    agreemt.Agreement_Duration_Months__c=36;
    //    agreemt.Agreement_Start_Date__c = System.today();
    //    agreemt.Agreement_End_Date__c = System.today()+1;
    //    agreemt.Advance_Frequency_months__c=20;
    //    agreemt.Advance_amount__c =100;
    //    agreemt.Case__c =caseTest.id;
    //    //agreemt.Charges_for_breach_of_contract__c=400;
    //    insert agreemt;
       
    //   system.Test.startTest();                   
    //    ApexPages.StandardController sc = new ApexPages.StandardController(caseTest);
    //    NewCaseControllerExt oNewCase= new NewCaseControllerExt(sc);
    //    PageReference pageRef = Page.NewCase;       
    //    system.test.setCurrentPage(pageRef);
    //    oNewCase.save();
        
    //    system.Test.stopTest();
        
    
    
    //}
}