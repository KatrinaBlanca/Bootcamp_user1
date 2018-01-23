public without sharing class CXE_CP_PaperlessBillingUnSubscribe { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    public class PortalData {
        @AuraEnabled
        public DateTime lockIn;
        @AuraEnabled
        public string ReturnMe;
    }
    @AuraEnabled
    public static PortalData insertCase(string account,string reason,boolean isOther){
        PortalData returnData = new PortalData();
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                             , CXE_Alias__c
                                                             ,CXE_Type__c
                                                             , CXE_ServiceId__r.Account__c 
                                                             , CXE_ServiceId__r.SIN__c
                                                             From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId()];
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> sinIds = new Set<Id>();
        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__r.Account__c!=null){
                accountIds.add(enroll.CXE_ServiceId__r.Account__c);
                sinIds.add(enroll.CXE_ServiceId__c);
            }
        }
        
        List<Agreement__c> service = [Select ID, payor__r.Bill_Print_Mode__c,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                      ,(Select Address__c from Billing_Preferences__r) 
                                      from Agreement__c 
                                      where Account__c In: accountIds 
                                      AND Id in: sinIds];
        		
        set<String> listofContract = new Set<String>();
        for(Agreement__c enroll : service){
            if(enroll.Payor__r.V10_Account_No__c!=null){
                listofContract.add(enroll.Payor__c);
            }
        }
        
        List<Contract> contract = [Select ID,Contract_External_ID__c,CXE_Date6monthfromNOW__c,CXE_6_Months_Paperless_Lock_in__c,CXE_PaperlessBIllingEnrollment_Effective__c,Name,V10_Account_No__c,Bill_Print_Mode__c,AccountId from Contract where Id In: listofContract and V10_Account_No__c =: account];
       
        if(contract.size() > 0){
            if(contract[0].CXE_6_Months_Paperless_Lock_in__c){
                returnData.ReturnMe = 'paperless lockin';
                returnData.lockIn = contract[0].CXE_Date6monthfromNOW__c;
            }else{
                try{      
                    Case newCase = new Case();
                    newCase.Account_Number__c = account;
                    newCase.Application_Type_Subtype__c = 'Paperless Billing Cancellation';
                    newCase.CXE_Request_Date__c = date.today();
                    newCase.Status = 'Successful';
                    newCase.CXE_Agreed_to_the_T_C_and_Privacy_Policy__c = true;
                    newCase.Origin = 'Customer';
                    //newCase.CXE_Bill_Print_Mode__c = 'BILPRNT002'; //CSM-12981 GGrandea 09.26.2017 - field removal
                    newCase.CXE_Effective_Date__c = date.today(); //CSM-12573 Emandolado 9/14/2017
                    //newCase.CXE_Secondary_Email__c =secondaryEmail;
                    if(isOther){
                        newCase.CXE_Paperless_BillingCancellationReason__c ='Others (please specify)';
                        newCase.CXE_Others_Cancellation_Reason__c = reason;
                    }else{
                        newCase.CXE_Paperless_BillingCancellationReason__c =reason; 
                    }
                    newCase.AccountId = contract[0].AccountId;
                    newCase.Contract__c = contract[0].Id;
                    
                    // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
                    Id contactId = CXE_CP_PortalUtility.getCurrentUserContacId();
                    if(contactId != null){
                        newCase.ContactId = contactId;
                    }
                    // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
                    
                    insert newCase;
                    Case getReference = [select CaseNumber from Case where Id=:newCase.id];
                    
                    returnData.ReturnMe =getReference.CaseNumber;
                    
                }catch (Exception ex){
                    returnData.ReturnMe = 'error';
                    ErrorHandlerException.recordException(null, true, 'CXE_CP_PaperlessBillingUnSubscribe', 'insertCase' ,ex.getMessage());
                }
                
               
            }
        }
        
        return returnData;
    }
    
    public class loadData {
        @AuraEnabled
        public List<Contract> listofContract;
        @AuraEnabled
        public List<String> listofReason;
    }
    @AuraEnabled
    public static loadData loadAccounts(){
        
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                             , CXE_Alias__c
                                                             ,CXE_Type__c
                                                             , CXE_ServiceId__r.Account__c 
                                                             , CXE_ServiceId__r.SIN__c
                                                              From CXE_Service_Enrollment__c 
                                                             Where CXE_UserId__c=:UserInfo.getUserId()
                                                              AND CXE_Type__c =: CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR];
                                                                //CSM-13653 GGrandea 10.02.2017     - added CXE_Type__c where clause
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> sinIds = new Set<Id>();
        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__r.Account__c!=null){
                accountIds.add(enroll.CXE_ServiceId__r.Account__c);
                sinIds.add(enroll.CXE_ServiceId__c);
            }
        }
        
        List<Agreement__c> service = [Select ID ,payor__r.Bill_Print_Mode__c,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                      ,(Select Address__c from Billing_Preferences__r) 
                                      from Agreement__c 
                                      where Account__c In: accountIds 
                                      AND Id in: sinIds];
        
        set<String> listofContract = new Set<String>();
        for(Agreement__c enroll : service){
            if(enroll.Payor__r.V10_Account_No__c!=null){
                listofContract.add(enroll.Payor__c);
            }
        }
        
        List<Contract> contract = [Select ID,V10_Account_No__c,Bill_Print_Mode__c from Contract where Id In: listofContract and Bill_Print_Mode__c = 'BILPRNT003'];
        
        
        
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = case.CXE_Paperless_BillingCancellationReason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        } 
        
        
        loadData returnMe = new loadData();
        returnMe.listofContract = contract;
		returnMe.listofReason = options;
        
            
            
        return returnMe;
    }
    

    
}