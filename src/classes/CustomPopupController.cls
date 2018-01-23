public with sharing class CustomPopupController
{

   
    public String query {get; set;}
    Public String Discountquery {get; set;}
    public List<Product2> product {get; set;}
    public List<Product2> Discountproduct {get; set;}    
    public void runQuery(){
        
        String soql = 'select id, name, RecordTypeId,recordtype.name, DEMO_Price__c,Master_Product_Type__c,IsActive from product2 where Recordtype.name !=\'Discount\'';
        if(query != '' && query != null)
          soql = soql +  ' where name LIKE \'%' + query +'%\'';
        soql = soql + ' limit 25';
        System.debug(soql);
        product = database.query(soql); 
     }
//for discount products  
 public PageReference DiscountQuery() {
        String soql = 'select id, name, RecordTypeId,recordtype.name, DEMO_Price__c,Master_Product_Type__c,IsActive from product2 where recordtype.name=\'Discount\'';
        if(Discountquery != '' && Discountquery != null)
          soql = soql +  ' where name LIKE \'%' + Discountquery +'%\'';
        soql = soql + ' limit 25';
        System.debug(soql);
        Discountproduct = database.query(soql);  
        return null;
    }
     
}