/**
 * @author Aard-Jan van Kesteren
 * @description Calculates the unit prices for 
 *              OpportunityLineItem or QuoteLineItem
 *              records if the related
 *              product is a commercial product.            
 */
public class CommercialProductUnitPriceCalculator {

    public static final String NEVER = 'Never'; 
    public static final String ALWAYS = 'Always';
    public static final String SINGLE_METER = 'Single Meter';
    public static final String DOUBLE_METER = 'Double Meter';
    
    public static final String PLUS_VALUE = '+ Value';
    public static final String TIMES_VALUE = '* Value';
    public static final String PLUS_VALUE_TIMES_FIELD = '+ (Value * Field)';
    public static final String TIMES_ONE_MINUS_VALUE = '* (1 - Value)';
    public static final String PLUS_TWELVE_TIMES_VALUE = '+ (12 * Value)';
    
    public static final String EAV_FIELD = 'EAV';
    
    public Map<OpportunityLineItem, List<Line>> calculateUnitPrices(List<OpportunityLineItem> olis) {
        
        Map<OpportunityLineItem, List<CommercialProductUnitPriceCalculator.Line>> linesMap = new
                Map<OpportunityLineItem, List<CommercialProductUnitPriceCalculator.Line>>();
        
        // Gather the pricebook entry ids
        List<Id> pricebookEntryIds = new List<Id>();
        for (OpportunityLineItem oli: olis) {
            pricebookEntryIds.add(oli.pricebookEntryId);
        }
        
        // Query the realted pricebook entries at its master product id
        // Only consider commercial products
        List<PricebookEntry> pricebookEntries = [
            select Product2Id, Product2.Master_Product__c
            from PricebookEntry        
            where Id in :pricebookEntryIds
            and Product2.RecordType.DeveloperName = 'Commercial_Product'
        ];
        
        // Gather the master product ids
        // And maintain a pricebook entry id to master product id map
        // And maintain a lit of product ids
        List<Id> masterProductIds = new List<Id>();
        List<Id> productIds = new List<Id>();
        Map<Id, Id> pricebookEntryIdToProductId = new Map<Id, Id>();
        for (PricebookEntry pricebookEntry: pricebookEntries) {
            masterProductIds.add(pricebookEntry.Product2.Master_Product__c);
            pricebookEntryIdToProductId.put(pricebookEntry.Id, pricebookEntry.Product2Id);
            productIds.add(pricebookEntry.Product2Id);
        }
        
        // Find the product items. Make sure that they ordered on calculation order
        List<Commercial_Product_Value__c> cpvs = [
            select Product__r.Master_Product__c, Product_Item__r.Value_Type__c, Rate_Value__c,Percentage_Value__c, 
                   Product_Item__r.Criterium__c, Product_Item__r.Operation__c, Product_Item__r.Field__c,
                   Product_Item__r.Name, Product_Item__r.Calculation_Order__c
            from Commercial_Product_Value__c 
            where Product__c in :productIds
            order by Product_Item__r.Calculation_Order__c asc
        ];
        // Now group the product items per master product
        Map<Id, Set<Commercial_Product_Value__c>> cpvMap 
            = new Map<Id, Set<Commercial_Product_Value__c>>();
        for (Commercial_Product_Value__c cpv: cpvs) {
            if (!cpvMap.containsKey(cpv.Product__c)) {
                cpvMap.put(cpv.Product__c, new Set<Commercial_Product_Value__c>());
            }
            cpvMap.get(cpv.Product__c).add(cpv);
        }
        
        // Do the calculation per Opportunity Line Item
        for (OpportunityLineItem oli: olis) {
            // Get all the product items relevant for oli.
            // For this, we first need to get master product for this oli
            
            Id productId = pricebookEntryIdToProductId.get(oli.PricebookEntryId); 
            
            Decimal value = 0;
            linesMap.put(oli, new List<Line>());
            
            System.debug('***** cpvMap: ' + cpvMap);
            
            if (cpvMap.containsKey(productId)) {
                for (Commercial_Product_Value__c cpv: cpvMap.get(productId)) {
                    value = processCpvCalculation(value, cpv, oli, linesMap); 
                }
            }
            oli.UnitPrice =value;
        }
        return linesMap;
    }
    
    public Decimal processCpvCalculation(Decimal value, Commercial_Product_Value__c cpv, sObject lineItem, Map<OpportunityLineItem, List<Line>> linesMap) {
        
        Decimal newValue;
      
            
            Line line = new Line();
            line.name = cpv.Product_Item__r.Name;
            line.operation = cpv.Product_Item__r.Operation__c;
            line.criterium = cpv.Product_Item__r.Criterium__c;
            
            // Handle "+ Value" operation
            if (cpv.Product_Item__r.Operation__c == PLUS_VALUE) {
        
                    line.rate = Util.formatRate(cpv.Rate_Value__c);     
                    newValue = value + cpv.Rate_Value__c;
                
            }
            
            // Handle "* Value" operation
            if (cpv.Product_Item__r.Operation__c == TIMES_VALUE) {
               
                    line.rate = Util.formatPercentage(cpv.Rate_Value__c);
                    newValue = value * cpv.Rate_Value__c;
                
            }    
            
            // Handle "+ (Value * Field) operation" 
            if (cpv.Product_Item__r.Operation__c == PLUS_VALUE_TIMES_FIELD) {
               
                    Decimal fieldValue;
                    if (lineItem instanceof OpportunityLineItem) {
                        if (cpv.Product_Item__r.Field__c == EAV_FIELD) {
                            fieldValue = ((OpportunityLineItem)lineItem).EAV__c;
                        } 
                    }
                    if (fieldValue == null) fieldValue = 0;
                    
                    line.rate = Util.formatRate(cpv.Rate_Value__c);
                    line.EAV = fieldValue + '';
                        
                    newValue = value + (cpv.Rate_Value__c * fieldValue);
                       
            }
            
            // Handle "+ (1 - Value) operation" 
            if (cpv.Product_Item__r.Operation__c == TIMES_ONE_MINUS_VALUE) {
               
                    line.rate = Util.formatPercentage(cpv.Rate_Value__c);
                    newValue = value * (1 - (cpv.Rate_Value__c ));
                      
            }

            // Handle "+ (12 * Value) operation" 
            if (cpv.Product_Item__r.Operation__c == PLUS_TWELVE_TIMES_VALUE) {
                
                    line.rate = Util.formatRate(cpv.Rate_Value__c);
                    newValue = value + 12 * cpv.Rate_Value__c;
                       
            }              
            
            line.newTotal = Util.formatRate(newValue, true);
            line.delta = Util.formatRate(((newValue==null)?0:newvalue)- ((value==null)?0:value), true);
            
            linesMap.get((OpportunityLineItem)lineItem).add(line);
            return newValue;
        
     //   throw new ConfigException('Cannot handle commercial product value '+ cpv.Product_Item__r);
    }
    
    public void updateOpportunity(Id opportunityId) {
        List<OpportunityLineItem> olis = [
            select PricebookEntryId, EAV__c
            from OpportunityLineItem
            where OpportunityId = :opportunityId
        ];
        
        Map<OpportunityLineItem, List<Line>> linesMap = calculateUnitPrices(olis);
        update olis;
    }
    
    class ConfigException extends Exception {}
    
    public class Line {
        public String name {get; set;}
        public String eav {get; set;}
        public String rate {get; set;}
        public String operation {get; set;}
        public String newTotal {get; set;}
        public String delta {get; set;}
        public String criterium {get; set;}
        
        
    }
}