@isTest
public class CXE_APADownloadController_Test {
	
    @testSetup
    static void setupOrgData(){
        OrganizationSettings__c orgSet = new OrganizationSettings__c();
        orgSet.Heroku_Basic_Auth__c = 'Basic TEST=';
        insert orgSet;
    }

    @isTest
    static void redirectToDownloadURLtest(){
        Auto_Payment_Arrangement__c apaRec = new Auto_Payment_Arrangement__c();
        apaRec.Status__c = 'Available';
        apaRec.Date__c = date.today();
        insert apaRec;
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.CXE_APADownload'));
        System.currentPageReference().getParameters().put('id', apaRec.Id);

        CXE_APADownloadController apaDownload = new CXE_APADownloadController();
        apaDownload.apaId = apaRec.Id;
    	PageReference pageRef = apaDownload.redirectToDownloadURL();
        System.assertNotEquals(pageRef, null);
        test.stopTest();
    }

    @isTest
    static void redirectToDownloadURLtest_Downloaded(){
        Auto_Payment_Arrangement__c apaRec = new Auto_Payment_Arrangement__c();
        apaRec.Status__c = 'Downloaded';
        apaRec.Date__c = date.today();
        insert apaRec;
        
        test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.CXE_APADownload'));
        System.currentPageReference().getParameters().put('id', apaRec.Id);

        CXE_APADownloadController apaDownload = new CXE_APADownloadController();
        apaDownload.apaId = apaRec.Id;
        PageReference pageRef = apaDownload.redirectToDownloadURL();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        Boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('File has already been downloaded.')) b = true;
        }
        System.assert(b);
        test.stopTest();
    }
}