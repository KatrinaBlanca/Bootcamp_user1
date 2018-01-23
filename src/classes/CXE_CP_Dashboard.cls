public without sharing class CXE_CP_Dashboard { //CSM-13070 GGrandea 10.02.2017 - changed to "without sharing"
    
    
    @AuraEnabled
    public static CXE_CP_PortalUtility.PortalData LoginDetails(){
        
        CXE_CP_PortalUtility.PortalData pData = CXE_CP_PortalUtility.retrievePortalData();
    
    	return pData;
    }
    
    //Rj --> Apex Class to Update Auto Enrollment Checkbox to false
    @AuraEnabled
    public static User UpdateAutoEnrollment(){
        
        User currentUser = [SELECT CXE_Auto_Enrolled_Services__c FROM User WHERE Id =:UserInfo.getUserId()];
        currentUser.CXE_Auto_Enrolled_Services__c = false;
        update currentUser;
        
        return currentUser;
    }
        
    @AuraEnabled
    public static String getProfInfoModal(){
        String value;
        
        User user = [SELECT Id, ContactId, MobilePhone, Phone FROM User WHERE Id =: UserInfo.getUserId()];
        //START CSM-13844 JRances - Customer Portal Notice to complete profile information is not displayed, Included Secondary Email for checking
        //Contact cont = [SELECT Id, Email, MobilePhone, Mobile_2__c, Phone, Birthdate FROM Contact WHERE Id =: user.ContactId];
        Contact cont = [SELECT Id, Email, MobilePhone, Mobile_2__c, Phone, Birthdate, Email_2__c, HomePhone 
                                    FROM Contact WHERE Id =: user.ContactId]; //CSM-14141 GGrandea 10.26.2017 added HomePhone
        
        //CSM-14141 GGrandea 10.26.2017 added HomePhone checking
        if(cont.Mobile_2__c == NULL || (cont.Phone == NULL && cont.HomePhone==NULL) || cont.Birthdate== null || cont.Email_2__c == null){
            value = 'true';
        //END CSM-13844 JRances    
        }else
           value = 'false';
           return value;
    }
    
    //Mike 08/09/2017 - Getting custom settings link for Feedback
    @AuraEnabled
    public static String getFeedbackLink(){
        return OrganizationSettings__c.getOrgDefaults().Customer_Feedback__c;
    }
    
    /* 
     * Description: Retrieve Last Login History
     * Parameters: none
     * Returns: N/A
     * Author: GGrandea (Accenture)
     * Date Created: OCT-2-17   [CSM-13070]
    */  
    @AuraEnabled
    public static CXE_CP_PortalUtility.PortalData retrieveLoginHistory(){
        
        CXE_CP_PortalUtility.PortalData pData = new CXE_CP_PortalUtility.PortalData();

        User currentUser = [SELECT LastLoginDate, 
                                    FirstName
                                 FROM User 
                                WHERE Id =:UserInfo.getUserId()];

        pData.FirstName = currentUser.FirstName;
        pData.LastLoginDate = currentUser.LastLoginDate;
        pData.loginHistoryList = [SELECT    LoginTime, Application, Status
                                         FROM LoginHistory 
                                        WHERE UserId =: UserInfo.getUserId()
                                         AND LoginTime < :currentUser.LastLoginDate //CSM-14635
                                            ORDER BY LoginTime DESC];

        return pData;
    }


    @AuraEnabled
    public static String getProfilePicture() {
        
        // Attachment permissions are set in parent object (Contact)
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new System.NoAccessException(); return null;
        }
        
        return [SELECT Id, FullPhotoUrl FROM User WHERE Id =:UserInfo.getUserId()].FullPhotoUrl;
    }
}