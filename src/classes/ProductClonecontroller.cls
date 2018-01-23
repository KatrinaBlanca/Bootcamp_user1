/**
  * @author       : Accenture IDC
  * @date         : 03/08/2015
  * @description  : Controller Class for Product Cloning
  */
public class ProductClonecontroller
{
    //Variables
    //private ApexPages.StandardController StdController {get; set;}
    //private Product2 Potcustomer {get;set;}
    //public list<Bundle_Line_Item__c> bundlelineitem = new list<Bundle_Line_Item__c>();
    //public list<Commercial_Product_Value__c> cpval1;
    //Constructor
    public ProductClonecontroller(Apexpages.StandardController controller)
    {
        //this.StdController=controller;
        //Potcustomer=(Product2)StdController.getrecord();
        //cpval1 = new list<Commercial_Product_Value__c>();
        //    if(potcustomer.RecordtypeId == Label.COMMERCIAL_PRODUCT_RECORDTYPE)
        //    {
        //        potcustomer.Start_Date__c = null;
        //        potcustomer.End_Date__c = null;
        //        potcustomer.IsActive=false;
        //        potcustomer.Original_Commercial_Product__c=potcustomer.id;
        //    }
        //    if(potcustomer.RecordtypeId == Label.DISCOUNT_RECORDTYPE)
        //    {
        //        potcustomer.Discount_End_Date__c = null;
        //        potcustomer.Discount_Start_Date__c = null;
        //        potcustomer.IsActive=false;
        //        potcustomer.Original_Discount_Product__c=potcustomer.id;
        //    }
        //    if(potcustomer.RecordtypeId == Label.BUNDLE_RECORDTYPE)
        //    {
        //        potcustomer.Start_Date__c = null;
        //        potcustomer.End_Date__c = null;
        //        potcustomer.IsActive=false;
        //        potcustomer.Original_Bundle_Product__c=potcustomer.id;
        //    }
        
    }
    /**
      * @description       This method is called on click of save button on clone VF page. 
      * @param             NA
      * @return            Product Detail Page
      * @throws            NA
      */
    //public pagereference customsave()
    //{
    //    PageReference page = null;
    //    Savepoint sp=Database.setSavepoint();
    //    potCustomer = (Product2) stdController.getRecord();
    //    try
    //    {
    //        Product2 prd2 = potcustomer;
    //        prd2 = potCustomer.clone(false,true);
    //        //Inserting cloned Product
    //        Database.upsert(prd2);
    //        PricebookEntry pbe = [select Product2Id,UnitPrice from PricebookEntry where Product2Id = :potcustomer.Id];
    //        PricebookEntry pbe2 = [select Product2Id,UnitPrice from PricebookEntry where Product2Id = :prd2.Id];
    //            pbe2.UnitPrice = pbe.UnitPrice;
    //            update pbe2;    
    //        if(potcustomer.RecordtypeId == Label.BUNDLE_RECORDTYPE)
    //        //Creating Bundle Line items here. 
    //        {
    //            list<Bundle_Line_Item__c> lineitemtoinsert = new list<Bundle_Line_Item__c>();
    //            bundlelineitem = [select Id,Product__c,Bundle__c from Bundle_Line_Item__c where Bundle__c =: potcustomer.Id];
    //            for(integer i=0;i<bundlelineitem.size();i++)
    //            {
    //                Bundle_Line_Item__c newbli = new Bundle_Line_Item__c();
    //                newbli.Bundle__c = prd2.Id;
    //                newbli.Product__c = bundlelineitem.get(i).Product__c;
    //                lineitemtoinsert.add(newbli);
    //            }
    //            Database.insert(lineitemtoinsert);
    //         }
    //         if(potcustomer.RecordtypeId == Label.COMMERCIAL_PRODUCT_RECORDTYPE)
    //         {
    //             List<Commercial_Product_Value__c> cpvtoupdate = new list<Commercial_Product_Value__c>();
    //             List<Commercial_Product_Value__c> cpv = new list<Commercial_Product_Value__c>();
    //             cpv = [select Id,Product_Item__c,Rate_Value__c,Percentage_Value__c,Included__c,Variable__c from Commercial_Product_Value__c where Product__c =: potcustomer.Id];
    //             Map<Id,Commercial_Product_Value__c> newmap = new map<Id,Commercial_Product_Value__c>();
    //             for(Commercial_Product_Value__c cpval: cpv)
    //             {
    //                 newmap.put(cpval.Product_Item__c,cpval);
    //             }
    //             system.debug('map'+newmap);
    //             cpval1 = [select id,Rate_Value__c,Percentage_Value__c,Product_Item__c,Included__c,variable__c from Commercial_Product_Value__c where Product__c=:prd2.Id];
    //             if(cpval1.size() != cpv.size())
    //             {
    //                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.PRODUCT_CLONE_ERROR));
    //                 return null;            
    //             }    
    //             for(Commercial_Product_Value__c cpval2: cpval1)
    //             {
    //               Commercial_Product_Value__c var= newmap.get(cpval2.Product_Item__c);
    //               //Commercial_Product_Value__c var1 = new Commercial_Product_Value__c;
    //               if(!var.variable__C)
    //               {
    //                   cpval2.Rate_Value_Override__c=var.Rate_Value__c;
    //                   cpval2.Percentage_Value_Override__c=var.Percentage_Value__c;
    //                   cpval2.Included__c=var.Included__c;
    //                   cpvtoupdate.add(cpval2);
    //               }    
    //             }
    //             system.debug('list'+cpvtoupdate);
    //             Database.Upsert(cpvtoupdate);         
                     
    //         }                    
    //         page = new ApexPages.StandardController(Prd2).view();
    //    }
    //    Catch(Exception e)
    //    {
    //        Database.rollback(sp);
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.PRODUCT_CLONE_GENERIC_ERROR));
    //        page=null;
    //    }
    //    return page;
        
    // }
}