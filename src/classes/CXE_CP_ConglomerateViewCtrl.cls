public with sharing class CXE_CP_ConglomerateViewCtrl {
    //10-20-17 for conglomerate -SHAYNE 

    @AuraEnabled
    public static boolean checkAccountIfConglomerate(String AccountId){
        System.debug('checkAccountIfConglomerate');
        boolean ret = false;
       	Account acountData = [SELECT id, Name, Conglomerate__c FROM Account where id=:AccountId];
       
        System.debug('checkAccountIfConglomerate :AccountId '+AccountId+' :Conglomerate__c '+acountData.Conglomerate__c);
        if(acountData.Conglomerate__c) ret = true;
        return ret; 
    }
   	
}