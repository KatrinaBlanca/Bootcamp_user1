/* 
 * Description: Handles the logic for User Trigger
 * Author: Gavi Grandea (Accenture)
 * Date Created: JUL-24-17
 */ 
public without sharing class UserTriggerHandler implements TriggerInterface //CSM-12552 set to without sharing
{
    Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;

    //Checks to see if the trigger has been disabled either by custom setting or by running code
    public Boolean IsDisabled() {
        //Added trigger control from heirarchy custom setting
        TriggerControl__c caseControl = TriggerControl__c.getInstance();
        return caseControl.User__c;
    }

    public void BeforeInsert(List<SObject> newList) {
        List<User> newLists = (List<User>)newList;
        //validateBizPortalUser(newLists);

        applyPortalUserByPassValidation(newLists); //CSM-13934 10.17.2017
    } 
    
    public void BeforeUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        
        Map<id, User> newMaps = (Map<id, User>)newMap;
        Map<id, User> oldMaps = (Map<id, User>)oldMap;
    }
    
    public void BeforeDelete(Map<Id, SObject> oldMap){}

    public void AfterInsert(Map<Id, SObject> newMap){
        Map<id, User> newMaps = (Map<id, User>)newMap;
        autoEnrollSiblingServices(newMaps.values());
        //START CSM-12168 RReyes AUG-04-17        
        //START CSM-14074 Jayson Sarion - made future method NOV-06-17
        updatePortalUserContact(newMaps.keySet());
        //END CSM-14074 Jayson Sarion - made future method NOV-06-17
        //END CSM-12168 RReyes AUG-04-17
    }

    public void AfterUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) 
    {
        Map<id, User> newMaps = (Map<id, User>)newMap;
        Map<id, User> oldMaps = (Map<id, User>)oldMap;
    
       
    }
    
    public void AfterDelete(Map<Id, SObject> oldMap){}

    public void AfterUndelete(Map<Id, SObject> oldMap){} 


      
    /* 
    * Description: Throw an error if related Account of User in context has 2 or more Portal Users already
    * Parameters: newList
    * Returns: N/A
    * Author: Gavi Grandea (Accenture)
    * Date Created: JUL-24-17
    */  
    /*public void validateBizPortalUser(List<User> newList){

        Set<Id> contactIds = new Set<Id>();
        Map<Id, Set<Id>> acctUserCntMap = new Map<Id, Set<Id>>();
        Map<Id, Id> userIdContactIdMap = new Map<Id, Id>();
        Map<Id, Id> conIdAcctIdMap = new Map<Id, Id>();

        for(User user : newList){
            if(user.ProfileId == portalCommProfId){
                contactIds.add(user.ContactId);
                userIdContactIdMap.put(user.Id, user.ContactId);
            }
        }

        if(!contactIds.isEmpty()){

            List<Contact> contactList = [SELECT AccountId 
                                            FROM Contact
                                             WHERE Id in: contactIds
                                             AND ( IsPersonAccount = true OR
                                                     (Account.RecordType.DeveloperName = 'CXE_Business_Account' 
                                                        AND Account.Conglomerate__c = false)
                                                        )
                                                     ];

            Set<Id> accountIds = new Set<Id>();
            for(Contact con : contactList){
                accountIds.add(con.AccountId);
                conIdAcctIdMap.put(con.Id, con.AccountId);
            }

            if(!accountIds.isEmpty()){
                List<Account> accountList = [SELECT Id
                                                , (SELECT Id
                                                    FROM Contracts) 
                                                FROM Account WHERE Id in: accountIds];

                Set<Id> contractIds = new Set<Id>();                                
                
                for(Account acct: accountList){
                    for(Contract contract : acct.Contracts){
                        contractIds.add(contract.Id);
                    }
                }

                Set<Id> userIdsTemp;

                if(!contractIds.isEmpty()){
                    List<Agreement__c> agrList = [SELECT Id
                                                    , (SELECT Id, CXE_UserId__c, CXE_ServiceId__c
                                                    , CXE_ServiceId__r.Payor__r.AccountId
                                                        FROM Service_Enrollments__r) 
                                                    FROM Agreement__c WHERE Payor__c in: contractIds];
                    for(Agreement__c agr : agrList){
                        for(CXE_Service_Enrollment__c servEnrl : agr.Service_Enrollments__r){
                            if(acctUserCntMap.containsKey(servEnrl.CXE_ServiceId__r.Payor__r.AccountId)){
                                userIdsTemp = acctUserCntMap.get(servEnrl.CXE_ServiceId__r.Payor__r.AccountId);
                            }else{
                                userIdsTemp = new Set<Id>();
                            }
                            userIdsTemp.add(servEnrl.CXE_UserId__c);

                            acctUserCntMap.put(servEnrl.CXE_ServiceId__r.Payor__r.AccountId, userIdsTemp);
                        }
                    }
                }
            }
        }

        for(User user : newList){
            if( userIdContactIdMap.get(user.Id) != null
                && conIdAcctIdMap.get(userIdContactIdMap.get(user.Id)) != null
                && acctUserCntMap.get(conIdAcctIdMap.get(userIdContactIdMap.get(user.Id))) != null 
                && acctUserCntMap.get(conIdAcctIdMap.get(userIdContactIdMap.get(user.Id))).size() >= 2 ){

                    user.addError('Portal User Limit exceeded for Account record.');
            }
        }

    }*/

      
    /* 
    * Description: Auto-enroll services when Portal User is manually created
    * Parameters: newList
    * Returns: N/A
    * Author: Gavi Grandea (Accenture)
    * Date Created: JUL-24-17
    */  
    public void autoEnrollSiblingServices(List<User> newList){

        Set<Id> contactIds = new Set<Id>();
        Set<String> serviceNumbers = new Set<String>(); // CSM-13904 20171014
        Map<Id, List<Agreement__c>> acctAgreemntListMap = new Map<Id, List<Agreement__c>>();
        Map<Id, Id> userIdContactIdMap = new Map<Id, Id>();
        Map<Id, Id> conIdAcctIdMap = new Map<Id, Id>();


        // START CSM-13895 Jerome To Portal Account is tag as Non-Payor when registering a CBG or BIZ/SME services.
        Set<String> codeSegmentFilter = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP001, CXE_Constants.SERVICE_CODE_SEGMENT_1, CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP003, CXE_Constants.SERVICE_CODE_SEGMENT_3};
        // END CSM-13895 Jerome To Portal Account is tag as Non-Payor when registering a CBG or BIZ/SME services.

        for(User user : newList){
            if(user.ProfileId == portalCommProfId){
                contactIds.add(user.ContactId);
                userIdContactIdMap.put(user.Id, user.ContactId);
                serviceNumbers.add(user.Initial_Service_ID__c);
            }
        }

        if(!contactIds.isEmpty()){
            

            List<Contact> contactList = [SELECT AccountId 
                                            FROM Contact
                                             WHERE Id in: contactIds
                                             AND ( /*IsPersonAccount = true OR*/
                                                     (Account.RecordType.DeveloperName =: CXE_Constants.ACCOUNT_RECORD_TYPE_CXE_BUSINESS_ACCOUNT) ) ];

            Set<Id> accountIds = new Set<Id>();
            for(Contact con : contactList){
                accountIds.add(con.AccountId);
                conIdAcctIdMap.put(con.Id, con.AccountId);
            }

            if(!accountIds.isEmpty()){
                // CSM-13904 20171014 : get contract id of registered service
                Set<Id> userRegisterContactIds = new Set<Id> ();
                for(Agreement__c item: [SELECT Id, Payor__r.Id FROM Agreement__c WHERE sin__c = :serviceNumbers]){
                    if(item.Payor__r.Id != null){
                        userRegisterContactIds.add(item.Payor__r.Id);
                    }
                }

                List<Account> accountList = [SELECT Id
                                                , (SELECT Id
                                                    FROM Contracts) 
                                                FROM Account WHERE Id in: accountIds];

                Set<Id> contractIds = new Set<Id>();                                
                
                for(Account acct: accountList){
                    for(Contract contract : acct.Contracts){
                        if(userRegisterContactIds.contains(contract.Id)){ // CSM-13904 20171014
                            contractIds.add(contract.Id);
                        }
                    }
                }

                List<Agreement__c> agreementListTemp;

                if(!contractIds.isEmpty()){
                    // START CSM-13895 Jerome To Portal Account is tag as Non-Payor when registering a CBG or BIZ/SME services.
                    // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/17
                    for(Agreement__c agr : [SELECT Id, Payor__r.AccountId, Payor__r.Account.Name, Code_Segment__c, Payor__r.Account.IsPersonAccount,
                                                    sin__c
                                            FROM Agreement__c 
                                            WHERE Payor__c in: contractIds 
                                                //START CSM-13904 10.14.2017
                                            AND (Code_Segment__c =: CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP002
                                                    OR Code_Segment__c =: CXE_Constants.SERVICE_CODE_SEGMENT_2) 
                                                //END CSM-13904 
                                            //AND Service_Status__c =: CXE_Constants.SERVICE_STATUS_ACTIVE]){ //13983 GGrandea 10.19.2017
                                            AND Service_Status__c !=: CXE_Constants.SERVICE_STATUS_PENDING]){ //13983 GGrandea 10.19.2017
                    // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/17
                    // END CSM-13895 Jerome To Portal Account is tag as Non-Payor when registering a CBG or BIZ/SME services.
                        if(acctAgreemntListMap.containsKey(agr.Payor__r.AccountId)){
                            agreementListTemp = acctAgreemntListMap.get(agr.Payor__r.AccountId);
                        }else{
                            agreementListTemp = new List<Agreement__c>();
                        }
                        agreementListTemp.add(agr);
                        acctAgreemntListMap.put(agr.Payor__r.AccountId, agreementListTemp);
                    }
                }
            }
        }

        List<CXE_Service_Enrollment__c> enrollmentsToInsert = new List<CXE_Service_Enrollment__c>();
        for(User user : newList){
            if( userIdContactIdMap.get(user.Id) != null
                && conIdAcctIdMap.get(userIdContactIdMap.get(user.Id)) != null
                && acctAgreemntListMap.get(conIdAcctIdMap.get(userIdContactIdMap.get(user.Id))) != null 
                && acctAgreemntListMap.get(conIdAcctIdMap.get(userIdContactIdMap.get(user.Id))).size() > 0 ){
                    // START CSM-13895 Jerome To Portal Account is tag as Non-Payor when registering a CBG or BIZ/SME services.
                    // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/17
                    for(Agreement__c agreemnt : acctAgreemntListMap.get(conIdAcctIdMap.get(userIdContactIdMap.get(user.Id)))){     
                        if(isRegisteredNameSameAsAccountName(user, agreemnt) || agreemnt.sin__c == user.Initial_Service_Id__c){ // CSM-13911 20171015: LISEN only if Payor then auto-enroll
                            enrollmentsToInsert.add( 
                                new CXE_Service_Enrollment__c( CXE_UserId__c=user.Id, 
                                                                CXE_ServiceId__c=agreemnt.Id,
                                                                CXE_IsActive__c=true,
                                                                CXE_CreatedforRegistration__c=true, //CSM-13749 10.12.2017
                                                                CXE_Type__c=( (!agreemnt.Payor__r.Account.IsPersonAccount && codeSegmentFilter.contains(agreemnt.Code_Segment__c) ) ? CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR : ((isRegisteredNameSameAsAccountName(user, agreemnt)) ? CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR : CXE_Constants.SERVICE_ENROLLMENT_TYPE_NON_PAYOR) )));
                        }
                    }
                    // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/17
                    // END CSM-13895 Jerome To Portal Account is tag as Non-Payor when registering a CBG or BIZ/SME services.
            }
        }

        if(!enrollmentsToInsert.isEmpty()){
            insert enrollmentsToInsert;
        }

    }

    /* 
    * Description: CSM-12168 Update CXE_isPortalContact__c upon insert of Portal User
    * Parameters: newList
    * Returns: N/A
    * Author: Rom Edison Reyes (Accenture)
    * Date Created: AUG-04-17
    */  
    //START CSM-14074 Jayson Sarion - made future method NOV-06-17
    /* moved creation of task from Process builder to trigger based on INDIV/BIZ */
    @future
    public static void updatePortalUserContact(Set<Id> newIdSet){
        Set<Id> contactIds = new Set<Id>();
        Map<Id, User> contactIdUserMap = new Map<Id, User>();
        List<User> newList = new List<User>();
        List<Task> newTaskList = new List<Task>();

        if(!newIdSet.isEmpty()) {
            newList = [SELECT Id, ContactId, MobilePhone, Suffix, MiddleName, EMail, Contact.Account.OwnerId, Contact.AccountId, IsPortalEnabled, Contact.IsPersonAccount,
                            CXE_SelfRegistredUser__c
                       FROM User 
                       WHERE ID IN :newIdSet];
        }

        for(User u: newList){
            if(u.ContactId != null){
                contactIds.add(u.ContactId);
                contactIdUserMap.put(u.ContactId, u);

                if(u.IsPortalEnabled && !u.CXE_SelfRegistredUser__c) {
                    Task newTask = new Task();
                    newTask.ActivityDate = date.Today();
                    newTask.Notification_Channel__c = 'Email';
                    newTask.Notification_Type__c = 'Service Application';
                    newTask.OwnerId = u.Contact.Account.OwnerId;
                    newTask.Priority = 'Normal';
                    newTask.Status = 'Completed';
                    newTask.Subject = 'Meralco Online Email Verification';
                    newTask.WhatId = u.Contact.AccountId;
                    //Start CSM-14807 GSerrano
                    newTask.WhoId = u.ContactId;
                    //ENd CSM-14807 GSerrano
                    newTaskList.add(newTask);
                }
            }
        }

        if(!contactIds.isEmpty()){
            List<Contact> contactToUpdate = [SELECT Id, IsPersonAccount FROM Contact 
                                                WHERE Id in: contactIds ];
                                                //AND CXE_isPortalContact__c = false]; //CSM-12863 GGrandea 09.21.2017 disabled

            if(contactToUpdate != null){
                if(contactToUpdate.size() > 0){
                    for(Contact c : contactToUpdate){
                        c.CXE_isPortalContact__c = true;
                        c.Billing_Notification__c = CXE_Constants.PORTALUSER_NOTIF_EMAIL;
                        c.Payment_Confirmation_Notification__c = CXE_Constants.PORTALUSER_NOTIF_EMAIL;
                        c.Payment_Reminders__c = CXE_Constants.PORTALUSER_NOTIF_EMAIL;
                        c.Outages_Notification__c = CXE_Constants.PORTALUSER_NOTIF_SMS;
                        c.MobilePhone = contactIdUserMap.get(c.Id).MobilePhone;
                        c.Mobile_1__c = contactIdUserMap.get(c.Id).MobilePhone; //12863 GGrandea 09.21.2017
                        //c.Suffix = contactIdUserMap.get(c.Id).Suffix; //CSM-12552 disabled GGrandea 09.15.2017
                        //c.MiddleName = contactIdUserMap.get(c.Id).MiddleName; //CSM-12552 disabled GGrandea 09.15.2017
                        c.Email = contactIdUserMap.get(c.Id).Email; //CSM-12552 overwrite Contact email during registration
                    }

                    try{
                        update contactToUpdate;
                    }catch(Exception e){
                        ErrorHandlerException.recordException(null, true, 'UserTriggerHandler', 'updatePortalUserContact', e);
                    }
                }
            }
        }
        system.debug('>>>>>newTaskList ' + newTaskList);
        if(!newTaskList.isEmpty()) {
            insert newTaskList;
        }
    }
    /* moved creation of task from Process builder to trigger based on INDIV/BIZ */
    //END CSM-14074 Jayson Sarion - made future method NOV-06-17
    
	@TestVisible
    private Boolean isRegisteredNameSameAsAccountName(User user, Agreement__c service) {
       
       List<String> userName = new List<String>();

        if(String.isNotBlank(user.firstname)) {
            userName.add(user.firstname);
        } 

        if(String.isNotBlank(user.middlename)) {
            userName.add(user.middlename);
        } 

        if(String.isNotBlank(user.lastname)) {
            userName.add(user.lastname);
        } 
       
       return String.join(userName, ' ').equalsIgnoreCase(service.Payor__r.Account.Name);
    }
    
    

    /* 
    * Description: CSM-13934 Set the By_Pass_Validation__c to TRUE for portal users
    * Parameters: newList
    * Returns: N/A
    * Author: GGrandea (Accenture)
    * Date Created: OCT-17-2017
    */  
    private void applyPortalUserByPassValidation(List<User> newList){

        for(User user : newList){
            if(user.ProfileId == portalCommProfId){
                user.By_Pass_Validation__c = True;
            }
        }
    } //END CSM-13934
    
    
   
    
    
}