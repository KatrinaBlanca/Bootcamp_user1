public class CaseStateTransitionHelper {

    public static id processedCaseId =null;
    public static Set<Id> processedCaseIds = new Set<Id>(); //CSM-14296 11.07.2017

    @testVisible
    private static Case_State_Transition__c getPreviousMediator(id caseId, string fromState) 
    {
        // TODO need to bulikfy this
        //
        Case_State_Transition__c rec = null;
        
        List<Case_State_Transition__c> relatedTransition = [select case__c,Name, to_state__c, 
                                                            Calculation_type__c, Total_Number_of_Days__c, Mediator_Used__c
                                                            from Case_State_Transition__c
                                                            where case__c = :caseId and to_state__c =:fromState
                                                            and Calculation_type__c= :CXE_Constants.CASESTATETRANSITIONHELPER_MEDIATOR
                                                            and Mediator_Used__c = false
                                                            order by CreatedDate desc limit 1];
        
        if(relatedTransition != null & relatedTransition.size() >0 ){
            rec = relatedTransition[0];
        }
        
        return rec;
        
    }
    
//START CSM-7230 GGrandea JUL-5-17   
/* 
 * Description: Retrieve Case State Transition records with CalculationType equals Mediator by Case Id and To States
 * Parameters: Set<Id> caseIds, Set<String> fromStates
 * Returns: Map<String, Case_State_Transition__c>
 * Author: GGrandea (Accenture)
 * Date Created: JUL-5-17
*/  
    public static Map<String, Case_State_Transition__c> getPrevMediators(Set<Id> caseIds, Set<String> fromStates) 
    {
        Map<String, Case_State_Transition__c> mapCst = new Map<String, Case_State_Transition__c>();
        for(Case_State_Transition__c cst : [select case__c,Name, to_state__c, 
                                                            Calculation_type__c, Total_Number_of_Days__c, Mediator_Used__c
                                                            from Case_State_Transition__c
                                                            where case__c in: caseIds and to_state__c in: fromStates
                                                            and Calculation_type__c= :CXE_Constants.CASESTATETRANSITIONHELPER_MEDIATOR
                                                            and Mediator_Used__c = false
                                                            order by CreatedDate desc]){

            mapCst.put(cst.Case__c+cst.To_state__c, cst);
        }
        return mapCst;
    }
//END   CSM-7230
    
     public static Case_State_Transition__c getRcordByName(string recordName) 
    {
        Case_State_Transition__c rec = null;
        
        List<Case_State_Transition__c> relatedTransition = [select id, Mediator_Used__c
                                                            from Case_State_Transition__c
                                                            where name = :recordName 
                                                            and Calculation_type__c= :CXE_Constants.CASESTATETRANSITIONHELPER_MEDIATOR];
        
        if(relatedTransition != null & relatedTransition.size() >0 ){
            rec = relatedTransition[0];
        }
        
        return rec;
        
    }
    
//START CSM-7230 GGrandea JUL-3-17   
/* 
 * Description: Retrieve Case State Transition records by Names
 * Parameters: List<String> recordNames
 * Returns: List<Case_State_Transition__c>
 * Author: GGrandea (Accenture)
 * Date Created: JUL-3-17
*/  
    public static List<Case_State_Transition__c> getCaseTransitionsByName(Set<String> recordNames){
        return [select id, Name, Mediator_Used__c 
                        from Case_State_Transition__c
                        where name in :recordNames 
                        and Mediator_Used__c = FALSE
                        and Calculation_type__c= :CXE_Constants.CASESTATETRANSITIONHELPER_MEDIATOR];
    }
//END   CSM-7230
    @testVisible
    private static date getPreviousFromDate(id caseId, string fromState) 
    {
        // TODO need to bulikfy this
        //
        date fromDate = date.Today();
        
        List<Case_State_Transition__c> relatedTransition = [select case__c, to_state__c, To_Date_Stamp__c,
                                                            Calculation_type__c, Total_Number_of_Days__c 
                                                            from Case_State_Transition__c
                                                            where case__c = :caseId and to_state__c =:fromState
                                                            order by CreatedDate desc limit 1];
        
        if(relatedTransition != null & relatedTransition.size() >0 ){
            fromDate = relatedTransition[0].To_Date_Stamp__c;
        }
        
        return fromDate;
        
    }
    
//START CSM-7230 GGrandea JUL-5-17   
/* 
 * Description: Retrieve Case State Transition records by Case Id and To States
 * Parameters: Set<Id> caseIds, Set<String> fromStates
 * Returns: Map<String, Case_State_Transition__c>
 * Author: GGrandea (Accenture)
 * Date Created: JUL-5-17
*/  
    public static Map<String, Case_State_Transition__c> getPreviousFromDates(Set<Id> caseIds, Set<String> fromStates){
        Map<String, Case_State_Transition__c> mapCst = new Map<String, Case_State_Transition__c>();
        for(Case_State_Transition__c cst : [select Id, Name, Case__c, To_state__c, To_Date_Stamp__c,
                                                            Calculation_type__c, Total_Number_of_Days__c 
                                                            from Case_State_Transition__c
                                                            where Case__c in: caseIds
                                                            and To_state__c in: fromStates
                                                            order by CreatedDate asc]){ // asc to get the last value to be put on map Corbes Melvin 11.10.2017
                                                                
                                                                
                                                          

            mapCst.put(cst.Case__c+cst.To_state__c, cst);
        }
        return mapCst;
    }
//END   CSM-7230
    
    private static Case_State_Transition_Setting__mdt 
        findSettingByState(List<Case_State_Transition_Setting__mdt> allSettings,
                           string fromState, string toState){
                               for(Case_State_Transition_Setting__mdt setting : allSettings){
                                   if (setting.From_State__c == fromState &&
                                       setting.To_State__c==toState) {
                                           return setting;
                                       }
                               }
        return null;
    }
    
    public static List<Case_State_Transition_Setting__mdt> getAllsettings(){
         
        List<Case_State_Transition_Setting__mdt> allSettings = [select id, Calculation_Type__c , From_State__c ,
                                  To_State__c , Include_From_Date__c , Include_Mediator__c, Active__c
                                  from Case_State_Transition_Setting__mdt
                                  where active__c = true];
        
       
        return allSettings;
    }
    
//START CSM-7230 GGrandea JUL-5-17   
/* 
 * Description: Return an initialized Case State Transition object
 * Parameters: 
 * Returns: Case_State_Transition__c
 * Author: GGrandea (Accenture)
 * Date Created: JUL-5-17
*/  
    public static Case_State_Transition__c  AddTransition(Id caseId, String fromState, 
                                                            String toState, Date fromDateStamp,
                                                            Case_State_Transition__c prevcTran, 
                                                            List<Case_State_Transition_Setting__mdt> allSettings) {
        
        Case_State_Transition__c csTran =  new Case_State_Transition__c ();
        csTran.From_State__c = (fromState==null) ? CXE_Constants.CASESTATETRANSITIONHELPER_CREATE : fromState;
        csTran.To_State__c = toState;
        csTran.case__c = caseId;
        //csTran.From_Date_Stamp__c = CaseStateTransitionHelper.getPreviousFromDate(caseId,fromState);
        csTran.From_Date_Stamp__c = fromDateStamp;
        csTran.To_Date_Stamp__c = Date.Today();
        
        if (allSettings != null && allSettings.size()>0){
           Case_State_Transition_Setting__mdt setting =  CaseStateTransitionHelper.findSettingByState(allSettings,fromState,toState);
            if (setting != null){
                csTran.Calculation_Type__c = setting.Calculation_Type__c;
                csTran.Include_From_Date__c = setting.Include_From_Date__c;
                if (setting.Include_Mediator__c ) {
                    //Case_State_Transition__c prevCaseTran = CaseStateTransitionHelper.getPreviousMediator(caseId,fromState);
                    Case_State_Transition__c prevCaseTran = prevcTran;
                    if (prevCaseTran != null){
                        csTran.Previous_Mediator_No_Of_Days__c=   prevCaseTran.Total_Number_of_Days__c;
                        csTran.Mediator_Reference_Trans_ID__c  = prevCaseTran.Name;
                      }
                }
            }
        }
        return csTran;
    }
//END   CSM-7230

}