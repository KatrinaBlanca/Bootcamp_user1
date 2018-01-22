/**
*  Lightning_Commodity component's Aura Controller to search display and add connections
*  @Author Accenture 
*  Created date : 22/03/2016
*  Version Changes  
* 
* 
*/
public class Lightning_CommodityProductsConfigCntrl { 
/**
* Method to get opportunity id and return the opportunity name
**/    
    //@AuraEnabled
    //public static opportunity getOpptyName(String opptyId) {
    //    opportunity opp = [select id,Name,Account.Name,Account.BillingCity,Account.BillingPostalCode,
    //                       Account.BillingStreet from Opportunity where Id = :opptyId];
       
    //    return opp;
    //}
    
/**
* Method to check whether logged-in user is Portal user/normal user 
**/    
    //@AuraEnabled
    //public static Boolean checkuser()
    //{
    //    Boolean comuser;
    //    id id1 = userinfo.getProfileId();
    //    if(id1 == '00e28000000JQz5')
    //    {
    //        comuser = True;
    //    }
    //    else
    //    {
    //        comuser = False;
    //    }            
    //    return comuser;
    //}
        
/**
* Method to get the few parameters and return List of connectionWrapper which are connections
**/    
    //@AuraEnabled
    //public static List<connectionWrapper> connectionSearch(String opptyId,String AccountId,String city,String street,String PostalCode,Boolean isGas,Boolean isElectricity)
    //{
        //ConnectionSearchComponentController comp = new ConnectionSearchComponentController();
        //comp.initilize(opptyId);
        //comp.actId = AccountId;
        //comp.street = street;
        //comp.city= city;
        //comp.postalCode = PostalCode;
        //comp.Gas = isGas;
        //comp.Electricity = isElectricity;
        //comp.mode= 'SearchFields';
        //list<connectionWrapper> connList = new list<connectionWrapper>();
       // List<ConnectionSearchComponentController.ConnectionWrapper> conn = comp.connectionWrappers;
       //if(conn.size()>0){
       //     for(ConnectionSearchComponentController.ConnectionWrapper currConnection : conn){
       //         connectionWrapper wrapper = new connectionWrapper();
       //         wrapper.connection = currConnection.connection;
       //         //wrapper.selected = currConnection.selected;
       //         //Modified by shilpa
       //         wrapper.selected = true;
                
       //         connList.add(wrapper);
       //     }
       // }
        
    //    return connList;
    //}
/**
* Method to get the few parameters and return List of connectionWrapper1 which are products
**/    
    //@AuraEnabled
    //public static List<connectionWrapper1> commodityProducts(String opptyId, list<Id> connectionIds)
    //{
    //    list<connectionWrapper1> connList = new list<connectionWrapper1>();        
        //CommodityProductsConfiguratorController cntrl = new CommodityProductsConfiguratorController();
        //cntrl.initilize(opptyId);
        //Map<String, Id> connectionIdToProductIdMap = cntrl.connectionIdToProductIdMap;
        //Map<Id, Connection__c> connectionIdToConnectionMap = cntrl.connectionIdToConnectionMap;
        //Map<id, string> connectionIdTofilterMap = cntrl.connectionIdTofilterMap;
        //Map<id, string> connectionIdTofilterFeeMap = cntrl.connectionIdTofilterFeeMap;
        //Map<id, string> connectionIdTofilterBrandMap = cntrl.connectionIdTofilterBrandMap;
        //Map<Id, OpportunityLineItem> connectionIdToOpportunityLineItemMap = cntrl.connectionIdToOpportunityLineItemMap;
        //Map<Id, List<SelectOption>> connectionIdToProductSelectOptionsMap = cntrl.connectionIdToProductSelectOptionsMap;
        //if(connectionIds.size()>0){
        //    connectionIdToProductIdMap.clear();
        //    system.debug('**********connectionIds'+connectionIds);
        //    List<Connection__c> connectionList = [select Id, Name, EAN__c, Delivery_Street__c, Delivery_City__c, Delivery_Postal_Code__c, Utility_Type__c from Connection__c where id in: connectionIds];
        //    for(Connection__c conn : connectionList){
        //        cntrl.newConnectionSelected(conn);
        //    }
        //}
        //connectionIdToProductIdMap = cntrl.connectionIdToProductIdMap;
        //if(connectionIdToProductIdMap.size()>0){
        //    system.debug('**********connectionIdToProductIdMap'+connectionIdToProductIdMap);
        //    for(String connectionId : connectionIdToProductIdMap.keySet()){
        //        connectionWrapper1 wrapper = new connectionWrapper1();
        //        wrapper.connectionId = connectionId;
        //        wrapper.connection = connectionIdToConnectionMap.get(connectionId);
        //        wrapper.filter = connectionIdTofilterMap.get(connectionId);
        //        wrapper.filterFee = connectionIdTofilterFeeMap.get(connectionId);
        //        wrapper.filterBrand = connectionIdTofilterBrandMap.get(connectionId);
        //        if(connectionIdToOpportunityLineItemMap.get(connectionId) != null){
        //            wrapper.oLI = connectionIdToOpportunityLineItemMap.get(connectionId);
        //            wrapper.eav = connectionIdToOpportunityLineItemMap.get(connectionId).EAV__c;                    
        //        }else{
        //            wrapper.oLI = new OpportunityLineItem();
        //            wrapper.eav = null;
        //        }
        //        wrapper.ProductId = connectionIdToProductIdMap.get(connectionId);
        //        list<options> ProductSelectOptions = new list<options>();
        //        if(connectionIdToProductSelectOptionsMap.get(connectionId).size()>0){
        //            for(SelectOption currOption : connectionIdToProductSelectOptionsMap.get(connectionId)){
        //                options currOpt = new options();
        //                currOpt.text = currOption.getValue();
        //                currOpt.label = currOption.getLabel();
        //                if(connectionIdToProductIdMap.get(connectionId) == currOption.getValue()){
        //                    currOpt.value = 'checked';
        //                }else{
        //                    currOpt.value = '';
        //                }
        //                ProductSelectOptions.add(currOpt);
        //            }
        //        }
        //        wrapper.ProductSelectOptions = ProductSelectOptions;
        //        connList.add(wrapper);
        //    }
        //}
        //return connList;
    //}
/**
* Method to get the few parameters and return List of connectionWrapper1 which are products based on the filter criteria
**/  
    
