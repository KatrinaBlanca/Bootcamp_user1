/**
  * @author       : Accenture IDC
  * @date         : 11/20/2015
  * @description  : Test Class for NonCommodityProdConfiguratorController class 
  */  
  
  @isTest(seealldata=true)
  public class NonCommodityProdsConfigControllerTest {
      
       
//      private static testmethod void checkSaveinOpptMode(){
       
//       //Creating Account
//       Test.startTest(); 
//       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
//       acc.name='Test Acc';
//       insert acc;
       
//       // Creating Opportunity   
//       Opportunity opp=new Opportunity();
//       opp.name='test Opp';
//       opp.StageName='Prospecting';
//       opp.CloseDate=System.Today();
//       opp.AccountId=acc.id;
//       Insert opp;
       
//       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
//       //Creating Master Product
//       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Non-commodity');
//       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
//       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
//       prod.Utility_type__c='Green';
//       Prod.isActive=True;
      
//       Prod.Contract_Duration_Years__c='testb';
//       Prod.Brand__c='testc';
//       update Prod;
//       //system.Test.startTest();                    
        
//       PageReference pageRef = Page.NonCommodityProductsConfigurator;       
           
//       system.Test.setCurrentPage(pageRef);
//       System.currentPageReference().getParameters().put('id',opp.id);
//       NonCommProductsConfiguratorController c=new NonCommProductsConfiguratorController();
//       OpportunityLineItem o=new OpportunityLineItem();
//      o=[select id from OpportunityLineItem limit 1];
//      // o.Product2.Id=Prod.id;
//       //o.Connection__c=con.id;
//       o.quantity=1;
//      update o;

//      Pricebook2 pb = TestDataFactoryTest.createPricebook(true, 'Price Book');
//      //Id pbid = Test.getStandardpricebookId();
//      Quote qout = TestDataFactoryTest.createQuote(opp.Id, acc.Id,'TestQuote', pb.Id);
//      PricebookEntry pbe = TestDataFactoryTest.createPricebookEntry(Prod.Id, pb.Id, 123);
//      QuoteLineItem q=TestDataFactoryTest.createQuoteLIneItem(qout.Id, pbe.Id,5,20,null);
//      //q.PriceBookId=Test.getStandardpricebookId();
//      //q=[select id from QuoteLineItem limit 1];
//      //q.QuoteId=qu.id;
//      q.Unitprice=12;
//      q.Quantity=1;
//      update q;
        
//       c.inOpportunityMode();      
//       c.save(); 
//       c.getnonCommodityProducts();
//       string st = c.title ;
//       string sub = c.subtitle;
//       //c.noncommodityProduct.add(masterProduct,True);
//       c.mselect();
//       NonCommProductsConfiguratorController.noncommodityProduct noncommodprod=new NonCommProductsConfiguratorController.noncommodityProduct();
//                    noncommodprod.product=Prod;
//                    noncommodprod.checked=true;
//                    //prodlist.add(noncommodprod);
//       List<NonCommProductsConfiguratorController.noncommodityProduct> prodlist = new List<NonCommProductsConfiguratorController.noncommodityProduct>();
//       c.noncomprds.add(noncommodprod);
//       //prodlist.add(noncommodprod);
//       //c.noncomprds[0].checked=true;
//       c.addnoncomprod();
//       c.opportunity = opp;
//       pagereference pfr1 = c.save();

//      // c.saveandNonCom();
//     //  c.saveanddiscount();
//       //csearch.actiont();   
//       //ConnectionSearchComponentController.ConnectionWrapper cwrapper= new  ConnectionSearchComponentController.ConnectionWrapper();
//      Test.stopTest();       
//      }
        
       
//     private static testmethod void checkSaveinQuoteMode(){
       
//       //Creating Account
       
//       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
//       acc.name='Test Acc';
//       insert acc;
       
//       // Creating Opportunity   
//       Opportunity opp=new Opportunity();
//       opp.name='test Opp';
//       opp.StageName='Prospecting';
//       opp.CloseDate=System.Today();
//       opp.AccountId=acc.id;
//       Insert opp;
       
//       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
//       //Creating Master Product
//       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Non-commodity');
//       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
//       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
//       prod.Utility_type__c='Grey';
//       Prod.isActive=True;
      
//       Prod.Contract_Duration_Years__c='testb';
//       Prod.Brand__c='testc';
//       update Prod;
//       system.Test.startTest();                  
//        Quote qu=new Quote();
//        qu.name='test';
//        qu.opportunityId=opp.id;
//        qu.PriceBook2Id=system.Test.getStandardpricebookId();
//        insert qu;
//       PageReference pageRef = Page.NonCommodityProductsConfigurator;       
           
//       system.Test.setCurrentPage(pageRef);
//       System.currentPageReference().getParameters().put('id',qu.id);
//       NonCommProductsConfiguratorController c=new NonCommProductsConfiguratorController();
       
//      // insert p;
//      Pricebook2 pb = TestDataFactoryTest.createPricebook(true, 'Price Book');
//      Quote qout = TestDataFactoryTest.createQuote(opp.Id, acc.Id,'TestQuote', pb.Id);
//      PricebookEntry pbe = TestDataFactoryTest.createPricebookEntry(Prod.Id, pb.Id, 123);
//      QuoteLineItem q=TestDataFactoryTest.createQuoteLIneItem(qout.Id, pbe.Id,5,20,null);
//      //q.PriceBookId=Test.getStandardpricebookId();
//      //q=[select id from QuoteLineItem limit 1];
//      //q.QuoteId=qu.id;
//      q.Unitprice=12;
//      q.Quantity=1;
     
//       //   q.Product2Id=Prod.id;
//    //   o.Connection__c=con.id;
//     //  o.quantity=1;
//       update q;
       
//       OpportunityLineItem o=new OpportunityLineItem();
//      // o.OpportunityId=opp.id;
//     //  o.PriceBookEntryId=[select id from pricebookEntry].id;
//     o=[select id from OpportunityLineItem limit 1];
//       o.Connection__c=Null;
//       o.quantity=1;
//       //o.TotalPrice=100;
//       update o;
//       c.inQuotemode(); 
//         c.mselect();
//c.quote =qu;
//c.save();
//c.saveanddiscount();
//NonCommProductsConfiguratorController.noncommodityProduct noncommodprod=new NonCommProductsConfiguratorController.noncommodityProduct();
//                    noncommodprod.product=Prod;
//                    noncommodprod.checked=true;
//                    //prodlist.add(noncommodprod);
//       List<NonCommProductsConfiguratorController.noncommodityProduct> prodlist = new List<NonCommProductsConfiguratorController.noncommodityProduct>();
//       c.noncomprds.add(noncommodprod);
//      c.addnoncomprod();
//      // c.saveandNoncom();
       
//     //  //csearch.actiont();   
//       //ConnectionSearchComponentController.ConnectionWrapper cwrapper= new  ConnectionSearchComponentController.ConnectionWrapper();
               
//      }
      
//      private static testmethod void checkMethods(){
//           //Creating Account
       
//       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
//       acc.name='Test Acc';
//       insert acc;
       
//       // Creating Opportunity   
//       Opportunity opp=new Opportunity();
//       opp.name='test Opp';
//       opp.StageName='Prospecting';
//       opp.CloseDate=System.Today();
//       opp.AccountId=acc.id;
//       Insert opp;
       
//       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
//       //Creating Master Product
//       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Non-commodity');
//       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
//       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
//       prod.Utility_type__c='Grey';
//       Prod.isActive=True;
      
//       Prod.Contract_Duration_Years__c='testb';
//       Prod.Brand__c='testc';
//       prod.Fee_type__c='testc';
//       update Prod;
//           OpportunityLineItem o=new OpportunityLineItem();
//      o=[select id from OpportunityLineItem limit 1];
//      //o.OpportunityId=opp.id;
//      // o.Product2.Id=Prod.id;
//       o.Connection__c=Null;
//       o.quantity=1;
//      update o; 
          
//           PageReference pageRef = Page.NonCommodityProductsConfigurator;       
        
//       system.Test.setCurrentPage(pageRef);
//       System.currentPageReference().getParameters().put('id',opp.id);
//       NonCommProductsConfiguratorController c=new NonCommProductsConfiguratorController();
//       c.cancel();
//      }
//      private static testmethod void checkSaveinOpptMode1(){
       
//       //Creating Account
       
//       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
//       acc.name='Test Acc';
//       insert acc;
       
//       // Creating Opportunity   
//       Opportunity opp=new Opportunity();
//       opp.name='test Opp';
//       opp.StageName='Prospecting';
//       opp.CloseDate=System.Today();
//       opp.AccountId=acc.id;
//       Insert opp;
       
//      RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
//       //Creating Master Product
//       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Non-commodity');
//       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
//       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
//       prod.Utility_type__c='Grey';
//       Prod.isActive=True;
      
//       Prod.Contract_Duration_Years__c='testb';
//       Prod.Brand__c='testc';
//       update Prod;
//       system.Test.startTest();                    
        
//       PageReference pageRef = Page.NonCommodityProductsConfigurator;       
           
//       system.Test.setCurrentPage(pageRef);
//       System.currentPageReference().getParameters().put('id',opp.id);
//       NonCommProductsConfiguratorController c=new NonCommProductsConfiguratorController();
//       OpportunityLineItem o=new OpportunityLineItem();
//      o=[select id from OpportunityLineItem limit 1];
//      // o.Product2.Id=Prod.id;
//       o.Connection__c=Null;
//       o.quantity=1;
//      update o;
//      Pricebook2 pb = TestDataFactoryTest.createPricebook(true, 'Price Book');
//      Quote qout = TestDataFactoryTest.createQuote(opp.Id, acc.Id,'TestQuote', pb.Id);
//      PricebookEntry pbe = TestDataFactoryTest.createPricebookEntry(Prod.Id, pb.Id, 123);
//      QuoteLineItem q=TestDataFactoryTest.createQuoteLIneItem(qout.Id, pbe.Id,5,20,null);
//      //q.PriceBookId=Test.getStandardpricebookId();
//      //q=[select id from QuoteLineItem limit 1];
//      //q.QuoteId=qu.id;
//      q.Unitprice=12;
//      q.Quantity=1;
//      update q;
//       c.inOpportunityMode();      
//      // c.save();   
//       c.saveandDiscount();
//     //  c.saveanddiscount();
//       //csearch.actiont();   
//       //ConnectionSearchComponentController.ConnectionWrapper cwrapper= new  ConnectionSearchComponentController.ConnectionWrapper();
               
//      }
      
//      private static testmethod void checkSaveinOpptMode2(){
       
//       //Creating Account
       
//       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
//       acc.name='Test Acc';
//       insert acc;
       
//       // Creating Opportunity   
//       Opportunity opp=new Opportunity();
//       opp.name='test Opp';
//       opp.StageName='Prospecting';
//       opp.CloseDate=System.Today();
//       opp.AccountId=acc.id;
//       Insert opp;
       
//       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
//       //Creating Master Product
//       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Non-commodity');
//       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
//       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
//       prod.Utility_type__c='Grey';
//       Prod.isActive=True;
      
//       Prod.Contract_Duration_Years__c='testb';
//       Prod.Brand__c='testc';
//       update Prod;
//       system.Test.startTest();                    
        
//       PageReference pageRef = Page.NonCommodityProductsConfigurator;       
//    //   Opportunity ot=[select id, (select id from OpportunityLineitems) from Opportunity limit 1];
//       system.Test.setCurrentPage(pageRef);
//       System.currentPageReference().getParameters().put('id',opp.id);
//       NonCommProductsConfiguratorController c=new NonCommProductsConfiguratorController();
//       OpportunityLineItem o=new OpportunityLineItem();
//      o=[select id from OpportunityLineItem  limit 1];
//      // o.Product2.Id=Prod.id;
//       o.Connection__c=Null;
//       o.quantity=1;
//      update o;
//      Pricebook2 pb = TestDataFactoryTest.createPricebook(true, 'Price Book');
//      Quote qout = TestDataFactoryTest.createQuote(opp.Id, acc.Id,'TestQuote', pb.Id);
//      PricebookEntry pbe = TestDataFactoryTest.createPricebookEntry(Prod.Id, pb.Id, 123);
//      QuoteLineItem q=TestDataFactoryTest.createQuoteLIneItem(qout.Id, pbe.Id,5,20,null);
//      //q.PriceBookId=Test.getStandardpricebookId();
//      //q=[select id from QuoteLineItem limit 1];
//      //q.QuoteId=qu.id;
//      q.Unitprice=12;
//      q.Quantity=1;
//      update q;
//       c.inOpportunityMode();   
//       c.save();   
//      // c.save();   
//      // c.saveandNonCom();
//      c.saveanddiscount();
//     // c.productToOliMap.put(Prod,o);
//      //c.productsInOppLineitemap.put(o.id,Prod);
//       //csearch.actiont();   
//       //ConnectionSearchComponentController.ConnectionWrapper cwrapper= new  ConnectionSearchComponentController.ConnectionWrapper();
               
//      }
      
      
//      private static testmethod void checkSaveinQuoteMode2(){
       
//       //Creating Account
       
//       Account acc= CXE_TestDataFactory.createBusinessAccount(1)[0];
//       acc.name='Test Acc';
//       insert acc;
       
//       // Creating Opportunity   
//       Opportunity opp=new Opportunity();
//       opp.name='test Opp';
//       opp.StageName='Prospecting';
//       opp.CloseDate=System.Today();
//       opp.AccountId=acc.id;
//       Insert opp;
       
//       //Creating Quote
//       Quote quo = new Quote();
//       Quo.Name = 'Test';
//       quo.OpportunityId = opp.id;
//       insert Quo;
       
//       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
      
//       //Creating Master Product
//       Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Non-commodity');
//       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
//       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
//       prod.Utility_type__c='Grey';
//       Prod.isActive=True;
      
//       Prod.Contract_Duration_Years__c='testb';
//       Prod.Brand__c='testc';
//       update Prod;
//       system.Test.startTest();                    
        
//       PageReference pageRef = Page.NonCommodityProductsConfigurator;       
//    //   Opportunity ot=[select id, (select id from OpportunityLineitems) from Opportunity limit 1];
//       system.Test.setCurrentPage(pageRef);
//       System.currentPageReference().getParameters().put('id',quo.id);
//       NonCommProductsConfiguratorController c=new NonCommProductsConfiguratorController();
//      Pricebook2 pb = TestDataFactoryTest.createPricebook(true, 'Price Book');
//      Quote qout = TestDataFactoryTest.createQuote(opp.Id, acc.Id,'TestQuote', pb.Id);
//      PricebookEntry pbe = TestDataFactoryTest.createPricebookEntry(Prod.Id, pb.Id, 123);
//      QuoteLineItem q=TestDataFactoryTest.createQuoteLIneItem(qout.Id, pbe.Id,5,20,null);
//      //q.PriceBookId=Test.getStandardpricebookId();
//      //q=[select id from QuoteLineItem limit 1];
//      //q.QuoteId=qu.id;
//      q.Unitprice=12;
//      q.Quantity=1;
//      update q;
//       c.inQuoteMode(); 
//      c.quote = quo;

//       c.save();    
//       c.cancel();
      
//      c.saveanddiscount();
      
//          //ConnectionSearchComponentController.ConnectionWrapper cwrapper= new  ConnectionSearchComponentController.ConnectionWrapper();
               
//      }
}