/* Description: CXE_SubmitApproval_CC test class
 * Author: Jerson Poblete
 * Date Created: MAR-21-17
 */


@isTest
public class CXE_SubmitApproval_CC_Test {
    static testMethod void submitGSL4approval() {
        //setup user and user roles
            List<User> ulist = new List<User>();    
            Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
            Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
            Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;

            //create user role heirarchy
            UserRole urg3 = new UserRole(Name = 'BC Head');
                insert urg3;
            UserRole urg4 = new UserRole(Name = 'Customer Care Officer', ParentRoleId = urg3.id);
                insert urg4;
            UserRole urg5 = new UserRole(Name = 'Customer Care Representative', ParentRoleId = urg4.id);
                insert urg5;
            
            //create users
            User g3 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g3Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg3.id,
                    Office__c = 'HMB - South Area'
                );
                insert g3;

              User g4 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g4Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg4.id            
                );
                insert g4;

              User g5 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g5Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg5.id,
                    Office__c = 'HMB - Bacoor BC'            
                );
                insert g5;

            Test.startTest();
            system.runAs(g5)
            {     
            Office__c parentOffice = CXE_TestDataFactory.createOffice(1)[0];
            parentOffice.Name = 'HMB - South Area';
            insert parentOffice;

            Office__c office = CXE_TestDataFactory.createOffice(1)[0];
            office.Name = 'HMB - Bacoor BC';
            office.Parent_RO__c = parentOffice.Id;
            insert office; 

            Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        
            Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
            insert contactRecord;
            
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            insert psicRecord;
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
            caseRecord.GSL4_Check__c = true;
            caseRecord.GSL4_Target_Date__c = system.today();
            caseRecord.New_GSL4_Target_Date__c = system.today();
            caseRecord.Reason_for_GSL4_Target_Date_Modification__c = 'Test for gsl4 approval';
            caseRecord.ContactId = contactRecord.id;
            caseRecord.Individual_Business_Tag__c = 'No';
            caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
            caseRecord.PSIC__c = psicRecord.id;
            caseRecord.Initial_Responsible_Office__c = 'RO1';
            caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
            caseRecord.Tax_Identification_No__c = '123';
            caseRecord.Telephone_No__c = '+6312312421';
            caseRecord.Mobile_No__c = '+631324358765';
            caseRecord.Application_for_Business_Service__c = true;
            
            insert caseRecord;
            String caseId = (string)caseRecord.Id;
            String comments = 'Test Comment for Approval';
            String result = '';
            result = CXE_SubmitApproval_CC.submitApproval(caseId, comments);
                
            //start Melvin Corbes
            User uDetails = CXE_SubmitApproval_CC.getUserDetails();
            Case cDetails =CXE_SubmitApproval_CC.getCaseDetails(caseId); 
            //end Melvin Corbes
            system.assertEquals('Success', result);
         }
        Test.stopTest();    
    }
    static testMethod void submitArrearsApproval() {
            List<User> ulist = new List<User>();    
            Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
            Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
            Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;

            //create user role heirarchy
            UserRole urg3 = new UserRole(Name = 'BC Head');
                insert urg3;
            UserRole urg4 = new UserRole(Name = 'Customer Care Officer', ParentRoleId = urg3.id);
                insert urg4;
            UserRole urg5 = new UserRole(Name = 'Customer Care Representative', ParentRoleId = urg4.id);
                insert urg5;
            
            //create users
            User g3 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g3Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg3.id,
                    Office__c = 'HMB - Bacoor BC'
                );
                insert g3;

              User g4 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g4Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg4.id,
                    Office__c = 'HMB - Bacoor BC'   

                );
                insert g4;

              User g5 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g5Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg5.id            
                );
                insert g5;

        Test.startTest();
        system.runAs(g4){

            Office__c parentOffice = CXE_TestDataFactory.createOffice(1)[0];
            parentOffice.Name = 'HMB - South Area';
            insert parentOffice;

            Office__c office = CXE_TestDataFactory.createOffice(1)[0];
            office.Name = 'HMB - Bacoor BC';
            office.Parent_RO__c = parentOffice.Id;
            insert office; 

            Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
            Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
            insert contactRecord;            
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            insert psicRecord;
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
            caseRecord.Arrears_Check__c = true;
            caseRecord.Arrears_Tag__c = true;
            caseRecord.Arrears_Lifting_Justification__c = 'Test for arrears approval';
            caseRecord.ContactId = contactRecord.id;
            caseRecord.Individual_Business_Tag__c = 'No';
            caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
            caseRecord.PSIC__c = psicRecord.id;
            caseRecord.Initial_Responsible_Office__c = 'RO1';
            caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
            caseRecord.Tax_Identification_No__c = '123';
            caseRecord.Telephone_No__c = '+6312312421';
            caseRecord.Mobile_No__c = '+631324358765';
            caseRecord.Application_for_Business_Service__c = true;
            insert caseRecord;
            String caseId = (string)caseRecord.Id;
            String comments = 'Test Comment for Approval';
            String result = '';
            result = CXE_SubmitApproval_CC.submitApproval(caseId, comments);
            system.assertEquals('Success', result);
            }
        Test.stopTest();
    }
    static testMethod void noValidCriteriaForApproval() {  

        List<User> ulist = new List<User>();    
            Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
            Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
            Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;

            //create user role heirarchy
            UserRole urg3 = new UserRole(Name = 'BC Head');
                insert urg3;
            UserRole urg4 = new UserRole(Name = 'Customer Care Officer', ParentRoleId = urg3.id);
                insert urg4;
            UserRole urg5 = new UserRole(Name = 'Customer Care Representative', ParentRoleId = urg4.id);
                insert urg5;
            
            //create users
            User g3 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g3Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg3.id
                );
                insert g3;

              User g4 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g4Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg4.id            
                );
                insert g4;

              User g5 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g5Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg5.id,
                    Office__c = 'HMB - Bacoor BC'            
                );
                insert g5;

        Test.startTest();
            system.runAs(g5)
            {  
            Office__c parentOffice = CXE_TestDataFactory.createOffice(1)[0];
            parentOffice.Name = 'HMB - South Area';
            insert parentOffice;

            Office__c office = CXE_TestDataFactory.createOffice(1)[0];
            office.Name = 'HMB - Bacoor BC';
            office.Parent_RO__c = parentOffice.Id;
            insert office;

            Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();        
            Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
            insert contactRecord;           
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            insert psicRecord;
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
            caseRecord.GSL4_Check__c = true;
            caseRecord.Reason_for_GSL4_Target_Date_Modification__c = 'Test for gsl4 approval';
            caseRecord.ContactId = contactRecord.id;
            caseRecord.Individual_Business_Tag__c = 'No';
            caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
            caseRecord.PSIC__c = psicRecord.id;
            caseRecord.Initial_Responsible_Office__c = 'RO1';
            caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
            caseRecord.Tax_Identification_No__c = '123';
            caseRecord.Telephone_No__c = '+6312312421';
            caseRecord.Mobile_No__c = '+631324358765';
            caseRecord.Application_for_Business_Service__c = true;
            insert caseRecord;
            String caseId = (string)caseRecord.Id;
            String comments = 'Test Comment for Approval';
            String result = '';
            
            result = CXE_SubmitApproval_CC.submitApproval(caseId, comments);
            system.assertEquals('No Approver Found.', result);
            }
        Test.stopTest();   
    }
    
    //start :Melvin Corbes  July-14-207
    static testMethod void submitApprovalR2NSA(){
        
        //setup user and user roles
            List<User> ulist = new List<User>();    
            Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
            Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
            Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;

            //create user role heirarchy
            UserRole urg3 = new UserRole(Name = 'BC Head');
                insert urg3;
            UserRole urg4 = new UserRole(Name = 'Customer Care Officer', ParentRoleId = urg3.id);
                insert urg4;
            UserRole urg5 = new UserRole(Name = 'Customer Care Representative', ParentRoleId = urg4.id);
                insert urg5;
            
            //create users
            User g3 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g3Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg3.id,
                    Office__c = 'HMB - South Area'
                );
                insert g3;

              User g4 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g4Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg4.id            
                );
                insert g4;

              User g5 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g5Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg5.id,
                    Office__c ='HMB - Bacoor BC'         
                );
                insert g5;

            Test.startTest();
            system.runAs(g5)
            {       
            Office__c parentOffice = CXE_TestDataFactory.createOffice(1)[0];
            parentOffice.Name = 'HMB - South Area';
            insert parentOffice;

            Office__c office = CXE_TestDataFactory.createOffice(1)[0];
            office.Name = 'HMB - Bacoor BC';
            office.Parent_RO__c = parentOffice.Id;
            insert office; 
            Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        
            Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
            insert contactRecord;
            
            PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
            insert psicRecord;
            Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private')[0];
            caseRecord.GSL4_Check__c = true;
            caseRecord.GSL4_Target_Date__c = system.today();
            caseRecord.New_GSL4_Target_Date__c = system.today();
            caseRecord.Reason_for_GSL4_Target_Date_Modification__c = 'Test for gsl4 approval';
            caseRecord.ContactId = contactRecord.id;
            caseRecord.Individual_Business_Tag__c = 'No';
            caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
            caseRecord.PSIC__c = psicRecord.id;
            caseRecord.Initial_Responsible_Office__c = 'RO1';
            caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
            caseRecord.Tax_Identification_No__c = '123';
            caseRecord.Telephone_No__c = '+6312312421';
            caseRecord.Mobile_No__c = '+631324358765';
            caseRecord.Application_for_Business_Service__c = true;
            caseRecord.CXE_Request_for_Lifting_of_Arrears_Tag__c = true;
            caseRecord.CXE_Reason_for_Lifting_of_Arrears_Tag__c = 'sample';
            
            insert caseRecord;
            String caseId = (string)caseRecord.Id;
            String comments = 'Test Comment for Approval';
            String result = '';
            result = CXE_SubmitApproval_CC.submitApprovalR2(caseId, comments);
            system.assertEquals('Success', result);
         }
           Test.stopTest();
        
        
    }

    static testMethod void submitApprovalR2RSA(){
        
        //setup user and user roles
            List<User> ulist = new List<User>();    
            Id g3Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G3].Id;
            Id g4Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G4].Id;
            Id g5Id = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PROFILE_NAME_MERALCO_G5].Id;

            //create user role heirarchy
            UserRole urg3 = new UserRole(Name = 'BC Head');
                insert urg3;
            UserRole urg4 = new UserRole(Name = 'Customer Care Officer', ParentRoleId = urg3.id);
                insert urg4;
            UserRole urg5 = new UserRole(Name = 'Customer Care Representative', ParentRoleId = urg4.id);
                insert urg5;
            
            //create users
            User g3 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g3Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg3.id,
                    Office__c = 'HMB - South Area'
                );
                insert g3;

              User g4 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g4Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg4.id,
                    Office__c ='HMB - Bacoor BC'             
                );
                insert g4;

              User g5 = new User(
                    ProfileId = [SELECT Id FROM Profile WHERE Id =:g5Id].Id,
                    LastName = 'last',
                    Email = 'puser000@amamama.com',
                    Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                    CompanyName = 'TEST',
                    Title = 'title',
                    Alias = 'alias',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    UserRoleId = urg5.id,
                    Office__c ='HMB - Bacoor BC'         
                );
                insert g5;

            Test.startTest();
            system.runAs(g5)
            {       
            Office__c parentOffice = CXE_TestDataFactory.createOffice(1)[0];
            parentOffice.Name = 'HMB - South Area';
            insert parentOffice;

            Office__c office = CXE_TestDataFactory.createOffice(1)[0];
            office.Name = 'HMB - Bacoor BC';
            office.Parent_RO__c = parentOffice.Id;
            insert office; 
            Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_SERVICE_APPLICATION).getRecordTypeId();
        
            Case caseRecord = CXE_TestDataFactory.createRecontractCase(1, '382938473643')[0];
            caseRecord.Arrears_Tag__c = true;
            insert caseRecord;

            caseRecord.CXE_Request_for_Lifting_of_Arrears_Tag__c = true;
            caseRecord.CXE_Reason_for_Lifting_of_Arrears_Tag__c = 'sample';
            update caseRecord;

            String caseId = (string)caseRecord.Id;
            String comments = 'Test Comment for Approval';
            String result = '';
            result = CXE_SubmitApproval_CC.submitApprovalR2(caseId, comments);
            system.assertEquals('Success', result);
         }
           Test.stopTest();    
    }
    
   //start : Melvin Corbes Aug-31-2017
    static testMethod void getApproversTest(){
        
        
        Rate__c rateRecord = CXE_TestDataFactory.createRate();
        insert rateRecord;
        
        List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert addressRefList;
        
        for(Integer i=0 ; i<addressRefList.size() ; i++) {
            if(i>0){
                addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
            }
        }
        update addressRefList;      
        
        Map<String, Reference__c> addressReference = new Map<String, Reference__c>();
        for(Reference__c addRef : [SELECT Id, Field__c, Name_Code__c FROM Reference__c]) {
            addressReference.put(addRef.Field__c, addRef);
        }  
        
        Account acc = CXE_TestDataFactory.createBusinessAccount(1)[0];
        insert acc;
        
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;
        

        Office__c parentOffice = CXE_TestDataFactory.createOffice(1)[0];
        parentOffice.Name = 'HMB - South Area';
        insert parentOffice;

        Office__c office = CXE_TestDataFactory.createOffice(1)[0];
        office.Name = 'HMB - Bacoor BC';
        office.Parent_RO__c = parentOffice.Id;
        insert office;
        
        PSIC__c psicRecord = CXE_TestDataFactory.createPSIC(1)[0];
        insert psicRecord;
        
        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.AccountId = acc.id;
        caseRecord.Applied_Load__c = 6;
        caseRecord.Billing_Class__c = 'billing';
        caseRecord.Responsible_Office_Lookup__c = office.id;
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Phase__c = 'Single Phase (1Ø), Network';
        caseRecord.Voltage__c = '230 V';
        caseRecord.Application_Type_Subtype__c = 'New Electric Service';
        caseRecord.Demand_Factor__c = 10;
        caseRecord.Load_Factor__c = 5 ;
        caseRecord.Contracted_Capacity__c = 10;
        caseRecord.Service_Supply_Type__c = 'service';
        caseRecord.Project_Type__c = 'project Type';
        caseRecord.Service_Rate_Type__c = 'service rate';
        caseRecord.Deposit_Amount__c = 100;
        caseRecord.Telephone_No__c = '+6312312340';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Application_for_Business_Service__c = true;
        insert caseRecord;
        
        Address__c addressRec = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec.Case__c = caseRecord.Id;
        addressRec.Type__c = 'Service';
        insert addressRec;
        
        Address__c addressRec2 = CXE_TestDataFactory.createAddress(addressReference, true);
        addressRec2.Case__c = caseRecord.Id;
        addressRec2.Type__c = 'Billing';
        insert addressRec2;
        
        Test.startTest();
        
        Id approverId =CXE_SubmitApproval_CC.getApprover(caseRecord.Id);
        Map<String,Id>getMapForApproverIds =CXE_SubmitApproval_CC.getMapForApproverIds(caseRecord);
        Approval.ProcessSubmitRequest  reqSubmit = CXE_SubmitApproval_CC.createApproval(caseRecord.Id, 
                                                                             'comments', 'approvalProcessName',  approverId);
		//submitApprovalR2(String caseId, String comments)
		Case caseRec =[SELECT Id,Status 
                       FROM Case
                       WHERE Id =:caseRecord.Id][0];
        
        caseRec.Status ='Application Validated';
        update caseRec;
        
        String comments = 'Test Comment for Approval';
            String result = '';
            result = CXE_SubmitApproval_CC.submitApprovalR2(caseRec.Id, comments);
        //CXE_SubmitApproval_CC.String submitApprovalR2

        
        Test.stopTest();
        
        System.assertEquals('No Approver Found.', result);
    }
}