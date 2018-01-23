public without sharing  class CXE_CP_PaperlessBillingSubscribe { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
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
        
       //CSM-12411 START EMandolado 09.04.2017
        List<Contract> listofContract = [Select Id,V10_Account_No__c,TYPE__c,Form_of_Payment__c,
                                         Method_of_Payment__c,AccountId, 
                                         Account.IsPersonAccount, Account.PersonContactId, Account.Email_2__pc
                                         from Contract where Id in:ContractIds and V10_Account_No__c =: accountid];
        
        returnEmails myReturn = new returnEmails();
        if(listofContract.size() > 0){
            if(listofContract[0].Account.IsPersonAccount){ //if person account
                 //Start CSM-12551 Emandolado 9/18/2017
                if(listofContract[0].Account.Email_2__pc != null){
                    myReturn.secondEmail = listofContract[0].Account.Email_2__pc;
                }else{
                    myReturn.secondEmail = '';
                }
                 //End CSM-12551 Emandolado 9/18/2017
            }else{
                Contact[] contacts = [SELECT Id,Email_2__c FROM Contact WHERE AccountId =: listofContract[0].AccountId]; 
                //GVG check if okay to use first if query returned multiple
                if(contacts.size()>0){
                    //Start CSM-12551 Emandolado 9/18/2017
                    if(listofContract[0].Account.Email_2__pc != null){
                        myReturn.secondEmail = contacts[0].Email_2__c;
                    }else{
                        myReturn.secondEmail = '';
                    }
                     //End CSM-12551 Emandolado 9/18/2017
                }
            }
        }
        //CSM-12411 END EMandolado 09.04.2017
        if(returnEmails.size() > 0){
            myReturn.firstEmail = returnEmails[0].Email;
        }
        return myReturn;
    }
    
    @AuraEnabled
    public static List<Contract> loadAccounts(){
        
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                             , CXE_Alias__c
                                                             ,CXE_Type__c
                                                             , CXE_ServiceId__r.Account__c 
                                                             , CXE_ServiceId__r.SIN__c
                                                             From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId() and CXE_Type__c = 'Payor'];
        
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
        
       //Start of CSM-13893 Corbes Melvin
        for(Case caseRec : [SELECT Id,
                            Contract__r.id,
                            Contract__r.V10_Account_No__c
                            FROM Case
                            WHERE RecordType.Name =: CXE_Constants.CASE_PAPERLESS_BILLING
                            AND Contract__c IN: listofContract
                            AND Application_Type_Subtype__c =: CXE_Constants.CASE_PAPERLESSBILLING_TYPE_SUB
                            AND Status =: CXE_Constants.CASE_STATUS_OPEN ]) {
                                
                            listofContract.remove(caseRec.Contract__r.id);  
                                
        }
        
        //End of CSM-13893 Corbes Melvin 
                                
        List<Contract> contract = [Select ID,V10_Account_No__c,Bill_Print_Mode__c from Contract where Id In: listofContract and Bill_Print_Mode__c = 'BILPRNT002'];
        
        
        
        
        
        
        /* set<String> accountIdsFinal = new Set<String>();
for(Agreement__c enroll : service){
if(enroll.Payor__r.V10_Account_No__c!=null){
accountIdsFinal.add(enroll.Payor__r.V10_Account_No__c);
}
}
List<string> acctHolder = new List<string>();
acctHolder.addAll(accountIdsFinal); */
        
        
        return contract;
    }
    
    //START R2C CSM-13274 Shayne 10/13/2017
     @AuraEnabled
        public static boolean retrieveCheckConglomerate(){
        System.debug('retrieveCheckConglomerate');
        boolean ret = false;
        User userData = [SELECT LastLoginDate,FirstName,CXE_Auto_Enrolled_Services__c, AccountId FROM User WHERE Id =:UserInfo.getUserId()]; 
        System.debug('retrieveCheckConglomerate uid '+userData.id+' :AccountID '+userData.AccountId);
        
         try{
              Account accountConglomerate = [SELECT id,Conglomerate__c,Name from Account where id=:userData.AccountId and Conglomerate__c=true];
                 ret = true;
            }catch(Exception e){
                System.debug('retrieveCheckConglomerate error '+e );
            }
        return ret;
    }
    //END R2C CSM-13274 Shayne 10/13/2017
    
    //Start CSM-14653 Mike Verdad 11/29/2017
    @AuraEnabled
    public static String RedirectToMeralcoWebsite() {
        System.debug('RedirectToMeralcoWebsite');
        return OrganizationSettings__c.getOrgDefaults().Paperless_Billing_Download_Form__c;
    }
    //End CSM-14653 Mike Verdad 11/29/2017
    
    // start of CSM-14772 Corbes Melvin 12/5/2017
    @AuraEnabled
    public static String ImageInPaperlessBilling() {
        return OrganizationSettings__c.getOrgDefaults().ImageInPaperlessBilling__c;
    }
    // end of CSM-14772 Corbes Melvin 12/5/2017



    
}