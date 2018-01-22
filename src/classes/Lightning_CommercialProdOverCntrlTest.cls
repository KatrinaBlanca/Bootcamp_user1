/**
*  Test Class for Lightning_CommercialProdOverCntrl
*  @Author Accenture 
*  Created date : 22/03/2016
*  Version Changes  
* 
* 
*/
@isTest(seealldata=true)
public class Lightning_CommercialProdOverCntrlTest {
static testMethod void testLightning_CommercialProdOverCntrl() {
     RecordType rec=[select id from recordtype where sObjectType='Product2' AND Recordtype.developername='Commercial_Product'];
     Master_Product__c masterProduct=TestDataFactoryTest.createMasterProduct('Test Master','Electricity');
       Product_Item__c Proditem=TestDataFactoryTest.createProductItem('test prodItem','Rate',masterProduct.id,True);
       Product2 Prod = TestDataFactoryTest.createProduct('test prod',masterProduct.id,rec.id,'Fixed');
    Lightning_CommercialProductOverviewCntrl check = new Lightning_CommercialProductOverviewCntrl();
    Lightning_CommercialProductOverviewCntrl.getCommercialProductOverview(Prod.id,2);
    }
    }