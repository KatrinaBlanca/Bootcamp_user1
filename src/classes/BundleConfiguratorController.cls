public class BundleConfiguratorController /*implements ConnectionSearchListener*/ {

   // public account Acc{get;set;}
   // public opportunity opportunity{get;set;}
   // public Map<Id, OpportunityLineItem> connectionIdToOpportunityLineItemMap {get; set;}
   // public  Map<Id, QuoteLineItem> connectionIdToQuoteLineItemMap {get; set;}  
   // public list<connection__C> selectedConnections{get;set;} 
   // public list<SelectOption> listProduct{get;set;}
   // public map<id,opportunityLineItem> bundlelineitems{get;set;}
   // public integer myMapSize {get;set;} 
   // public  id Selbundle{get;set;}
   // public map<id,product2> productidtoproductmap{set;get;}
   // public map<id,integer> eavmap{get;set;}
   // public  Boolean Electricity;
   // public Boolean Gas;
   // public map<string,connection__C> utilitytypeMap{get;set;}
 
   // public map<id,string> productconnectionMap{get;set;}
   // public map<id,boolean> producttobooleanMap{get;set;}
   // public boolean displayPopup {get; set;}
   // public decimal totaleleceav;
   // public decimal totalgaseav;
   // public decimal totalelec;
   // public decimal totalgas;
   // public map<string,List<selectoption>> labeltovaluemap{get;set;}
   // public map<string,string> labeltoanswermap{get;set;}    
   // public map<id,string> productName {get;set;}
   //public Map<OpportunityLineItem, List<CommercialProductUnitPriceCalculator.Line>> opplinemap{get;set;}
   //public map<string,string> productToPriceMap{get;set;}
    public bundleconfiguratorcontroller()
    {
      //Id objectId = Id.valueOf(ApexPages.currentPage().getParameters().get('Id'));
      //myMapSize = 0;
      //displayPopup = false;
      //labeltovaluemap = new map<string,List<selectoption>>();
      //labeltoanswermap = new map<string,string>();
      //connectionIdToOpportunityLineItemMap=new map<id,opportunitylineItem>();
      //connectionIdToQuoteLineItemMap =new map<id,quoteLineItem>();
      //selectedConnections=new list<connection__c>();
      //listProduct=new list<SelectOption>();
      //bundlelineitems=new  map<id,opportunityLineItem> ();
      //productidtoproductmap=new map<id,product2>();
      //eavmap=new map<id,integer>();
      //Electricity=false;
      //Gas=false;
      //utilitytypeMap=new map<string,connection__C>();
     
      // productconnectionMap=new map<id,string>();
      // producttobooleanMap=new map<id,boolean>();
      // productName =new map<id,string>();
      // opplinemap=new Map<OpportunityLineItem, List<CommercialProductUnitPriceCalculator.Line>>();
      // productToPriceMap=new map<string,string> ();     
      //if (Util.isOpportunityId(objectId))
      //  {
      //      opportunity = [
      //          select Id, Name, accountId
      //          from Opportunity
      //          where Id = :objectId
      //          limit 1
      //      ][0];
      //      Acc=[select id,BillingCity,BillingStreet,BillingPostalcode from account where id = :opportunity.accountid limit 1][0] ;
      //  }
          }
   //  public void newConnectionSelected(Connection__c connection) {
   //    selectedConnections.add(connection);
   //    selectedBundles();

   //    system.debug('selectedConnections   '+selectedConnections);
   //     }
   // public list<SelectOption> selectedBundles()
   // {
       
   //   list<product2> bundleprods=new list<product2>();
   //   listproduct.clear();
   //    for(connection__C conn:SelectedConnections)
   //    {
   //      if(conn.Utility_type__c=='Electricity')
   //      Electricity=true;
   //      if(conn.Utility_type__c=='Gas')
   //      Gas=true;
   //      utilitytypeMap.put(conn.Utility_type__c,conn);
   //    }
       
   //            if(!Electricity&&gas)
   //            {
   //                   for(product2 prod:[select id,name,description from product2 where 
   //                                           recordtypeid=:label.BUNDLE_RECORDTYPE and isactive=true and Electiricity_Bundle__c=false and Gas_Bundle__c=true])
   //                   {
   //                      listproduct.add(new SelectOption(prod.Id, prod.Name ));
   //                   }
   //           }
   //           else if(Electricity&&!gas)
   //            {
   //                   for(product2 prod:[select id,name,description from product2 where 
   //                                           recordtypeid=:label.BUNDLE_RECORDTYPE and isactive=true and Electiricity_Bundle__c=true and Gas_Bundle__c=false])
   //                   {
   //                      listproduct.add(new SelectOption(prod.Id, prod.Name ));
   //                   }
   //           }
   //           else if(Electricity&&gas)
   //            {
   //                   for(product2 prod:[select id,name,description from product2 where 
   //                                           recordtypeid=:label.BUNDLE_RECORDTYPE and isactive=true and Electiricity_Bundle__c=true and Gas_Bundle__c=true])
   //                   {
   //                      listproduct.add(new SelectOption(prod.Id, prod.Name ));
   //                   }
   //           }
       
   //    return listProduct;
   // }
   //  public Product2 getProductDetail() {
        
   //     return [
   //         select Id, Name, Description, Contract_Duration_Years__c,Product_Rating__c,
   //         Fee_Type__c,Start_Date__c,End_Date__c,Brand__c,Brand_s_Logo__c from product2 where id=:selbundle];                           
   // }
   // public void bundleProducts()
   // {
   // System.debug('in bundle prods');
   // myMapSize = myMapSize+1;    
   // bundlelineitems.clear();
   // productToPriceMap.clear();
   //   list<id> bundproducts=new list<id>();
   //    for(Bundle_Line_Item__c bli:[select id , product__C,product__r.Master_Product_Type__c,bundle__C,Product__r.name,EAV__c
   //                                 from Bundle_Line_Item__c where bundle__C=:Selbundle])
   //    {
   //        bundproducts.add(bli.product__C);
   //    } 
   //    map<id,pricebookentry> prodtoPricebookentryMap=new map<id,pricebookentry>();
   //    for(pricebookentry pbe:[select id,product2id,product2.name from pricebookentry where isactive=true and Pricebook2.IsStandard = true and product2id in :bundproducts])
   //    {
   //                productName.put(pbe.id,pbe.product2.name);
   //                prodtoPricebookentryMap.put(pbe.product2id,pbe);
   //    }
   //    for(product2 pr:[select id,name,Master_Product_Type__c  from product2 where id in :bundproducts and  Master_Product_Type__c!='non-commodity'])
   //    {
   //            opportunityLineItem oli=new OpportunityLineItem();
   //            oli.opportunityid=opportunity.id;
   //            if(utilitytypeMap.get(pr.Master_Product_Type__c)!=null) 
   //            {                     
   //            oli.Connection__c=utilitytypeMap.get(pr.Master_Product_Type__c).id;
   //            productconnectionMap.put(pr.id,utilitytypeMap.get(pr.Master_Product_Type__c).name);
   //            }
   //            else
   //            {
   //            productconnectionMap.put(pr.id,pr.Master_Product_Type__c);
   //            }
   //            oli.pricebookentryid=prodtoPricebookentryMap.get(pr.id).id; 
   //            oli.quantity=1;              
   //            bundlelineitems.put(pr.id,oli);
   //            myMapSize = bundlelineitems.size();
   //            system.debug('#############################################bundlelineitems    '+bundlelineitems);
   //            productidtoproductmap.put(pr.id,pr);
   //            eavmap.put(pr.id,0);
   //            producttobooleanMap.put(pr.id,false);
               
   //    } 
   //    for(product2 pr:[select id,name,Master_Product_Type__c  from product2 where id in :bundproducts and  Master_Product_Type__c='non-commodity'])
   //    {
   //            opportunityLineItem oli=new OpportunityLineItem();
   //            oli.opportunityid=opportunity.id;
   //            if(utilitytypeMap.get(pr.Master_Product_Type__c)!=null) 
   //            {                     
   //            oli.Connection__c=utilitytypeMap.get(pr.Master_Product_Type__c).id;
   //            productconnectionMap.put(pr.id,utilitytypeMap.get(pr.Master_Product_Type__c).name);
   //            oli.quantity=1; 
   //            }
   //            else
   //            {
   //            productconnectionMap.put(pr.id,pr.Master_Product_Type__c);
   //            }
   //            oli.pricebookentryid=prodtoPricebookentryMap.get(pr.id).id; 
                            
   //            bundlelineitems.put(pr.id,oli);
   //            myMapSize = bundlelineitems.size();
   //            system.debug('************************************ bundlelineitems    '+bundlelineitems);
   //            productidtoproductmap.put(pr.id,pr);
   //            eavmap.put(pr.id,0);
               
   //            producttobooleanMap.put(pr.id,true);
   //       }     
   //    CommercialProductUnitPriceCalculator  cpup=new CommercialProductUnitPriceCalculator ();
     
   //    opplinemap=cpup.calculateUnitPrices(bundlelineitems.values());
   //    system.debug('*********************opplinemap'+opplinemap);
   //    decimal total;
   //    for(opportunitylineitem oppline:opplinemap.keyset())
   //    {
   //      total=((total==null)?0:total)+oppline.unitprice;
   //      productToPriceMap.put(productName.get(oppline.pricebookentryid),'€ '+(oppline.unitprice).toPlainstring());
   //    }
   //    productToPriceMap.put('Total','€ '+((total==null)?0:total));
      
   // }
   // public BundleConfiguratorController getThis() {
   //     return this;
   // }    
   // public pagereference save()
   // {
     
   //  opportunity.bundle__C=Selbundle;
   //  update opportunity;
     
   //    if(bundlelineitems.size()>0)
   //   insert  bundlelineitems.values();
   //  return new ApexPages.StandardController(opportunity).view();
   // }
   // public pagereference cancel()
   // {
   // return new ApexPages.StandardController(opportunity).view();
   // }
    
   // public void showPopup() 
   // {        
   //     displayPopup = true;
   //     system.debug('showpopup---');
   //     List<SelectOption> options = new List<SelectOption>();
   //     //List<String> picklistoptions = new List<String>();
   //     //picklistoptions.addAll(eavest.keySet());
   //     labeltovaluemap.clear();
   //     //system.debug('Utilitytype:' +conutilitytype);
   //     //Connection__c con = [select Id,Utility_Type__c from Connection__c where id =:conutilitytype];
   //     for(EAVEstimatorRule__c customsetting :[select name,Type__c,Electricity_Units__c,Gas_Units__c,Value__c from EAVEstimatorRule__c order by Sorting_Order__c ASC])
   //     {
   //         if(!labeltovaluemap.containskey(customsetting.Type__c))
   //         {
   //             list<selectoption> ls=new list<selectoption>();
   //             ls.add(new SelectOption(customsetting.name,customsetting.Value__c));
   //             labeltovaluemap.put(customsetting.Type__c,ls);                
   //             labeltoanswermap.put(customsetting.Type__c,customsetting.name);
                                       
   //         } 
   //         else
   //         {
   //             labeltovaluemap.get(customsetting.Type__c).add((new SelectOption(customsetting.name,customsetting.Value__c)));  
   //         }   
   //     }
   //}
   //public void calculateeav()
   //{
   //    System.debug('in generate eav');
   //    totalelec = 0;
   //    totalgas = 0;
   //    EAVEstimatorDefaults__c defvalue = EAVEstimatorDefaults__c.getOrgDefaults();
   //    totaleleceav = defvalue.Electricity_Default_Units__c;
   //    totalgaseav = defvalue.Gas_Default_Units__c;
   //    map<string,EAVEstimatorRule__c> eavest = EAVEstimatorRule__c.getall();    
       
   //    for(string str: labeltoanswermap.values())
   //    {    
   //        System.debug('str'+str);
   //        if(str.contains('Select'))
   //        {    
   //            totalelec = totalelec+0;
   //            totalgas = totalgas+0;
   //        }
   //        else
   //        {        
   //            EAVEstimatorRule__c var = eavest.get(str);
   //            system.debug('ElecEstimate:' +var.Electricity_Units__c);
   //            totalelec = totalelec+var.Electricity_Units__c;
   //            totalgas = totalgas+var.Gas_Units__c;
   //        }    
   //    } 
   //    for(opportunitylineitem oli:bundlelineitems.values())
   //    {
   //        connectionIdToOpportunityLineItemMap.put(oli.connection__c,oli);
   //    }        
        
   //    for(Connection__c conn :selectedConnections)
   //    {    System.debug('in for');
   //    System.debug('----'+conn.utility_type__c);
   //    System.debug('totalgas'+totalgas);
   //        if(conn.utility_type__c == 'Electricity' && totalelec != 0)
   //        {
   //            connectionIdToOpportunityLineItemMap.get(conn.Id).EAV__c =totalelec + totaleleceav;
   //            System.debug('------'+bundlelineitems.get(conn.Id).EAV__c);
   //        }
   //        if(conn.utility_type__c == 'Gas' && totalgas != 0)
   //        {
   //            connectionIdToOpportunityLineItemMap.get(conn.Id).EAV__c = totalgas + totalgaseav;
   //            System.debug('------'+bundlelineitems.get(conn.Id).EAV__c);
   //        }
   //    }        
           
   //    displayPopup = false;
       
   //    closePopup();
                                                                       
   //}
   // public void clearmap(){}
   // public void closePopup()
   // {
   //     displayPopup = false;
   // }
    
   // public pagereference NewCon()
   // {
   //     PageReference openvfpage = page.NewConnectionPage;
   //     openvfpage.getParameters().put('Ptype', 'Bundle');
   //     openvfpage.getParameters().put('OppId',opportunity.Id);
   //     openvfpage.setRedirect(false);
   //     return openvfpage;
   // }    
}