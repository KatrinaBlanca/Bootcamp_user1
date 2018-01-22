/**
  * @author       : Accenture IDC
  * @date         : 01/12/2015
  * @description  : Test Class for DiscountProductsConfiguratorController class
  */  
@isTest
public class DiscountProductsConfiguratorContrTest{
     
  //  private static testMethod void DiscountProductsConfigurator_test(){
  //         //Creating Account
  //     RecordType persAccountRtype =[select id,name,developername,sobjecttype from recordtype where developername='PersonAccount' and sobjecttype='account'];
  //     List<Account> acclist= new Account[2];
  //     acclist[0] = new account(firstname='Test Acc',lastname='sample',recordtypeid = persAccountRtype.Id, Tax_Identification_No__c = '111111');
  //     acclist[1] = new account(firstname='Test Acc',lastname='sample',recordtypeid = persAccountRtype.Id, Tax_Identification_No__c = '222222');       
  //     insert acclist;
       
  //     // Creating Opportunity   
  //     List<Opportunity> oppList=new Opportunity[4];
  //     oppList[0] = new opportunity(name='test Opp',StageName='Prospecting',CloseDate=System.Today(),AccountId=acclist[1].id);
  //     oppList[1] = new opportunity(name='test Opp',StageName='Prospecting',CloseDate=System.Today(),AccountId=acclist[1].id);       
  //     oppList[2] = new opportunity(name='test Opp',StageName='Prospecting',CloseDate=System.Today(),AccountId=acclist[0].id);       
  //      oppList[3] = new opportunity(name='test Opp',StageName='Prospecting',CloseDate=System.Today(),AccountId=acclist[0].id);       
  //     Insert oppList; 
       
           
       
  //    RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
  //    RecordType rec1=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername<>'Commercial_Product' Limit 1];
      
  //     //Creating Master Product
  //     Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
  //     Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
  //     Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
  //     recordtype rt = [Select Id From RecordType Where sObjectType = 'product2' and DeveloperName = 'Discount'];
  //     Prod.isActive=True;
  //     prod.recordtypeid = rt.Id;
  //     prod.Utility_type__c='Electricity';
  //     prod.Allowed_Customer_Groups__c='All';
  //     update Prod;
       
  //     Product2 Prod2 = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
  //     //prod2.recordtypeid = rt.Id;    
  //     Prod2.isActive=True;
  //     prod2.Utility_type__c='Electricity';  
  //     update Prod2;  
       
  //     Product2 Prod3 = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
  //     Prod3.isActive=True;
  //       prod3.recordtypeid = rt.Id;
  //     Prod3.Allowed_Customer_Groups__c = 'Businesses';
  //     update Prod3;
       
  //       Product2 Prod4 = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec1.id,'Fixed');
  //     Prod4.isActive=True;
         
  //     Prod4.Allowed_Customer_Groups__c = 'All';
  //     update Prod4;
       
  //     Master_Product_Discount__c mpdiscot = new Master_Product_Discount__c(Master_Product__c=masterProduct.id,Product__c=prod.Id);
  //     insert mpdiscot ;
  //      Master_Product_Discount__c mpdiscot2 = new Master_Product_Discount__c(Master_Product__c=masterProduct.id,Product__c=prod3.Id);
  //     insert mpdiscot2 ;
       
  //      //Get the Standard PriceBook and make sure it is active
  //      List<Pricebook2> pricebooklist = new Pricebook2[3];
  //      pricebooklist[0] = new Pricebook2(Name = 'Standard Price Book');
  //      pricebooklist[1] = new Pricebook2(Name = 'Standard Price Book2');
  //      pricebooklist[2] = new Pricebook2(Name = 'Standard Price Book3');    
  //         insert pricebooklist;     
       
  //     //Create your pricebook entry
  //      List<PricebookEntry> PricebookEntrylist = new PricebookEntry[3];       
  //      PricebookEntrylist[0] = new PricebookEntry(Pricebook2Id = pricebooklist[0].Id,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true);       
  //      PricebookEntrylist[1] = new PricebookEntry(Pricebook2Id = pricebooklist[1].Id,Product2Id = prod2.Id,UnitPrice = 100.00,IsActive = true);
  //      PricebookEntrylist[2] = new PricebookEntry(Pricebook2Id = pricebooklist[2].Id,Product2Id = prod3.Id,UnitPrice = 100.00,IsActive = true); 
  //           insert PricebookEntrylist;
       
