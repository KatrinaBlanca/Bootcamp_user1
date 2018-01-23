/**
  * @author       : Accenture IDC
  * @date         : 05/08/2015
  * @description  : Test Class for Product create 
  */   
@isTest
private class ProductCloneController_Test
{
    public static Product2 prod2;
    @isTest static void testProductClonecontroller(){
        prod2 = new Product2(Name = 'Laptop X200', 
            Family = 'Hardware');
        insert prod2;
        ApexPages.StandardController sc = new ApexPages.StandardController(prod2);
        test.startTest();
        ProductClonecontroller pcc = new ProductClonecontroller(sc);
        test.stopTest();
    }
     
    //private static final String ADMIN_PROFILE = 'System Administrator';
    ////private static final String MP_RECTYPE_ID = Label.MASTER_PRODUCT_RECTYPID;
    ////private static final String DISC_RECTYPE_ID = Label.DISC_PROD_RECTYPE;
    //private static final String MP_RECTYPE_ID = Schema.Sobjecttype.Product2.getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
    //private static final String DISC_RECTYPE_ID = Schema.Sobjecttype.Product2.getRecordTypeInfosByName().get('Discount').getRecordTypeId();
    //private static final string MASTER_PRODUCT_NAME = 'Test Master Product';
    //private static final string PRODUCT_ITEM_NAME = 'Test Product Item';
    //private static final string PRODUCT_NAME = 'Test Product';  
    //private static final string PRODUCT_ITEM_RATE = 'Rate';        
    //private static final string PRODUCT_RATE_TYPE = 'Fixed';
    //private static final string MASTER_PRODUCT_TYPE = 'Electricity';
    ///**
    //  * @description       Test method to validate the Product Clone for commercial product
    //  * @param             NA
    //  * @return            Void
    //  * @throws            NA
    //  */
    //private static testMethod void testcomproductclone()
    //{
    //    Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
    //    User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
    //    System.runAs(contextUser)
    //    {
    //        Master_Product__c Mastprd=TestDataFactoryTest.createMasterProduct(MASTER_PRODUCT_NAME,MASTER_PRODUCT_TYPE); 
    //        Product_Item__c Prditem=TestDataFactoryTest.createProductitem(PRODUCT_ITEM_NAME,PRODUCT_ITEM_RATE,Mastprd.Id,True);
    //        Product2 prd2=TestDataFactoryTest.createProduct(PRODUCT_NAME,Mastprd.Id,MP_RECTYPE_ID,PRODUCT_RATE_TYPE); 
    //        ApexPages.StandardController cont = new ApexPages.StandardController(prd2);
    //        ProductClonecontroller pcc = new ProductClonecontroller(cont);
    //        System.Test.startTest();
    //            pcc.customsave();
    //        System.Test.stopTest();
    //        system.assertnotequals(apexpages.currentpage().getparameters().get('Id'),prd2.Id);
    //    } 
    //}
    ///**
    //  * @description       Test method to validate the Product Clone for bundle product
    //  * @param             NA
    //  * @return            Void
    //  * @throws            NA
    //  */
    //private static testMethod void testbunproductclone()
    //{
    //    Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
    //    User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
    //    System.runAs(contextUser)
    //    {
    //        pricebook2 BundlePricebook=TestDataFactoryTest.createPricebook('testPricebook1',true);  
    //        product2 Bundleprod=TestDataFactoryTest.createBundleProduct(' test bundle ',BundlePricebook.id);  
    //        ApexPages.StandardController cont = new ApexPages.StandardController(Bundleprod);
    //        ProductClonecontroller pcc = new ProductClonecontroller(cont);
    //        System.Test.startTest();
    //            pcc.customsave();
    //        System.Test.stopTest();
    //        system.assertnotequals(apexpages.currentpage().getparameters().get('Id'),Bundleprod.Id);
    //    } 
    //}
    ///**
    //  * @description       Test method to validate the Product Clone for Discount product
    //  * @param             NA
    //  * @return            Void
    //  * @throws            NA
    //  */
    //private static testMethod void testdiscproductclone()
    //{
    //    Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
    //    User contextUser = TestDataFactoryTest.createUser('Hulk',prof.id,null);
    //    System.runAs(contextUser)
    //    {
    //        product2 Discprod=TestDataFactoryTest.createDiscProduct('Test Discount',DISC_RECTYPE_ID,system.today(),'Conditional','Empty');  
    //        ApexPages.StandardController cont = new ApexPages.StandardController(Discprod);
    //        ProductClonecontroller pcc = new ProductClonecontroller(cont);
    //        System.Test.startTest();
    //            pcc.customsave();
    //        System.Test.stopTest();
    //        system.assertnotequals(apexpages.currentpage().getparameters().get('Id'),Discprod.Id);
    //    } 
    //}
}