    //@AuraEnabled
    //public static List<connectionWrapper1> filterChange(String opptyId, String WrapStr)
    //{
    //    system.debug('*****MethodfilterChange');
    //    system.debug('*****MethodfilterChangeopptyId'+opptyId);
    //    system.debug('*****MethodfilterChangeWrapStr'+WrapStr);
    //    List<connectionWrapper1> connList = new list<connectionWrapper1>();
    //    List<connectionWrapper1> WrapLis = (List<connectionWrapper1>)JSON.deserialize(WrapStr,list<connectionWrapper1>.class);
    //    Map<id, string> connectionIdTofilterMap1 = new map<id, string>();
    //    Map<id, string> connectionIdTofilterFeeMap1 = new map<id, string>();
    //    Map<id, string> connectionIdTofilterBrandMap1 = new map<id, string>();
    //    for(connectionWrapper1 temp : WrapLis){
    //        connectionIdTofilterMap1.put(Id.valueOf(temp.connectionId), temp.filter);
    //        connectionIdTofilterFeeMap1.put(Id.valueOf(temp.connectionId), temp.filterFee);
    //        connectionIdTofilterBrandMap1.put(Id.valueOf(temp.connectionId), temp.filterBrand);
    //    }
        //CommodityProductsConfiguratorController cntrl = new CommodityProductsConfiguratorController();
        //cntrl.initilize(opptyId);
        //cntrl.connectionIdTofilterMap = connectionIdTofilterMap1;
        //cntrl.connectionIdTofilterFeeMap = connectionIdTofilterFeeMap1;
        //cntrl.connectionIdTofilterBrandMap = connectionIdTofilterBrandMap1;
        //cntrl.filter();
        //Map<String, Id> connectionIdToProductIdMap = cntrl.connectionIdToProductIdMap;
        //Map<Id, Connection__c> connectionIdToConnectionMap = cntrl.connectionIdToConnectionMap;
        //Map<id, string> connectionIdTofilterMap = cntrl.connectionIdTofilterMap;
        //Map<id, string> connectionIdTofilterFeeMap = cntrl.connectionIdTofilterFeeMap;
        //Map<id, string> connectionIdTofilterBrandMap = cntrl.connectionIdTofilterBrandMap;
        //Map<Id, OpportunityLineItem> connectionIdToOpportunityLineItemMap = cntrl.connectionIdToOpportunityLineItemMap;
        //Map<Id, List<SelectOption>> connectionIdToProductSelectOptionsMap = cntrl.connectionIdToProductSelectOptionsMap;
        //if(connectionIdToProductIdMap.size()>0){
        //    for(String connectionId : connectionIdToProductIdMap.keySet()){
        //        connectionWrapper1 wrapper = new connectionWrapper1();
        //        wrapper.connectionId = connectionId;
        //        wrapper.connection = connectionIdToConnectionMap.get(connectionId);
        //        wrapper.filter = connectionIdTofilterMap.get(connectionId);
        //        wrapper.filterFee = connectionIdTofilterFeeMap.get(connectionId);
        //        wrapper.filterBrand = connectionIdTofilterBrandMap.get(connectionId);
        //        wrapper.oLI = connectionIdToOpportunityLineItemMap.get(connectionId);
        //        wrapper.eav = connectionIdToOpportunityLineItemMap.get(connectionId).EAV__c;
        //        wrapper.ProductId = connectionIdToProductIdMap.get(connectionId);
        //        list<options> ProductSelectOptions = new list<options>();
        //        if(connectionIdToProductSelectOptionsMap.get(connectionId).size()>0){
        //            for(SelectOption currOption : connectionIdToProductSelectOptionsMap.get(connectionId)){
        //                options currOpt = new options();
        //                currOpt.text = currOption.getValue();
        //                currOpt.label = currOption.getLabel();
        //                if(connectionIdToProductIdMap.get(connectionId) == currOption.getValue()){
        //                    currOpt.value = 'checked';
        //                }else{
        //                    currOpt.value = '';
        //                }
        //                ProductSelectOptions.add(currOpt);
        //            }
        //        }
        //        wrapper.ProductSelectOptions = ProductSelectOptions;
        //        connList.add(wrapper);
        //    }
        //}
        //system.debug('****filetrconnList'+connList);
    //    return connList;
    //}
    
/**
* Wrapper to store the product details
**/      
    
