public class CommodityProductsConfiguratorController /*implements ConnectionSearchListener*/ {
    //public account acc {get;set;}
    //public string picklist{get;set;}
    //public boolean displayPopup {get; set;}
    //public boolean fromComp;
    //public decimal totaleleceav;
    //public decimal totalgaseav;
    //public decimal totalelec;
    //public decimal totalgas;
    //public boolean showError {get;set;}
    //public integer productsize {get;set;}
    //public map<string,string> labeltoanswermap{get;set;}
    //public string Feetype{get;set;}
    // public string conutilitytype{
    //     get;
    //     set
    //     {
    //         conutilitytype = value;
    //     }
    // }            
    // public map<string,List<selectoption>> labeltovaluemap{get;set;}
    //private static final ID COMMERCIAL_PRODUCT_RECORD_TYPE_ID = [
    //    Select Id 
    //    From RecordType 
    //    Where sObjectType = 'Product2'
    //    and DeveloperName = 'Commercial_Product'
    //    limit 1
    //][0].Id; 
    
    public CommodityProductsConfiguratorController() {
        //if(ApexPages.currentPage() != null && ApexPages.currentPage().getParameters().get('id') != null)
        //{
        //    Id objectId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
        //    initilize(objectId );
        //}
    }
    
   // public void initilize(id objectId )
   // {
   //    //Id objectId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
   //     displayPopup =false;
   //    fromComp=false;
   //     productsize = 0;
   //    labeltovaluemap = new map<string,List<selectoption>>();
   //     connectionIdTofilterMap = new Map<id, String>();
   //     connectionIdTofilterFeeMap =new Map<id, String>();
   //     connectionIdTofilterBrandMap= new Map<id, String>();
   //     connectionIdToProductIdMap = new Map<String, String>();
   //     connectionIdToProductSelectOptionsMap = new Map<Id, List<SelectOption>>();
   //     //connectionIdToProddescMap = new Map<String, String>();
   //     //connectionIdToProductdescselectionmap = new Map<Id, List<selectoption>>();
   //     connectionIdToConnectionMap = new Map<Id, Connection__c>();
   //     connectionIdToOpportunityLineItemMap = new Map<Id, OpportunityLineItem>();
   //     connectionIdToQuoteLineItemMap=new map<id,QuoteLineItem>();
   //     productIdToB2BProductMap = new Map<Id, Boolean>();
   //     prodtoproddescmap = new Map<string,string>();
   //     labeltoanswermap = new map<string,string>();
       
   //     if (Util.isOpportunityId(objectId)) {
   //         opportunity = [
   //             select id,Name, accountId
   //             from Opportunity
   //             where Id = :objectId
   //             limit 1
   //         ][0];
            
   //         // Query the already existing commodity opportunity line items
   //         // for this opportunity.
   //         list<OpportunityLineItem> opportunityLineItems = [
   //             select Connection__c, Product2Id, Yearly_Usage_per_Connection_kWh__c, Volume_Peak__c,Volume_Off_Peak__c,Maximum_Usage__c,Maximum_Volume__c,
   //                    Usage_Total_Hour__c,Usage_Day__c,Usage_Night__c,Variable_Bandwidth_Electricity__c,Margin_Electrcity__c,Fine_Electricity__c,Yearly_Usage_per_Connection_m3__c,Maximum_Usage_m3__c,
   //                    Maximum_Volume_m3__c,Variable_Bandwidth_Gas__c,Margin_Gas__c, Fine_Gas__c, EAV__c 
   //             from OpportunityLineItem
   //             where OpportunityId = :opportunity.Id
   //             and Connection__c != null
   //         ];
            
   //         // Query the related connections and put them in a map
   //         List<Id> connectionIds = new List<Id>();
   //         for (OpportunityLineItem oli: opportunityLineItems) {
   //             connectionIds.add(oli.Connection__c);
   //         }
   //         Map<Id, Connection__c> connectionIdToConnectionMap = new Map<Id, Connection__c>(
   //             [
   //                 select Utility_Type__c, Name
   //                 from Connection__c
   //                 where Id in :connectionIds
   //             ]
   //         );
            
