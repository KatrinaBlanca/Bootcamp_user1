/**
 * @author Aard-Jan van Kesteren
 * @description Controller extension for the PublishNotification VF page. 
 */
public class PublishNotificationControllerExt {

 //   private static final String QUEUE = 'Queue';
 //   private static final String ORGANIZATION = 'Organization';
 //   private static final String REGULAR = 'Regular';    
    
 //   private static final Id GROUP_ALL_ID = [
 //       select Id from Group where Type = :ORGANIZATION limit 1
 //   ][0].Id;
    
	//ApexPages.StandardController standardController;
 //   private Notification__c notification;
 //   public Id groupId {get; set;}
    
 //   public List<SelectOption> groupSelectOptions {get; set;} 
    
 //   public List<User> selectedUsers {
 //       get {
 //           try {
 //           	if (groupId == null) {
 //               	return new List<User>();  
 //           	} else if (groupId == GROUP_ALL_ID) {
 //             	return [
 //                 	select Name
 //                 	from User
 //                 	where IsActive = true
 //                 	order by Name asc
 //             	];
 //           	} else {
 //              		return [
 //                   	select Name
 //                   	from User
 //                   	where Id in (
 //                   		select UserOrGroupId 
 //                       	from GroupMember
 //                       	where GroupId = :groupId                       
 //                   	)
 //                   	and IsActive = true
 //                   	order by Name asc
 //               	];
 //               }                
 //           } catch (Exception e) {
 //               System.debug(LoggingLevel.ERROR, e);
 //               System.debug(LoggingLevel.ERROR, e.getStackTraceString());
 //               return new List<User>();
 //           }
 //       }
 //   }
    
    public PublishNotificationControllerExt(ApexPages.StandardController stdController) {
    	//standardController = stdController;
     //   notification = (Notification__c)stdController.getRecord();
        
     //   groupSelectOptions = new List<SelectOption>();
     //   try {
     //   	for (Group grp: [
     //       	select Id, Name, Type
     //       	from Group
     //       	where type in (:QUEUE, :REGULAR, :ORGANIZATION)
     //       	order by Type asc, Name asc // First order by Type to get the organization one at the top. 
     //   	]) {
     //   		groupSelectOptions.add(new SelectOption(grp.Id, getGroupName(grp)));	    
     //   	}
     //   } catch (Exception e) {
     //       // Something unexpected went wrong. The user will not have 
     //       System.debug(LoggingLevel.ERROR, e);
     //       System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            
     //       // It's okay to not put the error message below in a custom label. We don't
     //       // expect to show this one anyway. 
     //       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL , 
     //       	'Oeps, something unexpected went wrong in retrieving the list of groups (' + e + ').'));
     //   }
    }
    
    //private String getGroupName(Group grp) {
    //    if (grp.Type == ORGANIZATION) {
    //    	return Label.PUBNOT_OPTION_Group_Type_All; 
    //    } else if (grp.Type == REGULAR) {
    //    	return string.format(Label.PUBNOT_OPTION_Group_Type_Public_Group, new String[]{grp.Name});
    //    } else if (grp.Type == QUEUE) {
    //        return string.format(Label.PUBNOT_OPTION_Group_Type_Queue, new String[]{grp.Name});
    //    } else {
    //        // Not using a custom label below is allowed, because it's 
    //        // only an exception situation. 
    //        return 'Unexpected Type: ' + grp.Type; 
    //    }
    //}
    
    //public PageReference publish() {
    //    try {
    //    	// Validations
    //    	// Check if a group has been selected
    //    	if (selectedUsers.isEmpty()) {
    //        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.PUBNOT_ERRMSG_No_Group_Selected));
    //    		return null;
    //   		}
    //    	// Check if the status is new
    //    	if (notification.Status__c != Constants.NOTIFICATION_STATUS_DRAFT) {
    //    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.PUBNOT_ERRMSG_Can_Only_Publish_Draft_Notifications));
    //    		return null;
    //    	}
        
    //    	notification.Status__c = Constants.NOTIFICATION_STATUS_PUBLISHED;
    //    	List<User_Notification__c> userNotificationsToInsert = new List<User_Notification__c>();
    //    	for (User user : selectedUsers) {
    //    		User_Notification__c userNotification = new User_Notification__c();
    //        	userNotification.Notification__c = notification.Id;
    //        	userNotification.User__c = user.Id;
    //        	userNotification.Status__c = Constants.USER_NOTIFICATION_STATUS_NEW;
    //        	userNotificationsToInsert.add(userNotification);
    //    	}
    //    	update notification;
    //    	insert userNotificationsToInsert;
    //    } catch (Exception e) {
    //        System.debug(LoggingLevel.ERROR, e);
    //        System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            
    //        // It's okay to not put the error message below in a custom label. We don't
    //        // expect to show this one anyway. 
    //        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL , 
    //        	'Oeps, something unexpected went wrong while publishing (' + e + ').'));
            
    //     	return null;   
    //    }
        
    //    return standardController.view();
    //}
    
    //public PageReference cancel() {
    //    return standardController.view();
    //}
    
}