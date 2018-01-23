/* Author : Melvin Corbes
 * Date : 10-13-2017 
 * Description: Deactivate Portal Users if Sole Service was terminated and has no enrollment activity after 30 days.
 * 
 */

global class CXE_CP_TerminatedSoleServiceDeactBatch implements Database.Batchable<sObject>{
    
    
    private Id portalCommProfId = [SELECT Id FROM Profile WHERE Name =: CXE_Constants.PORTAL_COMMUNITY_PROFILE].Id;
    private Integer nDays;
    public CXE_CP_TerminatedSoleServiceDeactBatch(Integer xDays){
        nDays = xDays;
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        
        // get all services terminated date of all active users 
        // after 30 days from now
        String query = 'SELECT Id,CXE_ServiceId__c,CXE_UserId__c,  '
            +' CXE_SERVICEID__r.Agreement_End_Date__c, '
            +' CXE_isLastEnrolledService__c '
            +' FROM CXE_Service_Enrollment__c WHERE CXE_UserId__r.Profile.Id =:portalCommProfId '
            +' AND CXE_UserId__r.isActive =True '
            +' AND CXE_SERVICEID__r.Agreement_End_Date__c != NULL '
            +' AND CXE_ServiceTerminated__c = True '
            +' AND CXE_IsActive__c =True  '
            +' AND CXE_SERVICEID__r.Agreement_End_Date__c < LAST_N_DAYS:'+nDays+'  '
            +' ORDER BY CXE_SERVICEID__r.Agreement_End_Date__c DESC '; 
             
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CXE_Service_Enrollment__c> scope)
    {
        try{
            /*  Map that contains User Id and  Set of Service Terminated Date
             *  Map values will only contain one record with the most Recent Service Terminated Date
             */
            Map<Id, Set<Date> > terminatedServicesMap = new   Map<Id, Set<Date> >(); 
            
            for(CXE_Service_Enrollment__c enrollRec: scope){
                
                if(!terminatedServicesMap.containsKey(enrollRec.CXE_UserId__c)) {
                    
                    terminatedServicesMap.put(enrollRec.CXE_UserId__c, new Set<Date> {enrollRec.CXE_SERVICEID__r.Agreement_End_Date__c});
                } 
            }//end of for loop
            
            
            /* Identify if Users Still Have active Enrollments
             * If users is found in the query result
             * remove the User in terminatedServicesMap
             */
            for(CXE_Service_Enrollment__c enrollRec: [SELECT Id,CXE_UserId__c  
                                                      FROM CXE_Service_Enrollment__c
                                                      WHERE CXE_isActive__c = TRUE
                                                      AND CXE_ServiceTerminated__c = FALSE
                                                      AND CXE_UserId__c IN: terminatedServicesMap.keySet()] ){
                                                          
                                                          if(terminatedServicesMap.containsKey(enrollRec.CXE_UserId__c)){                                                              
                                                              terminatedServicesMap.remove(enrollRec.CXE_UserId__c); 
                                                          }//end of if                                           
                                                      }//end of for loop
            
            //Check if the map contains Data to be processed.
            if(terminatedServicesMap.size() > 0){ 
                
                
                //Query the Portal User to be Updated(Deactivated);
                List<User>  deactivatePortalUserList =[SELECT Id,UserArticleSelected__c,
                                                       IsActive,CXE_CP_isPortalDeactivated__c  		
                                                       FROM USER 
                                                       WHERE Id IN:terminatedServicesMap.keySet()];
                
                
                if(!deactivatePortalUserList.isEmpty()){
                    
                    for(User userRec :deactivatePortalUserList){
                        userRec.IsActive =False;
                        userRec.CXE_CP_isPortalDeactivated__c =TRUE;
                        userRec.UserArticleSelected__c ='Due to Sole Service was Terminated';
                    }
                    
                    update deactivatePortalUserList;
                }   

            }// end of if
            
            
            
        
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_TerminatedSoleServiceDeact_Batch', 'execute', ex.getMessage());
        }
        
        
    }  
    
    global void finish(Database.BatchableContext BC){
        //START CSM-14098 Corbes Melvin - chain batch
        CXE_CP_UnEnrollServiceBatch b  = new CXE_CP_UnEnrollServiceBatch();
        Database.executebatch(b,200);
		//END CSM-14098 Corbes Melvin - chain batch
        
    }
    
    
    
    
    
    
}