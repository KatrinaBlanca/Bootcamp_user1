/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for AccountTriggerClass class 
  */  
@isTest()
public class AccountTriggerClassTest{
     
    private static testMethod void TestMet(){
            
       
       //Account Acc =TestDataFactoryTest.createAccount();
       //Opportunity opp=TestDataFactoryTest.createOpportunity();
           Account acc= new Account();
           acc.name='Test Acc';
           acc.Customer_Accepted__c = 'Rejected';
           acc.Tax_Identification_No__c = '1231'; //CXE PDC 3-28-2017 addition account validation
           //START RReyes JUL-07-17 - R2 - added field values for validations
           acc.Phone = '+6300000000';
           acc.V10_Customer_No__c = '3242527182';
           //END RReyes JUL-07-17 - R2 - added field values for validations
           insert acc;
           
          opportunity opp=new opportunity();
          opp.accountid= acc.id;
          opp.name= 'TestSAN';
          opp.closedate=System.today();
          opp.stagename = 'Pending Security Deposit';
          opp.Closed_Lost_Reason__c = 'close reason';//CXE PDC 3-28-2017 addition account validation
          //opp.pricebook2id= PricebookId;
          //opp.Bundle__C=BundleProductID;
          insert opp;
       
       
       List<Account> listAcc = new List<Account>();
        listAcc.add(Acc);
    
        
       system.Test.startTest();
        AccountTriggerClass oAccountTrigger = new AccountTriggerClass();
        oAccountTrigger.accountAcceptance(listAcc);        
        system.Test.stopTest();
           
    
    }
   
}