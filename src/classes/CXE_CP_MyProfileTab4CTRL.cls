public without sharing class CXE_CP_MyProfileTab4CTRL { //CSM-15023 Shayne Changed to 'without sharing'
    
    // Start CSM-12974 Jerome To Added profile response
    public class ProfileResponse {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String errorMessage;
    }
    // END CSM-12974 Jerome To Added profile response

    // Start CSM-12974 Jerome To Added profile response
    // sopon - move jerome code below
    @AuraEnabled
    //public static String updateContact(String MobileNum, String Mobile2, String Phone, String Birthdate, String secondaryEmail, String salutation) {
    public static CXE_CP_MyProfileTab4CTRL.ProfileResponse updateContact(String MobileNum, String Mobile2, String Phone, String Birthdate, String secondaryEmail, String salutation) {
        // START CSM-14285 Jerome To 11/09/2017
        //return updateContact(MobileNum, Mobile2, Phone, Birthdate, secondaryEmail, salutation, false, null, null, null, null);
        return updateContact(MobileNum, Mobile2, Phone, Birthdate, secondaryEmail, salutation, null, null, null, null);
        // END CSM-14285 Jerome To 11/09/2017
    }
    // End CSM-12974 Jerome To Added profile response


    //sopon - move app
    @AuraEnabled
    //public static String updateContact(String MobileNum, String Mobile2, String Phone, String Birthdate, String secondaryEmail, String salutation) {
    //public static CXE_CP_MyProfileTab4CTRL.ProfileResponse updateContact(String MobileNum, String Mobile2, String Phone, String Birthdate, String secondaryEmail, String salutation, Boolean update_social, String social_facebook, String social_twitter, String social_instagram, String social_google) {
    // START CSM-14285 Jerome To 11/09/2017
    //public static CXE_CP_MyProfileTab4CTRL.ProfileResponse updateContact(String MobileNum, String Mobile2, String Phone, String Birthdate, String secondaryEmail, String salutation, String googleAcct, String fbAcct, String twitterAcct, String instagramAcct) {
    // END CSM-14285 Jerome To 11/09/2017
    // START R3A CSM-14471 Von To 11/09/2017
    public static CXE_CP_MyProfileTab4CTRL.ProfileResponse updateContact(String MobileNum, String Mobile2, String Phone, String Birthdate, String secondaryEmail, String salutation, String fbAcct, String twitterAcct, String instagramAcct, String googleAcct) {
    // END R3A CSM-14471 Von To 11/09/2017
        //string ReturnMe;
        CXE_CP_MyProfileTab4CTRL.ProfileResponse response = new CXE_CP_MyProfileTab4CTRL.ProfileResponse();

        try{
            User user = [SELECT Id, ContactId, MobilePhone, Phone FROM User WHERE Id =: UserInfo.getUserId()];
            user.MobilePhone = MobileNum;
            if(!String.isBlank(Phone) &&  Phone != user.Phone) {
                user.Phone = Phone;
            }
            
            update user;
            // START CSM-12839 Jerome To
            // START CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
            // sopon - move app, add social
            Contact cont = [
                SELECT Id, Email, Mobile_1__c, HomePhone, MobilePhone, Mobile_2__c, Phone, Birthdate,Salutation,Email_2__c 
                    , Facebook__c, Twitter__c, Instagram__c, Google__c
                FROM Contact 
                WHERE Id =: user.ContactId
            ];
	        // START CSM-13021 Jerome To Added Mobile_1__c,HomePhone to update
            cont.Mobile_1__c = MobileNum;
            cont.MobilePhone = MobileNum;
            cont.Mobile_2__c = Mobile2;
            cont.Phone = Phone;
            cont.HomePhone = Phone;
            // END CSM-13021 Jerome To Added Mobile_1__c,HomePhone to update
            cont.Birthdate = String.isNotBlank(Birthdate) ? Date.valueOf(Birthdate) : null;
            cont.Email_2__c = secondaryEmail;
            if(!String.isBlank(salutation)) {
                if(salutation != '--None--') {
                    cont.Salutation = salutation;
                } else {
                    cont.Salutation = '';
                }
            }
            // START CSM-14285 Jerome To 11/09/2017
            // START CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
            ////sopon
            //if(update_social) {
            //    cont.Facebook__c = social_facebook;
            //    cont.Twitter__c = social_twitter;
            //    cont.Instagram__c = social_instagram;
            //    cont.Google__c = social_google;
            //}
            //// =====
            cont.Instagram__c = instagramAcct;
            cont.Facebook__c = fbAcct;
            cont.Twitter__c = twitterAcct;
            cont.Google__c = googleAcct;
            // END CSM-14285 Jerome To 11/09/2017
            // END CSM-14011 Jerome To 10/20/2017 Social Media links not saving in the Profile Information
            update cont;
            // END CSM-12839 Jerome To
            //ReturnMe = 'Success Apex';
            response.isSuccess = true;

        }catch (Exception ex) {
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileTab4CTRL', 'updateContact', ex);
            //ReturnMe = ('Failed Apex ' + ex.getMessage() );
            response.isSuccess = false;
            response.errorMessage = ex.getMessage();
        }
        //return ReturnMe;
        return response;
    }
    // End CSM-12974 Jerome To Added profile response
    
    
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
    public static Id saveAttachment(Id parentId, String fileName, String base64Data, String contentType) {
        
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileTab4CTRL'
                                                , 'saveAttachment' , String.valueOf(base64Data.length()) );
        try{
            Blob image = EncodingUtil.base64Decode(base64Data);
            ConnectApi.BinaryInput b=new ConnectApi.BinaryInput(image,contenttype,'myimage');
            ConnectApi.UserProfiles.setPhoto(null, UserInfo.getUserId(), b);
        }
        catch (Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyProfileTab4CTRL'
                                                , 'saveAttachment' , ex.getMessage());
        }
        return null;
    }


    // START CSM-12839 Jerome To
    @AuraEnabled
    public static List<String> getSalutations(String currentValue){
        List<String> options = new List<String>();
        options.add('--None--');
        Schema.DescribeFieldResult fieldResult = Contact.Salutation.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }    
        return options;    
    }
    // END CSM-12839 Jerome To
       
}