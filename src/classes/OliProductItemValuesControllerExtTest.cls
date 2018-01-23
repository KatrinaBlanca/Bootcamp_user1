/**  
* @author       : Accenture IDC  
* @date         : 17/07/2015  
* @description  : Test Class for OliProductItemValuesControllerExt  
*/ 
 @isTest
private class OliProductItemValuesControllerExtTest
{
  private static final String ADMIN_PROFILE = 'System Administrator';
  private static testMethod void productLineItemTestController()
  {   
     Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
     User contextUser = TestDataFactoryTest.createUser('Dev',prof.id,null);  
    
     Account acc=TestDataFactoryTest.createAccount('Test Account');  
      Master_Product__c MasterProduct= TestDataFactoryTest.createMasterProduct('Test MasterProduct','Gas');  
      id commercialProductRectype=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
      product2 product=TestDataFactoryTest.createProduct('test Product',masterproduct.id,commercialProductRectype,'Variable') ;
     Pricebookentry pbe=[select id from Pricebookentry where product2id=:product.id];
      //Pricebookentry pbe=TestDataFactoryTest.createPricebookEntry(product.id,test.getStandardPricebookid(),20);
      Product_Item__c productItem=TestDataFactoryTest.createProductItem('Test ProductItem','Rate',MasterProduct.id,true);
      Commercial_Product_Value__c commercialProdValue=TestDataFactoryTest.commercialProductValue(productItem.id,product.id,09,20);
      opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,'Test Opportunity',System.today(),'Close Won',System.Test.getStandardPricebookId(),null);
      OpportunityLineItem OLI=TestDataFactoryTest.createOpportunityLineItem(opp.id,PBE.id,1,20);
     system.runas(contextUser)
     {
             ApexPages.StandardController cont = new ApexPages.StandardController(OLI);
             OliProductItemValuesControllerExt  OLIV=new OliProductItemValuesControllerExt(Cont);
             list<Commercial_Product_Value__c> ActualRecords=[select Product_Item__r.Name, Value__c from Commercial_Product_Value__c 
                                                                where Product__c in (select Product2Id from PricebookEntry where id = :PBE.id)
                                                                    order by Name asc];
             system.assertEquals(ActualRecords, OLIV.getCommercialProductValues());
      }
      
   }   
  
}