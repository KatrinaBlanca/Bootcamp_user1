public without sharing class CXE_CP_PaymentHistory { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    public class paymentList implements Comparable{ 
        @AuraEnabled
        public String PaymentDate;
        
        @AuraEnabled
        public String PaymentReference;
        
        @AuraEnabled
        public String PaymentStatus;
         
        
        @AuraEnabled
        public String PaymentOffice;
        
        @AuraEnabled
        public String PaymentMode;
        
        @AuraEnabled
        public decimal AmountPaid; //CSM-12437 Emandolado 9/5/2017
        
        @AuraEnabled
        public String PostingDate;
        
        //vincent sorting code 
        /* public Integer compareTo(Object compareTo) {
            paymentList compareToPay = (paymentList)compareTo;
            if (PostingDate == compareToPay.PostingDate) return 0;
            if (PostingDate < compareToPay.PostingDate) return 1;
            return -1;        
        } */
        
        //Start CSM-12588 Emandolado 9/15/2017
         public Integer compareTo(Object compareTo) {
             /* 
            paymentList compareToPay = (paymentList)compareTo;
            if (PaymentDate == compareToPay.PaymentDate) return 0;
            if (PaymentDate < compareToPay.PaymentDate) return 1;
            return -1;        */
             //start update on 9/20/2017
             paymentList compareToPay = (paymentList)compareTo;
             Date compareHere = date.parse(PaymentDate);
             Date compareThis = date.parse(compareToPay.PaymentDate);
             if (compareHere == compareThis) return 0;
             if (compareHere < compareThis) return 1;
             return -1;      
             //end update on 9/20/2017
             
        }
        //End CSM-12588 Emandolado 9/15/2017
    }
    
    public class paymentrecordList{ 
        @AuraEnabled
        public List<paymentList> paymentList;
        
        @AuraEnabled
        public integer recordPagenum;    
    }
    
    public class returnDetails{
        @AuraEnabled
        public List<paymentrecordList> paymentrecordList;
        
        @AuraEnabled
        public List<paymentList> allData;
        
        @AuraEnabled
        public List<CXE_Heroku_Model.PaymentDetail> HerokuDat;
    }
    
    @AuraEnabled
    public static returnDetails retrievePayment(){
        
        try{
            Datetime earliestEnrollmentDate; //CSM-14036 10.23.2017
            List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c  
                                                                 , CXE_ServiceId__r.SIN__c
                                                                 , CXE_ServiceId__r.Account__c
                                                                 , CXE_ServiceId__r.Payor__c
                                                                 , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                 , CXE_ServiceId__r.Payor__r.AccountId
                                                                 , CXE_Type__c
                                                                 , CXE_IsActive__c
                                                                 , CreatedDate //CSM-13804 GGrandea 10.10.2017
                                                                 From CXE_Service_Enrollment__c 
                                                                 Where CXE_UserId__c=:UserInfo.getUserId()
                                                                 AND CXE_IsActive__c = TRUE]; //CSM-12871 GGrandea 09.21.2017
            
            // get account Ids
            Set<string> accountIds = new Set<string>();
            Set<string> sinIds = new Set<string>();
            returnDetails returnData = new returnDetails(); //CSM-12878 GGrandea 09.22.2017
            Map<String, Datetime> sinEnrolldateMap = new Map<String, Datetime>(); //CSM-13804 GGrandea 10.10.2017
            
            for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                if(enroll.CXE_ServiceId__r.Payor__r.AccountId!=null){
                    accountIds.add(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c);
                    sinIds.add(enroll.CXE_ServiceId__r.SIN__c);
                    sinEnrolldateMap.put(enroll.CXE_ServiceId__r.SIN__c, enroll.CreatedDate); //CSM-13804 GGrandea 10.10.2017
                }
                //START CSM-14036 GGrandea 10.23.2017
                //get earliest enrollment date
                if(earliestEnrollmentDate==null || enroll.CreatedDate < earliestEnrollmentDate){
                    earliestEnrollmentDate = enroll.CreatedDate;
                }
                //END CSM-14036
            }
            List<string> accountList = new List<string>();
            accountList.addAll(accountIds);
            system.debug('>>>>>>>>>>>>>>>>>>>>' + accountIds);
            
            //start CSM-12570  Emandolado 9/18/2017
            //Start CSM-12570 Emandolado 9/15/2017    
            //date startDate = date.today();
            //date endDate = startDate.addMonths(-13);
            date endDate = date.today();
            date startDate = endDate.addMonths(-13);
            //START CSM-14036 GGrandea 10.23.2017
                /****if 'earliest enrollment' date is later than 13monthsFromNow, use 'earliest enrollment' date
                        else use 13monthsFromNow(startDate) for Payment record retrieval    */
            if(startDate<earliestEnrollmentDate){
                startDate = earliestEnrollmentDate.date();
            }
            //END CSM-14036
            system.debug('heredateToday' + startDate);
            system.debug('heredateLast' + endDate);
            //End CSM-12570 9/15/2017
            //End CSM-12570 9/18/2017
            
            if(!accountList.isEmpty()){ //CSM-12878 ***
                //List<CXE_Heroku_Model.PaymentDetail> paymentHolder = CXE_HerokuApps.getAllPaymentsByAccountNos(accountList);
                List<CXE_Heroku_Model.PaymentDetail> paymentHolder = CXE_HerokuApps.getAllPaymentsByAccountNos(accountList,startDate,endDate);//CSM-12570
                List<paymentList> paymentReturn = new List<paymentList>();
                
                //vincent variable for getting last 13 month
                Date todayDate = Date.valueOf(date.today()) + 1;
                //Date last13month = todayDate - 394; //CSM-12570                

                for(CXE_Heroku_Model.PaymentDetail Billrec: paymentHolder){ 
                   // if( Date.valueOf(Billrec.payment.posting_date) > Date.valueOf(last13month) && Date.valueOf(Billrec.payment.posting_date) <  Date.valueOf(todayDate) ){ 
                        decimal paidAmount = 0; //CSM-12437 Emandolado 9/5/2017
                        paymentList insertMe = new paymentList();
                        Date paymentDate; //CSM-13804 GGrandea 10.10.2017
                        
                        if(Billrec.paymentDate != null ){
                            system.debug('ImHere');
                            //start CSM-11165 Emandolado 9/5/2017
                            //Date d = Date.valueOf(Billrec.payment.posting_date);
                            Date d = Date.valueOf(Billrec.paymentDate); //CSM-12483 Emandolado 9/7/2017
                            paymentDate = d; //CSM-13804 GGrandea 10.10.2017
                            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
                     
                            insertMe.PaymentDate = dt;
                            //end CSM-11165 Emandolado 9/5/2017
                        }else{
                            Date d = date.today(); //CSM-12483 Emandolado 9/7/2017
                            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
                            
                            insertMe.PaymentDate = dt;
                        }
                        //if(Billrec.payment.ref_number != null){
                        system.debug('sinIDSSS' + sinIds);
                           
                        if(Billrec.allocation != null){
                            for(CXE_Heroku_Model.allocation alloc: Billrec.allocation){ 
                                boolean hasSin = false;
                                if(sinIds.contains(alloc.serviceNum)){
                                    hasSin = true;
                                }
                                if(hasSin){
                                    paidAmount += alloc.paidAmount;
                                }
                                /*
                                // Start CSM-12428 Emandolado 9/5/2017
                                if(alloc.bill_note != null){ //CSM-12513 GGrandea 09.13.2017
                                    for(CXE_Heroku_Model.Bill_note bill: alloc.bill_note){ //CSM-12513 GGrandea 09.13.2017
                                        if(sinIds.contains(bill.service_number)
                                                && sinEnrolldateMap.get(bill.service_number) < paymentDate ){//CSM-13804 GGrandea 10.10.2017
                                            hasSin = true;
                                            break;
                                        }
                                    } 
                                }
                                // End CSM-12428 Emandolado 9/5/2017
                                if(hasSin){
                                    paidAmount += alloc.paidAmount;
                                }
								*/
                            }
                        }
                        //Start CSM-12824 Emandolado 9/20/2017 
                        insertMe.PaymentReference = '-';
                        if(Billrec.paymentOffice != null){
                            insertMe.PaymentOffice = Billrec.paymentOffice;
                            if(Billrec.paymentOffice.contains('MERALCO ONLINE')){ 
                                
                                if(Billrec.referenceNum != null){
                                    insertMe.PaymentReference = Billrec.referenceNum;
                                }
                                
                            }
                        }
                        //End CSM-12824 Emandolado 9/20/2017
                        if(Billrec.paymentMode != null){
                            insertMe.PaymentMode = Billrec.paymentMode;
                        }
                        if(paidAmount != null){
                            insertMe.AmountPaid = paidAmount;
                        }
                        if(Billrec.postingDate != 'null' ){
                            //start CSM-11165 Emandolado 9/5/2017
                            system.debug('postingdatecheker');
                            Date d = Date.valueOf(Billrec.postingDate);
                            String dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/dd/YYYY');
                            insertMe.PostingDate = dt;
                            //stop CSM-11165 Emandolado 9/5/2017
                            // START CSM-14393 Jerome To 11/10/2017 updated to collectionStatus
                            //if(Billrec.paymentStatus !=null){
                            //    insertMe.PaymentStatus = Billrec.paymentStatus;
                            if(Billrec.collectionStatus !=null){
                                insertMe.PaymentStatus = Billrec.collectionStatus;
                            // END CSM-14393 Jerome To 11/10/2017 updated to collectionStatus
                            }else{
                                insertMe.PaymentStatus = 'uknown status';
                            }
                        }else{
                            insertMe.PostingDate = '-';
                            //insertMe.PaymentStatus = 'Pending Payment Status'; 
                            insertMe.PaymentStatus = 'Pending Payment Posting'; //R2C JFERNANDEZ 1252017 - Changed Status to Posting
                        }
                    	system.debug('samplesample' + insertMe);
                        if(paidAmount > 0){
                            paymentReturn.add(insertMe);
                        }
                        
                    //}
                }
                paymentReturn.sort();
                integer pagination = 1;
                List<paymentrecordList> paymentRecords = new List<paymentrecordList>();
                List<paymentList> paymentTemp = new List<paymentList>();
                integer loopme = 1;
                for(integer i = 0 ; i < paymentReturn.size() ;i++){
                    paymentTemp.add(paymentReturn[i]);
                    if(loopme == 13){
                        paymentrecordList paymentRecordsTemp = new paymentrecordList();
                        paymentRecordsTemp.recordPagenum = pagination;
                        paymentRecordsTemp.paymentList = paymentTemp;
                        paymentRecords.add(paymentRecordsTemp);
                        pagination++;
                        paymentTemp = new List<PaymentList>();
                        loopme = 0;
                    }
                    else if(i == paymentReturn.size() - 1 && loopme != 13){
                        paymentrecordList paymentRecordsTemp = new paymentrecordList();
                        paymentRecordsTemp.recordPagenum = pagination;
                        paymentRecordsTemp.paymentList = paymentTemp;
                        paymentRecords.add(paymentRecordsTemp);
                        pagination++;
                        paymentTemp = new List<PaymentList>();
                    }
                    loopme = loopme + 1;
                    
                }
                system.debug('HERE>>>>>>>>>>>>>>' + paymentRecords);
                //returnDetails returnData = new returnDetails(); //CSM-12878 ***
                returnData.paymentrecordList = paymentRecords;
                returnData.allData = paymentReturn;
                returnData.HerokuDat = paymentHolder;

            }//CSM-12878 ***
                   
            return returnData;
        }
        catch(Exception e){
            ErrorHandlerException.recordException(null, true, 'paymentHistory', 'paymentHistory', e.getMessage());
            return null;
        }
    }
    
    //START R2C CSM-14749 Shayne 12/01/2017
	@AuraEnabled
     public static Boolean retrieveCheckConglomerate(){
         return CXE_CP_PortalUtility.checkIfConglomerateAccount();
     }
     //END R2C CSM-14749 Shayne 12/01/2017
    
}