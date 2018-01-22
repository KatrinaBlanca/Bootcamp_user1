/**  
* @author       : Accenture IDC  
* @date         : 20/07/2015  
* @description  : Class is for Opportunity Trigger
*/ 
@istest(seealldata=true)
public class OpportunityTriggerClassTest
{
     private static final String ADMIN_PROFILE = 'System Administrator';
     
     public static testMethod void ProductLineItemTestController()
      {  
       Profile prof = [select id from profile where Name =: ADMIN_PROFILE LIMIT 1];
      User contextUser = TestDataFactoryTest.createUser('Dev',prof.id,null); 
       system.runas(contextUser)
         {
             list<opportunity> Opportunities =new list<opportunity>();
             Account Acc=TestDataFactoryTest.createAccount('test Account');
              pricebook2 BundlePricebook=TestDataFactoryTest.createPricebook('testPricebook',true);  
             product2 Bundleprod=TestDataFactoryTest.createBundleProduct(' test bundle ',BundlePricebook.id);  
                       
             opportunity opp1=TestDataFactoryTest.createOpportunity(acc.id,'test opportunity ',system.today(),'close Won ',BundlePricebook.id,Bundleprod.id);
             Opportunities.add(opp1);
             
             System.test.startTest();
             {
                 list<opportunityLineItem> ExpectedOppLineItems=OpportunityTriggerClass.insertOppLineItems(Opportunities);
                 
                 system.assertEquals(2,ExpectedOppLineItems.size());  
             }
             System.test.stopTest();
         }
      }
}