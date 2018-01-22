/**
  * @author       : Accenture IDC
  * @date         : 10/26/2015
  * @description  : Test Class for CustomPopupController class 
  */  
  
  @isTest()
  public class CustomPopupControllerTest {
      
      /**
      * @description       Test method to validate payment plans
      * @param             NA
      * @return            Void
      * @throws            NA
      */
      
      private static testmethod void checkConnections(){
       
       
       
       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
       //Creating Master Product
       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
       Prod.isActive=True;
       prod.Utility_type__c='Electricity';
       update Prod;
       system.Test.startTest();                    
       CustomPopupController oCustomSearch=new CustomPopupController();        
       oCustomSearch.runQuery();
    oCustomSearch.DiscountQuery();
    system.Test.stopTest(); 
               
      }
      
      
  }