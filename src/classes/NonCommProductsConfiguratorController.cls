/**  
  * @author       : Accenture IDC  
  * @date         : 21/08/2015  
  * @description  : Extension Class to add Non-Commodity Products  
  */
public class NonCommProductsConfiguratorController
{
    //Constants and variables
    //public Opportunity opportunity {get; set;}
    //public Quote quote {get; set;}
    //public List<noncommodityProduct> noncomprds{get;set;}
    //public List<Product2> ncp{get;set;}
    //public List<opportunitylineitem> oli{get;set;}
    //public List<Quotelineitem> qli{get;set;}
    //public map<id,product2> productsInOppLineitemap{get;set;}
    //public map<id,product2> productsInQuoLineitemap{get;set;}
    //public Map<Product2, OpportunityLineItem> productToOliMap {get; set;}
    //public Map<Product2, QuoteLineItem> productToqliMap {get; set;}
    
    //public List<noncommodityMasterProduct> noncommasprds{get;set;}
    //public List<Master_Product__c> ncmp{get;set;}
    
    //public List<Id> productsinlineitem;
    //public Set<product2> prodtodelete;
    //public List<Opportunitylineitem> Olistodelete;
    //public List<Quotelineitem> qlistodelete;
    //public Boolean oppmode{set;get;}
    //public Boolean quomode{set;get;} 
    //public Boolean selectMaster{set;get;}
    //public Boolean selectChild{set;get;}
    //public Id objectId;
    //Constructor   
    public NonCommProductsConfiguratorController()
    {
        //noncomprds=new List<noncommodityProduct>();
        //noncommasprds=new List<noncommodityMasterProduct>();
        //objectId = Id.valueOf(ApexPages.currentPage().getParameters().get('Id'));
        //ncp = new List<Product2>();
        //ncmp = new List<Master_Product__c>();
        //oli = new List<opportunitylineitem>();
        //qli = new List<Quotelineitem>();
        //prodtodelete = new Set<Product2>();
        //Olistodelete = new List<Opportunitylineitem>();
        //Qlistodelete = new List<Quotelineitem>();
        //productsinlineitem=new list<id>();
        //selectMaster = false;
        //selectChild = false;
    
        ////Executing the below code if button is invoked from opportunity page
        //if (Util.isOpportunityId(objectId))
        //{
        //    opportunity = [
        //        select Id, Name, accountId
        //        from Opportunity
        //        where Id = :objectId
        //        limit 1
        //    ][0];
        //}
        //else if (Util.isQuoteId(objectId))
        //{
            
        //   quote = [
        //        select Name, accountId
        //        from Quote
        //        where Id = :objectId
        //        limit 1
        //    ][0]; 
            
        //}
            
        //    selectMaster = True;
            
        //    /*...................*/
        //     List<Master_Product__c> masPrds = [select id,Name,Type__c,Type_Icon__c,Product_Type__c from Master_Product__c where 
        //                           Type__c =: Label.Non_Commodity order by Name desc nulls last]; 
          
        //     for(Master_Product__c masPrd: masPrds)
        //    {     
        //        noncommodityMasterProduct noncommodmasprod=new noncommodityMasterProduct();
        //         noncommodmasprod.mProduct  =masPrd;
        //         noncommodmasprod.mchecked=false;
        //         noncommasprds.add(noncommodmasprod);
               
        //    }  
            
            
            
            
            
            
            
           
    }  
    
    ///**
    //  * @description        This method is called to check whether page is invoked from Opportunity
    //  * @param              Null
    //  * @return             Null
    //  * @throws             NA
    //  */
    //public Boolean inOpportunityMode()
    //{
    //    return opportunity != null;
    //}
    
    ///**
    //  * @description        This method is called to check whether page is invoked from quote
    //  * @param              Null
    //  * @return             Null
    //  * @throws             NA
    //  */
    //public Boolean inQuoteMode()
    //{
    //    return quote != null;
    //}    
    
    //public String title
    //{
    //    get {
    //        return (inOpportunityMode() ? Label.Opportunity : Label.Quote) + Label.ConfigureNonComProd;
    //        }
    //}
    
