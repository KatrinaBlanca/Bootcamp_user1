/**
  * @author       : Accenture IDC
  * @date         : 10/26/2015
  * @description  : Test Class for CommodityProductsConfiguratorController class 
  */  
  
  @isTest(seeAlldata=true)
  public class CommodityProdsConfiguratorControllerTest {
      
      ///**
      //* @description       Test method to validate payment plans
      //* @param             NA
      //* @return            Void
      //* @throws            NA
      //*/
      
      //private static testmethod void checkConnections(){
       
      // //Creating Account
       
      // Account acc= new Account();
      // acc.name='Test Acc';
      // acc.Tax_Identification_No__c = '1111'; //added Von Pernicia
      // insert acc;
       
      // // Creating Opportunity   
      // Opportunity opp=new Opportunity();
      // opp.name='test Opp';
      // opp.StageName='Prospecting';
      // opp.CloseDate=System.Today();
      // opp.AccountId=acc.id;
      // Insert opp;
       
      // //Creating Connection
      // Connection__c con=new Connection__c();
      // con.Account__c=acc.id;
      // con.Utility_Type__c='Electricity';
      // con.Delivery_Street__c='Street';
      // con.Delivery_City__c='City';
      // con.Delivery_Postal_Code__c='123456';
      // // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      // //con.name='Test Conection';
      // // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      // insert con;
       
       
      // //Creating Connection
      // Connection__c con1=new Connection__c();
      // con1.Account__c=acc.id;
      // con1.Utility_Type__c='Electricity';
      // // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      // //con1.name='Test Conection 1';
      // // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      // con1.Delivery_Street__c='Street';
      // con1.Delivery_City__c='City';
      // con1.Delivery_Postal_Code__c='123456';
      // insert con1;
       
      // RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
      //test.startTest();
      // //Creating Master Product
      // Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
      // Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
      // Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
      // Prod.isActive=True;
      // prod.Utility_type__c='Electricity';
      // update Prod;
       
      // //system.Test.startTest();                    
        
      // PageReference pageRef = Page.CommodityProductsConfigurator;       
           
      // system.Test.setCurrentPage(pageRef);
      // System.currentPageReference().getParameters().put('id',opp.id);
      // CommodityProductsConfiguratorController c=new CommodityProductsConfiguratorController();
       
      // ConnectionSearchComponentController csearch=new ConnectionSearchComponentController();        
      // c.connectionIdTofilterMap.put(con.id,'sel');
      // c.connectionIdTofilterfeeMap.put(con.id,'all');
      // c.connectionIdTofilterBrandMap.put(con.id,'all');
      //  OpportunityLineItem o=new OpportunityLineItem();
      //o=[select id from OpportunityLineItem limit 1];
      //// o.Product2.Id=Prod.id;
      // o.Connection__c=con.id;
      // o.quantity=1;
      //update o;
      // QuoteLineItem q=new QuoteLineItem ();
      ////q.PriceBookId=Test.getStandardpricebookId();

      //// Start Von Pernicia
      //Pricebookentry pbe=[select id from Pricebookentry where product2id=:prod.id];
      ////opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,'Test Opportunity',System.today(),'Prospecting',System.Test.getStandardPricebookId(),null);
      //OpportunityLineItem OLI=TestDataFactoryTest.createOpportunityLineItem(opp.id,PBE.id,1,20);
      //Quote quo = TestDataFactoryTest.createQuote(opp.id,acc.id,'Test Quote',System.Test.getStandardPricebookId());
      //QuoteLineItem qli = TestDataFactoryTest.createQuoteLIneItem(quo.id,PBE.id,1,20,con.id);
      //// End Von Pernicia

      //q=[select id,QuoteId from QuoteLineItem limit 1];
      ////q.QuoteId=qu.id;
      //q.Unitprice=12;
      //q.Quantity=1;
      //update q;
      
      //test.stopTest();

      // c.connectionIdToProductIdMap.put(con.id,Prod.id);
      //c.connectionIdToOpportunityLineItemMap.put(con.id,o); 
      //c.connectionIdToQuoteLineItemMap.put(con.id,q);
      // c.newConnectionSelected(con); 
      // c.showError=true;
      // c.Feetype ='Test'; 
      // c.picklist='Test'; 
      // c.conutilitytype= con.id;
      // c.fromComp=true;
      // c.totaleleceav = 1.0;
      // c.totalgaseav=2.0;
      // c.totalelec= 2.0;
      // c.totalgas=6.0;
      // String subtitle= c.subtitle;
      // String title=c.title;
      // List<SelectOption> oSelOpt = c.getCommercialProductOptionsForConnection(con1);
      // c.connectionDeselected(con);
      // c.save();
      // c.saveandNoncom();
      // c.saveanddiscount();
      // c.cancel();
      // //c.saveInQuoteMode();
      // c.filter();
      // c.filterFee();
      // c.showPopup();
      // c.calculateeav();
      // c.closePopup();
      // c.clearMap();
      // c.NewCon();
      // //csearch.actiont();   
      // //ConnectionSearchComponentController.ConnectionWrapper cwrapper= new  ConnectionSearchComponentController.ConnectionWrapper();
      // PageReference pageRef1 = Page.CommodityProductsConfigurator;       
           
      // system.Test.setCurrentPage(pageRef1);
      // System.currentPageReference().getParameters().put('id',opp.id);
      // CommodityProductsConfiguratorController c1=new CommodityProductsConfiguratorController();
               
      //}  
      //  private static testmethod void checkConnections1(){
      //      //Creating Account
       
      //         Account acc= new Account();
      //         acc.name='Test Acc';
      //         acc.Tax_Identification_No__c = '1111'; //added Von Pernicia
      //         insert acc;
               
      //         // Creating Opportunity   
      //         Opportunity opp=new Opportunity();
      //         opp.name='test Opp';
      //         opp.StageName='Prospecting';
      //         opp.CloseDate=System.Today();
      //         opp.AccountId=acc.id;
      //         Insert opp;
               
      //         //Creating Connection
      //         Connection__c con=new Connection__c();
      //         con.Account__c=acc.id;
      //         con.Utility_Type__c='Electricity';
      //         con.Delivery_Street__c='Street';
      //         con.Delivery_City__c='City';
      //         con.Delivery_Postal_Code__c='123456';
      //         // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      //         //con.name='Test Conection';
      //         // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      //         insert con;
               
               
      //         //Creating Connection
      //         Connection__c con1=new Connection__c();
      //         con1.Account__c=acc.id;
      //         con1.Utility_Type__c='Electricity';
      //         // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      //         //con1.name='Test Conection 1';
      //         // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      //         con1.Delivery_Street__c='Street';
      //         con1.Delivery_City__c='City';
      //         con1.Delivery_Postal_Code__c='123456';
      //         insert con1;
               
      //         RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
              
      //         //Creating Master Product
      //         Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
      //         Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
      //         Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
      //         Prod.isActive=True;
      //         prod.Utility_type__c='Electricity';
      //         //prod.Master_Product_Type__c='Electricity';
      //         prod.Contract_Duration_Years__c='all';
      //         prod.Fee_Type__c='all';
      //         prod.Brand__c='all';
      //         update Prod;
               
      //         OpportunityLineItem o=new OpportunityLineItem();
      //         o=[select id from OpportunityLineItem limit 1];
      //        // o.Product2.Id=Prod.id;
      //         o.Connection__c=con.id;
      //         o.quantity=1;
      //        update o;
      //         QuoteLineItem q=new QuoteLineItem ();

      //        // Start Von Pernicia
      //        Pricebookentry pbe=[select id from Pricebookentry where product2id=:prod.id];
      //        //opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,'Test Opportunity',System.today(),'Prospecting',System.Test.getStandardPricebookId(),null);
      //        OpportunityLineItem OLI=TestDataFactoryTest.createOpportunityLineItem(opp.id,PBE.id,1,20);
      //        Quote quo = TestDataFactoryTest.createQuote(opp.id,acc.id,'Test Quote',System.Test.getStandardPricebookId());
      //        QuoteLineItem qli = TestDataFactoryTest.createQuoteLIneItem(quo.id,PBE.id,1,20,con.id);
      //        // End Von Pernicia

      //        //q.PriceBookId=Test.getStandardpricebookId();
      //        q=[select id,QuoteId from QuoteLineItem limit 1];
      //        //q.QuoteId=qu.id;
      //        q.Unitprice=12;
      //        q.Quantity=1;
      //        update q;
               
      //         system.Test.startTest();                    
                
      //         PageReference pageRef = Page.CommodityProductsConfigurator;       
                   
      //         system.Test.setCurrentPage(pageRef);
      //         System.currentPageReference().getParameters().put('id',q.QuoteId);
      //         CommodityProductsConfiguratorController c=new CommodityProductsConfiguratorController();
               
      //         ConnectionSearchComponentController csearch=new ConnectionSearchComponentController();        
      //         c.connectionIdTofilterMap.put(con.id,'sel');
      //         c.connectionIdTofilterfeeMap.put(con.id,'sel');
      //         c.connectionIdTofilterBrandMap.put(con.id,'all');
      //         c.inQuoteMode();
      //         c.saveInQuoteMode(); 
               
            
      //  }  
      //  private static testmethod void checkConnections12()    
      //  {
      //      RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      //      Master_Product__c MasterProduct= TestDataFactoryTest.createMasterProduct('Test MasterProduct','Electricity');  
      //      id commercialProductRectype=product2.sobjectType.getDescribe().getRecordTypeInfosByName().get('Commercial Product').getRecordTypeId();
      //      product2 product=TestDataFactoryTest.createProduct('test Product',masterproduct.id,commercialProductRectype,'Variable') ;
      //      product2 prod =[select id from Product2 where id =:product.id];
      //      prod.isactive=true;
      //      update prod;
      //      Pricebookentry pbe=[select id from Pricebookentry where product2id=:prod.id];
      //      Account acc= new Account();
      //     acc.name='Test Acc';
      //     acc.Tax_Identification_No__c = '1111'; //added Von Pernicia
      //     acc.Customer_Accepted__c = 'Rejected';
      //     insert acc;
           
      //      opportunity opp=TestDataFactoryTest.createOpportunity(acc.id,'Test Opportunity',System.today(),'Prospecting',System.Test.getStandardPricebookId(),null);
      //      OpportunityLineItem OLI=TestDataFactoryTest.createOpportunityLineItem(opp.id,PBE.id,1,20);
      //      Quote quo = TestDataFactoryTest.createQuote(opp.id,acc.id,'Test Quote',System.Test.getStandardPricebookId());
            
      //      //Creating Connection
      //         Connection__c con=new Connection__c();
      //         con.Account__c=acc.id;
      //         con.Utility_Type__c='Electricity';
      //         // Begin: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      //         //con.name='Test Conection 1';
      //         // End: Von Pernicia 3/1/17 Story:CSM-237, CSM-238 Defect:CSM-659
      //         con.Delivery_Street__c='Street';
      //         con.Delivery_City__c='City';
      //         con.Delivery_Postal_Code__c='123456';
      //         insert con;
               
      //         QuoteLineItem qli = TestDataFactoryTest.createQuoteLIneItem(quo.id,PBE.id,1,20,con.id);
            
               
      //         OpportunityLineItem oliList = new OpportunityLineItem();
      //         oliList=[select id from OpportunityLineItem where id=:OLI.id];
      //         oliList.Connection__c=con.id;
      //         update oliList;
               
      //         system.Test.startTest();                    
        
      //         PageReference pageRef = Page.CommodityProductsConfigurator;       
                   
      //         system.Test.setCurrentPage(pageRef);
      //         System.currentPageReference().getParameters().put('id',opp.id);
      //         CommodityProductsConfiguratorController c=new CommodityProductsConfiguratorController();
            
      //        c.connectionIdToProductIdMap.put(con.id,prod.id);
      //        c.connectionIdToOpportunityLineItemMap.put(con.id,OLI); 
      //        c.connectionIdToQuoteLineItemMap.put(con.id,qli);
      //        c.connectionIdTofilterMap.put(con.id,'all');
      //         c.connectionIdTofilterfeeMap.put(con.id,'Sel');
      //         c.connectionIdTofilterBrandMap.put(con.id,'all');
      //         c.newConnectionSelected(con); 
      //         c.showError=true;
      //         c.Feetype ='Test'; 
      //         c.picklist='Test'; 
      //         c.conutilitytype= con.id;
      //         c.fromComp=true;
      //         c.totaleleceav = 1.0;
      //         c.totalgaseav=2.0;
      //         c.totalelec= 2.0;
      //         c.totalgas=6.0;
      //         String subtitle= c.subtitle;
      //         String title=c.title;
      //         List<SelectOption> oSelOpt = c.getCommercialProductOptionsForConnection(con);
      //         c.connectionDeselected(con);
      //         c.save();
      //         c.saveandNoncom();
      //         c.saveanddiscount();
      //         c.cancel();
      //         //c.saveInQuoteMode();
      //         c.filter();
      //         c.filterFee();
      //         c.showPopup();
      //         c.calculateeav();
      //         c.closePopup();
      //         c.clearMap();
      //         c.NewCon();
               
      //         PageReference pageRef1 = Page.CommodityProductsConfigurator;       
                   
      //         system.Test.setCurrentPage(pageRef1);
      //         System.currentPageReference().getParameters().put('id',quo.id);
      //         CommodityProductsConfiguratorController c2=new CommodityProductsConfiguratorController();
               
      //         ConnectionSearchComponentController csearch2=new ConnectionSearchComponentController();        
      //         c2.connectionIdTofilterMap.put(con.id,'all');
      //         c2.connectionIdTofilterfeeMap.put(con.id,'all');
      //         c2.connectionIdTofilterBrandMap.put(con.id,'all');
      //         c2.connectionIdToQuoteLineItemMap.put(con.id,qli);
      //         //c2.connectionDeselected(con);
      //         c2.showError=true;
      //         c2.Feetype ='Test'; 
      //         c2.picklist='Test'; 
      //         c2.conutilitytype= con.id;
      //         c2.fromComp=true;
      //         c2.totaleleceav = 1.0;
      //         c2.totalgaseav=2.0;
      //         c2.totalelec= 2.0;
      //         c2.totalgas=6.0;
      //         String subtitle1= c2.subtitle;
      //         String title2=c2.title;
      //         List<SelectOption> oSelOpt1 = c2.getCommercialProductOptionsForConnection(con);
      //         c2.connectionDeselected(con);
               
      //         c2.save();
      //         c2.saveandNoncom();
      //         c2.saveanddiscount();
      //         c2.cancel();
      //         //c.saveInQuoteMode();
      //         c2.filter();
      //         c2.filterFee();
      //         c2.showPopup();
      //         c2.calculateeav();
      //         c2.closePopup();
      //         c2.clearMap();
      //         //c2.NewCon();s
      //         c2.inQuoteMode();
      //         c2.saveInQuoteMode(); 
               
      //  } 
    
      
  }