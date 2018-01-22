/**  
* @author       : Accenture IDC  
* @date         : 18/07/2015  
* @description  : Class to create Commercial product value line items for new product, being called by Trigger.  
*/ 
public with sharing class UpdatePrdComValHandler
{
    
    /**   
      * @description       This method creates Commercial product value line items for new product.
      * @param             Product List                 
      * @return            NA     
      * @throws            NA      
      */
    public void Updateprdcomval(List<Product2> lstprd)
    {
        
         Id commercialProductRecordTypeId = [select Id from RecordType where DeveloperName = 'Commercial_Product' limit 1][0].Id;
         system.debug(' recordtype  '+commercialProductRecordTypeId );
        map<id,product2> productmap = new map<id,product2>();
        List<Commercial_Product_Value__c> Comprdtoinsert = new List<Commercial_Product_Value__c>();
        for (Product2 product: lstprd)
        {
            if (product.RecordTypeId == commercialProductRecordTypeId)
            {      
                for (Product_Item__c pi: [Select Id, Rate_Value__c,Price_Group__c,Percentage_Value__c,Variable__c from Product_Item__c where  Master_Product__c = :product.Master_Product__c])
                {
                Commercial_Product_Value__c cpv = new Commercial_Product_Value__c();
                cpv.Product__c = product.Id;
                cpv.Product_Item__c = pi.Id;
                cpv.Price_Group__c=pi.Price_Group__c;
                if(!pi.Variable__c)
                {
                    cpv.Rate_Value_Override__c = pi.Rate_Value__c;
                    cpv.Percentage_Value_Override__c = pi.Percentage_Value__c; 
                }    
                comprdtoinsert.add(cpv);
                productmap.put(product.id,product);
                }
             }
         }
         system.debug('products to create   '+comprdtoinsert);
         try
         {
             if(!comprdtoinsert.isempty())
             insert comprdtoinsert;
            
         }
         catch(dmlexception dmx)
         {
             for (Integer i = 0; i < dmx.getNumDml(); i++)
             {
                 Product2 source = productMap.get(dmx.getDmlId(i));
                 if (source != null) source.addError(Label.COM_PRD_VAL_INSERT_ERROR);
             }
         }        
     }
}