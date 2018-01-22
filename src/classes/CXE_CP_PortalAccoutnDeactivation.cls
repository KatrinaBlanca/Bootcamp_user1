/*Author: Melvin Corbes
* Jul-26-2017
*/
public without sharing class CXE_CP_PortalAccoutnDeactivation { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    
    @AuraEnabled
    public static Boolean hasSinPaperLessBilling(){
        
        List<CXE_Service_Enrollment__c> serviceEnrolled = [SELECT CXE_ServiceId__c  
                                                           	FROM  CXE_Service_Enrollment__c 
                                                           	WHERE CXE_UserId__c=:UserInfo.getUserId()];
        
        Set<Id> serviceIds = new Set<ID>();
        for(CXE_Service_Enrollment__c cxeRec: serviceEnrolled){
            
            serviceIds.add(cxeRec.CXE_ServiceId__c);
            
        }
        
  	   Set<String> serviceString = new Set<String>();
       List <Agreement__c> services = [SELECT SIN__c FROM Agreement__C
                                       WHERE Id IN :serviceIds];
        
       List<Agreement__c> checkBillPrintMode= [SELECT payor__r.Bill_Print_Mode__c FROM Agreement__c WHERE SIN__c IN:serviceString];
        
        
        if(checkBillPrintMode.size() > 0){
            
         return  true; 
            
        }else{
            
           return false; 
            
        }
        
       
        
        
        
    }      
    
}