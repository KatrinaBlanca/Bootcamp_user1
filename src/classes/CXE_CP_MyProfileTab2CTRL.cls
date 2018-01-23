public class CXE_CP_MyProfileTab2CTRL {

    
    
    @AuraEnabled
    public static String getProfilePicture(Id parentId) {
        
        // Attachment permissions are set in parent object (Contact)
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new System.NoAccessException();
            return null;
        }
        if(parentId == null){
            parentId = UserInfo.getUserId();
        }
        return [SELECT Id, FullPhotoUrl FROM User WHERE Id =:parentId].FullPhotoUrl;
    }
    
    @AuraEnabled
    public static String updateContact(String billingNotificationString,
                                       String paymentConfirmationString,
                                       String paymentReminderString,
                                       String serviceApplicationString,
                                       String outagesString,
                                       String promotionsString) {
                                           
        String ReturnMe;
        
        try{
            
            User user = [SELECT Id, ContactId, MobilePhone, Phone FROM User WHERE Id =: UserInfo.getUserId()];
            
            Contact cont = [SELECT Id, Billing_Notification__c, Payment_Confirmation_Notification__c, Payment_Reminders__c, 
                            Service_Applications_Notification__c, Outages_Notification__c, Promotions_Notification__c
                            FROM Contact WHERE Id =: user.ContactId];
            
            
           
            cont.Billing_Notification__c               = billingNotificationString;
            cont.Payment_Confirmation_Notification__c  = paymentConfirmationString;
            cont.Payment_Reminders__c                  = paymentReminderString;    
            cont.Service_Applications_Notification__c  = serviceApplicationString; 
            cont.Outages_Notification__c               = outagesString;            
            cont.Promotions_Notification__c            = promotionsString; 
            
            
            upsert cont;
            ReturnMe = 'Success';
            
        }catch (Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileTab4CTRL', 'updateContact', ReturnMe + ' : ' +ex.getMessage());
            
            ReturnMe = ex.getMessage();
            
        }
        return ReturnMe;
        
    }
       
}