@isTest
public class BotTest {


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
    }


    static testMethod void uploadTest() {
        Test.startTest();
       
        BotResponse response= BotController.upload('filename', 'content'); 
        Test.stopTest();
        
    }

    
    static testMethod void testBotController() {
		Bot_Command__c bc = new Bot_Command__c(Sample_Utterance__c='help lightning', apex_class__c='HandlerHelpTopic', pattern__c='help (.*)');
        insert bc;
        BotResponse response = BotController.submit('help lightning', null);
        Map<String, String> session = response.session;
        response = BotController.submit('Developer', session);
        System.assert(response.messages[0].items.size() > 0);
    }

    static testMethod void testHello() {
        BotHandler handler = new HandlerHello();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages[0].messageText == 'Hi there!');
    }

    static testMethod void testAddTwoNumbers() {
        BotHandler handler = new HandlerAddTwoNumbers();
        BotResponse response = handler.handle('', null, null);
        Map<String, String> session = response.session;
        response = handler.handle('1', null, session);
        session = response.session;
        response = handler.handle('2', null, session);
        System.assert(response.messages[0].messageText == '1 + 2 = 3');
    }
    
    static testMethod void testCostCenter() {
        BotHandler handler = new HandlerCostCenter();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages[0].messageText == 'Your cost center is 21852');
    }
    
    static testMethod void testEmployeeId() {
        BotHandler handler = new HandlerEmployeeId();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages[0].messageText == 'Your employee id is 9854');
    }

    static testMethod void testFindAccount() {
		Account a = new Account(Name='TestAccount',
                               	Email__c = 'TestEmail@email.com',
                                Mobile_Phone__c ='+639268152782',
                                Phone = '+6325325000',
                                Tax_Identification_No__c ='12345678911'
                               );
		insert a;
        BotHandler handler = new HandlerFindAccount();
        BotResponse response = handler.handle('', new String[]{'Test'}, null);
        System.assert(response.messages[0].records.size() == 1);
    }
    
    static testMethod void testFindContact() {
		Contact c = new Contact(LastName='TestContact',
                               	FirstName = 'TestContact',
                                Email = 'TestEmail@email.com',
                                Phone = '+6325325000',
                                MobilePhone = '+639268152782'
                               );
        insert c;
        BotHandler handler = new HandlerFindContact();
        BotResponse response = handler.handle('', new String[]{'Test'}, null);
        System.assert(response.messages[0].records.size() == 1);
    }
    
	static testMethod void testHelp() {
		Bot_Command__c bc = new Bot_Command__c(Sample_Utterance__c='Hello', apex_class__c='HelloHandler', pattern__c='Hello');
        insert bc;
        BotHandler handler = new HandlerHelp();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages[0].items.size() == 1);
    }
    
	static testMethod void testHelpTopic() {
        BotHandler handler = new HandlerHelpTopic();
        BotResponse response = handler.handle('', null, null);
        Map<String, String> session = response.session;
		handler.handle('User', null, session);
        
        response = handler.handle('', null, null);
        session = response.session;
		response = handler.handle('Admin', null, session);

        response = handler.handle('', null, null);
        session = response.session;
		response = handler.handle('Developer', null, session);

        System.assert(response.messages[0].items.size() > 0);
    }
    
	static testMethod void testMyOpenCases() {
        BotHandler handler = new HandlerMyOpenCases();
        BotResponse response = handler.handle('', null, null);
        //System.assert(response.messages[0].records.size() == 1);
    }

	static testMethod void testTopOpportunities() {
		Account a = new Account(Name='TestAccount',
                               	Email__c = 'TestEmail@email.com',
                                Mobile_Phone__c ='+639268152782',
                                Phone = '+6325325000',
                                Tax_Identification_No__c ='12345678911'
                               );
		insert a;
		Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
		insert o;
        BotHandler handler = new HandlerTopOpportunities();
        BotResponse response = handler.handle('', new String[]{'3'}, null);
        System.assert(response.messages[0].records.size() == 1);
    }

	static testMethod void testTravelApproval() {
        BotHandler handler = new HandlerTravelApproval();
        BotResponse response = handler.handle('', null, null);
        Map<String, String> session = response.session;
		handler.handle('Boston', null, session);
		handler.handle('Customer Facing', null, session);
		handler.handle('02/23/2017', null, session);
		handler.handle('1000', null, session);
		handler.handle('1000', null, session);
        System.assert(response.messages[0].messageText.length() > 0);
    }

	static testMethod void testPipeline() {
        BotHandler handler = new HandlerPipeline();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages[0].imageURL != null);
    }

	static testMethod void testQuarter() {
        BotHandler handler = new HandlerQuarter();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages[0].imageURL != null);
    }

    static testMethod void testNext() {
		Account a = new Account(Name='TestAccount',
                               	Email__c = 'TestEmail@email.com',
                                Mobile_Phone__c ='+639268152782',
                                Phone = '+6325325000',
                                Tax_Identification_No__c ='12345678911'
                               );
		insert a;
		Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
		insert o;

		List<Case> cList = [SELECT Id FROM Case];
        cList[0].Priority='High';
		update cList;
        BotHandler handler = new HandlerNext();
        BotResponse response = handler.handle('', null, null);
        System.assert(response.messages.size() > 1);
    }

    static testMethod void testSOQL() {
		Account a = new Account(Name='TestAccount',
                               	Email__c = 'TestEmail@email.com',
                                Mobile_Phone__c ='+639268152782',
                                Phone = '+6325325000',
                                Tax_Identification_No__c ='12345678911'
                               );
		insert a;
        BotHandler handler = new HandlerSOQL();
        BotResponse response = handler.handle('select id from account', null, null);
        //System.assert(true , response.messages[0].records.size() == 1);
    }
    
    
    
    

}