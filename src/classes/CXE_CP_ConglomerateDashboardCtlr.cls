public without sharing class CXE_CP_ConglomerateDashboardCtlr {
    //10-12-17 for conglomerate -SHAYNE 

    @AuraEnabled
    public static String getAccountIDofCurrentUser(){
        String ret = null;
        System.debug('CXE_CP_ConglomerateDashboardCtlr getAccountIDofCurrentUser START');
       	User userData = [SELECT LastLoginDate,FirstName,CXE_Auto_Enrolled_Services__c, AccountId, Account.Conglomerate__c, Account.Name
                                                    FROM User WHERE Id =:UserInfo.getUserId()];
       
        System.debug('getAccountIDofCurrentUser: UserId '+UserInfo.getUserId()+' :AccountId '+userData.AccountId+' :Conglomerate__c '+userData.Account.Conglomerate__c);
        if(userData.Account.Conglomerate__c) ret = userData.AccountId;
        return ret; 
    }
    
    //START R2C CSM-14832 Shayne 12/07/2017
    @AuraEnabled
    public static String getProfInfoModal(){
        return CXE_CP_Dashboard.getProfInfoModal();
    }
    //END R2C CSM-14832 Shayne 12/07/2017
    
}