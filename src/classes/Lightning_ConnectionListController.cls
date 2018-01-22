/**
*  Lightning_CommodityConnections component's Aura Controller to display connection details
*  @Author Accenture 
*  Created date : 22/03/2016
*  Version Changes   
* 
*/
public class Lightning_ConnectionListController {

/**
* Method get the products in connection based on the filter criteria 
**/
    
    //@AuraEnabled
    //public static Lightning_CommodityProductsConfigCntrl.connectionWrapper1 filterChange(String opptyId, String connectionId, String filter, String filterFee, String filterBrand, Decimal eav){
    //    Lightning_CommodityProductsConfigCntrl.connectionWrapper1 currConnWrapper = new Lightning_CommodityProductsConfigCntrl.connectionWrapper1();
    //    Map<id, string> connectionIdTofilterMap = new Map<id, string>{connectionId => filter};
    //    Map<id, string> connectionIdTofilterFeeMap = new Map<id, string>{connectionId => filterFee};
    //    Map<id, string> connectionIdTofilterBrandMap = new Map<id, string>{connectionId => filterBrand};
        //CommodityProductsConfiguratorController cntrl = new CommodityProductsConfiguratorController();
        //cntrl.initilize(opptyId);
        //cntrl.connectionIdTofilterMap = connectionIdTofilterMap;
        //cntrl.connectionIdTofilterFeeMap = connectionIdTofilterFeeMap;
        //cntrl.connectionIdTofilterBrandMap = connectionIdTofilterBrandMap;
        //cntrl.filter();
        //if(cntrl.connectionIdToProductIdMap.size() > 0 && cntrl.connectionIdToProductIdMap.get(connectionId) != null){
        //    currConnWrapper.connectionId = connectionId;
        //    currConnWrapper.connection = cntrl.connectionIdToConnectionMap.get(connectionId);
        //    currConnWrapper.filter = cntrl.connectionIdTofilterMap.get(connectionId);
        //    currConnWrapper.filterFee = cntrl.connectionIdTofilterFeeMap.get(connectionId);
        //    currConnWrapper.filterBrand = cntrl.connectionIdTofilterBrandMap.get(connectionId);
        //    currConnWrapper.oLI = cntrl.connectionIdToOpportunityLineItemMap.get(connectionId);
        //    // currConnWrapper.eav = Decimal.valueOf(eav);
        //    currConnWrapper.eav = eav;
        //    currConnWrapper.ProductId = cntrl.connectionIdToProductIdMap.get(connectionId);
        //    list<Lightning_CommodityProductsConfigCntrl.options> ProductSelectOptions = new list<Lightning_CommodityProductsConfigCntrl.options>();
        //    if(cntrl.connectionIdToProductSelectOptionsMap.get(connectionId).size()>0){
        //        for(SelectOption currOption : cntrl.connectionIdToProductSelectOptionsMap.get(connectionId)){
        //            Lightning_CommodityProductsConfigCntrl.options currOpt = new Lightning_CommodityProductsConfigCntrl.options();
        //            currOpt.text = currOption.getValue();
        //            currOpt.label = currOption.getLabel();
        //            if(cntrl.connectionIdToProductIdMap.get(connectionId) == currOption.getValue()){
        //                currOpt.value = 'checked';
        //            }else{
        //                currOpt.value = '';
        //            }
        //            ProductSelectOptions.add(currOpt);
        //        }
        //    }
        //    currConnWrapper.ProductSelectOptions = ProductSelectOptions;
        //}
    //    return currConnWrapper;
        
    //}
    
}