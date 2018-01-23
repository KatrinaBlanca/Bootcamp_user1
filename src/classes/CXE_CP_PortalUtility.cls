public without sharing class CXE_CP_PortalUtility { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    public class PortalData {
        @AuraEnabled
        public DateTime LastLoginDate;
        @AuraEnabled
        public string FirstName;
        @AuraEnabled
        public string AccountId;
        @AuraEnabled
        public integer AccountCount;
        @AuraEnabled
        public integer ServiceCount;
        @AuraEnabled
        public integer ContractCount;
        @AuraEnabled
        public integer BillCount;
        @AuraEnabled
        public integer UnpaidBillCount;
        @AuraEnabled
        public integer ServicesCount;

        @AuraEnabled
        public User user;
        @AuraEnabled
        public List<Account> UserAccounts;
        @AuraEnabled
        public List<Contract> UserContracts;
        @AuraEnabled
        public List<Agreement__c> UserServices;
        @AuraEnabled
        public List<CXE_Service_Enrollment__c> UserEnrollments;

        @AuraEnabled
        public List<CXE_Heroku_Model.BillDetail> UserBills;
        @AuraEnabled
        public List<CXE_Heroku_Model.BillDetail> UnpaidUserBills;

        @AuraEnabled
        public boolean DueDateChange = false;
        @AuraEnabled
        public string NewestDueDate;
        @AuraEnabled
        public List<Case> caseList {get; set;}

        //CSM-11322 Jerome To
        @AuraEnabled
        public Map<Id, String> caseStatusMap {get; set;}

        @AuraEnabled
        public Boolean UserType;
        
        @AuraEnabled
        public Agreement__c service {get;set;}

        @AuraEnabled
        public List<accountAdditionalData> accountAddData {get;set;}
        //RJ --> Added boolean flag for auto enrollment
        @AuraEnabled
        public Boolean autoEnroll;
        //START CSM-10961 RReyes AUG-15-17 - contract list for View Bills only
        @AuraEnabled
        public List<Contract> UserContractsViewBill;
        @AuraEnabled
        public integer ContractCountViewBill;
        //END CSM-10961 RReyes AUG-15-17 - contract list for View Bills only

        //START CSM-13070 GGrandea 10.02.2017
        @AuraEnabled
        public List<LoginHistory> loginHistoryList;
        //END CSM-13070 GGrandea 10.02.2017
	
        //START CSM-12645 RReyes
        @AuraEnabled
        public List<String> AccountsWithAllSINEnrolled;
        //END CSM-12645 RReyes
        public Map<String, Boolean> acctNoHasOpenPBCaseMap; //CSM-13719  Melvin Corbes Oct. 10, 2017 
       	//START CSM-13775 - Common due date of the unpaid bills doesn't display on the Due Date section of the Home Page 
        @AuraEnabled
        public String setPortalBillDueDate;
        //END CSM-13775
        //START CSM-12735 Von Pernicia
        @AuraEnabled
        public List<String> AccountsWithAllSINEnrolledWithoutBill;
        @AuraEnabled
        public List<CXE_Service_Enrollment__c> ServiceWithAllSINEnrolledWithoutBill;
        //END CSM-127355 Von Pernicia
        
        //START R2C CSM-13274 Shayne
        @AuraEnabled
        public boolean isConglomerate;
        //END R2C CSM-13274 Shayne
    }
     //CSM-11322 Jerome To 
    static final Map<String, Case_Status_Setting__mdt> statusJourneyMap;
    static{
        statusJourneyMap = new Map<String, Case_Status_Setting__mdt>();
        for (Case_Status_Setting__mdt setting : [SELECT MasterLabel, Service_Application_Journey__c, Service_Application_Journey_Remarks__c
                                                 FROM Case_Status_Setting__mdt
                                                 WHERE Service_Application_Journey__c != '']) {         
                statusJourneyMap.put(setting.MasterLabel, setting);
        }
    }

    public class accountAdditionalData{
        @AuraEnabled
        public string AccountId {get;set;}
        
        
        @AuraEnabled
        public string PrintMode {get;set;}
        
      
        
        @AuraEnabled
        public string Type {get;set;}
        
    }

    
    static final User currentUser;
    static{
        currentUser = [SELECT LastLoginDate,FirstName FROM User WHERE Id =:UserInfo.getUserId()];
    }

    @AuraEnabled
    public static PortalData retrievePortalData(){

        PortalData Udata    = new PortalData();
        
        try{

            //Rj --> Added CXE_Auto_Enrolled_Services__c in the query for auto enrollent notification on dashboard
            // Start CSM-12865 Jerome To added accountId
            User userData = [SELECT LastLoginDate,FirstName,CXE_Auto_Enrolled_Services__c, AccountId 
                                                    FROM User WHERE Id =:UserInfo.getUserId()]; 
            // End CSM-12865 Jerome To added accountId
            
            // get service enrollent records under the userId
            List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                     , CXE_ServiceId__r.SIN__c
                                                                     , CXE_ServiceId__r.Account__c
                                                                     , CXE_ServiceId__r.Payor__c
                                                                     , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                     , CXE_ServiceId__r.Payor__r.AccountId
                                                                     , CXE_Type__c
                                                                     , CXE_IsActive__c
                                                                     From CXE_Service_Enrollment__c 
                                                                     Where CXE_UserId__c=:UserInfo.getUserId() 
                                                                     and CXE_IsActive__c = True
                                                                           ];
            // get account Ids
            Set<Id> accountIds = new Set<Id>();
            Set<Id> contractIds = new Set<ID>();
            Set<Id> sinIds = new Set<Id>();
            List<String> sinNos = new List<String>();

            for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                if(enroll.CXE_ServiceId__r.Payor__r.AccountId!=null){
                    accountIds.add(enroll.CXE_ServiceId__r.Payor__r.AccountId);
                }
                if(enroll.CXE_ServiceId__c!=null){
                    sinIds.add(enroll.CXE_ServiceId__c);
                    if(enroll.CXE_ServiceId__r.Payor__c!=null){
                        contractIds.add(enroll.CXE_ServiceId__r.Payor__c);
                        if(enroll.CXE_ServiceId__r.Payor__r.AccountId!=null){
                            accountIds.add(enroll.CXE_ServiceId__r.Payor__r.AccountId);
                        }
                    }
                    if(enroll.CXE_ServiceId__r.SIN__c!=null){
                        sinNos.add(enroll.CXE_ServiceId__r.SIN__c);
                    }
                }
            }
            
            // get all Services/Agreement__c under the related Account
            List<Agreement__c> listofServiceAgreements = [Select ID ,Payor__c,Payor__r.V10_Account_No__c
                                                                    , SIN__c,Account__c,Service_Status__c
                                                            ,(Select Address__c from Billing_Preferences__r) 
                                                               from Agreement__c WHERE Id in: sinIds 
                                                              ORDER BY SIN__c ASC ]; 
                                                              //GVG //where Payor__r.AccountId In: accountIds
                                                              
            
            List<Contract> listofContract = [Select Id,V10_Account_No__c,Bill_Print_Mode__c,Contract_External_Id__c // Lisen CSM-14667 20171123
                                                FROM Contract where Id in:contractIds  
                                                ORDER BY V10_Account_No__c ASC];


            //GVG
            List<accountAdditionalData> Adata = new List<accountAdditionalData>();
            for(Contract contr: listofContract){
                accountAdditionalData tempdata = new accountAdditionalData();
                string typeTemp = 'none';
                tempdata.AccountId = contr.V10_Account_No__c;
                tempdata.PrintMode = contr.Bill_Print_Mode__c;
               
                for(integer i = 0; typeTemp == 'none' || i < listofEnrollments.size(); i++ ){
                    if(contr.V10_Account_No__c == listofEnrollments[i].CXE_ServiceId__r.Payor__r.V10_Account_No__c){
                        typeTemp = listofEnrollments[i].CXE_Type__c;
                    }
                }
                tempData.Type = typeTemp;
                Adata.add(tempdata);
            }
            Udata.accountAddData = Adata;
            //GVG
            
            // get all related Accounts
            List<Account> listOfAccounts = [SELECT Id, Name ,Account_ID__c,IsPersonAccount FROM Account WHERE Id in: accountIds];
            
            set<string> V10Id = new set<string>();
            for(Contract contRec : listofContract){
                if(contRec.V10_Account_No__c!=null){
                    V10Id.add(contRec.V10_Account_No__c);
                }
            }
            
System.debug('************ sinNos: '+ sinNos);
            //get Heroku
            List<CXE_Heroku_Model.BillDetail> bills = CXE_HerokuApps.getAllBillsBySinNos(sinNos);
            List<CXE_Heroku_Model.BillDetail> ListUserBills = new List<CXE_Heroku_Model.BillDetail>();
            List<CXE_Heroku_Model.BillDetail> ListUnpaidUserBills = new List<CXE_Heroku_Model.BillDetail>();
            
            string tempDueDate = 'DueDate';
            string laterdueDate = '1905-06-06';
            for( CXE_Heroku_Model.BillDetail Billrec: bills){            
                //if(V10Id.contains(Billrec.accountNumber)){
                ListUserBills.add(Billrec);  
                //todo vince
                if(Billrec.bill_status_filter == 'Unpaid'){
                    if(Billrec.due_date == tempDueDate){
                        Udata.DueDateChange = true;
                    }
                    if( Date.valueOf(Billrec.due_date) > Date.valueOf(laterdueDate) ){
                        Udata.NewestDueDate = Billrec.due_date;
                    }
                    ListUnpaidUserBills.add(Billrec);
                    tempDueDate = Billrec.due_date;
                }  
                
                //}
            }
            
            //Rj --> Added UData for auto enrollment
            UData.autoEnroll        = userData.CXE_Auto_Enrolled_Services__c;
            UData.user              = userData;
            
            UData.UserEnrollments   = listofEnrollments;
            UData.UserAccounts      = listOfAccounts;
            UData.UserServices      = listofServiceAgreements;
            UData.UserContracts     = listofContract;
            UData.LastLoginDate     = userData.LastLoginDate;
            UData.FirstName         = userData.FirstName;
            UData.UserBills         = ListUserBills;
            UData.UnpaidUserBills   = ListUnpaidUserBills;
            UData.AccountCount      = listOfAccounts.size();
            UData.ServiceCount      = listofEnrollments.size();
            UData.ContractCount     = listofContract.size();
            UData.ServicesCount     = listofServiceAgreements.size();
            UData.BillCount         = ListUserBills.size();
            UData.UnpaidBillCount   = ListUnpaidUserBills.size();
            if(!listOfAccounts.isEmpty()){
                UData.UserType = listOfAccounts[0].IsPersonAccount;
            }
            // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            // Start CSM-12865 Jerome To added accountId
            //UData.caseList = getCaseList(new Set<Id> { CXE_CP_PortalUtility.getCurrentUserContacId() });
            UData.caseList = getCaseList(accountIds); // Lisen CSM-13935 20171025
            // End CSM-12865 Jerome To added accountId
            // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            Udata.caseStatusMap = getCaseStatusMapping(UData.caseList); //CSM-11322 Jerome To
            Udata.acctNoHasOpenPBCaseMap = retrieveHasOpenPBCase(listofContract, contractIds); //CSM-13719  Melvin Corbes Oct. 10, 2017 
            
            //START CSM-13775 - Common due date of the unpaid bills doesn't display on the Due Date section of the Home Page 
            Udata.setPortalBillDueDate = setPortalBillDueDate(listofContract, ListofEnrollments, ListUnpaidUserBills);
            //END CSM-13775 
            
            //START R2C CSM-13274 Shayne
            Udata.isConglomerate = ([SELECT id,Conglomerate__c from Account where id=:userData.AccountId]).Conglomerate__c;
            System.debug('conglomerate '+Udata.isConglomerate);
			//END R2C CSM-13274 Shayne            
			
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_PortalUtility', 'retrievePortalData', ex.getMessage());
        }

        return Udata;
    }
    // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
    //private static List<Case> getCaseList(Set<Id> accountIds){
    //    //vincent added code for sorting
    //    // Start CSM-12865 Jerome To change accountId filter to createdbyid
    //    return [SELECT Id, CaseNumber, RecordType.Name, CreatedDate, CXE_Service_Address__c, Status, Last_Name__c,
    //                   CXE_Termination_Remarks__c, CXE_Retirement_FO_Remarks__c, Re_Inspection_FO_Resolution_Remarks__c 
    //            FROM Case 
    //            WHERE CreatedById IN:accountIds AND AccountId != ''
    //            ORDER BY CreatedDate DESC
    //           ];
    //    // End CSM-12865 Jerome To change accountId filter to createdbyid
    //    //return userCaseList;
    //}
    // Start Lisen CSM-13935 20171025
    private static List<Case> getCaseList(Set<Id> accountIds){ 
        Id userId = UserInfo.getUserId();
        Set<Id> contactIds = new Set<Id> {CXE_CP_PortalUtility.getCurrentUserContacId()}; 
        return [SELECT Id, CaseNumber, RecordType.Name, CreatedDate, CXE_Service_Address__c, Status, Last_Name__c,
                       CXE_Termination_Remarks__c, CXE_Retirement_FO_Remarks__c, Re_Inspection_FO_Resolution_Remarks__c 
                FROM Case 
                WHERE (ContactId IN:contactIds AND ContactId != '') OR CreatedById = :userId OR AccountID = :accountIds
                ORDER BY CreatedDate DESC
               ];
    }
    // End Lisen CSM-13935 20171025

    // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab



    @AuraEnabled
    public static PortalData retrievePortalData(Boolean includeBills){
        System.debug('>>>>conglomerate');
        PortalData Udata    = new PortalData();
        try{

            //Rj --> Added CXE_Auto_Enrolled_Services__c in the query for auto enrollent notification on dashboard
            // Start CSM-12865 Jerome To added accountId
            User userData = [SELECT LastLoginDate,FirstName,CXE_Auto_Enrolled_Services__c, AccountId 
                                                    FROM User WHERE Id =: UserInfo.getUserId()]; 
            // End CSM-12865 Jerome To added accountId
            // get service enrollent records under the userId
            //START CSM-10961 RReyes AUG-15-17 - added CXE_ServiceId__r.Contract__r.V10_Account_No__c in query
            List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c 
                                                                     , CXE_ServiceId__r.SIN__c
                                                                     , CXE_ServiceId__r.Account__c
                                                                     , CXE_ServiceId__r.Payor__c
                                                                     , CXE_ServiceId__r.Contract__c
                                                                     , CXE_ServiceId__r.Contract__r.V10_Account_No__c
                                                                     , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                     , CXE_ServiceId__r.Payor__r.AccountId
                                                                     , CXE_Type__c
                                                                     , CXE_IsActive__c //CSM-13930 10.17.2017
                                                                     From CXE_Service_Enrollment__c 
                                                                      Where CXE_UserId__c=:UserInfo.getUserId() 
                                                                            and CXE_IsActive__c = true];
            //END CSM-10961 RReyes AUG-15-17 - added CXE_ServiceId__r.Contract__r.V10_Account_No__c in query
            // get account Ids
            Set<Id> accountIds = new Set<Id>();
            Set<Id> contractIds = new Set<ID>();
            Set<Id> sinIds = new Set<Id>();
            List<String> sinNos = new List<String>();
            Set<Id> contractPayorIds = new Set<ID>(); //START/END CSM-10961 RReyes AUG-15-17
            //START CSM-12645 RReyes 
            Map<String,Set<Id>> mapEnrolledCtrToSIN = new Map<String, Set<Id>>();
            Map<String,Set<Id>> mapPayorToSIN = new Map<String, Set<Id>>(); 
            Set<String> contractV10Numbers = new Set<String>();
            List<String> contractWithAllSINSEnrolled = new List<String>();
            //END CSM-12645 RReyes 

            // Start R2C CSM-12735 Von Pernicia
            Set<String> contractWithUnpaidBill = new Set<String>(); 
            Set<String> sinWithUnpaidBill = new Set<String>(); 
            Map<String, String> contractWithAllSINSEnrolledPaid = new Map<String, String>();
            Map<String, CXE_Service_Enrollment__c> serviceSINSEnrolledPaid = new Map<String, CXE_Service_Enrollment__c>();
            // SEnd R2C CSM-12735 Von Pernicia

            for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                if(enroll.CXE_ServiceId__c!=null){
                    sinIds.add(enroll.CXE_ServiceId__c);
                    if(enroll.CXE_ServiceId__r.Payor__c!=null){
                        contractIds.add(enroll.CXE_ServiceId__r.Payor__c);
                        contractPayorIds.add(enroll.CXE_ServiceId__r.Payor__c); //START/END CSM-10961 RReyes AUG-15-17
                        //START CSM-12645 RReyes SEP-21-17
                        if(!String.isEmpty(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)){
                            contractV10Numbers.add(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c);
                            if(!mapEnrolledCtrToSIN.containsKey(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)){
                                mapEnrolledCtrToSIN.put(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c, new Set<Id>{enroll.CXE_ServiceId__c});
                            }else{
                                mapEnrolledCtrToSIN.get(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c).add(enroll.CXE_ServiceId__c);
                            }
                        }
                        //END CSM-12645 RReyes SEP-21-17
                        if(enroll.CXE_ServiceId__r.Payor__r.AccountId!=null){
                            accountIds.add(enroll.CXE_ServiceId__r.Payor__r.AccountId);
                        }
                    }
                    if(enroll.CXE_ServiceId__r.SIN__c!=null){
                        sinNos.add(enroll.CXE_ServiceId__r.SIN__c);
                        serviceSINSEnrolledPaid.put(enroll.CXE_ServiceId__r.SIN__c, enroll); // Start/End R2c CSM-12735: Von Pernicia
                    }
                    //START CSM-10961 RReyes AUG-15-17
                    if(enroll.CXE_ServiceId__r.Contract__c != null){
                        contractPayorIds.add(enroll.CXE_ServiceId__r.Contract__c);
                    }
                    //END CSM-10961 RReyes AUG-15-17
                }
            }
            system.debug('>>>serviceSINSEnrolledPaid' + serviceSINSEnrolledPaid);
            // get all Services/Agreement__c under the related Account
            //START CSM-10961 RReyes AUG-15-17 - added Contract__r.V10_Account_No__c in query
            List<Agreement__c> listofServiceAgreements = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c
                                                                    ,Account__c,Service_Status__c, 
                                                                    Contract__r.V10_Account_No__c
                                                            ,(Select Address__c from Billing_Preferences__r) 
                                                               from Agreement__c WHERE Id in: sinIds 
                                                              ORDER BY Payor__r.V10_Account_No__c ASC]; 
                                                              //GVG //where Payor__r.AccountId In: accountIds
            //END CSM-10961 RReyes AUG-15-17 - added Contract__r.V10_Account_No__c in query
            List<Contract> listofContract = [Select Id,V10_Account_No__c,Bill_Print_Mode__c
                                                FROM Contract where Id in:contractIds  
                                                ORDER BY V10_Account_No__c ASC];

           
            //START CSM-10961 RReyes AUG-15-17
            List<Contract> listofContractPayor = [Select Id,V10_Account_No__c,Bill_Print_Mode__c
                                                FROM Contract where Id in:contractPayorIds  
                                                ORDER BY V10_Account_No__c ASC];
            //END CSM-10961 RReyes AUG-15-17

            //START CSM-12645 RReyes SEP-21-17 - check related services
            List<Agreement__c> listofServices = [Select Id, SIN__c, Payor__r.Id, Payor__r.V10_Account_No__c
                                                    FROM Agreement__c where Payor__r.V10_Account_No__c in: contractV10Numbers  
                                                    ORDER BY V10_Account_No__c ASC];
            for(Agreement__c serv: listofServices){
                if(!mapPayorToSIN.containsKey(serv.Payor__r.V10_Account_No__c)){
                    mapPayorToSIN.put(serv.Payor__r.V10_Account_No__c, new Set<Id>{serv.Id});
                }else{
                    mapPayorToSIN.get(serv.Payor__r.V10_Account_No__c).add(serv.Id);
                }  
            }

            System.debug('>>mapEnrolledCtrToSIN : ' + mapEnrolledCtrToSIN);
            System.debug('>>mapPayorToSIN : ' + mapPayorToSIN);
            for(String acct: contractV10Numbers){
                if(mapEnrolledCtrToSIN.containsKey(acct) && mapPayorToSIN.containsKey(acct)){
                    if(mapEnrolledCtrToSIN.get(acct)!= null && mapEnrolledCtrToSIN.get(acct).size() > 0
                        && (mapEnrolledCtrToSIN.get(acct).size() == mapPayorToSIN.get(acct).size())){
                            contractWithAllSINSEnrolled.add(acct);
                            contractWithAllSINSEnrolledPaid.put(acct, acct); // Start/End CSM-12735 Von Pernicia
                    }
                }
            }
            UData.AccountsWithAllSINEnrolled = contractWithAllSINSEnrolled; //START/END CSM-12645 RReyes SEP-21-17
            System.debug('>>contractWithAllSINSEnrolled : ' + contractWithAllSINSEnrolled);
            //END CSM-12645 RReyes SEP-21-17 - check related services

            //GVG
            List<accountAdditionalData> Adata = new List<accountAdditionalData>();
            for(Contract contr: listofContract){
                accountAdditionalData tempdata = new accountAdditionalData();
                string typeTemp = 'none';
                tempdata.AccountId = contr.V10_Account_No__c;
                tempdata.PrintMode = contr.Bill_Print_Mode__c;
               
                for(integer i = 0; typeTemp == 'none' || i < listofEnrollments.size(); i++ ){
                    if(contr.V10_Account_No__c == listofEnrollments[i].CXE_ServiceId__r.Payor__r.V10_Account_No__c){
                        typeTemp = listofEnrollments[i].CXE_Type__c;
                    }
                }
                tempData.Type = typeTemp;
                Adata.add(tempdata);
            }
            Udata.accountAddData = Adata;
            //GVG
            
            // get all related Accounts
            List<Account> listOfAccounts = [SELECT Id, Name ,Account_ID__c,IsPersonAccount FROM Account WHERE Id in: accountIds];
            
            set<string> V10Id = new set<string>();
            for(Contract contRec : listofContract){
                if(contRec.V10_Account_No__c!=null){
                    V10Id.add(contRec.V10_Account_No__c);
                }
            }
            
            List<CXE_Heroku_Model.BillDetail> bills = null;
            List<CXE_Heroku_Model.BillDetail> ListUserBills = null;
            List<CXE_Heroku_Model.BillDetail> ListUnpaidUserBills = null;
            if(includeBills){
                //get Heroku
                //bills = CXE_HerokuApps.getAllBills();
                bills = CXE_HerokuApps.getAllBillsBySinNos(sinNos);
                ListUserBills = new List<CXE_Heroku_Model.BillDetail>();
                ListUnpaidUserBills = new List<CXE_Heroku_Model.BillDetail>();
                
                string tempDueDate = 'DueDate';
                string laterdueDate = '1905-06-06';
                for( CXE_Heroku_Model.BillDetail Billrec: bills){            
                    //if(V10Id.contains(Billrec.account_number)){
                    ListUserBills.add(Billrec);  
                    //todo vince
                    if(Billrec.collection_status == 'Unpaid'){
                        if(Billrec.due_date == tempDueDate){
                            Udata.DueDateChange = true;
                        }
                        if( Date.valueOf(Billrec.due_date) > Date.valueOf(laterdueDate) ){
                            Udata.NewestDueDate = Billrec.due_date;
                        }
                        ListUnpaidUserBills.add(Billrec);
                        tempDueDate = Billrec.due_date;
                    }  

                    // Start CSM-12735 Von Pernicia
                    if(Billrec.bill_status_filter == 'Unpaid'){
                        contractWithUnpaidBill.add(Billrec.account_number); 
                        sinWithUnpaidBill.add(Billrec.service_number);
                    }
                    // End CSM-12735 Von Pernicia
                    //}
                }
                UData.BillCount         = ListUserBills.size();
                UData.UnpaidBillCount   = ListUnpaidUserBills.size();

                // Start R2C CSM-12735 Von Pernicia
                for(CXE_Service_Enrollment__c enroll : listofEnrollments){

                    String v10AccountNo = enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c;
                    String sinNo = enroll.CXE_ServiceId__r.SIN__c;

                    for (integer i=0; i<contractWithAllSINSEnrolledPaid.size(); i++) {
                        
                        if (contractWithUnpaidBill.contains(v10AccountNo)) {
                            contractWithAllSINSEnrolledPaid.remove(v10AccountNo);
                        }
                    }
                    
                    for (String sinNum: serviceSINSEnrolledPaid.keySet())
                    {
                        if (sinWithUnpaidBill.contains(sinNo)) {
                            serviceSINSEnrolledPaid.remove(sinNo);
                        }
                    }
                   
                }
                
                UData.AccountsWithAllSINEnrolledWithoutBill = contractWithAllSINSEnrolledPaid.values();
                UData.ServiceWithAllSINEnrolledWithoutBill = serviceSINSEnrolledPaid.values();

                // End R2C CSM-12735 Von Pernicia
            }
            system.debug('contractWithUnpaidBill>>' + contractWithUnpaidBill);
            //Rj --> Added UData for auto enrollment
            UData.autoEnroll        = userData.CXE_Auto_Enrolled_Services__c;
            UData.user              = userData;
            
            UData.UserEnrollments   = listofEnrollments;
            UData.UserAccounts      = listOfAccounts;
            UData.UserServices      = listofServiceAgreements;
            UData.UserContracts     = listofContract;
            UData.LastLoginDate     = userData.LastLoginDate;
            UData.FirstName         = userData.FirstName;
            UData.UserBills         = ListUserBills;
            UData.UnpaidUserBills   = ListUnpaidUserBills;
            UData.AccountCount      = listOfAccounts.size();
            UData.ServiceCount      = listofEnrollments.size();
            UData.ContractCount     = listofContract.size();
            UData.ServicesCount     = listofServiceAgreements.size();
            if(!listOfAccounts.isEmpty()){
                UData.UserType = listOfAccounts[0].IsPersonAccount;
            }
            // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            // Start CSM-12865 Jerome To added accountId
            // UData.caseList = getCaseList(new Set<Id> { CXE_CP_PortalUtility.getCurrentUserContacId() });
            UData.caseList = getCaseList(accountIds); // Lisen CSM-13935 20171025
            // End CSM-12865 Jerome To added accountId
            // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            //START CSM-10961 RReyes AUG-15-17
            UData.UserContractsViewBill =  listofContractPayor;
            UData.ContractCountViewBill =  listofContractPayor.size();
            //END CSM-10961 RReyes AUG-15-17
            
            //START R2C CSM-14350 Shayne 11-09-17
            Udata.isConglomerate = ([SELECT id,Conglomerate__c from Account where id=:userData.AccountId]).Conglomerate__c;
            System.debug('conglomerate '+Udata.isConglomerate);
			//END R2C CSM-14350 Shayne 11-09-17
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_PortalUtility', 'retrievePortalData(Boolean includeBills)', ex.getMessage());
        }

        return Udata;
    }

    //CSM-11322 Jerome To 
    private static Map<Id, String> getCaseStatusMapping(List<Case> caseList){
        Map<Id, String> caseRemarksMapping = new Map<Id, String>();
        Map<Id, String> caseScheduleDateMapping = new Map<Id, String>();
        Set<Id> caseIds = new Set<Id>();
        Set<String> caseStatusesForFO = new Set<String> { CXE_Constants.INSPECTION_FO_SCHEDULED, CXE_Constants.CASE_MSD_FO_SCHEDULED, 
                                                          CXE_Constants.CASE_STATUS_RE_INSPECTION_FO_SCHEDULED, CXE_Constants.CASE_PRE_SURVEY_FO_SCHEDULED};

        for(Case caseRec : caseList) {
            if(caseStatusesForFO.contains(caseRec.Status)) {
                caseIds.add(caseRec.Id);
            }
        }

        for(Field_Order__c fo : [SELECT RecordType.DeveloperName, Schedule_Date__c, Case__c, Case__r.Status 
                                  FROM Field_Order__c 
                                  WHERE Case__c IN :caseIds
                                  AND Schedule_Date__c != NULL
                                  AND (RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_INSPECTION_FO OR 
                                       RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_METER_SOCKET_FO OR 
                                       RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_RE_INSPECTION_FO OR 
                                       RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_SURVEY_FO) 
                                  ORDER BY CreatedDate ASC]) {
            if( statusJourneyMap.containsKey(fo.Case__r.Status) && 
                String.isNotBlank(statusJourneyMap.get(fo.Case__r.Status).Service_Application_Journey_Remarks__c) && 
                fo.RecordType.DeveloperName == statusJourneyMap.get(fo.Case__r.Status).Service_Application_Journey_Remarks__c) {
                caseScheduleDateMapping.put(fo.Case__c, fo.Schedule_Date__c.format());
            }              
        }

        for(Case caseRec : caseList) {
            String remarks = (!statusJourneyMap.containsKey(caseRec.Status) ? '' : ( caseScheduleDateMapping.containsKey(caseRec.Id) ?  caseScheduleDateMapping.get(caseRec.Id) : statusJourneyMap.get(caseRec.Status).Service_Application_Journey_Remarks__c) );
            caseRemarksMapping.put(caseRec.Id, remarks);
        }

        return caseRemarksMapping;
    }

    /* 
    * Description: Return a Map of Case Status Subsbcribe in PaperLess Billing
    * Parameters: List<listofContract> Contract,Set<Id> contractIds
    * Returns: List<CXE_Service_Enrollment__c>
    * Author: Melvin Corbes (Accenture)  //CSM-13719
    * Date Created: OCT-10-17
    */  
    private static Map<String, Boolean> retrieveHasOpenPBCase(List<Contract> listofContract, Set<Id> contractIds){
        Map<String, Boolean> resultMap = new Map<String, Boolean>();

        for(Contract con : listofContract){
            resultMap.put(con.V10_Account_No__c, false);
        }

        for(Case caseRec : [SELECT Id,
                                    Contract__r.id,
                                    Contract__r.V10_Account_No__c
                                  FROM Case
                                  WHERE RecordType.Name =: CXE_Constants.CASE_PAPERLESS_BILLING
                                  AND Contract__c IN: contractIds
                                  AND Application_Type_Subtype__c =: CXE_Constants.CASE_PAPERLESSBILLING_TYPE_SUB
                                  AND Status =: CXE_Constants.CASE_STATUS_OPEN ]) {

            if(caseRec.Contract__r.V10_Account_No__c!=null){
                resultMap.put(caseRec.Contract__r.V10_Account_No__c, true);
            }
        }

        return resultMap;
    }
    //End of CSM-13719




    /* 
    * Description: SOQL utility to get all Service Enrollments by Id
    * Parameters: Set<Id> enrollIds
    * Returns: List<CXE_Service_Enrollment__c>
    * Author: GGrandea (Accenture)  //CSM-12581
    * Date Created: OCT-3-17
    */  
    public static List<CXE_Service_Enrollment__c> retrieveServiceEnrollments(Set<Id> enrollIds){

        return [SELECT Id, CXE_ServiceId__c,
                            CXE_IsActive__c,
                            CXE_ServiceId__r.Payor__c,
                            CXE_ServiceId__r.Payor__r.Bill_Print_Mode__c
                         FROM CXE_Service_Enrollment__c 
                        WHERE Id in: enrollIds];
    }

    /* 
    * Description: SOQL utility to get other Active Service Enrollments of Contract
    * Parameters: Set<Id> contractIds, Set<Id> enrollmentIds
    * Returns: List<CXE_Service_Enrollment__c>
    * Author: GGrandea (Accenture)  //CSM-12581
    * Date Created: OCT-3-17
    */  
    public static List<CXE_Service_Enrollment__c> retrieveExistingServiceEnrollmentsOfPayor(Set<Id> contractIds
                                                                                            , Set<Id> enrollmentIds){

        return [SELECT Id, CXE_ServiceId__r.Payor__c
                     FROM CXE_Service_Enrollment__c 
                    WHERE CXE_ServiceId__r.Payor__c in: contractIds 
                            AND CXE_IsActive__c = true
                            AND Id NOT in: enrollmentIds];
    }

    /* 
    * Description: retrieve the Customer Portal Profile Id
    * Parameters: none
    * Returns: Id
    * Author: GGrandea (Accenture)   //CSM-13053
    * Date Created: OCT-5-17
    */  
    public static Id retrieveCustomerPortalProfileId(){
        return [SELECT Id FROM Profile WHERE Name=:CXE_Constants.PORTAL_COMMUNITY_PROFILE Limit 1].id;
    }

    //START R2C CSM-13274 Shayne
	 //START R2C CSM-14365 Shayne 11-09-17
    @AuraEnabled 
    public static Boolean checkIfConglomerateAccount(){
        System.debug('checkConglomerateAccount');
        Boolean isConglomerate = false;
       isConglomerate = ([SELECT id,Account.Conglomerate__c from User where id=:UserInfo.getUserId()]).Account.Conglomerate__c;
        System.debug('checkIfConglomerateAccount '+UserInfo.getUserId()+' : '+isConglomerate);
        return isConglomerate;
    }
     //END R2C CSM-14365 Shayne 11-09-17
    //END R2C CSM-13274 Shayne
    
    
    
	/*Description: Assign customer Due date
    * Parameters: none
    * Returns: String
    * Author: JRances
    * Date Created: SEPT-12-2017
        */
    
    
    //START CSM-14054 JRances / UAT,  Fix for Homepage Due Date Display (DCXE-144)
    //START CSM-14035 JRances / UAT, Due date not displayed correctly in the Accounts Overview
    //START CSM-13775 - Common due date of the unpaid bills doesn't display on the Due Date section of the Home Page 
    private static String setPortalBillDueDate(List<Contract> listofContract, List<CXE_Service_Enrollment__c> listofEnrollments, List<CXE_Heroku_Model.BillDetail> ListUnpaidUserBills){
        String finalDueDate;
        
        //IF PORTAL HAS 1 ACCOUNT AND 1 SERV
        if(listofContract.size() == 1 && listofEnrollments.size() == 1){
            
            //IF USER HAS ONLY ONE UNPAID BILL
            if(ListUnpaidUserBills.size() == 1){
                
                //COMPARE IF DUE DATE IS FUTURE OR OLDER DATE
                if(Date.valueOf(ListUnpaidUserBills[0].due_date) > Date.today()){
                    // START CSM-13976 JRances / UAT, Due Date should not have Time in the Home Page
                    Date dd = Date.valueOf(ListUnpaidUserBills[0].due_date);
                    finalDueDate = String.valueOf(dd);
                    //finalDueDate = String.valueOf(ListUnpaidUserBills[0].due_date);
                    // END CSM-13976 JRances 
                } else {
                    finalDueDate = 'Immediately';
                }
                
            } else {
                //IF USER HAS MORE THAN ONE UNPAID BILL
                Set<Date> setOfUnpaidBillDueDates = new Set<Date>();
                
                //GET ALL DUE DATE OF BILLS
                for(CXE_Heroku_Model.BillDetail loUnpaidBills : ListUnpaidUserBills){
                    setOfUnpaidBillDueDates.add(Date.valueOf(loUnpaidBills.due_date));
                }
                
                if(setOfUnpaidBillDueDates.size() == 1){
                    Date finaD = new List<Date> (setOfUnpaidBillDueDates).get(0);
                    finalDueDate = String.valueOf(finaD);
                } else {
                    //CHECK DUE DATES IF FUTURE OR OLD DUE DATES 
                    for(Date loUnpaidBills1 : setOfUnpaidBillDueDates){
                        if(loUnpaidBills1 < Date.today()){
                            finalDueDate = 'Immediately';
                            break;
                        } else {
                            finalDueDate = 'See list of bills';
                        }
                    }
                }
                
            }
            
        } else {
            //IF PORTAL HAS 1 OR MORE ACCOUNT OR 1 OR MORE SERV
            
            Set<Date> setOfUnpaidBillDueDates = new Set<Date>();
            
            //GET ALL DUE DATE OF BILLS
            for(CXE_Heroku_Model.BillDetail loUnpaidBills : ListUnpaidUserBills){
                setOfUnpaidBillDueDates.add(Date.valueOf(loUnpaidBills.due_date));
            }
            
            
            if(setOfUnpaidBillDueDates.size() == 1){
                
                //CHECK DUE DATES IF FUTURE OR OLD DUE DATES 
                for(Date loUnpaidBills1 : setOfUnpaidBillDueDates){
                    
                    if(loUnpaidBills1 > Date.today()){
                        // START CSM-13976 JRances / UAT, Due Date should not have Time in the Home Page
                        // START CSM-14002 JRances / No Due Date Displayed when bill due date is future dated
                        Date dd = Date.valueOf(loUnpaidBills1);
                        finalDueDate = String.valueOf(dd);
                        //finalDueDate = String.valueOf(setOfUnpaidBillDueDates);
                        // END CSM-14002 JRances
                        // END CSM-13976 JRances
                    } else {
                        finalDueDate = 'Immediately';
                        break;
                    } 
                }
                
            } else {
                //CHECK DUE DATES IF FUTURE OR OLD DUE DATES 
                for(Date loUnpaidBills1 : setOfUnpaidBillDueDates){
                    if(loUnpaidBills1 > Date.today()){
                        finalDueDate = 'See list of bills';
                    } else {
                        finalDueDate = 'Immediately';
                        break;
                    }
                }
            }
        }
        
        return finalDueDate;
    }
    //END CSM-13775
    //END CSM-14035 JRances 
    //END CSM-14054 JRances
    
    // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
    public static Id getCurrentUserContacId() {
        return [SELECT ContactId FROM User WHERE Id =:UserInfo.getUserId()].ContactId;
    }
    // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
}