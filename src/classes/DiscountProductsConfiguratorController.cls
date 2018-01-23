public class DiscountProductsConfiguratorController
{
    //public Opportunity opportunity {get; set;}
    //public Quote quote {get; set;}
    //public List<Discountproduct> discountprds{get;set;}
    //public Map<Product2, OpportunityLineItem> productToOliMap {get; set;}
    //public Map<Product2, QuoteLineItem> productToqliMap {get; set;}
    //public List<Id> productsinlineitem;
    //public List<Id> discids;
    //Public map<Id,OpportunityLineItem> prodidtoolimap;
    //Public map<Id,QuoteLineItem> prodidtoqlimap;
    //public map<Id,Product2> discprdmap;
    //public List<Opportunitylineitem> Olistoinsert; 
    //public List<Opportunitylineitem> Olistodelete;
    //public List<Quotelineitem> qlistoinsert; 
    //public List<Quotelineitem> qlistodelete;
    //public List<Product2> ExistingDiscprds;
    //public Account acc;
    //private static final ID COMMERCIAL_PRODUCT_RECORD_TYPE_ID = [
    //    Select Id 
    //    From RecordType 
    //    Where sObjectType = 'Product2'
    //    and DeveloperName = :Label.ComProd
    //    limit 1
    //][0].Id;
    
    //Constructor
    public DiscountProductsConfiguratorController()
    {
        //Id objectId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
        //discountprds = new List<Discountproduct>();
        //productsinlineitem=new list<id>();
        //Discids=new list<id>();
        //prodidtoolimap = new map<Id,OpportunityLineItem>();
        //prodidtoqlimap = new map<Id,QuoteLineItem>();
        //Olistoinsert = new List<Opportunitylineitem>();
        //Olistodelete = new List<Opportunitylineitem>(); 
        //qlistoinsert = new List<Quotelineitem>();
        //qlistodelete = new List<Quotelineitem>();        
        //discprdmap = new map<Id,Product2>();
        //List<Id> Masterprodids = new List<Id>();
        //ExistingDiscprds = new List<Product2>();
        //List<Product2> Existingnondiscprds = new List<Product2>();
        //List<Id> discountids = new List<Id>();
        
        ////If button is invoked from Opportunity page, execute below code        
        //if (Util.isOpportunityId(objectId))
        //{
        //    opportunity = [
        //        select Name, accountId
        //        from Opportunity
        //        where Id = :objectId
        //        limit 1
        //    ][0];
        //    acc = [select Id,Ispersonaccount from Account where Id =:opportunity.accountId];
        //    system.debug('Ispersonaccount:' +acc.Ispersonaccount);
        //    productToOliMap = new Map<Product2, OpportunityLineItem>();
            
        //        list<OpportunityLineItem> opportunityLineItems = [select Product2Id, opportunityId from OpportunityLineItem
        //                                 where OpportunityId = :opportunity.Id];
        //    for(OpportunityLineItem olis: opportunityLineItems) 
        //    {
        //        productsinlineitem.add(olis.product2id);
        //        prodidtoolimap.put(olis.product2Id,Olis);
        //    }
        //}
        ////If button is invoked from Quote page, execute below code    
        //else if (Util.isQuoteId(objectId))
        //{
        //   quote = [
        //        select Name, accountId
        //        from Quote
        //        where Id = :objectId
        //        limit 1
        //    ][0]; 
        //    acc = [select Id,Ispersonaccount from Account where Id =:Quote.accountId];
        //    system.debug('Ispersonaccount:' +acc.Ispersonaccount);
        //    productToqliMap = new Map<Product2, QuoteLineItem>();
            
        //        list<QuoteLineItem> quoteLineItems = [select Product2Id, quoteId from quoteLineItem
        //                                 where QuoteId = :quote.Id];
        //    for(QuoteLineItem qlis: QuoteLineItems) 
        //    {
        //        productsinlineitem.add(qlis.product2id);
        //        prodidtoqlimap.put(qlis.product2Id,qlis);
        //    }
        //}    
        //    //Query existing products and add as existing disc prods or not(Common code for both Opportunity and Quote).
        //    List<Product2> prds = [select Name,Master_Product__r.name,Master_Product__c,Master_Product_Type__c, Id, Frequency__c, Discount_Type__c,Score__C,RecordtypeId,
        //                                     Energy_Type__c, Discount_Value__c, Discount_Value_Unit__c, Description_of_item__c, Discount_Start_Date__c, Discount_End_Date__c 
        //                                               from Product2 where IsActive = true and Id in :productsinlineitem order by score__c desc nulls last];
        //    for(product2 prd: prds)
        //    {
        //        if(prd.RecordtypeId == [Select Id From RecordType Where sObjectType = :Label.ProductAPI and DeveloperName = :Label.Discount  limit 1][0].Id)
        //        {
        //            ExistingDiscprds.add(prd);
        //        }
        //        else
        //        {
        //            Existingnondiscprds.add(prd);
        //            Masterprodids.add(prd.Master_Product__c);
        //        }         
        //    }
        //    //Show the ckeck box as checked for existing disc products.
        //    for(product2 discprd: ExistingDiscprds)
        //    {
        //        Discountproduct dis = new Discountproduct();
        //        dis.product = discprd;
        //        dis.checked = True;
        //        discountprds.add(dis);
        //        discprdmap.put(dis.product.Id,dis.product);
        //    }        
        //    List<Master_Product_Discount__c> MPD = [select Id,Product__c,Master_Product__c from Master_Product_Discount__c where Master_Product__c in :Masterprodids];
        //        for(Master_Product_Discount__c mpds :MPD)
        //        {
        //            if(mpds.Product__c != null)
        //            {
        //                discountids.add(mpds.Product__c);
        //            }    
        //        }
        //    if(acc.Ispersonaccount)
        //    {
        //        List<Product2> Discprds = [select Id,Name,Frequency__c, Discount_Type__c, Energy_Type__c, Discount_Value__c,Score__C,
        //                               Discount_Value_Unit__c, Description_of_item__c, Discount_Start_Date__c, Discount_End_Date__c
        //                               from product2 where IsActive = true and Product2.Id in :discountids and
        //                                (Allowed_Customer_Groups__c = 'Customers' or Allowed_Customer_Groups__c = 'All') order by score__c desc nulls last];   
        //        for(product2 disprd: Discprds)
        //        {
        //            //Show the ckeck box as Un-checked for non-existing disc products.
        //            if(!discprdmap.containskey(disprd.Id))
        //            {   
        //                Discountproduct dis = new Discountproduct();
        //                dis.product = disprd;
        //                dis.checked = false;
        //                discids.add(disprd.Id);
        //                discountprds.add(dis);
        //            }    
        //        }
        //    }
        //    else
        //    {
        //        List<Product2> Discprds = [select Id,Name,Frequency__c, Discount_Type__c, Energy_Type__c, Discount_Value__c,score__C,
        //                               Discount_Value_Unit__c, Description_of_item__c, Discount_Start_Date__c, Discount_End_Date__c
        //                               from product2 where IsActive = true and Product2.Id in :discountids and
        //                                (Allowed_Customer_Groups__c = 'Businesses' or Allowed_Customer_Groups__c = 'All') order by score__c desc nulls last];   
        //        for(product2 disprd: Discprds)
        //        {
        //            //Show the ckeck box as Un-checked for non-existing disc products.
        //            if(!discprdmap.containskey(disprd.Id))
        //            {   
        //                Discountproduct dis = new Discountproduct();
        //                dis.product = disprd;
        //                dis.checked = false;
        //                discids.add(disprd.Id);
        //                discountprds.add(dis);
        //            }    
        //        }
        //    }    
        //    if(discountprds.size() < 1)
        //    {
        //    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.DiscProdError));
        //    }
            
    }     
    
    /**
      * @description        This method is called to check whether page is invoked from Opportunity
      * @param              Null
      * @return             Null
      * @throws             NA
      */
    //private Boolean inOpportunityMode() {
    //    return opportunity != null;
    //}
    
    /**
      * @description        This method is called to check whether page is invoked from quote
      * @param              Null
      * @return             Null
      * @throws             NA
      */
    //private Boolean inQuoteMode() {
    //    return quote != null;
    //}      
    
    //public String title {
    //    get {
    //         return (inOpportunityMode() ? Label.Opportunity : Label.Quote) + Label.ConfigureDiscProd;
    //    }
    //}    
    
    //public String subtitle {
    //    get {
    //        return inOpportunityMode() ? opportunity.Name : quote.Name;
    //    }
    //}   

    //public List<Discountproduct> getDiscounts()
    //{
    //    return discountprds;
    //}
     
    /**
      * @description        This is wrapper class for Discount products.
      * @param              Null
      * @return             Noncommodity products
      * @throws             NA
      */
    //public class Discountproduct
    //{
    //    public Product2 product {get;set;} 
    //    public Boolean checked {get;set;}
   
    //}
    
    /**
      * @description        This method is invoked by click of save button to create/Update Opportunity/Quote Line items.
      * @param              Null
      * @return             Pagereference
      * @throws             NA
      */
    //public PageReference save()
    //{
    //    if (inOpportunityMode())
    //    {
    //       return saveInOpportunityMode(); 
    //    } 
    //    if (inQuoteMode()) {
    //       return saveInQuoteMode(); 
    //    }
    //    return null;
    //}
    
    /**
      * @description        This method is invoked by click of Cancel button to refer to opportunity/Quote page
      * @param              Null
      * @return             Null
      * @throws             NA
      */   
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
    
    /**
      * @description        This method is invoked from Save Method where opportunity line items gets created
      * @param              null
      * @return             Page Reference
      * @throws             NA
      */
    //private PageReference saveInOpportunityMode()
    //{
    //    // Gather pricebook entries and put in a map 
    //    Map<Id, Id> productIdToPricebookEntryIdMap = new Map<Id, Id>();
    //    for (PricebookEntry pricebookEntry: [
    //        select Product2Id
    //        from PricebookEntry
    //        where Product2Id in :discids
    //        and Pricebook2.IsStandard = true
    //    ]) {
    //        productIdToPricebookEntryIdMap.put(pricebookEntry.Product2Id, pricebookEntry.Id);
    //    }
    //    for(Discountproduct disc: discountprds)
    //    {
    //        //For newly selected Discount products, (Where opp ID is null), create new opp line item and specify mandatory fields.
    //        if(disc.checked)
    //        { 
    //           if(!prodidtoolimap.containskey(disc.product.Id))
    //           {
    //               opportunityLineitem olitoinsert = new opportunityLineitem();
    //               olitoinsert.opportunityid = opportunity.Id;
    //               olitoinsert.PricebookEntryId = productIdToPricebookEntryIdMap.get(disc.product.Id);
    //               olitoinsert.Quantity = 1;
    //               olitoinsert.UnitPrice = 1;
    //               Olistoinsert.add(olitoinsert);
    //           }            
    //        }
    //        //If existing opp line item is unchecked, Delete that line item
    //        if(!disc.checked)
    //        {
    //            for(product2 prd2: ExistingDiscprds)
    //            {
    //                if(prd2 == disc.product)
    //                {
    //                    opportunityLineitem olitodelete = new opportunityLineitem();
    //                    olitodelete = prodidtoolimap.get(prd2.Id);
    //                    olistodelete.add(olitodelete);
    //                }
    //            }
    //        }            
                            
    //    }
    //    if(Olistoinsert.size() > 0)
    //    { 
    //        upsert Olistoinsert;        
    //    }
    //    if(olistodelete.size() > 0)
    //    {    
    //        delete olistodelete;
    //    }    
    //    return new ApexPages.StandardController(opportunity).view();
    //}
    
    /**
      * @description        This method is invoked from Save Method where Quote line items gets created
      * @param              null
      * @return             Page Reference
      * @throws             NA
      */
    //private PageReference saveInQuoteMode()
    //{
    //    // Gather pricebook entries and put in a map 
    //    Map<Id, Id> productIdToPricebookEntryIdMap = new Map<Id, Id>();
    //    for (PricebookEntry pricebookEntry: [
    //        select Product2Id
    //        from PricebookEntry
    //        where Product2Id in :discids
    //        and Pricebook2.IsStandard = true
    //    ]) {
    //        productIdToPricebookEntryIdMap.put(pricebookEntry.Product2Id, pricebookEntry.Id);
    //    }
    //    for(Discountproduct disc: discountprds)
    //    {
    //        //For newly selected Discount products, (Where Quote ID is null), create new Quote line item and specify mandatory fields.
    //        if(disc.checked)
    //        { 
    //           if(!prodidtoqlimap.containskey(disc.product.Id))
    //           {
    //               QuoteLineitem qlitoinsert = new QuoteLineitem();
    //               qlitoinsert.quoteid = quote.Id;
    //               qlitoinsert.PricebookEntryId = productIdToPricebookEntryIdMap.get(disc.product.Id);
    //               qlitoinsert.Quantity = 1;
    //               qlitoinsert.UnitPrice = 1;
    //               qlistoinsert.add(qlitoinsert);
    //           }            
    //        }
    //        //If existing opp line item is unchecked, Delete that line item
    //        if(!disc.checked)
    //        {
    //            for(product2 prd2: ExistingDiscprds)
    //            {
    //                if(prd2 == disc.product)
    //                {
    //                    QuoteLineitem qlitodelete = new QuoteLineitem();
    //                    qlitodelete = prodidtoqlimap.get(prd2.Id);
    //                    qlistodelete.add(qlitodelete);
    //                }
    //            }
    //        }            
                            
    //    }
    //    try
    //    {
    //        if(qlistoinsert.size() > 0)
    //        {     
    //            upsert qlistoinsert;        
    //        }
    //        if(qlistodelete.size() > 0)
    //        {    
    //            delete qlistodelete;
    //        }    
            
    //    }
    //    catch(exception e)
    //    {
    //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ProductsException));
    //        return null;
    //    }
    //    return new ApexPages.StandardController(Quote).view();
    //}   
    
}