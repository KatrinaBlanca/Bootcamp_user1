/* Description: CXE_CreateService_CMP lightning component controller
 * Author: Michael Lasala
 * Date Created: MAR-08-17
 */
public with sharing class CXE_CreateService_CC {
    
    /* Description: Get Case details from Contract
     * Parameters: Contract Id
     * Returns: Contract
     * Author: Michael Lasala
     * Date Created: MAR-08-17
     */
    @AuraEnabled
    public static Contract getContract(String contractId){
        return [SELECT  ContractNumber, 
                        Case__c, 
                        Case__r.CaseNumber, 
                        Case__r.Multimetering__c, 
                        AccountId, 
                        Account.Name, 
                        Case__r.Pole_Code__c, 
                        Case__r.Service_Wire_Type__c, 
                        Case__r.Service_Wire_Length__c, 
                        Case__r.Wire_Size__c, 
                        Case__r.Material__c, 
                        Case__r.Service_Rate_Type__c, 
                        Case__r.Billing_Class__c, 
                        Case__r.Applied_Load__c, 
                        Case__r.Phase__c, 
                        Case__r.Voltage__c, 
                        Case__r.PSIC__c, 
                        Case__r.PSIC__r.Name, 
                        Case__r.Demand_Factor__c, 
                        Case__r.Load_Factor__c, 
                        Case__r.Contracted_Capacity__c, 
                        Case__r.Service_Supply_Type__c,
                        Case__r.Deposit_Amount__c, // Start/End CSM-1468: Von Pernicia 3/16/17
                        Case__r.TLN__c, //Start CSM-1911: Von Pernicia 3/16/17
                        Case__r.Business_Segment__c, //Start CSM-1911: Von Pernicia 3/16/17
                        Case__r.Status, V10_Account_No__c, //Start CSM-1926: Rom Edison Reyes 3/22/17
                        //START CSM-7145/CSM-7170 RReyes JUN-28-17
                        Case__r.CXE_Discount_Programs__c, // CSM-6395    JEROME TO   MAY-30-17
                        Case__r.CXE_Service_Wire_Phase__c,
                        Case__r.CXE_Service_Wire_Voltage__c,
                        //END CSM-7145/CSM-7170 RReyes JUN-28-17
                        //START CSM-12111 RReyes JUL-30-17
                        Case__r.RecordType.DeveloperName
                        //END CSM-12111 RReyes JUL-30-17
                FROM    Contract 
                WHERE   Id =: contractId LIMIT 1];
    }
    
    /* Description: Get PSIC
     * Parameters: PSIC Id
     * Returns: PSIC__c
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    @AuraEnabled
    public static PSIC__c getPSIC(String psicId){
        return [SELECT  Id, 
                        Name
                FROM    PSIC__c 
                WHERE   Id =: psicId LIMIT 1];
    }
    
    /* Description: Get Picklist Value
     * Parameters: Service Supply Voltage 
     * Returns: Reference__c
     * Author: Von Pernicia
     * Date Created: MAR-16-17
     */
    @AuraEnabled
    public static Reference__c getVoltage(String serviceSupplyVoltage){
        
        Reference__c r = [SELECT Name_Code__c
                          FROM   Reference__c
                          WHERE  Name =: serviceSupplyVoltage AND Field__c =: CXE_Constants.REFERENCE_FIELD_VOLTAGE LIMIT 1];
                         
        
        return [SELECT  Name_Code__c, 
                        Name
                FROM    Reference__c
                WHERE   Name_Code__c =: r.Name_Code__c AND Field__c =: CXE_Constants.REFERENCE_FIELD_VOLTAGE_LEVEL LIMIT 1];
    }
    
    /* Description: Get Account
     * Parameters: Account Id
     * Returns: PSIC__c
     * Author: Von Pernicia
     * Date Created: MAR-15-17
     */
    // Start CSM-1294: Von Pernicia 3/15/17
    @AuraEnabled
    public static Account getAccount(String accountId){
        return [SELECT  Id, 
                        Name
                FROM    Account 
                WHERE   Id =: accountId LIMIT 1];
    } 
    // End CSM-1294: Von Pernicia 3/15/17
    
    /* Description: Insert Service record
     * Parameters: Service (Agreement__c)
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-09-17
     */
    @AuraEnabled
    public static String saveService(Agreement__c service){
        String dmlStatus = '';
        
        //Insert service record
        try {
            insert service;
            dmlStatus = 'Success';
            System.debug('service: '+service);
            //Start CSM-12027 Von Pernicia JUL-27-17: to avoid SOQL 101
            //relateServiceAddressToService(service.Id);//START/END RREYES CSM-1832 MAR-16-17
            relateServiceAddress(service.Id);
            //End CSM-12027 Von Pernicia JUL-27-17: to avoid SOQL 101

        } catch (DMLException error){
            dmlStatus = error.getDmlMessage(0);
            System.debug('insert agreement__c error: '+error.getMessage());
            ErrorHandlerException.recordException(service.Contract__c, true, 'CXE_CreateService_CC', 'saveService', error.getMessage());
        }
        return dmlStatus;
    }

    //Start CSM-12027 Von Pernicia JUL-27-17
    @future
    public static void relateServiceAddress(Id serviceId){
        
      relateServiceAddressToService(serviceId);
    }
    //End CSM-12027 Von Pernicia JUL-27-17

    /* Description: Retrieve all Agreement__c (Service) picklist values
     * Parameters: None
     * Returns: Map<String, List<String>>
     * Author: Michael Lasala
     * Date Created: MAR-09-17
     */
    @AuraEnabled
    public static Map<String, List<String>> getServicePicklistValues(){
        Map<String, List<String>> picklistMap = new Map<String, List<String>>();
        List<String> servicePicklistFields = new List<String>();
        
        //Add picklists fields' API Name for getting of picklist values
        servicePicklistFields.add('Phase__c');
        servicePicklistFields.add('Rate__c');
        servicePicklistFields.add('Segment__c');
        servicePicklistFields.add('Service_Wire_Phase__c');
        servicePicklistFields.add('Service_Wire_Type__c');
        servicePicklistFields.add('Service_Supply_Voltage__c');
        servicePicklistFields.add('Service_Supply_Type__c');
        servicePicklistFields.add('Service_Wire_Size__c');
        servicePicklistFields.add('Service_Wire_Material__c');
        servicePicklistFields.add('Voltage_Level__c');
        servicePicklistFields.add('Service_Status__c');     //Michael Lasala MAR-27-17 CSM-2006
        // Start CSM-12178 Von Pernicia JUL-03-17
        //servicePicklistFields.add('CXE_Discount_Program__c'); // JEROME To MAY-30-17 CSM-6359
        // End CSM-12178 Von Pernicia JUL-03-17
        //START RReyes CSM-7283 JUL-06-17
        servicePicklistFields.add('Service_Supply_Phase__c');
        servicePicklistFields.add('Service_Wire_Voltage__c');
        //END RReyes CSM-7283 JUL-06-17
        Schema.sObjectType sobject_type = Agreement__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        
        //Iterate over each picklist field and map picklist values per field
        for(String s: servicePicklistFields){
            List<String> tempList = new List<String>();
            tempList.add('--None--');   //Add default value

            List<Schema.PicklistEntry> pick_list_values = field_map.get(s).getDescribe().getPickListValues();

            for(Schema.PicklistEntry a : pick_list_values){
                tempList.add(a.getValue());
            }
            picklistMap.put(s, tempList);
        }
        System.debug('picklistMap: '+picklistMap);
        return picklistMap;
    }
  
  /* Description: Validate if contract's related case has values populated
     * Parameters: contract record
     * Returns: string
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    @AuraEnabled
    public static string validateRequiredCaseValues(Contract contractRec){
        String errMsg = '';
    Integer errCount = 0;
    System.debug('contractRec: ' + contractRec);
    if(contractRec != null){
    
    if(contractRec.Case__r.Pole_Code__c == null || contractRec.Case__r.Pole_Code__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_POLE_CODE;
      errCount++;
      
    }
    if(contractRec.Case__r.Service_Wire_Type__c == null || contractRec.Case__r.Service_Wire_Type__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_SERVICE_WIRE_TYPE;
      errCount++;
      
    }  
    if(contractRec.Case__r.Service_Wire_Length__c == null){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_SERVICE_WIRE_LENGTH;
      errCount++;
      
    }  
    if(contractRec.Case__r.Wire_Size__c == null || contractRec.Case__r.Wire_Size__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_WIRE_SIZE;
      errCount++;
      
    }  
    if(contractRec.Case__r.Material__c == null || contractRec.Case__r.Material__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_MATERIAL;
      errCount++;
    }  
    if(contractRec.Case__r.Service_Rate_Type__c == null || contractRec.Case__r.Service_Rate_Type__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_SERVICE_RATE_TYPE;
      errCount++;
    }  
    if(contractRec.Case__r.Billing_Class__c == null || contractRec.Case__r.Billing_Class__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_BILLING_CLASS;
      errCount++;  
    }  
    if(contractRec.Case__r.Applied_Load__c == null){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_APPLIED_LOAD;
      errCount++;
    }
    if(contractRec.Case__r.Phase__c == null || contractRec.Case__r.Phase__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_PHASE;
      errCount++;
      
    }  
    if(contractRec.Case__r.Voltage__c == null || contractRec.Case__r.Voltage__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_VOLTAGE;
      errCount++;
      
    }  
    if(contractRec.Case__r.PSIC__c == null){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_PSIC;
      errCount++;
      
    }if(contractRec.Case__r.Demand_Factor__c == null){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_DEMAND_FACTOR;
      errCount++;
      
    }  
    if(contractRec.Case__r.Load_Factor__c == null){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_LOAD_FACTOR;
      errCount++;
      
    }  
    if(contractRec.Case__r.Contracted_Capacity__c == null){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_CONTRACTED_CAPACITY;
      errCount++;
      
    }  
    if(contractRec.Case__r.Service_Supply_Type__c == null || contractRec.Case__r.Service_Supply_Type__c == ''){
      if(errCount > 0){ errMsg += ', ';}
      errMsg += CXE_Constants.CASE_SERVICE_SUPPLY_TYPE;
      errCount++;
      
    }  
    

    if(errCount > 0){
      errMsg = 'The following fields are required on the related case of the contract: ' + errMsg + '.';
    }
  
    }
    System.debug('errormessage: ' + errMsg);
        return errMsg;
    }
  
  /* Description: Validate if contract has billing address
     * Parameters: contract Id
     * Returns: boolean
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    @AuraEnabled
    public static boolean validateIfContractHasBillingAddress(String contractId){
        Boolean isValid = false;
        List<Address__c> billAdd = [SELECT  Id FROM Address__c WHERE Contract__r.Id =: contractId AND Type__c = 'Billing' LIMIT 1];
        if(billAdd.size() > 0){
            isValid = true;
        }
        return isValid;
    }
    
    /* Description: Validate if account has service address
     * Parameters: Account Id
     * Returns: boolean
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    @AuraEnabled
    public static boolean validateIfAccountHasServiceAddress(String acctId){
        Boolean isValid = false;
        List<Address__c> servAdd = [SELECT  Id FROM Address__c WHERE Account__r.Id =: acctId AND Type__c = 'Service' LIMIT 1];
        if(servAdd.size() > 0){
            isValid = true;
        }
        return isValid;
    }

    //START CSM-12318 RReyes AUG-23-17 - check if case has a related service address
    /* Description: Validate if contract's case has service address
     * Parameters: Case Id
     * Returns: boolean
     * Author: Rom Edison Reyes
     * Date Created: AUG-23-17
     */
    @AuraEnabled
    public static boolean validateIfCaseHasServiceAddress(String caseId){
        Boolean isValid = false;
        List<Address__c> servAdd = [SELECT Id FROM Address__c WHERE Case__r.Id =: caseId AND Type__c = 'Service' LIMIT 1];
        if(servAdd.size() > 0){
            isValid = true;
        }
        return isValid;
    }
    //END CSM-12318 RReyes AUG-23-17 - check if case has a related service address

    /* Description: Map Service Address to Service
     * Parameters: serviceId
     * Returns: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */

    public static void relateServiceAddressToService(String serviceId){
       List<Agreement__c> servList = [SELECT Id, Contract__r.Id, Contract__r.AccountId, Contract__r.Case__r.Multimetering__c, Contract__r.Case__r.Id FROM Agreement__c WHERE Id=: serviceId LIMIT 1];
       if(servList.size() > 0){
           if(servList[0].Contract__r.Case__r.Multimetering__c){
               //multi-meter
                //START RReyes CSM-2059 MAR-31-17 - changed WHERE clause to compare contract instead of account
                //START RReyes CSM-2066 APR-06-17 - changed WHERE clause to compare contract's case instead of contract
               List<Agreement__c> serviceList = [SELECT Id, Contract__r.AccountId FROM Agreement__c WHERE Contract__r.Case__r.Id =: servList[0].Contract__r.Case__r.Id];
                //END RReyes CSM-2066 APR-06-17 - changed WHERE clause to compare contract's case instead of contract
                //END RReyes CSM-2059 MAR-31-17 - changed WHERE clause to compare contract instead of account
               if(serviceList.size() == 1 ){

                    //Michael Lasala MAR-27-17 CSM-2007 Added multimetering parameter
                    //START/END CSM-2000 RReyes MAR-27-17 - added caseId parameter
                    //START/END CSM-2059 RReyes MAR-31-17 - changed second parameter to reference on servList instead of serviceList
                    updateAddressService(serviceId, servList[0].Contract__r.AccountId, servList[0].Contract__r.Case__r.Multimetering__c, servList[0].Contract__r.Case__r.Id); //START/END CSM-2000 RReyes MAR-27-17 - added caseId parameter
               }   
           }else{
                //single meter
                //Michael Lasala MAR-27-17 CSM-2007 Added multimetering parameter
                //START/END CSM-2000 RReyes MAR-27-17 - added caseId parameter
                updateAddressService(serviceId, servList[0].Contract__r.AccountId, servList[0].Contract__r.Case__r.Multimetering__c, servList[0].Contract__r.Case__r.Id);//START/END CSM-2000 RReyes MAR-27-17 - added caseId parameter
           }
       } 
    }
    
    /* Description: Update Address
     * Parameters: serviceId, accountId, multimeter
     * Returns: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */

    //START CSM-2000 RReyes MAR-27-17 - added caseId parameter, limit addresses to update to those related to service contract's case only 
    public static void updateAddressService(String serviceId, String accountId, Boolean isMultimeter, String caseId){    
        List<Address__c> addressList = new List<Address__c>();
        
        //BEGIN Michael Lasala MAR-27-17 CSM-2007
        List<Agreement__c> serviceList = new List<Agreement__c>();
        Set<Id> serviceIds = new Set<Id>();//START/END CSM - 7329 RReyes

        for(Address__c addr: [SELECT Id, Service__c, Premise_Type__c
                              FROM Address__c 
                              //Rhyan Cruz CSM 7067 removed checking of account id in address
                              WHERE Case__r.Id=: caseId AND Type__c = 'Service']){
//                              WHERE Account__r.Id =: accountId AND Case__r.Id=: caseId AND Type__c = 'Service']){

            addr.Service__c = serviceId;
            addressList.add(addr);
            //START CSM-7329 RReyes JUL-09-17
            if(!isMultimeter && !serviceIds.contains(serviceId)){
                Agreement__c service = new Agreement__c(Id = serviceId, 
                                                        Premises_Type__c = addr.Premise_Type__c);
                serviceList.add(service);
                serviceIds.add(serviceId);
            }
            //END CSM-7329 RReyes JUL-09-17
            //END Michael Lasala MAR-27-17
        }
        
        try{
            if(!addressList.isEmpty()){
                update addressList;
            }
        } catch (DMLException error){
            System.debug('update contract error: '+error.getMessage());
            ErrorHandlerException.recordException(addressList[0].Id, true, 'CXE_CreateContract_CC', 'relateBillingAddressToContract', error.getMessage());
        }

        try{
            if(!isMultimeter && 
               !serviceList.isEmpty()){  //Michael Lasala MAR-28-17 CSM-2038
                update serviceList;
            }
        } catch (DMLException error){
            System.debug('update service error: '+error.getMessage());
            ErrorHandlerException.recordException(serviceId, true, 'CXE_CreateContract_CC', 'relateBillingAddressToContract', error.getMessage());
        }
    } 
    
    /* Description: Check if contract is Valid to create service
     * Parameters: contract Id, case Status, isMultimeter
     * Returns: string
     * Author: Rom Edison Reyes
     * Date Created: MAR-22-17
     * CSM 1926
     */
    @AuraEnabled
    public static string isValidToCreateService(String contractId, String caseStatus, Boolean isMultiMeter, String v10AccNum){
        String errMsg = '';
        if((!isMultiMeter && (CXE_Constants.VALID_CASE_STATUS_INITIAL.contains(caseStatus) || CXE_Constants.VALID_CASE_STATUS_ADDTL_SINGLE.contains(caseStatus))) || 
            (isMultiMeter && (CXE_Constants.VALID_CASE_STATUS_INITIAL.contains(caseStatus) || CXE_Constants.VALID_CASE_STATUS_SUCCEEDING_MULTI.contains(caseStatus)))  
        ){
            Integer serviceCount = [SELECT COUNT() FROM Agreement__c WHERE Contract__c =:contractId LIMIT 1];
            if(!isMultiMeter && serviceCount > 0){
                //single-meter and contract already has a service
                errMsg = CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_SINGLE_METERED_VALIDATION;
            }else if(isMultiMeter && serviceCount > 0){
                if(!CXE_Constants.VALID_CASE_STATUS_SUCCEEDING_MULTI.contains(caseStatus)){
                    //multi-meter and case status is not 'Contract Finalized', 'Application Ready for Connection' OR 'Pending Energization'     
                    errMsg = CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_MULTI_METERED_VALIDATION;
                }else if(v10AccNum == '' || v10AccNum == null){
                    errMsg = CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_CONTRACT_WITHOUT_V10;
                }
            }
        }else{
            errMsg = CXE_Constants.CREATE_SERVICE_ERROR_MESSAGE_INVALID_CASE_STATUS;
        }
        return errMsg;
    }
}