public without sharing class CXE_CP_MyBillsViewBillsCtrl { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"

    @AuraEnabled
    public static List<ViewBillsWrapper> retrieveBillingDetails(String legacyV10AcctNo){
        Map<String, CXE_Service_Enrollment__c> sinKeyEnrollMap = new Map<String, CXE_Service_Enrollment__c>();
        List<ViewBillsWrapper> wrapList = new List<ViewBillsWrapper>();
        //try{
            List<String> sinNos = new List<String>(); //CSM-14097
            // get service enrollent records under the userId
            List<CXE_Service_Enrollment__c> listofEnrollments = [Select CXE_ServiceId__c, CXE_ServiceId__r.SIN__c,CXE_Alias__c From CXE_Service_Enrollment__c 
                                                                      Where CXE_UserId__c=:UserInfo.getUserId()
                                                                        AND CXE_IsActive__c = true //CSM-14097
                                                                        AND CXE_ServiceId__r.Payor__r.V10_Account_No__c =: legacyV10AcctNo];
            for(CXE_Service_Enrollment__c enroll : listofEnrollments){
                if(enroll.CXE_ServiceId__c!=null && enroll.CXE_ServiceId__r.SIN__c!=null){
                    sinKeyEnrollMap.put(enroll.CXE_ServiceId__r.SIN__c, enroll);
                    sinNos.add(enroll.CXE_ServiceId__r.SIN__c); //CSM-14097
                }
            }

            Date dateFrom = Date.valueOf('2013-12-01');
            Date dateTo = Date.valueOf('2013-12-22');
            Date invoiceDate;

            //START CSM-14097 GGrandea 10.25.2017
            //List<CXE_Heroku_Model.BillDetail> billNotes = CXE_HerokuApps.getAllBillsBySingleAcctNo(legacyV10AcctNo);
            List<CXE_Heroku_Model.BillDetail> billNotes = CXE_HerokuApps.getAllBillsBySinNos(sinNos);
            //END CSM-14097

            for(CXE_Heroku_Model.BillDetail bDtl: CXE_CP_MyBillsSummaryCtlr.groupBillNotes(billNotes)){
                bDtl.toolTipMessage = '';
                invoiceDate = Date.valueOf(bDtl.invoice_date);
            //START CSM-12624 RReyes SEP-18-2017 - changed comparison values to Label reference
            if( bDtl.collection_status == Label.TOOLTIP_IN_ARRANGEMENTS
               //START CSM-12401 GGrandea 09.07.2017
               /*|| (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo))*/
               || (bDtl.due_date == Label.TOOLTIP_TRO_DATE
                   || (invoiceDate != null && (invoiceDate >= dateFrom && invoiceDate <= dateTo)) )
               //END CSM-12401 GGrandea 09.07.2017
               || bDtl.is_under_complaint == Label.TOOLTIP_UNDER_COMPLAINT
               || bDtl.collection_status == Label.TOOLTIP_FOR_BANK_PROCESSING
                    || bDtl.bill_type == CXE_Constants.BILLS_BILL_DEPOSIT ) {

                            bDtl.toolTipMessage = CXE_Constants.BILLS_HAS_TOOLTIP;
                }
            //Start CommentedOut by RReyes - SEP-18-17 - service irregularity can be paid
            /*f(bDtl.bill_type == CXE_Constants.BILLS_SERVICE_IRREG  && String.isEmpty(bDtl.toolTipMessage) ){
bDtl.toolTipMessage = CXE_Constants.BILLS_HAS_TOOLTIP;
}*/
            //End CommentedOut by RReyes - SEP-18-17 - service irregularity can be paid
            //END CSM-12624 RReyes SEP-18-2017 - changed comparison values to Label reference
                wrapList.add(
                        new CXE_CP_MyBillsViewBillsCtrl.ViewBillsWrapper(sinKeyEnrollMap.get(bDtl.service_number), bDtl)
                    );
            } 
        //} catch (Exception ex){
        //    wrapList.clear();
        //    ErrorHandlerException.recordException(null, true, 'CXE_CP_MyBillsViewBillsCtrl', 'retrieveBillingDetails', ex.getMessage());
        //}
        return wrapList;
    }
    
    @AuraEnabled
    public static String pdfVault(String action, String fileName) {
        //START CSM-11039 RReyes AUG-18-17 - PDF Vault
        String url = CXE_HerokuApps.getPDFUrl(action, fileName);
        //END CSM-11039 RReyes AUG-18-17 - PDF Vault
        return url;        
    }
    
    @AuraEnabled
    public static String validateData(string acctNo, decimal amount){
        List<CXE_Heroku_Model.BillDetail> billingDetails;
        List<Contract> listofContract = [Select Id,V10_Account_No__c
                                         from Contract where V10_Account_No__c =:acctNo];
        
        if(listofContract.size() > 0){
            boolean isTerminated = false;
            boolean isDisconnected = false;
            List<Agreement__c> listofService = [SELECT Service_Status__c FROM Agreement__c WHERE Payor__c =: listofContract[0].id];
            for(Agreement__c servRec: listofService){ 
                if(servRec.Service_Status__c == 'Active - Disconnected'){
                    isDisconnected = true;
                }
                if(servRec.Service_Status__c == 'Terminated'){
                    isTerminated = true;
                }
            }
            
            billingDetails = CXE_HerokuApps.getAllUnpadBillsBySingleAcctNo(acctNo);
            system.debug('herokuReturn ' + billingDetails);  
            if(billingDetails.size() > 0){
                
                Boolean isOverdue = false;
                Boolean isEqual = false;
                decimal totalAmount = 0;
                
                for(CXE_Heroku_Model.BillDetail Billrec: billingDetails){ 
                    if(Billrec.collection_status == 'Overdue- Service Terminated, please pay immediately' || Billrec.collection_status == 'Overdue, please pay immediately'
                       || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately' || Billrec.collection_status == 'Overdue - Disconnected, please pay immediately'
                       || Billrec.collection_status == 'Overdue - for Disconnection please pay immediately'){
                           isOverdue = true;
                       }
                    totalAmount += decimal.valueof(Billrec.total_amount);
                }
                if(totalAmount == amount || totalAmount < amount){
                    isEqual = true;
                }  
                if(isEqual){
                    if(isTerminated && isDisconnected){
                        return 'reactivate pending 2';
                    }
                    else if(isTerminated && !isDisconnected){
                        return 'reactivate pending';
                    }
                    else if(isDisconnected && !isTerminated){
                        return 'reactivate pending 2';
                    }else{
                        return 'active';
                    }
                }else{
                    if(isOverdue){
                        return 'overdue';
                    }else{
                        return 'active';
                    }
                }
                
                
            }else{
                return 'No Heroku';
            }
        }
        
        return null;
    }
    
    public class ViewBillsWrapper{
        public ViewBillsWrapper(CXE_Service_Enrollment__c enroll, CXE_Heroku_Model.BillDetail bDetail){
            this.enrollment = enroll;
            this.billDtl = bDetail;
        }
        @AuraEnabled
        public CXE_Service_Enrollment__c enrollment;
        @AuraEnabled
        public CXE_Heroku_Model.BillDetail billDtl;
    }


    @AuraEnabled
    public static String presign(String name){
        // Deprecated
        return CXE_HerokuApps.presign(name);


        // USE:
        // return CXE_HerokuApps.pdf_sign(name, name.replace('|', '-'));
    }

    @AuraEnabled
    public static String pdf_stat(String name){
        
        return CXE_HerokuApps.pdf_stat(name);
    }
}