public class AddMeterReadingController
{
    //public case ThisCase{get;set;}
    //public connection__c con{get;set;}
    //public boolean test{get;set;}
    //public boolean displaypopup{get;set;}
    //public boolean displaypopup1{get;set;}
    //public Case_Connection__c CaseCon{get;set;}
    //public list<Case_Connection__c > prevmtrs{get;set;}
    public AddMeterReadingController(apexpages.standardcontroller controller)
    {
        //displaypopup=false;
        //displaypopup1=false;
        //this.ThisCase = (Case)controller.getRecord();
        //ThisCase=[select id,accountid,CaseNumber,Subject,Effective_date_End_of_Contract__c,CaseConnection__c  from case where id=:controller.getrecord().id];
        //con = new connection__c();
        //con = [select Id,Name,Serial_number__c,MRID_Number__c from Connection__c where Id =: Thiscase.CaseConnection__c];
        //CaseCon = new Case_Connection__c();
        //prevmtrs = [select Meter_Read_Date__c,Meter_Read_Value__c,Meter_Reading_Reason__c,Meter_Reading_Status__c,Meter_Reading_Type__c from Case_Connection__c where Connection__c = :con.id ORDER BY Meter_Read_Date__c DESC];
    }
    
    //public String title
    //{
    //    get {
    //        return 'Case' + ' - Add Meter Reading';
    //    }
    //} 
    
    //public String subtitle
    //{
    //    get {
    //        return ThisCase.Subject;
    //    }
    //}
    
    //public pagereference cancel()
    //{
    //    return new ApexPages.StandardController(Thiscase).view();
    //}
    
    //public pagereference save()
    //{
    //    pagereference pr;
    //    if(CaseCon.Meter_Read_Value__c == Null)
    //    {
    //        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
    //        return Null;
    //    }
    //    if(CaseCon.Plausibility_Result__c == 'Meter Reading Plausible' || CaseCon.Plausibility_Result__c == Null)
    //    {
    //        CaseCon.Account__c = Thiscase.accountid;
    //        casecon.Case__c = Thiscase.Id;
    //        CaseCon.Connection__c = con.id;
    //        CaseCon.MRID_Number__c = con.MRID_Number__c;
    //        insert CaseCon;
    //        Thiscase.Meter_Read_Value__c = CaseCon.Meter_Read_Value__c;
    //        Thiscase.Meter_Read_Date__c = CaseCon.Meter_Read_Date__c;
    //        Thiscase.Meter_Reading_Reason__c = CaseCon.Meter_Reading_Reason__c;
    //        Thiscase.Meter_Reading_Type__c = CaseCon.Meter_Reading_Type__c;
    //        Thiscase.Meter_Reading_Status__c = CaseCon.Meter_Reading_Status__c;
    //        Thiscase.Plausibility_Result__c = CaseCon.Plausibility_Result__c;
    //        Thiscase.Reason_To_Release__c = CaseCon.Reason_To_Release__c;
    //        Thiscase.Reason_For_Rejection__c = CaseCon.Reason_For_Rejection__c;
    //        //Thiscase.Meter_Read_Status__c = 'Approved'; //Michael Lasala MAR-31-17 Commented out because record type does not have any selected picklist values
    //        Thiscase.status='Back-end Handling';
    //        Update Thiscase;
    //        pr = new ApexPages.StandardController(Thiscase).view();
    //        return pr;
    //    }
    //    else
    //    {
    //        displaypopup = true;
    //        pr = null;
    //        return pr;
    //    }
        
    //}    
    //public void plausibility()
    //{
    //    Decimal newvalue = CaseCon.Meter_Read_Value__c;
    //    List<Case_Connection__c> cc = [select Meter_Read_Value__c from Case_Connection__c where Connection__c = :con.Id ORDER BY Meter_Read_Date__c DESC LIMIT 1];
    //    if(!cc.isempty())
    //    {
    //        Case_Connection__c ccc = cc[0];
    //        Decimal oldvalue = ccc.Meter_Read_Value__c;
    //        if(newvalue > oldvalue)
    //        {
    //            test=true;
    //            CaseCon.Plausibility_Result__c = 'Meter Reading Plausible';    
    //        }
    //        else
    //        {
    //            test=false;
    //            CaseCon.Plausibility_Result__c = 'Meter Reading Not Plausible';    
    //        }
    //     }            
    //}
    //public void closePopup()
    //{
    //    displayPopup = false;

        
    //}
    
