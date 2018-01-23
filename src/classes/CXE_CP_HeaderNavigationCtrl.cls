public with sharing class CXE_CP_HeaderNavigationCtrl {

    @AuraEnabled
    public static User LoginDetails(){
        List<user> UserData = new List<user>();
        UserData = [SELECT LastLoginDate,FirstName,LastName FROM User WHERE Id =:UserInfo.getUserId()]; 
        
        return UserData[0];
    }
}