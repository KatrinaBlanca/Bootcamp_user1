public with sharing class CXE_CP_MYBILLSCONSUMPTIONREPORT {
    
    public class Bills{
        @AuraEnabled
        public List<CXE_Heroku_Model.BillDetail> allBills;
        
        //START CSM-13671 GGrandea 10.12.2017
        /*@AuraEnabled
        public List<CXE_Heroku_Model.BillDetail> unpaidBills;*/
        //END CSM-13671 GGrandea 10.12.2017
        
        @AuraEnabled
        public Date earliestDate;
        
        @AuraEnabled
        public Date oldestDate;
        
        @AuraEnabled
        public Date earliestBillFromDate; // Lisen

        @AuraEnabled
        public Date latestBillToDate; // Lisen
        
        @AuraEnabled
        public Integer billingDaysDifference; // Lisen
    }
    
    @AuraEnabled
    public static CXE_CP_PortalUtility.PortalData getData(){    
        return CXE_CP_PortalUtility.retrievePortalData();
    }
    
    @AuraEnabled
    public static Bills retrieveBillsData(string sinSelected){
        //START CSM-13671 GGrandea 10.12.2017
        //List<CXE_Heroku_Model.BillDetail> bills = CXE_HerokuApps.getAllBillsBySingleSin(sinSelected);
        List<CXE_Heroku_Model.BillDetail> bills = CXE_HerokuApps.getAllConsumptionBySingleSin(sinSelected);
        //END CSM-13671 GGrandea 10.12.2017
        List<CXE_Heroku_Model.BillDetail> ListUserBills = new List<CXE_Heroku_Model.BillDetail>();
        List<CXE_Heroku_Model.BillDetail> ListUnpaidUserBills = new List<CXE_Heroku_Model.BillDetail>();
        
        Date todayDate = Date.valueOf(date.today()) + 1;
        Date last13month = todayDate.addMonths(-13);
        String earliestDate = String.valueOf('1700-08-04');
        String oldestDate = String.valueOf(date.today());

        // START Lisen CSM-14048 20171022
        Date earliestBillFromDate = null;
        Date latestBillToDate = null;
        // END Lisen CSM-14048 20171022

        for( CXE_Heroku_Model.BillDetail Billrec: bills){
            if(Date.valueOf(Billrec.bill_date) <  Date.valueOf(todayDate) ){ // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                //ListUserBills.add(Billrec);
                if(Date.valueOf(Billrec.bill_date) > Date.valueOf(earliestDate) ){ // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                    earliestDate = Billrec.bill_date; // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                }
                //START CSM-13671 GGrandea 10.12.2017
                /*if(Date.valueOf(Billrec.bill_date) < Date.valueOf(oldestDate) ){ // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                   // oldestDate = Billrec.bill_date;
                }
                
                //todo vince
                if(Billrec.collection_status == 'Unpaid'){
                   // ListUnpaidUserBills.add(Billrec);
                }*/
                //END CSM-13671 GGrandea 10.12.2017
            }
            //}

            // START Lisen CSM-14048 20171022
            // get earliest Bill From Date
            if(Billrec.last_bill_date != ''){
                if(earliestBillFromDate == null){
                    earliestBillFromDate = Date.valueOf(Billrec.last_bill_date);
                }else if(earliestBillFromDate > Date.valueOf(Billrec.last_bill_date)){
                    earliestBillFromDate = Date.valueOf(Billrec.last_bill_date);
                }
            }

            // get latest Bill To Date
            if(Billrec.bill_date != ''){   
                if(latestBillToDate == null){
                    latestBillToDate = Date.valueOf(Billrec.bill_date);
                }else if(latestBillToDate < Date.valueOf(Billrec.bill_date)){
                    latestBillToDate = Date.valueOf(Billrec.bill_date);
                }   
            }        
            // END Lisen CSM-14048 20171022
        }
        //Start CSM-12988 Emandolado 9/27/2017
        last13month =  Date.valueOf(earliestDate).addMonths(-13);
        for( CXE_Heroku_Model.BillDetail Billrec: bills){            
            if( Date.valueOf(Billrec.bill_date) > Date.valueOf(last13month) && Date.valueOf(Billrec.bill_date) <  Date.valueOf(todayDate) ){ // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                ListUserBills.add(Billrec);
                if(Date.valueOf(Billrec.bill_date) < Date.valueOf(oldestDate) ){ // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                    oldestDate = Billrec.bill_date; // CSM-13743 Mike Verdad 10/06/2017 (changed due_date to bill_date)
                }
                //START CSM-13671 GGrandea 10.12.2017
                /*//todo vince
                if(Billrec.collection_status == 'Unpaid'){
                    ListUnpaidUserBills.add(Billrec);
                }*/
                //END CSM-13671 GGrandea 10.12.2017
            }
            //}
        }
        //End CSM-12988 Emandolado 9/27/2017
        Bills returnData = new Bills();
        returnData.allBills = ListUserBills;
        //returnData.unpaidBills = ListUnpaidUserBills; //CSM-13671 GGrandea 10.12.2017
        returnData.earliestDate = Date.valueOf(oldestDate);
        returnData.oldestDate = Date.valueOf(earliestDate);

        // START Lisen CSM-14048 20171022
        returnData.earliestBillFromDate = earliestBillFromDate; 
        returnData.latestBillToDate = latestBillToDate; 

        if(earliestBillFromDate != null && latestBillToDate != null){
            returnData.billingDaysDifference = earliestBillFromDate.daysBetween(latestBillToDate);
        }else{
            returnData.billingDaysDifference = 0;
        }
        // END Lisen CSM-14048 20171022

        return returnData;
    }
}