   //         // For the opportunity line items already existing, make sure that the connection boxes
   //         // appear and that the right product is selected.
   //         for (OpportunityLineItem oli: opportunityLineItems) {
   //             productsize = productsize+1;
   //             connectionIdTofilterMap.put(oli.Connection__c, 'all');
   //             connectionIdTofilterFeeMap.put(oli.Connection__c, 'all');
   //             connectionIdTofilterBrandMap.put(oli.Connection__c, 'all');
   //             newConnectionSelected(connectionIdToConnectionMap.get(oli.Connection__c));
   //             connectionIdToProductIdMap.put(oli.Connection__c, oli.Product2Id);
   //             connectionIdToOpportunityLineItemMap.put(oli.Connection__c, oli);
   //          system.debug('connectionIdToOpportunityLineItemMap   '+  connectionIdToOpportunityLineItemMap.put(oli.Connection__c, oli));
   //         }
   //         for(id connec:connectionIdToProductIdMap.keyset())
   //         {
   //          if(!connectionIdToOpportunityLineItemMap.containskey(connec))
   //          {
   //            opportunityLineItem oplineitem=new opportunityLineItem();
   //            connectionIdToOpportunityLineItemMap.put(connec,oplineitem);
   //            }
   //         }
            
   //         acc = [select BillingCity,BillingPostalCode,BillingStreet from Account where id = :opportunity.AccountId];
            
   //     } else if (Util.isQuoteId(objectId)) {
   //        // TODO: add inQuoteMode functionality 
   //         quote=[select Name, AccountId
   //             from Quote
   //             where Id = :objectId
   //             limit 1
   //         ][0];
           
   //         // Query the already existing commodity opportunity line items
   //         // for this opportunity. 
   //         List<QuoteLineItem> QuoteLineItems = [
   //             select Connection__c, Product2Id,EAV__c 
   //             from QuoteLineItem
   //             where Quoteid= :quote.Id
   //             and Connection__c != null
   //         ];
            
   //         // Query the related connections and put them in a map
   //         List<Id> connectionIds = new List<Id>();
   //         for (QuoteLineItem oli: QuoteLineItems) {
   //             connectionIds.add(oli.Connection__c);
   //         }
   //         Map<Id, Connection__c> connectionIdToConnectionMap = new Map<Id, Connection__c>(
   //             [
   //                 select Utility_Type__c, Name
   //                 from Connection__c
   //                 where Id in :connectionIds
   //             ]
   //         ); 
            
   //            for (QuoteLineItem Qli: QuoteLineItems) {
   //             productsize = productsize+1;     
   //             connectionIdTofilterMap.put(Qli.Connection__c, 'all');
   //             connectionIdTofilterFeeMap.put(Qli.Connection__c, 'all');
   //             connectionIdTofilterBrandMap.put(Qli.Connection__c, 'all');
   //             newConnectionSelected(connectionIdToConnectionMap.get(Qli.Connection__c));
   //             connectionIdToProductIdMap.put(Qli.Connection__c, Qli.Product2Id);
               
   //             connectionIdToQuoteLineItemMap.put(Qli.Connection__c, Qli);
   //         }
   //          for(id connec:connectionIdToProductIdMap.keyset())
   //         {
   //          if(!connectionIdToQuoteLineItemMap.containskey(connec))
   //          {
   //            QuoteLineItem Quotelineitem=new QuoteLineItem();
   //            connectionIdToQuoteLineItemMap.put(connec,Quotelineitem);
   //            }
   //         }
   //         acc = [select BillingCity,BillingPostalCode,BillingStreet from Account where id = :quote.AccountId];
           
   //     }
   //     system.debug('connectionIdToQuoteLineItemMap    '+connectionIdToQuoteLineItemMap);
   //     system.debug('connectionIdToProductIdMap         '+connectionIdToProductIdMap);
   //      system.debug('connectionIdToQuoteLineItemMap    '+connectionIdToQuoteLineItemMap);   
   // }         
    
