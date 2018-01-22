/**  
* @author       : Accenture IDC  
* @date         : 20/07/2015  
* @description  : This class is for DEMO_OpportunityTrigger which creates opportunitylineItems for opportunity with bundle  
*/ 

public class OpportunityTriggerClass
{
     /**
      * @description        This method is invoked by DEMO_OpportunityTrigger which will create opportunityLineItems for bundle opportunity 
      * @param              Null
      * @return             OpportunityLineItem
      * @throws             NA
      */
  public static list<OpportunityLineItem> insertOppLineItems(list<opportunity> opps)
  {
   
    list<id> ProductIds=new list<id>();
    list<id> bundleIds=new list<id>();
    map<id,list<id>> BundleProductMap=new  map<id,list<id>> ();
    map<id,id> ProductPricebookentryid=new map<id,id>();
    list<opportunityLIneItem> OppLineItems=new list<OpportunityLineItem>();
    pricebook2 StandardPricebookId=[select id from pricebook2 where isstandard=true];
    map<id,id> OpptyPricebookidMap=new map<id,id>();
    for(opportunity opp:[select id,Bundle__C,pricebook2id from opportunity where id in :opps])
    {
       OpptyPricebookidMap.put(opp.bundle__C,opp.pricebook2id);     
    }
     for(Bundle_Line_Item__c  BundleProduct:[select Product__c,Bundle__c  from Bundle_Line_Item__c where Bundle__c in :OpptyPricebookidMap.keyset()])
     {
           ProductIds.add(bundleProduct.product__C);
           if(BundleProductMap.containsKey(BundleProduct.Bundle__c))
           {
                list<id> prodlist=BundleProductMap.get(BundleProduct.Bundle__c);
                prodlist.add(BundleProduct.product__C);
                BundleProductMap.put(BundleProduct.Bundle__C,prodlist);
           }
           else
           {
                 list<id> prodlist=new list<id>();
                 prodlist.add(BundleProduct.product__C);
                 BundleProductMap.put(BundleProduct.Bundle__C,prodlist);
           }
     }
     system.debug('bundle map size  '+BundleProductMap);
     for(PricebookEntry pricebookEntry :[select Id,Product2Id  from PricebookEntry where Product2Id in :ProductIds and pricebook2id in :OpptyPricebookidMap.values()])
      {
                   ProductPricebookentryid.put(PricebookEntry.Product2Id ,pricebookentry.id);
      }

           for(opportunity oppty:[select id,Bundle__C from opportunity where id in :opps])
        {
              for(id Productid:BundleProductMap.get(oppty.Bundle__C))
                   {
                        OpportunityLineItem oli = new OpportunityLineItem();
                          oli.OpportunityId = oppty.Id;
                          oli.PricebookEntryId = ProductPricebookentryid.get(productid);
                          oli.Quantity = 1;
                          oli.UnitPrice = 0;
                          OppLineItems.add(oli);
                   }   
         }
         
                if(!opplineItems.isempty())
                insert OppLineItems;  
                
        return OppLineItems;
   }
 }