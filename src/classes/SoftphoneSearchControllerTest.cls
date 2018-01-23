@isTest(SeeAllData=true) 
private class SoftphoneSearchControllerTest {   
    /*
    private static testMethod void testDoSearch() {
    List<Contact> lstCont = CXE_TestDataFactory.createContact(1);
    Contact cont = lstCont.get(0);
    cont.FirstName = 'Lauren';
    insert cont;
       SoftphoneSearchController softphoneSearchController = new SoftphoneSearchController();       
       softphoneSearchController.contactName = 'Lauren';
       softphoneSearchController.doSearch();
       System.assert(softphoneSearchController.contactList.size() > 0, 'Result list should contain at least one contact');       
    }

    private static testMethod void testGetContacts() {
        // ANI to search on
        string ANI = '+6312345678'; 
        // Create Contact
        Contact contact = new Contact();
        contact.FirstName = 'Test' + DateTime.now();
        contact.LastName = 'SoftphoneSearchControllerTest';
        contact.phone = ANI;
        insert contact; 
        try {
            // Test contact query method
            System.assert(SoftphoneSearchController.getContacts(ANI).contains(ANI), 'Result should contain at least one contact with ANI');
        } finally {
            // Delete Contact
            delete contact;
        }
    }
    
    private static testMethod void testGetCases() {
        //Create Case
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case cs = testCaseList.get(0);
        cs.Last_Name_Business_Name__c = 'Test';
        insert cs;
        
        String caseNum = '';

        Case caseRec = [SELECT CaseNumber FROM Case WHERE Id=:cs.Id LIMIT 1];
        if(caseRec != null){
            caseNum = caseRec.CaseNumber;            
        }

        // We're going to hardcode the case number here because the call control always looks for case 00001001
        string CaseNumber = '00001001';    
        System.assert(SoftphoneSearchController.getCases(caseNum).contains(caseNum), 'Result should contain at least one case with this case number');
    }

    // Start CXE Update Class
    private static testMethod void testGetLead() {
        //Create Lead
        string ANI = '+6321231234'; 

        Lead testLead = CXE_TestDataFactory.createCreateLead(1)[0];
        testLead.Phone = '+6321231234';
        insert testLead;
        
        try {
            // Test contact query method
            System.assert(SoftphoneSearchController.getLeads(ANI).contains(ANI), 'Result should contain at least one contact with ANI');
        } finally {
            // Delete Contact
            delete testLead;
        }
        
    }
    // End CXE Update Class
    */
}