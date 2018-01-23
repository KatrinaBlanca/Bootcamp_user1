@isTest
private class CXE_CP_APAFileUpload_CC_Test {
	
	@testSetup
    static void setupOrgData(){
        OrganizationSettings__c orgSet = new OrganizationSettings__c();
        orgSet.Heroku_Basic_Auth__c = 'Basic TEST=';
        insert orgSet;

        CXE_KeyValueSetting__c keyVal = new CXE_KeyValueSetting__c();
        keyVal.Name = 'APA_UPLOAD_MAX_FILESIZE';
        keyVal.Value__c = '2000000';
        insert keyVal;
    }

	@isTest static void getCaseDetailsTest() {
		List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
       
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;

        //CREATE PayOps USER ACCOUNT
        Profile payOps = [SELECT Id FROM Profile WHERE Name ='Payment Operations' Limit 1];
        User payOpsUser = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ProfileId = payOps.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );

        system.runAs(payOpsUser){
            Case apaCase = CXE_TestDataFactory.createAPACase(1, true, testContract.Id)[0];
            insert apaCase;

            test.startTest();
            Case c = CXE_CP_APAFileUpload_CC.getCaseDetails(apaCase.Id);
            System.assertNotEquals(null, c);
            test.stopTest();
        }
	}
	
	@isTest static void updateFileCountTest_SUCCESS() {
		List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;
       
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
        testCase.RecordTypeId = newServiceApplicationRecordTypeId;
        testCase.Tax_Identification_No__c = '1111111';
        testCase.AccountId = testAccount.Id;
        insert testCase;
        
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             V10_Account_No__c = '12345678',
                                             Method_of_Payment__c = 'Over the Counter',
                                             Bill_Print_Mode__c = 'Paper',
                                             Type__c = 'Regular');
        insert testContract;

        //CREATE PayOps USER ACCOUNT
        Profile payOps = [SELECT Id FROM Profile WHERE Name ='Payment Operations' Limit 1];

        User payOpsUser = new User(
            Username = System.now().millisecond() + 'test12345@test.com',
            ProfileId = payOps.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );

        system.runAs(payOpsUser){
            Case apaCase = CXE_TestDataFactory.createAPACase(1, true, testContract.Id)[0];
            apaCase.CXE_APA_Attachment_Count__c = 0;
            insert apaCase;

            test.startTest();
                String result = CXE_CP_APAFileUpload_CC.updateFileCount(apaCase.Id, 1);
                System.assertEquals('SUCCESS', result);

            Case updatedCase = [SELECT CXE_APA_Attachment_Count__c 
            					FROM Case WHERE Id=:apaCase.Id LIMIT 1];
            System.assertEquals(1, updatedCase.CXE_APA_Attachment_Count__c);
            test.stopTest();
        }
	}

	@isTest static void updateFileCountTest_FAILED() {
		test.startTest();
        String result = CXE_CP_APAFileUpload_CC.updateFileCount(null, 1);
        System.assertEquals('FAILED', result);
        test.stopTest();
	}

	@isTest static void getKeyValTest() {
		List<CXE_KeyValueSetting__c> keyValSet = CXE_CP_APAFileUpload_CC.getKeyValSettings();
		System.assert(!keyValSet.isEmpty());
	}

	@isTest static void upload_signTest() {
		String sign = CXE_CP_APAFileUpload_CC.upload_sign('APADocument');
	}
	
}