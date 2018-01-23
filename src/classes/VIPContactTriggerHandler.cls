/* 
 * Description: Handles the logic for VIP Contact Trigger
 * Author: Gavi Grandea (Accenture)
 * Date Created: Jun-28-17
 */ 
 
public without sharing class VIPContactTriggerHandler implements TriggerInterface {

    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c triggerControl = TriggerControl__c.getInstance();
        return triggerControl.VIP_Contact__c;
    }

    public void BeforeInsert(List<SObject> newList) {
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){
        
        Map<id, VIP_Contact__c> newMaps = (Map<id, VIP_Contact__c>)newMap;
        
        shareRecordWithManagers(newMaps.values(), null);
    }

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Map<id, VIP_Contact__c> newMaps = (Map<id, VIP_Contact__c>)newMap;
        Map<id, VIP_Contact__c> oldMaps = (Map<id, VIP_Contact__c>)oldMap;
        shareRecordWithManagers(newMaps.values(), oldMaps);
    }
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){}   



//START CSM-7202 GGrandea JUN-28-17   
/* 
 * Description: Add access of VIP Contact Records using Manager Groups
 * Parameters: List<VIP_Contact__c> newVIPContactList, Map<Id, VIP_Contact__c> oldMap
 * Returns: N/A
 * Author: GGrandea (Accenture)
 * Date Created: JUN-27-17
*/  
    public void shareRecordWithManagers(List<VIP_Contact__c> newVIPContactList, Map<Id, VIP_Contact__c> oldMap){

        try {
            Set<Id> userIds = new Set<Id>();
            Map<Id, Group> groupMap = new Map<Id, Group>();

            for(VIP_Contact__c vipc : newVIPContactList){
                if(oldMap==null){ //if on create
                    userIds.add(vipc.OwnerId);
                }
                else{ // if update
                    if(oldMap.get(vipc.Id).OwnerId != vipc.OwnerId){    //only share if record owner is changed
                        userIds.add(vipc.OwnerId);
                    }
                }
            }

            
            if(userIds.size()>0){

                for(Group grp : [SELECT Id, RelatedId FROM Group 
                                                    WHERE RelatedId in: userIds 
                                                     AND Type =: CXE_Constants.GROUP_TYPE_MANAGER]){
                    groupMap.put(grp.RelatedId, grp);
                }

                if(!groupMap.isEmpty()){
                    List<VIP_Contact__Share> vipContactShareList = new List<VIP_Contact__Share>();
                    VIP_Contact__Share vShare;
                    String rowCauseManual = Schema.VIP_Contact__Share.RowCause.Manual; //CSM-14144 10.27.2017
                    for(VIP_Contact__c vipc : newVIPContactList){

                        if(groupMap.containsKey(vipc.OwnerId)){

                            //grant view/edit access to Manager Group
                            vShare  = new VIP_Contact__Share();
                            vShare.ParentId = vipc.Id;
                            vShare.UserOrGroupId = groupMap.get(vipc.OwnerId).Id;
                            vShare.AccessLevel = CXE_Constants.SHARE_ACCESS_LEVEL_EDIT;
                            //vShare.RowCause = Schema.VIP_Contact__Share.RowCause.Manual; //CSM-14144 10.27.2017
                            vShare.RowCause = rowCauseManual; //CSM-14144 10.27.2017
                            vipContactShareList.add(vShare);
                        }
                    }

                    if(!vipContactShareList.isEmpty()){
                        insert vipContactShareList;
                    }                
                }
            }
        } catch (Exception error){ 
            ErrorHandlerException.recordException(null, true, 'VIPContactTriggerHandler', 'shareRecordWithManagers', error.getMessage());
        }

    }
//END CSM-7202 GGrandea JUN-28-17  
    
}