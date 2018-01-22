@isTest
public class UserTriggerHandler_Test {
    
    @testSetup
    static void createTestRequirements() {
        
        User sysAd = CXE_TestDataFactory.createAdminUser();
        sysAd.MiddleName = 'MidName';
        Database.insert(sysAd);
    }
    
    @isTest
    static void test_isDisabled() {
        test.startTest();
        UserTriggerHandler uth = new UserTriggerHandler();
        Boolean isDisabled = uth.IsDisabled();
        test.stopTest();       
    }
    

    @isTest
    static void test_UserTriggerHandler() {
        
        test.startTest();
        
        User  userSysAd =[SELECT ID, FirstName, MiddleName, LastName, ContactId FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        
        System.runAs(userSysAd) {
            List <Account> bAccountList = CXE_TestDataFactory.createBusinessAccount(1);
            Account bAccount = bAccountList.get(0);
            Database.insert(bAccount);
            
            List<Contact> contactList = CXE_TestDataFactory.createContact(5);
            Contact contactRecord = contactList.get(0);
            contactRecord.AccountId = bAccount.Id;
            contactRecord.CXE_isPortalContact__c = True;
            Database.insert(contactRecord);
            
            Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
            
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            Database.insert(psicRecord);
            
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
            caseRecord.RecordTypeID = newServiceApplicationRecordTypeId;
            caseRecord.ContactId = contactRecord.id;
            caseRecord.PSIC__c = psicRecord.id;
            Database.insert(caseRecord);
            
            List <Contract> contractList = CXE_TestDataFactory.createContract(1, bAccount.Id, caseRecord.Id); 
            Contract contractRecord = contractList.get(0);
            contractRecord.Related_Account__c = bAccount.Id;
            Database.insert(contractRecord);
            
            Address__c addressRecord = CXE_TestDataFactory.createAddress(bAccount.Id, caseRecord.Id, contractRecord.Id);
            Database.insert(addressRecord);
            
            List<Agreement__c> serviceList = CXE_TestDataFactory.createServiceWithLessDetails(1, bAccount.Id, caseRecord.Id, contractRecord.Id, psicRecord.Id);
            Agreement__c service = serviceList.get(0);
            service.Payor__c = contractRecord.Id;
            Database.insert(service);
            
            Id portalCommProfId = [SELECT Id, Name FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
            User portalUser = CXE_TestDataFactory.createPortalUser(contactRecord.Id);
            portalUser.ProfileId = portalCommProfId;
            Database.insert(portalUser);
            
            
            List<User> userList = CXE_TestDataFactory.createUser(5, 'System Administrator');
            Database.insert(userList);
            
            UserTriggerHandler uth = new UserTriggerHandler();
            uth.BeforeInsert(userList);
            uth.BeforeUpdate(null, null);
            uth.AfterUpdate(null, null);
            uth.BeforeDelete(null);
            uth.AfterDelete(null);
            uth.AfterUndelete(null);
            uth.isRegisteredNameSameAsAccountName(userSysAd, service);

            test.stopTest();
        }
        
    }
    /*
    @isTest
    static void test_pAccount_UserTriggerHandler() {
        
        test.startTest();
        
        User  userSysAd =[SELECT ID, FirstName, MiddleName, LastName, ContactId FROM USER WHERE EMAIL ='bruce.wayne@wayneenterprises.com' ];
        
        System.runAs(userSysAd) {
            List <Account> pAccountList = CXE_TestDataFactory.createPersonAccount(1);
            Account pAccount = pAccountList.get(0);
            Database.insert(pAccount);
            
            
            Contact contactRecord = [SELECT Id FROM Contact WHERE AccountId =: pAccount.Id];
            
            Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
            
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            Database.insert(psicRecord);
            
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
            caseRecord.RecordTypeID = newServiceApplicationRecordTypeId;
            caseRecord.ContactId = pAccount.PersonContactId;
            caseRecord.PSIC__c = psicRecord.id;
            Database.insert(caseRecord);
            
            List <Contract> contractList = CXE_TestDataFactory.createContract(1, pAccount.Id, caseRecord.Id); 
            Contract contractRecord = contractList.get(0);
            contractRecord.Related_Account__c = pAccount.Id;
            Database.insert(contractRecord);
            
            Address__c addressRecord = CXE_TestDataFactory.createAddress(pAccount.Id, caseRecord.Id, contractRecord.Id);
            Database.insert(addressRecord);
            
            List<Agreement__c> serviceList = CXE_TestDataFactory.createServiceWithLessDetails(1, pAccount.Id, caseRecord.Id, contractRecord.Id, psicRecord.Id);
            Agreement__c service = serviceList.get(0);
            service.Payor__c = contractRecord.Id;
            Database.insert(service);
            
            List<User> userList = CXE_TestDataFactory.createUser(5, 'System Administrator');
            Database.insert(userList);
            
            /*
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            Database.insert(psicRecord);
            
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
            caseRecord.RecordTypeID = newServiceApplicationRecordTypeId;
            caseRecord.ContactId = contactRecord.id;
            caseRecord.PSIC__c = psicRecord.id;
            Database.insert(caseRecord);
            
            List <Contract> contractList = CXE_TestDataFactory.createContract(1, pAccount.Id, caseRecord.Id); 
            Contract contractRecord = contractList.get(0);
            contractRecord.Related_Account__c = pAccount.Id;
            Database.insert(contractRecord);
            
            Address__c addressRecord = CXE_TestDataFactory.createAddress(pAccount.Id, caseRecord.Id, contractRecord.Id);
            Database.insert(addressRecord);
            
            List<Agreement__c> serviceList = CXE_TestDataFactory.createServiceWithLessDetails(1, pAccount.Id, caseRecord.Id, contractRecord.Id, psicRecord.Id);
            Agreement__c service = serviceList.get(0);
            service.Payor__c = contractRecord.Id;
            Database.insert(service);
            
            Id portalCommProfId = [SELECT Id, Name FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
            User portalUser = CXE_TestDataFactory.createPortalUser(contactRecord.Id);
            portalUser.ProfileId = portalCommProfId;
            Database.insert(portalUser);
            
            
            List<User> userList = CXE_TestDataFactory.createUser(5, 'System Administrator');
            Database.insert(userList);
            
            UserTriggerHandler uth = new UserTriggerHandler();
            uth.BeforeInsert(userList);
            uth.BeforeUpdate(null, null);
            uth.AfterUpdate(null, null);
            uth.BeforeDelete(null);
            uth.AfterDelete(null);
            uth.AfterUndelete(null);
            uth.isRegisteredNameSameAsAccountName(userSysAd, service);

            test.stopTest();
        }
        
    }
*/
    
}