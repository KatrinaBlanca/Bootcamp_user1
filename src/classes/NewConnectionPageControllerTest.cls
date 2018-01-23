/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for NewConnectionPageController class 
  */  
@isTest()
public class NewConnectionPageControllerTest{
     
    private static testMethod void TestMet(){
           //Creating Account
       
       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
       //acc.name='Test Acc';
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
      // insert con1;
       
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
       //insert con2;
       
       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
       //Creating Master Product
       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
       Prod.isActive=True;
       prod.Utility_type__c='Electricity';
       update Prod;
       system.Test.startTest(); 
       PageReference pageRef = Page.NewConnectionPage;       
           
       system.Test.setCurrentPage(pageRef);
       System.currentPageReference().getParameters().put('Oppid',opp.id);
       System.currentPageReference().getParameters().put('Ptype','Commodity');       
    ApexPages.StandardController sc = new ApexPages.StandardController(con2);
        NewConnectionPageController oNewCon= new NewConnectionPageController(sc);
       //NewConnectionPageController oNewCon = new NewConnectionPageController();
       oNewCon.Customsave();
       oNewCon.CustomCancel();
       System.currentPageReference().getParameters().put('Ptype','Bundle'); 
           ApexPages.StandardController sc2 = new ApexPages.StandardController(con1);
        NewConnectionPageController oNewCon2= new NewConnectionPageController(sc2);
       oNewCon2.Customsave();
       oNewCon2.CustomCancel();
    }
   
}