/* Description: CXE_BillDepositSimulator_CMP lightning component controller
 * Author: Michael Lasala
 * Date Created: MAR-13-17
 */
 public with sharing class CXE_BillDepositSimulator_CC {
    
    static final Map<String, Id> caseRecordTypes;
    static {
        caseRecordTypes = new Map<String, Id>();
        for(RecordType recType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Case' AND IsActive = true]){
            caseRecordTypes.put(recType.DeveloperName, recType.Id);
        }
    }

    /* Description: Validate case and address
     * Parameters: Case Id
     * Returns: Map<String, String>
     * Author: Michael Lasala
     * Date Created: MAR-13-17
     */
    @AuraEnabled
    public static Map<String, String> validateBillDeposit(String caseId){
        Map<String, String> simulateStatus = new Map<String, String>();
        Set<Id> recordTypeFilters = new Set<Id> { caseRecordTypes.get(CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE)};
        //Retrieve case
        List<Case> caseList = [SELECT   Id, 
                                        Service_Rate_Type__c, 
                                        Applied_Load__c,
                                        Demand_Factor__c,
                                        Contracted_Capacity__c,
                                        Load_Factor__c,
                                        RecordTypeId
                               FROM     Case 
                               WHERE    Id =: caseId LIMIT 1];

        if(!caseList.isEmpty()){
            if (CXE_BillDepositUtility.getRate() == null) {
                simulateStatus.put(CXE_Constants.STATUS_ERROR, CXE_Constants.BILL_DEPOSIT_SIMULATOR_CASE_MISSING_RATE);   
            }
            
            Case caseRecord = caseList.get(0);

            //Validate case required fields
            if(String.isBlank(caseRecord.Service_Rate_Type__c) || 
               caseRecord.Applied_Load__c == null){

                //Case required fields error message
                simulateStatus.put(CXE_Constants.STATUS_ERROR, CXE_Constants.BILL_DEPOSIT_SIMULATOR_CASE_REQUIRED_FIELDS_ERROR);

            } else if(caseRecord.Demand_Factor__c == null || caseRecord.Contracted_Capacity__c == null || caseRecord.Load_Factor__c == null){
                simulateStatus.put(CXE_Constants.STATUS_ERROR, CXE_Constants.BILL_DEPOSIT_SIMULATOR_CASE_REQUIRED_FIELDS_ERROR2); // CSM-166 JEROME TO MAY-15-17
            }

            else if (!recordTypeFilters.contains(caseRecord.RecordTypeId)) {
                //Retrieve case service address
                List<Address__c> addressList = [SELECT  Id 
                                                FROM    Address__c 
                                                WHERE   Case__c =: caseRecord.Id 
                                                AND     Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE];
                if(addressList.isEmpty()){

                    //Address required error message
                    simulateStatus.put(CXE_Constants.STATUS_ERROR, CXE_Constants.BILL_DEPOSIT_SIMULATOR_ADDRESS_REQUIRED_ERROR);
                }
            }
        }
        return simulateStatus;
    }

 	/* Description: Update bill deposit amount
     * Parameters: Case Id
     * Returns: Map<String, String>
     * Author: Michael Lasala
     * Date Created: MAR-13-17
     */
    @AuraEnabled
    public static Map<String, String> simulateBillDeposit(String caseId){

    	Map<String, String> simulateStatus = new Map<String, String>();

    	//Retrieve case
    	List<Case> caseList = [SELECT 	Id, 
    									Service_Rate_Type__c, 
    									Applied_Load__c
    				  		   FROM 	Case 
    				  		   WHERE    Id =: caseId LIMIT 1];

    	if(!caseList.isEmpty()){

    		Case caseRecord = caseList.get(0);

            //Set calculation variables
            Map<Id, CXE_BillDepositWrapper> calculationVariables = CXE_BillDepositUtility.getCalculationVariables(new Set<Id>{caseId});
            CXE_BillDepositWrapper billDeposit = calculationVariables.get(caseId);

            //Get rate for current month and year
            Rate__c rate = CXE_BillDepositUtility.getRate();

            //Get LFT and TRAC rates for city/municipality
            Map<String, LFT_TRAC_Table__c> lftTRACMap = CXE_BillDepositUtility.getLFTTRAC(new Set<String>{billDeposit.municipality});
            LFT_TRAC_Table__c lftTRAC = lftTRACMap.get(billDeposit.municipality);
            System.debug('lftTRAC: '+lftTRAC);

            //Calculate
            //billDeposit = CXE_BillDepositUtility.calculateRate(billDeposit, rate, lftTRAC);
            billDeposit = CXE_BillDepositUtility.calculateRate(billDeposit, rate, lftTRAC);

            //Override deposit amount
            //caseRecord.Override_Auto_Deposit_Amount__c = true; // // Start/End CSM-12246 Von Pernicia
            // Start CSM-12101 Von Pernicia
			      //caseRecord.Deposit_Amount__c = billDeposit.totalCurrentAmount;
            caseRecord.Deposit_Amount__c = billDeposit.roundedTotalAmount.setscale(2);
            // End CSM-12101 Von Pernicia
			
			//START CSM-12251 RReyes AUG-11-17
            // Start CSM-12217 Von Pernicia
            caseRecord.CXE_isClickBillDepositButton__c = false;
            // End CSM-12217 Von Pernicia
            //END CSM-12251 RReyes AUG-11-17

			//Update case
			try {
              CaseTriggerHandler.isClickUpdateBD = true; // Start/End CSM-12246 Von Pernicia
	            update caseRecord;
	    		System.debug('case: '+caseRecord);

	            //Deposit amount value
				simulateStatus.put(CXE_Constants.STATUS_SUCCESS, 'Bill Deposit Estimate: '+caseRecord.Deposit_Amount__c);

	        } catch (DMLException error){
				simulateStatus.put(CXE_Constants.STATUS_ERROR, error.getDmlMessage(0));
	            System.debug('update case error: '+error.getMessage());
	            ErrorHandlerException.recordException(caseId, true, 'CXE_BillDepositSimulator_CC', 'simulateBillDeposit', error.getMessage());
	        }
    	}
		System.debug('simulateStatus: '+simulateStatus);
    	return simulateStatus;
    }

    /* Description: Calculate bill deposit
     * Parameters: CXE_BillDepositWrapper
     * Returns: CXE_BillDepositWrapper
     * Author: Michael Lasala
     * Date Created: MAR-16-17
     */
    @AuraEnabled
    public static CXE_BillDepositWrapper calculateBillDeposit(String caseId, 
                                                              Boolean isUpdate, 
                                                              String localFranchiseTax, 
                                                              String lifelineDiscount, 
                                                              String lifelineSubsidy, 
                                                              String scSubsidy, 
                                                              String energyTax, 
                                                              String zeroRated){
                                                              //String specialDiscount, 
                                                              //String scid, 
                                                              //String schd){
        //Set calculation variables
        Map<Id, CXE_BillDepositWrapper> calculationVariables = CXE_BillDepositUtility.getCalculationVariables(new Set<Id>{caseId});
        CXE_BillDepositWrapper billDeposit = calculationVariables.get(caseId);

        if(isUpdate){
            billDeposit.isLocalFranchiseTax = localFranchiseTax;
            billDeposit.isLifelineDiscount = lifelineDiscount;
            billDeposit.isLifeLineSubsidy = lifelineSubsidy;
            billDeposit.isSCSubsidy = scSubsidy;
            billDeposit.isEnergyTax = energyTax;
            billDeposit.isZeroRated = zeroRated;
            //billDeposit.isSpecialDiscount = specialDiscount;
            //billDeposit.isSCID = scid;
            //billDeposit.isSCHD = schd;
        }

        //Get rate for current month and year
        Rate__c rate = CXE_BillDepositUtility.getRate();

        //Get LFT and TRAC rates for city/municipality
        Map<String, LFT_TRAC_Table__c> lftTRACMap = CXE_BillDepositUtility.getLFTTRAC(new Set<String>{billDeposit.municipality});
        LFT_TRAC_Table__c lftTRAC = lftTRACMap.get(billDeposit.municipality);
        System.debug('lftTRAC: '+lftTRAC);

        //Calculate
        billDeposit = CXE_BillDepositUtility.calculateRate(billDeposit, rate, lftTRAC);
        
        return billDeposit;
    }

    /* Description: Calculate bill deposit
     * Parameters: CXE_BillDepositWrapper
     * Returns: CXE_BillDepositWrapper
     * Author: Jerome To
     * Date Created: MAY-19-17
     */
    @AuraEnabled
    public static CXE_BillDepositWrapper reCalculateBillDeposit(String billDepositJSON){
                                                              //String specialDiscount, 
                                                              //String scid, 
                                                              //String schd){

        //Get rate for current month and year
        CXE_BillDepositWrapper updateBillDeposit = (CXE_BillDepositWrapper)System.JSON.deserialize(billDepositJSON, CXE_BillDepositWrapper.class);

        CXE_BillDepositWrapper billDeposit = new CXE_BillDepositWrapper();
        billDeposit.demandFactor = updateBillDeposit.demandFactor;
        billDeposit.loadFactor = updateBillDeposit.loadFactor;
        billDeposit.contractedCapacity = updateBillDeposit.contractedCapacity;
        billDeposit.appliedLoad = updateBillDeposit.appliedLoad;
        billDeposit.rate = updateBillDeposit.rate;     
        billDeposit.municipality = updateBillDeposit.municipality;
        billDeposit.province = updateBillDeposit.province;
        billDeposit.voltageLevel = updateBillDeposit.voltageLevel;
       
        billDeposit.isLocalFranchiseTax = updateBillDeposit.isLocalFranchiseTax;
        billDeposit.isLifelineDiscount = updateBillDeposit.isLifelineDiscount;
        billDeposit.isLifeLineSubsidy = updateBillDeposit.isLifeLineSubsidy;
        billDeposit.isSCSubsidy = updateBillDeposit.isSCSubsidy;
        billDeposit.isEnergyTax = updateBillDeposit.isEnergyTax;
        billDeposit.isZeroRated = updateBillDeposit.isZeroRated;

        Rate__c rate = CXE_BillDepositUtility.getRate();

        //Get LFT and TRAC rates for city/municipality
        Map<String, LFT_TRAC_Table__c> lftTRACMap = CXE_BillDepositUtility.getLFTTRAC(new Set<String>{billDeposit.municipality});
        LFT_TRAC_Table__c lftTRAC = lftTRACMap.get(billDeposit.municipality);
        System.debug('lftTRAC: '+lftTRAC);

        //Calculate
        return CXE_BillDepositUtility.calculateRate(billDeposit, rate, lftTRAC);
    }

    /* Description: Calculate bill deposit
     * Parameters: CXE_BillDepositWrapper
     * Returns: CXE_BillDepositWrapper
     * Author: Jerome To
     * Date Created: MAY-19-17
     */
    @AuraEnabled
    public static List<String> getServiceRateTypes() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Case.Service_Rate_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
}