   // public Opportunity opportunity {get; set;}
   // public Quote quote {get; set;}
    
   // public Map<String, Id> connectionIdToProductIdMap {get; set;} 
   // public Map<Id, List<SelectOption>> connectionIdToProductSelectOptionsMap {get; set;}
   // //public Map<string,string> connectionIdToProddescmap {get; set;}
   // //public Map<Id, List<selectoption>> connectionIdToProductdescselectionmap {get;set;}
   // public Map<Id, Connection__c> connectionIdToConnectionMap {get; set;}
   // public Map<Id, OpportunityLineItem> connectionIdToOpportunityLineItemMap {get; set;}
   // public  Map<Id, QuoteLineItem> connectionIdToQuoteLineItemMap {get; set;}   
   // public Map<id, string> connectionIdTofilterMap {get; set;} 
   // public Map<id, string> connectionIdTofilterFeeMap {get; set;}
   // public Map<id, string> connectionIdTofilterBrandMap {get; set;}
   // public Map<Id, Boolean> productIdToB2BProductMap {get; set;}
   // public Map<string,string> prodtoproddescmap {get;set;}
    
   // public Boolean inOpportunityMode() {
   //     return opportunity != null;
   // }
    
   // public Boolean inQuoteMode() {
   //     return quote != null;
   // }
    
   // public String title {
   //     get {
   //         // TODO: Move Strings to custom labels
   //         return (inOpportunityMode() ? 'Opportunity' : 'Quote') + ' - Configure Commodity Products';
   //     }
   // }
    
   // public String subtitle {
   //     get {
   //         return inOpportunityMode() ? opportunity.Name : quote.Name;
   //     }
   // }
    
   // public List<SelectOption> getCommercialProductOptionsForConnection(Connection__c connection) {
   //     return new List<SelectOption>();
   // }
   
    
   // public void newConnectionSelected(Connection__c connection) {
   //     try{
   //     connectionIdToConnectionMap.put(connection.Id, connection);
   //     List<SelectOption> selectOptions = getProductSelectOptionsForConnection(connection);
   //     //List<selectOption> selectoptions1 = getProductSelectOptionsForConnection1(connection); 
       
   //     connectionIdToProductSelectOptionsMap.put(connection.Id, selectOptions);
   //     //connectionIdToProdDescMap.put(Connection.Id, selectoptions1);
   //     if (inOpportunityMode())
   //     {
   //         if(!connectionIdToOpportunityLineItemMap.containskey(connection.id))
   //               {
   //                 OpportunityLineItem oli = new OpportunityLineItem();
   //                 oli.OpportunityId = opportunity.Id;
   //                 oli.connection__C=connection.id;
   //                 connectionIdToOpportunityLineItemMap.put(connection.id,oli);
   //                 system.debug('connectionIdToOpportunityLineItemMap   ' +connectionIdToOpportunityLineItemMap.put(connection.id,oli));
   //               }
   //       }  
   //        if (inQuoteMode()) 
   //        {
   //         if(!connectionIdToQuoteLineItemMap.containskey(connection.id))
   //               {
   //                 QuoteLineItem Qli = new QuoteLineItem();
   //                 Qli.Quoteid= Quote.Id;
   //                 Qli.connection__C=connection.id;
   //                 connectionIdToQuoteLineItemMap.put(connection.id,Qli);
                    
   //               }
   //        }  
   //     // Automatically select the first option
   //    // connectionIdToProductIdMap.clear();
      
   //      system.debug('size===='+connectionIdToProductIdMap.size());
   //     connectionIdToProductIdMap.put(connection.Id, selectOptions[0].getValue());
       
   //     System.debug('connectionIdToProductIdMap'+connectionIdToProductIdMap);
   //     productsize = productsize+1;
   //     if(!connectionIdTofilterMap.containskey(connection.id))
   //     connectionIdTofilterMap.put(connection.Id,'all');        
   //     if(!connectionIdTofilterfeeMap.containskey(connection.id))
   //    connectionIdTofilterFeeMap.put(connection.Id,'all');
   //     if(!connectionIdTofilterBrandMap.containskey(connection.id))
   //    connectionIdTofilterBrandMap.put(connection.Id,'all');  
   //    }
   //    catch(exception e)
   //    {
   //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'There are no Products available for this filter'));

