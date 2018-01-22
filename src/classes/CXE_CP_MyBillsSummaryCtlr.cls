public without sharing class CXE_CP_MyBillsSummaryCtlr { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    //START CSM-14422 RReyes NOV-12-17
    public class SubMap {
        public String key;
        public Decimal subtotal;
        public Decimal prevSubtotal;
        public String accountHasDisabled;
        public String isSingleSINSelected;
        public String isSingleSINAllSelected;
        public String isAllSINSEnrolled;
        public String isAccountSelected;
        public String isDisabled;
        public String contractExternalId;
    }

    public class SelectedInvoice {
        public String accountNum;
        public String serviceNum;
        public String billId;
        public String pendingAmount;
        public String invoiceId;
    }

    public class PayTrans {
        public String accountNum;
        public String serviceNum;
        public String billId;
        public String paymentAmount;
        public String accountId;
    }
    //END CSM-14422 RReyes NOV-12-17

    @AuraEnabled
    public static CXE_CP_PortalUtility.PortalData retrievePortalData(Boolean hasBilling){
        return CXE_CP_PortalUtility.retrievePortalData(hasBilling);
    }
    
    //START R2C CSM-12735 Von Pernicia
    @AuraEnabled
    public static CXE_CP_PaymentPayAsGuest.ReturnData getBillDetails(String validationType, String valuePass, Decimal amountPass){
        
        return CXE_CP_PaymentPayAsGuest.validateData(validationType, valuePass, AmountPass, null);
    }
    //START R2C CSM-12735 Von Pernicia
    
    //START CSM-XXX Wenjun - Mobile Business Service
    //START CSM-10913 RReyes JUL-24-17 - dummy method
    @AuraEnabled
    //START CSM-14260 RReyes NOV-07-17 - changed from retrieveBillingDetails to retrieveBillingDetailsNoParam --
    //-- since lightning calls the one with parameter incase there are 2 or more methods of the same name
    public static List<CXE_Heroku_Model.BillDetail> retrieveBillingDetailsNoParam(){
    //END CSM-14260 RReyes NOV-07-17
        //List<String> sinNos = new List<String>{'918299989876','123454321122'};
        List<String> sinNos = new List<String>();
        Map<String, String> mapSINToAlias = new Map<String, String>();
        Map<String, String> mapContractV10ToExternalId = new Map<String, String>(); //START/END CSM-12705 RReyes OCT-24-17
        
        // get service enrollent records under the userId
        //START CSM-12705 RReyes OCT-24-17 - added Contract_External_ID__c and V10_Account_No__c
        List<CXE_Service_Enrollment__c> listofEnrollments = [Select CXE_ServiceId__c, CXE_ServiceId__r.SIN__c, CXE_Alias__c,
                                                                CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                                                CXE_ServiceId__r.Payor__r.Contract_External_ID__c,
                                                                CXE_ServiceId__r.Payor__c
                                                             From CXE_Service_Enrollment__c 
                                                             Where CXE_UserId__c=:UserInfo.getUserId()
                                                             AND CXE_IsActive__c = true]; //CSM-12878 GGrandea 09.21.2017
        //END CSM-12705 RReyes OCT-24-17 - added Contract_External_ID__c
        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__c!=null && enroll.CXE_ServiceId__r.SIN__c!=null){
                sinNos.add(enroll.CXE_ServiceId__r.SIN__c);
            }
            if(enroll.CXE_ServiceId__r.SIN__c != null){
                if(!mapSINToAlias.containsKey(enroll.CXE_ServiceId__r.SIN__c)){
                    mapSINToAlias.put(enroll.CXE_ServiceId__r.SIN__c, enroll.CXE_Alias__c);
                }   
            }
            //START CSM-12705 RReyes OCT-24-17 
            if(enroll.CXE_ServiceId__c != null && enroll.CXE_ServiceId__r.Payor__c != null){
                if(!String.isBlank(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)
                    && !String.isBlank(enroll.CXE_ServiceId__r.Payor__r.Contract_External_ID__c)){
                    if(!mapContractV10ToExternalId.containsKey(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)){
                        mapContractV10ToExternalId.put(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c, enroll.CXE_ServiceId__r.Payor__r.Contract_External_ID__c);
                    }
                }
            }
            System.debug('>>rr mapContractV10ToExternalId: ' + mapContractV10ToExternalId);
            //END CSM-12705 RReyes OCT-24-17 
        }
        
        List<CXE_Heroku_Model.BillDetail> billingDetails = CXE_HerokuApps.getAllBillsBySinNos(sinNos);
                
        return processingBillNotes(billingDetails, mapSINToAlias, mapContractV10ToExternalId);
    }
    
 
    //Method for get Bills by Service Num
    @AuraEnabled
    public static List<CXE_Heroku_Model.BillDetail> retrieveBillingDetails(String serviceNum){
        List<String> lstSINNum = new List<String>{serviceNum};
        Map<String, String> mapSINToAlias = new Map<String, String>();
        Map<String, String> mapContractV10ToExternalId = new Map<String, String>();
        
        // get service enrollent records under the userId & servie num
        for(CXE_Service_Enrollment__c enroll : [SELECT CXE_ServiceId__c, CXE_ServiceId__r.SIN__c, CXE_Alias__c, 
                            CXE_ServiceId__r.Payor__r.V10_Account_No__c, CXE_ServiceId__r.Payor__r.Contract_External_ID__c, CXE_ServiceId__r.Payor__c
                            FROM CXE_Service_Enrollment__c 
                            WHERE CXE_UserId__c=:UserInfo.getUserId() AND CXE_ServiceId__r.SIN__c = :serviceNum AND CXE_IsActive__c = true])
        {
            mapSINToAlias.put(enroll.CXE_ServiceId__r.SIN__c, enroll.CXE_Alias__c);
                    
            //START CSM-12705 RReyes OCT-24-17 
            if(enroll.CXE_ServiceId__c != null && enroll.CXE_ServiceId__r.Payor__c != null)
            {
                if(!String.isBlank(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)
                    && !String.isBlank(enroll.CXE_ServiceId__r.Payor__r.Contract_External_ID__c))
                {
                    if(!mapContractV10ToExternalId.containsKey(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c))
                    {
                        mapContractV10ToExternalId.put(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c, enroll.CXE_ServiceId__r.Payor__r.Contract_External_ID__c);
                    }
                }
            }
        }
        
        List<CXE_Heroku_Model.BillDetail> billingDetails = CXE_HerokuApps.getAllBillsBySinNos(lstSINNum); 
        
        return processingBillNotes(billingDetails, mapSINToAlias, mapContractV10ToExternalId);
    }
    
    public static List<CXE_Heroku_Model.BillDetail> processingBillNotes(List<CXE_Heroku_Model.BillDetail> lstRaw, 
                                                                        Map<String, String> mapSINToAlias,
                                                                        Map<String, String> mapContractV10ToExternalId)
    {
        List<CXE_Heroku_Model.BillDetail> lstGrouped = groupBillNotes(lstRaw);
        
        String toolTipMsg;
        Decimal currentAmount;
        Date invoiceDate;
        Date dateFrom = Date.valueOf('2013-12-01');
        Date dateTo = Date.valueOf('2013-12-22');
        
        for(CXE_Heroku_Model.BillDetail bd: lstGrouped){
            currentAmount = 0;
            bd.isSINSelected = 'true';
            bd.isAccountSelected = 'true';
            bd.isSINDisabled = 'false';
            bd.isAccountDisabled = 'false';
            bd.subTotal = 0;
            
            //START CSM-12645 RReyes SEP-28-17 - set default values
            bd.hasDisabledSIN = false;
            bd.isSingleSINSelected = false;
            bd.isSingleSINSelectAll = false;
            bd.allSINsEnrolled = false;
            //END CSM-12645 RReyes SEP-28-17 - set default values
            toolTipMsg = '';
            //START CSM-14172 GGrandea 10.30.2017
            if(bd.toolTipMessage!=null){
                toolTipMsg = bd.toolTipMessage;
            }
            //END CSM-14172
            invoiceDate = Date.valueOf(bd.invoice_date);
            bd.contractExternalId = ''; //START/END CSM-12705 RReyes OCT-24-17 
            
        //START CSM-12624 RReyes SEP-18-2017 - changed hardcoded values to Label reference
            //CSM-11105 - #1 IPA            
      //CSM-14172 added toolTipMsg check
      if(bd.collection_status == Label.TOOLTIP_IN_ARRANGEMENTS && toolTipMsg == ''){ //START/END CSM-12354 RReyes - changed from 'In Arrangements' to 'Under Installment Agreement'
                toolTipMsg = CXE_Constants.VIEW_BILL_TOOLTIP_IPA;
            }

            //CSM-11099 - #2 TRO
          //  if(bd.due_date == Label.TOOLTIP_TRO_DATE || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo)) && toolTipMsg == ''){ //CSM-14351 Corbes Melvin 11.09.2017
            if((bd.due_date == Label.TOOLTIP_TRO_DATE || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo))) && toolTipMsg == ''){
                toolTipMsg += CXE_Constants.VIEW_BILL_TOOLTIP_TRO;
            }

            //CSM-11087 - #3 Under Review - Pending criteria
            if(bd.is_under_complaint == Label.TOOLTIP_UNDER_COMPLAINT  && toolTipMsg == ''){
                toolTipMsg += CXE_Constants.VIEW_BILL_TOOLTIP_UNDER_REVIEW;
            }

            //CSM-11093 - #4 APA
            if(bd.collection_status == Label.TOOLTIP_FOR_BANK_PROCESSING  && toolTipMsg == ''){ //START/END CSM-12355 RReyes - changed from 'Set to Bank for Processing' to 'For bank processing'
                toolTipMsg = CXE_Constants.VIEW_BILL_TOOLTIP_APA;
            }

            //CSM-11111 - #5 Bill Deposit
            if(bd.bill_type == 'Deposit'  && toolTipMsg == ''){ //START/END CSM-12353 AUG-29 changed back from bill_type_filter to bill_type 
            // CSM-14040 LISEN Change "Bill Deposit" to "Deposit" (TFGEN10006)
                toolTipMsg = CXE_Constants.VIEW_BILL_TOOLTIP_BILL_DEPOSIT;
            }

            if(toolTipMsg != ''){
                bd.isSINDisabled = 'true';
                bd.isSINSelected = 'false';
                bd.toolTipMessage = toolTipMsg;
            }

            //CSM-11966 - #6 Service Irregularity
            if(bd.bill_type == Label.TOOLTIP_SERVICE_IRREGULARITY  && toolTipMsg == ''){//START/END CSM-12353 AUG-29 changed from bill_type_filter to bill_type
                toolTipMsg = CXE_Constants.VIEW_BILL_TOOLTIP_SERV_IRREG;
                bd.toolTipMessage = toolTipMsg;
            }
      //END CSM-12624 RReyes SEP-18-2017 - changed hardcoded values to Label reference
            //START CSM-14172 GGrandea 10.30.2017
            else if(bd.toolTipMessage==CXE_Constants.VIEW_BILL_TOOLTIP_SERV_IRREG){
                bd.isSINDisabled = 'false';
                bd.isSINSelected = 'true';
            }
            //END CSM-14172
            
            //set current amount to decimal
            if(bd.pending_amount != null && bd.pending_amount != ''){
                currentAmount = Decimal.valueOf(bd.pending_amount);
            }
            
            //disable SIN if already paid or current amount is 0
            if(bd.bill_status_filter == 'Paid' || currentAmount <= 0){
                bd.isSINDisabled = 'true';
                bd.isSINSelected = 'false';
            }
            
            //set alias
            if(mapSINToAlias.containsKey(bd.service_number)){
                bd.alias = mapSINToAlias.get(bd.service_number);
            }

            //START CSM-12705 RReyes OCT-24-17 
            if(bd.account_number != null && bd.account_number != '' && mapContractV10ToExternalId != null){
                if(mapContractV10ToExternalId.containsKey(bd.account_number)){
                    bd.contractExternalId = mapContractV10ToExternalId.get(bd.account_number);
                }
            }
            //END CSM-12705 RReyes OCT-24-17 
        }

        return lstGrouped;      
    }
    //END CSM-XXX Wenjun - Mobile Business Service 
    
    public static List<CXE_Heroku_Model.BillDetail> groupBillNotes(List<CXE_Heroku_Model.BillDetail> initialBillNotes){
        List<CXE_Heroku_Model.BillDetail> updatedBillNotes = new List<CXE_Heroku_Model.BillDetail>();
        List<CXE_Heroku_Model.BillDetail> billNoteToReturn = new List<CXE_Heroku_Model.BillDetail>();
        Map<String, List<CXE_Heroku_Model.BillDetail>> mapInvoiceIdToRecords = new Map<String, List<CXE_Heroku_Model.BillDetail>>();
        Map<String, Decimal> mapInvoiceIdToTotalAmount = new Map<String, Decimal>();
        Map<String, Decimal> mapInvoiceIdToPendingAmount = new Map<String, Decimal>();
        Set<String> unpaidInvoices = new Set<String>();
        Set<String> invoicesWithService = new Set<String>();
        //Set<String> invoicesUnderReview = new Set<String>(); //CSM-14172
        Decimal totalAmount = 0, pendingAmount = 0;
        //START CSM-12629 RReyes SEP-29-17
        Set<String> sinsOverduePayNow = new Set<String>();
        Set<String> sinsOverdueDisconnected = new Set<String>();
        Set<String> sinsOverdueForDisconnection = new Set<String>();
        Set<String> sinsOverdueTerminated = new Set<String>();
        String overduePayNow = Label.CS_OVERDUE;
        String overdueDisconnected = Label.CS_OVERDUE_DISCONNECTED;
        String overdueForDisconnection = Label.CS_OVERDUE_FOR_DISCONNECTION;
        String overdueTerminated = Label.CS_OVERDUE_TERMINATED;
        
        //END CSM-12629 RReyes SEP-29-17
        
        if(initialBillNotes != null){
            for(CXE_Heroku_Model.BillDetail bd : initialBillNotes){
                //do not include cancelled bill status in the calculation
                //Start of  CSM-13805 Corbes Melvin
                //if(bd.bill_status_filter != 'Cancelled'){ //end of CSM-13805
                //if invoice id is null - show bill not as it is - standalone
                if(bd.bill_status != 'Cancelled'){
                    //START CSM-14102 RReyes OCT-26-17
                    bd.hasAnyOverdue = false;
                    bd.hasOverduePayNow = false;
                    bd.hasOverdueForDisconnection = false;
                    bd.hasOverdueDisconnected = false;
                    bd.hasOverdueTerminated = false;
                    //END CSM-14102 RReyes OCT-26-17
                    if(bd.invoice_id == null || bd.invoice_id == 'null' || bd.invoice_id == ''){
                        //START CSM-12629 RReyes SEP-29-17
                        if(bd.collection_status == overduePayNow){
                            bd.hasAnyOverdue = true;
                            bd.hasOverduePayNow = true;
                        }else if(bd.collection_status == overdueDisconnected){
                            bd.hasAnyOverdue = true;
                            bd.hasOverdueDisconnected = true;
                        }else if(bd.collection_status == overdueForDisconnection){
                            bd.hasAnyOverdue = true;
                            bd.hasOverdueForDisconnection = true;
                        }else if(bd.collection_status == overdueTerminated){
                            bd.hasAnyOverdue = true;
                            bd.hasOverdueTerminated = true;
                        }
                        //END CSM-12629 RReyes SEP-29-17
                        updatedBillNotes.add(bd);
                    }else{
                        if(mapInvoiceIdToRecords.containsKey(bd.invoice_id)){
                            mapInvoiceIdToRecords.get(bd.invoice_id).add(bd);
                        }else{
                            mapInvoiceIdToRecords.put(bd.invoice_id, new List<CXE_Heroku_Model.BillDetail>{ bd });
                        }
                        //set invoices with service
                        if(bd.bill_type == 'Service'){ //START/END CSM-12353 AUG-29 changed from bill_type_filter to bill_type
                            if(!invoicesWithService.contains(bd.invoice_id)){
                                invoicesWithService.add(bd.invoice_id);
                            }
                        }
                        //START CSM-12629 RReyes SEP-29-17
                        if(bd.collection_status == overduePayNow){
                            sinsOverduePayNow.add(bd.invoice_id);
                        }else if(bd.collection_status == overdueDisconnected){
                            sinsOverdueDisconnected.add(bd.invoice_id);
                        }else if(bd.collection_status == overdueForDisconnection){
                            sinsOverdueForDisconnection.add(bd.invoice_id);
                        }else if(bd.collection_status == overdueTerminated){
                            sinsOverdueTerminated.add(bd.invoice_id);
                        }
                        //END CSM-12629 RReyes SEP-29-17
                    }
                }
            }
        }
        //START CSM-14172 GGrandea 10.30.2017
        Set<String> invoicesWithIPA = new Set<String>();
        Set<String> invoicesWithTRODue = new Set<String>();
        Set<String> invoicesUnderReview = new Set<String>();
        Set<String> invoicesWithAPA = new Set<String>();
        Set<String> invoicesWithBillDeposit = new Set<String>();
        Set<String> invoicesWithServIrreg = new Set<String>();
        Date troDateFrom = Date.valueOf('2013-12-01');
        Date trodateTo = Date.valueOf('2013-12-22');
        Date invoiceDate;
        //END CSM-14172 GGrandea 10.30.2017
        
        if(!mapInvoiceIdToRecords.isEmpty()){
            for(String invId: mapInvoiceIdToRecords.keySet()){
                totalAmount = 0;
                pendingAmount = 0;
                
                for(CXE_Heroku_Model.BillDetail bd: mapInvoiceIdToRecords.get(invId)){
                    if(bd.total_amount != null){
                        totalAmount += Decimal.valueOf(bd.total_amount);
                    }  
                    if(bd.pending_amount != null && bd.bill_status_filter == 'Unpaid'){
                        pendingAmount += Decimal.valueOf(bd.pending_amount);
                    }
                    if(bd.bill_status_filter == 'Unpaid'){
                        //set unpaid invoice list
                        if(!unpaidInvoices.contains(invId)){
                            unpaidInvoices.add(invId);
                        }
                    }


                    //START CSM-14172 GGrandea 10.30.2017
                    invoiceDate = Date.valueOf(bd.invoice_date);

                    if(bd.collection_status == 'Under Installment Agreement'){
                        invoicesWithIPA.add(invId);
                    }
                    else if(bd.due_date == '2888-12-31' 
                            || (invoiceDate != null && (invoiceDate >= troDateFrom && invoiceDate <= trodateTo)) ){
                        invoicesWithTRODue.add(invId);
                    }
                    else if(bd.is_under_complaint == '1'){
                        invoicesUnderReview.add(invId);
                    }
                    else if(bd.collection_status == 'For bank processing'){
                        invoicesWithAPA.add(invId);
                    }
                    else if(bd.bill_type == 'Deposit'){
                        invoicesWithBillDeposit.add(invId);
                    }
                    else if(bd.bill_type == 'Service Irregularity'){
                        invoicesWithServIrreg.add(invId);
                    }
                    //END CSM-14172
                }
                
                mapInvoiceIdToTotalAmount.put(invId, totalAmount);
                mapInvoiceIdToPendingAmount.put(invId, pendingAmount);
            }
            
            for(String invId: mapInvoiceIdToRecords.keySet()){
                if(mapInvoiceIdToRecords.get(invId).size() == 1){
                    updatedBillNotes.add(mapInvoiceIdToRecords.get(invId)[0]);
                }else if(mapInvoiceIdToRecords.get(invId).size() > 1){
                    for(CXE_Heroku_Model.BillDetail bd: mapInvoiceIdToRecords.get(invId)){
                        //get only the service when 
                        if(invoicesWithService.contains(invId)){
                            if(bd.bill_type == 'Service'){ //START/END CSM-12353 AUG-29 changed from bill_type_filter to bill_type
                                //set Billed Amount (total_amount)
                                if(mapInvoiceIdToTotalAmount.containsKey(invId)){
                                    bd.total_amount = String.valueOf(mapInvoiceIdToTotalAmount.get(invId));
                                }
                                //set Current Amount Due (pending_amount)
                                if(mapInvoiceIdToPendingAmount.containsKey(invId)){
                                    bd.pending_amount = String.valueOf(mapInvoiceIdToPendingAmount.get(invId));
                                }   
                                
                                //set bill_status_filter depending on whether at least one bill not is unpaid
                                if(unpaidInvoices.contains(invId)){
                                    bd.bill_status_filter = 'Unpaid';
                                }else{
                                    bd.bill_status_filter = 'Paid';
                                }
                                
                                if(unpaidInvoices.contains(invId)){
                                    bd.bill_status_filter = 'Unpaid';
                                }
                                //START CSM-14404
                                //START CSM-14172 GGrandea 10.30.2017
                                if(invoicesWithIPA.contains(invId)){
                                    //bd.toolTipMessage = CXE_Constants.VIEW_BILL_TOOLTIP_IPA;
                                    bd.toolTipMessage = 'IPA';
                                }
                                else if(invoicesWithTRODue.contains(invId)){
                                    //bd.toolTipMessage = CXE_Constants.VIEW_BILL_TOOLTIP_TRO;
                                    bd.toolTipMessage = 'TRO';
                                }
                                else if(invoicesUnderReview.contains(invId)){
                                    //bd.toolTipMessage = CXE_Constants.VIEW_BILL_TOOLTIP_UNDER_REVIEW;
                                    bd.toolTipMessage = 'UNDER_REVIEW';
                                }
                                else if(invoicesWithAPA.contains(invId)){
                                    //bd.toolTipMessage = CXE_Constants.VIEW_BILL_TOOLTIP_APA;
                                    bd.toolTipMessage = 'APA';
                                }
                                else if(invoicesWithBillDeposit.contains(invId)){
                                    //bd.toolTipMessage = CXE_Constants.VIEW_BILL_TOOLTIP_BILL_DEPOSIT;
                                    bd.toolTipMessage = 'BD';
                                }
                                else if(invoicesWithServIrreg.contains(invId)){
                                    //bd.toolTipMessage = CXE_Constants.VIEW_BILL_TOOLTIP_SERV_IRREG;
                                    bd.toolTipMessage = 'IRREG';
                                }
                                //END CSM-14172
                                //END CSM-14404
                                
                                updatedBillNotes.add(bd);
                                break;
                            }
                        }else{
                            updatedBillNotes.add(bd);
                        }
                    }
                }
            }
        } //START CSM-14790 by Gavi Grandea 12.14.2017
            
            if(!updatedBillNotes.isEmpty()){
                Date dateTo = date.today();
                Date dateFrom = dateTo.addMonths(-13);
                Date billDate = Date.today().addMonths(-14); //set default to last 14 months
                
                for(CXE_Heroku_Model.BillDetail bd : updatedBillNotes){
                    billDate = Date.today().addMonths(-14);
                    //START CSM-14244 GGrandea 11.21.2017 - change bill_date to invoice_date
                    /*if(bd.bill_date != null || bd.bill_date != ''){
                        billDate = Date.valueOf(bd.bill_date);
                    }*/
                    if(bd.invoice_date != null || bd.invoice_date != ''){
                        billDate = Date.valueOf(bd.invoice_date);
                    }
                    //END CSM-14244
                    
                    //return only unpaid invoices, or paid invoices within the past 13 months
                    if(bd.bill_status_filter == 'Unpaid' || (bd.bill_status_filter == 'Paid' && billDate >= dateFrom)){
                        billNoteToReturn.add(bd);
                    }
                }
            }
        //} //END CSM-14790 by Gavi Grandea 12.14.2017
        
        //System.debug('>>rr: mapInvoiceIdToRecords: ' + mapInvoiceIdToRecords);
        System.debug('>>rr: initialBillNotes: ' + initialBillNotes);
        for(CXE_Heroku_Model.BillDetail bd : initialBillNotes){
            System.debug('>>rr: initial bd: ' + bd);
        }
        System.debug('>>rr: unpaidInvoices: ' + unpaidInvoices);
        System.debug('>>rr: invoicesWithService: ' + invoicesWithService);
        System.debug('>>rr: mapInvoiceIdToTotalAmount: ' + mapInvoiceIdToTotalAmount);
        System.debug('>>rr: mapInvoiceIdToPendingAmount: ' + mapInvoiceIdToPendingAmount);
        System.debug('>>rr: updatedBillNotes: ' + billNoteToReturn);

        //START CSM-12629 RReyes - SEP-29-17
        System.debug('>>rr: sinsOverduePayNow: ' + sinsOverduePayNow);
        System.debug('>>rr: sinsOverdueDisconnected: ' + sinsOverdueDisconnected);
        System.debug('>>rr: sinsOverdueForDisconnection: ' + sinsOverdueForDisconnection);
        System.debug('>>rr: sinsOverdueTerminated: ' + sinsOverdueTerminated);
        for(CXE_Heroku_Model.BillDetail bd : billNoteToReturn){
            //START CSM-14102 RReyes OCT-26-17 - commentedout and moved code up
            /*bd.hasAnyOverdue = false;
            bd.hasOverduePayNow = false;
            bd.hasOverdueForDisconnection = false;
            bd.hasOverdueDisconnected = false;
            bd.hasOverdueTerminated = false;
            */
            //END CSM-14102 RReyes OCT-26-17 - commentedout and moved code up
            if(bd.invoice_id != null && bd.invoice_id != ''){
                if(sinsOverduePayNow.contains(bd.invoice_id)){
                    bd.hasAnyOverdue = true;
                    bd.hasOverduePayNow = true;
                }
                if(sinsOverdueDisconnected.contains(bd.invoice_id)){
                    bd.hasAnyOverdue = true;
                    bd.hasOverdueDisconnected = true;
                }
                if(sinsOverdueForDisconnection.contains(bd.invoice_id)){
                    bd.hasAnyOverdue = true;
                    bd.hasOverdueForDisconnection = true;
                }
                if(sinsOverdueTerminated.contains(bd.invoice_id)){
                    bd.hasAnyOverdue = true;
                    bd.hasOverdueTerminated = true;
                }
                
                //START CSM-14725 jfernandez NOV-30-17 added for the start and end date in the tab3
                String stringMonthStart;
                String stringMonthEnd;
                date dateStart = Date.valueOf(bd.last_bill_date);
                date dateEnd = Date.valueOf(bd.bill_date);
                
                if(dateStart.month() == 1){
                    stringMonthStart = 'Jan';
                }else if(dateStart.month() == 2){
                    stringMonthStart = 'Feb';
                }else if(dateStart.month() == 3){
                    stringMonthStart = 'Mar';
                }else if(dateStart.month() == 4){
                    stringMonthStart = 'Apr';
                }else if(dateStart.month() == 5){
                    stringMonthStart = 'May';
                }else if(dateStart.month() == 6){
                    stringMonthStart = 'Jun';
                }else if(dateStart.month() == 7){
                    stringMonthStart = 'Jul';
                }else if(dateStart.month() == 8){
                    stringMonthStart = 'Aug';
                }else if(dateStart.month() == 9){
                    stringMonthStart = 'Sep';
                }else if(dateStart.month() == 10){
                    stringMonthStart = 'Oct';
                }else if(dateStart.month() == 11){
                    stringMonthStart = 'Nov';
                }else if(dateStart.month() == 12){
                    stringMonthStart = 'Dec';
                }
                
                if(dateEnd.month() == 1){
                    stringMonthEnd = 'Jan';
                }else if(dateEnd.month() == 2){
                    stringMonthEnd = 'Feb';
                }else if(dateEnd.month() == 3){
                    stringMonthEnd = 'Mar';
                }else if(dateEnd.month() == 4){
                    stringMonthEnd = 'Apr';
                }else if(dateEnd.month() == 5){
                    stringMonthEnd = 'May';
                }else if(dateEnd.month() == 6){
                    stringMonthEnd = 'Jun';
                }else if(dateEnd.month() == 7){
                    stringMonthEnd = 'Jul';
                }else if(dateEnd.month() == 8){
                    stringMonthEnd = 'Aug';
                }else if(dateEnd.month() == 9){
                    stringMonthEnd = 'Sep';
                }else if(dateEnd.month() == 10){
                    stringMonthEnd = 'Oct';
                }else if(dateEnd.month() == 11){
                    stringMonthEnd = 'Nov';
                }else if(dateEnd.month() == 12){
                    stringMonthEnd = 'Dec';
                }
                
                if(dateStart.month() == dateEnd.month()){
                    bd.billStartEndDate = stringMonthStart + ' ' + String.valueOf(dateStart.day()) + '-' +  String.valueOf(dateEnd.day()) + ' ' + String.valueOf(dateStart.year());
                }else{
                    bd.billStartEndDate = stringMonthStart + ' ' + String.valueOf(dateStart.day()) + ' ' + String.valueOf(dateStart.year()) + ' - ' + stringMonthEnd + ' ' + String.valueOf(dateEnd.day()) + ' ' + String.valueOf(dateEnd.year());
                }
                //end CSM-14725 NOV-30-17
            }else{

            }    
        }
        //END CSM-12629 RReyes - SEP-29-17
        return billNoteToReturn;
    }
    //END CSM-10913 RReyes JUL-24-17 - dummy method
    
    
    //START CSM-12680 JFERNANDEZ 9292017
    @AuraEnabled
    public static Map<String, Object> convenienceFee(String amount){
        system.debug('CONVENIENCE FEE');
        try{
            system.debug('CONVENIENCE FEE TRY');
            return (Map<String, Object>) JSON.deserializeUntyped(
                CXE_HerokuApps.convenienceFee(amount)
            );
        }
        catch(CXE_HerokuApps.HerokuException hx){
            system.debug('CONVENIENCE FEE CATCH');
            if(hx.asJson() != null) return hx.asJson();
            
            throw hx;
        }
    }
    //END CSM-12680 JFERNANDEZ 9292017
    @AuraEnabled
    public static Map<String, Object> pay(String token, String amount, String fee, String total, String fname,String emailPass ,String paymentMode ,String paymentOffice,String address ,List<Object> paymentTransaction){
        try{
            return (Map<String, Object>) JSON.deserializeUntyped(
                // Start R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
                CXE_HerokuApps.cc_pay(token, amount, fee, total, fname,emailPass,paymentMode,paymentOffice,address,paymentTransaction,CXE_Constants.PAYMENT_ORIGIN_PORTAL)
                // End R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
            );    
        }
        catch(CXE_HerokuApps.HerokuException hx){
            if(hx.asJson() != null) return hx.asJson();
            
            throw hx;
        }
    }

    //START CSM-14422 RReyes NOV-12-17
    @AuraEnabled
    public static Map<String, Object> payV2(String token, String amount, String fee, String total, String fname,
        String emailPass ,String paymentMode ,String paymentOffice, String address , List<Object> paymentTransaction, 
        String paymentType, String invoiceId, String billId, String acctNum, String servNum, String payAmount,
        String subTotalMap, String lstSelectedInvoices, String lstSelectedSINS,
        String lstSelectedBillIds, String lstSelectedInvoiceNums, String invoiceNumber){
        
        String ptype = '';
        String payAmountType = '';
        List<Object> paymentTransactionToPass = new List<Object>();
        if(paymentType == 'Advance' || paymentType == 'Other'){
            ptype = 'Advance or Other or Pay As Guest';
            paymentTransactionToPass = paymentTransaction;
            System.debug('>>rr paymentTransactionToPass: ' + paymentTransactionToPass);
        }else if(paymentType == 'ViewBill'){
            ptype = 'View Bill';
            List<PayTrans> lstPayTrans = new List<PayTrans>();
            String accountId = '';
            if(acctNum != null && acctNum != ''){
                List<Contract> contrList = [SELECT Contract_External_ID__c FROM Contract WHERE V10_Account_No__c =:acctNum LIMIT 1];
                if(!contrList.isEmpty()){
                    accountId = contrList[0].Contract_External_ID__c;
                }
            }
            if(invoiceId != null && invoiceId != ''){
                List<CXE_Heroku_Model.BillDetail> billSums = CXE_HerokuApps.getAllBillsBySingleSin(servNum);
                PayTrans pt = new PayTrans();
                for(CXE_Heroku_Model.BillDetail bd: billSums){
                    if(bd.bill_status != 'Cancelled' && bd.invoice_id == invoiceId && bd.pending_amount != '0'){
                        pt = new PayTrans();
                        pt.accountNum = bd.account_number;
                        pt.serviceNum = null; //START/END CSM-14422
                        pt.billId = bd.id;
                        pt.paymentAmount = bd.pending_amount;
                        pt.accountId = accountId;
                        lstPayTrans.add(pt);
                    }
                }
            }else{
                //create pay trans
                PayTrans pt = new PayTrans();
                pt.accountNum = acctNum;
                pt.serviceNum = null; //START/END CSM-14422
                pt.billId = billId;
                pt.paymentAmount = payAmount;
                pt.accountId = accountId;
                lstPayTrans.add(pt);
            }
            System.debug('>>rr invoiceId: ' + invoiceId);
            System.debug('>>rr billId: ' + billId);
            System.debug('>>rr acctNum: ' + acctNum);
            System.debug('>>rr servNum: ' + servNum);
            System.debug('>>rr paymentAmount: ' + payAmount);

            if(!lstPayTrans.isEmpty()){
                paymentTransactionToPass = (List<Object>)lstPayTrans;
            }
            System.debug('>>rr lstPayTrans: ' + lstPayTrans);
            System.debug('>>rr paymentTransactionToPass: ' + paymentTransactionToPass);
            //identify account Id here
        }else if(paymentType == 'PayAsGuestInvoice'){
            ptype = 'Pay As Guest thru Invoice No';
            System.debug(payAmount);
            System.debug('>>rr invoiceNumber: ' + invoiceNumber);
            List<PayTrans> lstPayTrans = new List<PayTrans>();
            if(invoiceNumber != null && invoiceNumber != ''){
                Date dateFrom = Date.valueOf('2013-12-01');
                Date dateTo = Date.valueOf('2013-12-22');
                Date invoiceDate;
                Boolean hasToolTip = false;
                List<CXE_Heroku_Model.BillDetail> billSums = CXE_HerokuApps.getAllBillsBySingleInvoiceNo(invoiceNumber);
                List<CXE_Heroku_Model.BillDetail> groupedBill = new List<CXE_Heroku_Model.BillDetail>();
                Decimal totalPendingAmount = 0;
                Decimal serviceAmount = 0;
                Boolean hasService = false;
                String acctNumFromInvoice = '';
                String acctIdFromInvoice = '';
                Decimal paidAmount = 0;
                Decimal excessAmount = 0;

                for(CXE_Heroku_Model.BillDetail bd: billSums){
                    invoiceDate = Date.valueOf(bd.invoice_date);
                    if(bd.invoice_number != null && bd.invoice_number == invoiceNumber
                        && bd.bill_status != 'Cancelled' && bd.pending_amount != '0' && bd.pending_amount != null
                    && !(bd.collection_status == Label.TOOLTIP_IN_ARRANGEMENTS)
                    && !(bd.due_date == Label.TOOLTIP_TRO_DATE || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo)))
                    && !(bd.is_under_complaint == Label.TOOLTIP_UNDER_COMPLAINT)
                    && !(bd.collection_status == Label.TOOLTIP_FOR_BANK_PROCESSING)
                    && !(bd.bill_type == 'Deposit')){
                        totalPendingAmount += Decimal.valueOf(bd.pending_amount);
                        groupedBill.add(bd);
                        acctNumFromInvoice = bd.account_number;
                    }
                }

                if(acctNumFromInvoice != '' && acctNumFromInvoice != null){
                    List<Contract> contrList = [SELECT Contract_External_ID__c FROM Contract WHERE V10_Account_No__c =:acctNumFromInvoice LIMIT 1];
                    if(!contrList.isEmpty()){
                        acctIdFromInvoice = contrList[0].Contract_External_ID__c;
                    }
                }

                if(payAmount != null && payAmount != ''){
                    paidAmount = Decimal.valueOf(payAmount);
                }
                
                if(totalPendingAmount == paidAmount){
                    payAmountType = 'exact';
                }else if(totalPendingAmount < paidAmount){
                    payAmountType = 'over';
                    excessAmount = paidAmount - totalPendingAmount;
                    PayTrans pt = new PayTrans();
                    pt.accountNum = acctNumFromInvoice;
                    pt.serviceNum = null;
                    pt.billId = null;
                    pt.paymentAmount = String.valueOf(excessAmount);
                    pt.accountId = acctIdFromInvoice;
                    lstPayTrans.add(pt);
                }else{
                    payAmountType = 'partial';
                }
                System.debug('>>rr totalPendingAmount: ' + totalPendingAmount);
                System.debug('>>rr paidAmount: ' + paidAmount);
                System.debug('>>rr payAmountType: ' + payAmountType);

                if(!groupedBill.isEmpty()){
                    Map<String, List<CXE_Heroku_Model.BillDetail>> mapInvIdToBN = new Map<String, List<CXE_Heroku_Model.BillDetail>>();
                    Map<String, Decimal> mapRemainingAmount = new Map<String, Decimal>();
                    for(CXE_Heroku_Model.BillDetail bd: groupedBill){
                        if(payAmountType == 'exact' || payAmountType == 'over'){
                            //create pay trans
                            PayTrans pt = new PayTrans();
                            pt.accountNum = bd.account_number;
                            pt.serviceNum = null; //START/END CSM-14422
                            pt.billId = bd.id;
                            pt.paymentAmount = bd.pending_amount;
                            pt.accountId = acctIdFromInvoice;
                            lstPayTrans.add(pt);
                        }else{
                            if(bd.bill_type == 'Service'){
                                Decimal pendingAmt = Decimal.valueOf(bd.pending_amount);
                                if(pendingAmt == paidAmount){
                                    mapRemainingAmount.put(bd.invoice_id, 0);  
                                    
                                    //create pay trans
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = bd.pending_amount;
                                    pt.accountId = acctIdFromInvoice;
                                    lstPayTrans.add(pt);
                                }else if(pendingAmt > paidAmount){
                                    mapRemainingAmount.put(bd.invoice_id, 0);  
                                    //create pay trans
                                    //create pay trans
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = String.valueOf(paidAmount);
                                    pt.accountId = acctIdFromInvoice;
                                    lstPayTrans.add(pt);
                                }else{
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = String.valueOf(pendingAmt);
                                    pt.accountId = acctIdFromInvoice;
                                    lstPayTrans.add(pt);
                                    mapRemainingAmount.put(bd.invoice_id, paidAmount - pendingAmt);
                                }
                            }else{
                                if(!mapRemainingAmount.containsKey(bd.invoice_id)){
                                    mapRemainingAmount.put(bd.invoice_id, paidAmount);  
                                }

                                if(!mapInvIdToBN.containsKey(bd.invoice_id)){
                                    mapInvIdToBN.put(bd.invoice_id, new List<CXE_Heroku_Model.BillDetail>{bd});  
                                }else{
                                    mapInvIdToBN.get(bd.invoice_id).add(bd);
                                }
                            }
                        }
                    }

                    System.debug('>>mapRemainingAmount: ' + mapRemainingAmount);
                    System.debug('>>mapInvIdToBN: ' + mapInvIdToBN);
                    for(String inv: mapRemainingAmount.keySet()){
                        Decimal remainder = mapRemainingAmount.get(inv);
                        if(remainder > 0){
                            Decimal remainingAmt = remainder;
                            for(CXE_Heroku_Model.BillDetail bd: mapInvIdToBN.get(inv)){
                                Decimal pendingAmt = Decimal.valueOf(bd.pending_amount);
                                if(pendingAmt > remainingAmt){
                                    //create pay trans with remainingAmt
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = String.valueOf(remainingAmt);
                                    pt.accountId = acctIdFromInvoice;
                                    lstPayTrans.add(pt);
                                    break;
                                }else{
                                    //create pay trans with pending_amount
                                    remainingAmt = remainingAmt - pendingAmt;
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = String.valueOf(pendingAmt);
                                    pt.accountId = acctIdFromInvoice;
                                    lstPayTrans.add(pt);
                                }
                            }
                        }
                    }
                }
            }  

            if(!lstPayTrans.isEmpty()){
                paymentTransactionToPass = (List<Object>)lstPayTrans;
            }
            System.debug('>>lstPayTrans: ' + lstPayTrans);
            System.debug('>>paymentTransactionToPass: ' + paymentTransactionToPass);
        }else{
            ptype = 'Bill Summary';
            //System.debug('>>rr lstPartialAccounts: ' + lstPartialAccounts);
            //System.debug('>>rr lstSelectedInvoices: ' + lstSelectedInvoices);
            //System.debug('>>rr lstSelectedSINS: ' + lstSelectedSINS);
            Map<String, Decimal> mapAcctToSubtotal= new Map<String, Decimal>();
            Map<String, String> mapAcctToV10 = new Map<String, String>();
            Map<String, String> mapAcctToType = new Map<String, String>();
            List<String> lstSINs = new List<String>();
            Set<String> lstBillIds = new Set<String>();
            Set<String> lstInvoiceIds = new Set<String>();
            List<PayTrans> lstPayTrans = new List<PayTrans>();

            if(lstSelectedSINS != null && lstSelectedSINS!= ''){
                lstSINs = (List<String>)JSON.deserialize(lstSelectedSINS, List<String>.class);
            }

            if(lstSelectedBillIds != null && lstSelectedBillIds!= ''){
                lstBillIds = (Set<String>)JSON.deserialize(lstSelectedBillIds, Set<String>.class);
            }

            if(lstSelectedInvoiceNums != null && lstSelectedInvoiceNums != ''){
                lstInvoiceIds = (Set<String>)JSON.deserialize(lstSelectedInvoiceNums, Set<String>.class);
            }
            
            List<SelectedInvoice> selectedInvoices = (List<SelectedInvoice>) JSON.deserialize(lstSelectedInvoices, List<SelectedInvoice>.class);
            List<SubMap> mapSubTotal = (List<SubMap>) JSON.deserialize(subTotalMap, List<SubMap>.class);
            for(SubMap sub: mapSubTotal){
                if(!mapAcctToSubtotal.containsKey(sub.key)){
                    mapAcctToSubtotal.put(sub.key, sub.subtotal);
                    mapAcctToV10.put(sub.key, sub.contractExternalId);
                }
                if(!mapAcctToType.containsKey(sub.key)){
                    if(sub.subtotal == sub.prevSubtotal){
                        mapAcctToType.put(sub.key, 'exact');    
                    }else if(sub.subtotal > sub.prevSubtotal){
                        mapAcctToType.put(sub.key, 'over');
                        //create payment trans
                        PayTrans pt = new PayTrans();
                        pt.accountNum = sub.key;
                        pt.serviceNum = null;
                        pt.billId = null;
                        pt.paymentAmount = String.valueOf(sub.subtotal - sub.prevSubtotal);
                        pt.accountId = sub.contractExternalId;
                        lstPayTrans.add(pt);
                    }else{
                        mapAcctToType.put(sub.key, 'partial');
                    }
                }
            }
            System.debug('>>rr mapAcctToV10: ' + mapAcctToV10);
            System.debug('>>rr mapAcctToSubtotal: ' + mapAcctToSubtotal);
            System.debug('>>rr mapAcctToType: ' + mapAcctToType);
            System.debug('>>rr selectedInvoices: ' + selectedInvoices);
            System.debug('>>rr lstSINs: ' + lstSINs);
            System.debug('>>rr lstBillIds: ' + lstBillIds);
            System.debug('>>rr lstInvoiceIds: ' + lstInvoiceIds);

            Map<String, List<CXE_Heroku_Model.BillDetail>> mapInvIdToBN = new Map<String, List<CXE_Heroku_Model.BillDetail>>();
            Map<String, Decimal> mapRemainingAmount = new Map<String, Decimal>();
            List<CXE_Heroku_Model.BillDetail> billSums = CXE_HerokuApps.getAllBillsBySinNos(lstSINs);
            for(CXE_Heroku_Model.BillDetail bd: billSums){
                if(bd.bill_status != 'Cancelled' && bd.pending_amount != '0'){
                    if(bd.invoice_id != '' && bd.invoice_id != null){
                        if(lstInvoiceIds.contains(bd.invoice_id)){
                            if(mapAcctToType.containsKey(bd.account_number)){
                                String payType = mapAcctToType.get(bd.account_number);
                                if(payType == 'exact' || payType == 'over'){
                                    //create pay trans
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null;//START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = bd.pending_amount;
                                    pt.accountId = mapAcctToV10.get(bd.account_number);
                                    lstPayTrans.add(pt);
                                }else{
                                    if(bd.bill_type == 'Service'){
                                        Decimal pendingAmt = Decimal.valueOf(bd.pending_amount);
                                        if(pendingAmt == mapAcctToSubtotal.get(bd.account_number)){
                                            mapRemainingAmount.put(bd.invoice_id, 0);  
                                            
                                            //create pay trans
                                            PayTrans pt = new PayTrans();
                                            pt.accountNum = bd.account_number;
                                            pt.serviceNum = null; //START/END CSM-14422
                                            pt.billId = bd.id;
                                            pt.paymentAmount = bd.pending_amount;
                                            pt.accountId = mapAcctToV10.get(bd.account_number);
                                            lstPayTrans.add(pt);
                                        }else if(pendingAmt > mapAcctToSubtotal.get(bd.account_number)){
                                            mapRemainingAmount.put(bd.invoice_id, 0);  
                                            //create pay trans
                                            //create pay trans
                                            PayTrans pt = new PayTrans();
                                            pt.accountNum = bd.account_number;
                                            pt.serviceNum = null; //START/END CSM-14422
                                            pt.billId = bd.id;
                                            pt.paymentAmount = String.valueOf(mapAcctToSubtotal.get(bd.account_number));
                                            pt.accountId = mapAcctToV10.get(bd.account_number);
                                            lstPayTrans.add(pt);
                                        }else{
                                            PayTrans pt = new PayTrans();
                                            pt.accountNum = bd.account_number;
                                            pt.serviceNum = null; //START/END CSM-14422
                                            pt.billId = bd.id;
                                            pt.paymentAmount = String.valueOf(pendingAmt);
                                            pt.accountId = mapAcctToV10.get(bd.account_number);
                                            lstPayTrans.add(pt);
                                            mapRemainingAmount.put(bd.invoice_id, mapAcctToSubtotal.get(bd.account_number) - pendingAmt);
                                        }
                                    }else{
                                        if(!mapRemainingAmount.containsKey(bd.invoice_id)){
                                            mapRemainingAmount.put(bd.invoice_id, mapAcctToSubtotal.get(bd.account_number));  
                                        }

                                        if(!mapInvIdToBN.containsKey(bd.invoice_id)){
                                            mapInvIdToBN.put(bd.invoice_id, new List<CXE_Heroku_Model.BillDetail>{bd});  
                                        }else{
                                            mapInvIdToBN.get(bd.invoice_id).add(bd);
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        if(lstBillIds.contains(bd.id)){
                            if(mapAcctToType.containsKey(bd.account_number)){
                                String payType = mapAcctToType.get(bd.account_number);
                                if(payType != 'partial'){
                                    //create pay trans with pending_amount
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = bd.pending_amount;
                                    pt.accountId = mapAcctToV10.get(bd.account_number);
                                    lstPayTrans.add(pt);
                                }else{
                                    //create pay trans with subtotal
                                    PayTrans pt = new PayTrans();
                                    pt.accountNum = bd.account_number;
                                    pt.serviceNum = null; //START/END CSM-14422
                                    pt.billId = bd.id;
                                    pt.paymentAmount = String.valueOf(mapAcctToSubtotal.get(bd.account_number));
                                    pt.accountId = mapAcctToV10.get(bd.account_number);
                                    lstPayTrans.add(pt);
                                }
                            }
                        }
                    }
                }
            }

            System.debug('>>mapRemainingAmount: ' + mapRemainingAmount);
            System.debug('>>mapInvIdToBN: ' + mapInvIdToBN);
            for(String inv: mapRemainingAmount.keySet()){
                Decimal remainder = mapRemainingAmount.get(inv);
                if(remainder > 0){
                    Decimal remainingAmt = remainder;
                    for(CXE_Heroku_Model.BillDetail bd: mapInvIdToBN.get(inv)){
                        Decimal pendingAmt = Decimal.valueOf(bd.pending_amount);
                        if(pendingAmt > remainingAmt){
                            //create pay trans with remainingAmt
                            PayTrans pt = new PayTrans();
                            pt.accountNum = bd.account_number;
                            pt.serviceNum = null; //START/END CSM-14422
                            pt.billId = bd.id;
                            pt.paymentAmount = String.valueOf(remainingAmt);
                            pt.accountId = mapAcctToV10.get(bd.account_number);
                            lstPayTrans.add(pt);
                            break;
                        }else{
                            //create pay trans with pending_amount
                            remainingAmt = remainingAmt - pendingAmt;
                            PayTrans pt = new PayTrans();
                            pt.accountNum = bd.account_number;
                            pt.serviceNum = null; //START/END CSM-14422
                            pt.billId = bd.id;
                            pt.paymentAmount = String.valueOf(pendingAmt);
                            pt.accountId = mapAcctToV10.get(bd.account_number);
                            lstPayTrans.add(pt);
                        }
                    }
                }
            }
            if(!lstPayTrans.isEmpty()){
                paymentTransactionToPass = (List<Object>)lstPayTrans;
            }
            System.debug('>>lstPayTrans: ' + lstPayTrans);
            System.debug('>>paymentTransactionToPass: ' + paymentTransactionToPass);
            //identify account Id here
        }
        try{
            return (Map<String, Object>) JSON.deserializeUntyped(
                // Start R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
                CXE_HerokuApps.cc_pay(token, amount, fee, total, fname,emailPass,paymentMode,paymentOffice,address,paymentTransactionToPass,CXE_Constants.PAYMENT_ORIGIN_PORTAL)
                // End R3A CSM-14884 Von Pernicia 1/4/17: Added origin parameter
            );    
        }
        catch(CXE_HerokuApps.HerokuException hx){
            if(hx.asJson() != null) return hx.asJson();
            
            throw hx;
        }
    }
    //END CSM-14422 RReyes NOV-12-17

    @AuraENabled
    public static String errorMessage(String code, String error){
        Map<String, String> errorMap  = new Map<String, String>();
        errorMap.put('2553', 'A required parameter is missing or has a null/empty/invalid value. Field and description will be shown in parameters object.');
        errorMap.put('PY0002', 'Card is already expired based from expMonth and expYear.');
        
        return null;
    }
    
    
    //START R2C CSM-13274 Shayne
     @AuraENabled
        public static boolean retrieveCheckConglomerate(){
        System.debug('retrieveCheckConglomerate');
        boolean ret = false;
        User userData = [SELECT LastLoginDate,FirstName,CXE_Auto_Enrolled_Services__c, AccountId FROM User WHERE Id =:UserInfo.getUserId()]; 
        System.debug('retrieveCheckConglomerate uid '+userData.id+' :AccountID '+userData.AccountId);
        
         try{
              Account accountConglomerate = [SELECT id,Conglomerate__c,Name from Account where id=:userData.AccountId and Conglomerate__c=true];
                 ret = true;
            }catch(Exception e){
                System.debug('retrieveCheckConglomerate error '+e );
            }
        return ret;
    }
    //END R2C CSM-13274 Shayne


    //START CSM-14404 Wenjun 28 Nov - Bill Summary Page Performance Optimization
    @AuraEnabled
    public static CXE_BillsSummary_Response retrieveFilteredBills(String serviceNo, 
                                                                            String accountNo,
                                                                            String billType,
                                                                            String billStatus){

        CXE_BillsSummary_Response resp = new CXE_BillsSummary_Response();
        List<String> sinNos = new List<String>();
        Map<String, String> mapSINToAlias = new Map<String, String>();
        List<CXE_Heroku_Model.BillSummary> returnList = new List<CXE_Heroku_Model.BillSummary>(); 
        Map<String, String> mapContractV10ToExternalId = new Map<String, String>(); //START/END CSM-12705 RReyes OCT-24-17

        List<BillObjMap> billObjList = new List<BillObjMap>();
        BillObjMap tempObjMap;
        Map<String, List<CXE_Heroku_Model.BillSummary>> billObjMapList = new Map<String, List<CXE_Heroku_Model.BillSummary>>();
        List<CXE_Heroku_Model.BillSummary> tempList;
        
        List<CXE_Service_Enrollment__c> listofEnrollments;

        //START CSM-12705 RReyes OCT-24-17 - added Contract_External_ID__c and V10_Account_No__c
        if(serviceNo=='--Select All--' && accountNo!='--Select All--'){
            listofEnrollments = [SELECT CXE_ServiceId__c, CXE_ServiceId__r.SIN__c, CXE_Alias__c,
                                            CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                            CXE_ServiceId__r.Payor__r.Contract_External_ID__c,
                                            CXE_ServiceId__r.Payor__c
                                          FROM CXE_Service_Enrollment__c 
                                        WHERE CXE_UserId__c=:UserInfo.getUserId()
                                         AND CXE_IsActive__c = true
                                         AND CXE_ServiceId__r.Payor__r.V10_Account_No__c =: accountNo]; 
        }
        else if(serviceNo!='--Select All--'){
            listofEnrollments = [SELECT CXE_ServiceId__c, CXE_ServiceId__r.SIN__c, CXE_Alias__c,
                                            CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                            CXE_ServiceId__r.Payor__r.Contract_External_ID__c,
                                            CXE_ServiceId__r.Payor__c
                                          FROM CXE_Service_Enrollment__c 
                                        WHERE CXE_UserId__c=:UserInfo.getUserId()
                                         AND CXE_IsActive__c = true
                                         AND CXE_ServiceId__r.SIN__c =: serviceNo]; 
        }
        else{ //both serviceNo & accountNo equals 'all'
            listofEnrollments = [SELECT CXE_ServiceId__c, CXE_ServiceId__r.SIN__c, CXE_Alias__c,
                                            CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                            CXE_ServiceId__r.Payor__r.Contract_External_ID__c,
                                            CXE_ServiceId__r.Payor__c
                                          FROM CXE_Service_Enrollment__c 
                                        WHERE CXE_UserId__c=:UserInfo.getUserId()
                                         AND CXE_IsActive__c = true];
        }
        //END CSM-12705 RReyes OCT-24-17 - added Contract_External_ID__c and V10_Account_No__c

        for(CXE_Service_Enrollment__c enroll : listofEnrollments){
            if(enroll.CXE_ServiceId__c!=null && enroll.CXE_ServiceId__r.SIN__c!=null){
                sinNos.add(enroll.CXE_ServiceId__r.SIN__c);
            }
            if(enroll.CXE_ServiceId__r.SIN__c != null){
                if(!mapSINToAlias.containsKey(enroll.CXE_ServiceId__r.SIN__c)){
                    mapSINToAlias.put(enroll.CXE_ServiceId__r.SIN__c, enroll.CXE_Alias__c);
                }   
            }
            //START CSM-12705 RReyes OCT-24-17 
            if(enroll.CXE_ServiceId__c != null && enroll.CXE_ServiceId__r.Payor__c != null){
                if(!String.isBlank(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)
                    && !String.isBlank(enroll.CXE_ServiceId__r.Payor__r.Contract_External_ID__c)){
                    if(!mapContractV10ToExternalId.containsKey(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c)){
                        mapContractV10ToExternalId.put(enroll.CXE_ServiceId__r.Payor__r.V10_Account_No__c, enroll.CXE_ServiceId__r.Payor__r.Contract_External_ID__c);
                    }
                }
            }
            System.debug('>>rr mapContractV10ToExternalId: ' + mapContractV10ToExternalId);
            //END CSM-12705 RReyes OCT-24-17 
        }
        
        List<CXE_Heroku_Model.BillDetail> billingDetails = CXE_HerokuApps.getFilteredBillsBySinNos(sinNos, billType, billStatus);
        System.debug('>>rr: unprocessedbillingDetailsFromHeroku: ' + billingDetails);
        List<CXE_Heroku_Model.BillDetail> updatedBillingDetails = groupBillNotes(billingDetails);
        billingDetails = updatedBillingDetails;
        
        
        Date dateFrom = Date.valueOf('2013-12-01');
        Date dateTo = Date.valueOf('2013-12-22');
        
        for(CXE_Heroku_Model.BillDetail bd: billingDetails){

            CXE_Heroku_Model.BillSummary summaryRec = initBillSummaryRecord(bd);
            
            Decimal currentAmount = 0;
            String toolTipMsg = '';
            Date invoiceDate = Date.valueOf(bd.invoice_date);

            if(bd.toolTipMessage!=null){
                toolTipMsg = bd.toolTipMessage;
            }
            
            //CSM-11105 - #1 IPA
            if(bd.collection_status == 'Under Installment Agreement' && toolTipMsg == ''){ //START/END CSM-12354 RReyes - changed from 'In Arrangements' to 'Under Installment Agreement'
                toolTipMsg = 'IPA';
            }
            
            //CSM-11099 - #2 TRO
            if((bd.due_date == '2888-12-31' || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo))) && toolTipMsg == ''){
                toolTipMsg = 'TRO';
            }
            
            //CSM-11087 - #3 Under Review - Pending criteria
            if(bd.is_under_complaint == '1'  && toolTipMsg == ''){
                toolTipMsg = 'UNDER_REVIEW';
            }
            
            //CSM-11093 - #4 APA
            if(bd.collection_status == 'For bank processing'  && toolTipMsg == ''){
                toolTipMsg = 'APA';
            }
            
            //CSM-11111 - #5 Bill Deposit
            if(bd.bill_type == 'Deposit'  && toolTipMsg == ''){
                toolTipMsg = 'BD';
            }
            
            if(toolTipMsg != ''){
                summaryRec.isSINOff = 'true';
                summaryRec.isSINSel = 'false';
                summaryRec.msg = toolTipMsg;
            }
            
            //CSM-11966 - #6 Service Irregularity
            if(bd.bill_type == 'Service Irregularity'  && toolTipMsg == ''){
                bd.toolTipMessage = toolTipMsg;
                summaryRec.msg = 'IRREG';
            }

            else if(bd.toolTipMessage=='IRREG'){
                summaryRec.isSINOff = 'false';
                summaryRec.isSINSel = 'true';
            }
            
            if(bd.pending_amount != null && bd.pending_amount != ''){
                currentAmount = Decimal.valueOf(bd.pending_amount);
            }
            
            if(bd.bill_status_filter == 'Paid' || currentAmount <= 0){
                summaryRec.isSINOff = 'true';
                summaryRec.isSINSel = 'false';
            }
            
            if(mapSINToAlias.containsKey(bd.service_number)){
                summaryRec.alias = mapSINToAlias.get(bd.service_number);
            }

            //START CSM-12705 RReyes OCT-24-17 
            if(bd.account_number != null && bd.account_number != '' && mapContractV10ToExternalId != null){
                if(mapContractV10ToExternalId.containsKey(bd.account_number)){
                    summaryRec.contractExternalId = mapContractV10ToExternalId.get(bd.account_number);
                }
            }
            //END CSM-12705 RReyes OCT-24-17 

            returnList.add(summaryRec);


            if(billObjMapList.containsKey(bd.account_number)){
                tempList = billObjMapList.get(bd.account_number);
            }else{
                tempList = new List<CXE_Heroku_Model.BillSummary>();
            }
            tempList.add(summaryRec);
            
            billObjMapList.put(bd.account_number, tempList);
        }

        for(String billKey : billObjMapList.keySet()){
            tempObjMap = new BillObjMap();
            tempObjMap.key = billKey;
            tempObjMap.listBills = billObjMapList.get(billKey);
            billObjList.add(tempObjMap);
        }

        
        //return returnList;

        resp.summaryList = returnList;
        resp.billObjMainMap = billObjList;

        return resp;
    }


    public class BillObjMap {
        @AuraEnabled
        public List<CXE_Heroku_Model.BillSummary> listBills;
        @AuraEnabled
        public String key;
    }

    public class CXE_BillsSummary_Response {
        @AuraEnabled
        public List<CXE_Heroku_Model.BillSummary> summaryList;
        @AuraEnabled
        public List<BillObjMap> billObjMainMap;
    }
    
    public static CXE_Heroku_Model.BillSummary initBillSummaryRecord(CXE_Heroku_Model.BillDetail billDtl)
    {
        CXE_Heroku_Model.BillSummary summaryRec = new CXE_Heroku_Model.BillSummary();
        summaryRec.acctNum = billDtl.account_number;
        summaryRec.billDt = billDtl.bill_date;
        summaryRec.dueDt= billDtl.due_date;
        summaryRec.invDt= billDtl.invoice_date;
        summaryRec.penAmt= billDtl.pending_amount;
        summaryRec.payStatus= billDtl.bill_status_filter;
        summaryRec.totalAmt= billDtl.total_amount;
        summaryRec.billType= billDtl.bill_type;
        summaryRec.id= billDtl.id;
        summaryRec.svcNum= billDtl.service_number;
        summaryRec.isSINOff= 'false';
        summaryRec.isAcctOff= 'false';
        summaryRec.msg= billDtl.toolTipMessage;
        summaryRec.isSINSel= 'true';
        summaryRec.isAcctSel= 'true';
        summaryRec.subTotal= 0;

        summaryRec.hasDisabledSIN = billDtl.hasDisabledSIN;
        summaryRec.isSingleSINSelected = billDtl.isSingleSINSelected;
        summaryRec.isSingleSINSelectAll = billDtl.isSingleSINSelectAll;
        summaryRec.allSINsEnrolled = billDtl.allSINsEnrolled;

        summaryRec.isSINAllSelectable = billDtl.isSINAllSelectable;
        summaryRec.allSINselected = billDtl.allSINselected;
        summaryRec.hasAnyOverdue = billDtl.hasAnyOverdue;
        summaryRec.hasOverduePayNow = billDtl.hasOverduePayNow;
        summaryRec.hasOverdueForDisconnection = billDtl.hasOverdueForDisconnection;
        summaryRec.hasOverdueDisconnected = billDtl.hasOverdueDisconnected;
        summaryRec.hasOverdueTerminated = billDtl.hasOverdueTerminated;
        
        summaryRec.contractExternalId = '';
        //START CSM-14799 RReyes DEC-05-17
        summaryRec.invoice_id = billDtl.invoice_id;
        //END CSM-14799 RReyes DEC-05-17
        return summaryRec;
    }
    //END CSM-14404 Wenjun 28 Nov - Bill Summary Page Performance Optimization
}