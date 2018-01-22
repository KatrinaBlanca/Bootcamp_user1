trigger OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update) {

    
   CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
    Map<OpportunityLineItem, List<CommercialProductUnitPriceCalculator.Line>> linesMap = 
        calculator.calculateUnitPrices(Trigger.new);
        
    //   DiscountProductUnitPriceCalculator calculator1 = new DiscountProductUnitPriceCalculator();
    //calculator1.calculatediscprice(trigger.new);
    
    
}