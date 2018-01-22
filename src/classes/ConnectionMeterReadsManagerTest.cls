/**
  * @author       : Sanchayeeta
  * @date         : 05/11/2015
  * @description  : Test Class for ConnectionMeterReadsManager class 
  */  
@isTest
public class ConnectionMeterReadsManagerTest{
 /*    
    private static testMethod void TestMet(){
            
        //inserting Account
        Account acc=new Account();
        acc.LastName = 'SanTestSanS';
        acc.Phone = '55555555';
        insert acc;
        
        
        //inserting Connection
        Connection__c connect =new Connection__c();
        connect.Account__c=acc.id;
        connect.name='Test San Connect';
        connect.Utility_type__c = 'Electricity';
        connect.EAN__c ='89898989';
        insert connect;
        
        //inserting CAse Connection
        Case_Connection__c caseConnect = new Case_Connection__c();
        caseConnect.Connection__c= connect.id;
        caseConnect.Type__c= 'Move In';
        caseConnect.Meter_Read_Date__c= System.today();
        caseConnect.Meter_Read_Value__c = 50.02;
        insert caseConnect;
        
        Case_Connection__c newManualMeterRead=[select Meter_Read_Date__c,Meter_Read_Value__c from Case_Connection__c where id =: caseConnect.id];
         
        Date d5 = Date.newInstance(2015, 3, 29);
        system.Test.startTest();                   
        ConnectionMeterReadsManager cTerm= new ConnectionMeterReadsManager(connect.EAN__c);
        //cTerm.meterReadsAsGoogleChartsJson();
        cTerm.fetchMeterReads();
        system.Test.stopTest();
        
        
        
  
    
    }*/  
}