   //    }
   // }
    
   //  public void connectionDeselected(Connection__c connection)
   // {
   //   map<id,connection__c> Uncheckedconnections=new map<id,connection__c>();
   //   Uncheckedconnections.put(connection.id,connection);
   //  Map<String, Id> connectionIdToProductIdMapnew=new Map<String, Id>(); 
   //   for(string conn:connectionIdToProductIdMap.keyset())
   //   {
   //      if(!Uncheckedconnections.containskey(conn))
   //      {
   //        connectionIdToProductIdMapnew.put(conn,connectionIdToProductIdMap.get(conn));
   //      }    
   //   }
   //   connectionIdToProductIdMap.clear();
   //   connectionIdToProductIdMap=connectionIdToProductIdMapnew.clone();
   // }
   // private List<SelectOption> getProductSelectOptionsForConnection(Connection__c connection) {
   //     List<SelectOption> selectOptions = new List<SelectOption>();
   //     //List<selectOption> selectoptions1 = new List<selectoption>();
   //      System.debug('fromComp'+fromComp);
       
   //      if(fromComp){
   //     system.debug('in fromcomp');
   //         connectionIdToProductIdMap.clear();
   //         fromComp=false;
   //     }
   //     if(connectionIdTofilterMap.get(connection.id)!=null&&connectionIdTofilterMap.get(connection.id)!='all'&&((connectionIdTofilterfeeMap.get(connection.id)==null)||connectionIdTofilterfeeMap.get(connection.id)=='all')&&(connectionIdTofilterBrandMap.get(connection.id)!=null&&connectionIdTofilterBrandMap.get(connection.id)!='all'))

