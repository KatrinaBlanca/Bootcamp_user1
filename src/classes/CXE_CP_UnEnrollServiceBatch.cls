/*Author : Melvin Corbes
*Description: Batch that will Unenroll Services for Deactivated User.
*/
global class CXE_CP_UnEnrollServiceBatch  implements Database.Batchable<sObject>, Database.AllowsCallouts{ //CSM-12581 added AllowsCallouts
    Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id FROM USER WHERE isActive =False AND CXE_CP_isPortalDeactivated__c =TRUE AND Profile.Id =:portalCommProfId AND LastModifiedDate =TODAY';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        try{
            
            Set<Id> userIds = new Set<Id>();
            
            for(User uRec: scope){ 
                userIds.add(uRec.Id);
            }
            
            
            if(!userIds.isEmpty()){
                
                
                //updateServiceEnrollment(userIds);
                List<CXE_Service_Enrollment__c> servcEnrollmnt = [SELECT Id, CXE_IsActive__c,
                                                                        CXE_ServiceId__r.Payor__r.V10_Account_No__c,
                                                                        CXE_ServiceId__r.Payor__c,
                                                                        CXE_ServiceId__c,CXE_Unenrollment_Date__c,
                                                                        CXE_UserId__c,CXE_ServiceId__r.SIN__c
                                                                  FROM CXE_Service_Enrollment__c 
                                                                  WHERE CXE_UserId__c IN:userIds AND CXE_IsActive__c = TRUE];
                
                
                //Set of Service ID
                Set<Id> serviceID = new Set<Id>();
                set<Id> sinID = new Set<Id>();
                for(CXE_Service_Enrollment__c cxeSE : servcEnrollmnt ){
                    cxeSE.CXE_Unenrollment_Date__c = System.now();
                    cxeSE.CXE_IsActive__c = False;
                    serviceID.add(cxeSE.CXE_ServiceId__c);
                    sinID.add(cxeSE.Id);
                }

                //get active enrollments from other Portal Users                
                Set<String> sinWithExistingActiveEnrollments = new Set<String>();
                for(CXE_Service_Enrollment__c cxeSE : [SELECT Id, CXE_ServiceId__r.SIN__c
                                                                   FROM CXE_Service_Enrollment__c 
                                                                  WHERE CXE_ServiceId__c IN:serviceID 
                                                                    AND CXE_IsActive__c = TRUE 
                                                                    AND Id NOT IN:sinID] ){

                    sinWithExistingActiveEnrollments.add(cxeSE.CXE_ServiceId__r.SIN__c);
                }
                
                
                /*Author: Melvin Corbes
                * Aug-10-2017 
                * Data Preparation for changing the payor
                * Bill Print mode to Paper
                */ 
                
                Set<Id> contractId = new Set<Id>();
                for(CXE_Service_Enrollment__c servRec : servcEnrollmnt){
                    if(!sinWithExistingActiveEnrollments.contains(servRec.CXE_ServiceId__r.SIN__c)){
                        contractId.add(servRec.CXE_ServiceId__r.Payor__c);
                    }
                }
                
                if(!contractId.isEmpty()){

                    List<Contract> contractRec = [select Id,
                                                        Contract_External_ID__c,
                                                        Bill_Print_Mode__c 
                                                    from Contract 
                                                     where Id =: contractId];
                    
                    //end of Melvin Corbes Aug-8-2017
                        try{
                            
                            //Vincent Mandolado Aug-8-2017
                            
                            //START CSM-13009 GGrandea 09.27.2017
                            /*Set<Id> contractIds = new Set<Id>();
                            Map<String, String> bpmMap = new Map<String, String>();*/                            
                            Map<String, Contract> contractMap = new Map<String, Contract>();
                            Map<String, String> bpmContractMap = new Map<String, String>();
                            //END CSM-13009 GGrandea 09.27.2017

                            
                            for(Contract conRec: contractRec)
                            {
                                //if(conRec.Bill_Print_Mode__c == CXE_Constants.BPM_PAPERPLUS){ //CSM-12581 deactivated

                                //START CSM-13009 GGrandea 09.27.2017
                                    /*contractIds.add(conRec.Id);
                                    bpmMap.put(conRec.Id, CXE_Constants.BPM_PAPER);*/
                                if(conRec.Contract_External_ID__c!=null){
                                    contractMap.put(conRec.Contract_External_ID__c, conRec);
                                    bpmContractMap.put(conRec.Contract_External_ID__c, CXE_Constants.BPM_PAPER);
                                }
                                //END CSM-13009 GGrandea 09.27.2017
                                //}
                            }
                            
                            //START CSM-13009 GGrandea 09.27.2017
                            //CXE_CP_BillPrintModeIntegrationUtility.printmodeUpdateRequestBulk(contractIds,bpmMap);
                            CXE_CP_BillPrintModeIntegrationUtility.updateContract(contractMap,bpmContractMap);
                            //END CSM-13009 GGrandea 09.27.2017
                            
                            //End of Vincent Mandolado Aug-8-2017
                            
                        }catch(Exception e){
                            ErrorHandlerException.recordException(null, true, 'CXE_CP_UnEnrollServiceBatch', 'execute', e.getMessage() );
                        }
                    //} //CSM-12581 Removed - GGrandea 09.15.2017
                    
                }

                update servcEnrollmnt;   

            }
            
            
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_UnEnrollServiceBatch', 'execute', ex.getMessage());
        }
        
        
    }  
    
    global void finish(Database.BatchableContext BC){}
    
    
    
}