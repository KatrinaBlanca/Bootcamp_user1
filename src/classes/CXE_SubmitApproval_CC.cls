/* Description: CXE_Submit_Approval.cmp lightning component controller
* Author: Jerson Poblete
* Date Created: MAR-20-2017
*/
public without sharing class CXE_SubmitApproval_CC {

    //@AuraEnabled
    //public static String submitApproval(String caseId, String comments)
    //{
    //    system.debug(caseId+', '+comments);
    //    String checkApproval = '';
    //    List <Case> clist = [SELECT Id, GSL4_Check__c, Arrears_Check__c FROM Case WHERE Id = :caseId];
    //    For(Case c:clist){
    //        if(c.GSL4_Check__c){
    //            checkApproval = 'GSL4';
    //        } else if(c.Arrears_Check__c){
    //            checkApproval = 'Arrears';
    //        }
    //    }
    //    List<User> approverList = getglsApproverUserId(checkApproval);
    //    String dmlStatus = '';
    //    try{
    //        if(!approverList.isEmpty())
    //        {
    //            Id approver = approverList[0].id;
    //            approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    //            req1.setComments(comments);
    //            req1.setObjectId(caseId);           
    //            req1.setNextApproverIds(new Id[] {approver});
    //            approval.ProcessResult result = Approval.process(req1);
    //            Approval.unlock(caseId);
    //            system.debug(result);
    //            dmlStatus = 'Success';
    //        }
    //    }
    //    catch (Exception error)
    //    {
    //        dmlStatus = error.getDmlMessage(0);
    //        System.debug('Submit Approval error: '+error.getMessage());
    //    }
    //    system.debug('Status ' + dmlStatus);
    //    return dmlStatus;

    //}

    ///* 
    //* Description: get the list of approvers
    //* Parameters: N/A
    //* Returns: List of User
    //* Author: Jerson Poblete (Accenture)
    //* Date Created: MAR-10-17
    //*/ 
    ////get the list of approvers
    //@AuraEnabled

    //public static List<User> getglsApproverUserId(String checkApprovals)
    //{
    //    list<UserRole> ur1 = new List<UserRole>();
    //    list<UserRole> ur = new List<UserRole>();
    //    Id roleId;
    //    Id userId = UserInfo.getUserId();
    //    Map<String, String> roleApproverMap = new Map<String, String>();
    //    roleId = [select UserRoleId from User where Id = :userId].UserRoleId;

    //    //Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR].Id;
    //    Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
    //    Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;
    //        //check if the profile is meralco g4 
    //    if((UserInfo.getProfileId() == g4Id && checkApprovals == 'GSL4') 
    //      || (UserInfo.getProfileId() == g5Id && checkApprovals == 'Arrears') 
    //      || (UserInfo.getProfileId() == g4Id && checkApprovals == 'Arrears'))
    //    { 
    //            //one role up
    //        ur = [select Id, ParentRoleId, Name from UserRole WHERE Id = :roleId];
    //    }
    //    //check if the profile is meralgo g5
    //    else if(UserInfo.getProfileId() == g5Id && checkApprovals == 'GSL4')
    //    { 
    //        ur1 = [select Id, ParentRoleId, Name from UserRole WHERE Id = :roleId];
    //        ur = [select Id, ParentRoleId, Name from UserRole WHERE Id = :ur1[0].ParentRoleId];
    //    }

    //    for(UserRole rs :ur) 
    //    {
    //        if(rs.parentroleid != null){
    //            roleApproverMap.put(string.valueof(rs.Id),string.valueof(rs.ParentRoleId));
    //        }
    //    }
    //    system.debug('roleApproverMap>>>>>>>>' + roleApproverMap);
    //    List<User> userIdList = [Select Id, Name From User where UserRoleId IN :roleApproverMap.values() AND IsActive = true];
    //    system.debug('userId List' + userIdList);
    //    return userIdList;
    //}

    /* 
    * Description: create aproval process
    * Parameters: N/A    
    * Author: Jerome To (Accenture)
    * Date Created: MAY-09-17
    */ 
    //@AuraEnabled
    //public static String submitApproval(String caseId, String comments)
    //{   
    //    //List<User> approverList = getglsApproverList(caseList);
    //    Id approver = getApprover(caseId);
    //    String dmlStatus = '';
    //    try{
    //        if(approver != null) {
    //            Id approverId = approver;
    //            approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    //            req1.setComments(comments);
    //            req1.setObjectId(caseId);           
    //            req1.setNextApproverIds(new Id[] {approverId});
    //            approval.ProcessResult result = Approval.process(req1);
    //            Approval.unlock(caseId);
    //            system.debug(result);
    //            dmlStatus = 'Success';
    //        }else{
    //            dmlStatus = 'No Approver Found.';
    //        }
            
    //    }
    //    catch (Exception error) {
    //        dmlStatus = error.getDmlMessage(0);
    //        System.debug('Submit Approval error: '+error.getMessage());
    //    }
    //    system.debug('Status ' + dmlStatus);
    //    return dmlStatus;

    //}


    /* 
    * Description: create aproval process
    * Parameters: N/A    
    * Author: Jerome To (Accenture)
    * Date Created: MAY-09-17
    */ 
    @AuraEnabled
    public static String submitApproval(String caseId, String comments) {   
        //List<User> approverList = getglsApproverList(caseList);
        Id approver = getApprover(caseId);
        String dmlStatus = '';
        try{
            if(approver != null) {
                Id approverId = approver;
                approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments(comments);
                req1.setObjectId(caseId);           
                req1.setNextApproverIds(new Id[] {approverId});
                approval.ProcessResult result = Approval.process(req1);
                Approval.unlock(caseId);
                system.debug(result);
                dmlStatus = 'Success';
            }else{
                dmlStatus = 'No Approver Found.';
            }
            
        }
        catch (Exception error) {
            dmlStatus = error.getDmlMessage(0);
            System.debug('Submit Approval error: '+error.getMessage());
        }
        system.debug('Status ' + dmlStatus);
        return dmlStatus;
    }


    @TestVisible private static Approval.ProcessSubmitRequest createApproval(Id caseId, String comments, String approvalProcessName, Id approverId) { //START/END CSM-12409 RReyes SEP-05-17 - added @TestVisible
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments(comments);
        req.setObjectId(caseId);
        if(approverId != null) {
            req.setNextApproverIds(new List<Id> { approverId });
        }           
        req.setProcessDefinitionNameOrId(approvalProcessName);
        //req.setSkipEntryCriteria(true);
        return req;
        //approval.ProcessResult result = Approval.process(req);
        //Approval.unlock(caseId);
    }

    @TestVisible private static Map<String, Id> getMapForApproverIds(Case caseRecord) {  //START/END CSM-12409 RReyes SEP-05-17 - added @TestVisible      
        Map<String, Id> approverIdMap = new Map<String, Id>();
        Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
        Id approverId = null;
        List<User> approvers1 = new List<User>();
        List<User> approvers2 = new List<User>();
        
        User currentUser = [SELECT Office__c, UserRole.ParentRoleId
                            FROM User 
                            WHERE Id = :UserInfo.getUserId()];


        //if (caseRecord.GSL4_Check__c && caseRecord.CXE_Request_GSL4_TargetDate_Modification__c) {
        List<Office__c> parentROList = [SELECT Parent_RO__r.Name FROM Office__c WHERE Name=:currentUser.Office__c LIMIT 1];
        if(!parentROList.isEmpty()) {
            approvers1 = [SELECT Id FROM User WHERE Office__c =:parentROList.get(0).Parent_RO__r.Name AND ProfileId =:g3Id LIMIT 1];
            if(!approvers1.isEmpty()) {
                approverIdMap.put(CXE_Constants.CASE_REQUEST_GSL4_TARGET_DATE_MODIFICATION, approvers1.get(0).Id);
            }
        }
        
        //}

        //if ((caseRecord.Arrears_Check__c && caseRecord.CXE_Request_for_Lifting_of_Arrears_Tag__c) || caseRecord.Override_Auto_Deposit_Amount__c ||                   
        //           caseRecord.CXE_Request_for_Application_Cancellation__c ||
        //           caseRecord.CXE_Request_for_Change_in_Name__c) {
        approvers2 = [SELECT Id FROM User WHERE Office__c =:currentUser.Office__c AND UserRoleId =:currentUser.UserRole.ParentRoleId LIMIT 1];
        if(!approvers2.isEmpty()) {
            approverIdMap.put(CXE_Constants.CASE_REQUEST_FOR_LIFTING_OF_ARREARS_TAG, approvers2.get(0).Id);
        }
        //}
        
        return approverIdMap;            
    }
    
    @TestVisible private static Id getApprover(String caseId) { //START/END CSM-12409 RReyes SEP-05-17 - added @TestVisible
        List<Case> caseList = [SELECT Id, GSL4_Check__c, Arrears_Check__c FROM Case WHERE Id = :caseId AND (GSL4_Check__c = true OR Arrears_Check__c = true)];
        Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
        Id approverId = null;
        List<User> approvers = new List<User>();
        if(!caseList.isEmpty()) {
            User currentUser = [SELECT Office__c, UserRole.ParentRoleId
                                FROM User 
                                WHERE Id = :UserInfo.getUserId()];
                                
            //Rhyan Cruz CSM 2158 get ParentRO from Office of current user
            String ParentRO = [SELECT Parent_RO__c FROM Office__c where Name = :currentUser.Office__c LIMIT 1].Parent_RO__c;
            String ParentROName = [SELECT Name FROM Office__c where Id = :ParentRO ].Name;

            if (caseList.get(0).GSL4_Check__c) {
                if (ParentRO != null) {
                    approvers = [SELECT Id FROM User WHERE Office__c =:ParentROName AND ProfileId =:g3Id LIMIT 1];
                }
            } else {
                approvers = [SELECT Id FROM User WHERE Office__c =:currentUser.Office__c AND UserRoleId =:currentUser.UserRole.ParentRoleId]; 
            }

            if(!approvers.isEmpty()) {
                approverId = approvers.get(0).Id;
            }
            return approverId;            
        }
        return approverId;
    }
    
    /* 
    * Description: get case details
    * Parameters: N/A    
    * Author: Rom Edison Reyes (Accenture)
    * Date Created: MAY-17-17
    */ 
    @AuraEnabled
    public static Case getCaseDetails(String caseId)
    {   
        Case caseRec = [Select Id, GSL4_Check__c, Status FROM Case WHERE Id=: caseId LIMIT 1];
        return caseRec;
    }
    
    /* 
    * Description: get user details
    * Parameters: N/A    
    * Author: Rom Edison Reyes (Accenture)
    * Date Created: MAY-17-17
    */ 
    @AuraEnabled
    public static User getUserDetails()
    {   
        User userRec = [SELECT Id, UserRoleId, Office__c FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        return userRec;
    }


    /* 
    * Description: get user details
    * Parameters: N/A    
    * Author: Jerome To (Accenture)
    * Date Created: MAY-17-17
    */ 
    @AuraEnabled
    public static String submitApprovalR2(String caseId, String comments)
    {   
        // Start CSM-11964 Von Pernicia
        String dmlStatus = '';
        try{
            List<Case> caseList = [SELECT Override_Auto_Deposit_Amount__c, CXE_Request_for_Lifting_of_Arrears_Tag__c, CXE_Request_GSL4_TargetDate_Modification__c,
                                      CXE_Request_for_Application_Cancellation__c, CXE_Request_for_Change_in_Name__c, GSL4_Check__c, Arrears_Check__c,
                                      CXE_G3_Approver__c, CXE_G4_Approver__c, Record_Type__c
                                   FROM Case 
                                   WHERE Id =:caseId];
            if(!caseList.isEmpty()) {

                if (caseList[0].Record_Type__c == CXE_Constants.CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION)
                {
                    dmlStatus = submitApproval(caseId, comments);

                    return dmlStatus; 
                }

                Map<String, Id> approverIdMap = getMapForApproverIds(caseList.get(0));
                Case caseRec = caseList.get(0);
                caseRec.CXE_G3_Approver__c = approverIdMap.get(CXE_Constants.CASE_REQUEST_GSL4_TARGET_DATE_MODIFICATION);
                caseRec.CXE_G4_Approver__c = approverIdMap.get(CXE_Constants.CASE_REQUEST_FOR_LIFTING_OF_ARREARS_TAG);
                caseRec.isUpdatedFromPB__c = true; //START/END CSM-12378 RReyes AUG-31-17 - set to true to exempt from validation
                update caseRec;

                Approval.ProcessSubmitRequest req = createApproval(caseList.get(0).Id, comments, CXE_Constants.CASE_APPROVAL_CXE_CASE_APPROVALS, null);
                List<Approval.ProcessResult> processResults = Approval.process(new List<Approval.ProcessSubmitRequest> { req }, true);
                for(Approval.ProcessResult result : processResults) {
                    if(result.isSuccess()) {
                        dmlStatus = 'Success';
                    } else {
                        dmlStatus += '~~~' + result.getErrors() + '~~~';
                    }                    
                }                
            }
        } catch (Exception error) {
            dmlStatus = error.getDmlMessage(0);
            System.debug('Submit Approval error: '+error.getMessage());
        }

        system.debug('Status ' + dmlStatus);
        return dmlStatus;
    }
    // End CSM-11964 Von Pernicia
}