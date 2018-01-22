/**
  * @author       : Accenture IDC
  * @date         : 18/7/2015
  * @description  : Test Class for UpdatePrdComValController class to insert the Product Commercial Values.
  */   
@isTest
private class UpdatePrdComValHandler_Test
{
    private static final String ADMIN_PROFILE = 'System Administrator';
    //private static final String MP_RECTYPE_ID = Label.MASTER_PRODUCT_RECTYPID;
    private static final String MP_RECTYPE_ID = Schema.Sobjecttype.Product2.getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
    private static final string MASTER_PRODUCT_NAME = 'Test Master Product';
    private static final string PRODUCT_ITEM_NAME = 'Test Product Item';
    private static final string PRODUCT_NAME = 'Test Product';  
    private static final string PRODUCT_ITEM_RATE = 'Rate';        
    private static final string PRODUCT_RATE_TYPE = 'Fixed';
    private static final string MASTER_PRODUCT_TYPE = 'Electricity';
    
    /**
      * @description       Test method to validate whether Product commercial values are getting created for product(Positive Scenario)
      * @param             NA
      * @return            Void
      * @throws            NA
      */
       private static testMethod void Updateproductcomval()
       {
           Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
           User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
           System.runAs(contextUser)
           {
               Master_Product__c Mastprd=TestDataFactoryTest.createMasterProduct(MASTER_PRODUCT_NAME,MASTER_PRODUCT_TYPE); 
               Product_Item__c Prditem=TestDataFactoryTest.createProductitem(PRODUCT_ITEM_NAME,PRODUCT_ITEM_RATE,Mastprd.Id,True);      
               System.Test.startTest();
                   Product2 prd2=TestDataFactoryTest.createProduct(PRODUCT_NAME,Mastprd.Id,MP_RECTYPE_ID,PRODUCT_RATE_TYPE); 
                   Commercial_Product_Value__c cpv=[select Id,Product__c from Commercial_Product_Value__c where Product__c =: prd2.Id];
                   system.debug('***:'+cpv.Product__c);
               System.Test.stopTest();
               system.assertequals(cpv.Product__c,prd2.Id);
           }
       }
       
      //START RReyes - 04/25 
      private static testMethod void testActiveProduct()
       {
           Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
           User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
           System.runAs(contextUser)
           {
               Master_Product__c Mastprd=TestDataFactoryTest.createMasterProduct(MASTER_PRODUCT_NAME,MASTER_PRODUCT_TYPE); 
               Product_Item__c Prditem=TestDataFactoryTest.createProductitem(PRODUCT_ITEM_NAME,PRODUCT_ITEM_RATE,Mastprd.Id,True);      
               System.Test.startTest();

               Product2 Prod = new Product2();
               Prod.Name=PRODUCT_NAME;
               Prod.Master_Product__c=Mastprd.Id;
               Prod.Fee_Type__c=PRODUCT_RATE_TYPE;
               Prod.RecordTypeId=MP_RECTYPE_ID;
               Prod.isactive=true;
               insert Prod;

                Id standardPBId = Test.getStandardPricebookId();
                PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = Prod.Id, UnitPrice = 1000, IsActive = true);
                insert standardPBE;

                System.Test.stopTest();
           }
       }

      //END RReyes - 04/25
}