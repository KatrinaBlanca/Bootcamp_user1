public class CommercialProductOverviewController {
    
    public String productId {get; set;}
    public Integer eavParam {get; set;}
    
    public List<CommercialProductUnitPriceCalculator.Line> lines {
        
        get {
            
            if (productId != null && productId.trim() != '') {
                CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
                System.debug('productid---'+productId );
                OpportunityLineItem oli = new OpportunityLineItem();

                // The Commerical Product Unit Calculator price needs to have the
                // the pricebook entry id filled on the opportunity line item. Therefore we
                // query it here. It's a workaround, but it works. 
                oli.PricebookEntryId = [
                    select Id
                    from PricebookEntry
                    where Product2Id = :productId
                    and Pricebook2.IsStandard = true
                    limit 1
                ][0].Id;
                oli.EAV__c = eavParam == null ? 0 : eavParam;
                System.debug('*****: ' + oli);
                List<OpportunityLineItem> olis = new List<OpportunityLineItem>{oli};
                Map<OpportunityLineItem, List<CommercialProductUnitPriceCalculator.Line>> linesMap = 
                    calculator.calculateUnitPrices(olis);
                System.debug('*****: ' + linesMap);
                
                /* List<CpvLineItem> cpvLineItems = new List<CpvLineItem>();
                for (Commercial_Product_Value__c cpv: [select Product_Item__r.Name, Value__c from Commercial_Product_Value__c 
                    where Product__c = :productId
                    order by Name asc]) {
                    CpvLineItem cpvLineItem = new CpvLineItem();
                    cpvLineItem.Name = cpv.Product_Item__r.Name;
                    cpvLineItem.value = cpv.Value__c;
                    cpvLineItems.add(cpvLineItem);
                } 
                return cpvLineItems;
                */
                List<CommercialProductUnitPriceCalculator.Line> lines = linesMap.values()[0];
                
                CommercialProductUnitPriceCalculator.Line totalLine = 
                    new CommercialProductUnitPriceCalculator.Line();
                totalLine.name = 'Total';
              //  if(lines.size()>1){
                totalLine.delta = (lines[lines.size() - 1].newTotal);
             //   }
                totalLine.eav=''+eavParam;
                lines.add(totalLine);
                
                return lines;
            } else {
                return new List<CommercialProductUnitPriceCalculator.Line>();
            }
        }
    }
       
    public Product2 getProductDetail() {
        System.debug('*****: getProductDetail()');
        return [
            select Id, Name, Description,Product_Rating__c,Contract_Duration_Years__c, 
            Brand_s_Logo__c from product2 where id=:productid];                           
    }
    
}