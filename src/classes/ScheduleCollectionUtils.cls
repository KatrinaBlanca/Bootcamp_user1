/* Description: Utility class to pull the deposit amount from the schedule object.
 * Note that this class is from click
 * Parameters: Case 
 * Returns: Deposit Amount
 * Author: Von Pernicia
 * Date Updated: FEB-21-17
*/     

public class ScheduleCollectionUtils {

    private static Schedule__c GetScheduleByName (List<Schedule__c> listData, string findBy)
    {
        for( Schedule__c o :  listData){
            
            if ((String)o.Schedule_Selector__c  == findBy  ){
                return o;
            }
        }  
        return null;
    } 
    
    /* old method from click: Comment out by Von Pernicia
    private static decimal GetRateByResidType (Schedule__c schedData, string residentialOrNonResidential )
    {
        if (residentialOrNonResidential =='Yes') 
                { 
                    return schedData.Residential_Rate__c;    
                } else {
                    return schedData.Non_Residential_Rate__c;
                }
        return -1;
    }*/
    
    private static decimal GetRateByResidType (Schedule__c schedData, Boolean businessCustomer )
    {
        if (!businessCustomer) 
                { 
                    return schedData.Residential_Rate__c;    
                } else {
                    return schedData.Non_Residential_Rate__c;
                }
        return -1;
    }
    
