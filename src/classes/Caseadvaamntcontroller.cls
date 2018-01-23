public class Caseadvaamntcontroller
{
    //public case ThisCase{get;set;}
    //public list<agreement__c> agreements{get;set;}
    //public list<agreement__c> newagreements{get;set;}
    //public integer noofagr = 0;
    //public double oriadvamnt = 0;
    //public double Newadvamnt = 0;
    //public double diffadvamnt = 0;
    //public double advtoagradd = 0;
    //public boolean flag{get;set;}
    //public double Advamntnew{get;set;}
    //private ApexPages.StandardController stdController;
    public Caseadvaamntcontroller(ApexPages.StandardController controller) 
    {
        //this.stdController = controller;
        //this.ThisCase = (Case)controller.getRecord();
        //agreements = new list<agreement__c>();
        //flag = False;
       
        //newagreements = new List<agreement__c>();
        //ThisCase=[select id,accountid,CaseNumber,Contract__c,Advance_amount__c,New_Advance_amount__c,Status  from case where id=:controller.getrecord().id];    
        //Advamntnew=Thiscase.New_Advance_amount__c;
        //for(Agreement__c agr: [select Id,Advance_amount__c,Name from Agreement__c where Contract__c =:ThisCase.Contract__c])
        //{
        //    agreements.add(agr);
        //    noofagr = noofagr+1;
        //}                
    }
    
    //public void calculatenewval()
    //{
    //    if(isverified())
    //    {
    //        newagreements.clear();
    //        flag = True;
    //        //ThisCase=[select id,accountid,CaseNumber,Contract__c,Advance_amount__c,New_Advance_amount__c  from case where id=:Thiscase.id];
    //        oriadvamnt = Thiscase.Advance_amount__c;
    //        system.debug('Original Amount'+oriadvamnt);
    //        Newadvamnt = Advamntnew;
    //        system.debug('New Amount'+Newadvamnt);
    //        diffadvamnt = Newadvamnt - oriadvamnt;
    //        advtoagradd = diffadvamnt/noofagr;
    //        system.debug('Amount Getting Added'+advtoagradd);
    //        for(Agreement__c agr: agreements)
    //        {
    //            agr.Advance_amount__c += advtoagradd;
    //            agr.Case__c = ThisCase.Id;
    //            newagreements.add(agr);
    //        }
    //    }    
    //    //update newagreements;
    //    //return newagreements;
    //}
    
    //public pagereference customsave()
    //{
    //    PageReference page = null;
    //    try
    //    {
    //        Thiscase.New_Advance_amount__c=Advamntnew;
    //        Thiscase.status = 'Back-end Handling';
    //        update newagreements;
    //        update Thiscase;
    //        page = stdController.view();
            
    //    }
    //    catch(Exception exp)
    //    {
    //        page = null;
    //        ApexPages.addMessages(exp);
    //    }          
    //    return page;
    //}
    
    //public boolean isverified()
    //{
    //    Boolean ischecked = true;
        
    //    if(Advamntnew == null || Advamntnew == 0)
    //    {
    //        ischecked = false;
    //        Apexpages.Message  msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'New Advance Amount Cannot be Zero');
    //        apexpages.addmessage(msg);
    //    }
    //    if(Advamntnew == Thiscase.Advance_amount__c)
    //    {
    //        ischecked = false;
    //        Apexpages.Message  msg = new ApexPages.Message(ApexPages.Severity.Error, 'New and Old Advance Amounts are same. Please change the New Advance Amount');
    //        apexpages.addmessage(msg);
    //    }        
        
    //    if((Advamntnew < (Thiscase.Advance_amount__c * 0.75)) || (Advamntnew > (Thiscase.Advance_amount__c * 1.25)))
    //    {
    //        ischecked = false;
    //        Apexpages.Message  msg = new ApexPages.Message(ApexPages.Severity.Error, 'The new Advance amount may not be 25% higher or lower than the original Advance amount');
    //        apexpages.addmessage(msg);
    //    }                
    //        return ischecked;     
    //}
    
    //public pagereference cancel()
    //{
    //    PageReference page = null;
    //    page = stdController.view();
    //    return page;  
    //}
    
    //public String title
    //{
    //    get {
    //        return 'Case' + ' - Advance Amount';
    //    }
    //}
}