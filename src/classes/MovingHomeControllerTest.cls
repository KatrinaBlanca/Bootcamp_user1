/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for MovingHomeController class 
  */  
@isTest
//(SeeallData=true)
public class MovingHomeControllerTest{
     
    //private static testMethod void TestMet(){
      /*      
        //inserting Account
        //Account acc=new Account();
        List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account acc = testAccountList.get(0);
        //acc.LastName = 'SanTestSan';
        acc.Phone = '55555555';
        insert acc;
        
        //RecordType rtype = [SELECT id FROM RecordType WHERE sObjectType='Case' and isActive=true AND Recordtype.Developername='Handle_a_Contract_Termination'];
        //Inserting Case Record
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case caseTest = testCaseList.get(0);
        //Case caseTest=new Case();
        //caseTest.RecordtypeId=rtype.Id;
        caseTest.Origin='Phone';
        caseTest.NEW_Bank_Name__c = 'Yes Bank';
        caseTest.NEW_Terms_of_Payment__c ='30d end of month';
        caseTest.New_Payment_Day__c='1st of month';
        caseTest.NEW_IBAN__c ='Test';
        caseTest.Subject='Test Subject';
        caseTest.AccountId=acc.Id;
        insert caseTest;
        
    
    
    // inserting opportunity
    Opportunity opp=TestDataFactoryTest.createOpportunity();
    
    
          // inserting contract
    Contract contract = new Contract ();
    contract.Case__c = caseTest.Id;
    contract.Method_of_Payment__c = 'ADA (Bank)';
    contract.Type__c = 'Regular';
    contract.Accountid = acc.id;
    contract.Name= 'TestContract';
    insert contract;


        Address__c testAddress = CXE_TestDataFactory.createAddressWithoutReference('Billing', caseTest.Id, acc.Id, contract.Id, null, null, null);
        insert testAddress;
        
    //Query Product
    //Product2 prod = [select id from Product2 where isActive = true limit 1];
        
        //inserting Agreement
        agreement__C agreemt= new agreement__C();
        agreemt.Account__c = acc.id;
        //agreemt.name ='TestAgree';
        //agreemt.Commercial_Product__c = prod.id;
        agreemt.Contract__c = contract.id;
        agreemt.Agreement_Duration_Months__c=36;
        agreemt.Agreement_Start_Date__c = System.today();
        agreemt.Agreement_End_Date__c = System.today()+1;
        agreemt.Advance_Frequency_months__c=20;
        agreemt.Advance_amount__c =100;
        agreemt.Case__c =caseTest.id;
        agreemt.Active_Agreement__c=true;
        //agreemt.Charges_for_breach_of_contract__c=400;
        insert agreemt;
     */

    // List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
    //    Account testAccount = testAccountList.get(0);
    //    insert testAccount;

    //    Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

    //    List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
    //    Case caseTest = testCaseList.get(0);
    //    caseTest.RecordTypeId = newServiceApplicationRecordTypeId;
    //    caseTest.Tax_Identification_No__c = '1111111';
    //    caseTest.AccountId = testAccount.Id;
    //    insert caseTest;

    //    Contract testContract = new Contract(AccountId = testAccount.Id,
    //                                         Case__c = caseTest.Id,
    //                                         Method_of_Payment__c = 'ADA (Bank)',
    //                                         Type__c = 'Regular');
    //    insert testContract;
                                               
    //    Address__c testAddress = new Address__c(Type__c = 'Billing', 
    //                                            Account__c = testAccount.Id,
    //                                            Case__c = caseTest.Id,
    //                                            Contract__c = testContract.Id,
    //                                            Address_Street_No__c = '1');
    //    insert testAddress;

    //    List<Agreement__c> serviceList = CXE_TestDataFactory.createService(1, null,null,testContract.Id, null);
    //    Agreement__c agreemt = serviceList.get(0);
    //    insert agreemt;   
        
      
        
    //   system.Test.startTest();
    //System.Test.setCurrentPageReference(new PageReference('Page.MovingHomePage'));
    ////System.currentPageReference().getParameters().put('caseid', caseTest.id);                
    //    ApexPages.StandardController sc = new ApexPages.StandardController(caseTest);
    //    MovingHomeController oMoveHome= new MovingHomeController(sc);
    //    //PageReference pageRef = Page.MoveHomeOpportunity;       
    //    oMoveHome.ThisCase = caseTest;
    //    //MovingHomeController.AgreementWrapper agWrap = new MovingHomeController.AgreementWrapper();
    //    //agWrap.agreement = agreemt;
    //    //agWrap.Sel = true;
    //    //oMoveHome.agreementWrap.add(agWrap);
    //    List<MovingHomeController.AgreementWrapper> lstAgWrap = new List<MovingHomeController.AgreementWrapper>();
    //    for(MovingHomeController.AgreementWrapper agw : oMoveHome.agreementWrap){
    //        if(agw.Sel == null){
    //            agw.Sel  = false;
    //        }
    //        lstAgWrap.add(agw);
    //    }
    //    oMoveHome.agreementWrap = lstAgWrap;
    //    //system.assertEquals(null,oMoveHome.agreementWrap);
        
    //    oMoveHome.save();
        
    //    oMoveHome.updategraph();
    //    oMoveHome.meterReadsAsGoogleChartsJson(testAccount.id);
    //    oMoveHome.cancel();
        
    //    MovingHomeController.Prevmeterresponse oPrev = new MovingHomeController.Prevmeterresponse();
    //    oPrev.ReadingDateTime1= 'Test';
    //    oPrev.ReadingDateTime2 =System.today();
    //    oPrev.ReadingOrigin1 = 'Test';
    //    oPrev.UsageCode1 = 'Test';
    //    oPrev.Value1 =2.0;
    //    oPrev.utiltarriflabel1 = 'Test';
    //    oPrev.unitofmeasure1 = 'Test';
    //    //oPrev.compareTo(caseTest);
    //    MovingHomeController.MeterRead oMtrRrd = new MovingHomeController.MeterRead(System.today(),8.0);
    //    oMtrRrd.meterReadDate= System.today();
    //    oMtrRrd.meterReadValue = 2.0;
    //    List<MovingHomeController.Prevmeterresponse> oPrevlist=new List<MovingHomeController.Prevmeterresponse>();
    //    oPrevlist.add(oPrev);
    //    oMoveHome.resp= oPrevlist;
    //    oMoveHome.fetchmeterreads();
    //    system.Test.stopTest();
           
    
    //}
   
}