public with sharing class CXE_Heroku_Model {

    public class PaymentDetail {
        @AuraEnabled
        public string referenceNum;
        
        @AuraEnabled
        public string paymentOffice;
        
        @AuraEnabled
        public allocation[] allocation;
        
        @AuraEnabled
        public string paymentMode;
        
        @AuraEnabled
        public string paymentSource;
        
        @AuraEnabled
        public string postingDate;
        
        @AuraEnabled
        public string paymentDate;
        
        @AuraEnabled
        public decimal paidAmount;
        
        @AuraEnabled
        public string collectionStatus; //public string paymentStatus; CSM-14393 Jerome To 11/10/2017 updated to collectionStatus 
        
    }
    
    public class allocation {
        @AuraEnabled
        public string serviceNum;
        
        @AuraEnabled
        public decimal paidAmount;
    }
    /* 
    public class PaymentDetail {
        @AuraEnabled
        public Payment payment;
        @AuraEnabled
        public Payment_Transaction payment_Transaction;
    }

    public class Payment {

        @AuraEnabled
        public String payment_office;
        @AuraEnabled
        public String ref_number;
        @AuraEnabled
        public String account_number;
        @AuraEnabled
        public String collection_status;
        @AuraEnabled
        public String payment_mode;
        @AuraEnabled
        public decimal paid_amount; //CSM-12437 Emandolado 9/5/2017
        @AuraEnabled
        public Payment_allocation[] payment_allocation; //CSM-12513 GGrandea 09.13.2017
        @AuraEnabled
        public String payment_source;
        @AuraEnabled
        public String posting_date;
        @AuraEnabled
        public String document_id;
        @AuraEnabled
        public String payment_date;
    }

    public class Payment_allocation { //CSM-12513 GGrandea 09.13.2017
        @AuraEnabled
        public Bill_note[] bill_note; //CSM-12513 GGrandea 09.13.2017
        @AuraEnabled
        public decimal paid_amount; //CSM-12437 Emandolado 9/5/2017
    }

    */
    public class Bill_note { //CSM-12513 GGrandea 09.13.2017
        @AuraEnabled
        public String service_number;
    }

    public class Payment_Transaction {
        @AuraEnabled
        public Payment_Transaction_Item payment_Transaction_Item;
        @AuraEnabled
        public long payment_amount;
        @AuraEnabled
        public String response_time;
        @AuraEnabled
        public String id;
    }

    public class Payment_Transaction_Item {
        @AuraEnabled
        public String account_number;
        @AuraEnabled
        public long payment_amount;
        @AuraEnabled
        public String service_number;
    }
    
    public class BillDetail {
        @AuraEnabled
        public String account_number;
        @AuraEnabled
        public String bill_demand;
        @AuraEnabled
        public String bill_date;
        @AuraEnabled
        public String due_date;
        @AuraEnabled
        public String is_placement;
        @AuraEnabled
        public String bill_status;
        @AuraEnabled
        public String invoice_date;
        @AuraEnabled
        public String pending_amount;
        @AuraEnabled
        public String gen_date;
        @AuraEnabled
        public String bill_status_filter;
        @AuraEnabled
        public String collection_status;
        @AuraEnabled
        public String bill_number;
        @AuraEnabled
        public String last_bill_date;
        @AuraEnabled
        public String bill_type_filter;
        @AuraEnabled
        public String total_amount;
        @AuraEnabled
        public String fwv_amount;
        @AuraEnabled
        public String bill_usage;
        @AuraEnabled
        public String bill_type;
        @AuraEnabled
        public String is_under_complaint;
        @AuraEnabled
        public String invoice_id;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String service_number;
        @AuraEnabled
        public String invoice_number;
        @AuraEnabled
        public String cwt_amount;
        //START CSM-11087, CSM-11093, CSM-11099, CSM-11105, CSM-11111, CSM-11117 RReyes JUL-25-17
        @AuraEnabled
        public String isSINDisabled;
        @AuraEnabled
        public String isAccountDisabled;
        @AuraEnabled
        public String toolTipMessage;
        @AuraEnabled
        public String isSINSelected;
        @AuraEnabled
        public String isAccountSelected;
        @AuraEnabled
        public Decimal subTotal;
        @AuraEnabled
        public String alias;
        //END CSM-11087, CSM-11093, CSM-11099, CSM-11105, CSM-11111, CSM-11117 RReyes JUL-25-17
        //START CSM-11039 RReyes AUG-17-17 - for PDF vault
        @AuraEnabled
        public String document_id;
        //END CSM-11039 RReyes AUG-17-17 - for PDF vault
        // START CSM-13777 Jerome To 10/11/2017
        @AuraEnabled
        public String is_replacement_bill;
        // END CSM-13777 Jerome To 10/11/2017
    

        //START CSM-12645 RReyes SEP-22-17
        @AuraEnabled
        public boolean hasDisabledSIN;
        @AuraEnabled
        public boolean isSingleSINSelected;
        @AuraEnabled
        public boolean isSingleSINSelectAll;
        @AuraEnabled
        public boolean allSINsEnrolled;
        //END CSM-12645 RReyes SEP-22-17

        //START CSM-12629 RReyes SEP-29-17
        @AuraEnabled
        public boolean isSINAllSelectable;
        @AuraEnabled
        public boolean allSINselected;
        @AuraEnabled
        public boolean hasAnyOverdue;
        @AuraEnabled
        public boolean hasOverduePayNow;
        @AuraEnabled
        public boolean hasOverdueForDisconnection;
        @AuraEnabled
        public boolean hasOverdueDisconnected;
        @AuraEnabled
        public boolean hasOverdueTerminated;
        //END CSM-12629 RReyes SEP-29-17

        //START CSM-12705 RReyes OCT-24-17 
        @AuraEnabled
        public String contractExternalId;
        //END CSM-12705 RReyes OCT-24-17 
        
        //START JFERNANDEZ NOV-30-17
        @AuraEnabled
        public String billStartEndDate;
        //END JFERNANDEZ NOV-30-17
    }
    
    public class ConglomerateDetail{
        @AuraEnabled
        public String account_id;
        
        @AuraEnabled
        public String parent_id;
        
        @AuraEnabled
        public integer direct_sin;
        
        @AuraEnabled
        public decimal direct_kwh;
        
        @AuraEnabled
        public decimal direct_bill_demand;
        
        @AuraEnabled
        public decimal direct_prev_bal;
        
        @AuraEnabled
        public decimal direct_bill_amt;
        
        @AuraEnabled
        public decimal direct_pay_amt;
        
        @AuraEnabled
        public decimal direct_pending_amt;
        
        @AuraEnabled
        public integer total_sin;
        
        @AuraEnabled
        public decimal total_kwh;
        
        @AuraEnabled
        public decimal total_bill_demand;
        
        @AuraEnabled
        public decimal total_prev_bal;
        
        @AuraEnabled
        public decimal total_bill_amt;
        
        @AuraEnabled
        public decimal total_pay_amt;
        
        @AuraEnabled
        public decimal total_pending_amt;
        
    }
    
    public class ConglomerateDisplay{
        @AuraEnabled
        public String account_id;
        
        @AuraEnabled
        public String name;
        
        @AuraEnabled
        public integer sin = 0;
        
        @AuraEnabled
        public decimal kwh = 0;
        
        @AuraEnabled
        public decimal bill_demand = 0;
        
        @AuraEnabled
        public decimal prev_bal = 0;
        
        @AuraEnabled
        public decimal bill_amt = 0;
        
        @AuraEnabled
        public decimal pay_amt = 0;
        
        @AuraEnabled
        public decimal pending_amt = 0;
            
    }
    
    //START CSM-XXX Wenjun - Mobile Business Service
    //Wrappper for Mobile Service
    public class BillDtlWrapper{
        public BillDtlWrapper(CXE_Heroku_Model.BillDetail billDetail){
            this.billDtl = billDetail;
        }
        @AuraEnabled
        public CXE_Heroku_Model.BillDetail billDtl;
    }
    //END CSM-XXX Wenjun - Mobile Business Service
    
    //START Wenjun 26 Oct - Bill Summary Page Performance Optimization CSM-14404 (Applied 11.27.2017)
    public class BillSummary {
        @AuraEnabled
        public String acctNum;
        @AuraEnabled
        public String billDt;
        @AuraEnabled
        public String dueDt;
        @AuraEnabled
        public String invDt;
        @AuraEnabled
        public String penAmt;
        @AuraEnabled
        public String payStatus;
        @AuraEnabled
        public String totalAmt;
        @AuraEnabled
        public String billType;
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String svcNum;
        @AuraEnabled
        public String isSINOff;
        @AuraEnabled
        public String isAcctOff;
        @AuraEnabled
        public String msg;
        @AuraEnabled
        public String isSINSel;
        @AuraEnabled
        public String isAcctSel;
        @AuraEnabled
        public Decimal subTotal;
        @AuraEnabled
        public String alias;
    

        //START CSM-12645 RReyes SEP-22-17
        @AuraEnabled
        public boolean hasDisabledSIN;
        @AuraEnabled
        public boolean isSingleSINSelected;
        @AuraEnabled
        public boolean isSingleSINSelectAll;
        @AuraEnabled
        public boolean allSINsEnrolled;
        //END CSM-12645 RReyes SEP-22-17

        //START CSM-12629 RReyes SEP-29-17
        @AuraEnabled
        public boolean isSINAllSelectable;
        @AuraEnabled
        public boolean allSINselected;
        @AuraEnabled
        public boolean hasAnyOverdue;
        @AuraEnabled
        public boolean hasOverduePayNow;
        @AuraEnabled
        public boolean hasOverdueForDisconnection;
        @AuraEnabled
        public boolean hasOverdueDisconnected;
        @AuraEnabled
        public boolean hasOverdueTerminated;
        //END CSM-12629 RReyes SEP-29-17

        //START CSM-12705 RReyes OCT-24-17 
        @AuraEnabled
        public String contractExternalId;
        //END CSM-12705 RReyes OCT-24-17 
        
        //START JFERNANDEZ NOV-30-17
        @AuraEnabled
        public String billStartEndDate;
        //END JFERNANDEZ NOV-30-17

        //START CSM-14799 RReyes DEC-05-17
        @AuraEnabled
        public String invoice_id;
        //END CSM-14799 RReyes DEC-05-17
    }
    //END Wenjun 26 Oct - Bill Summary Page Performance Optimization CSM-14404 (Applied 11.27.2017)
    
}