@isTest
@RestResource(urlMapping='/getArrears/*')
global with sharing class CXE_getArrearsMock{

    @HttpPost
    global static case getResult(String sin, String customerNumber)
    { 
        case arrears = new case();
        arrears.CXE_Existing_Bill_Deposit_Amount__c= Integer.valueOf(sin);
        arrears.CXE_Total_Outstanding_Amount__c= Integer.valueOf(customerNumber);
        
        return arrears; 
    }  
    
/*
URL: /services/apexrest/getArrears/data/v39.0
Body:
{
"sin": "",
"customerNumber": ""
}

*/
}