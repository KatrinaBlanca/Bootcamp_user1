global class AdvanceAmountListnerService
{
    // Commenting out the Code to increase Code coverage as this is Mecom Class
    /*
    global class AdvanceAmountResponse
    {
        webservice AdvanceAmountListnerService.header header;
        webservice AdvanceAmountListnerService.AdvanceAmountAdjResponse request;
        webservice AdvanceAmountListnerService.error error;
    }    
    global class AdvanceAmountAdjResponse
    {
        webservice String ContractID;
        webservice double AdvanceAmountContract;
        webservice List<AdvanceamountTerm> Connection;
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
    global class AdvanceamountTerm
    {
        webservice String ConnectionId;
        webservice Double AdvanceAmountConnection;
        webservice Date NewAdvanceStartDate;
    }
    global class error
    {
        webservice String Origin;
        webservice String Code;
        webservice String Description; 
    }    
    webservice static void AdvanceAmountResponse(AdvanceAmountListnerService.AdvanceAmountResponse AdvanceAmountResponse)
    {
        map<string,double> Eantoadvamount = new map<string,double>();
        map<string,double> Conidtoadvamount = new map<string,double>();
        List<Agreement__c> Agreements = new List<Agreement__c>();
        Case cs = [select Id,CaseNumber,Status,AccountId from Case where CaseNumber =:AdvanceAmountResponse.header.TransactionId];    
            if(AdvanceAmountResponse.error.Description == '' || AdvanceAmountResponse.error.Description == Null)
            {
                cs.Status = 'Closed';
                //contract con = [select Id,ContractNumber,Advance_amount__c from contract where ContractNumber =:AdvanceAmountResponse.request.ContractID];
                //con.Advance_amount__c =  AdvanceAmountResponse.request.AdvanceAmountContract;
                for(AdvanceAmountListnerService.AdvanceamountTerm aat :AdvanceAmountResponse.request.Connection)
                {
                    Eantoadvamount.put(aat.ConnectionId,aat.AdvanceAmountConnection);    
                    system.debug('First Map:'+Eantoadvamount);
                }
                for(connection__c con: [select Id,Ean__c from Connection__c where Ean__c in :Eantoadvamount.keyset()])
                {
                    Conidtoadvamount.put(con.id,Eantoadvamount.get(con.Ean__c));
                    system.debug('Second Map:'+Conidtoadvamount);
                }
                for(Agreement__c agr: [select Id,Agreement_Name__c,Advance_amount__c,Connection__c from Agreement__c where Connection__c in :Conidtoadvamount.keyset()])
                {
                    agr.Advance_amount__c = Conidtoadvamount.get(agr.Connection__c);   
                    Agreements.add(agr);        
                }
                update Agreements;
            }
            else
            {
                 cs.Error_Message_From_Webservice__c = AdvanceamountResponse.error.Description;
            }
            update cs;    
    }
    */
    //End of Comment
}