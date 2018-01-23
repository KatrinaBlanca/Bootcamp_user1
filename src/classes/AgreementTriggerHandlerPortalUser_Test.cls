@isTest
private class AgreementTriggerHandlerPortalUser_Test {

     @testSetup static void setup(){
        
        CXE_TestDataFactory.setupPortalData('2', true);

    }
    
    
    @isTest
    static void terminateService_Test(){
        
        Test.startTest();
        
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            
            
            Account acct = CXE_TestDataFactory.createSingleAccountForPortalUser(userAd.Id);
            insert acct;
            Contact  cont =CXE_TestDataFactory.createContact(acct.Id);
            insert cont;
            
            User portalUser = CXE_TestDataFactory.createPortalUser(cont.Id);
            insert portalUser; 
            portalUser.CommunityNickname ='CorbesTest';
            update portalUser;
            
            System.assert(portalUser!=null);
            
            
            Agreement__c service =[SELECT Id,Service_Status__c  FROM Agreement__c WHERE SIN__C= '293028374839' LIMIT  1]; 
            
            CXE_Service_Enrollment__c cxe = new CXE_Service_Enrollment__c();
            cxe.CXE_ServiceId__c = service.Id;
            cxe.CXE_UserId__c = portalUser.ID;
            cxe.CXE_IsActive__c =True;
            cxe.CXE_Type__c  ='Payor';
            
            insert cxe;
            
            System.assert(cxe!=null);
            
            service.Service_Status__c ='Terminated';
            
            update service;
            
            System.assertEquals('Terminated',  service.Service_Status__c);
            // Activate the Service
            service.Service_Status__c ='Active';
            
            update service; 
            
           System.assertEquals('Active',  service.Service_Status__c);
        }
        Test.stopTest();
        
    }
    
    
 }