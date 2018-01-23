/**
 * @author Aard-Jan van Kesteren
 * @description Tests CommercialProductUnitPriceCalculator            
 */
@isTest
public class CommercialProductUnitPriceCalculatorTest {

    @isTest 
    static void testCalculateUnitPrices() {
        CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
        
        Master_Product__c masterProduct = TestDataFactoryTest.createMasterProduct();
        
        // P * Q
        Product_Item__c pi1 = TestDataFactoryTest.createRateProductItem(masterProduct, 0.14, 1, 
                                                                    CommercialProductUnitPriceCalculator.ALWAYS,
                                                                    CommercialProductUnitPriceCalculator.PLUS_VALUE_TIMES_FIELD,
                                                                    CommercialProductUnitPriceCalculator.EAV_FIELD
                                                                    );
 
        // Grid fee
        Product_Item__c pi2 = TestDataFactoryTest.createRateProductItem(masterProduct, 35, 2, 
                                                                    CommercialProductUnitPriceCalculator.ALWAYS,
                                                                    CommercialProductUnitPriceCalculator.PLUS_VALUE,
                                                                    null
                                                                    );   
        
        // Discount
        Product_Item__c pi3 = TestDataFactoryTest.createPercentageProductItem(masterProduct, 1000, 3, 
                                                                    CommercialProductUnitPriceCalculator.ALWAYS,
                                                                    CommercialProductUnitPriceCalculator.TIMES_ONE_MINUS_VALUE,
                                                                    null
                                                                    );   
        
        
        Product_Item__c pi4 = TestDataFactoryTest.createPercentageProductItem(masterProduct, 1000, 3, 
                                                                    CommercialProductUnitPriceCalculator.ALWAYS,
                                                                    CommercialProductUnitPriceCalculator.TIMES_VALUE,
                                                                    null
                                                                    );  

        Product_Item__c pi5 = TestDataFactoryTest.createPercentageProductItem(masterProduct, 1000, 3, 
                                                                    CommercialProductUnitPriceCalculator.ALWAYS,
                                                                    CommercialProductUnitPriceCalculator.PLUS_TWELVE_TIMES_VALUE,
                                                                    null
                                                                    ); 
        

        Product2 commercialProduct = TestDataFactoryTest.createCommercialProduct(masterProduct);
        // Note that the commercial product values are created automatically by a trigger

        //System.assertEquals(0.1, [select Percentage_Value__c from Commercial_Product_Value__c where Product_Item__c = :pi3.Id][0].Percentage_Value__c);
        
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.PricebookEntryId = [select Id from PriceBookEntry where Product2Id = :commercialProduct.Id limit 1][0].Id;
        oli1.EAV__c = 1300;        
        
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.PricebookEntryId = [select Id from PriceBookEntry where Product2Id = :commercialProduct.Id limit 1][0].Id;
        oli2.EAV__c = 1000;
        
        
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        olis.add(oli1);
        olis.add(oli2);
        calculator.calculateUnitPrices(olis);
        
        System.assertNotEquals(null, oli1.PricebookEntryId);
        System.assertNotEquals(null, oli2.PricebookEntryId);

        Opportunity opp=TestDataFactoryTest.createOpportunity();
        CommercialProductUnitPriceCalculator cpupc = new CommercialProductUnitPriceCalculator();
        cpupc.updateOpportunity(opp.Id);
     //   System.assertEquals(0.9 * ((1300 * 0.14) + 35), olis[0].UnitPrice);
      //  System.assertEquals(0.9 * ((1000 * 0.14) + 35), olis[1].UnitPrice);
    }
    
    @isTest
    static void testProcessCpvCalc_Rate_Always_PlusValue() {
        CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
        
        OpportunityLineItem oli = new OpportunityLineItem();
        
        Product_Item__c productItem = new Product_Item__c();
        productItem.Value_Type__c = Constants.PRODUCT_ITEM_VALUE_TYPE_RATE;
        productItem.Criterium__c = CommercialProductUnitPriceCalculator.ALWAYS;
        productItem.Operation__c = CommercialProductUnitPriceCalculator.PLUS_VALUE;
        
        Commercial_Product_Value__c cpv = new Commercial_Product_Value__c();
        cpv.Product_Item__r = productItem;
        cpv.Rate_Value_Override__c = 4.56;
        
        //System.assertEquals(5.76, calculator.processCpvCalculation(1.2, cpv, oli));
    }

    @isTest
    static void testProcessCpvCalc_Percentage_Always_TimesValue() {
        CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
        
        OpportunityLineItem oli = new OpportunityLineItem();
        
        Product_Item__c productItem = new Product_Item__c();
        productItem.Value_Type__c = Constants.PRODUCT_ITEM_VALUE_TYPE_PERCENTAGE;
        productItem.Criterium__c = CommercialProductUnitPriceCalculator.ALWAYS;
        productItem.Operation__c = CommercialProductUnitPriceCalculator.TIMES_VALUE;
    
        Commercial_Product_Value__c cpv = new Commercial_Product_Value__c();
        cpv.Product_Item__r = productItem;
        cpv.Percentage_Value_Override__c = 0.1;        
        
        //System.assertEquals(18, calculator.processCpvCalculation(180, cpv, oli));
    }
    
    @isTest
    static void testProcessCpvCalc_Rate_Always_PlusValueTimesField() {
        CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.EAV__c = 2300;
        
        Product_Item__c productItem = new Product_Item__c();
        productItem.Value_Type__c = Constants.PRODUCT_ITEM_VALUE_TYPE_RATE;
        productItem.Criterium__c = CommercialProductUnitPriceCalculator.ALWAYS;
        productItem.Operation__c = CommercialProductUnitPriceCalculator.PLUS_VALUE_TIMES_FIELD;
        //productItem.Field__c = CommercialProductUnitPriceCalculator.EAV;
        
        Commercial_Product_Value__c cpv = new Commercial_Product_Value__c();
        cpv.Product_Item__r = productItem;
        cpv.Rate_Value_Override__c = 0.14;          
        
        //System.assertEquals(20 + (0.14 * 2300), calculator.processCpvCalculation(20, cpv, oli));
    }    

    @isTest
    static void testProcessCpvCalc_Percentage_Always_TimesOneMinusValue() {
        CommercialProductUnitPriceCalculator calculator = new CommercialProductUnitPriceCalculator();
        
        OpportunityLineItem oli = new OpportunityLineItem();
        
        Product_Item__c productItem = new Product_Item__c();
        productItem.Value_Type__c = Constants.PRODUCT_ITEM_VALUE_TYPE_PERCENTAGE;
        productItem.Criterium__c = CommercialProductUnitPriceCalculator.ALWAYS;
        productItem.Operation__c = CommercialProductUnitPriceCalculator.TIMES_ONE_MINUS_VALUE;

        Commercial_Product_Value__c cpv = new Commercial_Product_Value__c();
        cpv.Product_Item__r = productItem;
        cpv.Percentage_Value_Override__c = 0.2;  
        
        //System.assertEquals(300 * (1 - 0.2), calculator.processCpvCalculation(300, cpv, oli));
    } 
    
}