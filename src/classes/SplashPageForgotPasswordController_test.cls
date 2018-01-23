@isTest
private class SplashPageForgotPasswordController_test{
    
    @testSetUp static void createPortalUsers(){  
        
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
            
            createPortalUsers(200);
            
        }
    }
    
    
    /*
    @isTest static void requestIndividualuser(){
        Test.startTest();
        List<User> testuser =[SELECT Email,Contact.IsPersonAccount,CXE_ForgotPasswordFlag__c  FROM user 
                              WHERE  Contact.IsPersonAccount =true AND isActive = true];
        
        String req =SplashPageForgotPasswordController.sendMailMethod(testuser[0].Email);
        
        String message ='Please make sure that you enter the email address that you used to register on Meralco Online.';
        Test.stopTest();
        System.assertEquals(message, req);

    }
    
    @isTest static void requestBizUser(){
        Test.startTest();
        List<User> testuser =[SELECT Email,Contact.IsPersonAccount,CXE_ForgotPasswordFlag__c  FROM user 
                              WHERE  Contact.IsPersonAccount =true AND isActive = true];
        
        String req= SplashPageForgotPasswordController.sendMailMethod(testuser[0].email);
        
        String message ='Please make sure that you enter the email address that you used to register on Meralco Online.';
        
        Test.stopTest();
        
        System.assertEquals(message, req);
    }
    */
    
    @isTest static void requestInvalidEmail(){
        
        Test.startTest(); 
        String req= SplashPageForgotPasswordController.sendMailMethod('email0thus0not@exist.com');
        String message ='Please make sure that you enter the email address that you used to register on Meralco Online.';
        
        System.assertEquals(message, req);
        Test.stopTest();

    }
    
    @isTest static void requestValidEmail(){
        
        Test.startTest(); 
        
        List<User> valiEmail =[SELECT Id, Email, Contact.IsPersonAccount,CXE_ForgotPasswordFlag__c  FROM user WHERE Profile.Name =:CXE_Constants.PORTAL_COMMUNITY_PROFILE AND isActive = True LIMIT 1];

        User portalUser2 = valiEmail[0];

        System.runAs ( portalUser2 ) {
            String req= SplashPageForgotPasswordController.sendMailMethod(portalUser2.Email);
        }
        System.assertEquals(1, valiEmail.size());
        
        Test.stopTest();
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
                Email = System.now().millisecond()+recordCount +count + 'gold@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'CommNickName'+recordCount,
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                CXE_ForgotPasswordFlag__c =false,
                isActive =True,
                By_Pass_Validation__c = true
            ); 
            
            userList.add(u);
        }
        
        insert userList;
        //System.assertEquals('expected', String.valueOf(userList[0].Email)); 
        return userList;
        
    }
    
    
    
}