    // Start CSM-12246 Von Pernicia
    // Start CSM-12256 Von Pernicia: Added isRetrieveService, isClickOutstandingAmount
    public  static void UpdateCaseWithScheduleDepositInfo(Case c, List<Schedule__c> allSchedules, Case oldCase, Boolean isUpdate, String profileName, Boolean isClickUpdateBD, Boolean isRetrieveService, Boolean isClickOutstandingAmount)
    {
        //START CSM-7151 RReyes JUL-07-17
        Boolean isBusiness = false;
        //END CSM-7151 RReyes JUL-07-17
        
        Id newServRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

        if (//!c.Override_Auto_Deposit_Amount__c &&
            //c.Residential_Non_Residential_Tag__c != null && // Old logic from click: Comment out by Von Pernicia
            //c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
            c.applied_load__c > 0 &&  c.applied_load__c <= 5)
        {
            //START CSM-7151 RReyes JUL-10-17 - added condition to compute for GSA or Residential only 
            if(c.Service_Rate_Type__c == CXE_Constants.SERVICE_RATE_TYPE_RES || c.Service_Rate_Type__c == CXE_Constants.SERVICE_RATE_TYPE_GSA
                || c.Service_Rate_Type__c ==CXE_Constants.SERVICE_RATE_TYPE_GHMSCI)// CSMCW-23 // added Logic for CXE_Constants.SERVICE_RATE_TYPE_GHMSCI Corbes Melvin 11-16-2017
            {  
                Schedule__c oSchedData = null;
                if (c.applied_load__c <= 1){
                        oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S1);
         
                    } else if (c.applied_load__c >1  && c.applied_load__c <= 1.5){
                        oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S2);
                       
                    } else if (c.applied_load__c >1.5  && c.applied_load__c <= 2){
                        oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S3);
                      
                    }else if (c.applied_load__c >2  && c.applied_load__c <= 3){
                        oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S4);
                       
                    } else if (c.applied_load__c >3  && c.applied_load__c <= 4){
                        oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S5);
                       
                    }  else if (c.applied_load__c >4  && c.applied_load__c <= 5){
                       oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S6);
                    }  
                    
                     if (oSchedData !=null){
                            c.Bill_Deposit_Schedule__c = oSchedData.id;
                            //START CSM-7151 RReyes JUL-07-17 - use the service rate type as basis instead of the checkbox
                            if(c.Service_Rate_Type__c != CXE_Constants.CASE_SERVICE_RATE_TYPE_RESIDENTIAL_SERVICE_RS){
                                isBusiness = true;
                            }
                            if (!c.Override_Auto_Deposit_Amount__c) {
                                c.Deposit_Amount__c = ScheduleCollectionUtils.GetRateByResidType(oSchedData, isBusiness);

                                if (c.RecordTypeId <> newServRecTypeId)
                                {
                                    if (isUpdate)
                                    {
                                        if (c.Deposit_Amount__c == oldCase.Deposit_Amount__c && (!isRetrieveService && !isClickOutstandingAmount))
                                        {
                                            c.CXE_Required_Deposit_Amount__c = oldCase.CXE_Required_Deposit_Amount__c;        
                                        }
                                    }
                                }
                            }
                            //c.Deposit_Amount__c = ScheduleCollectionUtils.GetRateByResidType(oSchedData, c.Application_for_Business_Service__c);//Rhyan Cruz CSM-2143 Replaced Application_for_Business_Customer__c with Application_for_Business_Service__c
                            //END CSM-7151 RReyes JUL-07-17 - use the service rate type as basis instead of the checkbox
                            // Old logic from click: Comment out by Von Pernicia
                            //c.Deposit_Amount__c = ScheduleCollectionUtils.GetRateByResidType(oSchedData, (string)c.Residential_Non_Residential_Tag__c);
                        }   
            } 
            //END CSM-7151 RReyes JUL-10-17  - added condition to compute for GSA or Residential only    
        }
        
        //Christian Peter Doctolero
        //March 14, 2017
        //CSM-298
        /* Start CSM-7159 Von Pernicia: Comment out
        else if (c.Override_Auto_Deposit_Amount__c &&
            //c.Residential_Non_Residential_Tag__c != null && // Old logic from click: Comment out by Von Pernicia
            c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
            isUpdate &&
            c.Deposit_Amount__c != oldCase.Deposit_Amount__c
           )
        {
            //List<Profile> Profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            //String profileName = PROFILE[0].Name;
            
            System.debug('OVERRIDE STEP 1');
            
            if(profileName == CXE_Constants.PROFILE_NAME_MERALCO_G5 || profileName == CXE_Constants.PROFILE_NAME_MERALCO_G4 ||  profileName == CXE_Constants.PROFILE_NAME_MERALCO_G3 || 
               profileName == CXE_Constants.PROFILE_NAME_MERALCO_G2 || profileName == CXE_Constants.PROFILE_NAME_MERALCO_G1 
               || profileName == CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR)
            {    
                if(oldCase.Deposit_Amount__c >= 1000 && (profileName == CXE_Constants.PROFILE_NAME_MERALCO_G4 || profileName == CXE_Constants.PROFILE_NAME_MERALCO_G5 ))
                {
                    c.addError(CXE_Constants.CASE_ERROR_DEPOSIT_AMOUNT_CHANGE);
                }
            } 
            
            else
            {
                c.addError(CXE_Constants.CASE_ERROR_DEPOSIT_AMOUNT_CHANGE);

            }
            
        }
        End CSM-7159 Von Pernicia: Comment out*/
        else if (
            //c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
            c.applied_load__c > 5)
        {
            if (c.CXE_isClickBillDepositButton__c)
            {
                c.Bill_Deposit_Schedule__c = null;
                c.Deposit_Amount__c = null; 
            }
            else
            {
                if (!c.Override_Auto_Deposit_Amount__c && !isClickUpdateBD) 
                {
                    if (c.RecordTypeId == newServRecTypeId)
                    {
                        if (isUpdate)
                        {
                            c.Deposit_Amount__c = oldCase.Deposit_Amount__c;
                        }
                    }
                    else
                    {
                        if (isUpdate)
                        {
                            c.CXE_Required_Deposit_Amount__c = oldCase.CXE_Required_Deposit_Amount__c;   
                        }
                    }
                }
            }
        }
    }
    // End CSM-12256 Von Pernicia: Added isRetrieveService, isClickOutstandingAmount
    // End CSM-12246 Von Pernicia

    //Start CSM-2051: Von Pernicia MAR-30-17
    public  static void UpdateServiceWithScheduleDepositInfo(Agreement__c a, List<Schedule__c> allSchedules, Agreement__c oldAgreement, Boolean isUpdate, String profileName, Case c)
    {
        // Start CSM-11923 Von Pernicia JUL-22-17
        Id modifyRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_MODIFICATION_OF_ELECTRIC_APPLICATION).getRecordTypeId();
        // End CSM-11923 Von Pernicia JUL-22-17
        boolean blnRateBusiness = true; //CSM-2772 new variable to store if business rate
        
        // Start CSM-11454 Von Pernicia JUL-16-17
        if (c != null)
        {
        // End CSM-11454 Von Pernicia JUL-16-17
            // Start CSM-12102 Von Pernicia
            if (//!c.Override_Auto_Deposit_Amount__c &&
                //c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
                a.applied_load__c > 0 &&  a.applied_load__c <= 5 
               )
            {
            // End CSM-12102 Von Pernicia
                
                Schedule__c oSchedData = null;
            if (a.applied_load__c <= 1){
                   
                      oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S1);
     
                } else if (a.applied_load__c >1  && a.applied_load__c <= 1.5){
                    oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S2);
                   
                } else if (a.applied_load__c >1.5  && a.applied_load__c <= 2){
                    oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S3);
                  
                }else if (a.applied_load__c >2  && a.applied_load__c <= 3){
                    oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S4);
                   
                } else if (a.applied_load__c >3  && a.applied_load__c <= 4){
                    oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S5);
                   
                }  else if (a.applied_load__c >4  && a.applied_load__c <= 5){
                   oSchedData = ScheduleCollectionUtils.GetScheduleByName(allSchedules,CXE_Constants.SCHEDULE_S6);
                }  
                
                 if (oSchedData !=null){
                        a.Deposit_Schedule__c = oSchedData.id;
                        //Rhyan Cruz CSM-2772 Replaced Application_for_Business_Customer__c with var blnRateBusiness(data coming from Rate of Service record)             
                        if (a.Rate__c == CXE_Constants.CASE_SERVICE_RATE_TYPE_RESIDENTIAL_SERVICE_RS)  {
                            blnRateBusiness = false;
                        }
                        a.Deposit_Amount__c = ScheduleCollectionUtils.GetRateByResidType(oSchedData, blnRateBusiness);
                    }
            }
            
            //Christian Peter Doctolero
            //March 14, 2017
            //CSM-298
            /* Start CSM-7159 Von Pernicia: Comment out
            else if (a.Override_Auto_Deposit_Amount__c &&
                c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
                isUpdate &&
                a.Deposit_Amount__c != oldAgreement.Deposit_Amount__c
               )
            {
                if( profileName == CXE_Constants.PROFILE_NAME_MERALCO_G5 || profileName == CXE_Constants.PROFILE_NAME_MERALCO_G4 ||  profileName == CXE_Constants.PROFILE_NAME_MERALCO_G3 || 
                   profileName == CXE_Constants.PROFILE_NAME_MERALCO_G2 || profileName == CXE_Constants.PROFILE_NAME_MERALCO_G1 
                   || profileName == CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR)
                {    
                    if(oldAgreement.Deposit_Amount__c >= 1000 && (profileName == CXE_Constants.PROFILE_NAME_MERALCO_G4 || profileName == CXE_Constants.PROFILE_NAME_MERALCO_G5 ))
                    {
                        a.addError(CXE_Constants.CASE_ERROR_DEPOSIT_AMOUNT_CHANGE);
                    }
                } 
                
                else
                {
                    a.addError(CXE_Constants.CASE_ERROR_DEPOSIT_AMOUNT_CHANGE);

                }
                
            }
            End CSM-7159 Von Pernicia: Comment out*/
            else if (
                //c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
                a.applied_load__c > 5)
            {
                a.Deposit_Schedule__c = null;
                // Start CSM-12246 Von Pernicia
                //if (c.CXE_isClickBillDepositButton__c)
                //{
                //    a.Deposit_Amount__c = null; 
                //}
                // End CSM-12246 Von Pernicia
                
                // Start CSM-11923 Von Pernicia JUL-22-17
                if (c.RecordTypeId == modifyRecTypeId)
                {
                    a.Deposit_Amount__c = c.CXE_Required_Deposit_Amount__c;
                }
                // End CSM-11923 Von Pernicia JUL-22-17
            }
            // Start CSM-12102 Von Pernicia
            else if (
                //c.status != CXE_Constants.CASE_APPLICATION_EVALUATED &&
                a.applied_load__c < 5 &&
                c.RecordTypeId == modifyRecTypeId)
            {
                a.Deposit_Schedule__c = null;
                a.Deposit_Amount__c = c.CXE_Required_Deposit_Amount__c;
            }
            // End CSM-12102 Von Pernicia

        } //Start/End CSM-11454 Von Pernicia JUL-16-17
    }
    //END CSM-2051: Von Pernicia MAR-30-17
}