  //     List<Quote> qtList = new Quote[2];
  //     qtList[0]= new quote(name='qt1',OpportunityId=oppList[0].id,Pricebook2id=pricebooklist[1].Id);  
  //     qtList[1]= new quote(name='qt2',OpportunityId=oppList[0].id,Pricebook2id=pricebooklist[2].Id); 
                      
  //     insert qtList ;    
       
        
       
  //     //insersion of opptylineitem
  //     List<opportunitylineitem > lineitemlist = new opportunitylineitem[3];
  //     lineitemlist[0] = new opportunitylineitem(opportunityid=oppList[0].id,PricebookEntryId = PricebookEntrylist[0].id,quantity=5, TotalPrice=1);
  //     lineitemlist[1] = new opportunitylineitem(opportunityid=oppList[1].id,PricebookEntryId = PricebookEntrylist[1].id,quantity=5, TotalPrice=1);       
  //     lineitemlist[2] = new opportunitylineitem(opportunityid=oppList[2].id,PricebookEntryId = PricebookEntrylist[2].id,quantity=5, TotalPrice=1);       
  //     insert lineitemlist ;
       
  //     List<quotelineitem> qtlineitemlist = new quotelineitem[2];       
       
  //     qtlineitemlist[0]  = new quotelineitem(quoteId=qtList[0].id,PricebookEntryId = PricebookEntrylist[1].id,quantity=5,UnitPrice=44);
  //     qtlineitemlist[1]  = new quotelineitem(quoteId=qtList[1].id,PricebookEntryId = PricebookEntrylist[2].id,quantity=5,UnitPrice=44);       
  //     insert qtlineitemlist ;       
       
  //     PageReference pageRef = page.DiscountProductsConfigurator;       
           
  //     system.Test.setCurrentPage(pageRef);
  //     System.currentPageReference().getParameters().put('id',oppList[0].id);  
           
  //     DiscountProductsConfiguratorController contr1 = new DiscountProductsConfiguratorController();

  //     pagereference pf1 = contr1.save();
  //    pagereference pf2 = contr1.cancel();
    
  //    Prod.recordtypeid = rec1.id;
  //    update Prod;
  //   System.currentPageReference().getParameters().put('id',oppList[0].id);  
           
  //     DiscountProductsConfiguratorController contr11 = new DiscountProductsConfiguratorController();
        
  //    oppList[0].accountid =accList[0].id;
  //update oppList[0];
  //     System.currentPageReference().getParameters().put('id',oppList[0].id);  
           
  //     DiscountProductsConfiguratorController contr111 = new DiscountProductsConfiguratorController();
    
     
    
       
  //      System.currentPageReference().getParameters().put('id',oppList[1].id);       
       
  //     DiscountProductsConfiguratorController contr1b = new DiscountProductsConfiguratorController();

  //     pagereference pf1b = contr1b.save();
  //     pagereference pf2b = contr1b.cancel();       
     
  //     System.currentPageReference().getParameters().put('id',qtList[0].id);       
  //     DiscountProductsConfiguratorController contr2 = new DiscountProductsConfiguratorController();
  //     pagereference pf3 = contr2.save();
  //     pagereference pf4 = contr2.cancel();            
       
      
  //     System.currentPageReference().getParameters().put('id',qtList[1].id);       
  //     DiscountProductsConfiguratorController contr3 = new DiscountProductsConfiguratorController();
  //     pagereference pf5 = contr3.save();
  //     pagereference pf6 = contr3.cancel(); 
  //     contr3.getdiscounts(); 
  //     string str1 = contr3.title;      
  //     string str2 = contr3.subtitle ;
     
     
     
  //      System.currentPageReference().getParameters().put('id',oppList[3].id);  
           
  //     DiscountProductsConfiguratorController contr1g = new DiscountProductsConfiguratorController();
  //      pagereference prg1 = contr1g.save();
  //     pagereference prg2 = contr1g.cancel(); 
       

  //  }
   
}