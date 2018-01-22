/**
 * @author Aard-Jan van Kesteren
 * @group Test
 * @description Test class for NotificationsComponentController.
 */
@isTest
private class NotificationsComponentControllerTest {

    @isTest
    static void testRefreshUserNotificationAndGetHasUserNotification() {
        NotificationsComponentController controller = new NotificationsComponentController();
        
        // No data has been created yet. Assert that the user does not yet have
        // a user notification.
        controller.refreshUserNotification();
        System.assertEquals(null, controller.userNotification);
        System.assert(!controller.HasUserNotification);
        
        // Setup a Draft notification and user notification. Still the user should not yet have
        // a user notification.
        Notification__c notification = TestDataFactoryTest.createNotification(false);
        User_Notification__c userNot = TestDataFactoryTest.createUserNotification(notification);
        
        controller.refreshUserNotification();
        System.assertEquals(null, controller.userNotification);
        System.assert(!controller.HasUserNotification);

        // Now publish the notification. Now the user should have a user notification.
        notification.Status__c = Constants.NOTIFICATION_STATUS_PUBLISHED;
        update notification;

        controller.refreshUserNotification();
        System.assertEquals(userNot.Id, controller.userNotification.Id);
        System.assert(controller.HasUserNotification);        
        
        // Finally, set the status to Read. Not the user should hot have a user notification anymore.
        controller.markRead();
    
        controller.refreshUserNotification();
        System.assertEquals(null, controller.userNotification);
        System.assert(!controller.HasUserNotification);        
    }
    
    @isTest
    static void testMarkRead() {
        NotificationsComponentController controller = new NotificationsComponentController();
        Notification__c notification = TestDataFactoryTest.createNotification(true);
        User_Notification__c userNot = TestDataFactoryTest.createUserNotification(notification);
        // Call the refresh method to make sure that user notification is set 
        // in the the controller
        controller.refreshUserNotification();
        
        System.Test.startTest();
        controller.markRead();
        System.Test.stopTest();
        
        // Refresh the user notification to make sure that we actually look at the persisted data
        userNot = [select Status__c from User_Notification__c where Id = :userNot.Id limit 1][0];
        
        System.assertEquals(Constants.USER_NOTIFICATION_STATUS_READ, userNot.Status__c);
    }
    
    @isTest
    static void testMarkDisplayed() {
        NotificationsComponentController controller = new NotificationsComponentController();
        Notification__c notification = TestDataFactoryTest.createNotification(true);
        User_Notification__c userNot = TestDataFactoryTest.createUserNotification(notification);
        // Call the refresh method to make sure that user notification is set 
        // in the the controller
        controller.refreshUserNotification();
        
        System.Test.startTest();
        controller.markDisplayed();
        System.Test.stopTest();
        
        // Refresh the user notification to make sure that we actually look at the persisted data
        userNot = [select Status__c from User_Notification__c where Id = :userNot.Id limit 1][0];
        
        System.assertEquals(Constants.USER_NOTIFICATION_STATUS_DISPLAYED, userNot.Status__c);   
    }
    
    @isTest 
    static void testMarkOpened() {
        NotificationsComponentController controller = new NotificationsComponentController();
        Notification__c notification = TestDataFactoryTest.createNotification(true);
        User_Notification__c userNot = TestDataFactoryTest.createUserNotification(notification);
        // Call the refresh method to make sure that user notification is set 
        // in the the controller
        controller.refreshUserNotification();
        
        System.Test.startTest();
        controller.markOpened();
        System.Test.stopTest();
        
        // Refresh the user notification to make sure that we actually look at the persisted data
        userNot = [select Status__c from User_Notification__c where Id = :userNot.Id limit 1][0];
        
        System.assertEquals(Constants.USER_NOTIFICATION_STATUS_OPENED, userNot.Status__c);        
    }
    
}