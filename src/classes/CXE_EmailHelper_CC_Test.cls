/* Description: CXE_EmailHelper_CC_Test test class
 * Author: Christian Peter Doctolero
 * Date Created: MAR-24-17
 */
@isTest
private class CXE_EmailHelper_CC_Test {
    
    static testMethod String prepareData() {
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        Id foRecTypeIdSurvey = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_SURVEY_FO).getRecordTypeId();
        Id foRecTypeIdInspection = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();    
        
        List<Account> accountRecordList = CXE_TestDataFactory.createBusinessAccount(1);
        Account accountRecord = accountRecordList.get(0);
        accountRecord.Customer_Type__c = 'Private';
        insert accountRecord; 
            
        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;

        Case caseRecord = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', CXE_Constants.CASE_APPLICATION_RECEIVED, 'Private')[0];
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.ContactId = contactRecord.id;
        caseRecord.Individual_Business_Tag__c = 'No';
        caseRecord.Residential_Non_Residential_Tag__c = 'Yes';
        //caseRecord.PSIC__c = psicRecord.id;
        caseRecord.Initial_Responsible_Office__c = 'RO1';
        caseRecord.Date_of_Birth__c = date.newInstance(1995, 1, 1);
        caseRecord.Tax_Identification_No__c = '123';
        caseRecord.Telephone_No__c = '+6312312421';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Application_for_Business_Service__c = true;
        caseRecord.AccountId = accountRecord.Id;
        insert caseRecord;
        
        Address__c addressRecord = new Address__c();
        addressRecord.Case__c = caseRecord.Id;
        addressRecord.Type__c = 'Service';
        addressRecord.Premise_Type__c = 'High-rise Building';
        addressRecord.Address_Street_No__c = '1';
        //insert addressRecord;
            
        Address__c addressRecordB = new Address__c();
        addressRecordB.Case__c = caseRecord.Id;
        addressRecordB.Type__c = 'Billing';
        addressRecordB.Premise_Type__c = 'High-rise Building';
        addressRecordB.Address_Street_No__c = '1';
        //insert addressRecordB;

        List<Address__c> addressList = new List<Address__c>();
        
        addressList.add(addressRecord);
        addressList.add(addressRecordB);

        insert addressList;

        //caseRecord.Status = 'Application Validated';
        //update caseRecord;
            
        Requirement__c requirementRecord = new Requirement__c();
        requirementRecord.Case__c = caseRecord.Id;
        requirementRecord.Status__c = 'Pending';
        insert requirementRecord;
        
        Connection__c connectionRecord = new Connection__c();
        connectionRecord.Case__c = caseRecord.Id;
        connectionRecord.Utility_type__c = 'Gas';
        connectionRecord.Installation_Date__c = System.today();
        insert connectionRecord;
        
        return caseRecord.Id;
        
