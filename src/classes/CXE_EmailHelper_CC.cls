/* Description: Visualforce email templates controller
 * Author: Michael Lasala
 * Date Created: MAR-13-17
 */
 public class CXE_EmailHelper_CC {
     
    public Id caseId {get;set;}
    public Id serviceId {get;set;}
    public Id contractId {get;set;}
    public String caseRType {get;set;}
    //START CSM-12343 AUG-25-17 RReyes
    public String servAddWeb {get;set;}
    public String billAddWeb {get;set;}
    //END CSM-12343 AUG-25-17 RReyes
    
    /* Description: Get Case Service Address
     * Parameters: None
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-13-17
     */
    public String getServiceAddress(){
        String addressStr = '';
        if(caseId != null){
            List<Address__c> addressList = [SELECT Address__c FROM Address__c WHERE Case__c =: caseId AND Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE LIMIT 1];
            if(!addressList.isEmpty()){
                if(addressList[0].Address__c != null){
                    addressStr = addressList[0].Address__c;
                }
            }
        }
        return addressStr;
    }
    
    /* Description: Get Case Billing Address
     * Parameters: None
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-13-17
     */
    public String getBillingAddress(){
        String addressStr = '';
        String serviceAddress = '';
        if(caseId != null){
            List<Address__c> addressList = [SELECT Address__c FROM Address__c WHERE Case__c =: caseId AND Type__c =: CXE_Constants.ADDRESS_TYPE_BILLING LIMIT 1];  
            if(!addressList.isEmpty()){
                if(addressList[0].Address__c != null){
                    addressStr = addressList[0].Address__c;
                }
            }
        }
        if(addressStr != ''){
            serviceAddress = getServiceAddress();
            if(addressStr == serviceAddress){
                addressStr = '<same as above>';
            }
        }
        return addressStr;
    }
     
    public List<Requirement__c> getRequirements(){
        List<Requirement__c> r = [SELECT Requirement_Type__c FROM Requirement__c WHERE Case__c =: caseId AND Status__c = 'Pending'];
        return r;
    }
     
     public List<String> getPreSurveyNotFeasible(){
       
         Id surveyFO = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get('Survey FO').getRecordTypeId();
         List<String> preSurvey = new List<String>();
         
             for (Field_Order__c fo: [SELECT Inconsistent_SA_Data_Required__c, 
                                   ROW_Grant_for_SE_Required__c,
                                   Unable_to_Locate_Given_Address__c,
                                   Add_Distribution_Facilities_Required__c,
                                   Extensive_modifications_to_premises_requ__c
                                   FROM Field_Order__c 
                                   WHERE Case__c =: caseId AND Pre_Survey_Result__c = 'Not Feasible' and RecordTypeId =: surveyFO 
                                   ORDER BY CreatedDate DESC LIMIT 1])
         {
             if (fo.Inconsistent_SA_Data_Required__c)
             {
                 //preSurvey.add('Inconsistent SA Data');
                 preSurvey.add('Info submitted needs further checking');
             }
             
             if (fo.ROW_Grant_for_SE_Required__c)
             {
                 //preSurvey.add('ROW Grant for SE Required'); 
                preSurvey.add('Need to secure Right of Way for SE Pole');                
             }
             
             if (fo.Unable_to_Locate_Given_Address__c)
             {
                 //preSurvey.add('Unable to Locate Given Address');
                 preSurvey.add('Cannot locate address during inspection');
             }
             
             if (fo.Add_Distribution_Facilities_Required__c)
             {
                 //preSurvey.add('Add. Distribution Facilities Required');
                 preSurvey.add('Additional Facilities Required');
             }
             
             if (fo.Extensive_modifications_to_premises_requ__c)
             {
                 //preSurvey.add('Extensive Modifications to Premises');
                 preSurvey.add('Customer needs major site modifications');
             }
      }
        return preSurvey;
    }
     
    public List<String> getInspectionFoDisApproved(){
       
         Id inspectionFO = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get('Inspection FO').getRecordTypeId();
         List<String> inspectionFOList = new List<String>();
         
             for (Field_Order__c fo: [SELECT Ready_for_Connection__c,
                                   SE_Not_Compliant__c,
                                   SE_Not_Installed_Yet__c,
                                   Wrong_SE_Location__c
                                   FROM Field_Order__c 
                                   WHERE Case__c =: caseId AND Inspection_Result__c = 'Disapproved' and RecordTypeId =: inspectionFO 
                                   ORDER BY CreatedDate DESC LIMIT 1])
         {
             if (fo.Ready_for_Connection__c)
             {
                 inspectionFOList.add('Ready for Connection');
             }
             
             if (fo.SE_Not_Compliant__c)
             {
                 //inspectionFOList.add('SE Not Compliant'); 
                inspectionFOList.add('Service entrance needs correction');                 
             }
             
             if (fo.SE_Not_Installed_Yet__c)
             {
                 //inspectionFOList.add('SE Not Installed Yet');
                inspectionFOList.add('Found no service entrance on site');
             }
             
             if (fo.Wrong_SE_Location__c)
             {
                 //inspectionFOList.add('Wrong SE Location');
                 inspectionFOList.add('Service entrance not in agreed location');
             }
      }
        return inspectionFOList;
    }

    /* Description: Get Meter Socket Field Order Schedule Date
     * Parameters: None
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-20-17
     */
    public String getFieldOrderScheduleDate(){
        String scheduleDate = '';
        Id meterSocketDeliveryRecordTypeId = Schema.Sobjecttype.Field_Order__c.getRecordTypeInfosByName().get(CXE_Constants.FIELD_ORDER_RECORDTYPE_NAME_METER_SOCKET_DELIVERY).getRecordTypeId();
        List<Field_Order__c> meterSocketDelivery = [SELECT Schedule_Date__c FROM Field_Order__c WHERE Case__c =: caseId AND RecordTypeId =: meterSocketDeliveryRecordTypeId LIMIT 1];
        if(!meterSocketDelivery.isEmpty()){
            scheduleDate = String.valueOf(meterSocketDelivery.get(0).Schedule_Date__c);
        }
        return scheduleDate;
    }

    /* Description: Get Connection Installation Date
     * Parameters: None
     * Returns: String
     * Author: Michael Lasala
     * Date Created: MAR-20-17
     */
    public String getConnectionInstallationDate(){
        Connection__c connection = [SELECT Installation_Date__c FROM Connection__c WHERE Case__c =: caseId ORDER BY CreatedDate ASC LIMIT 1];
        return String.valueOf(connection.Installation_Date__c);
    }
    
    //START - R1 Templates - Test
    /* Description: Get Case Details
     * Parameters: None
     * Returns: Case
     * Author: Rom Edison Reyes
     * Date Created: JUN-30-17
     */
    public Case getCase(){
        Case c = [SELECT Id, 
                        RecordType.DeveloperName,
                        CXE_Service_Request_s__c,
                        Has_Applied_for_Someone__c, 
                        Authorized_Representative_First_Name__c, 
                        Authorized_Representative_Last_Name__c, 
                        Authorized_Representative_Middle_Name__c, 
                        Authorized_Rep_Primary_Contact_Number__c,
                        CXE_Authorized_Rep_Designation__c,
                        Relationship__c,
                        AMC_Service_Tag__c,
                        CXE_Enroll_to_Paperless_Billing__c,
                        CXE_Interested_in_Other_Payment_Methods__c,
                        Deposit_Amount__c,
                        First_Name__c,
                        Middle_Name__c,
                        Last_Name__c,
                        Designation__c,
                        Mobile_No__c,
                        Origin,
                        CXE_Web_First_Name__c,
                        CXE_Required_Deposit_Amount__c // Start/End CSM-12329 Von Pernicia
                        //START CSM-12335 AUG-24-17 RReyes
                        , Last_Name_Business_Name__c, 
                        Full_Name_Concatenated__c, 
                        CXE_Service__r.Account__c, 
                        CXE_Service__r.Account__r.Name, 
                        CXE_Service__r.Account__r.IsPersonAccount
                        //END CSM-12335 AUG-24-17 RReyes
                        FROM Case 
                        WHERE Id =: caseId LIMIT 1];
        return c;
    }

    public Case getCaseFromService(){
        String rType = '';
        if(caseRType == 'MSA'){
            rType = CXE_Constants.CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE;
        }else if(caseRType == 'RSA'){
            rType = CXE_Constants.CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE;
        }else if(caseRType == 'TSA'){
            rType = CXE_Constants.CASE_RECORD_TYPE_TERMINATION_OF_ELECTRIC_SERVICE;
        }

        Case c = [SELECT Id, 
                        CaseNumber,
                        RecordType.DeveloperName,
                        CXE_Service_Request_s__c,
                        Has_Applied_for_Someone__c, 
                        Authorized_Representative_First_Name__c, 
                        Authorized_Representative_Last_Name__c, 
                        Authorized_Representative_Middle_Name__c, 
                        Authorized_Rep_Primary_Contact_Number__c,
                        CXE_Authorized_Rep_Designation__c,
                        Relationship__c,
                        AMC_Service_Tag__c,
                        CXE_Enroll_to_Paperless_Billing__c,
                        CXE_Interested_in_Other_Payment_Methods__c,
                        Deposit_Amount__c,
                        First_Name__c,
                        Middle_Name__c,
                        Last_Name__c,
                        Designation__c,
                        Mobile_No__c,
                        Origin,
                        CXE_Web_First_Name__c,
                        Full_Name_Concatenated__c,
                        Email_Address__c,
                        Telephone_No__c
                        FROM Case 
                        WHERE CXE_Service__c =: serviceId
                        AND RecordType.DeveloperName =: rType
                        AND Status !=: CXE_Constants.CASE_APPLICATION_CLOSED 
                        AND Status !=: CXE_Constants.CASE_APPLICATION_CANCELLED LIMIT 1];
        return c;
    }
    //END - R1 Templates - Test

    /* Description: Get related Service Address from service
     * Parameters: None
     * Returns: String
     * Author: Rom Edison Reyes
     * Date Created: AUG-07-17
     */
    public String getServiceAddressFromService(){
        String addressStr = '';
        if(serviceId != null){
            List<Address__c> addressList = [SELECT Address__c FROM Address__c WHERE Service__c =: serviceId AND Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE LIMIT 1];
            if(addressList != null){
                if(!addressList.isEmpty()){
                    if(addressList[0].Address__c != null){
                        addressStr = addressList[0].Address__c;
                    }
                }
            }
        }
        return addressStr;
    }
    
    /* Description: Get related Billing Address from service's contract
     * Parameters: None
     * Returns: String
     * Author: Rom Edison Reyes
     * Date Created: AUG-07-17
     */
    public String getBillingAddressFromServiceContract(){
        String addressStr = '';
        String serviceAddress = '';
        if(contractId != null){
            List<Address__c> addressList = [SELECT Address__c FROM Address__c WHERE Contract__c =: contractId AND Type__c =: CXE_Constants.ADDRESS_TYPE_BILLING LIMIT 1];  
            if(addressList != null){ 
                if(!addressList.isEmpty()){
                    if(addressList[0].Address__c != null){
                        addressStr = addressList[0].Address__c;
                    }
                }
            }
        }
        if(addressStr != ''){
            serviceAddress = getServiceAddressFromService();
            if(addressStr == serviceAddress){
                addressStr = '<same as above>';
            }
        }
        return addressStr;
    }

    //START CSM-12335 AUG-24-17 RReyes
    /* Description: Get New Registered Customer name
     * Parameters: None
     * Returns: String
     * Author: Rom Edison Reyes
     * Date Created: AUG-07-17
     */
    public String getNewRegisteredCustomer(){
        String name = '';
        
        if(caseId != null){
            List<Case> caseList = [SELECT Id, Last_Name_Business_Name__c, First_Name__c, Middle_Name__c, Last_Name__c, CXE_Service__r.Account__c, CXE_Service__r.Account__r.Name, Application_for_Business_Customer__c
                                        FROM Case 
                                        WHERE Id=:caseId 
                                        LIMIT 1];
            if(caseList != null){
                if(!caseList.isEmpty()){
                    if(caseList[0].CXE_Service__r.Account__c != null){
                        if(caseList[0].Application_for_Business_Customer__c){
                            if(caseList[0].CXE_Service__r.Account__r.Name != caseList[0].Last_Name_Business_Name__c){
                                name = caseList[0].Last_Name_Business_Name__c;
                            }
                        }else{
                            String fullName = '';
                            String fName = caseList[0].First_Name__c == null ? '' : caseList[0].First_Name__c;
                            String mName = caseList[0].Middle_Name__c == null ? '' : caseList[0].Middle_Name__c;
                            String lName = caseList[0].Last_Name__c == null ? '' : caseList[0].Last_Name__c;
                            if(fName != ''){
                                fullName += fName;
                            }
                            if(mName != ''){
                                if(fullName != ''){
                                    fullName += ' ';
                                }
                                fullName += mName;
                            }

                            if(lName != ''){
                                if(fullName != ''){
                                    fullName += ' ';
                                }
                                fullName += lName;
                            }

                            if(caseList[0].CXE_Service__r.Account__r.Name != fullName){
                                name = fullName;
                            }
                        }
                    }
                }
            }
        }
        return name;
    }
    //END CSM-12335 AUG-24-17 RReyes

    //START CSM-12343 AUG-25-17 RReyes
    /* Description: For Web - show <same as above> for billing address if same as service address
     * Parameters: None
     * Returns: String
     * Author: Rom Edison Reyes
     * Date Created: AUG-25-17
     */
    public String getWebBillingAddress(){
        String webBillAdd = servAddWeb == billAddWeb ? '<same as above>' : billAddWeb;
        return webBillAdd;
    }
    //END CSM-12343 AUG-25-17 RReyes
   
    //START CSM-14914 DEC-21-17 JFernandez
	/* Description: Get APA Agent From Contract
	* Parameters: None
	* Returns: String
	* Author: John Mark Fernandez
	* Date Created: DEC-21-17
	*/
     public Contract getApaAgent(){
         
         if(contractId != null){
             Contract contractRec = [SELECT Id, toLabel(CXE_APA_Agent__c) FROM Contract WHERE Id =: contractId]; //START END CSM-15057 JAN-10-18 JFernandez add tolabel
             return contractRec;
         }
         return null; 
     }
     //END CSM-14914 DEC-21-17 JFernandez
     
     //START CSM-15057 JAN-10-18 JFernandez
	/* Description: Get APA Agent From Case
	* Parameters: None
	* Returns: String
	* Author: John Mark Fernandez
	* Date Created: JAN-10-18
	*/
     public Case getApaAgentCase(){
         
         if(caseId != null){
             Case caseRec = [SELECT Id, toLabel(CXE_APA_Agent__c) FROM Case WHERE Id =: caseId];
             return caseRec;
         }
         return null;
     }
     //END CSM-15057 JAN-10-18 JFernandez
}