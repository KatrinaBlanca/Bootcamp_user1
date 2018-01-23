/**
 * @author Aard-Jan van Kesteren
 * @description Controller for the NotificationsCustomConsoleComponent VF page.  
 */
public class NotificationsComponentController {

    public User_Notification__c userNotification {get; set;}
    
    public Boolean hasUserNotification {
        get {
            return userNotification != null;
        }
    }    

    public NotificationsComponentController() {
		refreshUserNotification();
    }
    
    public void markRead() {
        try {
        	if (userNotification != null) {
            	userNotification.Status__c = Constants.USER_NOTIFICATION_STATUS_READ;
            	update userNotification;
        	}
        	refreshUserNotification();
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
        }
    }
    
    public void markDisplayed() {
        try {
        	if (userNotification != null && 
            	userNotification.Status__c == Constants.USER_NOTIFICATION_STATUS_NEW) {
            	// Only allowed transition is NEW -> DISPLAYED
            	userNotification.Status__c = Constants.USER_NOTIFICATION_STATUS_DISPLAYED;
            	update userNotification;
                }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());            
        }
    }    
    
    public void markOpened() {
        try {
        	if (userNotification != null && 
            	(userNotification.Status__c == Constants.USER_NOTIFICATION_STATUS_NEW 
             	|| userNotification.Status__c == Constants.USER_NOTIFICATION_STATUS_DISPLAYED)) {
            	// Only allowed transitions are NEW -> OPENED and DISPLAYED -> OPENED
            	userNotification.Status__c = Constants.USER_NOTIFICATION_STATUS_OPENED;
            	update userNotification;
                }
   			
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e);
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());            
        }
    }      
    
    public void refreshUserNotification() {
        try {
    		List<User_Notification__c> userNotifications = [
            	select Id
            	, 	   Notification__r.Short_Message__c
            	,      Notification__r.Long_Message__c
            	,      Status__c
            	,      Name
            	from User_Notification__c
            	where User__c = :UserInfo.getUserId()
            	and Status__c != :Constants.USER_NOTIFICATION_STATUS_READ
            	and Notification__r.Status__c = :Constants.NOTIFICATION_STATUS_PUBLISHED
            	order by CreatedDate asc
            	limit 1
        	];
        	userNotification = userNotifications.isEmpty() ? null : userNotifications[0];
        } catch (Exception e) {
        	System.debug(LoggingLevel.ERROR, e);
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
        }
    }
    
}