   //     {
   //         for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Score__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and
   //          Contract_Duration_Years__c=:connectionIdTofilterMap.get(connection.id) and Brand__c=:connectionIdTofilterBrandMap.get(connection.id) order by Score__c desc NULLS LAST Limit 3
             
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));  
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description);  
   //         }
   //         system.debug(' testing 1   '+selectOptions);
   //    }
      
   //     else if((connectionIdTofilterMap.get(connection.id)==null||connectionIdTofilterMap.get(connection.id)=='all')&&(connectionIdTofilterfeeMap.get(connection.id)!=null&&connectionIdTofilterfeeMap.get(connection.id)!='all')&&(connectionIdTofilterBrandMap.get(connection.id)!=null&&connectionIdTofilterBrandMap.get(connection.id)!='all'))
   //      {
   //             for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Score__c,Brand__c , Description from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and
   //          Fee_Type__c=:connectionIdTofilterFeeMap.get(connection.id) and Brand__c=:connectionIdTofilterBrandMap.get(connection.id) order by Score__c desc NULLS LAST Limit 3
             
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description); 
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing   2 '+selectOptions);
   //    }
      
   //     else if((connectionIdTofilterMap.get(connection.id)!=null&&connectionIdTofilterMap.get(connection.id)!='all') &&(connectionIdTofilterfeeMap.get(connection.id)!=null&&connectionIdTofilterfeeMap.get(connection.id)!='all')&&(connectionIdTofilterBrandMap.get(connection.id)!=null&&connectionIdTofilterBrandMap.get(connection.id)!='all'))
   //     {
        
   //        system.debug('filter values   '+connectionIdTofilterMap.get(connection.id)+'######################'+connectionIdTofilterfeeMap.get(connection.id));
   //             for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and
   //          Contract_Duration_Years__c=:connectionIdTofilterMap.get(connection.id) and 
   //          Fee_Type__c=:connectionIdTofilterFeeMap.get(connection.id) and Brand__c=:connectionIdTofilterBrandMap.get(connection.id)
   //          order by Score__c desc NULLS LAST Limit 3        
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description); 
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing  3  '+selectOptions);
   //    }
      
   //    else if((connectionIdTofilterMap.get(connection.id)==null||connectionIdTofilterMap.get(connection.id)=='all') &&(connectionIdTofilterfeeMap.get(connection.id)==null||connectionIdTofilterfeeMap.get(connection.id)=='all')&&(connectionIdTofilterBrandMap.get(connection.id)!=null&&connectionIdTofilterBrandMap.get(connection.id)!='all'))
   //     {
   //     for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and Brand__c=:connectionIdTofilterBrandMap.get(connection.id)
   //         order by Score__c desc NULLS LAST Limit 3
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name)); 
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description);  
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing 4   '+selectOptions);
   //    }
   //    else if((connectionIdTofilterMap.get(connection.id)!=null&&connectionIdTofilterMap.get(connection.id)!='all') &&(connectionIdTofilterfeeMap.get(connection.id)!=null&&connectionIdTofilterfeeMap.get(connection.id)!='all')&&((connectionIdTofilterBrandMap.get(connection.id)==null) || (connectionIdTofilterBrandMap.get(connection.id)=='all')))
   //     {
        
   //        system.debug('filter values   '+connectionIdTofilterMap.get(connection.id)+'######################'+connectionIdTofilterfeeMap.get(connection.id));
   //             for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and
   //          Contract_Duration_Years__c=:connectionIdTofilterMap.get(connection.id) and 
   //          Fee_Type__c=:connectionIdTofilterFeeMap.get(connection.id)
   //          order by Score__c desc NULLS LAST Limit 3        
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description); 
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing  3  '+selectOptions);
   //    }   
   //     else if((connectionIdTofilterMap.get(connection.id)!=null&&connectionIdTofilterMap.get(connection.id)!='all') &&(connectionIdTofilterfeeMap.get(connection.id)==null || connectionIdTofilterfeeMap.get(connection.id)=='all')&&((connectionIdTofilterBrandMap.get(connection.id)==null) || (connectionIdTofilterBrandMap.get(connection.id)=='all')))
   //     {
        
   //        system.debug('filter values   '+connectionIdTofilterMap.get(connection.id)+'######################'+connectionIdTofilterfeeMap.get(connection.id));
   //             for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and
   //          Contract_Duration_Years__c=:connectionIdTofilterMap.get(connection.id)           
   //          order by Score__c desc NULLS LAST Limit 3       
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description); 
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing  3  '+selectOptions);
   //    }   
   //    else if((connectionIdTofilterMap.get(connection.id)==null || connectionIdTofilterMap.get(connection.id)=='all') &&(connectionIdTofilterfeeMap.get(connection.id)!=null&&connectionIdTofilterfeeMap.get(connection.id)!='all')&&((connectionIdTofilterBrandMap.get(connection.id)==null) || (connectionIdTofilterBrandMap.get(connection.id)=='all')))
   //     {
        
   //        system.debug('filter values   '+connectionIdTofilterMap.get(connection.id)+'######################'+connectionIdTofilterfeeMap.get(connection.id));
   //             for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c and
   //          Fee_Type__c=:connectionIdTofilterFeeMap.get(connection.id)          
   //          order by Score__c desc NULLS LAST Limit 3           
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description); 
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing  3  '+selectOptions);
   //    }
   //     else if((connectionIdTofilterMap.get(connection.id)==null || connectionIdTofilterMap.get(connection.id)=='all') &&(connectionIdTofilterfeeMap.get(connection.id)==null || connectionIdTofilterfeeMap.get(connection.id)=='all')&&((connectionIdTofilterBrandMap.get(connection.id)==null) || (connectionIdTofilterBrandMap.get(connection.id)=='all')))
   //     {
        
   //        system.debug('filter values   '+connectionIdTofilterMap.get(connection.id)+'######################'+connectionIdTofilterfeeMap.get(connection.id));
   //             for (Product2 product : [
   //         select Name, Master_Product__r.B2B_Product__c,Brand__c, Description
   //         from Product2
   //         where IsActive = true 
   //         and RecordTypeId = :COMMERCIAL_PRODUCT_RECORD_TYPE_ID
   //         and Master_Product_Type__c = :connection.Utility_type__c        
   //          order by Score__c desc NULLS LAST Limit 3          
   //     ]) {
   //         selectOptions.add(new SelectOption(product.Id, product.Name));
   //         //selectoptions1.add(new Selectoption(product.Id, product.description));
   //         prodtoproddescmap.put(product.Id,product.Description); 
   //         productIdToB2BProductMap.put(product.Id, product.Master_Product__r.B2B_Product__c);
   //         }
   //         system.debug(' testing123  '+prodtoproddescmap);
   //    }
   //     //connectionIdToProductdescselectionmap.put(connection.Id,selectoptions1);
   //     return selectOptions;
   // }
    
    
    
   // public PageReference save() {
   //     string s;
   //     if (inOpportunityMode()) {
   //        saveInOpportunityMode(); 
           
           
        
   //         s='https://accenture-utilities.my.salesforce.com/console';
            
            
          
         
   //        PageReference pageRef = new PageReference(s);
   //         pageRef.setRedirect(false); 
   //         return pageref;
   //     } 
   //     if (inQuoteMode()) {
   //        return saveInQuoteMode(); 
   //     }
   //     return null;
   // }
   //  public PageReference saveandNoncom() {
   // string s;
   //     if (inOpportunityMode()) {
   //     s='/apex/NonCommodityProductsConfigurator?id='+opportunity.id;
   //        saveInOpportunityMode(); 
   //         } 
   //     if (inQuoteMode()) {
   //             s='/apex/NonCommodityProductsConfigurator?id='+quote.id;
   //       saveInQuoteMode(); 
   //     }
   //      PageReference pageRef = new PageReference(s);
   //         pageRef.setRedirect(false); 
   // return pageRef;
   //        }
           
   //  public PageReference saveanddiscount() {
   // string s;
   //     if (inOpportunityMode()) {
   //     s='/apex/discountproductsconfigurator?id='+opportunity.id;
   //        saveInOpportunityMode(); 
   //         } 
   //     if (inQuoteMode()) {
   //             s='/apex/discountproductsconfigurator?id='+quote.id;
   //       saveInQuoteMode(); 
   //     }
   //      PageReference pageRef = new PageReference(s);
   //         pageRef.setRedirect(false); 
   // return pageRef;
   //        }      
    
    
   // public Pagereference Cancel()
   // {
   //     if (inOpportunityMode())
   //     {
   //     return new PageReference('/' + opportunity.Id);
   //     }
   //     if (inQuoteMode())
   //     {
   //     return new PageReference('/' + Quote.Id);
   //     }
   //     return null;
   // }        
    
   // public void saveInOpportunityMode() {
   //     // TODO: Add error handling 
   //     List<OpportunityLineItem> olisToInsert = new List<OpportunityLineItem>();
   //     List<OpportunityLineItem> olisToDelete = new List<OpportunityLineItem>();
   //     //List<PricebookEntry> pdelist = new List<PricebookEntry>();        
        
   //     Map<Id, Id> productIdToPricebookEntryIdMap = new Map<Id, Id>();
   //     // Gather pricebook entries and put in a map
   //     for (PricebookEntry pricebookEntry: [
   //         select Product2Id
   //         from PricebookEntry
   //         where Product2Id in :connectionIdToProductIdMap.values()
   //         and Pricebook2.IsStandard = true
   //     ]) {
   //         //pricebookEntry.unitprice = Lightning_CommercialProductOverviewCntrl.totalprice;
   //         //update pricebookEntry;
   //         productIdToPricebookEntryIdMap.put(pricebookEntry.Product2Id, pricebookEntry.Id);
                      
   //     }
        
        
   //     for (String connectionId : connectionIdToProductIdMap.keySet()) {
            
   //                 // if an Opportunity Line Item already existed for the connected and the product
   //         // has changed, we have to delete the existing opportunity line item
   //         if (connectionIdToOpportunityLineItemMap.containsKey(connectionId)) {
   //             OpportunityLineItem oldOli = connectionIdToOpportunityLineItemMap.get(connectionId);
   //             if (oldOli.Product2Id != connectionIdToProductIdMap.get(connectionId)&&!String.isblank(oldoli.id)) {
   //                olisToDelete.add(oldOli); 
   //             OpportunityLineItem oli = connectionIdToOpportunityLineItemMap.get(connectionid).clone();
   //             oli.OpportunityId = opportunity.Id;
   //             oli.Connection__c = Id.valueOf(connectionId);
   //             oli.Quantity = 1;
   //             oli.UnitPrice = 14647.02;                
                
   //             oli.PricebookEntryId = productIdToPricebookEntryIdMap.get(connectionIdToProductIdMap.get(connectionId));
   //             system.debug('PricebookId :' +oli.PricebookEntryId);
   //             // Set default values for quantity and unit price.
   //             //olisToInsert.add(oli);
   //             connectionIdToOpportunityLineItemMap.put(connectionid,oli);
   //             }
   //         }
 
   //         if (String.isblank(connectionIdToOpportunityLineItemMap.get(connectionId).id)) {
   //             OpportunityLineItem oli = connectionIdToOpportunityLineItemMap.get(connectionid).clone();
   //             oli.OpportunityId = opportunity.Id;
   //             oli.Connection__c = Id.valueOf(connectionId);
   //             oli.Quantity = 1;
   //             oli.UnitPrice = 14647.02;                
                
   //             oli.PricebookEntryId = productIdToPricebookEntryIdMap.get(connectionIdToProductIdMap.get(connectionId));
   //             system.debug('PricebookId :' +oli.PricebookEntryId);
   //             // Set default values for quantity and unit price.
   //             //olisToInsert.add(oli);
   //             connectionIdToOpportunityLineItemMap.put(connectionid,oli);
   //         }
   //     }
   //     system.debug('olisToDelete '+olisToDelete);
   //     system.debug('olisToInsert  '+olisToInsert);
   //     if (!olisToDelete.isEmpty()) delete olisToDelete;
   //     if (!connectionIdToOpportunityLineItemMap.values().isEmpty()) upsert connectionIdToOpportunityLineItemMap.values(); 
        
   //     //return new ApexPages.StandardController(opportunity).view();
   // }
    
   // public PageReference saveInQuoteMode() {
   //     // TODO: Add error handling 
   //     List<QuoteLineItem> qlisToInsert = new List<QuoteLineItem>();
   //     List<QuoteLineItem> qlisToDelete = new List<QuoteLineItem>();
        
   //     Map<Id, Id> productIdToPricebookEntryIdMap = new Map<Id, Id>();
   //     // Gather pricebook entries and put in a map
   //     for (PricebookEntry pricebookEntry: [
   //         select Product2Id
   //         from PricebookEntry
   //         where Product2Id in :connectionIdToProductIdMap.values()
   //         and Pricebook2.IsStandard = true
   //     ]) {
   //         productIdToPricebookEntryIdMap.put(pricebookEntry.Product2Id, pricebookEntry.Id);
   //     }
        
   //     for (String connectionId : connectionIdToProductIdMap.keySet()) {
            
   //         Boolean doInsertForConnectionId = true;
   //         // if an Opportunity Line Item already existed for the connected and the product
   //         // has changed, we have to delete the existing opportunity line item
   //         if (connectionIdToQuoteLineItemMap.containsKey(connectionId)) {
   //             QuoteLineItem oldqli = connectionIdToQuoteLineItemMap.get(connectionId);
   //             if (oldqli.Product2Id != connectionIdToProductIdMap.get(connectionId)&&!String.isblank(oldqli.id))  {
   //                qlisToDelete.add(oldqli); 
   //                QuoteLineItem qli = connectionIdToQuoteLineItemMap.get(connectionid).clone();
   //                 qli.QuoteId = Quote.Id;
   //                 qli.Connection__c = Id.valueOf(connectionId);
   //                 qli.Quantity = 1;
   //                 qli.UnitPrice = 1;                
   //                 qli.PricebookEntryId = productIdToPricebookEntryIdMap.get(connectionIdToProductIdMap.get(connectionId));
   //                 qlisToInsert.add(qli);
   //             }
   //         }
 
   //         if (String.isblank(connectionIdToQuoteLineItemMap.get(connectionid).id)) {
   //             QuoteLineItem qli = connectionIdToQuoteLineItemMap.get(connectionid).clone();
   //             qli.QuoteId = Quote.Id;
   //             qli.Connection__c = Id.valueOf(connectionId);
   //             qli.Quantity = 1;
   //             qli.UnitPrice = 1;                
                
   //             qli.PricebookEntryId = productIdToPricebookEntryIdMap.get(connectionIdToProductIdMap.get(connectionId));
   //             // Set default values for quantity and unit price.
   //             qlisToInsert.add(qli);
   //         }
   //     }
   //     if (!qlisToDelete.isEmpty()) delete qlisToDelete;
   //     if (!qlisToInsert.isEmpty()) insert qlisToInsert; 
        
   //     return new ApexPages.StandardController(Quote).view();
   // }
    
    
   // public CommodityProductsConfiguratorController getThis() {
   //     return this;
   // }
    
   //  public void filter()
   //  {
   //      system.debug('in filter');
   //      system.debug('in filter'+connectionIdTofilterMap.keyset());
       
   //      for(connection__C connection:[select id,name,Utility_type__c from connection__c where id =:connectionIdTofilterMap.keyset()])
   //      {
   //          newConnectionSelected(connection);
   //      }          
         
   //   }
   //    public void filterFee()
   //  {
   //      system.debug('in filterfee');
       
   //      for(connection__C connection:[select id,name,Utility_type__c from connection__c where id =:connectionIdTofilterfeeMap.keyset()])
   //      {
   //          newConnectionSelected(connection);
   //      }          
         
   //   }
    
   // public void showPopup() 
   // {        
   //     displayPopup = true;
   //     //system.debug('Custom Settings:' +eavest);
   //     List<SelectOption> options = new List<SelectOption>();
   //     //List<String> picklistoptions = new List<String>();
   //     //picklistoptions.addAll(eavest.keySet());
   //     labeltovaluemap.clear();
   //     system.debug('Utilitytype:' +conutilitytype);
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
   //    displayPopup = false;
   //    totalelec = 0;
   //    totalgas = 0;
   //    EAVEstimatorDefaults__c defvalue = EAVEstimatorDefaults__c.getOrgDefaults();
   //    totaleleceav = defvalue.Electricity_Default_Units__c;
   //    totalgaseav = defvalue.Gas_Default_Units__c;
   //    map<string,EAVEstimatorRule__c> eavest = EAVEstimatorRule__c.getall();    
   //    for(string str: labeltoanswermap.values())
   //    {
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
   //    for(ID conn :connectionIdToOpportunityLineItemMap.keyset())
   //    {
   //        if(connectionIdToConnectionMap.get(conn).utility_type__c == 'Electricity' && totalelec != 0)
   //        {
   //            connectionIdToOpportunityLineItemMap.get(conn).EAV__c = totalelec + totaleleceav;
   //        }
   //        if(connectionIdToConnectionMap.get(conn).utility_type__c == 'Gas' && totalgas != 0)
   //        {
   //            connectionIdToOpportunityLineItemMap.get(conn).EAV__c = totalgas + totalgaseav;
   //        }
   //    }        
           
       
                                                                       
   //}
    
   // public void closePopup()
   // {
   //     displayPopup = false;
   // }
    
    //public void clearMap(){
    //    connectionIdToProductIdMap.clear();
    //    fromComp=true;
    //    system.debug('inside clear'+connectionIdToProductIdMap.size());
    //    System.debug('fromComp'+fromComp);
    //}
    
    //public pagereference NewCon()
    //{
    //    PageReference openvfpage = page.NewConnectionPage;
    //    openvfpage.getParameters().put('Ptype', 'Commodity');
    //    openvfpage.getParameters().put('OppId',opportunity.Id);
    //    openvfpage.setRedirect(false);
    //    return openvfpage;
    //}    
        
    
}