    //public class connectionWrapper1{
       
    //    @AuraEnabled
    //    public String connectionId {get; set;}
    //    @AuraEnabled
    //    public String ProductId {get; set;}
    //    @AuraEnabled
    //    public String filter {get; set;}
    //    @AuraEnabled
    //    public String filterFee {get; set;}
    //    @AuraEnabled
    //    public String filterBrand {get; set;}
    //    @AuraEnabled
    //    public Connection__c connection {get; set;}
    //    @AuraEnabled
    //    public OpportunityLineItem oLI {get; set;}
    //    @AuraEnabled
    //    public list<options> ProductSelectOptions {get; set;}
    //    @AuraEnabled
    //    public Decimal eav {get; set;}
    //}
    
/**
* Wrapper for product options
**/      
    //public class options{
    //    @AuraEnabled
    //    public String value {get; set;}
    //    @AuraEnabled
    //    public String label {get; set;}
    //    @AuraEnabled
    //    public String text {get; set;}
    //}
/**
* Method to save connection to the opportunity
**/
    //@AuraEnabled
    //public static string saveConn(String wrapStr, String opptyId){
        //system.debug('******Inside Method'+wrapStr);
        //CommodityProductsConfiguratorController cntrl = new CommodityProductsConfiguratorController();
        //cntrl.initilize(opptyId);
        //Map<Id, OpportunityLineItem> connectionIdToOpportunityLineItemMap = cntrl.connectionIdToOpportunityLineItemMap;
        //List<connectionWrapper1> WrapLis = (List<connectionWrapper1>)JSON.deserialize(WrapStr,list<connectionWrapper1>.class);
        //Map<String, Id> connectionIdToProductIdMap = new map<String, Id>();
        //for(connectionWrapper1 temp : WrapLis){
        //    connectionIdToProductIdMap.put(temp.connectionId, Id.valueOf(temp.ProductId));
        //    //Decimal eav = Decimal.valueOf(temp.eav);
        //    if(connectionIdToOpportunityLineItemMap.get(temp.connectionId) == null){
        //        OpportunityLineItem newOli = new OpportunityLineItem();
        //        connectionIdToOpportunityLineItemMap.put(temp.connectionId, newOli);
        //    }
        //    connectionIdToOpportunityLineItemMap.get(temp.connectionId).EAV__c = temp.eav;
        //}
        //cntrl.connectionIdToProductIdMap = connectionIdToProductIdMap;
        //cntrl.connectionIdToOpportunityLineItemMap = connectionIdToOpportunityLineItemMap;
        //cntrl.save();
    //    return 'success';
    //}
    
/**
* Wrapper to store the connection details
**/    
    
    //public class connectionWrapper{
    //    @AuraEnabled
    //    public ConnectionSearchListener connectionSearchListener {get; set;}
    //    @AuraEnabled
    //    public Connection__c connection {get; set;}
    //    @AuraEnabled
    //    public Boolean selected {get; set;}
    //    @AuraEnabled
    //    public String utilityType {get; set;}
    //    @AuraEnabled
    //    public String connectionName {get; set;}
        
    //} 

/**
* Wrapper to store the opportunitylineitem details
**/     
    //public class oliWrapper{ 
    //    @AuraEnabled
    //    public OpportunityLineItem opptyline{get; set;}
    //}

/**
* Wrapper to store the eav details
**/     
    //public class eavQA{
    //    @AuraEnabled
    //    public String question {get;set;}
    //    @AuraEnabled
    //    public String answer {get;set;}
    //}
    
}