    //public String subtitle
    //{
    //    get {
    //        return inOpportunityMode() ? opportunity.Name : quote.Name;
    //    }
    //}    
    
    ///**
    //  * @description        This is wrapper class for noncommodity products.
    //  * @param              Null
    //  * @return             Noncommodity products
    //  * @throws             NA
    //  */
    //public List<noncommodityProduct> getnonCommodityProducts()
    //{
    //      return noncomprds;
    //}
    
    //public class noncommodityProduct
    //{
    //    public Product2 product {get;set;} 
    //    public Boolean checked {get;set;}
        
    //}
    
    ///**
    //  * @description        This method is invoked from clicking select button on page to show non commodity product related fields.
    //  * @param              Null
    //  * @return             Null
    //  * @throws             NA
    //  */
    //public void addnoncomprod()
    //{
    //   ncp.clear();
    //    for(noncommodityProduct prd: noncomprds)
    //    {
    //        if(prd.checked)
    //        { 
    //           ncp.add(prd.product);
    //           //If new product is selected, add it to the ncp list and show related fields on the page.
    //           if (inOpportunityMode())
    //           {
    //               if(!productToOliMap.containskey(prd.product))
    //               {
    //                   productToOliMap.put(prd.product, new OpportunityLineItem()); 
    //               }
                  
    //           }
               
    //           if (inQuoteMode())
    //           {     
    //               if(!productToqliMap.containskey(prd.product))
    //               {
    //                   productToqliMap.put(prd.product, new QuoteLineItem()); 
    //               }
                   
    //           }
    //        }
    //    }            
    //    Map<Id, Id> productIdToPricebookEntryIdMap = new Map<Id, Id>();
    //    //Executing below code if button is invoked from opportunity page.
    //    if (inOpportunityMode())
    //    {
    //        // Gather pricebook entries and put in a map 
    //        for (PricebookEntry pricebookEntry: [
    //            select Product2Id
    //            from PricebookEntry
    //            where Product2Id in :productToOliMap.keyset()
    //            and Pricebook2.IsStandard = true
    //            ]) {
    //            productIdToPricebookEntryIdMap.put(pricebookEntry.Product2Id, pricebookEntry.Id);
    //            }
    //        integer i=0;
    //        for(product2 prod: ncp)
    //        {
    //            //For newly selected non-com products, (Where opp ID is null), create new opp line item and specify mandatory fields.
    //            if(productToOliMap.get(prod).opportunityid==null)
    //            {
    //                OpportunityLineItem olitoinsert = productToOliMap.get(prod); 
    //                olitoinsert.OpportunityId = opportunity.Id;
    //                olitoinsert.PricebookEntryId = productIdToPricebookEntryIdMap.get(prod.Id);
    //               // olitoinsert.Quantity = 1;
    //                olitoinsert.UnitPrice = 1;
    //                productToOliMap.put(prod,olitoinsert );
    //                //oli.add(olitoinsert);
    //            }
    //            //For already existing products, just add to the list to be upserted.
    //            else
    //            {
    //                oli.add(productToOliMap.get(prod));
    //            }
    //        }
    //    }
    //    //Executing below code if button is invoked from Quote page.    
    //    if (inQuoteMode())
    //    {
    //        // Gather pricebook entries and put in a map 
    //        for (PricebookEntry pricebookEntry: [
    //            select Product2Id
    //            from PricebookEntry
    //            where Product2Id in :productToqliMap.keyset()
    //            and Pricebook2.IsStandard = true
    //            ]) {
    //            productIdToPricebookEntryIdMap.put(pricebookEntry.Product2Id, pricebookEntry.Id);
    //            }
    //        integer i=0;
    //        for(product2 prod: ncp)
    //        {
    //            //For newly selected non-com products, (Where opp ID is null), create new opp line item and specify mandatory fields.
    //            if(productToqliMap.get(prod).quoteid==null)
    //            {
    //                QuoteLineItem qlitoinsert = productToqliMap.get(prod); 
    //                qlitoinsert.QuoteId = quote.Id;
    //                qlitoinsert.PricebookEntryId = productIdToPricebookEntryIdMap.get(prod.Id);
    //                //qlitoinsert.Quantity = 1;
    //                qlitoinsert.UnitPrice = 1;
    //                productToqliMap.put(prod,qlitoinsert );
    //            }
    //            //For already existing products, just add to the list to be upserted.
    //            else
    //            {
    //                qli.add(productToqliMap.get(prod));
    //            }
    //        }    
    //    }        
    //}   
    
