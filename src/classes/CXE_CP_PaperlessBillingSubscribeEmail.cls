public without sharing class CXE_CP_PaperlessBillingSubscribeEmail {
    public class returnEmails{
        @AuraEnabled
        public String firstEmail;
        
        @AuraEnabled
        public String secondEmail;
    }
    
    @AuraEnabled	
    public static returnEmails firstEmail(string accountid){
        List<User> returnEmails = [SELECT LastLoginDate,FirstName,Email FROM User WHERE Id =:UserInfo.getUserId()]; 
        
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                             , CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c
                                                             , CXE_ServiceId__r.Payor__c
                                                             From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId()];
        
        
        Set<string> ContractIds = new Set<string>();
        for(CXE_Service_Enrollment__c agreement : listofEnrollments){
            if(agreement.CXE_ServiceId__r.Payor__c!=null){
                ContractIds.add(agreement.CXE_ServiceId__r.Payor__c);
            }
        }
        
        List<Contract> listofContract = [Select Id,V10_Account_No__c,TYPE__c,Form_of_Payment__c,Method_of_Payment__c,AccountId, Account.PersonContactId from Contract where Id in:ContractIds and V10_Account_No__c =: accountid];
        
        List<Contact> c = new List<Contact>();
        if(listofContract.size() > 0){
            c = [select id,Email_2__c from Contact where Id=:listofContract[0].Account.PersonContactId];
        }
        returnEmails myReturn = new returnEmails();
        if(returnEmails.size() > 0){
            myReturn.firstEmail = returnEmails[0].Email;
        }
        if(c.size() > 0){
            myReturn.secondEmail = c[0].Email_2__c;
        }
        return myReturn;
    }
    
    @AuraEnabled	
    public static string updateEmail(string emailadd,string accountid){
        
        String returnMsg = 'none';
        try{
            List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                 , CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c
                                                                 , CXE_ServiceId__r.Payor__c
                                                                 From CXE_Service_Enrollment__c 
                                                                  Where CXE_UserId__c=:UserInfo.getUserId()
                                                                  AND CXE_IsActive__c = true ]; //CSM-13961 10.18.2017
            
            
            Set<string> ContractIds = new Set<string>();
            for(CXE_Service_Enrollment__c agreement : listofEnrollments){
                if(agreement.CXE_ServiceId__r.Payor__c!=null){
                    ContractIds.add(agreement.CXE_ServiceId__r.Payor__c);
                }
            }
            
            //Id test1; //CSM-13961 removed
            
            
            List<Contract> contract = [Select ID,Contract_External_ID__c,Name,V10_Account_No__c,Bill_Print_Mode__c,AccountId from Contract where Id In: ContractIds and V10_Account_No__c =: accountid];
            
            
            if(contract.size() > 0){
                //system.debug('here' + contract); //CSM-13961 removed
                //CXE_CP_BillPrintModeIntegrationUtility.printmodeUpdateRequest(contract , CXE_Constants.BPM_PAPERLESS); //CSM-12877 GGrandea 09.22.2017
                
                //START CSM-13961 GGrandea 10.18.2017
                /*List<Contract> listofContract = [Select Id,V10_Account_No__c,TYPE__c,Form_of_Payment__c
                                                 ,Method_of_Payment__c,AccountId, Account.PersonContactId 
                                                 from Contract 
                                                 where Id in: ContractIds 
                                                 and V10_Account_No__c =: accountid];
                //test1 = listofContract[0].Account.PersonContactId; //CSM-13961 removed
                //try{
                if(listofContract.size() > 0){
                    Contact c;
                    if(listofContract[0].Account.PersonContactId!=null){ //if person account
                        c = new Contact(Id=listofContract[0].Account.PersonContactId);
                        c.Email_2__c = emailadd;
                        update c;
                    }else{
                        Contact[] contacts = [SELECT Id,Email_2__c FROM Contact WHERE AccountId =: listofContract[0].AccountId]; 
                        //GVG check if okay to use first if query returned multiple
                        contacts[0].Email_2__c = emailadd;
                        update contacts;
                    }
                    
                    returnMSG = 'success';
                }*/

                if(String.isNotBlank(emailadd)){
                    Contact con = new Contact(  Id = CXE_CP_PortalUtility.getCurrentUserContacId(), 
                                                    Email_2__c = emailadd);
                    update con;
                }
                //END CSM-13961 GGrandea 10.18.2017
                
                
                Case newCase = new Case();
                newCase.Account_Number__c = accountid;
                newCase.Application_Type_Subtype__c = 'Paperless Billing Subscription';
                newCase.CXE_Request_Date__c = date.today();
                newCase.CXE_Effective_Date__c = date.today(); //CSM-12589 Emandolado 9/15/2017
                newCase.Status = 'Successful';
                newCase.CXE_Agreed_to_the_T_C_and_Privacy_Policy__c = true;
                newCase.Origin = 'Customer';
                //newCase.CXE_Bill_Print_Mode__c = 'BILPRNT003'; //CSM-12981 GGrandea 09.26.2017 - field removal
                newCase.CXE_Secondary_Email__c =emailadd;
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
                returnMSG = getReference.CaseNumber;
            }
        }catch (Exception ex){
            returnMSG = 'error';
            ErrorHandlerException.recordException(null, true, 'CXE_CP_PaperlessBillingSubscribeEmail', 'updateEmail' ,ex.getMessage());
        }
        return returnMsg;
    }
    
    
}