public without sharing class CXE_CP_PaymentPayAsGuest {
    
    public class ReturnData{
        @AuraEnabled
        public String errorMessage;
        
        @AuraEnabled
        public decimal totalPendingAmount;
        
        @AuraEnabled
        public decimal totalPaidAmount;
        
        @AuraEnabled
        public string paymentStatus;
        
        @AuraEnabled
        public string paymentReferences;
        
        @AuraEnabled
        public string paymentReferenceNumber;
        
        @AuraEnabled
        public string invoice_number;
        
        @AuraEnabled
        public string invoice_id;
        
        @AuraEnabled
        public string account_number;
        
        @AuraEnabled
        public string service_number;
        
        @AuraEnabled
        public boolean pay_advance;  
        
        @AuraEnabled
        public string payment_status;
        
        @AuraEnabled
        public decimal overPaid_Amount;
        
        @AuraEnabled
        public string billId;
        
        @AuraEnabled
        public string external_Id;
        
        @AuraEnabled
        public string advanceState;
        
        @AuraEnabled
        public List<CXE_Heroku_Model.BillDetail> billList;
        
        @AuraEnabled
        public Boolean isTerminated;
        
        @AuraEnabled
        public Boolean isDisconnected;
        
        @AuraEnabled
        public Boolean isOverdue;
        
        @AuraEnabled
        public decimal checkTotalAmount;
        
        //START CSM-14526 JFERNANDEZ 11-20-2017
        @AuraEnabled
        public boolean hasAnyTerminated = false;
        
        @AuraEnabled
        public boolean hasAnyDisconnected = false;
        //END CSM-14526 JFERNANDEZ 11-20-2017
    }
    
    @AuraEnabled
    public static ReturnData validateData(string validationType , string valuePass , decimal amountPass ,string emailPass){
        ReturnData dataReturned = new ReturnData();
        dataReturned.pay_advance = false;
        boolean isValid = true;
        decimal totalAmount = 0;
        List<CXE_Heroku_Model.BillDetail> billingDetails;
        try{
            if(validationType == 'serviceRadio'){
                dataREturned.advanceState = 'advanceService';
                dataReturned.paymentReferences = 'Service';
                List<Agreement__c> listofService = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c 
                                                              from Agreement__c 
                                                              where SIN__c =: valuePass 
                                                             ];
               system.debug('here1' + listofService);
                if(listofService.size() > 0){
                    dataReturned.pay_advance = true;
                    dataReturned.service_number = valuePass;
                    //billingDetails = CXE_HerokuApps.getAllUnpaidBillsBySingleSin(valuePass);
                    //List<Agreement__c> listofServiceAgreements = [SELECT ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c  FROM Agreement__c WHERE Payor__r.V10_Account_No__c =: listofService[0].Payor__r.V10_Account_No__c];
                    List<Agreement__c> listofServiceAgreements = [SELECT ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c  FROM Agreement__c WHERE SIN__c =: valuePass];
                   	List<Contract> getExternalID = [select ID,Contract_External_ID__c from Contract where V10_Account_No__c =: listofService[0].Payor__r.V10_Account_No__c ];
                    dataReturned.external_Id = getExternalID[0].Contract_External_ID__c;
                    dataReturned.account_number = listofService[0].Payor__r.V10_Account_No__c;
                    dataReturned.isTerminated = false;
                    dataReturned.isDisconnected = false;
                    for(Agreement__c servRec: listofServiceAgreements){ 
                        if(servRec.Service_Status__c == 'Active - Disconnected'){
                            dataReturned.isDisconnected = true;
                        }
                        if(servRec.Service_Status__c == 'Terminated'){
                            dataReturned.isTerminated = true;
                        }
                    }
                    
                    //billingDetails = CXE_HerokuApps.getAllUnpadBillsBySingleAcctNo(listofService[0].Payor__r.V10_Account_No__c);
                    billingDetails = CXE_HerokuApps.getAllUnpaidBillsBySingleSin(listofService[0].SIN__c);
                    if(emailPass == null){
                        //billingDetails = CXE_HerokuApps.getAllBillsBySingleAcctNo(listofService[0].Payor__r.V10_Account_No__c);
                        billingDetails = CXE_HerokuApps.getAllBillsBySingleSin(listofService[0].SIN__c);
                    }
                    List<CXE_Heroku_Model.BillDetail> filteredDetail = new List<CXE_Heroku_Model.BillDetail>();
                    system.debug('herokuReturn ' + billingDetails);  
                    dataReturned.isOverdue = false;
                    Boolean isEqual = false;
                    decimal filteredTotal = 0;
                    
                    if(billingDetails.size() > 0){
                        //START CSM-14422 RReyes NOV-13-17
                        Date dateFrom = Date.valueOf('2013-12-01');
                        Date dateTo = Date.valueOf('2013-12-22');
                        Date invoiceDate;
                        //END CSM-14422 RReyes NOV-13-17
                        
                        for(CXE_Heroku_Model.BillDetail Billrec: billingDetails){ 
                            //START CSM-14422 RReyes NOV-13-17
                            invoiceDate = Date.valueOf(Billrec.invoice_date);
                            if(!(Billrec.collection_status == Label.TOOLTIP_IN_ARRANGEMENTS)
                            && !(Billrec.due_date == Label.TOOLTIP_TRO_DATE || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo)))
                            && !(Billrec.is_under_complaint == Label.TOOLTIP_UNDER_COMPLAINT)
                            && !(Billrec.collection_status == Label.TOOLTIP_FOR_BANK_PROCESSING)
                            && !(Billrec.bill_type == 'Deposit')){
                                if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately' || Billrec.collection_status == 'Overdue, please pay immediately'
                                   || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately' || Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'
                                   || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately'){
                                       dataReturned.isOverdue = true;
                                   }
                                if(Billrec.service_number == valuePass){
                                    filteredDetail.add(Billrec);
                                    filteredTotal += decimal.valueof(Billrec.pending_amount);
                                }
                                totalAmount += decimal.valueof(Billrec.pending_amount);
                            }
                            
                            //START CSM-14526 JFERNANDEZ 11-20-2017
                            if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately'){
                                dataReturned.hasAnyTerminated = true;
                            }
                            if(Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'){
                                dataReturned.hasAnyDisconnected = true;
                            }
                            //END CSM-14526 JFERNANDEZ 11-20-2017
                            
                            //END CSM-14422 RReyes NOV-13-17
                        }
                        
                        billingDetails = filteredDetail;
                        system.debug('filteredTotal' + filteredTotal);
                        system.debug('filteredData' + billingDetails);
                        system.debug('here2' + totalAmount);
                        system.debug('here3' + amountPass);
                        dataReturned.checkTotalAmount = totalAmount;
                        if(totalAmount == amountPass || totalAmount < amountPass){
                            isEqual = true;
                        }                             
                        system.debug('here4' + isEqual);
                        if(isEqual){
                            if(dataReturned.isTerminated && dataReturned.isDisconnected){
                                dataReturned.errorMessage = 'reactivate pending 2';
                            }
                            else if(dataReturned.isTerminated && !dataReturned.isDisconnected){
                                dataReturned.errorMessage = 'reactivate pending';
                            }
                            else if(dataReturned.isDisconnected && !dataReturned.isTerminated){
                                dataReturned.errorMessage = 'reactivate pending 2';
                            }else{
                                dataReturned.errorMessage = 'active';
                            }
                            dataReturned.payment_status = 'Exact';
                            if(filteredTotal < amountPass){
                                decimal overPaid_Amount = amountPass - filteredTotal;
                                dataReturned.overPaid_Amount = overPaid_Amount;
                                dataReturned.payment_status = 'Over';
                            }
                        }else{ 
                            system.debug('isEqual = false');
                            dataReturned.payment_status = 'Partial';
                            if(dataReturned.isOverdue){
                                dataReturned.errorMessage = 'overdue';
                            }else{
                                dataReturned.errorMessage = 'active';
                            }
                        }
                        
                    }else{
                        //dataReturned.errorMessage = 'No Heroku';
                    }
                }else{
                    dataReturned.errorMessage = 'Invalid Service ID No.';
                    isValid = false;
                }
                dataReturned.totalPendingAmount = totalAmount;
                dataReturned.totalPaidAmount = amountPass;
                dataReturned.paymentReferenceNumber = valuePass;
            }else if(validationType =='accountRadio'){
                dataREturned.advanceState = 'advanceAccount';
                //dataReturned.pay_advance = true; //START/END CSM-15183 RReyes Jan-17-18
                dataReturned.paymentReferences = 'Account';
                List<Contract> listofContract = [Select Id,V10_Account_No__c,Contract_External_ID__c
                                                 from Contract where V10_Account_No__c =:valuePass];
                
                //List<Contract> getExternalID = [select ID,Contract_External_ID__c from Contract where V10_Account_No__c =: listofService[0].Payor__r.V10_Account_No__c ];
                //START CSM-15183 RReyes Jan-17-18
                    //dataReturned.external_Id = listofContract[0].Contract_External_ID__c;
                if(listofContract.size() > 0){
                    dataReturned.pay_advance = true;
                    dataReturned.external_Id = listofContract[0].Contract_External_ID__c;
                //END CSM-15183 RReyes Jan-17-18
                    dataReturned.isTerminated = false;
                    dataReturned.isDisconnected = false;
                    dataReturned.account_number = listofContract[0].V10_Account_No__c;
                    List<Agreement__c> listofService = [SELECT Service_Status__c FROM Agreement__c WHERE Payor__c =: listofContract[0].id];
                    for(Agreement__c servRec: listofService){ 
                        if(servRec.Service_Status__c == 'Active - Disconnected'){
                            dataReturned.isDisconnected = true;
                        }
                        if(servRec.Service_Status__c == 'Terminated'){
                            dataReturned.isTerminated = true;
                        }
                    }
                    
                    billingDetails = CXE_HerokuApps.getAllUnpadBillsBySingleAcctNo(valuePass);
                    if(emailPass == null){
                        billingDetails = CXE_HerokuApps.getAllBillsBySingleAcctNo(valuePass);
                    }
                    system.debug('herokuReturn ' + billingDetails);  
                    if(billingDetails.size() > 0){
                        
                        dataReturned.isOverdue = false;
                        Boolean isEqual = false;

                        //START CSM-14422 RReyes NOV-13-17
                        Date dateFrom = Date.valueOf('2013-12-01');
                        Date dateTo = Date.valueOf('2013-12-22');
                        Date invoiceDate;
                        //END CSM-14422 RReyes NOV-13-17
                        
                        for(CXE_Heroku_Model.BillDetail Billrec: billingDetails){ 
                            //START CSM-14422 RReyes NOV-13-17
                            invoiceDate = Date.valueOf(Billrec.invoice_date);
                            if(!(Billrec.collection_status == Label.TOOLTIP_IN_ARRANGEMENTS)
                            && !(Billrec.due_date == Label.TOOLTIP_TRO_DATE || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo)))
                            && !(Billrec.is_under_complaint == Label.TOOLTIP_UNDER_COMPLAINT)
                            && !(Billrec.collection_status == Label.TOOLTIP_FOR_BANK_PROCESSING)
                            && !(Billrec.bill_type == 'Deposit')){
                                if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately' || Billrec.collection_status == 'Overdue, please pay immediately'
                                   || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately' || Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'
                                   || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately'){
                                       dataReturned.isOverdue = true;
                                   }
                                totalAmount += decimal.valueof(Billrec.pending_amount);
                            }
                            
                            //START CSM-14526 JFERNANDEZ 11-20-2017
                            if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately'){
                                dataReturned.hasAnyTerminated = true;
                            }
                            if(Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'){
                                dataReturned.hasAnyDisconnected = true;
                            }
                            //END CSM-14526 JFERNANDEZ 11-20-2017
                            
                            //END CSM-14422 RReyes NOV-13-17
                        }
                        if(totalAmount == amountPass || totalAmount < amountPass){
                            isEqual = true;
                        }  
                        if(isEqual){
                          
                            if(dataReturned.isTerminated && dataReturned.isDisconnected){
                                dataReturned.errorMessage = 'reactivate pending 2';
                            }
                            else if(dataReturned.isTerminated && !dataReturned.isDisconnected){
                                dataReturned.errorMessage = 'reactivate pending';
                            }
                            else if(dataReturned.isDisconnected && !dataReturned.isTerminated){
                                dataReturned.errorMessage = 'reactivate pending 2';
                            }else{
                                dataReturned.errorMessage = 'active';
                            }
                            dataReturned.payment_status = 'Exact';
                            if(totalAmount < amountPass){
                                dataReturned.payment_status = 'Over';
                                decimal overPaid_Amount = amountPass - totalAmount;
                                dataReturned.overPaid_Amount = overPaid_Amount;
                            }
                        }else{
                            system.debug('isEqual = false');
                            dataReturned.payment_status = 'Partial';
                            if(dataReturned.isOverdue){
                                dataReturned.errorMessage = 'overdue';
                            }else{
                                dataReturned.errorMessage = 'active';
                            }
                        }
                        
                        
                    }else{
                        dataReturned.pay_advance = true;
                        //dataReturned.errorMessage = 'No Heroku';
                    }
                }else{
                    dataReturned.errorMessage = 'Invalid Account';
                    isValid = false;
                }
                dataReturned.totalPendingAmount = totalAmount;
                dataReturned.totalPaidAmount = amountPass;
                dataReturned.paymentReferenceNumber = valuePass;
            }
            else{
                dataReturned.paymentReferences = 'Invoice';
                billingDetails = CXE_HerokuApps.getAllBillsBySingleInvoiceNo(valuePass);
                system.debug('herokuReturn ' + billingDetails);  
             
                if(billingDetails.size() > 0){
                    list<String> serviceId = new List<String>();
                    list<String> accountId = new List<String>();
                    dataReturned.isOverdue = false;
                    Boolean isEqual = false;
                    decimal filteredTotal = 0;
                    List<CXE_Heroku_Model.BillDetail> filteredDetail = new List<CXE_Heroku_Model.BillDetail>();
                    //START CSM-14422 RReyes NOV-13-17
                    Date dateFrom = Date.valueOf('2013-12-01');
                    Date dateTo = Date.valueOf('2013-12-22');
                    Date invoiceDate;
                    Boolean hasToolTip = false;
                    //END CSM-14422 RReyes NOV-13-17

                    decimal currentAmount = amountPass;
                    //decimal currentAmount = 0; //JFERNANDEZ 11262077
                    for(CXE_Heroku_Model.BillDetail Billrec: billingDetails){ 
                        /*system.debug('account number sample' + Billrecs.account_number);
                        system.debug('service number sample' + Billrecs.service_number);
                        if(Billrecs.service_number != null){
                            serviceId.add(Billrecs.service_number);
                        }
                        if(Billrecs.account_number != null){
                            accountId.add(Billrecs.account_number);
                        }
                        system.debug('sample s' + serviceId);
                        system.debug('sample a' + accountId);*/
                        if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately' || Billrec.collection_status == 'Overdue, please pay immediately'
                           || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately' || Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'
                           || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately'){
                               dataReturned.isOverdue = true;
                           }
                        if(Billrec.invoice_number != null){
                            if(Billrec.invoice_number == valuePass && currentAmount >= 0){
                                //if(decimal.valueof(Billrec.pending_amount) > currentAmount){
                                     //Billrec.pending_amount = string.valueof(currentAmount);
                                //}else{
                                    //Billrec.pending_amount = Billrec.pending_amount;
                                //}
                                currentAmount = currentAmount - decimal.valueof(Billrec.pending_amount);
                                filteredDetail.add(Billrec);
                                dataReturned.invoice_id = Billrec.id;
                                dataReturned.account_number = Billrec.account_number;
                                filteredTotal += decimal.valueof(Billrec.pending_amount);
                                //START CSM-14526 JFERNANDEZ 11-20-2017
                                if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately' && Billrec.invoice_number == valuePass){
                                    dataReturned.hasAnyTerminated = true;
                                }
                                if(Billrec.collection_status == 'Overdue - Disconnected, please pay immediately' && Billrec.invoice_number == valuePass){
                                    dataReturned.hasAnyDisconnected = true;
                                }
                            //END CSM-14526 JFERNANDEZ 11-20-2017
                                totalAmount = decimal.valueof(Billrec.pending_amount);
                            }
                            
                            
                            
                        }
                        dataReturned.invoice_number = valuePass;
                        //START CSM-14422 RReyes NOV-13-17
                        invoiceDate = Date.valueOf(Billrec.invoice_date);
                        if(Billrec.invoice_number != null && Billrec.invoice_number == valuePass && !(!(Billrec.collection_status == Label.TOOLTIP_IN_ARRANGEMENTS)
                        && !(Billrec.due_date == Label.TOOLTIP_TRO_DATE || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo)))
                        && !(Billrec.is_under_complaint == Label.TOOLTIP_UNDER_COMPLAINT)
                        && !(Billrec.collection_status == Label.TOOLTIP_FOR_BANK_PROCESSING)
                        && !(Billrec.bill_type == 'Deposit'))){
                            hasToolTip = true;
                        }//END CSM-14422 RReyes NOV-13-17
                    }
                 	billingDetails=filteredDetail;
                    system.debug('accountId sample' + accountId);
                    //List<CXE_Heroku_Model.BillDetail> billingRelated = CXE_HerokuApps.getAllUnpadBillsByAcctNo(accountId);
                    //system.debug('herokuReturn Related' + billingRelated);      
                    
                    /*for(CXE_Heroku_Model.BillDetail Billrec: billingDetails){ 
                        if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately' || Billrec.collection_status == 'Overdue, please pay immediately'
                           || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately' || Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'
                           || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately'){
                               isOverdue = true;
                           }
                        totalAmount += decimal.valueof(Billrec.total_amount);
                    }*/
                    
                    dataReturned.isTerminated = false;
                    dataReturned.isDisconnected = false;
                    //START CSM-14422 RReyes NOV-13-17
                    if(!billingDetails.isEmpty()){
                        List<Contract> listofContract = [Select Id,V10_Account_No__c,Contract_External_ID__c
                                                         from Contract where V10_Account_No__c =: billingDetails[0].account_number];
                        
            			//List<Contract> getExternalID = [select ID,Contract_External_ID__c from Contract where V10_Account_No__c =: listofService[0].Payor__r.V10_Account_No__c ];
                        dataReturned.external_Id = listofContract[0].Contract_External_ID__c;
                        List<Agreement__c> listofService = [SELECT Service_Status__c FROM Agreement__c WHERE Payor__r.V10_Account_No__c =: billingDetails[0].account_number];
                        for(Agreement__c servRec: listofService){ 
                            if(servRec.Service_Status__c == 'Active - Disconnected'){
                                dataReturned.isDisconnected = true;
                            }
                            if(servRec.Service_Status__c == 'Terminated'){
                                dataReturned.isTerminated = true;
                            }
                        }
                    }
                    //END CSM-14422 RReyes NOV-13-17
                    
                    if(totalAmount == amountPass || totalAmount < amountPass){
                        isEqual = true;
                    }  
                    if(isEqual){
                        if(dataReturned.isTerminated && dataReturned.isDisconnected){
                            dataReturned.errorMessage = 'reactivate pending 2';
                        }
                        else if(dataReturned.isTerminated && !dataReturned.isDisconnected){
                            dataReturned.errorMessage = 'reactivate pending';
                        }
                        else if(dataReturned.isDisconnected && !dataReturned.isTerminated){
                            dataReturned.errorMessage = 'reactivate pending 2';
                        }else{
                            dataReturned.errorMessage = 'active';
                        }
                        dataReturned.payment_status = 'Exact';
                        if(filteredTotal < amountPass){
                            decimal overPaid_Amount =amountPass - filteredTotal;
                            dataReturned.overPaid_Amount = overPaid_Amount;
                            dataReturned.payment_status = 'Over';
                        }
                    }else{
                        system.debug('isEqual = false');
                        dataReturned.payment_status = 'Partial';
                        if(dataReturned.isOverdue){
                            dataReturned.errorMessage = 'overdue';
                        }else{
                            dataReturned.errorMessage = 'active';
                        }
                    } 
                    //START CSM-14422 RReyes NOV-13-17
                    if(hasToolTip){
                        dataReturned.errorMessage = 'Invalid Invoice No.';
                        isValid = false; 
                    }
                    //END CSM-14422 RReyes NOV-13-17
                }else{
                    dataReturned.errorMessage = 'Invalid Invoice No.';
                    isValid = false;
                }
                dataReturned.totalPendingAmount = totalAmount;
                dataReturned.totalPaidAmount = amountPass;
                dataReturned.paymentReferenceNumber = valuePass;
            }
            system.debug('updatebillingdetailsreturn' + billingDetails);
            if(billingDetails != null){
                List<CXE_Heroku_Model.BillDetail> updatedBillingDetails = CXE_CP_MyBillsSummaryCtlr.groupBillNotes(billingDetails);
                billingDetails = updatedBillingDetails;
                system.debug('updatebillingdetailsreturn' + billingDetails);
                
                for(CXE_Heroku_Model.BillDetail bd: billingDetails){
                    bd.isSINSelected = 'true';
                    bd.isAccountSelected = 'true';
                }
                dataReturned.billList = billingDetails;
            }
            
        }catch(Exception e) {
            ErrorHandlerException.recordException(null, true, 'payasguest', 'aaaaaaaaaaa', e.getMessage());
            dataReturned.errorMessage = e.getMessage();
        }
        
        //dataReturned.totalPendingAmount = totalAmount;
        //dataReturned.totalPaidAmount = amountPass;
        //dataReturned.paymentReferenceNumber = valuePass;
        return dataReturned;
    }
    
    @AuraEnabled
    public static String getHiearchySettings(){
        return OrganizationSettings__c.getOrgDefaults().Terms_And_Conditions_Link__c;
    }   
   
    
    @AuraEnabled
    public static Boolean getBooleanServiceStatus(){
        return false;
    }
}