    ///**
    //  * @description        This method is invoked by click of Cancel button to refer to opportunity/Quote page
    //  * @param              Null
    //  * @return             Null
    //  * @throws             NA
    //  */   
    //public Pagereference Cancel()
    //{
    //    if (inOpportunityMode())
    //    {
          
    //        return new PageReference('/' + opportunity.Id);
    //    }
    //    if (inQuoteMode())
    //    {
           
    //        return new PageReference('/' + Quote.Id);
    //    }
    //    return null;
    //}
    
    ///**
    //  * @description        This method is invoked by click of save button to create/Update Opportunity/Quote Line items.
    //  * @param              Null
    //  * @return             Pagereference
    //  * @throws             NA
    //  */
    //public PageReference save()
    //{
    //    //Doing some error handling here...
    //    if(ncp.size() < 1)
    //    {
    //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.NonComErrorMessage));
    //        return null;
    //    }    
    //    if (inOpportunityMode())
    //    {
    //       saveInOpportunityMode(); 
    //       return new ApexPages.StandardController(opportunity).view();
    //    } 
    //    if (inQuoteMode()) {
    //       saveInQuoteMode(); 
    //       return new ApexPages.StandardController(quote).view();
    //    }
    //    return null;
    //}
    
    ///**
    //  * @description        This method is invoked from Save Method where opportunity line items gets created
    //  * @param              null
    //  * @return             Page Reference
    //  * @throws             NA
    //  */
    //private Void saveInOpportunityMode()
    //{
    //    try
    //    {
    //        if (!productToOliMap.isEmpty())
    //        {
    //            upsert productToOliMap.values(); 
    //        }
    //        prodtodelete = productToOliMap.keyset();
    //        for(noncommodityProduct prd: noncomprds)
    //        {
    //            if(!prd.checked)
    //            {
    //                for(product2 prddel: prodtodelete)
    //                {
    //                    if(prddel == prd.product)
    //                    {
    //                        opportunityLineitem olitodelete = new opportunityLineitem();
    //                        olitodelete =  productToOliMap.get(prddel);
    //                        olistodelete.add(olitodelete);
    //                    }
    //                }                   
    //            }
    //        }
    //        if(olistodelete.size() > 0)
    //        {
    //            delete olistodelete;
    //        }                 
    //    }      
    //    catch(exception e)
    //    {
    //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ProductsException));
    //    }    
        
    //}
    
    ///**
    //  * @description        This method is invoked from Save Method where Quote line items gets created
    //  * @param              null
    //  * @return             Page Reference
    //  * @throws             NA
    //  */
    //private Void saveInQuoteMode()
    //{
    //    try
    //    {
    //        if (!productToqliMap.isEmpty())
    //        {
    //            upsert productToqliMap.values(); 
    //        }
    //        prodtodelete = productToqliMap.keyset();
    //        for(noncommodityProduct prd: noncomprds)
    //        {
    //            if(!prd.checked)
    //            {
    //                for(product2 prddel: prodtodelete)
    //                {
    //                    if(prddel == prd.product)
    //                    {
    //                        QuoteLineitem qlitodelete = new QuoteLineitem();
    //                        qlitodelete =  productToqliMap.get(prddel);
    //                        qlistodelete.add(qlitodelete);
    //                    }
    //                }                   
    //            }
    //        }
    //        if(qlistodelete.size() > 0)
    //        {
    //            delete qlistodelete;
    //        }                 
    //    }      
    //    catch(exception e)
    //    {
    //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ProductsException));
    //    }    
        
