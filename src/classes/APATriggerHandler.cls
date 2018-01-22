/* 
 * Description: Handles the logic for APA Trigger
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: NOV-05-17
 */ 
public class APATriggerHandler implements TriggerInterface {

    public void BeforeInsert(List<SObject> newList) {
        List<Auto_Payment_Arrangement__c> newLists = (List<Auto_Payment_Arrangement__c>)newList;
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<id, Auto_Payment_Arrangement__c> newMaps = (Map<id, Auto_Payment_Arrangement__c>)newMap;
        Map<id, Auto_Payment_Arrangement__c> oldMaps = (Map<id, Auto_Payment_Arrangement__c>)oldMap;
        updateLastDownloadDate(newMaps, oldMaps);
        //START CSM-13174 RReyes NOV-09-17
        updateStatusToDeleted(newMaps, oldMaps);
        //END CSM-13174 RReyes NOV-09-17
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){}

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<id, Auto_Payment_Arrangement__c> newMaps = (Map<id, Auto_Payment_Arrangement__c>)newMap;
        Map<id, Auto_Payment_Arrangement__c> oldMaps = (Map<id, Auto_Payment_Arrangement__c>)oldMap;
        //START CSM-13174 RReyes NOV-09-17
        checkFoldersForPurging(newMaps, oldMaps);
        //END CSM-13174 RReyes NOV-09-17
    }
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}   

    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        TriggerControl__c apaControl = TriggerControl__c.getInstance();
        return apaControl.Auto_Payment_Arrangement__c;
    }
    
    public void updateLastDownloadDate(Map<id, Auto_Payment_Arrangement__c> newAPAMap, Map<id, Auto_Payment_Arrangement__c> oldAPAMAP){
         for(Auto_Payment_Arrangement__c apaRec: newAPAMap.values()){
             Auto_Payment_Arrangement__c oldApa = oldAPAMAP.get(apaRec.Id);
             if(apaRec.Status__c == 'Downloaded' && oldApa.Status__c != 'Downloaded'){
                 apaRec.Last_Downloaded_Time__c = System.now();
             }
         }
    }

    //START CSM-13174 RReyes NOV-09-17
    public void updateStatusToDeleted(Map<id, Auto_Payment_Arrangement__c> newAPAMap, Map<id, Auto_Payment_Arrangement__c> oldAPAMAP){
         for(Auto_Payment_Arrangement__c apaRec: newAPAMap.values()){
             Auto_Payment_Arrangement__c oldApa = oldAPAMAP.get(apaRec.Id);
             if(apaRec.CXE_isForPurging__c && !oldApa.CXE_isForPurging__c){
                 apaRec.Status__c = 'Deleted';
             }
         }
    }

    public void checkFoldersForPurging(Map<id, Auto_Payment_Arrangement__c> newAPAMap, Map<id, Auto_Payment_Arrangement__c> oldAPAMAP){
        Set<String> foldersToPurge = new Set<String>();
         for(Auto_Payment_Arrangement__c apaRec: newAPAMap.values()){
             Auto_Payment_Arrangement__c oldApa = oldAPAMAP.get(apaRec.Id);
             if(apaRec.CXE_isForPurging__c && !oldApa.CXE_isForPurging__c){
                 if(apaRec.Date__c != null){
                    DateTime folderDate = apaRec.Date__c;
                    String folderName = folderDate.format('MMddyyyy');
                    foldersToPurge.add(folderName);
                 }
             }
         }

         if(!foldersToPurge.isEmpty()){
            autoPurge(foldersToPurge);
         }
    }

    @future(callout = true)
    public static void autoPurge(Set<String> folderNames){
        for(String folderName: folderNames){
            try{
                String res = CXE_HerokuApps.apa_delete(folderName);
            }catch(Exception e){
                ErrorHandlerException.recordException(null, true, 'APATriggerHandler', 'autoPurge', e.getMessage());
            }
        }
    }
    //END CSM-13174 RReyes NOV-09-17
    
}