    //public void closepopup1()
    //{
    //    displayPopup1 = false;
    //}
    //public pagereference savemr()
    //{
    //        displayPopup = false;
    //        //CaseCon.Account__c = Thiscase.accountid; //Michael Lasala MAR-31-17 Commented out: Field is not writeable: Case_Connection__c.Account__c
    //        casecon.Case__c = Thiscase.Id;
    //        //CaseCon.Connection__c = con.id; //Michael Lasala MAR-31-17 Commented out: Field is not writeable: Case_Connection__c.Connection__c
    //        CaseCon.MRID_Number__c = con.MRID_Number__c;
    //        //CaseCon.Meter_Serial_Number__c = con.Serial_number__c;
    //        //ccc.Meter_Read_Date__c =  CaseCon.Meter_Read_Date__c;
    //        //ccc.Meter_Read_Value__c = CaseCon.Meter_Read_Value__c;
    //        //insert CaseCon; //Michael Lasala MAR-31-17 Commented out: Cannot specify Id in an insert call: [Id]
    //        Thiscase.Meter_Read_Value__c = CaseCon.Meter_Read_Value__c;
    //        Thiscase.Meter_Read_Date__c = CaseCon.Meter_Read_Date__c;
    //        Thiscase.Meter_Reading_Reason__c = CaseCon.Meter_Reading_Reason__c;
    //        Thiscase.Meter_Reading_Type__c = CaseCon.Meter_Reading_Type__c;
    //        Thiscase.Meter_Reading_Status__c = CaseCon.Meter_Reading_Status__c;
    //        Thiscase.Plausibility_Result__c = CaseCon.Plausibility_Result__c;
    //        Thiscase.Reason_To_Release__c = CaseCon.Reason_To_Release__c;
    //        Thiscase.Reason_For_Rejection__c = CaseCon.Reason_For_Rejection__c;
    //        //Thiscase.Meter_Read_Status__c = 'Approved But Not Plausible'; //Michael Lasala MAR-31-17 Commented out because record type does not have any selected picklist values
    //        Thiscase.status='Back-end Handling';
    //        Update Thiscase;
    //        return new ApexPages.StandardController(Thiscase).view();    
    //} 
    
    //public pagereference donotsave()
    //{
    //    if(CaseCon.Meter_Read_Value__c == Null)
    //    {
    //        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
    //        return Null;
    //    }
        
    //    if(CaseCon.Plausibility_Result__c == 'Meter Reading Plausible')
    //    {
    //        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You cannot reject a meter read if it is plausible'));
    //        return Null;
    //    }
    //    displaypopup1 = True;
    //    pagereference pr;
    //    pr= Null;
    //    return pr;
    //}
    
    //public pagereference donotsavemr()
    //{
    //        displayPopup = false;
    //        Thiscase.Meter_Read_Value__c = CaseCon.Meter_Read_Value__c;
    //        Thiscase.Meter_Read_Date__c = CaseCon.Meter_Read_Date__c;
    //        Thiscase.Meter_Reading_Reason__c = CaseCon.Meter_Reading_Reason__c;
    //        Thiscase.Meter_Reading_Type__c = CaseCon.Meter_Reading_Type__c;
    //        Thiscase.Meter_Reading_Status__c = CaseCon.Meter_Reading_Status__c;
    //        Thiscase.Plausibility_Result__c = CaseCon.Plausibility_Result__c;
    //        Thiscase.Reason_To_Release__c = CaseCon.Reason_To_Release__c;
    //        Thiscase.Reason_For_Rejection__c = CaseCon.Reason_For_Rejection__c;
    //        //Thiscase.Meter_Read_Status__c = 'Rejected'; //Michael Lasala MAR-31-17 Commented out because record type does not have any selected picklist values
    //        Update Thiscase;
    //        return new ApexPages.StandardController(Thiscase).view();    
    //}    
    
    //public void correctinvoice()
    //{
    //    displayPopup = true;
        
    //}    
}