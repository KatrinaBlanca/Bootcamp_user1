/**
 * @author Aard-Jan van Kesteren
 * @group Test
 * @description Test class for PublishNotificationControllerExt.
 */
@isTest()
private class PublishNotificationControllerExtTest {

    //private static final Id ORGANIZATION_GROUP_ID = 
    //    [select Id from Group where Type = 'Organization' limit 1][0].Id;
    
    //@isTest
    //static void testGroupSelectOptions() {
    //    Notification__c notification = TestDataFactoryTest.createNotification(false);
        
    //    ApexPages.StandardController stdController = new ApexPages.StandardController(notification);
    //    PublishNotificationControllerExt controllerExt = new PublishNotificationControllerExt(stdController);
        
    //    Boolean found = false;
    //    for (SelectOption selectOption: controllerExt.groupSelectOptions) {
    //        if (selectOption.getValue() == ORGANIZATION_GROUP_ID) {
    //            found = true;
    //            System.assertEquals('All', selectOption.getLabel());
    //        }
    //    }
    //    // It should always be the case that the group select options contain the all option
    //    System.assert(found);
    //}
    
    //@isTest
    //static void testPublish() {
    //    Notification__c notification = TestDataFactoryTest.createNotification(false);
        
    //    ApexPages.StandardController stdController = new ApexPages.StandardController(notification);
    //    PublishNotificationControllerExt controllerExt = new PublishNotificationControllerExt(stdController);
        
    //    System.Test.startTest();
    //    // Select the all option
    //    controllerExt.GroupId = ORGANIZATION_GROUP_ID;
    //    // And now publish
    //    PageReference pageRef = controllerExt.publish();
    //    System.Test.stopTest();
        
    //    // The page ref should not be null
    //    System.assertNotEquals(null, pageRef);
        
    //    // Refresh the notification
    //    notification = [select Status__c from Notification__c where Id = :notification.Id limit 1][0];
        
    //    // Status should now be published
    //    System.assertEquals(Constants.NOTIFICATION_STATUS_PUBLISHED, notification.Status__c);
        
    //    // At least for the current user a user notification with status new should be created
    //    Boolean found = false;
    //    for (User_Notification__c userNot: [
    //        select User__c, Status__c from User_Notification__c
    //        where Notification__c = :notification.Id
    //    ]) {
    //        if (userNot.User__c == UserInfo.getUserId()) {
    //            found = true;
    //            System.assertEquals(Constants.USER_NOTIFICATION_STATUS_NEW, userNot.Status__c);
    //        }
    //    }
    //    System.assert(found);
    //}
    
    //@isTest
    //static void testPublishWithoutGroupIdSelected() {
    //    Notification__c notification = TestDataFactoryTest.createNotification(false);
        
    //    ApexPages.StandardController stdController = new ApexPages.StandardController(notification);
    //    PublishNotificationControllerExt controllerExt = new PublishNotificationControllerExt(stdController);
        
    //    System.Test.startTest();
    //    // Publish without having a group selected
    //    PageReference pageRef = controllerExt.publish();
    //    System.Test.stopTest();        
        
    //    // pageRef should be null now, as a validation exception should have ocurred. 
    //    System.assertEquals(null, pageRef);
    //    // And there should be an exception message
    //    System.assert(!ApexPages.getMessages().isEmpty());
    //}

    //@isTest
    //static void testPublishForAlreadyPublishedNotification() {
    //    Notification__c notification = TestDataFactoryTest.createNotification(true);
        
    //    ApexPages.StandardController stdController = new ApexPages.StandardController(notification);
    //    PublishNotificationControllerExt controllerExt = new PublishNotificationControllerExt(stdController);
        
    //    System.Test.startTest();
    //    // Select the all option
    //    controllerExt.GroupId = ORGANIZATION_GROUP_ID;        
    //    // Publish without having a group selected
    //    PageReference pageRef = controllerExt.publish();
    //    System.Test.stopTest();        
        
    //    // pageRef should be null now, as a validation exception should have ocurred. 
    //    System.assertEquals(null, pageRef);
    //    // And there should be an exception message
    //    System.assert(!ApexPages.getMessages().isEmpty());
    //}    
    
    //@isTest
    //static void testCancel() {
    //    Notification__c notification = TestDataFactoryTest.createNotification(false);
        
    //    ApexPages.StandardController stdController = new ApexPages.StandardController(notification);
    //    PublishNotificationControllerExt controllerExt = new PublishNotificationControllerExt(stdController);
        
    //    // The cancel button should return a not null page reference
    //    System.assertNotEquals(null, controllerExt.cancel());
    //}

}