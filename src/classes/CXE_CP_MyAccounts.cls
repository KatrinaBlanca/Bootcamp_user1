public without sharing class CXE_CP_MyAccounts { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    @AuraEnabled
    public static CXE_CP_PortalUtility.PortalData getBills(){
        //START CSM-13930 GGrandea 10.17.2017   
        //return CXE_CP_PortalUtility.retrievePortalData();
        return CXE_CP_PortalUtility.retrievePortalData(false);
        //END CSM-13930 GGrandea 10.17.2017
    }
   
    public class ReturnData{
        @AuraEnabled
        public String AccountNumber;
        
        @AuraEnabled
        public String AccountType;
        
        @AuraEnabled
        public String AWA;
        
        @AuraEnabled
        public String PaymentMode;
        
        @AuraEnabled
        public String PaperlessBilling;
        
        @AuraEnabled
        public String SIN;
        
        @AuraEnabled
        public String SAddress;
        
        @AuraEnabled
        public string Alias;
        
        @AuraEnabled
        public String SServerType;
        
        @AuraEnabled
        public decimal SCapacity;
        
        @AuraEnabled
        public decimal SGMBD;
        
        @AuraEnabled
        public String SVoltage;
        
        @AuraEnabled
        public String SDescription;
        
        @AuraEnabled
        public String SStatus;

        // sopon
        @AuraEnabled public string icon;
        // ===
    }
    
    public class paperlessEnrollee{
        @AuraEnabled
        public String acctType;
        
        @AuraEnabled
        public Agreement__c acctEnrollee;
    }
    @AuraEnabled
    public static ReturnData SelectedData(string accountSelected , string sinSelected){
        
        ReturnData SelectedData = new ReturnData();
        try{
            if(accountSelected != null && !String.isEmpty(accountSelected)){
                List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c, CXE_Icon_Id__c
                                                                     , CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c
                                                                     , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                     From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId() and CXE_IsActive__c = true];
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + listofEnrollments);
                // get account Ids
                Set<Id> accountIds = new Set<Id>();
                
                Set<Id> sinIds = new Set<Id>();
                
                for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                    if(enroll.CXE_ServiceId__r.Account__c!=null){
                        accountIds.add(enroll.CXE_ServiceId__r.Account__c);
                        sinIds.add(enroll.CXE_ServiceId__c);
                    }
                }
                
                // get all Services/Agreement__c under the related Account
                List<Agreement__c> listofServiceAgreements = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                                              , (Select Address__c from Billing_Preferences__r) 
                                                              from Agreement__c 
                                                              where Account__c In: accountIds 
                                                              AND Payor__r.V10_Account_No__c =: accountSelected
                                                              AND Id in: sinIds];
                Set<Id> ContractIds = new Set<ID>();
                for(Agreement__c agreement : listofServiceAgreements){
                    if(agreement.Payor__c!=null){
                        ContractIds.add(agreement.Payor__c);
                    }
                }
                List<Contract> listofContract = [Select Id,V10_Account_No__c,TYPE__c,Form_of_Payment__c,Method_of_Payment__c, Bill_Print_Mode__c from Contract where Id in:ContractIds]; //CSM-12584
               // List<Contract> checkAWA = [Select Id,(Select Type__c from Account_Characteristics__r where Type__c ='CWT' or Type__c = 'FWV')V10_Account_No__c,TYPE__c,Form_of_Payment__c from Contract where Id in:ContractIds];
                //Start CSM-12866 Emandolado 9/22/2017 	
                List<Account_Characteristic__c> checkAWA = [Select Type__c from Account_Characteristic__c where (Type__c ='CWT' or Type__c = 'FWV') and Contract_ID__c =: listofContract[0].id];
                //End CSM-12866 Emandolado 9/22/2017 	
                
                SelectedData.AccountNumber = ListofServiceAgreements[0].Payor__r.V10_Account_No__c;
                SelectedData.AccountType = listofContract[0].TYPE__c;
                SelectedData.PaymentMode = listofContract[0].Method_of_Payment__c;
                SelectedData.PaperlessBilling = (listofContract[0].Bill_Print_Mode__c==CXE_Constants.BPM_PAPERLESS)? 'Subscribed':'Unsubscribed'; //CSM-12584 GGrandea 09.15.2017
                IF(checkAwa.size() > 0){
                    SelectedData.AWA = 'Yes';
                }
                else{
                    SelectedData.AWA = 'No';
                }
            }else{
                List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                     , CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c
                                                                     , CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_Icon_Id__c
                                                                     From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId()];
                system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + listofEnrollments);
                // get account Ids
                Set<Id> accountIds = new Set<Id>();
                for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                    if(enroll.CXE_ServiceId__r.Account__c!=null){
                        accountIds.add(enroll.CXE_ServiceId__r.Account__c);
                    }
                }
                
                // get all Services/Agreement__c under the related Account
                List<Agreement__c> SinHolder = [Select ID ,Rate_Program__c,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,
                                                (Select Address__c from Billing_Preferences__r),Contracted_Capacity__c,GMBD_kW__c,Service_Supply_Voltage__c,Service_Description__c,Service_Status__c 
                                                from Agreement__c 
                                                where Account__c In: accountIds and SIN__c =: sinSelected];//CSM-12600 Emandolado 9/18/2017
                string AccountId = SinHolder[0].Payor__r.V10_Account_No__c; 
                List<Agreement__c> listofServiceAgreements = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,(Select Address__c from Billing_Preferences__r) from Agreement__c where Account__c In: accountIds and Payor__r.V10_Account_No__c =: AccountId];
                Set<Id> ContractIds = new Set<ID>();
                for(Agreement__c agreement : listofServiceAgreements){
                    if(agreement.Payor__c!=null){
                        ContractIds.add(agreement.Payor__c);
                    }
                }
                List<Contract> listofContract = [Select Id,V10_Account_No__c,TYPE__c,Form_of_Payment__c,Method_of_Payment__c,Bill_Print_Mode__c from Contract where Id in:ContractIds]; //CSM-12584
                //List<Contract> checkAWA = [Select Id,(Select Type__c from Account_Characteristics__r where Type__c ='CWT' or Type__c = 'FWV')V10_Account_No__c,TYPE__c,Form_of_Payment__c from Contract where Id in:ContractIds];
                // START CSM-13899 Jerome To 10/13/2017
                List<Account_Characteristic__c> checkAWA = [Select Type__c from Account_Characteristic__c where (Type__c ='CWT' or Type__c = 'FWV') and Contract_ID__c =: listofContract[0].id];
                // END CSM-13899 Jerome 10/13/2017
                SelectedData.AccountNumber = AccountId;
                SelectedData.AccountType = listofContract[0].TYPE__c;
                SelectedData.PaymentMode = listofContract[0].Method_of_Payment__c;
                SelectedData.PaperlessBilling = (listofContract[0].Bill_Print_Mode__c==CXE_Constants.BPM_PAPERLESS)? 'Subscribed':'Unsubscribed'; //CSM-12584 GGrandea 09.15.2017
                IF(checkAwa.size() > 0){
                    SelectedData.AWA = 'Yes';
                }
                else{
                    SelectedData.AWA = 'No';
                }
                
                if(!SinHolder.isEmpty()){
                    SelectedData.Sin = SinHolder[0].Sin__c;
                    SelectedData.SCapacity= SinHolder[0].Contracted_Capacity__c;
                    SelectedData.SGMBD = SinHolder[0].GMBD_kW__c;
                    SelectedData.SVoltage = SinHolder[0].Service_Supply_Voltage__c;
                    SelectedData.SDescription = SinHolder[0].Service_Description__c;
                    SelectedData.SStatus = SinHolder[0].Service_Status__c;
                    SelectedData.SServerType = SinHolder[0].Rate_Program__c; //CSM-12600 Emandolado 9/18/2017


                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == SinHolder[0].Id){
                            SelectedData.Alias = enroll.CXE_Alias__c;

                            // sopon
                            SelectedData.icon = enroll.CXE_Icon_Id__c;
                            // =====
                        }
                    }
                    if(!SinHolder[0].Billing_Preferences__r.isEmpty()){
                        SelectedData.SAddress = SinHolder[0].Billing_Preferences__r[0].Address__c;
                    }
                } 
                
                
                
            }
        }catch(Exception e) {
            ErrorHandlerException.recordException(null, true, 'AAAAAAA', 'aaaaaaaaaaa', e.getMessage());
        }
        
        return SelectedData;       
    }
    //Start Code Modification CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
    public class ServiceWrapper{
        @AuraEnabled
        public Agreement__c service {get;set;}
        
        
        @AuraEnabled
        public Boolean isApaEnroll {get;set;}
        
        @AuraEnabled
        public Boolean isApaCancel {get;set;}
        
        
        
        @AuraEnabled
        public String alias {get;set;}
        
        @AuraEnabled
        public String typeOf {get;set;}
        
        @AuraEnabled
        public Boolean isSelected {get;set;} 
        
        public ServiceWrapper(Agreement__c service, Boolean isApaEnroll, Boolean isApaCancel, String alias, Boolean isSelected,String typeOf) {
            this.service = service;
            this.isApaEnroll = isApaEnroll;
            this.isApaCancel = isApaCancel;
            this.alias = alias;
            this.isSelected = isSelected;
            this.typeOf = typeOf;
            
        }  
        
    }
    //End Code Modification CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
    public class TableData{
        @AuraEnabled
        public string AccountId {get;set;}
        
        
        @AuraEnabled
        public string Address {get;set;}
        
        
        @AuraEnabled
        public string Status {get;set;}
        
        @AuraEnabled
        public List<Agreement__c> SinList {get;set;}
        
    }
    
    @AuraEnabled
    public static String changeAura(String SINId,String NewAura){
        try{
            List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                                 , CXE_Alias__c
                                                                 , CXE_ServiceId__r.Account__c 
                                                                 , CXE_ServiceId__r.SIN__c 
                                                                 From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId()
                                                                 and CXE_ServiceId__c =: SINId];
            
            listofEnrollments[0].CXE_Alias__c = NewAura;
            update listofEnrollments[0];
            return 'Save Successfully';
        }catch(Exception e){
            return  e.getMessage();
        }
    }
    
    //@AuraEnabled
    //public static List<Agreement__c> ListofServices(String SINNumber , String AccountNumber){
    @AuraEnabled
    public static List<ServiceWrapper> ListofServices(String SINNumber , String AccountNumber){
        List<ServiceWrapper> wrapperList = new List<ServiceWrapper>();
        
        //Start Code modification CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
        //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                             , CXE_Alias__c
                                                             , CXE_ServiceId__r.Account__c 
                                                             , CXE_ServiceId__r.SIN__c
                                                             , CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c
                                                             , CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c
                                                             , CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c 
                                                             , CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c
                                                             , CXE_ServiceId__r.Payor__r.Account.IsPersonAccount // Start/End CSM-14905 Von Pernicia
                                                             From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId()
                                                             and CXE_IsActive__c = True]; //CSM-12857 GGrandea 09.20.2017
        //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
        //End Code Modification CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + listofEnrollments);
        // get account Ids             
        Set<Id> accountIds = new Set<Id>();
        Set<Id> sinIds = new Set<Id>();
        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__r.Account__c!=null){
                accountIds.add(enroll.CXE_ServiceId__r.Account__c);
                sinIds.add(enroll.CXE_ServiceId__c);
            }
        }
        
        List<Account> listOfAccounts = [SELECT Id, Name,Account_ID__c,IsPersonAccount FROM Account WHERE Id in: accountIds];
        
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + sinIds);
        
        if(SINNumber == 'none' && AccountNumber =='none'){ //both select ALL
            
            List<Agreement__c> service = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                          ,(Select Address__c from Billing_Preferences__r) 
                                          from Agreement__c 
                                          where Account__c In: accountIds 
                                          AND Id in: sinIds
                                          ORDER BY Payor__r.V10_Account_No__c DESC];
            
            
            for(integer i = 0 ; i < service.size() ; i++){
                if(i == 0){
                    
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }
                else if(i != 0 && service[i].Payor__r.V10_Account_No__c != service[i-1].Payor__r.V10_Account_No__c){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }else{
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }
            }
            
            /* EMMAN BACKUP
Map<Id, Agreement__c> agreementMap = new Map<Id, Agreement__c>();
for(Agreement__c service : [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
,(Select Address__c from Billing_Preferences__r) 
from Agreement__c 
where Account__c In: accountIds 
AND Id in: sinIds
ORDER BY Payor__r.V10_Account_No__c DESC]){
agreementMap.put(service.Id, service);
}
Agreement__c tempServAgr;
for(integer i = 0 ; i < listofEnrollments.size() ; i++){
tempServAgr = agreementMap.get(listofEnrollments[i].CXE_ServiceId__c);
if(i == 0){
wrapperList.add(new ServiceWrapper(tempServAgr, listofEnrollments[i], true));
}
else if(i != 0 
&& tempServAgr.Payor__r.V10_Account_No__c != agreementMap.get(listofEnrollments[i-1].CXE_ServiceId__c).Payor__r.V10_Account_No__c){
wrapperList.add(new ServiceWrapper(tempServAgr, listofEnrollments[i], true));
}else{
wrapperList.add(new ServiceWrapper(tempServAgr, listofEnrollments[i], false));
}
}*/
            
        }
        else if(SINNumber =='none' && AccountNumber != 'none'){
            
            List<Agreement__c> service = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                          ,(Select Address__c from Billing_Preferences__r) 
                                          from Agreement__c 
                                          where Payor__r.V10_Account_No__c =: AccountNumber 
                                          and Account__c In: accountIds
                                          AND Id in: sinIds];
            
            for(integer i = 0 ; i < service.size() ; i++){
                if(i == 0){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes 
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17 
                                }
                            }
                        }
                    }
                }
                else if(i != 0 && service[i].Payor__r.V10_Account_No__c != service[i-1].Payor__r.V10_Account_No__c){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }else{
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }
            }
            //List<Agreement__c> listofServiceAgreements = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c,(Select Address__c from Billing_Preferences__r) from Agreement__c where Account__c In: accountIds];
            
            
            
        }else if(SINNumber != 'none' && AccountNumber =='none'){
            
            List<Agreement__c> service = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                          ,(Select Address__c from Billing_Preferences__r) 
                                          from Agreement__c 
                                          where Account__c In: accountIds 
                                          and SIN__c =: SINNumber
                                          AND Id in: sinIds];
            for(integer i = 0 ; i < service.size() ; i++){
                if(i == 0){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes 
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }
                // Start CSM-15028 Von Pernicia: Comment our as this condition will not be cover based on the query
                /*else if(i != 0 && service[i].Payor__r.V10_Account_No__c != service[i-1].Payor__r.V10_Account_No__c){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }else{
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes 
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }*/
                // End CSM-15028 Von Pernicia: Comment our as this condition will not be cover based on the query
            }
            
        }
        else{
            
            List<Agreement__c> service = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                          ,(Select Address__c from Billing_Preferences__r) 
                                          from Agreement__c  
                                          where Payor__r.V10_Account_No__c =: AccountNumber 
                                          and Account__c In: accountIds 
                                          and SIN__c =: SINNumber
                                          AND Id in: sinIds ];
            for(integer i = 0 ; i < service.size() ; i++){
                if(i == 0){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }
                // Start CSM-15028 Von Pernicia: Comment our as this condition will not be cover based on the query
                /*else if(i != 0 && service[i].Payor__r.V10_Account_No__c != service[i-1].Payor__r.V10_Account_No__c){
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes 
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, true,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }else{
                    for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                        if(enroll.CXE_ServiceId__c == service[i].Id){
                            for(Account acts : listOfAccounts){
                                if(acts.Id == service[i].Account__c){
                                    //Start CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                    Boolean isApaE = false;
                                    Boolean isApaC = false;
                                    //START CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==false 
                                        && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Enrollment__c==false
                                        || (enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==true 
                                            && enroll.CXE_ServiceId__r.Payor__r.CXE_Reason_for_Cancellation_APA__c  == LABEL.RFC_CHANGE_IN_NUMBER)) //START/END CSM-14006 RReyes
                                    {
                                        isApaE = true;
                                    }
                                    
                                    if(enroll.CXE_ServiceId__r.Payor__r.CXE_Enrolled_to_APA_formula__c==true
                                       && enroll.CXE_ServiceId__r.Payor__r.CXE_Pending_APA_Cancellation__c==false )
                                    {
                                        isApaC = true;
                                    }
                                    //END CSM-14973 RReyes DEC-27-17 - change from CXE_Enrolled_to_APA__c to CXE_Enrolled_to_APA_formula__c
                                    if(enroll.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){ // Start/End CSM-14905 Von Pernicia
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Residential'));
                                    }else{
                                        wrapperList.add(new ServiceWrapper(service[i], isApaE, isApaC, enroll.CXE_Alias__c, false,'Business'));
                                    }
                                    //End CSM-13079, CSM-13204 R2C Rabayon 10/04/17
                                }
                            }
                        }
                    }
                }*/
                // End CSM-15028 Von Pernicia: Comment our as this condition will not be cover based on the query
            }
            
        }
        return wrapperList;
        
    }
    
    
    
    @AuraEnabled
    public static CXE_CaseResponseWrapper getCaseVariable(String serviceId, String requiredStatus){
        CXE_CaseResponseWrapper response = new CXE_CaseResponseWrapper();
        try {
            List<Agreement__c> serviceList = [SELECT Id,Payor__r.Account.Name, Payor__r.Account.Doing_Business_As__c, Payor__r.Account.Email__c,
                                              Payor__r.Account.FirstName, Payor__r.Account.LastName, Payor__r.Account.Mobile_Phone__c, Payor__r.Account.Email_1__pc,
                                              Payor__r.Account.PersonMobilePhone, Case__r.Designation__c, SIN__c, Payor__r.Account.IsPersonAccount,
                                              Payor__r.Account.Date_of_Birth__pc, Payor__r.Account.PersonBirthdate, Case__r.Home_Ownership__c,
                                              Service_Unit_No__c, Service_Street_No__c, Service_Street_Name__c, Service_Barangay__c, 
                                              Service_Subdivision__c, Service_City_Municipality__c, Service_Province__c,
                                              (SELECT Address_Unit_No__c, Address_Street_No__c, Address_Street_Name__r.Name, Address_Barangay__r.Name,
                                               Address_Subdivision__r.Name, Address_City_Municipality__r.Name, Address_Province__r.Name
                                               FROM Billing_Preferences__r)
                                              FROM Agreement__c 
                                              WHERE SIN__c =:serviceId 
                                              AND Service_Status__c = : requiredStatus];
            
            if(!serviceList.isEmpty()) {
                
                //Start CSM-12828 Jerome To hotfix 09/19/2017
                //Case caseVariable = new Case();
                Case caseVariable = CXE_ServiceApplication.newPortalCase();
                caseVariable.Account_No__c = serviceId;
                /*
                caseVariable.CXE_Web_First_Name__c = serviceList.get(0).Payor__r.Account.FirstName;
                caseVariable.CXE_Web_Middle_Name__c = '';
                caseVariable.CXE_Web_Last_Name__c = serviceList.get(0).Payor__r.Account.LastName;
                //caseVariable.CXE_Web_Primary_Email__c = serviceList.get(0).Payor__r.Account.Email__c;
                caseVariable.CXE_Web_Primary_Email__c = ((!serviceList.get(0).Payor__r.Account.IsPersonAccount) ? serviceList.get(0).Payor__r.Account.Email__c : serviceList.get(0).Payor__r.Account.Email_1__pc);
                //caseVariable.CXE_Web_Primary_Mobile__c = ((!serviceList.get(0).Payor__r.Account.IsPersonAccount) ? serviceList.get(0).Payor__r.Account.Mobile_Phone__c : serviceList.get(0).Payor__r.Account.PersonMobilePhone);
                caseVariable.CXE_Web_Primary_Mobile__c = serviceList.get(0).Payor__r.Account.Mobile_Phone__c;
                caseVariable.CXE_Web_Date_of_Birth__c = ((!serviceList.get(0).Payor__r.Account.IsPersonAccount) ? serviceList.get(0).Payor__r.Account.Date_of_Birth__pc : serviceList.get(0).Payor__r.Account.PersonBirthdate);
                */

                //End CSM-12828 Jerome To hotfix 09/19/2017

                
                caseVariable.Application_for_Residential_Customer__c = serviceList.get(0).Payor__r.Account.IsPersonAccount;
                caseVariable.Application_for_Residential_Service__c = serviceList.get(0).Payor__r.Account.IsPersonAccount;
                caseVariable.Application_for_Business_Customer__c = !serviceList.get(0).Payor__r.Account.IsPersonAccount;
                caseVariable.Application_for_Business_Service__c = !serviceList.get(0).Payor__r.Account.IsPersonAccount;
                caseVariable.Home_Ownership__c = serviceList.get(0).Case__r.Home_Ownership__c;
                caseVariable.CXE_Service__c = serviceList.get(0).Id;
                // START CSM-12841 Jerome To switch order of subdivision and barangay
                if(!serviceList.get(0).Billing_Preferences__r.isEmpty()){
                    caseVariable.Service_Address_Province__c = serviceList.get(0).Billing_Preferences__r.get(0).Address_Province__r.Name;
                    caseVariable.Service_Address_City_Municiple__c = serviceList.get(0).Billing_Preferences__r.get(0).Address_City_Municipality__r.Name;
                    caseVariable.address_1__c = String.join( new List<String> { serviceList.get(0).Billing_Preferences__r.get(0).Address_Unit_No__c, 
                        serviceList.get(0).Billing_Preferences__r.get(0).Address_Street_No__c, 
                        serviceList.get(0).Billing_Preferences__r.get(0).Address_Street_Name__r.Name,                        
                        serviceList.get(0).Billing_Preferences__r.get(0).Address_Subdivision__r.Name,
                        serviceList.get(0).Billing_Preferences__r.get(0).Address_Barangay__r.Name}, ' ');
                }
                // END CSM-12841 Jerome To switch order of subdivision and barangay
                response.hasError = false;
                response.caseRecord = caseVariable;
                
            } else{
                response.hasError=true;
                response.errorMessage = 'No record found.';
                response.errorMessages = new List<String>{ 'No record found.' };
                    }
            
        } catch(Exception e) {
            response.hasError=true;
            response.errorMessage = e.getMessage();
            response.errorMessages = new List<String>{ e.getMessage() };
                }
        return response;
    }
    
    @AuraEnabled
    public static paperlessEnrollee enrollPaperless(String accId){
        
        List<CXE_Service_Enrollment__c> getSignificantEnroll = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                , CXE_ServiceId__r.Account__c, CXE_ServiceId__r.SIN__c
                                                                , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId()];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + getSignificantEnroll);
        // get account Ids
        Set<Id> accountIds = new Set<Id>();
        
        for(CXE_Service_Enrollment__c enroll : getSignificantEnroll){
            if(enroll.CXE_ServiceId__r.Account__c!=null){
                accountIds.add(enroll.CXE_ServiceId__r.Account__c);
            }
        }
        List<Agreement__c> enrolleeAcctDetails= [SELECT ID,payor__r.Bill_Print_Mode__c,Payor__r.V10_Account_No__c FROM Agreement__c WHERE Payor__r.V10_Account_No__c =: accId and Account__c In: accountIds];
        //List<Agreement__c> enrolleeAcctDetails = [Select ID ,payor__r.Bill_Print_Mode__c,Payor__c,Payor__r.V10_Account_No__c
        //                              from Agreement__c 
        //                            where Payor__r.V10_Account_No__c =: accId];
        
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c
                                                             , CXE_Alias__c,
                                                             CXE_Type__c
                                                             , CXE_ServiceId__r.Account__c 
                                                             , CXE_ServiceId__r.SIN__c
                                                             From CXE_Service_Enrollment__c Where CXE_UserId__c=:UserInfo.getUserId() and CXE_ServiceId__c =: enrolleeAcctDetails[0].Id];
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + listofEnrollments);
        
        paperlessEnrollee enrollee = new paperlessEnrollee();
        if(enrolleeAcctDetails != null){
            enrollee.acctEnrollee = enrolleeAcctDetails[0];
        }
        if(listofEnrollments != null){
            enrollee.acctType = listofEnrollments[0].CXE_Type__c;
        }
        return enrollee;
    }
    @AuraEnabled
    public static List<Contract> unenroll(String accId){
        
        Id uid = UserInfo.getUserId();

        List<CXE_Service_Enrollment__c> enroll = [
            Select Id
            From CXE_Service_Enrollment__c 
            Where CXE_UserId__c = :uid 
            and CXE_ServiceId__r.Payor__r.V10_Account_No__c = :accId
        ];

        if(enroll != null && enroll.size() > 0){
            List<Contract> contractList = [
                Select ID,V10_Account_No__c,Bill_Print_Mode__c 
                from Contract 
                where V10_Account_No__c = :accId 
                and Bill_Print_Mode__c = 'Paperless'
            ];
            
            return contractList;
        }
        
        return new List<Contract>();
    }
   
    
    //@AuraEnabled
    //public static List<String> getHomeOwnership(){
    //    List<String> options = new List<String>();
    //    Schema.DescribeFieldResult fieldResult = Case.Home_Ownership__c.getDescribe();
    //    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    //    for (Schema.PicklistEntry f: ple) {
    //        options.add(f.getLabel());
    //    }    
    //    return options;    
    //}
}