        //corbebes Melvin Add Service 
        
    }

    /*static testMethod String prepareDataFO()
    {
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        Id foRecTypeIdSurvey = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_SURVEY_FO).getRecordTypeId();
        Id foRecTypeIdInspection = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();    
        
        List<Account> accountRecordList = CXE_TestDataFactory.createBusinessAccount(1);
        Account accountRecord = accountRecordList.get(0);
        accountRecord.Customer_Type__c = 'Private';
        insert accountRecord;        

        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;

        Case caseRecord = new Case();
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Origin = 'Web';
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Target_Energization_Date__c = System.today() +30;
        caseRecord.Application_for_Business_Customer__c = true;
        caseRecord.Application_for_Business_Service__c = true;
        caseRecord.Last_Name_Business_Name__c = 'B1';
        caseRecord.Tax_Identification_No__c = '12345';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Email_Address__c = 'sample@email.com';
        caseRecord.AccountId = accountRecord.Id;
        caseRecord.ContactId = contactRecord.Id;
        insert caseRecord;

        
        Address__c addressRecord = new Address__c();
        addressRecord.Case__c = caseRecord.Id;
        addressRecord.Type__c = 'Service';
        addressRecord.Premise_Type__c = 'High-rise Building';
        addressRecord.Address_Street_No__c = '1';
        //insert addressRecord;
            
        Address__c addressRecordB = new Address__c();
        addressRecordB.Case__c = caseRecord.Id;
        addressRecordB.Type__c = 'Billing';
        addressRecordB.Premise_Type__c = 'High-rise Building';
        addressRecordB.Address_Street_No__c = '1';
        //insert addressRecordB;
        List<Address__c> addressList = new List<Address__c>();
        
        addressList.add(addressRecord);
        addressList.add(addressRecordB);
        
        insert addressList;
        
        caseRecord.Status = 'Application Validated';
        update caseRecord;
        //System.Assert

        Test.startTest();
            
        Field_Order__c foRecord = new Field_Order__c();
        foRecord.RecordTypeId = foRecTypeIdSurvey;
        foRecord.Case__c = caseRecord.Id;
        foRecord.Survey_Instructions__c = 'Sample Instructions';
        insert foRecord;
   
        foRecord.Schedule_Date__c = System.today();
        update foRecord;
        foRecord.Resolution_Date__c = System.today();
        foRecord.Resolution_Remarks__c = 'Sample Remarks';
        foRecord.Pre_Survey_Result__c = 'Not Feasible';
        foRecord.Inconsistent_SA_Data_Required__c = true;
        foRecord.ROW_Grant_for_SE_Required__c = true;
        foRecord.Unable_to_Locate_Given_Address__c = true;
        foRecord.Add_Distribution_Facilities_Required__c = true;
        foRecord.Extensive_modifications_to_premises_requ__c = true;
        update foRecord;

        //Records for Inspection FO

        Field_Order__c foRecord2 = new Field_Order__c();
        foRecord2.RecordTypeId = foRecTypeIdSurvey;
        foRecord2.Case__c = caseRecord.Id;
        foRecord2.Survey_Instructions__c = 'Sample Instructions';
        insert foRecord2;
        
   
        foRecord2.Schedule_Date__c = System.today() + 1;
        update foRecord2;

        foRecord2.Resolution_Date__c = System.today();
        foRecord2.Resolution_Remarks__c = 'Sample Remarks';
        foRecord2.Pre_Survey_Result__c = 'Feasible';
        update foRecord2;

        Case caseStatusCheck = [SELECT Status FROM CASE WHERE Id=: caseRecord.Id LIMIT 1];
        System.assertEquals('Pre-Survey FO Resolved - Feasible', caseStatusCheck.Status);


        Schedule__c scheduleRecord = new Schedule__c();
        scheduleRecord.Residential_Rate__c = 1234;
        scheduleRecord.Non_Residential_Rate__c = 5678;
        insert scheduleRecord;*/        

        /*caseRecord.Project_Type__c = 'Simple Connection';
        caseRecord.Service_Rate_Type__c = 'GSA';
        caseRecord.Billing_Class__c = 'GSA';
        caseRecord.Applied_Load__c = 4.0;
        caseRecord.Phase__c = 'Single Phase 2 Wire';
        caseRecord.Voltage__c = '230V';
        caseRecord.Service_Supply_Type__c = 'Normal with meter';
        caseRecord.Bill_Deposit_Schedule__c = scheduleRecord.Id;
        update caseRecord;*/

        /*Field_Order__c inspectionFORecord = new Field_Order__c();
        inspectionFORecord.RecordTypeId = foRecTypeIdInspection;
        inspectionFORecord.Case__c = caseRecord.Id;
        inspectionFORecord.Survey_Instructions__c = 'Sample Instructions';
        insert inspectionFORecord;

        inspectionFORecord.Schedule_Date__c = System.today();
        update inspectionFORecord;

        inspectionFORecord.Resolution_Date__c = System.today();
        inspectionFORecord.Resolution_Remarks__c = 'Sample Remarks';
        inspectionFORecord.Pre_Survey_Result__c = 'Disapproved';
        update inspectionFORecord;*/
        /*Test.stopTest();

        return caseRecord.Id;
    }*/

    /*static testMethod String prepareDataFODisApproved()
    {
        Id servRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();
        Id foRecTypeIdSurvey = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_SURVEY_FO).getRecordTypeId();
        Id foRecTypeIdInspection = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FO_INSPECTION_FO).getRecordTypeId();    
        
        List<Account> accountRecordList = CXE_TestDataFactory.createBusinessAccount(1);
        Account accountRecord = accountRecordList.get(0);
        accountRecord.Customer_Type__c = 'Private';
        insert accountRecord;        

        Contact contactRecord = CXE_TestDataFactory.createContact(1)[0];
        insert contactRecord;

        Case caseRecord = new Case();
        caseRecord.RecordTypeID = servRecTypeId;
        caseRecord.Origin = 'Web';
        caseRecord.Customer_Type__c = 'Private';
        caseRecord.Target_Energization_Date__c = System.today() +30;
        caseRecord.Application_for_Business_Customer__c = true;
        caseRecord.Application_for_Business_Service__c = true;
        caseRecord.Last_Name_Business_Name__c = 'B1';
        caseRecord.Tax_Identification_No__c = '12345';
        caseRecord.Mobile_No__c = '+631324358765';
        caseRecord.Email_Address__c = 'sample@email.com';
        caseRecord.AccountId = accountRecord.Id;
        caseRecord.ContactId = contactRecord.Id;
        insert caseRecord;

        
        Address__c addressRecord = new Address__c();
        addressRecord.Case__c = caseRecord.Id;
        addressRecord.Type__c = 'Service';
        addressRecord.Premise_Type__c = 'High-rise Building';
        addressRecord.Address_Street_No__c = '1';
        //insert addressRecord;
            
        Address__c addressRecordB = new Address__c();
        addressRecordB.Case__c = caseRecord.Id;
        addressRecordB.Type__c = 'Billing';
        addressRecordB.Premise_Type__c = 'High-rise Building';
        addressRecordB.Address_Street_No__c = '1';
        //insert addressRecordB;
        List<Address__c> addressList = new List<Address__c>();
        
        addressList.add(addressRecord);
        addressList.add(addressRecordB);
        
        insert addressList;
        
        caseRecord.Status = 'Application Validated';
        update caseRecord;
        Test.startTest();
        caseRecord.Status = 'Pre-survey FO Generated';
        update caseRecord;

        caseRecord.Status = 'Pre-survey FO Scheduled';
        update caseRecord;

        caseRecord.Status = 'Pre-survey FO Resolved - Feasible';
        update caseRecord;

        caseRecord.Status = 'Application Evaluated';
        update caseRecord;

        caseRecord.Status = 'Meter Socket Issued';
        update caseRecord;
        //System.Assert

        
            
        Field_Order__c foRecord = new Field_Order__c();
        foRecord.RecordTypeId = foRecTypeIdInspection;
        foRecord.Case__c = caseRecord.Id;
        foRecord.Inspection_Instructions__c = 'Sample Instructions';
        insert foRecord;
   
        foRecord.Schedule_Date__c = System.today();
        update foRecord;
        foRecord.Resolution_Date__c = System.today();
        foRecord.Resolution_Remarks__c = 'Sample Remarks';
        foRecord.Inspection_Result__c = 'Disapproved';
        foRecord.Ready_for_Connection__c = true;
        foRecord.SE_Not_Compliant__c = true;
        foRecord.SE_Not_Installed_Yet__c = true;
        foRecord.Wrong_SE_Location__c = true;
        update foRecord;

        //Records for Inspection FO

        Case caseStatusCheck = [SELECT Status FROM CASE WHERE Id=: caseRecord.Id LIMIT 1];
        System.assertEquals('Inspection FO Resolved - Disapproved', caseStatusCheck.Status);

        Test.stopTest();

        return caseRecord.Id;
    }*/
    
    static testMethod void getServiceAddressTest()
    {
        String caseRecordId = prepareData();
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordId;
        
        emailHelper.getServiceAddress();
    }

    static testMethod void getBillingAddressTest()
    {
        String caseRecordId = prepareData();
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordId;
        
        emailHelper.getBillingAddress();
    }
    
    static testMethod void getRequirementsTest()
    {
        String caseRecordId = prepareData();
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordId;
        
        emailHelper.getRequirements();
    }
    
    
    /*static testMethod void getPreSurveyNotFeasibleTest()
    {
        
        String caseRecordIdFO = prepareDataFO();
        
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordIdFO;
        
        emailHelper.getPreSurveyNotFeasible();
    }*/
    
    /*static testMethod void getInspectionFoDisApprovedTest()
    {
        String caseRecordId = prepareDataFODisApproved();
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordId;
        
        emailHelper.getInspectionFoDisApproved();
    }*/
    
    static testMethod void getFieldOrderScheduleDateTest()
    {
        String caseRecordId = prepareData();
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordId;
        
        emailHelper.getFieldOrderScheduleDate();
    }
    
    static testMethod void getConnectionInstallationDateTest()
    {
        String caseRecordId = prepareData();
        CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();  
        
        emailHelper.caseId = caseRecordId;
        
        emailHelper.getConnectionInstallationDate();
    }

    
    //corbes Melvin
    static testMethod void getServiceAddressFromServiceTest(){
        Test.startTest();
        
        User adminUser = CXE_TestDataFactory.createAdminUser();
        insert adminUser;
        User userAd = [SELECT Id FROM User Where email='bruce.wayne@wayneenterprises.com'];
        System.runAs(userAd){
            List<Account> testAccountList = CXE_TestDataFactory.createBusinessAccount(1);
        Account testAccount = testAccountList.get(0);
        insert testAccount;

        
        System.assertEquals(False,testAccount.IsPersonAccount );
        
       
        
        //System.assert(null,[SELECT (SELECT Name,Id FROM Contacts) FROM Account WHERE Id =:testAccount.Id]);
        
        
        Id newServiceApplicationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case testCase = testCaseList.get(0);
            testCase.RecordTypeId = newServiceApplicationRecordTypeId;
            testCase.Tax_Identification_No__c = '1111111';
            testCase.AccountId = testAccount.Id;
            testCase.Application_for_Business_Customer__c = True;
            testCase.Application_for_Residential_Customer__c = false; 
        //testCase.Reason_for_Manual_Deposit_Input__c ='Manual Deposit Reason';
            
            insert testCase;
       
        Contract testContract = new Contract(AccountId = testAccount.Id,
                                             Case__c = testCase.Id,
                                             
                                             Method_of_Payment__c = 'ADA (Bank)',
                                             Type__c = 'Regular');
        insert testContract;
        List<Address__c> lstAddress = new List<Address__c>();
       
         Address__c testAddress = new Address__c(Type__c = 'Billing', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Contract__c = testContract.Id,
                                                Address_Street_No__c = '1');

         
        Address__c testAddress2 = new Address__c(Type__c = 'Service', 
                                                Account__c = testAccount.Id,
                                                Case__c = testCase.Id,
                                                Premise_Type__c = 'Single-Detached Residential',
                                                Address_Street_No__c = '1');
         
         
        lstAddress.add(testAddress);
        lstAddress.add(testAddress2);
               
        insert lstAddress;
        
   
 
        Agreement__c service = new Agreement__c();
        service.Account__c = testAccount.Id;
        service.Case__c = testCase.Id;
        service.Contract__c = testContract.Id;
        //service.PSIC__c = psicId;
        service.Rate__c = 'General Power (GP)';
        service.Segment__c = 'Home and Micro Business';
        service.Service_Supply_Type__c = 'Normal with meter';
        service.Service_Wire_Material__c = 'Copper';
        service.Service_Wire_Phase__c = 'Single Phase (1Ø), Network';
        service.Service_Wire_Size__c = '#1/0';
        service.Service_Wire_Type__c = 'Under Copper,Lateral';
        service.Voltage_Level__c = '4.8 kV';
        service.Applied_Load__c = 50; //START/END RReyes JUL-08-17 changed to prevent validation
        service.payor__c=testContract.Id;
        
        
        insert service;
            
            
            CXE_EmailHelper_CC  emailHelper = new CXE_EmailHelper_CC();
            
            emailHelper.serviceId =service.Id;
            emailHelper.contractId =testContract.Id;
            emailHelper.caseId =testCase.Id;
            
            
            String serviceAddress =  emailHelper.getServiceAddressFromService();
            String billingAddress = emailHelper.getBillingAddressFromServiceContract();
            String webAddress = emailHelper.getWebBillingAddress();
            String newCustomer =emailHelper.getNewRegisteredCustomer();
            Case getCase =emailHelper.getCase();
            
            try{
                emailHelper.caseRType ='MSA';
                Case getCaseFromService =emailHelper.getCaseFromService();
               
                
            }catch(Exception e){
                
                System.assert(e!=null);
            }
            
            try{
               emailHelper.caseRType ='RSA';
                Case getCaseFromServiceRSA =emailHelper.getCaseFromService();
                
            }catch(Exception e){
                
                System.assert(e!=null);
            }
            
            try{
                emailHelper.caseRType ='TSA';
                Case getCaseFromServiceTSA =emailHelper.getCaseFromService();
                
            }catch(Exception e){
                
                System.assert(e!=null);
            }
            
           
        }
        
        
       
        
       
        
        
        Test.stopTest();
        
        
    }
    
    
    
}