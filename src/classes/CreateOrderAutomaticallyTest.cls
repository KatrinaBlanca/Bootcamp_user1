/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for CreateOrderAutomatically trigger 
  */  
@isTest()
public class CreateOrderAutomaticallyTest{
     
    private static testMethod void TestMet(){

       system.Test.startTest();  
       Account acc= new Account();
           acc.name='Test Acc';
           acc.Customer_Accepted__c = 'Rejected';
           acc.Tax_Identification_No__c = '1111'; //added Von Pernicia
           acc.Email__c = 'test@test.com';//START/END R2 RReyes JUL-08-17 - added email to pass validation
           insert acc;
        /*Opportunity opp = new Opportunity();
        opp.name='test Opp';
       opp.StageName='Prospecting';
       opp.CloseDate=System.Today();
       opp.AccountId=acc.id;
       Insert opp;*/
       Master_Product__c MasterProduct= TestDataFactoryTest.createMasterProduct('Test MasterProduct','Gas');  
      id commercialProductRectype=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
      product2 product=TestDataFactoryTest.createProduct('test Product',masterproduct.id,commercialProductRectype,'Variable') ;
     Pricebookentry pbe=[select id from Pricebookentry where product2id=:product.id];
      
      opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,'Test Opportunity',System.today(),'Prospecting',System.Test.getStandardPricebookId(),null);
      OpportunityLineItem OLI=TestDataFactoryTest.createOpportunityLineItem(opp.id,PBE.id,1,20);
      opp.StageName='Closed Won';
      update opp;
    }
   
}