/**  
* @author       : Accenture IDC  
* @date         : 21/07/2015  
* @description  : class is used to display the table with commercial product values in opportunity line items  
*/ 
public class OliProductItemValuesControllerExt {

    Id pricebookEntryId;
    
    public oliProductItemValuesControllerExt(ApexPages.StandardController stdController) 
    {
        pricebookEntryId = ((OpportunityLineItem)stdController.getRecord()).PricebookEntryId;
    }    
    
    public List<Commercial_Product_Value__c> getCommercialProductValues() 
    {
        return [select Product_Item__r.Name, Value__c from Commercial_Product_Value__c 
            where Product__c in (select Product2Id from PricebookEntry where id = :pricebookEntryId)
            order by Name asc];
    }
}