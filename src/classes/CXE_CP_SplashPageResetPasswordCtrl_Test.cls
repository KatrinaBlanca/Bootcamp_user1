@isTest
private class CXE_CP_SplashPageResetPasswordCtrl_Test {
    
    @testSetUp 
    static void createPortalUsers(){  
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];   
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];   
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago' 
        );
        Database.insert(portalAccountOwner1);
        
        System.runAs ( portalAccountOwner1 ) {
            
            createPortalUsers(2);
            
        }
    }
    
    
    public static List<Account> createPersonAccount(Integer count){
        
        List<Account> accountList = new List<Account>();
        
        Id personAccountRecordTypeId = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get(CXE_Constants.RECORD_TYPE_NAME_ACCOUNT_PERSON).getRecordTypeId();
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
            Account acc = new Account();
            
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = 'FName: ' + recordCount + count;
            acc.MiddleName = 'MName: '+recordCount + count;
            acc.LastName = 'LName: '+recordCount + count;
            acc.PersonBirthdate = System.today() - 30;
            acc.Phone = '+6300000000';
            acc.PersonMobilePhone = '+630000000000'; 
            acc.PersonEmail = 'test@test.com';
            acc.Tax_Identification_No__c = '123456789012';
            acc.Mobile_Phone__c = '+630000000000';
            acc.Email__c = 'test@test.com';
            
            accountList.add(acc);
        }
        
        insert(accountList);
        
        return accountList;
    }
    
    
    public static List<User> createPortalUsers(Integer count){
        
        List<User> userList = new List<User>();
        
        List<Account> createAcct =createPersonAccount(count);
        
        List<Account> pcIdAcct = [SELECT Id,PersonContactId FROM Account WHERE Id IN:createAcct];
        
        List<Id> accId = new List<Id>();
        
        for(Account accRec : pcIdAcct){
            
            accId.add(accRec.PersonContactId); 
            
        }
        
        Profile portalProfile = [SELECT Id FROM Profile Limit 1];
        
        for(Integer recordCount=0; recordCount<count; recordCount++){
            
            User u = new User(
                Username = System.now().millisecond()+recordCount +count + 'gold@test.com',
                ContactId = accId[recordCount],
                ProfileId = portalProfile.Id,
                Alias = 'IAlias',
                Email = 'IndiPersonalAccount@test.com'+recordCount,
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CXE_CP_isPortalDeactivated__c =True,
                CommunityNickname = 'CommNickName'+recordCount,
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                CXE_ChangePasswordSuccessFlag__c =False,    
                isActive =True,
                By_Pass_Validation__c =true
            ); 
            
            userList.add(u);
        }
        
        insert userList;
        
        return userList;
        
    }
    
    @IsTest
    public static void testResetPasswordSuccess() {
        Test.startTest();
        // Instantiate a new controller with all parameters in the page
        String oldPassword = '123456';
        String newPassword = 'Cairo!98978'; 
        String verifyNewPassword = 'Cairo!98978';
        String page ='dashboard';
        
        User portaluser =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c FROM User WHERE email ='indipersonalaccount@test.com0'];
        System.assertEquals('indipersonalaccount@test.com0',portalUser.Email);
        System.debug('PortalUserData:'+ portaluser.Id);
        String message;
        
        System.runAs (portaluser) {
            //message = CXE_CP_SplashPageResetPasswordCtrl.getChangePassword(oldPassword,newPassword,portaluser.Id,page);     
            message =  CXE_CP_SplashPageResetPasswordCtrl.getChangePassword(newPassword, verifyNewPassword, portaluser.Id, page, 'Set');
        }
        
        Test.stopTest();
    } 
    
    
    @IsTest
    public static void testResetPasswordPageNull() {
        Test.startTest();
        // Instantiate a new controller with all parameters in the page
        String oldPassword = '123456';
        String newPassword = 'Cairo!98978'; 
        String verifyNewPassword = 'Cairo!98978';
        String page;
        
        User portaluser =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c FROM User WHERE email ='IndiPersonalAccount@test.com0'];
        System.assertEquals('indipersonalaccount@test.com0',portalUser.Email);
        System.debug('PortalUserData:'+ portaluser.Id);
        String message;
        System.runAs (portaluser) {
            //message = CXE_CP_SplashPageResetPasswordCtrl.getChangePassword(oldPassword,newPassword,portaluser.Id,page);  
            message =  CXE_CP_SplashPageResetPasswordCtrl.getChangePassword(newPassword, verifyNewPassword, portaluser.Id, page, 'Reset');         
        }
        Test.stopTest();
        System.assertEquals('Argument 1 cannot be null',message);
        
    } 
    
    @IsTest
    public static void testVerificationLink() {
        Test.startTest();
        
        User portaluser =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c FROM User WHERE email ='IndiPersonalAccount@test.com0'];
        User portaluser2 =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c, CXE_CP_isPortalDeactivated__c, IsActive FROM User WHERE email ='IndiPersonalAccount@test.com1'];
        User portaluser3 =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c, CXE_CP_isPortalDeactivated__c, IsActive, LastLoginDate, CreatedDate FROM User WHERE email ='IndiPersonalAccount@test.com1'];
        User portaluser4 =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c, CXE_CP_isPortalDeactivated__c, IsActive, Reset_Password_Token__c, Reset_Password_Link_Generation__c FROM User WHERE email ='IndiPersonalAccount@test.com1'];
        portaluser2.IsActive = false;
        portaluser2.CXE_CP_isPortalDeactivated__c = true;
        update portaluser2;
        portaluser4.Reset_Password_Link_Generation__c = Datetime.Now().addHours(1);
        
        System.assertEquals('indipersonalaccount@test.com0', portaluser.Email);
        System.assertEquals('indipersonalaccount@test.com1', portaluser2.Email);
        String message;
        String message2;
        String message3;
        String message4;
        System.runAs (portaluser) { 
            message =  CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser(portaluser.Id, null, null);
        }
        
        User portaluserAdmin =[SELECT Id, Email, CXE_ChangePasswordSuccessFlag__c FROM User WHERE email ='bruce.wayne@wayneenterprises.com'];
        System.runAs (portaluserAdmin) { 
            message2 =  CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser(portaluser2.Id, 'Set', null);
            CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser('sampleemailId', 'Set', null);
            
            message4 =  CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser(portaluser3.Id, 'Reset', null);
            CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser('sampleemailId', 'Reset', 'guid');
            
            message4 =  CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser(portaluser4.Id, 'Reset', 'guid');
            CXE_CP_SplashPageResetPasswordCtrl.verifyPortalUser('sampleemailId', 'Reset', 'guid');
        }
        system.debug(portaluser2);
        Test.stopTest();
        
        System.assertEquals('valid',message);
        System.assertEquals('expired',message2);
    }
    
}