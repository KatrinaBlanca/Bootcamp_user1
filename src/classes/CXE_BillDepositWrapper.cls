/* Description: Bill deposit wrapper for computations
 * Author: Michael Lasala
 * Date Created: MAR-14-17
 * Updated : MAY-12-17  Jerome To
 */
 public with sharing class CXE_BillDepositWrapper {
    
    

    @AuraEnabled public Decimal appliedLoad;
    @AuraEnabled public String rate;
    //@AuraEnabled public Decimal equivalentMonthlyConsumption;
    @AuraEnabled public String municipality;
    @AuraEnabled public String province;

    @AuraEnabled public String isLocalFranchiseTax;
    @AuraEnabled public String isLifelineDiscount;
    @AuraEnabled public String isLifeLineSubsidy;
    @AuraEnabled public String isSCSubsidy;
    @AuraEnabled public String isEnergyTax;
    @AuraEnabled public String isZeroRated;
    //@AuraEnabled public String isSpecialDiscount;
    //@AuraEnabled public String isSCID;
    //@AuraEnabled public String isSCHD;

    @AuraEnabled public Decimal priceGenerationCharge;
    @AuraEnabled public Decimal amountGenerationCharge;

    @AuraEnabled public Decimal pricePowerActReduction;
    @AuraEnabled public Decimal amountPowerActReduction;
    
    @AuraEnabled public Decimal pricePrevMonthAdj;
    @AuraEnabled public Decimal amountPrevMonthAdj;

    @AuraEnabled public Decimal priceTransmissionCharge;
    @AuraEnabled public Decimal amountTransmissionCharge;

    @AuraEnabled public Decimal priceTCVAT;
    @AuraEnabled public Decimal amountTCVAT;

    @AuraEnabled public Decimal priceTCnonVAT;
    @AuraEnabled public Decimal amountTCnonVAT;

    @AuraEnabled public Decimal priceSystemLossCharge;
    @AuraEnabled public Decimal amountSystemLossCharge;

    @AuraEnabled public Decimal baseFixedSupplyCharge;
    @AuraEnabled public Decimal priceFixedSupplyCharge;
    @AuraEnabled public Decimal amountFixedSupplyCharge;

    @AuraEnabled public Decimal priceSupplyChargekWh;
    @AuraEnabled public Decimal amountSupplyChargekWh;

    @AuraEnabled public Decimal baseLifelineDiscount;
    @AuraEnabled public Decimal priceLifelineDiscount;
    @AuraEnabled public Decimal amountLifelineDiscount;

    @AuraEnabled public Decimal priceLifelineRateSubsidy;
    @AuraEnabled public Decimal amountLifelineRateSubsidy;

    @AuraEnabled public Decimal baseSeniorCitizenSubsidy;
    @AuraEnabled public Decimal priceSeniorCitizenSubsidy;
    @AuraEnabled public Decimal amountSeniorCitizenSubsidy;

    @AuraEnabled public Decimal baseLocalFranchiseTax;
    @AuraEnabled public Decimal priceLocalFranchiseTax;
    @AuraEnabled public Decimal amountLocalFranchiseTax;

    @AuraEnabled public Decimal priceVATGenerationCost;
    @AuraEnabled public Decimal amountVATGenerationCost;

    @AuraEnabled public Decimal priceVATTransmissionCharge;
    @AuraEnabled public Decimal amountVATTransmissionCharge;

    @AuraEnabled public Decimal priceVATSystemLossCharge;
    @AuraEnabled public Decimal amountVATSystemLossCharge;

    //@AuraEnabled public Decimal priceVATLifelineRateSubsidy;
    //@AuraEnabled public Decimal amountVATVATLifelineRateSubsidy;

    @AuraEnabled public Decimal priceVATPowerActReduction;
    @AuraEnabled public Decimal amountVATPowerActReduction;

    @AuraEnabled public Decimal baseVATDistributionRevenueAmount;
    @AuraEnabled public Decimal priceVATDistributionRevenueAmount;
    @AuraEnabled public Decimal amountVATDistributionRevenueAmount;

    @AuraEnabled public Decimal baseVATSubsidies;
    @AuraEnabled public Decimal priceVATSubsidies;
    @AuraEnabled public Decimal amountVATSubsidies;

    @AuraEnabled public Decimal priceMissionaryCharge;
    @AuraEnabled public Decimal amountMissionaryCharge;

    @AuraEnabled public Decimal priceEnvironmentalCharge;
    @AuraEnabled public Decimal amountEnvironmentalCharge;

    @AuraEnabled public Decimal priceDUsStrandedCost;
    @AuraEnabled public Decimal amountDUsStrandedCost;

    @AuraEnabled public Decimal priceFitAll;
    @AuraEnabled public Decimal amountFitAll;

    @AuraEnabled public Decimal baseVATSales;
    @AuraEnabled public Decimal priceVATSales;
    @AuraEnabled public Decimal baseVATZero;
    @AuraEnabled public Decimal baseVATExempt;
    @AuraEnabled public Decimal baseTotalBillAmount;
    @AuraEnabled public Decimal amountTotalBillAmount;
    @AuraEnabled public Decimal totalCurrentAmount;
    //@AuraEnabled public Decimal totalCurrentAmountInc;


    // START CSM-166 Added by Jerome To MAY-12-17 

    
    @AuraEnabled public Decimal demandFactor;
    @AuraEnabled public Decimal loadFactor;
    @AuraEnabled public Decimal contractedCapacity;
    @AuraEnabled public Decimal kwHConsumption;
    @AuraEnabled public Decimal kwDemand;

    @AuraEnabled public String contractedCapacityScale;
    @AuraEnabled public Decimal roundedTotalAmount;
    @AuraEnabled public Decimal priceDistributionCharge;
    @AuraEnabled public Decimal amountDistributionCharge;       
    @AuraEnabled public Decimal priceDistributionDemandCharge;
    @AuraEnabled public Decimal amountDistributionDemandCharge;
    @AuraEnabled public Decimal priceDistributionEnergyCharge;
    @AuraEnabled public Decimal amountDistributionEnergyCharge;

    @AuraEnabled public Decimal priceFixedMeteringCharge;
    @AuraEnabled public Decimal amountFixedMeteringCharge;

    @AuraEnabled public Decimal priceMeteringCharge;
    @AuraEnabled public Decimal amountMeteringCharge;

    @AuraEnabled public Decimal priceLifeLineSubsidy;
    @AuraEnabled public Decimal amountLifeLineSubsidy;

    @AuraEnabled public String voltageLevel;

    @AuraEnabled public Decimal priceCrossSubsidyCharge;
    @AuraEnabled public Decimal amountCrossSubsidyCharge;

    @AuraEnabled public Decimal priceNPCStrandedDebts;
    @AuraEnabled public Decimal amountNPCStrandedDebts;

    @AuraEnabled public Decimal priceNPCStrandedContractCosts;
    @AuraEnabled public Decimal amountNPCStrandedContractCosts;

    @AuraEnabled public Decimal priceEqualizationTaxesAndRoyalties;
    @AuraEnabled public Decimal amountEqualizationTaxesAndRoyalties;

    @AuraEnabled public Decimal pricePowerFactorAdjustment;
    @AuraEnabled public Decimal amountPowerFactorAdjustment;

    @AuraEnabled public Decimal baseFixedMeteringCharge;

    @AuraEnabled public Decimal priceTRAC;
    @AuraEnabled public Decimal amountTRAC;

    @AuraEnabled public Decimal basedLFT;
    @AuraEnabled public Decimal priceLFT;
    @AuraEnabled public Decimal amountLFT;

    @AuraEnabled public Boolean hasGenerationCharge;
    @AuraEnabled public Boolean hasTransmissionCharge;
    @AuraEnabled public Boolean hasSystemLossCharge;
    @AuraEnabled public Boolean hasDistributionCharge;
    @AuraEnabled public Boolean hasDistributionDemandCharge;
    @AuraEnabled public Boolean hasDistributionEnergyCharge;
    @AuraEnabled public Boolean hasFixedMeteringCharge;
    @AuraEnabled public Boolean hasMeteringCharge;
    @AuraEnabled public Boolean hasFixedSupplyCharge;
    @AuraEnabled public Boolean hasSupplyCharge;
    @AuraEnabled public Boolean hasPowerFactorAdjustment;
    @AuraEnabled public Boolean hasLifelineRateSubsidy;
    @AuraEnabled public Boolean hasCrossSubsidyCharge;
    @AuraEnabled public Boolean hasSeniorCitizenSubsidy;
    @AuraEnabled public Boolean hasVATOnGenerationCharge;
    @AuraEnabled public Boolean hasVATOnTransmissionCharge;
    @AuraEnabled public Boolean hasVATOnSystemLossCharge;
    @AuraEnabled public Boolean hasVATOnDistributionRevenueAmount;
    @AuraEnabled public Boolean hasVATOnSubsidiesAndOthers;
    @AuraEnabled public Boolean hasMissionaryElectrificationCharge;
    @AuraEnabled public Boolean hasEnvironmentalFund;
    @AuraEnabled public Boolean hasNPCStrandedDebts;
    @AuraEnabled public Boolean hasNPCStrandedContractCost;
    @AuraEnabled public Boolean hasDUsStrandedContractCost;
    @AuraEnabled public Boolean hasEqualizationTaxesAndRoyalties;
    @AuraEnabled public Boolean hasFiTAll;
    @AuraEnabled public Boolean hasLFT;
    @AuraEnabled public Boolean hasTRAC;

    @AuraEnabled public Boolean getIsAdmin() {
        //List<User> uList = [SELECT firstname FROM user WHERE Id=:userinfo.getuserid() AND firstname = 'Jerome'];
        return [SELECT PermissionsModifyAllData FROM Profile WHERE Id = :UserInfo.getProfileId()].PermissionsModifyAllData;
        //return !uList.isEmpty();
    }

    //@AuraEnabled public Decimal distributionDemandCharge;

    // END CSM-166 Added by Jerome To MAY-12-17

    public CXE_BillDepositWrapper() {        
        this.baseFixedSupplyCharge = 0;
        this.baseFixedMeteringCharge = 0;
        this.appliedLoad = 0;
        this.rate = '';
        //this.equivalentMonthlyConsumption = 0;
        this.municipality = '';
        this.province = '';
        this.contractedCapacityScale = '';

        this.isLocalFranchiseTax = CXE_Constants.OPTION_NO;
        this.isLifelineDiscount = CXE_Constants.OPTION_NO;
        this.isLifeLineSubsidy = CXE_Constants.OPTION_NO;
        this.isSCSubsidy = CXE_Constants.OPTION_NO;
        this.isEnergyTax = CXE_Constants.OPTION_NO;
        this.isZeroRated = CXE_Constants.OPTION_NO;
        //this.isSpecialDiscount = CXE_Constants.OPTION_NO;
        //this.isSCID = CXE_Constants.OPTION_NO;
        //this.isSCHD = CXE_Constants.OPTION_NO;

        this.priceGenerationCharge = 0;
        this.amountGenerationCharge = 0;

        this.pricePowerActReduction = 0;
        this.amountPowerActReduction = 0;
        
        this.pricePrevMonthAdj = 0;
        this.amountPrevMonthAdj = 0;

        this.priceTransmissionCharge = 0;
        this.amountTransmissionCharge = 0;

        this.priceTCVAT = 0;
        this.amountTCVAT = 0;

        this.priceTCnonVAT = 0;
        this.amountTCnonVAT = 0;

        this.priceSystemLossCharge = 0;
        this.amountSystemLossCharge = 0;

        this.baseFixedSupplyCharge = 0;
        this.priceFixedSupplyCharge = 0;
        this.amountFixedSupplyCharge = 0;

        this.priceSupplyChargekWh = 0;
        this.amountSupplyChargekWh = 0;

        this.baseLifelineDiscount = 0;
        this.priceLifelineDiscount = 0;
        this.amountLifelineDiscount = 0;

        this.priceLifelineRateSubsidy = 0;
        this.amountLifelineRateSubsidy = 0;

        this.baseSeniorCitizenSubsidy = 0;
        this.priceSeniorCitizenSubsidy = 0;
        this.amountSeniorCitizenSubsidy = 0;

        this.baseLocalFranchiseTax = 0;
        this.priceLocalFranchiseTax = 0;
        this.amountLocalFranchiseTax = 0;

        this.priceVATGenerationCost = 0;
        this.amountVATGenerationCost = 0;

        this.priceVATTransmissionCharge = 0;
        this.amountVATTransmissionCharge = 0;

        this.priceVATSystemLossCharge = 0;
        this.amountVATSystemLossCharge = 0;

        //this.priceVATLifelineRateSubsidy = 0;
        //this.amountVATVATLifelineRateSubsidy = 0;

        this.priceVATPowerActReduction = 0;
        this.amountVATPowerActReduction = 0;

        this.baseVATDistributionRevenueAmount = 0;
        this.priceVATDistributionRevenueAmount = 0;
        this.amountVATDistributionRevenueAmount = 0;

        this.baseVATSubsidies = 0;
        this.priceVATSubsidies = 0;
        this.amountVATSubsidies = 0;

        this.priceMissionaryCharge = 0;
        this.amountMissionaryCharge = 0;

        this.priceEnvironmentalCharge = 0;
        this.amountEnvironmentalCharge = 0;

        this.priceDUsStrandedCost = 0;
        this.amountDUsStrandedCost = 0;

        this.priceFitAll = 0;
        this.amountFitAll = 0;

        this.baseVATSales = 0;
        this.priceVATSales = 0;
        this.baseVATZero = 0;
        this.baseVATExempt = 0;
        this.baseTotalBillAmount = 0;
        this.amountTotalBillAmount = 0;
        this.totalCurrentAmount = 0;
        //this.totalCurrentAmountInc = 0;

        // START CSM-166 Added by Jerome To MAY-12-17 
        
        this.hasGenerationCharge = true;
        this.hasTransmissionCharge = true;
        this.hasSystemLossCharge = true;
        this.hasSeniorCitizenSubsidy = true;
        this.hasVATOnGenerationCharge = true;
        this.hasVATOnTransmissionCharge = true;
        this.hasVATOnSystemLossCharge = true;
        this.hasVATOnDistributionRevenueAmount = true;
        this.hasVATOnSubsidiesAndOthers = true;
        this.hasMissionaryElectrificationCharge = true;
        this.hasEnvironmentalFund = true;
        this.hasNPCStrandedContractCost = true;
        this.hasNPCStrandedDebts = true;
        this.hasDUsStrandedContractCost = true;
        this.hasEqualizationTaxesAndRoyalties = true;
        this.hasFiTAll = true;
        this.hasLFT = true;
        this.hasTRAC = true;
        this.hasFixedMeteringCharge = true;
        this.hasFixedSupplyCharge = true;
        this.hasLifelineRateSubsidy = true;

        //this.hasDistributionCharge = false;
        //this.hasDistributionDemandCharge = false;
        //this.hasDistributionEnergyCharge = false;
        //this.hasFixedMeteringCharge = false;
        //this.hasPowerFactorAdjustment = false;
        
        this.hasMeteringCharge = false;
        this.hasSupplyCharge = false;
        this.hasDistributionCharge = false;           
        this.hasDistributionDemandCharge = false;
        this.hasDistributionEnergyCharge = false;
        this.hasPowerFactorAdjustment = false;
        this.hasCrossSubsidyCharge = false;

        this.kwHConsumption = 0;
        this.kwDemand = 0;
        this.voltageLevel = '';
        this.demandFactor = 0;
        this.loadFactor = 0;
        this.contractedCapacity = 0;

        this.priceDistributionCharge = 0;
        this.amountDistributionCharge = 0;       
        this.amountdistributionDemandCharge = 0;
        this.amountdistributionEnergyCharge = 0;
        this.priceFixedMeteringCharge = 0;
        this.amountFixedMeteringCharge = 0;
        this.priceMeteringCharge = 0;
        this.amountMeteringCharge = 0;
        this.priceLifeLineSubsidy = 0;
        this.amountLifeLineSubsidy = 0;
        this.priceCrossSubsidyCharge = 0;
        this.amountCrossSubsidyCharge = 0;
        this.priceNPCStrandedDebts = 0;
        this.amountNPCStrandedDebts = 0;
        this.priceNPCStrandedContractCosts = 0;
        this.amountNPCStrandedContractCosts = 0;
        this.priceEqualizationTaxesAndRoyalties = 0;
        this.amountEqualizationTaxesAndRoyalties = 0;
        this.pricePowerFactorAdjustment = 0;
        this.amountPowerFactorAdjustment = 0;
        this.baseFixedMeteringCharge = 0;
        this.priceTRAC = 0;
        this.amountTRAC = 0;
        this.basedLFT = 0;
        this.priceLFT = 0;
        this.amountLFT = 0;
        this.roundedTotalAmount = 0;

        // END CSM-166 Added by Jerome To MAY-12-17
    }
}