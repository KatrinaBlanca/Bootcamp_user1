@isTest
public class sobjectEnterpriseSoapSforceCom_Test{
    
    @isTest static void sObject_Test(){
        
        Test.startTest();
        User  Idvalue = [SELECT Id FROM USER LIMIT 1];
        
        sobjectEnterpriseSoapSforceCom sobj = new sobjectEnterpriseSoapSforceCom();
        //To Access Inner Class
        sobjectEnterpriseSoapSforceCom.sObject_x  sox = new sobjectEnterpriseSoapSforceCom.sObject_x();
        String[] StringArray = new String[]{'fieldsToNull','urn:sobject.enterprise.soap.sforce.com',null,'0','-1','true'};
            
        sox.fieldsToNull = StringArray;
        sox.Id =Idvalue.Id;
        
        sobjectEnterpriseSoapSforceCom.AggregateResult soag = new sobjectEnterpriseSoapSforceCom.AggregateResult();
        sobjectEnterpriseSoapSforceCom.Case_x  soacase = new sobjectEnterpriseSoapSforceCom.Case_x();
        
        System.assert(sox !=null);
        Test.stopTest();
        
    }
}