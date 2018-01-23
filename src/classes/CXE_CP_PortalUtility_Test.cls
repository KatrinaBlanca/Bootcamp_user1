@isTest
public class CXE_CP_PortalUtility_Test{

    @testSetup static void setup() {

        Test.startTest();

        CXE_TestDataFactory.setOrgSettings();

        //Create PSIC
        List<PSIC__c> psicLst = CXE_TestDataFactory.createPSIC(1);
        psicLst[0].Name = 'Non-Residential';
        psicLst[0].Demand_Factor__c = .80;
        psicLst[0].PSIC_Code__c = '77770';
        insert psicLst;
        system.assertEquals(true, psicLst[0].Id!=null );

        List<Account> acctList = CXE_TestDataFactory.createPersonAccount(1);
            acctList[0].FirstName = 'first';
            acctList[0].MiddleName = 'middle';
            acctList[0].LastName = 'last';
            acctList[0].Email__c = 'first_last_name@yopmail.com';
        insert acctList;
        system.assertEquals(true, acctList[0].Id!=null );

        Account acct = [Select Id, PersonContactId From Account 
                        Where Id =: acctList[0].Id ];
        system.assertEquals(true, acct.PersonContactId!=null );

         //Create Case
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();  
        List<Case> createCase = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        createCase[0].RecordTypeId = newServiceApplicationRecordTypeId;
        createCase[0].PSIC__c = psicLst[0].id;
        createCase[0].ContactId = acct.PersonContactId;
        createCase[0].AccountId = acct.Id;
        createCase[0].Applied_Load__c = 6;
        createCase[0].Demand_Factor__c = 0.50;
        createCase[0].Load_Factor__c = 0.25;
        createCase[0].Phase__c = 'Single Phase (1Ø), Network';
        createCase[0].Service_Supply_Type__c = 'Normal with meter';
        createCase[0].Service_Wire_Length__c = 1;
        createCase[0].Material__c = 'Copper';
        createCase[0].Pole_Code__c = '1';
        createCase[0].Wire_Size__c = '#1/0';
        createCase[0].Service_Wire_Type__c = 'Under Copper,Lateral';
        createCase[0].Voltage__c = '2.0 kV';
        createCase[0].Application_for_Business_Customer__c = false;
        createCase[0].Application_for_Residential_Customer__c = true;
        
        insert createCase;
        system.assertEquals(true, createCase[0].Id!=null );

        
        //Create Contract
        List<Contract> createContract = CXE_TestDataFactory.createContract(1,acct.id,createCase[0].id);
        createContract[0].V10_Account_No__c = '584950609109';
        insert createContract;
        system.assertEquals(true, createContract[0].Id!=null );

        //Create Address
        Address__c createAddress = CXE_TestDataFactory.createAddress(acct.id,createCase[0].id,createContract[0].id);
        insert createAddress;
        system.assertEquals(true, createAddress.Id!=null );
        
        //Create Service
        //Modified by Rom - changed method call from createService() to createServiceWithLessDetails()
        List<Agreement__c> createService = CXE_TestDataFactory.createServiceWithLessDetails(1,acct.id,createCase[0].id,
                                                                createContract[0].id,psicLst[0].id);
        createService[0].Payor__c = createContract[0].id;
        createService[0].Code_Segment__c = CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP002;
        insert createService;
        createService[0].SIN__c = '293028374839';
        update createService;
        system.assertEquals(true, createService[0].Id!=null );

        Test.stopTest();
    }


    @isTest
    static void test_retrievePortalData()
    {
        List<User> userList = [Select Id From User Where Profile.Name =: CXE_Constants.MERALCO_CUSTOMER_COMMUNITY_PROFILE];

        List<Agreement__c> agreementList = [Select Id, Contract__c, Payor__c From Agreement__c 
                                        Where SIN__c = '293028374839'];
        System.assertEquals(1, agreementList.size() );
        System.assertEquals(agreementList[0].Contract__c, agreementList[0].Payor__c );
        
        CXE_CP_PortalUtility.PortalData portalUtilData;
        CXE_CP_PortalUtility.PortalData portalUtilData2;
        List<CXE_Service_Enrollment__c> enrollmentList;
        List<CXE_Service_Enrollment__c> enrollmentList2;
        List<User> portalUserList;

        Test.startTest();

            System.runAs(userList[0]){
                CXE_CP_SplashPageSelfRegistration_CC.createUser(
                        'first_last_name@yopmail.com', 
                        'first', 
                        'middle', 
                        'last', 
                        'Mr', 
                        '+639001110011', 
                        '293028374839', 
                        300, 
                        '2018-3-15', 
                        false
                    );
            }

            portalUserList = [SELECT Id, ProfileId, ContactId FROM User 
                                WHERE Profile.Name = :CXE_Constants.PORTAL_COMMUNITY_PROFILE
                                AND Email = 'first_last_name@yopmail.com'];                            
            System.assertEquals(1, portalUserList.size() );


            System.runAs(portalUserList[0]){
                Set<Id> enrollmentIds = new Set<Id>();
                Set<Id> contractIds = new Set<Id>();
                portalUtilData = CXE_CP_PortalUtility.retrievePortalData();
                portalUtilData2 = CXE_CP_PortalUtility.retrievePortalData(true);

                for(CXE_Service_Enrollment__c enrol : portalUtilData.UserEnrollments){
                    enrollmentIds.add(enrol.Id);
                }
                for(Contract contract : portalUtilData.UserContracts){
                    contractIds.add(contract.Id);
                }
                enrollmentList = CXE_CP_PortalUtility.retrieveServiceEnrollments(enrollmentIds);
                enrollmentList2 = CXE_CP_PortalUtility.retrieveExistingServiceEnrollmentsOfPayor(contractIds, new Set<Id>{} );
                Id portalProfileId = CXE_CP_PortalUtility.retrieveCustomerPortalProfileId();
                System.assertEquals(portalUserList[0].ProfileId, portalProfileId);
                Id contactId = CXE_CP_PortalUtility.getCurrentUserContacId();
                System.assertEquals(portalUserList[0].ContactId, contactId);
            }
        
        Test.stopTest();

        /*List<Exception_Log__c> logList = [SELECT Id, Exception__c,Class_Name__c, Method_Name__c FROM Exception_Log__c];
        if(logList.size()>0){
            System.assertEquals(1, logList.size() );
            System.assertEquals('test', logList[0].Class_Name__c + ' ' + logList[0].Method_Name__c + ' ' + logList[0].Exception__c );
        }
        else{*/

        //}

        List<Contract> contractList = [SELECT Id, V10_Account_No__c
                                                        FROM Contract]; 
        System.assertEquals(1, contractList.size() );  

        List<CXE_Service_Enrollment__c> enrollments = [SELECT Id, CXE_IsActive__c, CXE_UserId__c, CXE_ServiceId__c, CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                        FROM CXE_Service_Enrollment__c];
        System.assertEquals(1, enrollments.size() ); /*
        System.assertEquals('test: ' + String.valueOf(contractList[0]), 
                String.valueOf(enrollments[0])+enrollments[0].CXE_ServiceId__r.Payor__r.V10_Account_No__c );*/

        System.assertEquals(1, portalUtilData.ServiceCount);
        System.assertEquals(1, portalUtilData2.ServiceCount);
        System.assertEquals(1, enrollmentList.size());
        System.assertEquals(1, enrollmentList2.size());


    }


    
}