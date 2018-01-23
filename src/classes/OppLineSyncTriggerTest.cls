/**  
* @author       : Accenture IDC  
* @date         : 20/07/2015  
* @description  : Class is for Opportunity Trigger
*/ 
@istest
public class OppLineSyncTriggerTest
{
     //private static final String ADMIN_PROFILE = 'System Administrator';
     
     //public static testMethod void OppSyncTriggerTestController()
     // {  
     //  Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
     // User contextUser = TestDataFactoryTest.createUser('Dev',prof.id,null); 
     //  system.runas(contextUser)
     //    {
     //        list<opportunity> Opportunities =new list<opportunity>();
     //        Account Acc=TestDataFactoryTest.createAccount('test Account');
     //         //pricebook2 BundlePricebook=TestDataFactoryTest.createPricebook('testPricebook',true);  
     //       // product2 Bundleprod=TestDataFactoryTest.createBundleProduct(' test bundle ',BundlePricebook.id);  
     //                       RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];

     //          Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
     //  Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
       
     //          Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
     //            Prod.isactive = true;
     //            update Prod;
              
       
     //         //Get the Standard PriceBook and make sure it is active
     //   List<Pricebook2> pricebooklist = new Pricebook2[1];
     //   pricebooklist[0] = new Pricebook2(Name = 'Standard Price Book');
     //      insert pricebooklist;  
     //     pricebooklist[0].isactive = true;
     //     update pricebooklist[0]; 
     //        //Create your pricebook entry
     //   List<PricebookEntry> PricebookEntrylist = new PricebookEntry[1];       
     //   PricebookEntrylist[0] = new PricebookEntry(Pricebook2Id = pricebooklist[0].Id,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true);       
     //        insert PricebookEntrylist;
     //       Opportunity opp1 = new opportunity(name='test Opp',StageName='Prospecting',CloseDate=System.Today(),AccountId=acc.id);
     //      insert opp1; 
             
     //          Quote q2 = new Quote(name ='test',opportunityid = opp1.id,Pricebook2id=pricebooklist[0].Id);
     //         insert q2;  
     //   List<quotelineitem> qtlineitemlist = new quotelineitem[1];       
       
     //  qtlineitemlist[0]  = new quotelineitem(quoteId=q2.id,PricebookEntryId = PricebookEntrylist[0].id,quantity=5,UnitPrice=2,Discount =2);
     //    insert qtlineitemlist ;  
             
             
           
     //       // opportunity opp1=TestDataFactoryTest.createOpportunity(acc.id,'test opportunity ',system.today(),'close Won ',BundlePricebook.id,Bundleprod.id);
     //       Quote q = new Quote(name ='test',opportunityid = opp1.id,Pricebook2id=pricebooklist[0].Id);
     //         insert q;   
     //         update q;
     //            QuoteSyncUtil.isRunningTest = True;
              
     //         opportunitylineitem  lineitemlist= new opportunitylineitem(opportunityid=opp1.id,PricebookEntryId = PricebookEntrylist[0].id,quantity=5,UnitPrice=2,Discount =2);
     //  insert lineitemlist ;
       
      
     //       // Opportunities.add(opp1);
     //       opp1.SyncedQuoteId = q2.id;
     //         update opp1;    
     
             
             
     //  opp1.SyncedQuoteId = q.id;
     //         update opp1;  
      
     //        opp1.SyncedQuoteId = q2.id;
     //         update opp1;    
     //         QuoteSyncUtil.isRunningTest = True;
     //         opportunitylineitem  newoppline = [select id from opportunitylineitem limit 1];
       
     //        update newoppline ;
           
              
     //    }
     // }
}