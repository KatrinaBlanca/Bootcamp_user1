/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for CommercialProductOverviewController class 
  */  
@isTest(seeAllData=true)
public class CommercialProductOverviewControllerTest{
     
    private static testMethod void TestMet(){
           //Creating Account
       
       Account acc= new Account();
       acc.name='Test Acc';
       acc.Tax_Identification_No__c = '1111'; //added Von Pernicia
       acc.Email__c = 'test@test.com';//START/END R2 RReyes JUL-08-17 - added email to pass validation
       insert acc;
       
       // Creating Opportunity   
       Opportunity opp=new Opportunity();
       opp.name='test Opp';
       opp.StageName='Prospecting';
       opp.CloseDate=System.Today();
       opp.AccountId=acc.id;
       Insert opp;
       
       //Creating Connection
       Connection__c con=new Connection__c();
       con.Account__c=acc.id;
       con.Utility_Type__c='Electricity';
       con.Delivery_Street__c='Street';
       con.Delivery_City__c='City';
       con.Delivery_Postal_Code__c='123456';
       // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       //con.name='Test Conection';
       // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       insert con;
       
       
       //Creating Connection
       Connection__c con1=new Connection__c();
       con1.Account__c=acc.id;
       con1.Utility_Type__c='Electricity';
       // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       //con1.name='Test Conection 1';
       // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       con1.Delivery_Street__c='Street';
       con1.Delivery_City__c='City';
       con1.Delivery_Postal_Code__c='123456';
       insert con1;
       
       //Creating Connection
       Connection__c con2=new Connection__c();
       con2.Account__c=acc.id;
       con2.Utility_Type__c='Gas';
       // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       //con2.name='Test Conection 2';
       // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       con2.Delivery_Street__c='Street';
       con2.Delivery_City__c='City';
       con2.Delivery_Postal_Code__c='123456';
       insert con2;
       
       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
       //Creating Master Product
       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
       Pricebookentry pbe= [select id from PricebookEntry where Product2.id=:Prod.id];
       OpportunityLineItem oli=TestDataFactoryTest.createOpportunityLineItem(opp.id,pbe.id,1,1.0);

       Prod.isActive=True;
       prod.Utility_type__c='Electricity';
       update Prod;
       system.Test.startTest(); 
       //PageReference pageRef = Page.NewMeterReadPageFromOpp;       
           
       //system.Test.setCurrentPage(pageRef);
       CommercialProductOverviewController oCommProd = new CommercialProductOverviewController();
       oCommProd.productId=Prod.id;
       oCommProd.eavParam=12;
       //CommercialProductOverviewController.lines oLine=new CommercialProductOverviewController.lines();
       oCommProd.getProductDetail();
       CommercialProductUnitPriceCalculator.line oLine= new CommercialProductUnitPriceCalculator.line();
       oLine.name = 'Test';
       oLine.eav= 'Test';
       oLine.rate = 'Test';
       oLine.operation = 'Test';
       oLine.newTotal = 'Test';
       oLine.delta = 'Test';
       oLine.criterium = 'Test';
       List<CommercialProductUnitPriceCalculator.line> oLineList = new List<CommercialProductUnitPriceCalculator.line>();
       oLineList.add(oLine);
       oLineList=oCommProd.lines;
       //System.assertEquals(oLineList,oCommProd.lines);
    
    }
   
}