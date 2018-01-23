/**
  * @author       : Accenture IDC
  * @date         : 10/26/2015
  * @description  : Test Class for NewQuoteFromOppControllerExt class 
  */  
  
  @isTest()
  public class NewQuoteFromOppControllerExtTest {
      
      /**
      * @description       Test method to validate payment plans
      * @param             NA
      * @return            Void
      * @throws            NA
      */
      
      private static testmethod void checkConnections(){
       // inserting Opportunity

        Id CommercialRecordType = Schema.Sobjecttype.Product2.getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();

        Opportunity opp=TestDataFactoryTest.createOpportunity();
        
        Master_Product__c mp = TestDataFactoryTest.createMasterProduct('Sample1', 'Sample2');
        
        Product2 Prod=TestDataFactoryTest.createProduct('Test Product1',mp.id, CommercialRecordType,'Fixed');
        
        Pricebook2 pb = TestDataFactoryTest.createPricebook(true, 'sample1');
       
        PricebookEntry pbe = TestDataFactoryTest.createPricebookEntry(Prod.Id, pb.ID ,100);
        
        OpportunityLineItem oli = TestDataFactoryTest.createOpportunityLineItem(opp.Id, pbe.Id, 1, 100);
     
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        NewQuoteFromOppControllerExt oNewQuote = new NewQuoteFromOppControllerExt(sc);
        oNewQuote.createQuote();
               
      }
  }