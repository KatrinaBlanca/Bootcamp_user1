@isTest
public class HandlerMyOpenCasesTest {
    @testSetup 
    static void createPortalUser(){
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
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
        
    }
    static testmethod void testHandle(){
        Test.startTest();
        User  portalAccountOwner1 =[SELECT ID FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
         String hasSession;
         System.runAs ( portalAccountOwner1 ) {
             //Create account
             
             Account portalAccount1 = new Account(
                 Name = 'TestAccount',
                 OwnerId = portalAccountOwner1.Id,
                 Phone = '+63021234567',
                 Tax_Identification_No__c = '123456789012',
                 Mobile_Phone__c = '+630000000000',
                 Email__c = 'test@test.com'
                 
             );
             Database.insert(portalAccount1);
             
             //Create contact
             Contact contact1 = new Contact(
                 FirstName = 'Test',
                 Lastname = 'McTesty',
                 AccountId = portalAccount1.Id,
                 Email = System.now().millisecond() + 'test@test.com',
                 CXE_isPortalContact__c =False
             );
             
       		 Database.insert(contact1);
             Case cs = new Case(Subject = 'Test only for test class',
                           Status = 'New', Priority = 'Medium',
                           ContactId = contact1.id				   
        	);
             insert cs;
             HandlerMyOpenCases handler = new HandlerMyOpenCases();
             List<String> params = new List<String>();
             Map<String,String> session = new Map<String,String>();
             handler.handle('test', params, session);
         }
        
    }
}