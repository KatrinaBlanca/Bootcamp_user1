/**
*  Lightning_CommercialProductOverview component's Aura Controller to display product details
*  @Author Accenture 
*  Created date : 23\03\2016
*  Version Changes  
*/
public class Lightning_CommercialProductOverviewCntrl {
    //public static decimal totalprice = 0;
    //public map<product2,decimal> producttopricemap{get;set;}

/**
* Method assigns the product details to the wrapper and returns the wrapper
**/
    @AuraEnabled
    public static commProdWrapper getCommercialProductOverview(String productId, Integer eavParam) {
        system.debug('*****productId'+productId);
        system.debug('*****eavParam'+eavParam);
        commProdWrapper wrapper = new commProdWrapper();
        CommercialProductOverviewController base = new CommercialProductOverviewController();
        base.productId = productId;
        base.eavParam = Integer.valueOf(eavParam);
        List<CommercialProductUnitPriceCalculator.Line> lines = new List<CommercialProductUnitPriceCalculator.Line>();
        lines = base.lines;
        list<lines> prodLines = new list<lines>();
        Product2 product = new Product2();
        if(lines.size()>0){
            for(CommercialProductUnitPriceCalculator.Line currLine : lines){
                lines wrapLine = new lines();
                wrapLine.name = currLine.name;
                wrapLine.eav = currLine.eav;
                wrapLine.rate = currLine.rate;
                wrapLine.delta = currLine.delta;
                prodLines.add(wrapLine);
                            }
        }
        product = base.getProductDetail();
        wrapper.product = product;
        //producttopricemap.add(wrapper.product,totalprice);
        wrapper.lines = prodLines;
        return wrapper;
    }
/**
* Wrapper to store the product details
**/   
    
    public class commProdWrapper{
        @AuraEnabled
        public Product2 product {get;set;}
        @AuraEnabled
        public list<lines> lines {get;set;}
    }
/**
* Wrapper lines which goes as wrapper inside another wrapper
**/    
    
    public class lines{
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String eav {get; set;}
        @AuraEnabled
        public String rate {get; set;}
        @AuraEnabled
        public String delta {get; set;}
    }
}