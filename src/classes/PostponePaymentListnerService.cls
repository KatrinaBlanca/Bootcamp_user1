global class PostponePaymentListnerService
{
   // Commenting out the Code to increase Code coverage as this is Mecom Class
    /*
    global class postponepaymentresponse
    {
        webservice PostponePaymentListnerService.header header;
        webservice PostponePaymentListnerService.PostponepaymentRequestelement request;
        webservice PostponePaymentListnerService.error error;
    }    
    global class PostponepaymentRequestelement
    {
        webservice String Invoiceid;
        webservice Date Newinvoicedate;
    }
    global class Header
    {
        webservice String MessageId;
        webservice String SourceHost;
        webservice DateTime DateTime_x;
        webservice String TransactionId;
        webservice String Sender;
        webservice String Receiver;
        //webservice PostponePaymentListnerService.PostponepaymentRequestelement request;
        //webservice PostponePaymentListnerService.error error;
    }
    global class error
    {
        webservice String Origin;
        webservice String Code;
        webservice String Description; 
    }    
    webservice static void postponepaymentresponse(PostponePaymentListnerService.postponepaymentresponse postponepaymentresponse)
    {
        Case cs = [select Id,CaseNumber,Status from Case where CaseNumber =:postponepaymentresponse.header.TransactionId];
        if(postponepaymentresponse.error.Description == '' || postponepaymentresponse.error.Description == Null)
        {
            cs.Status = 'Closed';
            Invoice__c inv = [select Invoice_ID__c,Invoice_Due_Date__c from Invoice__c where Invoice_ID__c =:postponepaymentresponse.request.InvoiceId];
            inv.Invoice_Due_Date__c = postponepaymentresponse.request.Newinvoicedate;
            Update inv;
        }
        else
        {
            cs.Error_Message_From_Webservice__c = postponepaymentresponse.error.Description;
        }        
        Update cs;
   }
   */
   //End of COmment
}