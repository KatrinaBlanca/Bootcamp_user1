/* Description: Utility class for bill deposit computations
 * Author: Michael Lasala
 * Date Created: MAR-14-17
 */
 public with sharing class CXE_BillDepositUtility {

    /* Description: Get case and address details for calculation variables
     * Parameters: Set<Id>
     * Returns: Map<Id, CXE_BillDepositWrapper>
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     * Updated : CSM-166 MAY-12-17  Jerome To   added kwHConsumption and kwDemand
     * Updated : CSM-166 MAY-15-17  Jerome To   added Voltage__c
     */
    public static Map<Id, CXE_BillDepositWrapper> getCalculationVariables(Set<Id> caseIds){

        //Retrieve case details
        Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, 
                                                          Service_Rate_Type__c, 
                                                          Applied_Load__c,
                                                          Contracted_Capacity__c,
                                                          Voltage__c,
                                                          Load_Factor__c,
                                                          Demand_Factor__c
                                                   FROM   Case 
                                                   WHERE  Id IN: caseIds]);
        System.debug('caseMap: '+caseMap);

        Map<Id, Address__c> addressMap = new Map<Id, Address__c>();

        //Retrieve service address
        for(Address__c address: [SELECT     Id, 
                                            Case__c, 
                                            Address_City_Municipality__r.Name, 
                                            Address_Province__r.Name
                                 FROM       Address__c 
                                 WHERE      Case__c IN: caseIds 
                                 AND        Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE]){

            addressMap.put(address.Case__c, address);
        }
        System.debug('addressMap: '+addressMap);

        Map<Id, CXE_BillDepositWrapper> variableMap = new Map<Id, CXE_BillDepositWrapper>();

        // START CSM-166 JEROME TO MAY-15-17
        Map<String, String> voltageLevelMap = getVoltageLevelMap();
        // END CSM-166 JEROME TO MAY-15-17

        if(!caseMap.keySet().isEmpty()){
            for(Id i: caseMap.keySet()){
                
                //Assign wrapper values based on case, service address and default values
                //CXE_BillDepositWrapper billDeposit = new CXE_BillDepositWrapper();
                //billDeposit.appliedLoad = caseMap.get(i).Applied_Load__c;
                //billDeposit.rate = caseMap.get(i).Service_Rate_Type__c;
                //billDeposit.equivalentMonthlyConsumption = caseMap.get(i).Applied_Load__c * 90;
                //billDeposit.municipality = addressMap.get(i).Address_City_Municipality__r.Name;
                //billDeposit.province = addressMap.get(i).Address_Province__r.Name;

                // START CSM-166 Added by Jerome To MAY-12-17 
                CXE_BillDepositWrapper billDeposit = new CXE_BillDepositWrapper();
                billDeposit.demandFactor = caseMap.get(i).Demand_Factor__c;
                billDeposit.loadFactor = caseMap.get(i).Load_Factor__c;
                billDeposit.contractedCapacity = caseMap.get(i).Contracted_Capacity__c;
                billDeposit.appliedLoad = caseMap.get(i).Applied_Load__c;
                billDeposit.rate = caseMap.get(i).Service_Rate_Type__c;                
                billDeposit.municipality = (!addressMap.isEmpty() ? addressMap.get(i).Address_City_Municipality__r.Name : '');
                billDeposit.province = (!addressMap.isEmpty() ? addressMap.get(i).Address_Province__r.Name : '');
                billDeposit.voltageLevel = voltageLevelMap.get(caseMap.get(i).Voltage__c);
                // END CSM-166 Added by Jerome To MAY-12-17

                
                billDeposit.isLocalFranchiseTax = CXE_Constants.OPTION_NO;
                billDeposit.isLifelineDiscount = CXE_Constants.OPTION_NO;
                billDeposit.isLifeLineSubsidy = CXE_Constants.OPTION_YES;
                billDeposit.isSCSubsidy = CXE_Constants.OPTION_YES;     //billDeposit.equivalentMonthlyConsumption > 100 ? true : false;
                billDeposit.isEnergyTax = CXE_Constants.OPTION_NO;
                billDeposit.isZeroRated = CXE_Constants.OPTION_NO;
                //billDeposit.isSpecialDiscount = CXE_Constants.OPTION_NO;
                //billDeposit.isSCID = CXE_Constants.OPTION_NO;
                //billDeposit.isSCHD = CXE_Constants.OPTION_NO;

                variableMap.put(i, billDeposit);
            }
        }
        System.debug('variableMap: '+variableMap);
        return variableMap;
    }

    /* Description: Get rates for calculation
     * Parameters: None
     * Returns: Rate__c
     * Author: Michael Lasala
     * Date Created: MAR-14-17
     */
    public static Rate__c getRate(){

        //Get current month and year
        Date currentDate = Date.today();
        Decimal currentMonth = Decimal.valueOf(currentDate.month());
        String currentYear = String.valueOf(currentDate.year());

        //Build query string
        String queryString = 'SELECT ';
        
        //Get all Rate__c fields
        Map<String, Schema.SObjectField> rateFields = Schema.getGlobalDescribe().get('Rate__c').getDescribe().fields.getMap();

        //Add each field to query string
        for(String s : rateFields.keySet()){
            queryString += s+',';
        }

        //Remove last comma
        queryString = queryString.subString(0, queryString.Length()-1);

        //Close query string
        String queryStringCurrentMonthYear = queryString;
        queryStringCurrentMonthYear += ' FROM Rate__c WHERE Month_Code__c =: currentMonth and Year__c =: currentYear ORDER BY CreatedDate DESC LIMIT 1';
        //System.debug(queryString);

        //Retrieve rates
        List<Rate__c> rateList = Database.query(queryStringCurrentMonthYear);
        //System.debug('rateList: '+rateList);

        //Rate__c rate = new Rate__c();
        Rate__c rate = null;
        if(!rateList.isEmpty()){
            rate = rateList.get(0);
        } else {
            String queryStringLatestRate = queryString;
            queryStringLatestRate += ' FROM Rate__c ORDER BY CreatedDate DESC LIMIT 1';
            rateList = Database.query(queryStringLatestRate);
            if (!rateList.isEmpty()) {
                rate = rateList.get(0);
            } 
        }
        return rate;
    }

    /* Description: Get LFT TRAC rates for calculation
     * Parameters: Set<String>
     * Returns: Map<String, LFT_TRAC_Table__c>
     * Author: Michael Lasala
     * Date Created: MAR-16-17
     */
    public static Map<String, LFT_TRAC_Table__c> getLFTTRAC(Set<String> cityNameSet){

        Map<String, LFT_TRAC_Table__c> lftTRACMap = new Map<String, LFT_TRAC_Table__c>();
        
        //Retrieve custom setting based on parameter
        for(LFT_TRAC_Table__c lftTRAC: [SELECT Name, LFT_Rate__c, TRAC_Rate__c FROM LFT_TRAC_Table__c WHERE NAME IN: cityNameSet]){
            lftTRACMap.put(lftTRAC.Name, lftTRAC);
        }
        return lftTRACMap;
    }

    ///* Description: Calculate rates
    // * Parameters: Map<Id, CXE_BillDepositWrapper>, Rate__c, LFT_TRAC_Table__c
    // * Returns: CXE_BillDepositWrapper
    // * Author: Michael Lasala
    // * Date Created: MAR-15-17
    // * Updated  : CSM-166 Added by Jerome To  updated computations
    // */
    //public static CXE_BillDepositWrapper calculateRate(CXE_BillDepositWrapper wrapper, Rate__c rate, LFT_TRAC_Table__c lftTRAC){
        
    //    //Assign wrapper values based on rate
    //    wrapper.priceGenerationCharge = rate.Genertion_Charge_for_Non_TOU__c;

    //    if(wrapper.rate == 'Residential Service (RS)'){
    //        wrapper.pricePowerActReduction = rate.Power_Act_Reduction__c;
    //    }
        
    //    wrapper.pricePrevMonthAdj = rate.Previous_Month_s_Adjustment_on_Generatio__c;
    //    wrapper.priceTCVAT = rate.TC_Transmission_Charge_non_VAT__c;
    //    wrapper.priceTCnonVAT = rate.TC_Transmission_Charge_VATable__c;
    //    wrapper.priceFixedSupplyCharge = rate.SC_Res_Gen_Service_A_Per_Cust_month__c;
    //    wrapper.priceMissionaryCharge = rate.Universal_Charge_Missionary_Electrific__c;
    //    wrapper.priceEnvironmentalCharge = rate.Universal_Charge_Environmental_Charge__c;
    //    wrapper.priceStrandedCost = rate.Universal_Charge_Stranded_Contract_Cos__c;
    //    wrapper.priceFitAll = rate.Fit_All__c;

    //    //DUMMY DATA
    //    wrapper.baseFixedSupplyCharge = 1;
    //    wrapper.baseLifelineDiscount = 1;
    //    //DUMMY DATA

    //    //Calculate
    //    //wrapper.amountGenerationCharge = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceGenerationCharge);
    //    wrapper.amountPowerActReduction = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.pricePowerActReduction);
    //    wrapper.amountPrevMonthAdj = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.pricePrevMonthAdj);

    //    // START CSM-166 Added by Jerome To MAY-12-17 
    //    wrapper.amountGenerationCharge = multiplyRate(wrapper.kwHConsumption, wrapper.priceGenerationCharge);
    //    wrapper.amountGenerationCharge = multiplyRate(wrapper.kwHConsumption, wrapper.priceGenerationCharge);
    //    // END CSM-166 Added by Jerome To MAY-12-17


    //    wrapper.amountFixedSupplyCharge = multiplyRate(wrapper.baseFixedSupplyCharge, wrapper.priceFixedSupplyCharge);

    //    if(wrapper.rate == 'General Service A (GSA)' || 
    //       wrapper.rate == 'Residential Service (RS)'){

    //        wrapper.priceTransmissionCharge = rate.TC_Residential_General_Service_A__c;
    //        wrapper.priceSystemLossCharge = rate.SLC_Res_Gen_Services_A_P_kWh__c;
    //        wrapper.priceSupplyChargekWh = rate.SC_Res_Gen_Service_A_Per_kWh__c;

    //    } else if(wrapper.rate == 'General Service B (GSB)'){
            
    //        wrapper.priceTransmissionCharge = rate.TC_General_Service_B__c;
    //        wrapper.priceSystemLossCharge = rate.GHMSCI__c;
    //        wrapper.priceSupplyChargekWh = rate.GHMSCI__c;

    //    } else { //if(wrapper.rate == 'General Service B (GSB)'){
            
    //        wrapper.priceTransmissionCharge = rate.TC_GHMS__c;
    //        wrapper.priceSystemLossCharge = rate.SLC_Res_Gen_Services_A_P_kWh__c;
    //        wrapper.priceSupplyChargekWh = rate.SC_GHMSCI_Per_Cust_month__c;
    //    }

    //    //wrapper.amountTransmissionCharge = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceTransmissionCharge);
    //    wrapper.amountTransmissionCharge = multiplyRate(wrapper.kwHConsumption, wrapper.priceTransmissionCharge);
    //    //wrapper.amountSystemLossCharge = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceSystemLossCharge);
    //    wrapper.amountSystemLossCharge = multiplyRate(wrapper.kwHConsumption, wrapper.priceSystemLossCharge);
    //    wrapper.amountSupplyChargekWh = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceSupplyChargekWh);
    //    wrapper.amountTCVAT = multiplyRate(wrapper.priceTransmissionCharge, wrapper.priceTCVAT);
    //    wrapper.amountTCnonVAT = multiplyRate(wrapper.amountTCVAT, wrapper.priceTCnonVAT);

    //    //wrapper.isLifelineDiscount = CXE_Constants.OPTION_YES;  //DUMMY DATA
    //    if(wrapper.isLifelineDiscount == CXE_Constants.OPTION_NO){
    //        wrapper.priceLifelineDiscount = 0;
    //    } else {

    //        if(wrapper.equivalentMonthlyConsumption < 21){
    //            wrapper.priceLifelineDiscount = rate.Lifeline_Discount_0_20__c;
    //        } else if(wrapper.equivalentMonthlyConsumption < 51){
    //            wrapper.priceLifelineDiscount = rate.Lifeline_Discount_21_50__c;
    //        } else if(wrapper.equivalentMonthlyConsumption < 71){
    //            wrapper.priceLifelineDiscount = rate.Lifeline_Discount_51_70__c;
    //        } else {
    //            wrapper.priceLifelineDiscount = rate.Lifeline_Discount_71_100__c;
    //        }
    //    }
    //    wrapper.amountLifelineDiscount = multiplyRate(wrapper.baseLifelineDiscount, wrapper.priceLifelineDiscount);
        
    //    if(wrapper.isLifeLineSubsidy == CXE_Constants.OPTION_YES){
    //        wrapper.priceLifelineRateSubsidy = rate.Lifeline_Subsidy__c;
    //    }
    //    wrapper.amountLifelineRateSubsidy = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceLifelineRateSubsidy);

    //    //wrapper.isSCSubsidy = CXE_Constants.OPTION_NO;  //DUMMY DATA
    //    if(wrapper.isSCSubsidy == CXE_Constants.OPTION_NO){
    //        wrapper.baseSeniorCitizenSubsidy = wrapper.equivalentMonthlyConsumption;
    //    }
    //    wrapper.priceSeniorCitizenSubsidy = rate.Senior_Citizen_Subsidy__c;
    //    wrapper.amountSeniorCitizenSubsidy = multiplyRate(wrapper.baseSeniorCitizenSubsidy, wrapper.priceSeniorCitizenSubsidy);
        
    //    wrapper.baseLocalFranchiseTax += wrapper.amountGenerationCharge + wrapper.amountPowerActReduction + wrapper.amountPrevMonthAdj;
    //    wrapper.baseLocalFranchiseTax += wrapper.amountTransmissionCharge + wrapper.amountSystemLossCharge /*+ distribution energy charge*/;
    //    wrapper.baseLocalFranchiseTax += /*fix metering charge + metering charge per kWh +*/ wrapper.amountFixedSupplyCharge;
    //    wrapper.baseLocalFranchiseTax += wrapper.amountLifelineDiscount + wrapper.amountLifelineRateSubsidy /* + schd  + */;
    //    wrapper.baseLocalFranchiseTax += wrapper.amountSeniorCitizenSubsidy;

    //    if(wrapper.isLocalFranchiseTax ==  CXE_Constants.OPTION_NO){
    //        wrapper.priceLocalFranchiseTax = lftTRAC.LFT_Rate__c;
    //    }
    //    wrapper.amountLocalFranchiseTax = multiplyRate(wrapper.baseLocalFranchiseTax, wrapper.priceLocalFranchiseTax);

    //    if(wrapper.isZeroRated != CXE_Constants.OPTION_YES){

    //        wrapper.priceVATGenerationCost = rate.VAT_Generation_Charge__c;
    //        wrapper.priceVATTransmissionCharge = rate.Transmission_Charge_VATable__c;
    //        wrapper.priceVATSystemLossCharge = rate.VAT_System_Loss_Charge__c;
    //        wrapper.priceVATDistributionRevenueAmount = rate.Distribution_Charge__c;

    //        if(wrapper.rate == 'General Service A (GSA)' || 
    //           wrapper.rate == 'Residential Service (RS)'){

    //            wrapper.priceVATPowerActReduction = rate.VAT_Power_Act_Reduction__c;
    //        }
    //    }

    //    wrapper.amountVATGenerationCost = multiplyRate(wrapper.amountGenerationCharge, wrapper.priceVATGenerationCost);
    //    wrapper.amountVATTransmissionCharge = multiplyRate(wrapper.amountTCVAT, wrapper.priceVATTransmissionCharge);
    //    wrapper.amountVATSystemLossCharge = multiplyRate(wrapper.amountSystemLossCharge, wrapper.priceVATSystemLossCharge);
    //    wrapper.amountVATPowerActReduction = multiplyRate(wrapper.amountPowerActReduction, wrapper.priceVATPowerActReduction);
        
    //    //wrapper.baseVATDistributionRevenueAmount += distribution energy change + fixed metering charge + metering charge per kwh
    //    wrapper.baseVATDistributionRevenueAmount += wrapper.amountFixedSupplyCharge + wrapper.amountSupplyChargekWh;
    //    wrapper.amountVATDistributionRevenueAmount = multiplyRate(wrapper.baseVATDistributionRevenueAmount, wrapper.priceVATDistributionRevenueAmount);
        
    //    wrapper.baseVATSubsidies += wrapper.amountLifelineDiscount + wrapper.amountLifelineRateSubsidy /*+ sched*/ + wrapper.amountSeniorCitizenSubsidy;
    //    wrapper.baseVATSubsidies += /* trac + */ wrapper.amountLocalFranchiseTax;
    //    wrapper.amountVATSubsidies = multiplyRate(wrapper.baseVATSubsidies, wrapper.priceVATDistributionRevenueAmount);

    //    wrapper.priceMissionaryCharge = rate.Universal_Charge_Missionary_Electrific__c;
    //    wrapper.amountMissionaryCharge = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceMissionaryCharge);
        
    //    wrapper.priceEnvironmentalCharge = rate.Universal_Charge_Environmental_Charge__c;
    //    wrapper.amountEnvironmentalCharge = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceEnvironmentalCharge);
        
    //    wrapper.priceStrandedCost = rate.Universal_Charge_Stranded_Contract_Cos__c;
    //    wrapper.amountStrandedCost = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceStrandedCost);
        
    //    wrapper.priceFitAll = rate.Fit_All__c;
    //    wrapper.amountFitAll = multiplyRate(wrapper.equivalentMonthlyConsumption, wrapper.priceFitAll);
        
    //    if(wrapper.isZeroRated != CXE_Constants.OPTION_YES){

    //        wrapper.baseVATSales += wrapper.amountGenerationCharge + wrapper.amountTCVAT + wrapper.amountSystemLossCharge;
    //        wrapper.baseVATSales += /*vart pmagc + */ wrapper.amountPowerActReduction + wrapper.baseVATDistributionRevenueAmount;
    //        wrapper.baseVATSales += wrapper.baseVATSubsidies;
            
    //        wrapper.priceVATSales += wrapper.priceVATGenerationCost + wrapper.amountVATTransmissionCharge + wrapper.amountVATSystemLossCharge;
    //        wrapper.priceVATSales += /*vart pmagc + */ wrapper.amountVATPowerActReduction + wrapper.amountVATDistributionRevenueAmount;
    //        wrapper.priceVATSales += wrapper.amountVATSubsidies;
        
    //    } else {

    //        wrapper.baseVATZero += wrapper.amountGenerationCharge + wrapper.amountTCVAT + wrapper.amountSystemLossCharge;
    //        wrapper.baseVATZero += /*vart pmagc + */ wrapper.amountPowerActReduction + wrapper.baseVATDistributionRevenueAmount;
    //        wrapper.baseVATZero += wrapper.baseVATSubsidies;

    //    }

    //    wrapper.baseVATExempt =+ wrapper.amountTCnonVAT; //block 1 + block 2 + block 3;
    //    wrapper.baseVATExempt =+ wrapper.amountVATSubsidies + wrapper.amountMissionaryCharge + wrapper.amountEnvironmentalCharge;
    //    wrapper.baseVATExempt =+ wrapper.amountMissionaryCharge + wrapper.amountEnvironmentalCharge + wrapper.amountStrandedCost;
    //    wrapper.baseVATExempt =+ wrapper.amountFitAll;

    //    wrapper.baseTotalBillAmount = wrapper.baseVATSales + wrapper.baseVATZero + wrapper.baseVATExempt;
        
    //    wrapper.amountTotalBillAmount = wrapper.baseTotalBillAmount + wrapper.priceVATSales;
        
        //wrapper.totalCurrentAmount += wrapper.amountGenerationCharge + wrapper.amountFixedSupplyCharge + wrapper.amountPrevMonthAdj;
        //wrapper.totalCurrentAmount += wrapper.amountSystemLossCharge + wrapper.amountSupplyChargekWh + wrapper.amountLifelineDiscount;
        //wrapper.totalCurrentAmount += wrapper.amountLifelineRateSubsidy + wrapper.amountSeniorCitizenSubsidy + wrapper.amountLocalFranchiseTax;
        //wrapper.totalCurrentAmount += wrapper.amountVATGenerationCost + wrapper.amountVATTransmissionCharge + wrapper.amountVATSystemLossCharge;
        //wrapper.totalCurrentAmount += wrapper.amountVATDistributionRevenueAmount + wrapper.amountVATSubsidies + wrapper.amountMissionaryCharge;
        //wrapper.totalCurrentAmount += wrapper.amountEnvironmentalCharge + wrapper.amountStrandedCost + wrapper.amountFitAll;
        
    //    wrapper.totalCurrentAmountInc = wrapper.totalCurrentAmount; //- unapplied credits + pending adjustments

    //    return wrapper;
    //}

    /* Description: Multiply rates
     * Parameters: Multiplicand, multiplier
     * Returns: Product
     * Author: Michael Lasala
     * Date Created: MAR-15-17
     */
    public static Decimal multiplyRate(Decimal multiplicand, Decimal multiplier){
        return (multiplicand * multiplier).setScale(2);
    }

    /* Description: Calculate rates
     * Parameters: Map<Id, CXE_BillDepositWrapper>, Rate__c, LFT_TRAC_Table__c
     * Returns: CXE_BillDepositWrapper
     * Author: Jerome To
     * Date Created: MAY-15-17
     */
    public static CXE_BillDepositWrapper calculateRate(CXE_BillDepositWrapper wrapper, Rate__c rate, LFT_TRAC_Table__c lftTR){
        
        try {
            // Assign wrapper values based on rate
            wrapper.kwHConsumption =  wrapper.contractedCapacity * wrapper.loadFactor * 24 * 30;
            wrapper.kwDemand = wrapper.contractedCapacity;
            // Generation Charge

            wrapper.priceGenerationCharge = rate.Generation_Charge_for_Non_TOU__c;
            wrapper.amountGenerationCharge =  multiplyRate(wrapper.priceGenerationCharge, wrapper.kwHConsumption);
            
            wrapper.baseFixedSupplyCharge = rate.Base_Fixed_Supply_Charge__c;
            wrapper.baseFixedMeteringCharge = rate.Base_Fixed_Metering_Charge__c;

            // Transmission Charge, 
            // System Loss Charge,
            // Distribution Charge,
            // Fixed Metering charge,
            // Supply Charge,
            // Lifeline Rate Subsidy
            if(wrapper.rate == CXE_Constants.SERVICE_RATE_TYPE_GSA || 
               wrapper.rate == CXE_Constants.SERVICE_RATE_TYPE_RES) {

                wrapper.priceFixedMeteringCharge = rate.MC_Res_Gen_Service_A_Per_Cust_month__c;
                wrapper.priceMeteringCharge = rate.MC_Res_Gen_Service_A_Per_kWh__c;

                wrapper.priceFixedSupplyCharge = rate.SC_Res_Gen_Service_A_Per_Cust_month__c;
                wrapper.priceSupplyChargekWh = rate.SC_Res_Gen_Service_A_Per_kWh__c;

                wrapper.priceTransmissionCharge = rate.TC_Residential_General_Service_A__c;
                wrapper.priceSystemLossCharge = rate.SLC_Res_Gen_Services_A_P_kWh__c;

                if(wrapper.kwHConsumption <= 200) {
                    wrapper.priceDistributionCharge = rate.DC_Res_Gen_Service_A_Up_to_200_Per_k__c;
                } else if(wrapper.kwHConsumption > 200 && wrapper.kwHConsumption <= 300) {
                    wrapper.priceDistributionCharge = rate.DC_Res_Gen_Service_A_201_300_Per_kWh__c;
                } else if(wrapper.kwHConsumption > 300 && wrapper.kwHConsumption <= 400) {
                    wrapper.priceDistributionCharge = rate.DC_Res_Gen_Service_A_301_400_Per_kWh__c;
                } else {
                    wrapper.priceDistributionCharge = rate.DC_Res_Gen_Service_A_401_kWh_and_Up__c;
                }
                
                wrapper.amountDistributionCharge = multiplyRate(wrapper.priceDistributionCharge, wrapper.kwHConsumption);
                wrapper.amountTransmissionCharge = multiplyRate(wrapper.priceTransmissionCharge, wrapper.kwHConsumption);
                wrapper.hasMeteringCharge = true;  
                wrapper.hasSupplyCharge = true;  
                wrapper.hasDistributionCharge = true;

            } else if (wrapper.rate == CXE_Constants.SERVICE_RATE_TYPE_GSB){
                
                wrapper.priceTransmissionCharge = rate.TC_General_Service_B__c;
                wrapper.priceSystemLossCharge = rate.SLC_General_Service_B__c;
                wrapper.priceFixedMeteringCharge = rate.MC_General_Service_B_Per_Cust_month__c;
                wrapper.priceFixedSupplyCharge = rate.SC_General_Service_B_Per_Cust_month__c;
                wrapper.priceDistributionDemandCharge = rate.DC_General_Service_B_Per_kW__c;
                wrapper.priceDistributionEnergyCharge = rate.DC_General_Service_B_Per_kWh__c;

                wrapper.amountDistributionDemandCharge = multiplyRate(wrapper.priceDistributionDemandCharge, wrapper.kwDemand);
                wrapper.amountDistributionEnergyCharge = multiplyRate(wrapper.priceDistributionEnergyCharge, wrapper.kwHConsumption);
                wrapper.amountTransmissionCharge = multiplyRate(wrapper.priceTransmissionCharge, wrapper.kWDemand);

                wrapper.hasDistributionDemandCharge = true;
                wrapper.hasDistributionEnergyCharge = true;
            } else if (wrapper.rate == CXE_Constants.SERVICE_RATE_TYPE_GHMSCI) {   

                wrapper.priceTransmissionCharge = rate.TC_GHMS__c;
                wrapper.priceSystemLossCharge = rate.SLC_GHMSCI__c;
                wrapper.priceDistributionCharge = rate.DC_GHMSCI__c;
                wrapper.priceFixedMeteringCharge = rate.MC_GHMSCI_Per_Cust_month__c;
                wrapper.priceFixedSupplyCharge = rate.SC_GHMSCI_Per_Cust_month__c;

                wrapper.amountDistributionCharge = multiplyRate(wrapper.priceDistributionCharge, wrapper.kwHConsumption);
                wrapper.amountTransmissionCharge = multiplyRate(wrapper.priceTransmissionCharge, wrapper.kwHConsumption);

                wrapper.hasDistributionCharge = true;
            } else { // General Power
                   //Secondary
                   //Below 13.2 kV
                   //13.8/13.2 kV
                   //34.5 kV
                   //115 kV/69 kV
                wrapper.contractedCapacityScale = getContractedCapacityScaleForGP(wrapper.contractedCapacity);

                if (wrapper.contractedCapacityScale == CXE_Constants.CONTRACTED_CAPACITY_SCALE_MEDIUM) {
                    wrapper.priceFixedMeteringCharge = rate.MC_GP_MEDIUM_Per_Cust_month__c;
                    wrapper.priceFixedSupplyCharge = rate.SC_GP_MEDIUM_Per_Cust_month__c;
                } else if (wrapper.contractedCapacityScale == CXE_Constants.CONTRACTED_CAPACITY_SCALE_LARGE) {
                    wrapper.priceFixedMeteringCharge = rate.MC_GP_LARGE_Per_Cust_month__c;
                    wrapper.priceFixedSupplyCharge = rate.SC_GP_LARGE_Per_Cust_month__c;
                } else if (wrapper.contractedCapacityScale == CXE_Constants.CONTRACTED_CAPACITY_SCALE_VERY_LARGE ||
                            wrapper.contractedCapacityScale == CXE_Constants.CONTRACTED_CAPACITY_SCALE_EXTRA_LARGE ) {
                    wrapper.priceFixedMeteringCharge = rate.MC_GP_VERY_LARGE_Per_Cust_month__c;
                    wrapper.priceFixedSupplyCharge = rate.SC_GP_VERY_LARGE_Per_Cust_month__c;
                }

                if(wrapper.voltageLevel == CXE_Constants.VOLTAGE_LEVEL_SECONDARY) {
                    wrapper.priceTransmissionCharge = rate.TC_GP_Secondary__c;
                    wrapper.priceSystemLossCharge = rate.SLC_GP_Secondary__c;
                    wrapper.priceDistributionDemandCharge = rate.DC_GP_Secondary_per_kW__c;
                    wrapper.priceDistributionEnergyCharge = rate.DC_GP_Secondary_per_kWh__c;
                } else if(wrapper.voltageLevel == CXE_Constants.VOLTAGE_LEVEL_TYPE_E) {
                    wrapper.priceTransmissionCharge = rate.TC_GP_Type_E__c;
                    wrapper.priceSystemLossCharge = rate.SLC_GP_Type_E__c;
                    wrapper.priceDistributionDemandCharge = rate.DC_GP_Type_E_per_kW__c;
                    wrapper.priceDistributionEnergyCharge = rate.DC_GP_Type_E_per_kWh__c;             
                } else if(wrapper.voltageLevel == CXE_Constants.VOLTAGE_LEVEL_TYPE_D) {
                    wrapper.priceTransmissionCharge = rate.TC_GP_Type_D__c;
                    wrapper.priceSystemLossCharge = rate.SLC_GP_Type_D__c;
                    wrapper.priceDistributionDemandCharge = rate.DC_GP_Type_D_per_kW__c;
                    wrapper.priceDistributionEnergyCharge = rate.DC_GP_Type_D_per_kWh__c;
                } else if(wrapper.voltageLevel == CXE_Constants.VOLTAGE_LEVEL_TYPE_C) {
                    wrapper.priceTransmissionCharge = rate.TC_GP_Type_C__c;
                    wrapper.priceSystemLossCharge = rate.SLC_GP_Type_C__c;
                    wrapper.priceDistributionDemandCharge = rate.DC_GP_Type_C_per_kW__c;
                    wrapper.priceDistributionEnergyCharge = rate.DC_GP_Type_C_per_kWh__c;
                } else if (wrapper.voltageLevel == CXE_Constants.VOLTAGE_LEVEL_TYPE_A || wrapper.voltageLevel == CXE_Constants.VOLTAGE_LEVEL_TYPE_B) {
                    wrapper.priceTransmissionCharge = rate.TC_GP_Type_AB__c;
                    wrapper.priceSystemLossCharge = rate.SLC_GP_Type_AB__c;
                    wrapper.priceDistributionDemandCharge = rate.DC_GP_Type_AB_per_kW__c;
                    wrapper.priceDistributionEnergyCharge = rate.DC_GP_Type_AB_per_kWh__c;
                }
                
                wrapper.amountdistributionDemandCharge = multiplyRate(wrapper.priceDistributionDemandCharge, wrapper.kwDemand);
                wrapper.amountdistributionEnergyCharge = multiplyRate(wrapper.priceDistributionEnergyCharge, wrapper.kwHConsumption);
                wrapper.amountTransmissionCharge = multiplyRate(wrapper.priceTransmissionCharge, wrapper.kWDemand);
                
                wrapper.hasDistributionDemandCharge = true;
                wrapper.hasDistributionEnergyCharge = true;
                wrapper.hasPowerFactorAdjustment = true;
                wrapper.hasCrossSubsidyCharge = true;
                //wrapper.hasFixedMeteringCharge = true;  
                //wrapper.hasFixedSupplyCharge = true;
            }

            
            wrapper.amountSystemLossCharge = multiplyRate(wrapper.priceSystemLossCharge, wrapper.kwHConsumption);
            
            wrapper.amountFixedMeteringCharge = multiplyRate(wrapper.priceFixedMeteringCharge, wrapper.baseFixedMeteringCharge);
            wrapper.amountFixedSupplyCharge = multiplyRate(wrapper.priceFixedSupplyCharge, wrapper.baseFixedSupplyCharge);

            if(wrapper.isLifeLineSubsidy == CXE_Constants.OPTION_YES) {
                wrapper.priceLifeLineSubsidy = rate.Lifeline_Subsidy__c;
                wrapper.amountLifeLineSubsidy = multiplyRate(wrapper.priceLifeLineSubsidy, wrapper.kwHConsumption);
            }

            if(wrapper.isSCSubsidy == CXE_Constants.OPTION_YES) {
                wrapper.priceSeniorCitizenSubsidy = rate.Senior_Citizen_Subsidy__c;
                wrapper.amountSeniorCitizenSubsidy = multiplyRate(wrapper.priceSeniorCitizenSubsidy, wrapper.kwHConsumption);
            }

            wrapper.amountMeteringCharge = multiplyRate(wrapper.priceMeteringCharge, wrapper.kwHConsumption);
            wrapper.amountSupplyChargekWh = multiplyRate(wrapper.priceSupplyChargekWh, wrapper.kwHConsumption);
            // cross subsidy charge
            wrapper.priceCrossSubsidyCharge = rate.Cross_Subsidy_Charge__c;
            wrapper.amountCrossSubsidyCharge = multiplyRate(wrapper.priceCrossSubsidyCharge, wrapper.kwHConsumption);

            wrapper.priceMissionaryCharge = rate.Universal_Charge_Missionary_Electrific__c;
            wrapper.amountMissionaryCharge = multiplyRate(wrapper.priceMissionaryCharge, wrapper.kwHConsumption);

            wrapper.priceEnvironmentalCharge = rate.Universal_Charge_Environmental_Charge__c;
            wrapper.amountEnvironmentalCharge = multiplyRate(wrapper.priceEnvironmentalCharge, wrapper.kwHConsumption);

            wrapper.priceDUsStrandedCost = rate.DUs_Stranded_Contract_Cost_kWh__c;
            wrapper.amountDUsStrandedCost = multiplyRate(wrapper.priceDUsStrandedCost, wrapper.kwHConsumption);

            wrapper.priceNPCStrandedDebts = rate.NPC_Stranded_Debts_kWh__c;
            wrapper.amountNPCStrandedDebts = multiplyRate(wrapper.priceNPCStrandedDebts, wrapper.kwHConsumption);

            wrapper.priceNPCStrandedContractCosts = rate.Universal_Charge_Stranded_Contract_Cos__c;
            wrapper.amountNPCStrandedContractCosts = multiplyRate(wrapper.priceNPCStrandedContractCosts, wrapper.kwHConsumption);

            wrapper.priceEqualizationTaxesAndRoyalties = rate.Equalization_Taxes_and_Royalties_kWh__c;
            wrapper.amountEqualizationTaxesAndRoyalties = multiplyRate(wrapper.priceEqualizationTaxesAndRoyalties, wrapper.kwHConsumption);

            wrapper.pricePowerFactorAdjustment = rate.Power_Factor_Adjustment__c;
            wrapper.amountPowerFactorAdjustment = multiplyRate(wrapper.pricePowerFactorAdjustment, wrapper.kwHConsumption);

            wrapper.priceFitAll = rate.Fit_All__c;
            wrapper.amountFitAll = multiplyRate(wrapper.priceFitAll, wrapper.kwHConsumption);

            wrapper.priceVATGenerationCost = rate.VAT_Generation_Charge__c;
            wrapper.amountVATGenerationCost = multiplyRate(wrapper.amountGenerationCharge, wrapper.priceVATGenerationCost /100);

            wrapper.pricePrevMonthAdj = rate.Previous_Month_s_Adjustment_on_Generatio__c;
            wrapper.priceTCVAT = rate.TC_Transmission_Charge_VATable__c;
            wrapper.priceTCnonVAT = rate.TC_Transmission_Charge_non_VAT__c;

            wrapper.amountTCVAT = multiplyRate(wrapper.amountTransmissionCharge, wrapper.priceTCVAT/100);
            wrapper.amountTCnonVAT = multiplyRate(wrapper.amountTransmissionCharge, wrapper.priceTCnonVAT/100);

            wrapper.priceVATTransmissionCharge = rate.VAT_Transmission_Charge_VATable__c;
            wrapper.amountVATTransmissionCharge = multiplyRate(wrapper.amountTCVAT, wrapper.priceVATTransmissionCharge /100);

            wrapper.priceVATSystemLossCharge = rate.VAT_System_Loss_Charge__c;
            wrapper.amountVATSystemLossCharge = multiplyRate(wrapper.amountSystemLossCharge, wrapper.priceVATSystemLossCharge/100);

            wrapper.priceVATDistributionRevenueAmount = rate.VAT_Other_Charges__c;
            wrapper.baseVATDistributionRevenueAmount = wrapper.amountDistributionCharge + wrapper.amountFixedMeteringCharge + wrapper.amountMeteringCharge + wrapper.amountFixedSupplyCharge + wrapper.amountSupplyChargekWh +  wrapper.amountdistributionEnergyCharge + wrapper.amountDistributionDemandCharge;
            //wrapper.baseVATDistributionRevenueAmount = ((wrapper.hasDistributionDemandCharge) ? wrapper.amountDistributionDemandCharge : 0) + ((wrapper.hasDistributionEnergyCharge) ? wrapper.amountdistributionEnergyCharge : 0 );
            wrapper.amountVATDistributionRevenueAmount = multiplyRate(wrapper.baseVATDistributionRevenueAmount, wrapper.priceVATDistributionRevenueAmount/100);

            if(wrapper.isLifelineDiscount == CXE_Constants.OPTION_NO){
                wrapper.priceLifelineDiscount = 0;
            } else {

                if(wrapper.kwHConsumption < 21){
                    wrapper.priceLifelineDiscount = rate.Lifeline_Discount_0_20__c;
                } else if(wrapper.kwHConsumption < 51){
                    wrapper.priceLifelineDiscount = rate.Lifeline_Discount_21_50__c;
                } else if(wrapper.kwHConsumption < 71){
                    wrapper.priceLifelineDiscount = rate.Lifeline_Discount_51_70__c;
                } else {
                    wrapper.priceLifelineDiscount = rate.Lifeline_Discount_71_100__c;
                }
            }
            wrapper.amountLifelineDiscount = multiplyRate(wrapper.baseLifelineDiscount, wrapper.priceLifelineDiscount);
            
            if(wrapper.isLifeLineSubsidy == CXE_Constants.OPTION_YES){
                wrapper.priceLifelineRateSubsidy = rate.Lifeline_Subsidy__c;
            }
            wrapper.amountLifelineRateSubsidy = multiplyRate(wrapper.kwHConsumption, wrapper.priceLifelineRateSubsidy);
            
            wrapper.priceTRAC = 0;
            wrapper.amountTRAC = multiplyRate(wrapper.priceTRAC, wrapper.kwHConsumption);

            wrapper.basedLFT = wrapper.amountGenerationCharge + wrapper.amountTransmissionCharge + wrapper.amountSystemLossCharge 
                                + wrapper.amountDistributionCharge + wrapper.amountFixedMeteringCharge + wrapper.amountMeteringCharge 
                                + wrapper.amountFixedSupplyCharge + wrapper.amountSupplyChargekWh + wrapper.amountLifelineRateSubsidy + wrapper.amountSeniorCitizenSubsidy;
            wrapper.priceLFT = 0;
            wrapper.amountLFT = multiplyRate(wrapper.basedLFT, wrapper.priceLFT);

            wrapper.baseVATSubsidies = wrapper.amountLifelineRateSubsidy + wrapper.amountSeniorCitizenSubsidy + wrapper.amountTRAC + wrapper.amountLFT;
            wrapper.priceVATSubsidies = rate.VAT_Other_Charges__c;
            wrapper.amountVATSubsidies = multiplyRate(wrapper.baseVATSubsidies, wrapper.priceVATSubsidies/100);


            if(wrapper.isZeroRated != CXE_Constants.OPTION_YES){
                wrapper.baseVATSales = wrapper.amountGenerationCharge + wrapper.amountTCVAT + wrapper.amountSystemLossCharge;
                wrapper.baseVATSales += wrapper.amountPowerActReduction + wrapper.baseVATDistributionRevenueAmount;
                wrapper.baseVATSales += wrapper.baseVATSubsidies;
                
                wrapper.priceVATSales += wrapper.priceVATGenerationCost + wrapper.amountVATTransmissionCharge + wrapper.amountVATSystemLossCharge;
                wrapper.priceVATSales += wrapper.amountVATPowerActReduction + wrapper.amountVATDistributionRevenueAmount;
                wrapper.priceVATSales += wrapper.amountVATSubsidies;
            
            } else {

                wrapper.baseVATZero = wrapper.amountGenerationCharge + wrapper.amountTCVAT + wrapper.amountSystemLossCharge;
                wrapper.baseVATZero +=  wrapper.amountPowerActReduction + wrapper.baseVATDistributionRevenueAmount;
                wrapper.baseVATZero += wrapper.baseVATSubsidies;

            }

            wrapper.baseVATExempt =+ wrapper.amountTCnonVAT;
            wrapper.baseVATExempt =+ wrapper.amountVATSubsidies + wrapper.amountMissionaryCharge + wrapper.amountEnvironmentalCharge;
            wrapper.baseVATExempt =+ wrapper.amountMissionaryCharge + wrapper.amountEnvironmentalCharge + wrapper.amountDUsStrandedCost;
            wrapper.baseVATExempt =+ wrapper.amountFitAll;

            wrapper.baseTotalBillAmount = wrapper.baseVATSales + wrapper.baseVATZero + wrapper.baseVATExempt;
            
            wrapper.amountTotalBillAmount = wrapper.baseTotalBillAmount + wrapper.priceVATSales;

            //this.hasFixedMeteringCharge = false;
            //this.hasFixedSupplyCharge = false;
            //this.hasDistributionCharge = false;           
            //this.hasDistributionDemandCharge = false;
            //this.hasDistributionEnergyCharge = false;
            //this.hasPowerFactorAdjustment = false;
            //this.hasCrossSubsidyCharge = false;

            wrapper.totalCurrentAmount = wrapper.amountGenerationCharge + wrapper.amountTCVAT + wrapper.amountTCnonVAT;
            wrapper.totalCurrentAmount += wrapper.amountSystemLossCharge + ((wrapper.hasDistributionCharge) ? wrapper.amountDistributionCharge : 0) + ((wrapper.hasDistributionDemandCharge) ? wrapper.amountDistributionDemandCharge : 0);
            wrapper.totalCurrentAmount += ((wrapper.hasDistributionEnergyCharge) ? wrapper.amountDistributionEnergyCharge : 0 ) + ((wrapper.hasFixedMeteringCharge) ? wrapper.amountFixedMeteringCharge : 0) + wrapper.amountMeteringCharge;
            wrapper.totalCurrentAmount += ((wrapper.hasFixedSupplyCharge) ? wrapper.amountFixedSupplyCharge : 0 )+ wrapper.amountSupplyChargekWh + ((wrapper.hasPowerFactorAdjustment) ? wrapper.amountPowerFactorAdjustment : 0 );
            wrapper.totalCurrentAmount += wrapper.amountLifelineRateSubsidy + ((wrapper.hasCrossSubsidyCharge) ? wrapper.amountCrossSubsidyCharge : 0) + wrapper.amountSeniorCitizenSubsidy;
            wrapper.totalCurrentAmount += wrapper.amountVATGenerationCost + wrapper.amountVATTransmissionCharge + wrapper.amountVATSystemLossCharge;
            wrapper.totalCurrentAmount += wrapper.amountVATDistributionRevenueAmount + wrapper.amountVATSubsidies + wrapper.amountMissionaryCharge;
            wrapper.totalCurrentAmount += wrapper.amountEnvironmentalCharge + wrapper.amountNPCStrandedDebts + wrapper.amountNPCStrandedContractCosts;
            wrapper.totalCurrentAmount += wrapper.amountDUsStrandedCost + wrapper.amountEqualizationTaxesAndRoyalties + wrapper.amountFitAll;
            wrapper.totalCurrentAmount += wrapper.amountLFT + wrapper.amountTRAC;

            Integer totalAmount = Integer.valueOf(wrapper.totalCurrentAmount);
            wrapper.roundedTotalAmount = (Math.mod(totalAmount,10) == 0 ? totalAmount : (Math.mod(totalAmount,10) < 5 ? totalAmount- Math.mod(totalAmount,10): totalAmount - Math.mod(totalAmount,10) + 10));
            return wrapper;
        } catch (Exception e) {
            System.debug('>>>>>>> calculateRate Error >>>>>>> ' + e.getMessage());
            return wrapper;
        } 
    }

    /* Description: Get Voltage Level for calculation
     * Parameters: None
     * Returns: Map
     * Author: Jerome To
     * Date Created: MAY-15-17
     */
    private static Map<String, String> getVoltageLevelMap(){
        Map<String, String> voltageLevelMap = new Map<String, String>();
        Map<String, String> voltageCodeNameMap = new Map<String, String>(); 

        for(Reference__c ref : [SELECT Name_Code__c, Name FROM Reference__c WHERE Field__c =:CXE_Constants.REFERENCE_FIELD_VOLTAGE]) {
            voltageCodeNameMap.put(ref.Name_Code__c, ref.Name);
        }

        if(!voltageCodeNameMap.isEmpty()) {
           for(Reference__c ref : [SELECT Name_Code__c, Name FROM Reference__c WHERE Name_Code__c IN:voltageCodeNameMap.keySet() AND Field__c =:CXE_Constants.REFERENCE_FIELD_VOLTAGE_LEVEL]) {
                voltageLevelMap.put(voltageCodeNameMap.get(ref.Name_Code__c), ref.Name);
            }
        }        

        return voltageLevelMap;
    }

    /* Description: Get Contracted Capacity Scale (this is used for GP only)
     * Parameters: Decimal contractedCapacity
     * Returns: String
     * Author: Jerome To
     * Date Created: MAY-22-17
     */
    private static String getContractedCapacityScaleForGP(Decimal contractedCapacity){

        return ((contractedCapacity >= 40 && contractedCapacity < 200) ? CXE_Constants.CONTRACTED_CAPACITY_SCALE_MEDIUM :
                 ((contractedCapacity >= 200 && contractedCapacity < 750) ? CXE_Constants.CONTRACTED_CAPACITY_SCALE_LARGE :
                    ((contractedCapacity >= 750 && contractedCapacity < 10000) ? CXE_Constants.CONTRACTED_CAPACITY_SCALE_VERY_LARGE : CXE_Constants.CONTRACTED_CAPACITY_SCALE_EXTRA_LARGE)));
    }
}