    //} 
    
    ///**
    //  * @description        This method is invoked from Save and Discount Method where Quote line items(Non Commodity products) gets created and page will be redirected to Discounts page.
    //  * @param              null
    //  * @return             Page Reference
    //  * @throws             NA
    //  */
    //public PageReference saveanddiscount()
    //{
    //    string s;
    //    if (inOpportunityMode())
    //    {
    //        s='/apex/discountproductsconfigurator?id='+opportunity.id;
    //        saveInOpportunityMode(); 
    //    } 
    //    if (inQuoteMode())
    //    {
    //        s='/apex/discountproductsconfigurator?id='+quote.id;
    //        saveInQuoteMode(); 
    //    }
    //    PageReference pageRef = new PageReference(s);
    //    pageRef.setRedirect(false); 
    //    return pageRef;
    //}
    
    ///* ...            */
    ///**
    //  * @description        This is wrapper class for noncommodity master products.
    //  * @param              Null
    //  * @return             Noncommodity master products
    //  * @throws             NA
    //  */
    //public List<noncommodityMasterProduct> getnoncommodityMasterProduct()
    //{
    //      return noncommasprds;
    //}
    
    //public class noncommodityMasterProduct
    //{
    //    public Master_Product__c mProduct {get;set;} 
    //    public Boolean mChecked {get;set;}
        
    //}
    
    
    ///**
    //  * @description        This method is invoked by click of save button to create/Update Opportunity/Quote Line items.
    //  * @param              Null
    //  * @return             Pagereference
    //  * @throws             NA
    //  */
    //public PageReference mSelect()
    //{
    //    selectMaster = false;
    //    selectChild = true;
        
    //    ncmp.clear();
    //    for(noncommodityMasterProduct mprd: noncommasprds)
    //    {
    //        if(mprd.mchecked)
    //        { 
    //           ncmp.add(mprd.mProduct);
    //        }
    //    }
    //    if (Util.isOpportunityId(objectId))
    //    {
        
       
        
        
        
        
    //   productToOliMap = new Map<Product2, OpportunityLineItem>();
    //        oppmode = True;
    //         //Querying Existing non-commodity specific fields(Basically Querying all the fields) and storing in an List.
    //        String objectName = 'OpportunityLineItem';  // modify as needed
    //        String query = 'SELECT';
    //        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
    //        for(String s : objectFields.keySet())
    //        {
    //           query += ' ' + s + ', ';
    //        }
    //        if (query.subString(query.Length()-2,query.Length()-1) == ',')
    //        {
    //            query = query.subString(0,query.Length()-2);
    //        }
    //        Id Oppid = opportunity.Id;
    //        query += ' FROM ' + objectName;
    //        query += ' WHERE Connection__c = null and OpportunityId = :Oppid';
    //        List<OpportunityLineItem> opportunityLineItems = database.query(query);
    //        for(OpportunityLineItem olis: opportunityLineItems) 
    //        {
    //            productsinlineitem.add(olis.product2id);
    //        }
    //        //Query existing opp line items and store in a map along with product
    //        productsInOppLineitemap=new map<id,product2>([select id,Name,End_Date__c,Master_Product__r.name,
    //                                                      Contract_Duration_Years__c,Fee_Type__c,Master_Product_Type__c,Start_Date__c,Product_Image__c  
    //                                                      from product2 where id in :productsinlineitem and Master_Product_Type__c =: Label.Non_Commodity order by score__C desc nulls last] );
    //        //Display existing Non-com products with checkbox as true.                                              
    //        for(OpportunityLineItem olis: opportunityLineItems) 
    //        {
    //            if(productsInOppLineitemap.containskey(olis.Product2Id))
    //            { 
                 
