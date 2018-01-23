/**
*  Lightning_CommodityProdConfCtrl component's Aura Controller to get and process the EAV details
*  @Author Accenture 
*  Created date : 23\03\2016
*  Version Changes
*/
public class Lightning_CommodityProdConfCtrl{
/**
* Method to get the question and options for EAV
**/    
    @AuraEnabled
    public static List<Wrapper> getQA(String OpportunityId){
        //CommodityProductsConfiguratorController ctrl = new CommodityProductsConfiguratorController();
        //map<string,List<selectoption>> tempMap = new map<string,List<selectoption>>();
        
        //ctrl.initilize(OpportunityId);
        //ctrl.showPopup();
        //tempMap = ctrl.labeltovaluemap;
        List<Wrapper> valHolder = new List<Wrapper>();
        //Wrapper Wrapval = new Wrapper();  
        //List<String> optStr = new List<String>();
        //Integer i = 0;
        //for (String key : tempMap.keySet()) {    
        //    List<selectoption> tempStr = tempMap.get(key);
        //    optStr.clear();
        //    for(selectoption tmp:tempStr)
        //    {
        //        optStr.add(tmp.getValue());
        //    }
        //    i=i+1;
            
        //    Wrapval.qno = 'QEST'+i;
        //    Wrapval.question = key;
            
            
            
            
        //    list<option> optionLst = new list<option>();
        //    if(optStr.size()>0){
        //        for(String currString : optStr){
        //            option optionWrapper = new option();
        //            optionWrapper.option = currString;
        //            optionLst.add(optionWrapper);
        //        }
        //    }
        //    Wrapval.options = optionLst;
        //    //valHolder.add(Wrapval);  
            
        //}
        ////assign values to wrapper
        //for (EAVEstimatorRule__c est: EAVEstimatorRule__c.getAll().values())
        //{
        //    Wrapval.electricityUnits = new List<Decimal>();
        //    Wrapval.gasUnits = new List<Decimal>();
        //    Wrapval.imageOne = new List<String>();
        //    Wrapval.imageTwo = new List<String>();
        //    Wrapval.sortOrder = new List<Decimal>();
        //    Wrapval.type = new List<String>();
        //    Wrapval.val = new List<String>();
        //    Wrapval.name = new List<String>();
        //    Wrapval.electricityUnits.add(est.Electricity_Units__c);
        //    Wrapval.gasUnits.add(est.Gas_Units__c);
        //    Wrapval.imageOne.add(est.image1__c);
        //    System.debug('img1------------'+Wrapval.imageOne);
        //    Wrapval.imageTwo.add(est.image2__c);
        //    Wrapval.sortOrder.add(est.Sorting_Order__c);
        //    Wrapval.type.add(est.Type__c);
        //    Wrapval.val.add(est.Value__c);
        //    Wrapval.name.add(est.name);
        //    valHolder.add(Wrapval);
        //}
        return valHolder;
    }
    
/**
* Wrapper to get the EAV question and options
**/   
    public class Wrapper{
//        @AuraEnabled
//        public String qno{get;set;}
//        @AuraEnabled
//        public String question{get;set;}
//        @AuraEnabled
//        public List<option> options{get;set;}
//        @AuraEnabled
//        public List<Decimal> electricityUnits{get;set;}
//        @AuraEnabled
//        public List<Decimal> gasUnits{get;set;}
//        @AuraEnabled
//        public List<String> imageOne{get;set;}
//        @AuraEnabled
//        public List<String> imageTwo{get;set;}
//        @AuraEnabled
//        public List<Decimal> sortOrder{get;set;}
//        @AuraEnabled
//        public List<String> type{get;set;}
//        @AuraEnabled
//        public List<String> val{get;set;}
//        @AuraEnabled
//        public List<String> name{get;set;}      
    }
//    public class option{
//        @AuraEnabled
//        public String option {get;set;}
//    }
///**
//* Method to calculate totals based on EAV inputs
//**/
    
//    @AuraEnabled
//    public static list<Lightning_CommodityProductsConfigCntrl.connectionWrapper1> genEAV(String qaStr, String currLstStr)
//    {
//        system.debug('***Inside Method******');
//        system.debug('***qaStr***'+qaStr);
//        system.debug('***currLstStr***'+currLstStr);
//        //List<Wrapper> WrapLis = (List<Wrapper>)JSON.deserialize(WrapStr,list<Wrapper>.class);
//        list<Lightning_CommodityProductsConfigCntrl.eavQA> qaList = (list<Lightning_CommodityProductsConfigCntrl.eavQA>)JSON.deserialize(qaStr,list<Lightning_CommodityProductsConfigCntrl.eavQA>.class);
//        list<Lightning_CommodityProductsConfigCntrl.connectionWrapper1> currList = (list<Lightning_CommodityProductsConfigCntrl.connectionWrapper1>)JSON.deserialize(currLstStr,list<Lightning_CommodityProductsConfigCntrl.connectionWrapper1>.class);
//        system.debug('***qaList***'+qaList);
//        map<string,string> labeltoanswermap = new map<string,string>();
//        for(Lightning_CommodityProductsConfigCntrl.eavQA currQA : qaList){
//            if(currQA.question != null && currQA.question != ''){
//                labeltoanswermap.put(currQA.question,currQA.answer);
//            }else{
//                labeltoanswermap.put(currQA.question,'Select');
//            }
//        }
//        if(labeltoanswermap.containsKey('Year of Building')){
//            if(labeltoanswermap.get('Year of Building') == '1945'){
//                labeltoanswermap.put('Year of Building','<1945');
//            }
//        }
//        if(labeltoanswermap.containsKey('Total Square Meters')){
//            if(labeltoanswermap.get('Total Square Meters') == '65'){
//                labeltoanswermap.put('Total Square Meters','<65');
//            }else if(labeltoanswermap.get('Total Square Meters') == '250'){
//                labeltoanswermap.put('Total Square Meters','>250');
//            }
//        }
//        system.debug('****labeltoanswermap****'+labeltoanswermap);
//        Map<Id, Connection__c> connectionIdToConnectionMap = new Map<Id, Connection__c>();
//        Map<Id, OpportunityLineItem> connectionIdToOpportunityLineItemMap = new Map<Id, OpportunityLineItem>();
//        for(Lightning_CommodityProductsConfigCntrl.connectionWrapper1 currRec : currList){
//            connectionIdToConnectionMap.put(currRec.connectionId, currRec.connection);
//            connectionIdToOpportunityLineItemMap.put(currRec.connectionId, currRec.oLI);
//        }
//        //CommodityProductsConfiguratorController ctrl = new CommodityProductsConfiguratorController();
//        //ctrl.connectionIdToConnectionMap = connectionIdToConnectionMap;
//        //ctrl.connectionIdToOpportunityLineItemMap = connectionIdToOpportunityLineItemMap;
//        //ctrl.labeltoanswermap = labeltoanswermap;
//        //ctrl.calculateeav();
//        //Map<Id, OpportunityLineItem> updatedConnectionIdToOpportunityLineItemMap = new Map<Id, OpportunityLineItem>();
//        //updatedConnectionIdToOpportunityLineItemMap = ctrl.connectionIdToOpportunityLineItemMap;
//        //system.debug('***updatedConnectionIdToOpportunityLineItemMap***'+updatedConnectionIdToOpportunityLineItemMap);
//        //for(Lightning_CommodityProductsConfigCntrl.connectionWrapper1 currRec : currList){
//        //    if(updatedConnectionIdToOpportunityLineItemMap.get(currRec.connectionId) != null){
//        //        currRec.eav = updatedConnectionIdToOpportunityLineItemMap.get(currRec.connectionId).EAV__c;
//        //    }
//        //}        
        
//        return currList;
//    }
    
    
    
    
}