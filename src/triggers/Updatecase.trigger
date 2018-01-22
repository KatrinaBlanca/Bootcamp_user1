trigger Updatecase on Agreement__c (before update, after insert)
{
    //if(trigger.isupdate)
    //{
    //    List<string> coninlist = new List<string>();
    //    List<string> coninlist1 = new List<string>();  
    //    List<case> caselist = new List<case>();  
    //    List<case> casetoupdate = new List<case>();
    //    for(Agreement__c agr:trigger.new)
    //    {
    //        if(agr.Integration_Successfull__c)
    //        {
    //            system.debug('Integration' +agr.Integration_Successfull__c);
    //            coninlist.add(agr.Contract__c);
    //        }
    //        if(agr.Integration_Successfull_Cont_Termination__c)
    //        {
    //            coninlist1.add(agr.Contract__c);
    //            system.debug('orenee'+coninlist1.size());
    //        }
    //    }
    //    if(coninlist.size() > 0)
    //    {   
    //        Id recordId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Change Advance Amount').getRecordTypeId();
    //        caselist = [select Id,Contract__c from case where Contract__c in :coninlist and RecordTypeId=:recordId];
    //        for(case cas:caselist)
    //        {
    //            cas.status = 'Closed';
    //            cas.Error_Message_From_Webservice__c = 'Advance Amount Successfully updated in Backend..!!';
    //            casetoupdate.add(cas);
    //        }
    //        update casetoupdate;
    //    }
    //    if(coninlist1.size() > 0)
    //    {   
    //        Id recordId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Handle a Contract Termination').getRecordTypeId();
    //        system.debug('recordtype'+recordId);
    //        caselist = [select Id,Contract__c from case where Contract__c in :coninlist1 and RecordTypeId=:recordId];
    //        system.debug('cases'+caselist);
    //        for(case cas:caselist)
    //        {
    //            cas.status = 'Closed';
    //            cas.Error_Message_From_Webservice__c = 'Contract End Date Updated in Backend Successfully..!!';
    //            casetoupdate.add(cas);
    //        }
    //        update casetoupdate;
    //    }
    //}
    //if(trigger.isinsert)
    //{
    //    system.debug('Inside Insert..!!!');
    //    List<string> accids = new List<string>();
    //    List<String> agrids = new List<String>();
    //    List<Contract> conts = new List<Contract>();
    //    Map<String,string> agrtoprdmap = new map<string,string>();
    //    List<agreement__c> agrmnts = new List<agreement__c>();
    //    //Map<Id,Id> prdid = new map<id,id>();
    //    for(Agreement__c agr:trigger.new)
    //    {
    //        accids.add(agr.Account__c);  
    //        agrids.add(agr.Id); 
    //        system.debug('Agreement Account Ids :' +accids);                 
    //    }
    //    Opportunity opp = [select Id,closedate from Opportunity where Accountid in :accids LIMIT 1];
    //    Date agrsrtdat = opp.closedate;
    //    List<Opportunitylineitem> olis = [select Id,Product2Id,Connection__c from opportunitylineitem where OpportunityId = :opp.id and connection__c != Null];        
    //    //Product2 prd = [select Id,Contract_Duration_Years__c from Product2 where Id = :oli.product2Id];
    //        for(Opportunitylineitem ol:olis)
    //        {
    //            agreement__c agr = new agreement__c();
                
    //            agr.id = agrids[0];
    //            System.debug('agreementid' +agr.id);
    //            agr.Commercial_Product__c = ol.Product2Id;
    //            agr.Agreement_Start_Date__c = agrsrtdat;
    //            agrtoprdmap.put(agr.id,ol.Product2Id);
    //            system.debug('ProductId:' +ol.Product2Id);
    //            agr.Connection__c = ol.Connection__c;
    //            agrmnts.add(agr);
    //            agrids.remove(0);
    //        }
    //        List<Product2> prds = [select Id,Contract_Duration_Years__c from Product2 where Id in :agrtoprdmap.values()];
    //        for(agreement__c agr: agrmnts)
    //        {
    //             for(product2 prd:prds)
    //             {
    //                 if(agr.Commercial_Product__c == prd.id)
    //                 {
    //                     if(prd.Contract_Duration_Years__c == '1 Year')
    //                     {
    //                         agr.Agreement_End_Date__c = agrsrtdat+365;
    //                         agr.Agreement_Duration_Months__c = 12;
    //                     }
    //                    if(prd.Contract_Duration_Years__c == '2 Years')
    //                    {
    //                        agr.Agreement_End_Date__c = agrsrtdat+730;
    //                        agr.Agreement_Duration_Months__c = 24;
    //                    }
    //                    if(prd.Contract_Duration_Years__c == '3 Years')
    //                    {
    //                        agr.Agreement_End_Date__c = agrsrtdat+1095;
    //                        agr.Agreement_Duration_Months__c = 36;
    //                    }
    //                    if(prd.Contract_Duration_Years__c == '4 Years')
    //                    {
    //                        agr.Agreement_End_Date__c = agrsrtdat+1460;
    //                        agr.Agreement_Duration_Months__c = 48;
    //                    }
    //                    if(prd.Contract_Duration_Years__c == '5 Years')
    //                    {
    //                        agr.Agreement_End_Date__c = agrsrtdat+1825;
    //                        agr.Agreement_Duration_Months__c = 60;
    //                    }    
    //                 }
    //             }  
    //             //contract c = new contract();
    //             //c.Id =  agr.Contract__c;
    //             //c.EndDate = agr.Agreement_End_Date__c;
    //             //c.ContractTerm = (Integer)agr.Agreement_Duration_Months__c;
    //             //conts.add(c);
    //        }
    //        update agrmnts;
    //        //update conts;
        
    //}           
}