@isTest
public class CXE_CP_PortalUserInactivityNoti_Test{
    
    
    
    @isTest
    static void HappyPath(){        
        Test.startTest(); 
       
        CXE_CP_PortalUserInactivityNotiBatch b 
            = new CXE_CP_PortalUserInactivityNotiBatch(0);
        Id batchinstanceid = database.executebatch(b,200);
        
        Test.stopTest(); 
        System.assert(batchinstanceid !=null,batchinstanceid);  
    }
    
    @isTest
    static void testScheduleClass(){        
        Test.startTest(); 
        CXE_CP_PortalUserInactivityNotiSched sh1 = new CXE_CP_PortalUserInactivityNotiSched();
        sh1.execute(null);
        Test.stopTest(); 
        
    }    
    
   
}