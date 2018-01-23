public with sharing class ContractTermination
{
   //public case ThisCase{get;set;}
   //public list<AgreementWrapper> agreementWrap{get;set;}
   //Public List<agreement__C> AgreementstoUpdate;
   //Public List<agreement__C> Agreementoncase;
   //public map<Id,Case> agrtocasemap;
    public ContractTermination (ApexPages.StandardController controller) 
    {
        //this.ThisCase = (Case)controller.getRecord();
        //agreementWrap=new list<AgreementWrapper>();
        //AgreementstoUpdate  = new List<agreement__C>();
        //Agreementoncase = new List<agreement__C>();
        //agrtocasemap = new map<Id,Case>();
        
        //ThisCase=[select id,accountid,CaseNumber,Subject,Effective_date_End_of_Contract__c  from case where id=:controller.getrecord().id];
        
        //Agreementoncase = [select id from Agreement__C where Case__c = :Thiscase.Id];
        //for(agreement__C ags: Agreementoncase)
        //{ 
        //    agrtocasemap.put(ags.Id,Thiscase);
        //}
        
        //for(agreement__C ag:[select id ,Account__c,name,Commercial_Product__c,Agreement_Duration_Months__c,Agreement_Start_Date__c,Agreement_End_Date__c,ERP_Agreement_ID__c,
        //                         Advance_Frequency_months__c,Advance_amount__c,Charges_for_breach_of_contract__c,Commercial_Product__r.name from agreement__c where Account__c =:ThisCase.accountid and Active_Agreement__c=true])
        //{
        //    system.debug('true123:' +ag);    
        //  AgreementWrapper agwp=new AgreementWrapper();
        //  agwp.agreement=ag;
        //  if(agrtocasemap.containskey(ag.Id))
        //  {
        //      system.debug('true123');
        //      agwp.sel = true;
        //  }   
        //  agreementWrap.add(agwp);
          
        //}
            
        
    }
    
    //public class AgreementWrapper
    //{
    //  public Agreement__C agreement{get;set;}
    //  public boolean Sel{get;set;}
    //}
    //public pagereference save()
    //{
    //    for(AgreementWrapper agr: agreementWrap)
    //    {
    //        if(agr.sel)
    //        {
    //            agr.agreement.Case__c = ThisCase.Id;
    //            agr.agreement.Agreement_End_Date__c = Thiscase.Effective_date_End_of_Contract__c;
    //            AgreementstoUpdate.add(agr.agreement);
    //        }
    //        if(!agr.sel)
    //        {
    //            if(agrtocasemap.containskey(agr.agreement.Id))
    //            {
    //                agr.agreement.Case__c = null;
    //                AgreementstoUpdate.add(agr.agreement);
    //            }
    //        }                       
    //    }
    //    if(AgreementstoUpdate.size() > 0)
    //    {
    //        update AgreementstoUpdate;
    //    }
    //    if(AgreementstoUpdate.size() == 0)
    //    {
    //        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select atleast 1 agreement to terminate and click on save'));
    //        return null;
    //    } 
    //    ThisCase.status = 'Backend Handling';  
    //    update ThisCase;
    //    return new ApexPages.StandardController(Thiscase).view();
    //}
    //public pagereference cancel()
    //{
    //    return new ApexPages.StandardController(Thiscase).view();
    //}
    
    //public String title
    //{
    //    get {
    //        return 'Case' + ' - Contract Termination';
    //    }
    //} 
    
    //public String subtitle
    //{
    //    get {
    //        return ThisCase.Subject;
    //    }
    //}        
}