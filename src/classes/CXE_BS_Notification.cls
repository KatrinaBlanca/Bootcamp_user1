@RestResource(urlMapping='/notification')
global with sharing class CXE_BS_Notification  {

    @HttpPost
    global static Task post(String tid, Boolean read, Boolean del){
        Set<Id> target = new Set<Id>{UserInfo.getUserId()};
        User u = [
            SELECT ContactId 
            FROM User 
            WHERE Id in :target
        ];

        target.add(u.ContactId);

        List<Task> task = [
            SELECT Id, WhoId, Is_Deleted__c, Is_Read__c
            FROM Task 
            WHERE Id = :tid
                and (WhoId in :target or OwnerId in :target)
        ];
        Task t = null;

        if(task != null && task.size() > 0){
            t = task.get(0);

            if(del != null) t.Is_Deleted__c = del;
            if(read != null) t.Is_Read__c = read;

            update t;
        }

        return t;
    }
}