    //                productToOliMap.put(productsInOppLineitemap.get(olis.product2id),olis);
    //                noncommodityProduct noncommodprod=new noncommodityProduct();
    //                noncommodprod.product=productsInOppLineitemap.get(olis.product2id);
    //                noncommodprod.checked=true;
    //                noncomprds.add(noncommodprod);
    //            }    
    //        }
    //        List<Product2> prds = [select id,Name,End_Date__c,Master_Product__r.name,
    //                               Contract_Duration_Years__c,Fee_Type__c,Master_Product_Type__c,Start_Date__c,Product_Image__c from Product2 where 
    //                               Master_Product_Type__c =: Label.Non_Commodity and Master_Product__c IN :ncmp and IsActive = True order by score__c desc nulls last]; 
    //        for(product2 prd: prds)
    //        {
                
                    
    //             //If product is not already lineitem, show it on page with checked as false.
    //             if(!productsInOppLineitemap.containskey(prd.id))
    //             {
    //                 noncommodityProduct noncommodprod=new noncommodityProduct();
    //                 noncommodprod.product=prd;
    //                 noncommodprod.checked=false;
    //                 noncomprds.add(noncommodprod);
    //             }
    //        }  
            
    //        addnoncomprod(); 
            
    //         }     
    //   //If adding non-commodity products from Quote page     
    //    else if (Util.isQuoteId(objectId))
    //    {
    //          productToqliMap = new Map<Product2, QuoteLineItem>();
    //       Quomode = True;
    //       selectMaster = false;
    //        //Querying Existing non-commodity specific fields(Basically Querying all the fields) and storing in an List.
    //        String objectName = 'QuoteLineItem';  // modify as needed
    //        String query = 'SELECT';
    //        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
    //        for(String s : objectFields.keySet())
    //        {
    //           query += ' ' + s + ', ';
    //        }
    //        if (query.subString(query.Length()-2,query.Length()-1) == ',')
    //        {
    //            query = query.subString(0,query.Length()-2);
    //        }
    //        Id Quoid = Quote.Id;
    //        query += ' FROM ' + objectName;
    //        query += ' WHERE Connection__c = null and QuoteId = :Quoid';
    //        List<QuoteLineItem> QuoteLineItems = database.query(query);
    //        for(QuoteLineItem qlis: QuoteLineItems) 
    //        {
    //            productsinlineitem.add(qlis.product2id);
    //        }
    //        //Query existing Quote line items and store in a map along with product
    //        productsInQuoLineitemap=new map<id,product2>([select id,Name,End_Date__c,Master_Product__r.name,
    //                                                      Contract_Duration_Years__c,Fee_Type__c,Master_Product_Type__c,Start_Date__c,Product_Image__c 
    //                                                      from product2 where id in :productsinlineitem and Master_Product_Type__c =: Label.Non_Commodity order by score__C desc nulls last]);
    //        //Display existing Non-com products with checkbox as true.                                              
    //        for(QuoteLineItem qlis: QuoteLineItems) 
    //        {
    //            if(productsInQuoLineitemap.containskey(qlis.Product2Id))
    //            { 
                 
    //                productToqliMap.put(productsInquoLineitemap.get(qlis.product2id),qlis);
    //                noncommodityProduct noncommodprod=new noncommodityProduct();
    //                noncommodprod.product=productsInquoLineitemap.get(qlis.product2id);
    //                noncommodprod.checked=true;
    //                noncomprds.add(noncommodprod);
    //            }    
    //        }
    //        List<Product2> prds = [select id,Name,End_Date__c,Master_Product__r.name,
    //                               Contract_Duration_Years__c,Fee_Type__c,Master_Product_Type__c,Start_Date__c,Product_Image__c from Product2 where 
    //                               Master_Product_Type__c =: Label.Non_Commodity and Master_Product__c IN :ncmp and IsActive = True order by score__C desc nulls last]; 
    //        for(product2 prd: prds)
    //        {
               
    //             //If product is not already lineitem, show it on page with checked as false.
    //             if(!productsInquoLineitemap.containskey(prd.id))
    //             {
    //                 noncommodityProduct noncommodprod=new noncommodityProduct();
    //                 noncommodprod.product=prd;
    //                 noncommodprod.checked=false;
    //                 noncomprds.add(noncommodprod);
    //             }
    //        }  
            
    //        addnoncomprod(); 
            
    //    }  
    //    return null;
    //}
    
       
  
}