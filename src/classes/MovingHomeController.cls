public with sharing class MovingHomeController
{
   //public case ThisCase{get;set;}
   //public list<AgreementWrapper> agreementWrap{get;set;}
   //Public List<agreement__C> AgreementstoUpdate;
   //Public List<agreement__C> Agreementoncase;
   //Public List<Prevmeterresponse> resp {get;set;}
   //public map<Id,Case> agrtocasemap;
   //public datetime Startdate1;
   //public datetime Enddate1;
   //public account acc;
   //Public List<Id> SelectedagreementIds;
   //public Map<Id,agreement__c> ConnectionIdtoAgreementmap;
   //public map<Id,List<Prevmeterresponse>> ConnectionIdtoResponsemap{get;set;}
   //public Map<Id, Case_Connection__c> connectionIdToCaseConnectionMap {get; set;}
   //public Map<Date,MeterRead> meterReads {get; set;} 
   //public Map<Id, Connection__c> connectionIdToConnectionMap{get;set;}
   //public list<Case_Connection__c> caseconnections;
   //public map<id,string> connectionidtographmap{get;set;} 
   //public string Cid{get;set;}
   
   
    public MovingHomeController (ApexPages.StandardController controller) 
    {
        //Cid = Null;
        //acc = new Account();
        //connectionidtographmap = new map<id,string>();
        //connectionIdToCaseConnectionMap = new Map<Id, Case_Connection__c>();
        //connectionIdToConnectionMap = new Map<Id, Connection__c>();
        //ConnectionIdtoResponsemap = new map<Id,List<Prevmeterresponse>>();
        //meterReads = new map<Date,MeterRead>();
        //this.ThisCase = (Case)controller.getRecord();
        //agreementWrap=new list<AgreementWrapper>();
        //AgreementstoUpdate  = new List<agreement__C>();
        //Agreementoncase = new List<agreement__C>();
        //agrtocasemap = new map<Id,Case>();
        //caseconnections = new list<Case_Connection__c>();
        
        //ThisCase=[select id,accountid,status,CaseNumber,Subject,Moving_to_Street__c,Moving_to_Postal_Code__c, Moving_to_City__c,Effective_date_of_Move_Out__c  from case where id=:controller.getrecord().id];
        //acc = [select Id, BillingStreet, BillingPostalCode,BillingCity from Account where Id =:ThisCase.accountid];
        //Agreementoncase = [select id from Agreement__C where Case__c = :Thiscase.Id];
        //for(agreement__C ags: Agreementoncase)
        //{ 
        //    agrtocasemap.put(ags.Id,Thiscase);
        //}
        
        //for(agreement__C ag:[select id ,Account__c,name,Commercial_Product__c,Agreement_Duration_Months__c,Agreement_Start_Date__c,Agreement_End_Date__c,
        //                         Advance_Frequency_months__c,Advance_amount__c,Charges_for_breach_of_contract__c from agreement__c where Account__c =:ThisCase.accountid and Active_Agreement__c=true])
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
        //Startdate1 = Datetime.now()-365;
        //Enddate1 = Datetime.now();
          
    }
    
    //public class AgreementWrapper
    //{
    //  public Agreement__C agreement{get;set;}
    //  public boolean Sel{get;set;}
    //}
    
    //public class Prevmeterresponse implements comparable
    //{
    //    public string ReadingDateTime1 {get;set;}
    //    public Date ReadingDateTime2 {get;set;}
    //    public String ReadingOrigin1 {get;set;}
    //    public String UsageCode1 {get;set;}
    //    public Decimal Value1 {get;set;}
    //    public String utiltarriflabel1 {get;set;}
    //    public string unitofmeasure1 {get;set;}
        
    //    public Integer compareTo(Object compareTo)
    //    {
    //        Prevmeterresponse compareToval = (Prevmeterresponse)compareTo;
    //        if (ReadingDateTime2 == compareToval.ReadingDateTime2) return 0;
    //        if (ReadingDateTime2 > compareToval.ReadingDateTime2) return 1;
    //        return -1; 
    //    }
    //}
    //public pagereference save()
    //{
    //    for(AgreementWrapper agr: agreementWrap)
    //    {
    //        if(agr.sel)
    //        {
    //            agr.agreement.Case__c = ThisCase.Id;
    //            agr.agreement.Agreement_End_Date__c = Thiscase.Effective_date_of_Move_Out__c;
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
    //    acc.BillingStreet = ThisCase.Moving_to_Street__c;
    //    acc.BillingCity = ThisCase.Moving_to_City__c;
    //    acc.BillingPostalCode = ThisCase.Moving_to_Postal_Code__c;
    //    update acc;
    //    Thiscase.status = 'Backend Handling';
    //    update ThisCase;
    //    Upsert caseconnections;
    //    return new ApexPages.StandardController(Thiscase).view();
    //}
    //public pagereference cancel()
    //{
    //    return new ApexPages.StandardController(Thiscase).view();
    //}
    
    //public String title
    //{
    //    get {
    //        return 'Case' + ' - Moving Home';
    //    }
    //} 
    
    //public String subtitle
    //{
    //    get {
    //        return ThisCase.Subject;
    //    }
    //} 
    
    
    //public void getpreviousmeterreadings()
    //{
    //    //// Commenting out the Code to increase Code coverage as this is Mecom Class
    
    //    ConnectionIdtoResponsemap.clear();
    //    SelectedagreementIds = new List<Id>();
    //    ConnectionIdtoAgreementmap = new Map<Id,agreement__c>();
    //    for(AgreementWrapper agr: agreementWrap)
    //    {
    //        if(agr.sel)
    //        {
    //            SelectedagreementIds.add(agr.agreement.Id);
    //        }
    //    }
    //    for(agreement__C ag: [select Connection__c from agreement__c where Id in :SelectedagreementIds])
    //    {
    //        ConnectionIdtoAgreementmap.put(ag.Connection__c,ag);    
    //    }
        
    //    for(Connection__c conn: [select Id,EAN__c,Utility_type__c,Name  from Connection__c where Id in :ConnectionIdtoAgreementmap.keyset()])
    //    {
    //        //resp.clear();
    //        resp = new  List<Prevmeterresponse>();
    //        system.debug('ConnectionIdtest:'+conn);
    //        connectionIdToConnectionMap.put(conn.id,conn);
    //        schemasFerrantiBeAxMecomsCmService.BasicHttpBinding_ITwoWayAsync soapreq = new schemasFerrantiBeAxMecomsCmService.BasicHttpBinding_ITwoWayAsync();
    //        SchemasDatacontractOrg200407Dynamic.Connection CON = new schemasDatacontractOrg200407Dynamic.Connection();
    //        CON.ConnectionID = conn.EAN__c;
    //        schemasDatacontractOrg200407Dynamic.Connection[] ARRCON = new schemasDatacontractOrg200407Dynamic.Connection[1];
    //        ARRCON[0]=CON;
    //        schemasDatacontractOrg200407Dynamic.ArrayOfConnection ARRCONS = new schemasDatacontractOrg200407Dynamic.ArrayOfConnection();
    //        ARRCONS.Connection = ARRCON;
    //            schemasDatacontractOrg200407Dynamic.ArrayOfDevice AOSD = soapreq.ProcessRequest(ARRCONS,StartDate1,EndDate1);
    //            system.debug('EANtest:'+ARRCONS);
    //            if(AOSD.Device != Null)
    //            {
    //                for(schemasDatacontractOrg200407Dynamic.Device DEV : AOSD.Device)
    //                {
    //                    for(schemasDatacontractOrg200407Dynamic.Register REG : DEV.Registers.Register)
    //                    {
    //                        for(schemasDatacontractOrg200407Dynamic.IndexValue IND : REG.IndexValues.IndexValue)
    //                        {
    //                            Prevmeterresponse prev = new Prevmeterresponse();                           
    //                            prev.ReadingDateTime2 = IND.ReadingDateTime.Date();
    //                            prev.ReadingDateTime1 = String.valueof(IND.ReadingDateTime).substring(0,10);
    //                            prev.ReadingOrigin1 = IND.ReadingOrigin;
    //                            prev.UsageCode1 = IND.UsageCode;
    //                            prev.Value1 = IND.Value;
    //                            prev.utiltarriflabel1 = REG.UtilityTariffLabel;
    //                            prev.unitofmeasure1 = REG.UnitOfMeasure;
    //                            resp.add(prev);
    //                        }
    //                    }
    //                }
    //                system.debug('Connectioniid:' +conn.id);
    //                system.debug('responsewegot:' +resp);
    //                ConnectionIdtoResponsemap.put(conn.id,resp);
    //                system.debug('Meterresponse:'+ConnectionIdtoResponsemap);
    //                Case_Connection__c cascon = new Case_Connection__c();
    //                //cascon.Case__c = ThisCase.Id;
    //                cascon.Connection__c = conn.Id;
    //                caseconnections.add(cascon);
    //                connectionIdToCaseConnectionMap.put(conn.Id,cascon);
    //                fetchmeterreads();
    //                meterReadsAsGoogleChartsJson(conn.id);
    //            } 
    //            else
    //            {
    //                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'There are no previous meter readings available for this connection(Agreement):' +Conn.Name +' '+ 'having EAN:' +Conn.Ean__c));
    //            }
                                   
    //     }
          
    ////End of Comment    
    //}
    
    //public map<id,string> meterReadsAsGoogleChartsJson(Id conid)
    //{
    //    // Commenting out the Code to increase Code coverage as this is Mecom Class
    ///*
    //    string s = '[[{type: \'date\', label: \'Date\'}, \'Index\', {role: \'certainty\'}]';
    //    for (MeterRead meterRead: meterReads.values())
    //    {
    //        system.debug('Meter Read:' +meterRead);
    //        s += ', [\'Date(' + meterRead.meterReadDate.year() + ', ' + (meterRead.meterReadDate.month() -1) + 
    //             ', ' + meterRead.meterReadDate.day() + ')\', ' + meterRead.meterReadValue + ', true]';
    //    }
               
    //    s += ']';
        
    //    system.debug('TestS:'+s);
    //    connectionidtographmap.put(conid,s);
    //    system.debug('connetiontographmap:'+connectionidtographmap);
    //    return connectionidtographmap;
    //    */
    ////End of Comment
    //return null;
    //}
    
    //public void updategraph()
    //{
    //// Commenting out the Code to increase Code coverage as this is Mecom Class
    ///*
    //    for(Id conid: connectionIdToCaseConnectionMap.keyset())
    //    {
    //        if(connectionIdToCaseConnectionMap.get(conid).Meter_Read_Date__c != Null && connectionIdToCaseConnectionMap.get(conid).Meter_Read_Value__c != Null)
    //        {
    //        string s = connectionidtographmap.get(conid);
    //        s = s.removeEnd(']');
    //        s += ', [\'Date(' + connectionIdToCaseConnectionMap.get(conid).Meter_Read_Date__c.year() + ', ' + (connectionIdToCaseConnectionMap.get(conid).Meter_Read_Date__c.month() -1) + 
    //                 ', ' + connectionIdToCaseConnectionMap.get(conid).Meter_Read_Date__c.day() + ')\', ' + connectionIdToCaseConnectionMap.get(conid).Meter_Read_Value__c+ ', false]';
    //        s += ']';
    //        //connectionidtographmap.remove(conid);
    //        connectionidtographmap.put(conid,s); 
    //        system.debug('UpdatedString:'+s);
    //        }
    //    }   
    //    */
    ////End of Comment         
    //}    
     
   
    //public class MeterRead 
    //{
    //    public Date meterReadDate {get; set;}
    //    public Decimal meterReadValue {get; set;}
        
    //    public MeterRead(Date meterReadDate, Decimal meterReadValue)
    //    {
    //        this.meterReadDate = meterReadDate;
    //        this.meterReadValue = meterReadValue;
    //    }
        
    //}
    
    //public void fetchmeterreads()
    //{
    //    meterreads.clear();
    //    resp.sort();
    //    for(Prevmeterresponse prev: resp)
    //    {
    //        meterReads.put(prev.ReadingDateTime2,new MeterRead(prev.ReadingDateTime2,prev.Value1));
    //    }
    //    //resp.clear();
    //}     
}