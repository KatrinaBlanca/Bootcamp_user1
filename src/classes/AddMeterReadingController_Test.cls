@isTest
public class AddMeterReadingController_Test {
    
    public static Case cs;
    @isTest 
    static void testAddMeterReadingController(){
        cs = new Case(Subject='Test Controller Acct Case');
        insert cs;
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        test.startTest();
        AddMeterReadingController pcc = new AddMeterReadingController(sc);
        test.stopTest();
    }
	
	//static testMethod void constructorTest(){
		
	//	List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
 //       Account testAccount = testAccountList.get(0);
 //       insert testAccount;

	//	List<Connection__c> testConnectionList = CXE_TestDataFactory.createConnection(1);
	//	Connection__c testConnection = testConnectionList.get(0);
	//	insert testConnection;

	//	List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
 //       Case testCase = testCaseList.get(0);
 //       testCase.CaseConnection__c = testConnection.Id;
 //       insert testCase;

	//	Case_Connection__c testCaseConnection = new Case_Connection__c(Connection__c = testConnection.Id,
	//																   Account__c = testAccount.Id);
	//	insert testCaseConnection;

	//	Test.StartTest();
 //           ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testCase);
 //       	AddMeterReadingController ctrl = new AddMeterReadingController(standardCon);
 //       Test.StopTest();

 //       System.assertEquals(testCase.Id, ctrl.ThisCase.Id);
 //       System.assertEquals(testConnection.Id, ctrl.con.Id);
 //       System.assertEquals(false, ctrl.prevmtrs.isEmpty());
 //       System.assertEquals(false, ctrl.displaypopup);
 //       System.assertEquals(false, ctrl.displaypopup1);
	//}

	//static testMethod void stringMethodsTest(){

 //       List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
 //       Account testAccount = testAccountList.get(0);
 //       insert testAccount;

	//	List<Connection__c> testConnectionList = CXE_TestDataFactory.createConnection(1);
	//	Connection__c testConnection = testConnectionList.get(0);
	//	insert testConnection;

	//	List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
 //       Case testCase = testCaseList.get(0);
 //       testCase.CaseConnection__c = testConnection.Id;
 //       testCase.Subject = 'Test';
 //       insert testCase;

	//	Case_Connection__c testCaseConnection = new Case_Connection__c(Connection__c = testConnection.Id,
	//																   Account__c = testAccount.Id);
	//	insert testCaseConnection;

	//	Test.StartTest();
 //           ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testCase);
 //       	AddMeterReadingController ctrl = new AddMeterReadingController(standardCon);
 //       Test.StopTest();

 //       System.assertEquals('Case - Add Meter Reading', ctrl.title);
 //       System.assertEquals('Test', ctrl.subtitle);
	//}

	//static testMethod void voidMethodsTest(){

 //       List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
 //       Account testAccount = testAccountList.get(0);
 //       insert testAccount;

	//	List<Connection__c> testConnectionList = CXE_TestDataFactory.createConnection(1);
	//	Connection__c testConnection = testConnectionList.get(0);
	//	insert testConnection;

	//	List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
 //       Case testCase = testCaseList.get(0);
 //       testCase.CaseConnection__c = testConnection.Id;
 //       testCase.Subject = 'Test';
 //       insert testCase;

	//	Case_Connection__c testCaseConnection = new Case_Connection__c(Connection__c = testConnection.Id,
	//																   Account__c = testAccount.Id, 
	//																   Meter_Read_Value__c = 1);
	//	insert testCaseConnection;

	//	Test.StartTest();
 //           ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testCase);
 //       	AddMeterReadingController ctrl = new AddMeterReadingController(standardCon);
 //       	ctrl.plausibility();
 //       	ctrl.CaseCon.Meter_Read_Value__c = 2;
 //       	ctrl.plausibility();
 //       	ctrl.closePopup();
 //       	ctrl.closepopup1();
 //       	ctrl.correctinvoice();
 //       Test.StopTest();

 //       System.assertEquals(false, ctrl.displayPopup1);
 //       System.assertEquals(true, ctrl.displayPopup);
	//}

	//static testMethod void pageReferenceMethodsTest(){

 //       List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
 //       Account testAccount = testAccountList.get(0);
 //       insert testAccount;

	//	List<Connection__c> testConnectionList = CXE_TestDataFactory.createConnection(1);
	//	Connection__c testConnection = testConnectionList.get(0);
	//	insert testConnection;

	//	List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
 //       Case testCase = testCaseList.get(0);
 //       testCase.AccountId = testAccount.Id;
 //       testCase.CaseConnection__c = testConnection.Id;
 //       testCase.Subject = 'Test';
 //       insert testCase;

	//	Case_Connection__c testCaseConnection = new Case_Connection__c(Connection__c = testConnection.Id,
	//																   Account__c = testAccount.Id, 
	//																   Meter_Read_Value__c = 1);
	//	insert testCaseConnection;

	//	Test.StartTest();
 //           ApexPages.Standardcontroller standardCon = new ApexPages.Standardcontroller(testCase);
 //       	AddMeterReadingController ctrl = new AddMeterReadingController(standardCon);
 //       	ctrl.cancel();
 //       	ctrl.save();
 //       	ctrl.CaseCon.Meter_Read_Value__c  = 1;
 //       	ctrl.save();
 //       	ctrl.CaseCon.Plausibility_Result__c = 'Test';
 //       	ctrl.save();
 //       	ctrl.savemr();
 //       	ctrl.CaseCon.Meter_Read_Value__c  = null;
 //       	ctrl.donotsave();
 //       	ctrl.CaseCon.Meter_Read_Value__c  = 1;
 //       	ctrl.CaseCon.Plausibility_Result__c = 'Meter Reading Plausible';
 //       	ctrl.donotsave();
 //       	ctrl.CaseCon.Plausibility_Result__c = 'Test';
 //       	ctrl.donotsave();
 //       	ctrl.donotsavemr();
 //       Test.StopTest();

 //       System.assertEquals(false, ctrl.displayPopup);
	//}
}