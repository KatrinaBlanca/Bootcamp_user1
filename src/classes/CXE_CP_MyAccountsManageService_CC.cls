/*************************************************************************************** 
Developer -    Rom Edison Reyes (Accenture)
Date -         07/20/2017
Version -      1.0 
Function -     Method for adding service
#############Change Log#############
****************************************************************************************/
public without sharing class CXE_CP_MyAccountsManageService_CC { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"

    public CXE_CP_MyAccountsManageService_CC() {
        
        
    }

    public class Response{
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String caseNumber;
        
        public Response(Boolean isSuccess, String message){
            this.isSuccess = isSuccess;
            this.message = message;
            this.caseNumber = '';
        }  
        public Response(String caseNumber){
            this.isSuccess = true;
            this.message = '';
            this.caseNumber = caseNumber;
        }    
    }

    public class Request{
        @AuraEnabled
        public Boolean isNew {get; set;}

        @AuraEnabled
        public String email {get; set;}

        @AuraEnabled
        public String firstname {get; set;}

        @AuraEnabled
        public String middlename {get; set;}

        @AuraEnabled
        public String lastname {get; set;}

        @AuraEnabled
        public String suffix {get; set;}

        @AuraEnabled
        public String mobileNumber {get; set;}

        @AuraEnabled
        public String SIN {get; set;}

        @AuraEnabled
        public Decimal amount {get; set;}

        @AuraEnabled
        public Date transactionDate {get; set;}
    }


    public class SINWrapper{
        public Boolean hasError {get; set;}
        public String errorMessage {get; set;}
        public String caseNumber {get; set;}

        public SINWrapper(String errorMessage){
            this.hasError = String.isNotBlank(errorMessage);
            this.errorMessage = errorMessage;
            this.caseNumber = caseNumber;
        }

        public SINWrapper(Boolean hasError, String caseNumber){
            this.hasError = false;
            this.errorMessage = '';
            this.caseNumber = caseNumber;
        }  
    }

    public class BillWrapper{
        public Boolean hasError {get; set;}
        public List<String> errorMessages {get; set;}

        public BillWrapper(List<String> errorMessages){
            this.hasError = !errorMessages.isEmpty();
            if(!errorMessages.isEmpty()) {
                this.errorMessages = errorMessages;
            }
        }

        public BillWrapper(Boolean hasError){
            this.hasError = hasError;
        }  
    }


    //@AuraEnabled
    //public static CXE_CP_MyAccountsManageService_CC.Response createUser(CXE_CP_SplashPageSelfRegistration_Req request) {
    @AuraEnabled
    public static CXE_CP_MyAccountsManageService_CC.Response enrollService(String sin, Decimal amount, String transactionDate, Boolean isNew) {
        try{
            Date bpDate = Date.valueOf(transactionDate);
            //START CSM-14735 JIntal 11/30/2017
            Set<String> cbgFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP001, CXE_Constants.SERVICE_CODE_SEGMENT_1};
            Set<String> smeFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP003, CXE_Constants.SERVICE_CODE_SEGMENT_3}; // CSM-15180 LISEN
			//END CSM-14735 JIntal 11/30/2017
			
            // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
            Set<String> hmbFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP002, CXE_Constants.SERVICE_CODE_SEGMENT_2};
            // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017

            CXE_CP_MyAccountsManageService_CC.Request request = createReqForServiceEnrollment(sin, amount, bpDate, isNew);
            
            if(request.SIN.length() != 12) {
                return new CXE_CP_MyAccountsManageService_CC.Response(false, CXE_Constants.SERVICE_ENROLLMENT_SIN_INVALID_LENGTH);
            }
            
            Set<Id> enrolledServiceIds = getEnrolledSINIds();
            List<Agreement__c> serviceList = getSIN(request.SIN);
            
            //START CSM-12474 Mike Verdad 09/12/2017 (Swapped position with validateBillingOrPayment, previously under validateBillingOrPayment condition)
            SINWrapper sinWrapper = validateSIN(request, serviceList, enrolledServiceIds);
            if(sinWrapper.hasError) {
                return new CXE_CP_MyAccountsManageService_CC.Response(false, sinWrapper.errorMessage);
            }
            //End START CSM-12474 Mike Verdad 09/12/2017
            
            BillWrapper billWrapper = validateBillingOrPayment(request, serviceList);
            if(billWrapper.hasError) {
                //START CSM-12435 Emandolado 9/5/2017
                //return new CXE_CP_MyAccountsManageService_CC.Response(false, billWrapper.errorMessages[0]);
                return new CXE_CP_MyAccountsManageService_CC.Response(false, String.join(billWrapper.errorMessages, ' ') );//CSM-13869 added space join error messages 10.12.2017
                //END CSM-12435 Emandolado 9/5/2017
            }

            //START CSM-15180 LISEN 20180117
            //START CSM-14735 JIntal 11/30/2017
            if(cbgFilters.contains(serviceList.get(0).Code_Segment__c)){
                return new CXE_CP_MyAccountsManageService_CC.Response(false, CXE_Constants.SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED);
            }
            //END CSM-14735 JIntal 11/30/2017
            else if(smeFilters.contains(serviceList.get(0).Code_Segment__c)){
                return new CXE_CP_MyAccountsManageService_CC.Response(createCaseForBusiness(request, serviceList.get(0)));
            }
            //END CSM-15180 LISEN 20180117
            
            //START CSM-12858 GGrandea 09.21.2017
            if(!serviceList.get(0).Payor__r.Account.IsPersonAccount) {

                // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
                if(hmbFilters.contains(serviceList.get(0).Code_Segment__c)) { 
                    String userId = UserInfo.getUserId();                
                    if(String.isNotBlank(userId)) {
                        createServiceEnrollmentList(request, serviceList.get(0), userId, enrolledServiceIds);
                    }
                    return new CXE_CP_MyAccountsManageService_CC.Response(true, CXE_Constants.SERVICE_ENROLLMENT_SUCCESSFUL);
                } 
                // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
            }

            
            //END CSM-12858 GGrandea 09.21.2017
            
            /* CSM-12474 Mike Verdad 09/12/2017 (transferred above validateBillingOrPayment)
             
            SINWrapper sinWrapper = validateSIN(request, serviceList, enrolledServiceIds);
            if(sinWrapper.hasError) {
                return new CXE_CP_MyAccountsManageService_CC.Response(false, sinWrapper.errorMessage);
            }
            */
            
            //START CSM-12858 GGrandea 09.21.2017
            /*if(String.isNotBlank(sinWrapper.caseNumber)) {
                return new CXE_CP_MyAccountsManageService_CC.Response(sinWrapper.caseNumber);
            }*/
            //END CSM-12858 GGrandea 09.21.2017

            
            if(!serviceList.isEmpty()) {
                String userId = UserInfo.getUserId();
                
                if(String.isNotBlank(userId)) {
                    createServiceEnrollmentList(request, serviceList.get(0), userId, enrolledServiceIds);
                }
            }

            return new CXE_CP_MyAccountsManageService_CC.Response(true, CXE_Constants.SERVICE_ENROLLMENT_SUCCESSFUL);
        } catch(Site.ExternalUserCreateException e) {
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyAccountsManageService_CC', 'enrollService', UserInfo.getUserId() + ' : ' + e.getMessage());
            return new CXE_CP_MyAccountsManageService_CC.Response(false, e.getMessage());
        } catch(Exception e) {
            ErrorHandlerException.recordException(null, true, 'CXE_CP_MyAccountsManageService_CC', 'enrollService', UserInfo.getUserId() + ' : ' + e.getMessage());
            return new CXE_CP_MyAccountsManageService_CC.Response(false, e.getMessage());
        }
    }
    
    //Vincent V10 Integration 8/10/2017
    //public static void requestUpdateToV10(List<CXE_Service_Enrollment__c> listofEnrollments){ //CSM-12833 modified param
    //START CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
    /*public static void requestUpdateToV10(Agreement__c service){ //CSM-12833 GGrandea 09.19.2017
        //START CSM-12833 GGrandea 09.19.2017
        //List<CXE_Service_Enrollment__c> getContracts = [select CXE_ServiceId__r.Payor__c 
        //                                                from CXE_Service_Enrollment__c 
        //                                               where id =: listofEnrollments[0].id
        //                                                and CXE_Type__c = 'Payor'];
        //END CSM-12833 GGrandea 09.19.2017

        List<Contract> contractRecords = new List<Contract>();
        //START CSM-12833 GGrandea 09.19.2017
        //if(getContracts.size() > 0){
        if(service.Payor__c!=null){
        //END CSM-12833 GGrandea 09.19.2017
            contractRecords = [Select Id,Contract_External_ID__c,Bill_Print_Mode__c
                                              from Contract 
                                              //where id=:getContracts[0].CXE_ServiceId__r.Payor__c]; //CSM-12833
                                              where id=:service.Payor__c]; //CSM-12833
        }
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>'+contractRecords);
        if(contractRecords.size() > 0){
            //START CSM-12847 GGrandea 09.20.2017
            //if(contractRecords[0].Bill_Print_Mode__c !=CXE_Constants.BPM_PAPERPLUS || contractRecords[0].Bill_Print_Mode__c !=CXE_Constants.BPM_PAPERLESS){
            if(contractRecords[0].Bill_Print_Mode__c==CXE_Constants.BPM_PAPER){
            //END CSM-12847 GGrandea 09.20.2017
                //START CSM-12285 RReyes AUG-22-17 - changed parameter from contractRecords[0] to contractRecords[0]
                CXE_CP_BillPrintModeIntegrationUtility.printmodeUpdateRequest (contractRecords , CXE_Constants.BPM_PAPERPLUS);
                //END CSM-12285 RReyes AUG-22-17 - changed parameter from contractRecords[0] to contractRecords[0]
            }
        }   
        
    }
    */
    //END CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
    //End
    
    //START CSM-10271 RReyes JUL-21-17
    @AuraEnabled
    public static CXE_CP_MyAccountsManageService_CC.Response hasBeenUsedByAnotherPortalAccount(String sin) {
       
       /* return new CXE_CP_MyAccountsManageService_CC.Response(true, ([SELECT COUNT() 
         FROM CXE_Service_Enrollment__c 
         WHERE CXE_ServiceId__r.SIN__c =:sin 
          AND CXE_IsActive__c = true 
         AND CXE_UserId__c !=:UserInfo.getUserId()] == 1) ? CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE : ''); //commented out : Melvin Corbes 09-13-2017 
        */  
        
        /*
        //START CSM-12460 Melvin Corbes
        return new CXE_CP_MyAccountsManageService_CC.Response(true, ([SELECT COUNT() 
                                                                      FROM CXE_Service_Enrollment__c 
                                                                      WHERE CXE_ServiceId__r.SIN__c =:sin 
                                                                      AND CXE_IsActive__c = true 
                                                                      AND CXE_UserId__c !=:UserInfo.getUserId()] == 1) ? CXE_Constants.SERVICE_ENROLLMENT_NOTICE_SIN_HAS_BEEN_USED : '');
        
       //END OF CSM-12460 Corbes
       */ //commented by John Mark Fernandez and reuse the code and changed the CXE_Constants below
        
       //START CSM-13929 John Mark Fernandez
        return new CXE_CP_MyAccountsManageService_CC.Response(true, ([SELECT COUNT() 
                                                                      FROM CXE_Service_Enrollment__c 
                                                                      WHERE CXE_ServiceId__r.SIN__c =:sin 
                                                                      AND CXE_IsActive__c = true 
                                                                      AND CXE_UserId__c !=:UserInfo.getUserId()] == 1) ? CXE_Constants.PORTAL_REGISTRATION_NOTICE_SIN_HAS_BEEN_USED2 : '');
        //END OF CSM-13929 John Mark Fernandez
}
    //END CSM-10271 RReyes JUL-21-17

    // CSM-10823 This SIN has reached its maximum portal account enrollments
    private static Boolean hasBeenRegisteredTwice(String serviceId){
        //check if registered by two portal accounts        
        return [SELECT COUNT() FROM CXE_Service_Enrollment__c WHERE CXE_ServiceId__c =:serviceId AND CXE_IsActive__c = true] >= 2;      
    }

    private static CXE_CP_MyAccountsManageService_CC.Request createReqForServiceEnrollment(String sin, Decimal amount, Date transactionDate, Boolean isNew){           
        CXE_CP_MyAccountsManageService_CC.Request req = new CXE_CP_MyAccountsManageService_CC.Request();
        User currentUser = [SELECT FirstName, MiddleName, LastName, Suffix, Email, MobilePhone FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        req.email = currentUser.Email;
        req.firstname = currentUser.FirstName;
        req.middlename = currentUser.MiddleName;
        req.lastname = currentUser.LastName;
        req.suffix = currentUser.Suffix;
        req.mobileNumber = currentUser.MobilePhone;
        req.sin = sin;
        req.amount = amount;
        req.transactionDate = transactionDate;
        req.isNew = isNew;
        return req;
    }

    // CSM-10811 As a system, I want to display an error message when the customer is enrolling for a Prepaid SIN during registration
    // show error "Prepaid SINs are not allowed to be enrolled in a portal account for this release"
    private static SINWrapper validateSIN(CXE_CP_MyAccountsManageService_CC.Request request, List<Agreement__c> serviceList, Set<Id> enrolledServiceIds) {

        Set<String> cbgFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP001, CXE_Constants.SERVICE_CODE_SEGMENT_1}; // CSM-13764
        Set<String> hmbFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP002, CXE_Constants.SERVICE_CODE_SEGMENT_2}; // CSM-13764
        Set<String> smeFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP003, CXE_Constants.SERVICE_CODE_SEGMENT_3}; // CSM-13764

        if(serviceList.isEmpty()) {
            return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_INACTIVE);
        } else {
            Agreement__c service = serviceList.get(0);
            
            // START CSM-14944 Lisen
            if(service.Payor__r.Account.Retail_Electricity_Supplier__c) {        
            // END CSM-14072 Jerome To 11.09.2017        
                return new SINWrapper(String.format(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_RES, new List<String>{ service.Payor__r.Account.Owner.Name }));
            }
            // END CSM-14944
            /**** start CSM-14735 JIntal 12/06/17****/
            if(cbgFilters.contains(service.Code_Segment__c)){
                // START CSM-14827 Jerome To 12/08/2017 - [R2C Regression] Issues when adding CBG SIN in portal account
                sendEmailTOCBGRM(request, service);
                // END CSM-14827 Jerome To 12/08/2017 - [R2C Regression] Issues when adding CBG SIN in portal account
                 return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED);
            }
			/**** end CSM-14735 JIntal 12/06/17****/
            
            //add validation if SIN is already enrolled in the same account
            if(!enrolledServiceIds.isEmpty()){
                if(enrolledServiceIds.contains(service.Id)){
                    return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_SIN_ALREADY_ENROLLED);
                }
            }

            // CSM-10811 As a system, I want to display an error message when the 
            //           customer is enrolling for a Prepaid SIN during registration
            if(service.Payor__r.Type__c == CXE_Constants.CONTRACT_TYPE_PREPAID) {
                return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_PREPAID);
            }
            // CSM-10769 As a system, I want to display an error message containing to 
            //           RM of that SIN when a customer is self-registering for a CBG account
            
            //START CSM-10853 RReyes JUL-21-17 - As a system, I want to display an error message when the customer is enrolling for a Retailer SIN during SIN enrollment
            if(service.Related_Account__c != null) {
                return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_SIN_RES);
            }
            //*** CSM-14735 - JIntal - 12-05-17 ***// 
            /*if(service.Related_Account__c != null && cbgFilters.contains(service.Code_Segment__c)){
                return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED);
            } else if (service.Related_Account__c != null){
				return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_SIN_RES);                
            }*/
            //*** CSM-14735 - JIntal - 12-05-17 ***// 
            //END CSM-10853 RReyes JUL-21-17 - As a system, I want to display an error message when the customer is enrolling for a Retailer SIN during SIN enrollment

            // CSM-10823
            if(hasBeenRegisteredTwice(service.Id)) {
                return new SINWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE);
            }

            //START CSM-10883, CSM-10889, CSM-10895 RReyes JUL-21-17 
            CXE_Service_Enrollment__c enrolledService = mySE();
            if(enrolledService != null){
                // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
                // Set<String> hmbFilters = new Set<String> {CXE_Constants.SERVICE_CODE_SEGMENT_BSEGTYP002, CXE_Constants.SERVICE_CODE_SEGMENT_2};
                // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017

                if(cbgFilters.contains(service.Code_Segment__c)){
                    //START CSM-10865 RReyes JUL-28-17
                    return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED);
                    //return new SINWrapper(String.format(CXE_Constants.PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT, new List<String>{ service.Payor__r.Account.Owner.Name }));
                    //END CSM-10865 RReyes JUL-28-17
                }
                //*** CSM-14735 - JIntal - 12-05-17 ***// 
                if(cbgFilters.contains(service.Code_Segment__c) && service.Related_Account__c != null){
                    return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED);
                }
                //*** CSM-14735 - JIntal - 12-05-17 ***// 
                else{
                    // Lisen - CSM-13764 - no longer validate conglomerate -> instead all CBG services will be prompted with error message
                    if(enrolledService.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){
                        // Portal User is Person Account
                        if(smeFilters.contains(service.Code_Segment__c)){
                            // SME
                            return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_CBG_BIZ_NOT_ALLOWED); // To update with correct message
                        }else{
                            // HMB
                            if(service.Payor__r.Account.IsPersonAccount){
                                // Service Account is Individual -> can proceed -> handled by creation of service enrollment
                            }else{
                                // Service Account is Business
                                return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_CBG_BIZ_NOT_ALLOWED); // To update with correct message
                            }
                        }

                    }else{
                        // Portal User is not Person Account

                        if(smeFilters.contains(service.Code_Segment__c)){
                            // SME - create case
                        }
                        else{
                            // HMB
                            if(service.Payor__r.Account.IsPersonAccount){
                                // Service Account is Individual
                                return new SINWrapper('Unable to enroll a Residential Service into a Business Account'); // To update with correct message
                            }else{
                                // Service Account is Business -> can proceed -> handled by creation of service enrollment
                            }
                        }
                    }
                }

                //CSM-10883
                
                
                //CSM-10889
                // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
                //if(enrolledService.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount && !service.Payor__r.Account.IsPersonAccount && !hmbFilters.contains(service.Code_Segment__c)){
                //    return new SINWrapper(String.format(CXE_Constants.SERVICE_ENROLLMENT_CBG_BIZ_NOT_ALLOWED, new List<String>{ service.Payor__r.Account.Owner.Name }));
                //}
                // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017

                /* CSM-13764 Lisen -> removing
                if(enrolledService.CXE_ServiceId__r.Payor__r.AccountId != service.Payor__r.AccountId && !enrolledService.CXE_ServiceId__r.Payor__r.Account.IsPersonAccount){
                    return new SINWrapper(CXE_Constants.SERVICE_ENROLLMENT_SIN_NOT_UNDER_ACCOUNT);
                }
                CSM-13764 */
            }
            //END CSM-10883, CSM-10889, CSM-10895 RReyes JUL-21-17 

            

            //START CSM-12858 GGrandea 09.21.2017
            /*if(!service.Payor__r.Account.IsPersonAccount) {                
                return new SINWrapper(false, createCaseForBusiness(request, service)); //CSM-12447 GGrandea 09.06.2017
            }*/
            //END CSM-12858 GGrandea 09.21.2017

            return new SINWrapper(null);
        }        
    }

    /* 
     * Description: Create Business Self Registration Case
     * Parameters: CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service
     * Returns: String - CaseNumber of created Case record
     * Author: RReyes (Accenture)
     * Date Created: FEB-24-17
     *
     * Revision:
     *      09.06.2017  GGrandea    CSM-12447 - changed parameter from Id to Agreement__c
    */  
    private static String createCaseForBusiness(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service){
        try{
            Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND IsActive = true AND DeveloperName =:CXE_Constants.CASE_RECORD_TYPE_BUSINESS_SELF_REGISTRATION].Id;
            Case caseRecord =  new Case();
            caseRecord.Email_Address__c = request.email;
            caseRecord.Business_Email__c = service.Payor__r.Account.Owner.Email; //CSM-12447 GGrandea 09.06.2017
            caseRecord.First_Name__c = request.firstname;
            caseRecord.Middle_Name__c = request.middlename;
            caseRecord.Last_Name__c = request.lastname;
            caseRecord.Mobile_No__c = request.mobileNumber;
            caseRecord.CXE_Service__c = service.Id;
            if(!request.isNew){
                caseRecord.Total_kWh__c = request.amount;
                caseRecord.Bill_Date__c = request.transactionDate;
            } else {
                caseRecord.Bill_Deposit_Amount__c = request.amount;
                caseRecord.Payment_Date__c = request.transactionDate;
            }         
            caseRecord.RecordTypeId = recordTypeId;
            caseRecord.CXE_isRegistrationCase__c = false;
            // START CSM-13756 Jerome To 10/17/2017 [R2B SQT] Email to Biz RM that a case is created for appropriate action.
            caseRecord = populateIROandRO(service, caseRecord); // CSM-10769 Jerome To 08/10/2017
            caseRecord.AccountId = service.Payor__r.AccountId;
            // END CSM-13756 Jerome To 10/17/2017 [R2B SQT] Email to Biz RM that a case is created for appropriate action.
            // START CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            Id contactId = CXE_CP_PortalUtility.getCurrentUserContacId();
            if(contactId != null){
                caseRecord.ContactId = contactId;
            }
            // END CSM-13935 Jerome To 10/17/2017 [R2B SQT] Only Portal created requests are displayed in the Request tab
            insert caseRecord;
            return [SELECT CaseNumber FROM Case WHERE Id=:caseRecord.Id].CaseNumber;
        } catch (DmlException e) {
            throw e;
        }
    } 

    //private static List<Agreement__c> getSIN(String serviceIdNumber) {
    //    return [SELECT Contract__r.Type__c, Account__c, Account__r.Conglomerate__c, 
    //                   Account__r.Owner.Name, RES__c, Payor__c, Account__r.IsPersonAccount, Account__r.FirstName, 
    //                   Account__r.MiddleName, Account__r.LastName 
    //            FROM Agreement__c 
    //            WHERE SIN__c =:serviceIdNumber 
    //            AND Service_Status__c = :CXE_Constants.SERVICE_STATUS_ACTIVE];
    //}
    
    private static List<Agreement__c> getSIN(String serviceIdNumber) {
        //START CSM-10865 RReyes - JUL-28-17 - added Payor__r.Account.Owner.MobilePhone
        // START CSM-13948 Jerome To 10/18/2017 Added Case fields and Case Id in filter
        //START CSM-14969 RReyes DEC-27-17 - added Payor__r.Account.Retail_Electricity_Supplier__c
        return [SELECT Payor__r.Type__c, Account__c, Payor__r.Account.Conglomerate__c, Payor__r.V10_Account_No__c, V10_Account_No__c,
                       Payor__r.Account.Owner.Name, Related_Account__c, Payor__c, Payor__r.Account.IsPersonAccount, Payor__r.Account.FirstName, 
                       Payor__r.Account.MiddleName, Payor__r.Account.LastName , Payor__r.AccountId, Payor__r.Account.Owner.MobilePhone,
                       Payor__r.Account.Owner.Email, Code_Segment__c, Payor__r.Account.Name, Payor__r.Account.Retail_Electricity_Supplier__c,
                       Case__c, Case__r.Initial_Responsible_Office__c, Case__r.Responsible_Office_Lookup__c //CSM-12858 GGrandea 09.21.2017 //CSM-13764 Jerome To 10/09/2017
                FROM Agreement__c 
                WHERE SIN__c =:serviceIdNumber 
                AND (Service_Status__c = :CXE_Constants.SERVICE_STATUS_ACTIVE
                OR Service_Status__c = :CXE_Constants.SERVICE_STATUS_ACTIVE_DISCONNECTED
                OR Service_Status__c = :CXE_Constants.SERVICE_STATUS_ACTIVE_PENDING_TO_DISCONNECT)]; //13983 GGrandea 10.19.2017
        //END CSM-14969 RReyes DEC-27-17 - added Payor__r.Account.Retail_Electricity_Supplier__c
        // END CSM-13948 Jerome To 10/18/2017 Added Case fields and Case Id in filter
        //END CSM-10865 RReyes - JUL-28-17 - Payor__r.Account.Owner.MobilePhone
    }

    //private static List<Agreement__c> getRelatedServices(String accountId) {
    //    return [SELECT Contract__r.Type__c, Account__r.Conglomerate__c, Account__r.Owner.Name, 
    //                   RES__c, Payor__c, Account__r.IsPersonAccount, Account__r.FirstName, 
    //                   Account__r.MiddleName, Account__r.LastName 
    //            FROM Agreement__c 
    //            WHERE Account__c =:accountId];
    //}

    //START Updates CSM-12461 GGrandea 09.12.2017
    //private static List<Agreement__c> getRelatedServices(String accountId) {
    private static List<Agreement__c> getRelatedServices(Id payorId) {
        return [SELECT Payor__r.Account.Id, Payor__r.Type__c, Payor__r.Account.Conglomerate__c, Payor__r.Account.Owner.Name, 
                       Related_Account__c, Payor__c, Payor__r.Account.IsPersonAccount, Payor__r.Account.FirstName, 
                       Payor__r.Account.MiddleName, Payor__r.Account.LastName , Payor__r.Account.Name
                FROM Agreement__c 
                //WHERE Payor__r.Account.Id =:accountId
                WHERE Payor__c =:payorId
                AND Service_Status__c !=:CXE_Constants.SERVICE_STATUS_PENDING];
    }
    //END Updates CSM-12461 GGrandea 09.12.2017

    //START CSM-10883, CSM-10889, CSM-10895 RReyes JUL-21-17 
    private static CXE_Service_Enrollment__c mySE(){
        CXE_Service_Enrollment__c se;
        List<CXE_Service_Enrollment__c> servEnr = [SELECT CXE_ServiceId__c, CXE_ServiceId__r.Payor__r.AccountId,
                                                        CXE_ServiceId__r.Payor__r.Account.IsPersonAccount 
                                                    FROM CXE_Service_Enrollment__c 
                                                    WHERE CXE_UserId__c=:UserInfo.getUserId() AND CXE_ServiceId__r.Payor__r.AccountId != null LIMIT 1];   
        if(!servEnr.isEmpty()){
            se = servEnr[0];
        }
        return se;
    }
    //END CSM-10883, CSM-10889, CSM-10895 RReyes JUL-21-17

    private static Set<Id> getEnrolledSINIds(){
        Set<Id> serviceIds = new Set<Id>();
        for(CXE_Service_Enrollment__c se: [SELECT CXE_ServiceId__c FROM CXE_Service_Enrollment__c 
                                            WHERE CXE_UserId__c=:UserInfo.getUserId() AND CXE_ServiceId__c != null
                                                AND CXE_IsActive__c = TRUE ]){ //CSM-12917 GGrandea 09.22.2017 added CXE_IsActive__c
            serviceIds.add(se.CXE_ServiceId__c );
        }  

        return serviceIds;
    }

    private static CXE_Service_Enrollment__c createServiceEnrollment(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service, Id userId) {
        CXE_Service_Enrollment__c serviceEnrollment = new CXE_Service_Enrollment__c();
        serviceEnrollment.CXE_ServiceId__c = service.Id;
        serviceEnrollment.CXE_UserId__c = userId;
        serviceEnrollment.CXE_IsActive__c = true;
        serviceEnrollment.CXE_Type__c = (isPayor(request, service) ? CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR : CXE_Constants.SERVICE_ENROLLMENT_TYPE_NON_PAYOR);
        return serviceEnrollment;
    }

    private static void createServiceEnrollmentList(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service, Id userId, Set<Id> enrolledServiceIds) {
        List<CXE_Service_Enrollment__c> serviceEnrollmentList = new List<CXE_Service_Enrollment__c>();
        List<CXE_Service_Enrollment__c> existingEnrollmentList = new List<CXE_Service_Enrollment__c>();
        List<Agreement__c> relatedServices = new List<Agreement__c>();
        if(isPayor(request, service)) {
            //START Updates CSM-12461 GGrandea 09.12.2017
            //relatedServices = getRelatedServices(service.Payor__r.AccountId);
            relatedServices = getRelatedServices(service.Payor__c);
            //END Updates CSM-12461 GGrandea 09.12.2017
        }  else {
            relatedServices.add(service);
        } 
        system.debug('>> relatedServices:' + relatedServices);
        for(Agreement__c serviceRecord : relatedServices) {
            if(!enrolledServiceIds.contains(serviceRecord.Id)){
                serviceEnrollmentList.add(createServiceEnrollment(request, serviceRecord, userId));   
            }
        } 
        system.debug('>> serviceEnrollmentList:' + serviceEnrollmentList); 

        
        if(!serviceEnrollmentList.isEmpty()){
            //START CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
            //vincent pass to V10integration method
            //CXE_CP_MyAccountsManageService_CC.requestUpdateToV10(serviceEnrollmentList); //CSM-12833 disabled
            //CXE_CP_MyAccountsManageService_CC.requestUpdateToV10(service); //CSM-12833 //CSM-12877 disabled
            //EMD CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
            
            insert serviceEnrollmentList;
                       
        }

        if(serviceEnrollmentList.size() > 1){
            User myUser = new User();
            myUser.Id = userId;
            myUser.CXE_Auto_Enrolled_Services__c = true;
            update myUser;
        }
    }

    //private static String getEnrollmentType(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service) {
    //   return (request.firstname == service.Payor__r.Account.FirstName && request.middlename == service.Payor__r.Account.MiddleName && request.lastname == service.Payor__r.Account.LastName) ? CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR : CXE_Constants.SERVICE_ENROLLMENT_TYPE_NON_PAYOR;
    //}

    private static Boolean isPayor(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service) {
        // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017   
        return isRegisteredNameSameAsAccountName(request, service);
        // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017   
        //return (request.firstname == service.Payor__r.Account.FirstName && request.lastname == service.Payor__r.Account.LastName);
    }
    // CSM-10787 No Bill Date
    /*
    private static BillWrapper validateBilling(CXE_CP_MyAccountsManageService_CC.Request request, List<CXE_Heroku_Model.BillDetail> billingDetails) {


        if(!request.isNew) {
            //CSM-10787
            if(!hasMatchingBillingDate(request, billingDetails)) {
                return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_BILL_DID_NOT_MATCH_BILL_DATE);
            }
        } else {
            
        }

        if(billingDetails.isEmpty()) {
            return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_NO_BILLING_DETAILS);
        }

        if(billingDetails.size() > 1) {
            if (!hasValidAmountAndBillingDate(request, billingDetails)) {
                return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_NOT_NEWLY_ENERGIZE);
            }
        } else {
            if (!hasValidAmountAndBillingDate(request, billingDetails)) {
                return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_NEWLY_ENERGIZE);
            }
        }

        return new BillWrapper('');
    }
    */

    // START CSM-13922 Jerome To 10/30/2017
    ////CSM-10787
    //private static Boolean hasMatchingBillingDate(CXE_CP_MyAccountsManageService_CC.Request request, List<CXE_Heroku_Model.BillDetail> billingDetails) {
    //    for(Integer i = 0; i < 2; i++) {
    //        // START CSM-12917 Jerome To Updated bill_date to gen_date
    //        if(Date.valueOf(billingDetails.get(i).gen_date) == request.transactionDate) {
    //            return true;
    //        }
    //        // END CSM-12917 Jerome To Updated bill_date to gen_date
    //    }
    //    return false;
    //}
    // END CSM-13922 Jerome To 10/30/2017

    /*
    private static CXE_Heroku_Model.BillDetail getBillingDetails(CXE_CP_MyAccountsManageService_CC.Request request) {
       return new CXE_Heroku_Model.BillDetail();
    }
    */

    // START CSM-13922 Jerome To 10/30/2017
    ////CSM-10733
    //private static Boolean hasValidAmountAndBillingDate(CXE_CP_MyAccountsManageService_CC.Request request, List<CXE_Heroku_Model.BillDetail> billingDetails) {
    //    for(Integer i = 0; i < 2; i++) {
    //        // START CSM-12917 Jerome To Updated bill_date to gen_date
    //        if(Date.valueOf(billingDetails.get(i).gen_date) == request.transactionDate && Decimal.valueOf(billingDetails.get(i).total_amount) == request.amount) {
    //           return true;
    //        }
    //        // END CSM-12917 Jerome To Updated bill_date to gen_date
    //    }
    //    return false;
    //}
    // END CSM-13922 Jerome To 10/30/2017

    //Start Roden Paolo Songco - Aug 02, 2017
    
    private static BillWrapper validateBillingOrPayment(CXE_CP_MyAccountsManageService_CC.Request request, List<Agreement__c> serviceList) {
        //CSM-11340
        if(!request.isNew) {
            //CSM-10787
            // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
            return validateBilling(request, serviceList.get(0));
            // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
        } else if(!serviceList.isEmpty()){
            return validatePayment(request, serviceList.get(0));
        }

        //if(billingDetails.isEmpty()) {
        //    return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_NO_BILLING_DETAILS);
        //}

        //if(billingDetails.size() > 1) {
        //    if (!hasValidAmountAndBillingDate(request, billingDetails)) {
        //        return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_NOT_NEWLY_ENERGIZE);
        //    }
        //} else {
        //    if (!hasValidAmountAndBillingDate(request, billingDetails)) {
        //        return new BillWrapper(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_NEWLY_ENERGIZE);
        //    }
        //}
        
        return new BillWrapper(false);
    }
    
    // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
    //CSM-11340
    //private static BillWrapper validateBilling(CXE_CP_MyAccountsManageService_CC.Request request) {
    private static BillWrapper validateBilling(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service) {
        //List<CXE_Heroku_Model.BillDetail> billingDetails = getBillingDetails(request);
        List<CXE_Heroku_Model.BillDetail> billingDetails = getBillingDetails(request, service.Payor__r.V10_Account_No__c);
    // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
        List<String> errorMsgs = new List<String>();
        List<String> errors = new List<String>();  //CSM-12443
        if(!billingDetails.isEmpty()) {
            // CSM-14105 Lisen 20171026

            // START CSM-14159 Lisen 20171028
            Date twoMosAgo = Date.Today().addMonths(-2).toStartofMonth();
            if(request.transactionDate < twoMosAgo){
                errorMsgs.add(CXE_Constants.SERVICE_ENROLLMENT_MUST_BE_LESS_THAN_2_MONTHS_AGO);
            }else{
                Boolean errorFlag = False; //CSM-14782 JIntal 12/06/2017
                for(Integer i = 0; i < billingDetails.size(); i++) {
                    // START CSM-13019 Jerome To Added null checking for bill_usage and gen_date
                    //if(i < 2 && String.isNotBlank(billingDetails.get(i).bill_usage) && String.isNotBlank(billingDetails.get(i).gen_date)){
                    if(String.isNotBlank(billingDetails.get(i).bill_usage) && String.isNotBlank(billingDetails.get(i).gen_date)) {
                    // END CSM-13019 Jerome To Added null checking for bill_usage and gen_date
                        CXE_Heroku_Model.BillDetail bill = billingDetails.get(i);
                        decimal consumption = Decimal.valueOf(bill.bill_usage);
                        // END CSM-12917 Jerome To Updated bill_date to gen_date
                        Date transactionDate = Date.valueOf(bill.gen_date);
                        // END CSM-12917 Jerome To Updated bill_date to gen_date
                        
						
                            
                        String billType = bill.bill_type;
                        // START CSM-12451, CSM-12517 Jerome To Remove this code
                        //errorMsgs = new List<String>();
                        // END CSM-12451, CSM-12517 Jerome To Remove this code
                        
                        //START CSM-12443 GGrandea 9/8/2017
                        /*if(request.amount != consumption) {
                            // invalid amountOrConsumption
                            //CSM-10787
                            errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_TOTAL_KWH);
                        }
                            system.debug('here' + request.transactionDate);
                            system.debug('here2' + transactionDate);
                            if(request.transactionDate != transactionDate) {
                                // invalid Date
                                //CSM-10733
                       
                                errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE);
                            }
                        if (request.transactionDate == transactionDate && request.amount == consumption){
                            return new BillWrapper(false);
                        }
                        if(!errorMsgs.isEmpty() && i == 1) {
                            return new BillWrapper(errorMsgs);
                        }*/

                        if(request.amount == consumption && request.transactionDate != transactionDate && errorFlag == false) { //CSM-14782 JIntal 12/06/2017 added the errorFlag condition
                            // invalid Date
                            //CSM-10733
                            errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE);
                            errorFlag = true; //CSM-14782 JIntal 12/06/2017
                            
                        } else if(request.transactionDate == transactionDate && request.amount != consumption) {
                            // invalid amountOrConsumption
                            //CSM-10787
                            errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_TOTAL_KWH);
                        } else if (request.transactionDate == transactionDate && request.amount == consumption){
                            // CSM-14105 Lisen 20171026
                            if(billType == 'Deposit'){
                                errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_EXISTING_BOTH_KWH_AND_BILL_DATE);
                            }else{
                                return new BillWrapper(false);
                            }
                            // CSM-14105 Lisen 20171026
                        }
                        //END CSM-12443 GGrandea 9/8/2017
                    }
                }
            }
            // END CSM-14159 Lisen 20171028
            
            //START CSM-12443 GGrandea 9/8/2017
            if(!errorMsgs.isEmpty()) {
                errors.addAll(errorMsgs);
                return new BillWrapper(errors);
            }
            //END CSM-12443 GGrandea 9/8/2017
        }

        //START CSM-14090 GGrandea 10.25.2017
        /*errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE);
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_TOTAL_KWH);*/
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_EXISTING_BOTH_KWH_AND_BILL_DATE);
        //END CSM-14090

        return new BillWrapper(errorMsgs);
    }
    
    private static BillWrapper validatePayment(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service) {
        // START CSM-13974 Jerome To 10/18/2017
        Set<String> errorMsgs = new Set<String>();
        List<String> errors = new List<String>();
        List<CXE_Heroku_Model.BillDetail> billingDetails = getBillingDetails(request, service.Payor__r.V10_Account_No__c);

        if(!billingDetails.isEmpty()) {
            //iterate the data
            //errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD); // CSM-14038
            // start of  CSM-14038 Corbes Melvin 10/20/2017
            for(Integer i = 0; i < billingDetails.size(); i++) {
                if(billingDetails[i].bill_type != CXE_Constants.HEROKU_BILL_TYPE_TFGEN10006){                    
                    errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD); 
                    errors.addAll(errorMsgs);
                    break;
                }
                
            }
            if(errors.size() > 0){
                return new BillWrapper(errors);
            }
          //end of CSM-14038 Corbes Melvin 10/20/2017
        }

        //Start CSM-12517 Mike Verdad 09.14.2017 - added 'request' parameter
        List<CXE_Heroku_Model.PaymentDetail> paymentDetails = getPaymentDetails(service, 
                                                                                request);

        //List<String> errorMsgs = new List<String>();
     

        
        //End CSM-12517 Mike Verdad 09/15/2017
        
        if(!paymentDetails.isEmpty()) {
            for(Integer i = 0; i < paymentDetails.size(); i++) {
                if(i < 2) {
                    CXE_Heroku_Model.PaymentDetail paymentDetail = paymentDetails.get(i);
                    //decimal amount = Decimal.valueOf(paymentDetail.payment.paid_amount); //CSM-12437 Emandolado 9/5/2017
                    Date transactionDate = Date.valueOf(paymentDetail.paymentDate);
                    
                    // START CSM-13950 Jerome To 10/18/2017 remove this line of codes
                    //Date twoMosAgo = Date.Today().AddMonths(-2);        
                            
                    /* CSM-12517 Mike Verdad 09/15/2017     
                    errorMsgs = new List<String>();
                    */
                    
                    //System.debug('>>>>>>>> Date :' + request.transactionDate);
                    
                    
                    //if(request.transactionDate < twoMosAgo){                            
                    //    errorMsgs.add(CXE_Constants.SERVICE_ENROLLMENT_MUST_BE_LESS_THAN_2_MONTHS_AGO);     
                    //}
                    // END CSM-13950 Jerome To 10/18/2017 remove this line of codes
                    
                    if(request.amount == paymentDetail.paidAmount && request.transactionDate != transactionDate) { //CSM-12437 Emandolado 9/5/2017
                        
                        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_PAYMENT_DATE);
                        
                    } else if(request.transactionDate == transactionDate && request.amount != paymentDetail.paidAmount) { //CSM-12437 Emandolado 9/5/2017
                        
                        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DEPOSIT_AMT);
                        
                    } else if (request.transactionDate == transactionDate && request.amount == paymentDetail.paidAmount){ //CSM-12437 Emandolado 9/5/2017
                        return new BillWrapper(false);
                    }
                    /* Start CSM-12517 Mike Verdad 09/15/2017 
                    if(!errorMsgs.isEmpty() && i == 1) {        
                        return new BillWrapper(errorMsgs);      
                    }
                    * End CSM-12517 Mike Verdad 09/15/2017
                    */  
                }
            }
           // Start CSM-12517 Mike Verdad 09/15/2017 
            if(!errorMsgs.isEmpty()) {
                errors.addAll(errorMsgs);
                return new BillWrapper(errors);
            }
           // End CSM-12517 Mike Verdad 09/15/2017
        }
            
        //START CSM-14090 GGrandea 10.25.2017
        /*errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_PAYMENT_DATE);
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DEPOSIT_AMT);*/
        errorMsgs.add(CXE_Constants.PORTAL_REGISTRATION_ERROR_INVALID_NEW_BOTH_BILLDEPOSIT_AND_PAYMENT_DATE);
        //END CSM-14090
        
        //Start CSM-12517 Mike Verdad 09/15/2017
          //return new BillWrapper(errorMsgs);
        errors.addAll(errorMsgs);
        return new BillWrapper(errors);
        //End CSM-12517 Mike Verdad 09/15/2017
        // END CSM-13974 Jerome To 10/18/2017
    }


    // START CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
    private static List<CXE_Heroku_Model.BillDetail> getBillingDetails(CXE_CP_MyAccountsManageService_CC.Request request, String acctNo) {
        //private static List<CXE_Heroku_Model.BillDetail> getBillingDetails(CXE_CP_SplashPageSelfRegistration_CC.Request request) {
        return CXE_HerokuApps.getAllBillsBySingleSin(request.SIN); // CSM-14105 Lisen 20171026
        //return CXE_HerokuApps.getAllBillsByAcctNoAndSinNo(request.SIN, acctNo);
    }
    // END CSM-13918 Jerome To Unable to enroll in portal if the Contract & Payor is not the same 10/16/2017
    
    //START CSM-12517 Mike Verdad 09.14.2017 - added 'request' parameter
    private static List<CXE_Heroku_Model.PaymentDetail> getPaymentDetails(Agreement__c service, 
                                                                          CXE_CP_MyAccountsManageService_CC.Request request) {
        //START CSM-12592 GGrandea 09.15.2017 // CSM-12603 Jerome To Switch endDate and StartDate
        // START CSM-13950 Jerome To 10/18/2017 remove this line of codes
        //START CSM-12592 GGrandea 09.15.2017
        //Date startDate = Date.today();
        //Date endDate = startDate.addMonths(-2);
        Date endDate = request.transactionDate.addMonths(1);
        Date startDate = request.transactionDate.addMonths(-1);
        // END CSM-13950 Jerome To 10/18/2017 remove this line of codes
        return CXE_HerokuApps.getAllPaymentsBySingleAcctNo(service.Payor__r.V10_Account_No__c, 
                                                                          //request.transactionDate);
                                                                          startDate, endDate);                                                                           
        //END CSM-12592 GGrandea 09.15.2017
    }
    //End CSM-12517 Mike Verdad 09.14.2017 - added 'request' parameter
    
    //End Roden Paolo Songco - Aug 02, 2017


    // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017    

    private static Boolean isRegisteredNameSameAsAccountName(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service) {
       
       List<String> requestName = new List<String>();

        if(String.isNotBlank(request.firstname)) {
            requestName.add(request.firstname);
        } 

        if(String.isNotBlank(request.middlename)) {
            requestName.add(request.middlename);
        } 

        if(String.isNotBlank(request.lastname)) {
            requestName.add(request.lastname);
        } 
       
       return String.join(requestName, ' ').equalsIgnoreCase(service.Payor__r.Account.Name);
    }

    // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017

    // START CSM-13756 Jerome To 10/17/2017 [R2B SQT] Email to Biz RM that a case is created for appropriate action.
    // CSM-10769 Jerome To 08/10/2017
    private static Case populateIROandRO(Agreement__c service, Case caseRecord) {
        // Case__c, Case__r.Initial_Responsible_Office__c, Case__r.Responsible_Office_Lookup__c
        if(service.Case__c != null) {
            caseRecord.Initial_Responsible_Office__c = service.Case__r.Initial_Responsible_Office__c;
            caseRecord.Responsible_Office_Lookup__c = service.Case__r.Responsible_Office_Lookup__c;
        } else {
            List<Address__c> serviceAddressList = [SELECT Address_City_Municipality__r.Name FROM Address__c WHERE Service__c =:service.Id AND Type__c =:CXE_Constants.ADDRESS_TYPE_SERVICE];
            if(!serviceAddressList.isEmpty()) {
                caseRecord.Initial_Responsible_Office__c = getInitialResponsibleOffice(serviceAddressList.get(0).Address_City_Municipality__r.Name);
            }
        }
        return caseRecord;
    }

    private static String getInitialResponsibleOffice(String cityAddress) {
        String responsibleOfficeString = '';
        if(String.isNotBlank(cityAddress)) {
            List<Reference__c> ref = [SELECT Id FROM Reference__c 
                                     WHERE Name =:cityAddress
                                     AND Field__c =:CXE_Constants.REFERENCE_FIELD_CITY];

            if(!ref.isEmpty()) {
                Set<String> responsibleOfficeList = new Set<String>();
                Set<Id> officeIds = new Set<Id>();

                for( Office_Jurisdiction__c oj : [SELECT  Id, Office__r.Name, Office__r.RecordType.Name, 
                                                          Street_Name__c, City__c, Office__c
                                                  FROM    Office_Jurisdiction__c 
                                                  WHERE   City__c =:ref.get(0).Id
                                                  AND     Office__r.RecordType.Name =:CXE_Constants.RECORD_TYPE_NAME_OFFICE_HMB]) {
                    
                    if(!officeIds.contains(oj.Office__c)){
                        responsibleOfficeList.add(oj.Office__r.Name);
                        officeIds.add(oj.Office__c);
                    }
                }

                if(!responsibleOfficeList.isEmpty()) {                    
                    for(String s: responsibleOfficeList){
                        responsibleOfficeString += s+',';
                    }                    
                    responsibleOfficeString = responsibleOfficeString.subString(0, responsibleOfficeString.length() - 1);
                }
            }
        }
        return responsibleOfficeString;
    }
    // CSM-10769 Jerome To 08/10/2017
    // END CSM-13756 Jerome To 10/17/2017 [R2B SQT] Email to Biz RM that a case is created for appropriate action.
    
    // START R2C CSM-13274 Shayne 10/12/2017
    @AuraEnabled
    public static boolean retrieveCheckConglomerate(){
       	System.debug('retrieveCheckConglomerate');
        return CXE_CP_PortalUtility.checkIfConglomerateAccount();
    }
    // END R2C CSM-13274 Shayne 10/12/2017

    // START CSM-14827 Jerome To [R2C Regression] Issues when adding CBG SIN in portal account
    @AuraEnabled
    public static void sendEmailTOCBGRM(CXE_CP_MyAccountsManageService_CC.Request request, Agreement__c service) {
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>([SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName = :CXE_Constants.CBG_RM_EMAIL_TEMPLATE]);
        List<OrgWideEmailAddress> owas = new List<OrgWideEmailAddress>([SELECT id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:CXE_Constants.ORG_WIDE_ADDRESS]);
        if(!emailTemplates.isEmpty() && !owas.isEmpty()) {
            EmailTemplate emailTemplate = emailTemplates.get(0);
            OrgWideEmailAddress owa = owas.get(0);
            List<String> fullname = new List<String>();
            fullname.add(request.firstname);
            fullname.add(request.middlename);
            fullname.add(request.lastname);

            // grab the email template
            String subject = emailTemplate.Subject;
            // process the merge fields
            String htmlBody = emailTemplate.HtmlValue;
            htmlBody = htmlBody.replace('{CustomerName}', String.join(fullname, ' '));
            htmlBody = htmlBody.replace('{SIN}', request.SIN);
            htmlBody = htmlBody.replace('{AccountName}', service.Payor__r.Account.Name);
            htmlBody = htmlBody.replace('{AccountOwner}', service.Payor__r.Account.Owner.Name);

            //build the email message
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();

            email.setOrgWideEmailAddressId(owa.Id);
            email.setToAddresses(new List<String>{ service.Payor__r.Account.Owner.Email } );
            email.setSaveAsActivity(true);
            email.setSubject(subject);
            email.setHtmlBody(htmlBody);

            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
        }
    }
    // END CSM-14827 Jerome To 12/08/2017 - [R2C Regression] Issues when adding CBG SIN in portal account
}