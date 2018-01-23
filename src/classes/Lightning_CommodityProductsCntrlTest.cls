/**
*  Test Class for Lightning_CommodityProductsConfigCntrl
*  @Author Accenture 
*  Created date : 04/04/2016
*  Version Changes 
*/
@isTest
private class Lightning_CommodityProductsCntrlTest {
       // static testMethod void validateOpptyName() {
       //     //Creating Account
       
       //Account acc= new Account();
       //acc.name='Test Acc';
       //acc.Tax_Identification_No__c = '1111'; //added Von Pernicia
       //insert acc;
       
       //// Creating Opportunity   
       //Opportunity opp=new Opportunity();
       //opp.name='test Opp';
       //opp.StageName='Prospecting';
       //opp.CloseDate=System.Today();
       //opp.AccountId=acc.id;
       //Insert opp;
       
       ////Creating Connection
       //Connection__c con=new Connection__c();
       //con.Account__c=acc.id;
       //con.Utility_Type__c='Electricity';
       //con.Delivery_Street__c='Street';
       //con.Delivery_City__c='City';
       //con.Delivery_Postal_Code__c='123456';
       //// Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       ////con.name='Test Conection';
       //// End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       //insert con;
       
       
       ////Creating Connection
       //Connection__c con1=new Connection__c();
       //con1.Account__c=acc.id;
       //con1.Utility_Type__c='Electricity';
       //// Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       ////con1.name='Test Conection 1';
       //// End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       //con1.Delivery_Street__c='Street';
       //con1.Delivery_City__c='City';
       //con1.Delivery_Postal_Code__c='123456';
       //insert con1;
       
       ////Creating Connection
       //Connection__c con2=new Connection__c();
       //con2.Account__c=acc.id;
       //con2.Utility_Type__c='Gas';
       //// Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       ////con2.name='Test Conection 2';
       //// End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
       //con2.Delivery_Street__c='Street';
       //con2.Delivery_City__c='City';
       //con2.Delivery_Postal_Code__c='123456';
       //insert con2;
       
       //RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
       ////Creating Master Product
       //Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
       //Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
       //Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
       //Prod.isActive=True;
       //prod.Utility_type__c='Electricity';
       //update Prod;
       //ConnectionSearchListener oConSer;          
       //ConnectionSearchComponentController csearch=new ConnectionSearchComponentController();
       //ConnectionSearchComponentController.ConnectionWrapper oSer=new ConnectionSearchComponentController.ConnectionWrapper(con2,oConSer);
       //oSer.selected=true;
       //List<ConnectionSearchComponentController.ConnectionWrapper> oSerList = new List<ConnectionSearchComponentController.ConnectionWrapper>();
       //oSerList.add(oSer);
       // csearch.selectedConnections();
       // csearch.inOpportunityMode();
       // csearch.postalCode='1212121';
       // csearch.street ='scasc';
       // csearch.City='vaav';
       // csearch.CityDupe='Test';
       // csearch.electricity=true;
       // csearch.postalCodeDupe='test';
       // csearch.streetDupe='test';
       // csearch.elecdupe=true;
       // csearch.gas=true;    
       // csearch.gasdupe=true;
       // csearch.AutoSearching=true;
       // csearch.mode='SearchFields';
       // csearch.actId=acc.id;
       // csearch.connectionSearchListener=oConSer;
       //  oSerList = csearch.connectionWrappers;
       ////oConSer.newConnectionSelected(con2);
       
       //List<ConnectionSearchComponentController.ConnectionWrapper> conn = new List<ConnectionSearchComponentController.ConnectionWrapper>(csearch.connectionWrappers);
       
       //csearch.returnList= oSerList;
       // String opptyId = opp.Id;
       //         String AccountId = acc.Id;
       //         String city = 'vaav';
       //         String street = 'scasc';
       //         String PostalCode = '1212121';
       //         Boolean isGas = true;
       //         Boolean isElectricity = true;
                
       //         list<Id> connectionIds = new List<Id>();
       //         connectionIds.add(con.Id);
       //         connectionIds.add(con1.Id);
       //         connectionIds.add(con2.Id);
                
       //         List<Lightning_CommodityProductsConfigCntrl.connectionWrapper1> s = new  List<Lightning_CommodityProductsConfigCntrl.connectionWrapper1>();
       //         String str = JSON.serialize(s);
                
       //  Lightning_CommodityProductsConfigCntrl.connectionSearch(opptyId,AccountId,city,street,PostalCode,isGas,isElectricity);
       //  Lightning_CommodityProductsConfigCntrl.getOpptyName(opptyId); 
       //  Lightning_CommodityProductsConfigCntrl.commodityProducts(opptyId,connectionIds);
       //  Lightning_CommodityProductsConfigCntrl.filterChange(opptyId,str);
       //  Lightning_CommodityProductsConfigCntrl.saveConn(str,opptyId);    
       // }

}