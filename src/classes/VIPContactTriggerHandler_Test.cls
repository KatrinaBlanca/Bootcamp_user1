/* Description: VIPContactTriggerHandler test class
 * Author: Gavi Grandea
 * Date Created: JUN-28-17
 */
@isTest
private class VIPContactTriggerHandler_Test {


    /* Description: verify DML/SOQL limits for DML operations
     * Author: Gavi Grandea
     * Date Created: JUN-29-17
     */
    static testMethod void testDML(){
        insert CXE_TestDataFactory.createVIPContact(100);
        List<VIP_Contact__c> recList = [SELECT Id, OwnerId FROM VIP_Contact__c];
        for(VIP_Contact__c rec : recList){
            rec.First_Name__c = 'TEST1';
        }
        update recList;
        delete recList;
        undelete recList;
    }


    /* Description: verify manual sharing to owner's manager group on VIP Contact record creation
     * Author: Gavi Grandea
     * Date Created: JUN-29-17
     */
    static testMethod void testManualManagerSharing(){
        
        List<VIP_Contact__c> vipConList = CXE_TestDataFactory.createVIPContact(100);

        Test.startTest();

            insert vipConList;

        Test.stopTest();

        vipConList = [SELECT Id, OwnerId FROM VIP_Contact__c WHERE Id in: vipConList];

        Group managerGrp = [SELECT Id FROM Group WHERE RelatedId =: vipConList[0].OwnerId
                                                    AND Type =: CXE_Constants.GROUP_TYPE_MANAGER LIMIT 1];

        List<VIP_Contact__Share> vipContShareList = [SELECT Id,UserOrGroupId FROM VIP_Contact__Share 
                                                                WHERE ParentId in: vipConList
                                                                 AND UserOrGroupId =: managerGrp.Id
                                                                 AND RowCause =: Schema.VIP_Contact__Share.RowCause.Manual];

        List<Exception_Log__c> logs = [SELECT Id FROM Exception_Log__c];

        System.assertEquals(100, vipContShareList.size());
        System.assertEquals(managerGrp.Id, vipContShareList[0].UserOrGroupId);
        System.assertEquals(0, logs.size());
      
    }


    /* Description: verify manual sharing to owner's manager group on VIP Contact record 'owner' update
     * Author: Gavi Grandea
     * Date Created: JUN-29-17
     */
    static testMethod void testManualManagerSharingChangeOwner(){
        
        List<VIP_Contact__c> vipConList = CXE_TestDataFactory.createVIPContact(100);
            insert vipConList;

        vipConList = [SELECT Id, OwnerId FROM VIP_Contact__c WHERE Id in: vipConList];
        System.assert(vipConList[0].OwnerId!=null);

        User nextUser = CXE_TestDataFactory.createUser(1, 'System Administrator')[0];
            nextUser.ManagerId = vipConList[0].OwnerId;
            insert nextUser;

        Test.startTest();

            for(VIP_Contact__c vipC : vipConList){
                vipC.OwnerId = nextUser.Id;
            }
            update vipConList;

        Test.stopTest();

        Group firstUserMngrGrp = [SELECT Id FROM Group WHERE RelatedId =: UserInfo.getUserId()
                                                    AND Type =: CXE_Constants.GROUP_TYPE_MANAGER LIMIT 1];
        Group managerGrp = [SELECT Id FROM Group WHERE RelatedId =: vipConList[0].OwnerId
                                                    AND Type =: CXE_Constants.GROUP_TYPE_MANAGER LIMIT 1];

        List<VIP_Contact__Share> vipContShareList = [SELECT Id, UserOrGroupId FROM VIP_Contact__Share 
                                                                WHERE ParentId in: vipConList
                                                                 AND UserOrGroupId =: managerGrp.Id
                                                                 AND RowCause =: Schema.VIP_Contact__Share.RowCause.Manual];

        List<Exception_Log__c> logs = [SELECT Id FROM Exception_Log__c];

        System.assertEquals(100, vipContShareList.size());
        System.assertNotEquals(firstUserMngrGrp.Id, vipContShareList[0].UserOrGroupId);
        System.assertEquals(managerGrp.Id, vipContShareList[0].UserOrGroupId);
        System.assertNotEquals(firstUserMngrGrp.Id, vipContShareList[99].UserOrGroupId);
        System.assertEquals(managerGrp.Id, vipContShareList[99].UserOrGroupId);
        System.assertEquals(0, logs.size());
      
    }
}