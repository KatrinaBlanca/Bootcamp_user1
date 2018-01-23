/* 
* Description: Controller for PDF generation
* Author: Rom Edison Reyes (Accenture)
* Date Created: SEP-07-17
*/ 
public class CXE_FOPrintingPDFController{
    public static List<String> lstFOIds = new List<String>();
    public CXE_FOPrintingPDFController(){
        String foIds = ApexPages.currentPage().getParameters().get('foIdList');
        System.debug('>>rr: foIds ' + foIds);
        if(!String.isBlank(foIds)){
            if(foIds.contains(';')){
                lstFOIds = foIds.split(';');
            }else{
                lstFOIds.add(foIds); 
            }    
        }
    }
    
    public List<Field_Order__c> getFieldOrderList(){
       List<Field_Order__c> foList = new List<Field_Order__c>();
       if(!lstFOIds.isEmpty()){
           foList = [SELECT Id, Name, Case__c, Case__r.CaseNumber, Mobile_No__c, Email__c, Address__c, Landmarks__c, Status__c, Schedule_Date__c, CreatedBy.Name, CreatedDate, Meter_Socket_Delivery_Instructions__c,
                          RecordType.Name,RecordType.DeveloperName, Account_Name__c, Contact_Name__c, Telephone_No__c, Resolution_Date__c, Office__r.Name, Executing_Personnel_FO__r.Name, Inspection_Instructions__c, 
                          TLN__c, Pole_Code__c, Material__c, Metering_Scheme__c, Mode_of_Retrieval__c, Service_Wire_Size__c, Service_Wire_Length__c, Service_Wire_Type__c, Resolution_Remarks__c, 
                          Inspection_Result__c, Ready_for_Connection__c, SE_Not_Compliant__c, SE_Not_Installed_Yet__c, Wrong_SE_Location__c, Meter_Socket_Delivery__c, SE_Completion_Target_Negotiated__c,
                          Delivery_for_Reschedule__c, Contact_Person_Unreachable__c, For_BC_Pickup__c, Re_inspection_Instructions__c, Re_Inspection_Result__c, Survey_Instructions__c, Pick_Up_Document__c, 
                          Deliver_Document__c, Additional_Documents_for_Evaluation_Requ__c, Pre_Survey_Result__c, Inconsistent_SA_Data_Required__c, ROW_Grant_for_SE_Required__c, Extensive_modifications_to_premises_requ__c,
                          Unable_to_Locate_Given_Address__c, Add_Distribution_Facilities_Required__c
                     FROM Field_Order__c
                     WHERE Id IN:lstFOIds];
       }
        //for adding a space every 100th character to push it as a next line.
        for (Field_Order__c ii : foList) {
            if (ii.recordType.developerName == 'CXE_Survey_FO') {
                 ii.Survey_Instructions__c = ii.Survey_Instructions__c.replaceAll('.{100}', '$0 ');
            }
            if (ii.recordType.developerName == 'CXE_Inspection_FO') {
                 ii.Inspection_Instructions__c = ii.Inspection_Instructions__c.replaceAll('.{100}', '$0 ');
            }
            if (ii.recordType.developerName == 'CXE_Re_Inspection_FO') {
                 ii.Re_inspection_Instructions__c = ii.Re_inspection_Instructions__c.replaceAll('.{100}', '$0 ');
            }
            if (ii.recordType.developerName == 'CXE_Meter_Socket_Delivery') {
                 ii.Meter_Socket_Delivery_Instructions__c = ii.Meter_Socket_Delivery_Instructions__c.replaceAll('.{100}', '$0 ');
            }
            system.debug(ii.recordType.developerName);
        }

       return foList;
    }
}