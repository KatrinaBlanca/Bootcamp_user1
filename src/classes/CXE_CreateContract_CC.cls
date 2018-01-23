/* Description: CXE_CreateContract_CMP lightning component controller
 * Author: Michael Lasala
 * Date Created: MAR-10-17
 */
 public with sharing class CXE_CreateContract_CC {

    /* Description: Get Case details
     * Parameters: Case Id
     * Returns: Case
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    @AuraEnabled
    public static Case getCase(String caseId){
        return [SELECT  Id, 
                        CaseNumber, 
                        Multimetering__c, 
                        AccountId, 
                        Account.Name,
                        Legacy_Account_Number__c, //CSM-11942 AUG-26-17 GGrandea
                        //START CSM-7191 RReyes JUN-28-17
                        Status,
                        RecordType.DeveloperName,
                        CXE_Service_Request_s__c
                        //END CSM-7191 RReyes JUN-28-17
                FROM    Case 
                WHERE   Id =: caseId LIMIT 1];
    }

    /* Description: Retrieve User Full Name
     * Parameters: None
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    @AuraEnabled
    public static String getUser(){
        String userName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
        return userName;
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
     
    /* Description: Insert Contract record
     * Parameters: Contract
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    @AuraEnabled
    public static String saveContract(Contract contractRecord){
        String dmlStatus = '';
        contractRecord.OwnerId = UserInfo.getUserId();
        
        //Insert service record
        try {
            insert contractRecord;
            dmlStatus = 'Success';
            System.debug('contract: '+contractRecord);
            relateBillingAddressToContract(contractRecord.Id);//START/END RREYES CSM-1832 MAR-16-17

        } catch (DMLException error){
            dmlStatus = error.getDmlMessage(0);
            System.debug('insert contract error: '+error.getMessage());
            ErrorHandlerException.recordException(contractRecord.Case__c, true, 'CXE_CreateContract_CC', 'saveContract', error.getMessage());
        }
        return dmlStatus;
    }

    /* Description: Retrieve all Contract picklist values
     * Parameters: None
     * Returns: Map<String, List<String>>
     * Author: Michael Lasala
     * Date Created: MAR-10-17
     */
    @AuraEnabled
    public static Map<String, List<String>> getContractPicklistValues(){
        Map<String, List<String>> picklistMap = new Map<String, List<String>>();
        List<String> contractPicklistFields = new List<String>();
        
        //Add picklists fields' API Name for getting of picklist values
        contractPicklistFields.add('Status');
        contractPicklistFields.add('Type__c');
        contractPicklistFields.add('Method_of_Payment__c');

        Schema.sObjectType sobject_type = Contract.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

        //START CSM-14144 10.27.2017
        Map<String, List<Schema.PicklistEntry>> pickListEntryMap = new Map<String, List<Schema.PicklistEntry>>();
        pickListEntryMap.put('Status', field_map.get('Status').getDescribe().getPickListValues() );
        pickListEntryMap.put('Type__c', field_map.get('Type__c').getDescribe().getPickListValues() );
        pickListEntryMap.put('Method_of_Payment__c', field_map.get('Method_of_Payment__c').getDescribe().getPickListValues() );
        //END CSM-14144
        
        //Iterate over each picklist field and map picklist values per field
        for(String s: contractPicklistFields){
            List<String> tempList = new List<String>();
            tempList.add('--None--');   //Add default value

            //START CSM-14144 10.27.2017
            //List<Schema.PicklistEntry> pick_list_values = field_map.get(s).getDescribe().getPickListValues();
            List<Schema.PicklistEntry> pick_list_values = pickListEntryMap.get(s);
            //END CSM-14144

            for(Schema.PicklistEntry a : pick_list_values){
                tempList.add(a.getValue());
            }
            picklistMap.put(s, tempList);
        }
        System.debug('picklistMap: '+picklistMap);
        return picklistMap;
    }
    
     /* Description: Validate if account has billing address
     * Parameters: Account Id
     * Returns: boolean
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    @AuraEnabled
    public static boolean validateIfAccountHasBillingAddress(String acctId){
        Boolean isValid = false;
        List<Address__c> billAdd = [SELECT  Id FROM Address__c WHERE Account__r.Id =: acctId AND Type__c = 'Billing' LIMIT 1];
        if(billAdd.size() > 0){
            isValid = true;
        }
        return isValid;
    }
  
     /* Description: Validate if case has billing address
     * Parameters: Case Id
     * Returns: boolean
     * Author: Rom Edison Reyes
     * Date Created: MAR-17-17
     */
    @AuraEnabled
    public static boolean validateIfCaseHasBillingAddress(String caseId){
        Boolean isValid = false;
        List<Address__c> billAdd = [SELECT  Id FROM Address__c WHERE Case__r.Id =: caseId AND Type__c = 'Billing' LIMIT 1];
        if(billAdd.size() > 0){
            isValid = true;
        }
        return isValid;
    }
    
    /* Description: Map Billing Address to Contract
     * Parameters: contractId
     * Returns: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    public static void relateBillingAddressToContract(String contractId){
       List<Contract> contList = [SELECT Id, AccountId, Case__r.Id, Case__r.AccountId, Case__r.Multimetering__c FROM Contract WHERE Id=: contractId LIMIT 1];
       if(contList.size() > 0){
           if(contList[0].Case__r.Multimetering__c){
               //multi-meter
               //START RReyes CSM-2059 MAR-31-17 - changed WHERE clause to compare case instead of account
               List<Contract> contractList = [SELECT Id, Case__r.AccountId FROM Contract WHERE Case__r.Id =: contList[0].Case__r.Id];
               //END RReyes CSM-2059 MAR-31-17 - changed WHERE clause to compare case instead of account
               if(contractList.size() == 1 ){
                   //START/END RReyes CSM-2059 MAR-31-17 - changed second parameter to reference on contList instead of contractList
                   updateAddressContract(contractId, contList[0].Case__r.AccountId, contList[0].Case__r.Id); //START/END CSM-2000 RReyes MAR-27-17 - added caseId parameter
               }   
           }else{
               //single meter
                updateAddressContract(contractId, contList[0].Case__r.AccountId, contList[0].Case__r.Id); //START/END CSM-2000 RReyes MAR-27-17 - added caseId parameter       
           }
       }
       
    }
    
    /* Description: Update Address
     * Parameters: contractId
     * Returns: None
     * Author: Rom Edison Reyes
     * Date Created: MAR-16-17
     */
    //START CSM-2000 RReyes MAR-27-17 - added caseId parameter, limit addresses to update to those related to contract's case only   
    public static void updateAddressContract(String contractId, String accountId, String caseId){ 
        List<Address__c> addressList = new List<Address__c>();
        for(Address__c addr: [SELECT Id, Contract__c 
                                FROM Address__c 
                                WHERE Case__r.Id =: caseId AND Type__c = 'Billing']){ // Rhyan Cruz CSM 7067
    //                            WHERE Account__r.Id =: accountId AND Case__r.Id =: caseId AND Type__c = 'Billing']){
            addr.Contract__c = contractId;
            addressList.add(addr);
        }
    //END CSM-2000 RReyes MAR-27-17 - added caseId parameter, limit addresses to update to those related to contract's case only      
        try{
            if(!addressList.isEmpty()){
                update addressList;
            }
        } catch (DMLException error){
            System.debug('update contract error: '+error.getMessage());
            ErrorHandlerException.recordException(addressList[0].Id, true, 'CXE_CreateContract_CC', 'relateBillingAddressToContract', error.getMessage());
        }               
    }

    /* Description: Check if case is Valid to create contract
     * Parameters: Case Id, case Status, isMultimeter
     * Returns: Case
     * Author: Jerome To, Rom Edison Reyes
     * Date Created: MAR-22-17
     * CSM 1926
     */
    @AuraEnabled
    public static string isValidToCreateContract(String caseId, String caseStatus, Boolean isMultiMeter){
        String errMsg = '';
        if((!isMultiMeter && (CXE_Constants.VALID_CASE_STATUS_INITIAL.contains(caseStatus) || CXE_Constants.VALID_CASE_STATUS_ADDTL_SINGLE.contains(caseStatus))) || 
            (isMultiMeter && (CXE_Constants.VALID_CASE_STATUS_INITIAL.contains(caseStatus) || CXE_Constants.VALID_CASE_STATUS_SUCCEEDING_MULTI.contains(caseStatus)))  
        ){
            Integer contractCount = [SELECT COUNT() FROM Contract WHERE Case__c =:caseId];
            if(!isMultiMeter && contractCount > 0){
                //single-meter and case already has a contract
                errMsg = CXE_Constants.CREATE_CONTRACT_ERROR_MESSAGE_SINGLE_METERED_VALIDATION;
            }else if(isMultiMeter && contractCount > 0 && !CXE_Constants.VALID_CASE_STATUS_SUCCEEDING_MULTI.contains(caseStatus)){
                //multi-meter and case status is not 'Contract Finalized', 'Application Ready for Connection' OR 'Pending Energization'     
                errMsg = CXE_Constants.CREATE_CONTRACT_ERROR_MESSAGE_MULTI_METERED_VALIDATION;
            }
        }else{
            errMsg = CXE_Constants.CREATE_CONTRACT_ERROR_MESSAGE_INVALID_CASE_STATUS;
        }
        return errMsg;
    }
}