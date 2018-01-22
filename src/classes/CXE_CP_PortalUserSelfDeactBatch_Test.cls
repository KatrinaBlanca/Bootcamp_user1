@isTest
public class CXE_CP_PortalUserSelfDeactBatch_Test {
    
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
            
             createPortalUsers(10);
            
        }
    }
    
    @isTest
    static void HappyPath(){
        
        Test.startTest();
        
        List<User> userBeforeList = [SELECT Id,Email,isActive,LastName,CXE_CP_isPortalDeactivated__c,
                                     Contact.IsPersonAccount 	
                                     FROM USER 
                                     WHERE Profile.Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE //CSM-14182
                                     AND CXE_CP_isPortalDeactivated__c=TRUE 
                                     AND isActive =true
                                     AND Email ='IndiPersonalAccount@test.com'];
        
        
        //Test for Batch and Schedule Class
        CXE_CP_PortalUserSelfDeactSched sh1 = new CXE_CP_PortalUserSelfDeactSched();      
        sh1.execute(null);
       
  		//Test for Sending an email for Individual or Bizness      
       // CXE_CP_PortalUserSelfDeactBatch.sendEmailNotification(userBeforeList);
        
        Test.stopTest(); 
      
        List<User> updatedUser = [SELECT Id, isActive 
                                  FROM User 
                                  WHERE Profile.Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE  //CSM-14182
                                  AND CXE_CP_isPortalDeactivated__c=TRUE
                                  AND Email ='IndiPersonalAccount@test.com'];
        
        for(User inactiveUsers : updatedUser){
             System.assertEquals(False, inactiveUsers.IsActive);
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
            Email = 'IndiPersonalAccount@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CXE_CP_isPortalDeactivated__c =True,
            CommunityNickname = 'CommNickName'+recordCount,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            isActive =True
            ); 
            
            userList.add(u);
        }
        
        insert userList;
        
        return userList;
        
    }
    
    
}