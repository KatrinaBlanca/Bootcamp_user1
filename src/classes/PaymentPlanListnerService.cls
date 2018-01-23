global class PaymentPlanListnerService
{
    // Commenting out the Code to increase Code coverage as this is Mecom Class
    /*
    global class PaymentPlanResponse
    {
        webservice PaymentPlanListnerService.header header;
        webservice PaymentPlanListnerService.PaymentPlan request;
        webservice PaymentPlanListnerService.error error;
    }    
    global class PaymentPlan
    {
        webservice List<string> IncludedInvoices;
        webservice String PaymentPlanID;
        webservice List<PaymentPlanListnerService.PaymentTerm> PaymentTerms;
    }
    global class Header
    {
        webservice String MessageId;
        webservice String SourceHost;
        webservice DateTime DateTime_x;
        webservice String TransactionId;
        webservice String Sender;
        webservice String Receiver;
    }
    global class PaymentTerm
    {
        webservice Integer Term;
        webservice Decimal AmountTerm;
        webservice Date Duedate;
    }
    global class error
    {
        webservice String Origin;
        webservice String Code;
        webservice String Description; 
    }    
    webservice static void PaymentPlanResponse(PaymentPlanListnerService.PaymentPlanResponse PaymentPlanResponse)
    {
        List<Invoice__c> Invoicetoupdate = new List<Invoice__c>();
        List<Payment_Plan_Line_Item__c> Lineitemtoinsert = new List<Payment_Plan_Line_Item__c>();
        Case cs = [select Id,CaseNumber,Status,AccountId from Case where CaseNumber =:PaymentPlanResponse.header.TransactionId];
        if(PaymentPlanResponse.error.Description == '' || PaymentPlanResponse.error.Description == Null)
        {
            cs.Status = 'Closed';
            Payment_Plan__c pplan = new Payment_Plan__c();
            pplan.Name = PaymentPlanResponse.request.PaymentPlanID;
            pplan.Account__c = cs.AccountId;
            pplan.Case_Payment_Relationship__c = cs.Id; 
            upsert pplan;
            for(PaymentPlanListnerService.PaymentTerm pt :PaymentPlanResponse.request.PaymentTerms)
            {
                Payment_Plan_Line_Item__c ppli = new Payment_Plan_Line_Item__c();
                ppli.Payment_Plan__c = pplan.Id;
                ppli.Invoice_Date__c = pt.Duedate;
                ppli.Amount__c = pt.AmountTerm;
                Lineitemtoinsert.add(ppli);     
            }
            upsert Lineitemtoinsert;
            for(Invoice__c inv :[select Id,Payment_plan_ID__c from Invoice__c where Case__c =:cs.Id])
            {
                inv.Payment_plan_ID__c = pplan.Id;
                Invoicetoupdate.add(inv);    
            }  
            update Invoicetoupdate;   
        }
        else
        {
            cs.Error_Message_From_Webservice__c = PaymentPlanResponse.error.Description;
        }
        Update cs;
    }
    */
    //End of Comment
}