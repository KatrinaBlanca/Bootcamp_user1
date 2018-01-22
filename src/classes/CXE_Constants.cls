/* 
 * Description: All constants that are used in multiple classes outside Click.
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-10-17
 */
public class CXE_Constants
{  
    //Begin CSM-973: Von Pernicia Feb-24-17
    public static final List<List<String>> CASE_PICKLIST_ARRAY = new List<List<String>>
    {
        new String[] {'Code_Application_Type_Subtype__c', 'Application_Type_Subtype__c', 'Application Type'},
        //new String[] {'Code_Billing_Class__c', 'Billing_Class__c', 'Billing Class'},
        new String[] {'Code_Business_Segment__c', 'Business_Segment__c', 'Business Segment'},
        new String[] {'Code_Customer_Type__c', 'Customer_Type__c', 'Customer Type'},
        new String[] {'Code_Material__c', 'Material__c', 'Material'},
        new String[] {'Code_Metering_Scheme__c', 'Metering_Scheme__c', 'Metering Scheme'},
        new String[] {'Code_Mode_of_Retrieval__c', 'Mode_of_Retrieval__c', 'Retrieval Mode'},
        new String[] {'Code_Phase__c', 'Phase__c', 'Phase'},
        new String[] {'Code_Premise_Type__c', 'Premise_Type__c', 'Premises Type'},
        new String[] {'Code_Project_Type__c', 'Project_Type__c', 'Project Type'},
        //new String[] {'Code_Responsible_Office__c', 'Responsible_Office_Name__c', 'Business Unit'},
        //new String[] {'Code_PSIC__c', 'PSIC__c', ''}, for query
        new String[] {'Code_Salutation__c', 'Salutation__c', 'Customer Title'},
        new String[] {'Code_Service_Rate_Type__c', 'Service_Rate_Type__c', 'Service Rate Type'},
        new String[] {'Code_Service_Supply_Type__c', 'Service_Supply_Type__c', 'Service Supply Type'},
        new String[] {'Code_Service_Wire_Type__c', 'Service_Wire_Type__c', 'Service Wire Type'},
        new String[] {'Code_Status__c', 'Status', 'Application Status'}, // *** For confimation if correct mapping
        new String[] {'Code_Voltage__c', 'Voltage__c', 'Voltage'},
        new String[] {'Code_Wire_Size__c', 'Wire_Size__c', 'Service Wire Size'},
         //Start CSM-6929: Von Pernicia Jun-16-17
        new String[] {'CXE_Code_Service_Wire_Phase__c', 'CXE_Service_Wire_Phase__c', 'Phase'},
        new String[] {'CXE_Code_Service_Wire_Voltage__c', 'CXE_Service_Wire_Voltage__c', 'Voltage'},
        //End CSM-6929: Von Pernicia Jun-16-17

        // Start CSM-7217: Von Pernicia Jun-20-17
        new String[] {'CXE_Code_Service_Request_s__c', 'CXE_Service_Request_s__c', 'Service Request'}
        // End CSM-7217: Von Pernicia Jun-20-17

        // Start CSM-7254: Von Pernicia Jul-07-17
        //new String[] {'CXE_Code_Rate_Programs__c', 'CXE_Rate_Programs__c', 'Program Code'}
        // End CSM-7254: Von Pernicia Jul-07-17
    }; 
    
    public static final List<List<String>> AGREEMENT_PICKLIST_ARRAY = new List<List<String>>
    {
        //new String[] {'Code_Billing_Class__c', 'Billing_Class__c', 'Billing Class'},
        new String[] {'Code_Phase__c', 'Phase__c', 'Phase'},
        new String[] {'Code_Premises_Type__c', 'Premises_Type__c', 'Premises Type'},
        new String[] {'Code_Program__c', 'Program__c', 'Program Code'},
        //new String[] {'Code_PSIC__c', 'PSIC__c', ''}, for query
        //new String[] {'Code_Rate__c', 'Rate__c', 'Service Rate Type'},
        new String[] {'Code_Segment__c', 'Segment__c', 'Business Segment'},
        new String[] {'Code_Service_Rate_Type__c', 'Rate__c', 'Service Rate Type'},
        new String[] {'Code_Service_Status__c', 'Service_Status__c', 'Service Status'},
        new String[] {'Code_Service_Supply_Phase__c', 'Service_Supply_Phase__c', 'Phase'}, // Start/End R2B CSM-13050 Von Pernicia
        new String[] {'Code_Service_Supply_Type__c', 'Service_Supply_Type__c', 'Service Supply Type'},
        new String[] {'Code_Service_Wire_Material__c', 'Service_Wire_Material__c', 'Material'},
        new String[] {'Code_Service_Wire_Phase__c', 'Service_Wire_Phase__c', 'Phase'},
        new String[] {'Code_Service_Wire_Size__c', 'Service_Wire_Size__c', 'Service Wire Size'},
        new String[] {'Code_Service_Wire_Type__c', 'Service_Wire_Type__c', 'Service Wire Type'},
        new String[] {'Code_Service_Wire_Voltage__c', 'Service_Wire_Voltage__c', 'Voltage'},
        new String[] {'Code_Voltage_Level__c', 'Service_Supply_Voltage__c', 'Voltage'},
        new String[] {'Code_Voltage_Level__c', 'Voltage_Level__c', 'Voltage Level'}
    };
    
    public static final List<List<String>> CONTRACT_PICKLIST_ARRAY = new List<List<String>>
    {
        //new String[]{'Code_Account_Rep__c', 'Account_Rep__c', 'Status'}, for query
        new String[]{'Code_Status__c', 'Status', 'Account Status'},
        new String[]{'Code_Type__c', 'Type__c', 'Account Type Code'},
        new String[]{'Code_Statement_Production_Trigger_Type__c', 'Statement_Production_Trigger_Type__c', 'Statement Production Trigger'}
    };
    
    public static final List<List<String>> ACCOUNT_PICKLIST_ARRAY = new List<List<String>>
    {
        new String[]{'Code_Customer_Type__c', 'Customer_Type__c', 'Customer Type'},
        new String[]{'Code_Salutation__c', 'Salutation', 'Customer Title'}
    };
    
    public static final List<List<String>> ADDRESS_PICKLIST_ARRAY = new List<List<String>>
    {
        new String[]{'Code_Premises_Type__c', 'Premise_Type__c', 'Premises Type'}
    };
    
    public static final List<List<String>> CONNECTION_PICKLIST_ARRAY = new List<List<String>>
    {
        new String[]{'Code_Meter_Status__c', 'Meter_Status__c', 'Meter Status'},
        new String[]{'Code_Reading_Frequency__c', 'Reading_Frequency__c', 'Reading Frequency'}
    };
    
    public static final List<List<String>> FIELDORDER_PICKLIST_ARRAY = new List<List<String>>
    {
        new String[]{'Code_Metering_Scheme__c', 'Metering_Scheme__c', 'Metering Scheme'},
        new String[]{'Code_Mode_of_Retrieval__c', 'Mode_of_Retrieval__c', 'Retrieval Mode'}
    };    
    
    public static final List<List<String>> ACCOUNTCHAR_PICKLIST_ARRAY = new List<List<String>>
    {
        new String[]{'Code_Type__c', 'Type__c', 'Type'}
    };
    //START RReyes CSM-1926 MAR-22-2017
    //START RReyes CSM-3762 JUN-01-2017 - add new case status
    public static final Set<String> VALID_CASE_STATUS_INITIAL = new Set<String>
    {
        'Application Received', 'Application Validated', 'Pre-Survey FO Generated', 'Pre-Survey FO Scheduled', 
        'Pre-Survey FO Resolved - Feasible', 'Pre-Survey FO Resolved - Not Feasible', 'Application Evaluated', 
        'Meter Socket Issued', 'Meter Socket Delivery FO Generated', 'Meter Socket Delivery FO Scheduled', 
        'Meter Socket Delivered', 'Meter Socket Not Delivered', 'AMC Service Availed', 'AMC Service Completed', 
        'Inspection FO Generated', 'Inspection FO Scheduled', 'Inspection FO Resolved - Approved', 
        'Inspection FO Resolved - Disapproved', 'Pre-Survey FO Not Required', 'Meter Socket Still Installed Onsite',
        'Service Entrance Still OK'
    };
    //END RReyes CSM-3762 JUN-01-2017 - add new case status
    
    public static final Set<String> VALID_CASE_STATUS_ADDTL_SINGLE = new Set<String>
    {
        'Contract Finalized', 'Application Ready for Connection', 'Pending Energization'
    };
    
    public static final Set<String> VALID_CASE_STATUS_SUCCEEDING_MULTI = new Set<String>
    {
        //Start CSM-11924 Von Pernicia JUL-22-17: added Re-inspection FO Resolved - Approved
        'Contract Finalized', 'Application Ready for Connection', 'Pending Energization', 'Application Approved', 'Re-inspection FO Resolved - Approved'
        //End CSM-11924 Von Pernicia JUL-22-17: added Re-inspection FO Resolved - Approved
    };
    
    //END RReyes CSM-1926 MAR-22-2017
    /*public static final List<List<String>> ADDRESS_ARRAY = new List<List<String>>
    {
      new String[]{'Code_Address_Province__c', 'Address_Province__c'},
        new String[]{'Code_Address_City_Municipality__c', 'Address_City_Municipality__c'},
        new String[]{'Code_Address_Barangay__c', 'Address_Barangay__c'},
        new String[]{'Code_Address_Subdivision__c', 'Address_Subdivision__c'},
        new String[]{'Code_Address_Street_Name__c', 'Address_Street_Name__c'}
    };*/
    
    public static final String ADDRESS_PROVINCE = 'Province';
    public static final String BILLING_CLASS= 'Billing Class';
    
    //End CSM-973: Von Pernicia Feb-24-17
     
    // Case Record Type
    public static final String CASE_CUSTOMER_COMMUNITY = 'Customer Community';
    public static final String CASE_SERVICE_APP_ADMIN = 'Service Application (Admin)';
    public static final String CASE_CUSTOMER_COMMUNITY_RT = 'Customer Community Record Type';
    public static final String CASE_SERVICE_APPLICATION = 'Service Application';
    public static final String CASE_SCS_EMAIL_CASE = 'SCS Email Case';
    public static final String CASE_SCS_SOCIAL_MEDIA_CASE = 'SCS Social Media Case';
    public static final String CASE_NEW_SERVICE_APPLICATION = 'New Service Application';    //Added by Michael Lasala FEB-14-17
    public static final String CASE_MODIFICATION_OF_ELECTRIC_APPLICATION = 'Modification of Electric Service';    //Added by Von Pernicia MAY-28-17
    public static final String CASE_TERMINATION_OF_ELECTRIC_SERVICE = 'Termination of Electric Service'; //Added by RReyes MAY-31-17
    public static final String CASE_RECONTRACT_OF_ELECTRIC_SERVICE = 'Recontract of Electric Service'; //Added by RReyes MAY-31-17
    //public static final String CASE_PORTAL_REGISTRATION_SIN_ENROLLMENT = 'Portal Registration SIN Enrollment'; //START/END CSM-XXXX RReyes JUL-21-17
    public static final String CASE_PORTAL_REGISTRATION_SIN_ENROLLMENT = 'Portal Request'; //CSM-13840 change recordtype label
    public static final String CASE_PAPERLESS_BILLING = 'Paperless Billing'; // VON-TBD
    public static final String CASE_APA = 'Auto Payment Arrangement'; //START/END CSM-13209 RReyes OCT-06-17
    
    // Case Status 
    public static final String CASE_APPLICATION_RECEIVED = 'Application Received';
    public static final String CASE_APPLICATION_EVALUATED = 'Application Evaluated'; //Added by Von Pernicia FEB-21-17 (CMS-713)
    public static final String CASE_APPLICATION_APPROVED = 'Application Approved'; //START/END CSM-12279 RReyes AUG-18-17
    //Start CSM-1546: Von Pernicia 3/16/17
    public static final String CASE_PRE_SURVEY_FO_GENERATED = 'Pre-survey FO Generated'; 
    public static final String CASE_PRE_SURVEY_FO_SCHEDULED = 'Pre-survey FO Scheduled'; 
    public static final String CASE_PRE_SURVEY_FO_FEASIBLE = 'Pre-survey FO Resolved - Feasible'; 
    public static final String CASE_PRE_SURVEY_FO_NOTFEASIBLE = 'Pre-survey FO Resolved - Not Feasible'; 
    public static final String CASE_PRE_SURVEY_FO_NOTREQUIRED = 'Pre-Survey FO Not Required'; //START/END CSM-12223/12251 RReyes AUG-08-17
    public static final String CASE_MS_ISSUED = 'Meter Socket Issued';
    public static final String CASE_MSD_FO_GENERATED = 'Meter Socket Delivery FO Generated';
    public static final String CASE_MSD_FO_SCHEDULED = 'Meter Socket Delivery FO Scheduled';
    public static final String CASE_MS_DELIVERED = 'Meter Socket Delivered';
    public static final String CASE_MS_NOT_DELIVERED = 'Meter Socket Not Delivered';
    public static final String CASE_AMC_AVALIED = 'AMC Service Availed';
    public static final String CASE_AMC_SERVICE_COMPLETED = 'AMC Service Completed';
    //End CSM-1546: Von Pernicia 3/16/17
    public static final String INSPECTION_FO_GENERATED = 'Inspection FO Generated'; //Added by Jerson Poblete MAR-10-17 (CMS-1310)
    public static final String INSPECTION_FO_SCHEDULED = 'Inspection FO Scheduled';
    public static final String INSPECTION_FO_RESOLVED_APPROVED = 'Inspection FO Resolved - Approved';
    public static final String INSPECTION_FO_RESOLVED_DISAPPROVED = 'Inspection FO Resolved - Disapproved'; //Start/End CSM-1546: Von Pernicia 3/16/17
    public static final String CASE_STATUS_APPLICATION_VALIDATED = 'Application Validated'; // Jerome To 
    public static final String CASE_STATUS_CONTRACT_FINALIZED = 'Contract Finalized'; // Jerome To CSM 1926
    public static final String CASE_STATUS_AWAITING_CUSTOMER_COMPLIANCE = 'Awaiting Customer Compliance'; // JEROME TO CSM-6448 JUN-05-17
    public static final String CASE_STATUS_RE_INSPECTION_FO_GENERATED = 'Re-inspection FO Generated'; // JEROME TO CSM-6448 JUN-06-17
    public static final String CASE_STATUS_RE_INSPECTION_FO_SCHEDULED = 'Re-inspection FO Scheduled'; // JEROME TO CSM-6448 JUN-06-17
    public static final String CASE_STATUS_RE_INSPECTION_FO_RESOLVED_DISAPPROVED = 'Re-inspection FO Resolved - Disapproved'; // JEROME TO CSM-6448 JUN-06-17
    public static final String CASE_STATUS_RE_INSPECTION_FO_RESOLVED_APPROVED = 'Re-inspection FO Resolved - Approved'; // JEROME TO CSM-6448 JUN-06-17
    public static final String CASE_APPLICATION_CLOSED = 'Application Closed'; //START/END CSM=6704 RReyes
    public static final String CASE_APPLICATION_CANCELLED = 'Application Cancelled'; //START/END CSM-6929 Von Pernicia
    public static final String CASE_STATUS_SERVICE_ENTR_STILL_OK = 'Service Entrance Still OK'; //START/END CSM-12217/12251 RReyes AUG-08-17
    
    public static final String CASE_APPLICATION_PENDING_ENERGIZED = 'Pending Energization'; //START/END CSM-12239 Von Pernicia
    public static final String CASE_APPLICATION_ENERGIZED = 'Energized'; //START/END CSM-12239 Von Pernicia

    //Field Order Record Type
    public static final String FO_INSPECTION_FO = 'Inspection FO';
    public static final String FO_SURVEY_FO = 'Survey FO';
    public static final String FO_MeterSocket_FO = 'Meter Socket Delivery';
    public static final String FO_RE_INSPECTION_FO = 'Re-Inspection FO'; //START/END CSM-6869 RReyes JUN-08-17
    
    // BEGIN Added by Von Pernicia FEB-21-17
    // Schedule
    public static final String SCHEDULE_S1 = 'S-1';
    public static final String SCHEDULE_S2 = 'S-2';
    public static final String SCHEDULE_S3 = 'S-3';
    public static final String SCHEDULE_S4 = 'S-4';
    public static final String SCHEDULE_S5 = 'S-5';
    public static final String SCHEDULE_S6 = 'S-6';
    // END Added by Von Pernicia FEB-21-17
    
    // Salesforce user
    public static final String SF_USER_SCC_ADMIN = 'SCC Admin';

    //BEGIN Added by Michael Lasala FEB-15-17 for create contact error messages (CSM-611)
    public static final String CREATE_CONTACT_ERROR_MESSAGE_EXISTING_CONTACT = 'Contact already exists.';
    public static final String CREATE_CONTACT_ERROR_MESSAGE_NO_ACCOUNT = 'Account has not been created.';
    public static final String CREATE_CONTACT_ERROR_MESSAGE_PERSON_ACCOUNT = 'Contact cannot be created for Person Accounts.';
    public static final String CREATE_CONTACT_ERROR_MESSAGE_RESIDENTIAL_CUSTOMER = 'Contact cannot be created for Residential Customers.';
    //Michael Lasala FEB-16-17 Added for full name validation
    public static final String CREATE_CONTACT_ERROR_MESSAGE_FULL_NAME = 'Please input first name, last name and date of birth of contact person.';
    //END Michael Lasala FEB-15-17

    //BEGIN Added by Michael Lasala FEB-15-17 for test data factory methods
    public static final String RECORD_TYPE_NAME_ACCOUNT_BUSINESS = 'Business Account';
    public static final String RECORD_TYPE_NAME_ACCOUNT_PERSON = 'Individual Account';
    public static final String RECORD_TYPE_NAME_OFFICE_WEB = 'Web';     //Michael Lasala MAR-13-17 (CSM-161)
    public static final String RECORD_TYPE_NAME_OFFICE_HMB = 'HMB Group';     //Michael Lasala MAR-24-17
    public static final String RECORD_TYPE_NAME_OFFICE_BIZ = 'Biz Partners Group';     //Christian Peter Doctolero MAR-29-17
    public static final String RECORD_TYPE_EXECUTING_PERSONEL = 'Executing Personnel';     //Von Pernicia test class
    //END Michael Lasala FEB-15-17

    //BEGIN Added by Jerome To MAR-03-17 create service error message (CSM-1068)
    public static final String CREATE_SERVICE_ERROR_MESSAGE_CONTRACT_WITHOUT_ADDRESS = 'Contract related to the Service must have address.';    
    //END Jerome To MAR-03-17 (CSM-1068)
    
    //BEGIN Added by Jerson Poblete MAR-10-17 Multimetering Validation (CSM-1318)
    //BEGIN Modified by Rom Edison Reyes MAR-22-17 Status Validation - Single and Multi (CSM-1926)
    public static final String CREATE_CONTRACT_ERROR_MESSAGE_MULTI_METERED_VALIDATION = 'You cannot create the succeeding contracts for this case until status is \'Application Approved\', \'Contract Finalized\', \'Application Ready for Connection\', or \'Pending Energization\'.'; 
    public static final String CREATE_SERVICE_ERROR_MESSAGE_MULTI_METERED_VALIDATION = 'You cannot create the succeeding services for this contract until the contract\'s case status is \'Application Approved\', \'Contract Finalized\', \'Application Ready for Connection\', or \'Pending Energization\'.'; 
    //END Modified by Rom Edison Reyes MAR-22-17 Status Validation - Single and Multi (CSM-1926)
    //END Jerson Poblete MAR-10-17 (CSM-1318)
    //BEGIN Added by Rom Edison Reyes MAR-18-17 Single-Metering Validation (CSM-1915)
    public static final String CREATE_CONTRACT_ERROR_MESSAGE_SINGLE_METERED_VALIDATION = 'You are not allowed to create more than one contract in this case.';
    public static final String CREATE_SERVICE_ERROR_MESSAGE_SINGLE_METERED_VALIDATION = 'You are not allowed to create more than one service in this case.';
    //END Added by Rom Edison Reyes MAR-18-17 Single-Metering Validation (CSM-1915)
    
    //BEGIN Added by Rom Edison Reyes MAR-22-17 Status Validation - Single and Multi (CSM-1926)
    public static final String CREATE_CONTRACT_ERROR_MESSAGE_INVALID_CASE_STATUS = 'You are not allowed to create a new contract in this Case. Please check the status of the Case before creating a new contract.';
    public static final String CREATE_SERVICE_ERROR_MESSAGE_INVALID_CASE_STATUS = 'You are not allowed to create a new service in this Contract. Please check the status of the Contract\'s Case before creating a new service.';
    public static final String CREATE_SERVICE_ERROR_MESSAGE_CONTRACT_WITHOUT_V10 = 'You cannot create the succeeding services for this contract until the V10 Account # is populated.';
    //END Added by Rom Edison Reyes MAR-22-17 Status Validation - Single and Multi (CSM-1926)
  
    public static final String LEAD_CHECK_ADDRESS = 'Please ensure that the Lead\'s address is valid.'; // Jerson Poblete MAR-14-17 (CSM 1303)

    //BEGIN Added by Jerome To MAR-11-17 Case Status Application validated Error message - CSM-1340
    //Michael Lasala MAR-23-17 Update error message for validated status to include billing address
    public static final String UPDATE_CASE_STATUS_ERROR_MESSAGE_APPLICATION_VALIDATED = 'Please ensure that Service and Billing Address are already created.'; 
    public static final String UPDATE_CASE_STATUS_ERROR_MESSAGE_APPLICATION_EVALUATED = 'Please ensure that Billing Address is already created.'; 
    //END Jerome To MAR-11-17

    // Address Type
    public static final String ADDRESS_TYPE_SERVICE = 'Service'; // Jerome To
    public static final String ADDRESS_TYPE_CUSTOMER = 'Customer';  //Michael Lasala MAR-11-17 (CSM-161)
    public static final String ADDRESS_TYPE_BILLING = 'Billing';    //Michael Lasala MAR-11-17 (CSM-166)
    //Address Premise Type
    public static final String ADDRESS_PREMISE_TYPE_OTHERS = 'Others'; // Jerson Poblete MAR-14-17 (CSM 1303)
    
    public static final String CASE_ERROR_MESSAGE_INVALID_RESPONSIBLE_OFFICE = 'Invalid Responsible Office, please select based on Initial Responsible Office';  //Michael Lasala MAR-12-17
    public static final String CASE_ERROR_MESSAGE_NO_INITIAL_RESPONSIBLE_OFFICE = 'Cannot select Responsible Office without Initial Responsible Office';  //Michael Lasala MAR-13-17

    public static final String CASE_ORIGIN_WEB = 'Web';  //Jerome To MAR-12-17
    public static final String CASE_APPLICATION_ERROR_MESSAGE_STRING1 = 'Ooops, something\'s wrong. Please check on the following:';  //Jerome To MAR-12-17
    public static final String CASE_APPLICATION_ERROR_MESSAGE_STRING2 = 'Account fields that affected this error: ';  //Jerome To MAR-12-17
    
    //Office Type
    public static final String OFFICE_WEB = 'Web';  //Christian Doctolero To MAR-13-17

    // Reference object variable
    //BEGIN Michael Lasala MAR-13-17 (CSM-161)
    public static final String REFERENCE_FIELD_STREET = 'Street';
    public static final String REFERENCE_FIELD_CITY = 'City';
    public static final String REFERENCE_FIELD_SUBDIVISION = 'Subdivision'; // Jerome To CSM-1904 MAR-19-2017
    public static final String REFERENCE_FIELD_PROVINCE = 'Province'; // Jerome To CSM-1904 MAR-19-2017
    public static final String REFERENCE_FIELD_BARANGAY = 'Barangay'; // Jerome To CSM-1904 MAR-19-2017
    public static final String REFERENCE_TYPE_GEO = 'Geo'; // Jerome To CSM-1904 MAR-19-2017

    public static final String ROLE_PREFIX_CBG = 'CBG';
    public static final String ROLE_PREFIX_BIZ = 'Biz';
    //END Michael Lasala MAR-13-17
    
    //Start CSM-1911: Von Pernicia
    public static final String REFERENCE_FIELD_VOLTAGE = 'Voltage';
    public static final String REFERENCE_FIELD_VOLTAGE_LEVEL = 'Voltage Level';
    //ENd CSM-1911: Von Pernicia

    public static final String CASE_APPLICATION_ERROR_MESSAGE_STRING3 = 'Case number: {0} has been successfully created but address creation failed.';  //Jerome To MAR-14-17
    
    //BEGIN Michael Lasala MAR-13-17 (CSM-166)
    public static final String BILL_DEPOSIT_SIMULATOR_CASE_REQUIRED_FIELDS_ERROR = 'Service Rate Type and Applied Load are required.';
    public static final String BILL_DEPOSIT_SIMULATOR_CASE_REQUIRED_FIELDS_ERROR2 = 'Demand Factor, Contracted Capacity and Load Factor are required.';
    public static final String BILL_DEPOSIT_SIMULATOR_CASE_MISSING_RATE = 'There is no Rate.';
    public static final String BILL_DEPOSIT_SIMULATOR_ADDRESS_REQUIRED_ERROR = 'Service Address is required.';
    public static final String STATUS_ERROR = 'Error';
    public static final String STATUS_SUCCESS = 'Success';
    public static final String STATUS_SUCCESS_NO_ARREARS = 'Success_NoArrears'; //CSMCW-13 Rhyan Cruz 09/25/2017 Added constant if there is no outstanding amount
    public static final String OPTION_YES = 'Yes';
    public static final String OPTION_NO = 'No';
    //END Michael Lasala MAR-13-17
    
    
    //BEGIN Christian Doctolero March-14-17 (CSM-298)
    public static final String PROFILE_NAME_MERALCO_G5 = 'MERALCO G5';
    public static final String PROFILE_NAME_MERALCO_G4 = 'MERALCO G4';
    public static final String PROFILE_NAME_MERALCO_G3 = 'MERALCO G3';
    public static final String PROFILE_NAME_MERALCO_G2 = 'MERALCO G2';
    public static final String PROFILE_NAME_MERALCO_G1 = 'MERALCO G1';
    public static final String PROFILE_NAME_SYSTEM_ADMINISTRATOR = 'System Administrator';
    
    public static final String CASE_ERROR_DEPOSIT_AMOUNT_CHANGE = 'You are not allowed to change the Deposit Amount in this Case';

    public static final String WEB_TO_CASE_CAPTCHA_ERROR = 'Please verify the captcha.'; // CSM 153 and 154
    public static final String WEB_TO_CASE_SAME_AS_BILLING = 'My home address is the same as my billing address';
    public static final String WEB_TO_CASE_NOT_SAME_AS_BILLING = 'No, I have a different billing address';    
    //END Christian Doctolero March-14-17
    
    //Case field labels
    //BEGIN Rom Edison Reyes MAR-18-17 (CSM-1919)
    public static final String CASE_APPLIED_LOAD = 'Applied Load';
    public static final String CASE_BILLING_CLASS = 'Billing Class';
    public static final String CASE_CONTRACTED_CAPACITY = 'Contracted Capacity';
    public static final String CASE_DEMAND_FACTOR = 'Demand Factor';
    public static final String CASE_LOAD_FACTOR = 'Load Factor';
    public static final String CASE_MATERIAL = 'Material';
    public static final String CASE_PHASE = 'Phase';
    public static final String CASE_POLE_CODE = 'Pole Code';
    public static final String CASE_PSIC = 'PSIC';
    public static final String CASE_SERVICE_RATE_TYPE = 'Service Rate Type';
    public static final String CASE_SERVICE_SUPPLY_TYPE = 'Service Supply Type';
    public static final String CASE_SERVICE_WIRE_LENGTH = 'Service Wire Length';
    public static final String CASE_WIRE_SIZE = 'Service Wire Size';
    public static final String CASE_SERVICE_WIRE_TYPE = 'Service Wire Type';
    public static final String CASE_VOLTAGE = 'Voltage';
    //END Rom Edison Reyes MAR-18-17 (CSM-1919)

    //START Michael Lasala MAR-20-17 For visualforce email template
    public static final String FIELD_ORDER_RECORDTYPE_NAME_METER_SOCKET_DELIVERY = 'Meter Socket Delivery';

    //Jerome To  MAR-28-17 CSM-2022
    public static final String PSIC_NAME_RESIDENTIAL = 'Residential';
    public static final String CASE_SERVICE_RATE_TYPE_RESIDENTIAL_SERVICE_RS = 'Residential Service (RS)';
    public static final String CASE_BILLING_CLASS_RESIDENTIAL_SERVICE_RS = 'Residential Service(RS)';
    //END Jerome To  MAR-28-17 CSM-2022

    //BEGIN Jerome To MAY-22-17 (CSM-166)
    public static final String CONTRACTED_CAPACITY_SCALE_MEDIUM = 'MEDIUM';
    public static final String CONTRACTED_CAPACITY_SCALE_LARGE = 'LARGE';
    public static final String CONTRACTED_CAPACITY_SCALE_VERY_LARGE = 'VERY LARGE';
    public static final String CONTRACTED_CAPACITY_SCALE_EXTRA_LARGE = 'EXTRA LARGE';
    public static final String SERVICE_RATE_TYPE_GSA = 'General Service A (GSA)';
    public static final String SERVICE_RATE_TYPE_RES = 'Residential Service (RS)';
    public static final String SERVICE_RATE_TYPE_GSB = 'General Service B (GSB)';
    public static final String SERVICE_RATE_TYPE_GHMSCI = 'Government Hospitals, Metered Streetlights & Charitable Institutions (GHMSCI)';
    public static final String VOLTAGE_LEVEL_SECONDARY = 'Secondary';
    public static final String VOLTAGE_LEVEL_TYPE_E = 'Type E - below 13.2kV';
    public static final String VOLTAGE_LEVEL_TYPE_D = 'Type D - 13.8/13.2kV';
    public static final String VOLTAGE_LEVEL_TYPE_C = 'Type C - 34.5kV';
    public static final String VOLTAGE_LEVEL_TYPE_B = 'Type B - 69kV';
    public static final String VOLTAGE_LEVEL_TYPE_A = 'Type A - 115kV';
    //END Jerome To MAY-22-17 (CSM-166)

    // START Jerome To MAY-29-17
    public static final String CASE_MODIFICATION_ERROR_DUPLICATE_OR_PENDING_CASE_EXIST = 'There is still a pending case on the entered SIN.'; // CSM-6444 JEROME TO JUN-04-17
    public static final String ACCOUNT_ERROR_PENDING_CASE_MODIFICATION_EXIST = 'An ongoing case {0} is in progress for this account.';
    public static final String ACCOUNT_ERROR_NO_CASE_MODIFICATION_EXIST = 'Editing of this account is restricted. Please file a Case for Modification of Electric Service to update the account.';
    public static final String ADDRESS_ERROR_CUSTOMER_ADDRESS_ALREADY_EXISTS = 'Customer address already exists.';
    public static final String ADDRESS_ERROR_SERVICE_ADDRESS_ALREADY_EXISTS = 'You cannot add more than one service address for a service.';
    public static final String ADDRESS_ERROR_BILLING_ADDRESS_ALREADY_EXISTS = 'You cannot add more than one billing address for a contract.';
    public static final String CASE_RECORD_TYPE_NEW_SERVICE_APPLICATION = 'New_Service_Application';
    public static final String CASE_RECORD_TYPE_TERMINATION_OF_ELECTRIC_SERVICE = 'CXE_Termination_of_Electric_Service';
    public static final String CASE_RECORD_TYPE_MODIFICATION_OF_ELECTRIC_SERVICE = 'CXE_Modification_of_Electric_Service';
    public static final String CASE_RECORD_TYPE_RECONTRACT_OF_ELECTRIC_SERVICE = 'CXE_Recontract_of_Electric_Service';
    public static final String WEB_TO_CASE_PERSONA_CONTRACTOR = 'Contractor';

    public static final String CASE_APPROVAL_CXE_CASE_APPROVALS = 'Case_Approvals';
    // FOR APPROVAL CHECKBOX ONLY
    public static final String CASE_REQUEST_GSL4_TARGET_DATE_MODIFICATION = 'REQUEST_GSL4_TARGET_DATE_MODIFICATION';
    public static final String CASE_REQUEST_FOR_LIFTING_OF_ARREARS_TAG = 'REQUEST_FOR_LIFTING_OF_ARREARS_TAG';
    public static final String CASE_REQUEST_FOR_APPLICATION_CANCELLATION = 'REQUEST_FOR_APPLICATION_CANCELLATION';
    public static final String CASE_REQUEST_FOR_CHANGE_IN_NAME = 'REQUEST_FOR_CHANGE_IN_NAME';
    public static final String CASE_OVERRIDE_AUTO_DEPOSIT_AMOUNT = 'OVERRIDE_AUTO_DEPOSIT_AMOUNT';

    public static final String ACCOUNT_RECORD_TYPE_CXE_INDIVIDUAL_ACCOUNT = 'CXE_Individual_Account';
    public static final String ACCOUNT_RECORD_TYPE_CXE_BUSINESS_ACCOUNT = 'CXE_Business_Account';

    // END Jerome To MAY-29-17

    // START CSM-3779, CSM-6130, CSM-6494, CSM-6471, CSM-6483 
    // Jerome To   JUN-02-17
    public static final String FIELD_ORDER_RECORD_TYPE_INSPECTION_FO = 'CXE_Inspection_FO';
    public static final String FIELD_ORDER_RECORD_TYPE_METER_SOCKET_FO = 'CXE_Meter_Socket_Delivery';
    public static final String FIELD_ORDER_RECORD_TYPE_RE_INSPECTION_FO = 'CXE_Re_Inspection_FO';
    public static final String FIELD_ORDER_RECORD_TYPE_SURVEY_FO = 'CXE_Survey_FO';

    public static final String AMC_SERVICE_PACKAGE_TECHNICAL_BUNDLE = 'Technical Bundle';
    public static final String AMC_SERVICE_PACKAGE_FULL_BUNDLE = 'Full Bundle';
    public static final String AMC_SERVICE_PACKAGE_DOCUMENTARY_BUNDLE = 'Documentary Bundle';
    public static final String AMC_SERVICE_PACKAGE_PROCESSING_BUNDLE = 'Processing Bundle';

    public static final String AMC_RULE_ERROR_INVALID_STATUS_FOR_AMC_SERVICE_TAG = 'Case with {0} Status is not allowed to have AMC Service.';
    public static final String AMC_RULE_ERROR2 = 'Accredited Meralco Contractor is required for applications with AMC Service.';
    public static final String AMC_RULE_ERROR3 = 'Case with {0} Status is required to be associated with Accredited Meralco Contractor.';
    //public static final String AMC_RULE_ERROR4 = 'AMC Service Package is required for applications with Accredited Meralco Contractor.';
    public static final String AMC_RULE_ERROR_INVALID_STATUS_FOR_AMC_SERVICE_PACKAGE = 'Case with {0} Status is invalid for {1} AMC Service Package.';
    public static final String WEB_TO_CASE_ERROR_NO_SERVICE_RECORD_FOUND = 'No Service record found.'; // JEROME TO JUN-14-2017
    // Jerome To   JUN-02-17
    // END CSM-3779, CSM-6130, CSM-6494, CSM-6471, CSM-6483 
    //You cannot further edit the record if status is "Application Approved".
    //public static final String CASE_ERROR_MESSAGE_ALLOW_SYSTEM_ADMIN_ONLY = 'Only System Administrators are allowed to edit this record with this status.'; // CSM-6448 JEROME TO  JUN-06-17
    public static final String CASE_ERROR_MESSAGE_ALLOW_SYSTEM_ADMIN_ONLY = 'You cannot further edit the record with this status.'; // CSM-6448 JEROME TO  JUN-15-17

    //START CSM-3861 Service Request
    public static final String SERVICE_REQ_CHANGE_IN_NAME = 'Change in Contract Name';
    public static final String SERVICE_REQ_ADDITIONAL_LOAD = 'Additional Load';
    public static final String SERVICE_REQ_REDUCTION_LOAD = 'Reduction in Load';
    public static final String SERVICE_REQ_REMODEL = 'Remodel';
    public static final String SERVICE_REQ_RELOCATION = 'Relocation';
    public static final String SERVICE_REQ_TRANSFER = 'Transfer of Service'; //START/END CSM-7223 - corrected the value from 'Tranasfer' to 'Transfer'
    //END CSM-3861 Service Request

    //START CSM-3861 Service Request Custom Setting
    public static final String SERV_REQ_CHANGE_IN_NAME = 'Change in Contract Name';
    public static final String SERV_REQ_ADDITIONAL_REDUCTION_LOAD = 'Add/Reduction Load';
    public static final String SERV_REQ_REMODEL = 'Remodel';
    public static final String SERV_REQ_REMODEL_RELOCATION = 'Remodel/Relocation';
    //END CSM-3861 Service Request Custom Setting
    public static final Set<String> MODIF_SER_REQ_EXEMPTED_FIELDS_LOAD = new Set<String>
    {
        'Applied_Load__c','PSIC__c','Code_PSIC__c','Demand_Factor__c','Load_Factor__c','Contracted_Capacity__c',
        'Service_Rate_Type__c','Code_Service_Rate_Type__c','Billing_Class__c','Code_Billing_Class__c',
        'Deposit_Amount__c','Bill_Deposit_Schedule__c'
    };
    //START CSM-3861 Service Request Custom Setting
    public static final String SERV_REQ_ERRORMSG = 'You are not allowed to edit '; //START/END CSM-7249 RReyes JUL-05-17 - Rephrased error message
    //END CSM-3861 Service Request Custom Setting

    //START CSM-7202
    public static final String SHARE_ACCESS_LEVEL_EDIT = 'Edit';
    public static final String GROUP_TYPE_MANAGER = 'Manager';
    //END CSM-7202
    
     public static final String CHANGE_IN_NAME_BUS = 'Last_Name_Business_Name__c';//START/END CSM-7249 RReyes JUL-04-17
     public static final String CASE_ERROR_ACCOUNT_WITHOUT_V10_NUM = 'This account is ineligible for reuse. Please select another account or populate case details to create an account.';//START/END CSM-7272 RReyes JUL-06-17
        
     //START CSM-12223/12251 RReyes AUG-08-17   
     public static final String CASE_ERROR_CLICK_RETRIEVE_BUTTON = 'Please click Retrieve Outstanding Amount button.';
     //END CSM-12223/12251 RReyes AUG-08-17
     //START CSM-12217/12251 RReyes AUG-08-17
     public static final String CASE_ERROR_CLICK_UPDATE_BILL_DEPOSIT = 'Please click Update Bill Deposit Button.'; 
     public static final String CASE_ERROR_SAVE_CONTRACTED_CAPACITY = 'Please save changes on the Contracted Capacity details (Applied Load, Load Factor, Demand Factor) before flipping this case status to ';
     public static final String CASE_ERROR_CLICK_UPDATE_BILL_DEPOSIT_WITH_STATUS = 'Please click Update Bill Deposit button before flipping the case status to ';    
    //END CSM-12217/12251 RReyes AUG-08-17
    //START RReyes CSM-6704 JUN-14-2017 - status path groupings
    // START R2C CSM-14084 Shayne 10/27/2017
    public static final String SHARE_ACCESS_LEVEL_READ = 'Read';
    // END R2C CSM-14084 Shayne 10/27/2017
    // Start CSM-12156 Von Pernicia AUG-03-17
    public static final Set<String> CASE_STATUS_SET_APPLY = new Set<String>
    {
        'New', 'Application Received',  'Application with Insufficient Data'
    };
    
    public static final Set<String> CASE_STATUS_SET_COMPLETE = new Set<String>
    {
        /*'Contract Finalized', 'Awaiting Customer Compliance', 'Energization FO Cancelled', 
        'AMC Service Completed','Application Approved'*/
        'AMC Service Completed', 'Service Entrance Still OK', 'Inspection FO Resolved - Approved',
        'Application Approved', 'Contract Finalized'//, 'Energization FO Cancelled'      
    };
    
    public static final Set<String> CASE_STATUS_SET_ENERGIZE = new Set<String>
    {
        /*'Energized', 'Billed', 'Application Ready for Connection', 'Pending Energization'*/
        'Re-inspection FO Generated', 'Re-inspection FO Scheduled', 'Re-inspection FO Resolved - Approved',
        'Re-inspection FO Resolved - Disapproved', 'Application Ready for Connection', 'Pending Energization',
        'Awaiting Customer Compliance', 'Energized', 'Billed'
    };
    
    public static final Set<String> CASE_STATUS_SET_EVALUATE = new Set<String>
    {
        /*'Pre-Survey FO Not Required', 'Pre-Survey FO Generated', 'Pre-Survey FO Scheduled', 
        'Pre-Survey FO Resolved - Feasible', 'Pre-Survey FO Resolved - Not Feasible', 'Application Validated'*/
        'Application Validated', 'Pre-Survey FO Not Required', 'Pre-Survey FO Generated',
        'Pre-Survey FO Scheduled', 'Pre-Survey FO Resolved - Feasible', 'Pre-Survey FO Resolved - Not Feasible'

    };
    
    public static final Set<String> CASE_STATUS_SET_INSPECT = new Set<String>
    {
        /*'Meter Socket Issued', 'Meter Socket Still Installed Onsite', 'Meter Socket Delivery FO Generated', 
        'Meter Socket Delivery FO Scheduled', 'Meter Socket Delivered', 'Meter Socket Not Delivered', 
        'AMC Service Availed', 'Service Entrance Still OK', 
        'Inspection FO Generated', 'Inspection FO Scheduled', 'Inspection FO Resolved - Approved', 
        'Inspection FO Resolved - Disapproved', 'Re-inspection FO Generated', 
        'Re-inspection FO Scheduled', 'Re-inspection FO Resolved - Approved', 'Re-inspection FO Resolved - Disapproved',
        'Application Evaluated'*/
        'Application Evaluated', 'Meter Socket Issued', 'Meter Socket Still Installed Onsite',
        'Meter Socket Delivery FO Generated', 'Meter Socket Delivery FO Scheduled', 'Meter Socket Delivered',
        'Meter Socket Not Delivered', 'AMC Service Availed', 'Inspection FO Generated', 'Inspection FO Scheduled',
        'Inspection FO Resolved - Disapproved'
    };
    
    public static final Set<String> CASE_STATUS_SET_RETIRE = new Set<String>
    {
        /*'Contract Termination Initiated', 'Pending Retirement', 'Retired', 
        'Final Bill Generated', 'Contract Terminated', 'Retirement FO Cancelled' //START/END CSM-7294 RReyes JUL-06-17 - added 'Retirement FO Cancelled'*/
        'Contract Termination Initiated', 'Pending Retirement','Retired',
        'Retirement FO Cancelled', 'Final Bill Generated', 'Contract Terminated'

    };
    // End CSM-12156 Von Pernicia AUG-03-17
    //END RReyes CSM-6704 JUN-14-2017 - status path groupings
    
    //START CSM-13988 Clarissa Capagas OCT-24-17
    public static final Set<String> SERVICE_STATUS_PENDING_TERMINATED = new Set<String>
    {
        'Terminated',
        'Pending to Terminate'
    };
    //END CSM-13988 Clarissa Capagas OCT-24-17

    //START CSM-6929: Von Pernicia
    public static final String SERVICE_STATUS_TERMINATED = 'Terminated';
    public static final String SERVICE_STATUS_PENDING_TO_TERMINATE = 'Pending to Terminate'; //START/END CSMCW-14 Rachelle Alforja OCT-19-17
    public static final String CASE_ERROR_SIN_ALREADY_RECONTRACTED = 'SIN entered is already recontracted.';
    public static final String CASE_ERROR_ONLY_TERMINATED = 'The SIN you entered is currently active and not eligible for recontracting.'; //START/END CSM-7086 RReyes JUN-22-17 
    public static final String CASE_ERROR_ALREADY_RETRIEVED = 'Terminated Service already retrieved for this Case';
    public static final String CASE_ERROR_NO_PREVIOUS_SIN = 'Please provide the previous SIN.'; //START/END CSM-7138 RReyes JUN-23-17
    //END CSM-6929: Von Pernicia
    
    //START RReyes CSM-7116 JUN-14-2017 - valid status for SIN retrieval
    public static final Set<String> CASE_STATUS_BEFORE_APPLICATION_EVALUATED = new Set<String>
    {
        'New', 'Application Received',  'Application with Insufficient Data', 
        'Pre-Survey FO Not Required', 'Pre-Survey FO Generated', 'Pre-Survey FO Scheduled', 
        'Pre-Survey FO Resolved - Feasible', 'Pre-Survey FO Resolved - Not Feasible', 'Application Validated'
    };
    //END RReyes CSM-7116 JUN-14-2017 - valid status for SIN retrieval
    
    //START RReyes CSM-7140 JUN-22-2017 - valid status for account contact update during recontract
    public static final Set<String> CASE_STATUS_FOR_ACCOUNT_CONTACT_UPDATE = new Set<String>
    {
        'New', 'Application Received',  'Application with Insufficient Data'
    };
    //END RReyes CSM-7140 JUN-22-2017 - valid status for account contact update during recontract


    // START CODE REVIEW      JEROME TO    JUN-29-2017
    public static final String CASESTATETRANSITIONHELPER_MEDIATOR = 'Mediator'; // CaseStateTransitionHelper
    public static final String CASESTATETRANSITIONHELPER_CREATE = 'CREATE';

    //START CSM-7223 VPernicia - Creation of Requirement records
    public static final Set<String> REQUIREMENT_FOR_NEW_SERVICE_APPLICATION = new Set<String>
    {
        'Proof of Identification',
        'Proof of Occupancy',
        'Electric Load Documents',
        'Energization Date Agreement Form',
        'Tax Identification Documents',
        //'Authorization Documents',
        'Certificate of Final Electrical Inspection',
        'Customer\'s Service Application Warranty'
    };

    public static final Set<String> REQUIREMENT_FOR_RECONTRACT = new Set<String>
    {
        'Request for Electric Service Documents',
        'Proof of Identification',
        'Proof of Occupancy',
        'Customer\'s Service Application Warranty',
        'Electric Load Documents',
        'Certificate of Final Electrical Inspection',
        'Energization Date Agreement Form'
    };

    public static final Set<String> REQUIREMENT_FOR_TERMINATE = new Set<String>
    {
        'Request for Electric Service Documents',
        'Proof of Identification'
    };

    public static final Set<String> REQUIREMENT_FOR_MODIFICATION_CONTRACT_NAME = new Set<String>
    {
        'Proof of Identification',
        'Customer\'s Service Application Warranty',
        'Documents for Correction of Name'
    };

    public static final Set<String> REQUIREMENT_FOR_MODIFICATION_LOAD = new Set<String>
    {
        'Proof of Identification',
        'Customer\'s Service Application Warranty',
        'Electric Load Documents',
        'Undertaking to Submit Pending Document/s'
    };

    public static final Set<String> REQUIREMENT_FOR_MODIFICATION_REMODEL = new Set<String>
    {
        'Proof of Identification',
        'Customer\'s Service Application Warranty',
        'Electric Load Documents',
        'Certificate of Final Electrical Inspection',
        'Energization Date Agreement Form',
        'Right of Way Grant',
        'Undertaking to Submit Pending Document/s'
    };

    public static final Set<String> REQUIREMENT_FOR_MODIFICATION_RELOCATION = new Set<String>
    {
        'Proof of Identification',
        'Customer\'s Service Application Warranty',
        'Certificate of Final Electrical Inspection',
        'Energization Date Agreement Form',
        'Right of Way Grant',
        'Undertaking to Submit Pending Document/s'
    };

    public static final Set<String> REQUIREMENT_FOR_MODIFICATION_TRANSFER = new Set<String>
    {
        'Proof of Identification',
        'Proof of Occupancy',
        'Customer\'s Service Application Warranty',
        'Undertaking to Submit Pending Document/s'
    };
    //END CSM-7223 VPernicia - Creation of Requirement records
    
    //START CSM-7249 RReyes JUL-04-17
     public static final Set<String> CHANGE_IN_NAME_IND = new Set<String>
    {
        'First_Name__c',
        'Last_Name__c',
        'Middle_Name__c'
    };
    //END CSM-7249 RReyes JUL-04-17

    //START CSM-11457 RReyes JUL-17-17 - transfer validation in trigger
     public static final Set<String> CASE_STATUS_INVALID_TO_EDIT_NON_TERMINATION = new Set<String>
    {
       'Application Approved', 'Contract Finalized', 'Bill Deposit Fully Paid',
       'Bill Deposit Deferred', 'Application Ready for Connection', 'Pending Energization',
       'Energized', 'Billed','Application Closed'
    };

    public static final Set<String> CASE_STATUS_INVALID_TO_EDIT_TERMINATION = new Set<String>
    {
        'Retirement FO Cancelled', 'Application Approved', 'Pending Retirement',
        'Retired', 'Final Bill Generated', 'Contract Terminated', 'Application Closed'
    };
    //END CSM-11457 RReyes JUL-17-17 - transfer validation in trigger
    public static final String SERVICE_STATUS_ACTIVE = 'Active'; // CSM-10241  JUL-12-2017 JEROME TO 
    public static final String CASE_ERROR_RETRIEVED_SERVICE = 'You must click Retrieve Service Button first before editing this record.';// Start/End CSM-12149 & CSM-12144 Von Pernicia AUG-01-17

    public static final String CASE_ERROR_REQUIRE_BIRTHDAY = 'Please indicate the Contact Person\'s Date of Birth.';// Start/End CSM-12249 Von Pernicia AUG-10-17
    public static final String CASE_ERROR_PROVIDE_REASON = 'Please populate the Reason for Manual Deposit'; //START/END CSM-12277 RReyes AUG-17-17
    public static final String CASE_ERROR_RETRIEVED_OUTSTANDING = 'This function is only available for after sales cases.'; //START/END CSM-12243 Von Pernicia AUG-23-17
    //public static final String SERVICE_STATUS_ACTIVE = 'Active'; // CSM-10241  JUL-12-2017 JEROME TO 
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_INACTIVE = 'SIN is Inactive.'; // CSM-10241  JUL-12-2017 JEROME TO 
    
    //Start CSM-12867 SEP-22-2017 Joebhelle Rances - Update Error Message
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_INACTIVE = 'Sorry, but your service is currently inactive. Please call our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    //Start CSM-13469 10/05/17 Rabayon - Update Error Message
    public static final String PORTAL_REGISTRATION_ERROR_SIN_INACTIVE = 'Your service is currently inactive. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    //End CSM-13469
    //End CSM-12867
    
    //Start CSM-12454 Emandolado 9/13/2017 Revert Changes
    //Start CSM-12391 Emandolado  9/5/2017
    //START CSM-12928 JRances SEP-25-2017 - Change "Customer Portal Account" To "Meralco Online Account"
    //Start CSM-13469 Rabayon 10/05/17 - update error message
    public static final String PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL = 'This email address is already associated with another Meralco Online account. Please log in with the correct password, or enter a new email address.';
    //End CSM-13469 Rabayon
    //public static final String PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL = 'Sorry, but this email address is already associated with another customer portal account. Please input the correct password or enter a new email address.';
    //public static final String PORTAL_REGISTRATION_ERROR_DUPLICATE_EMAIL = 'These values being inputted are already enrolled before from an already existing account';
    //END CSM-12928 JRances
    //End CSM-12391 Emandolado
    //End CSM-12454 Emandolado
    
    //error message if already login 
    public static final String PORTAL_REGISTRATION_ERROR_HAS_SESSION = 'Please logout first from current session.';
    public static final String PORTAL_REGISTRATION_SUCCESSFUL = 'Portal User has been successfully created.'; // CSM-10241  JUL-12-2017 JEROME TO 
    public static final String CONTRACT_TYPE_PREPAID = 'Prepaid';
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_PREPAID = 'Prepaid SINs are not allowed to be enrolled in a portal account for this release.';
    //Start CSM-12443 GGrandea 9/8/2017
    //Start CSM-13469 Rabayon 10/05/17-update error message
    
    //START CSM-14857 JRances 12/11/2017 - [R3A REGRESSION] Notification Update
        //public static final String PORTAL_REGISTRATION_ERROR_SIN_PREPAID = 'Enrollment of KLoad or prepaid electricity accounts is currently unavailable.';
        public static final String PORTAL_REGISTRATION_ERROR_SIN_PREPAID = 'Enrollment of Kuryente Load or prepaid electricity accounts is currently unavailable.';
    //END CSM-14857 JRances
    
    //End CSM-13469 Rabayon
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_PREPAID = 'Sorry, but you\'ve entered an invalid value. Please check your bill and enter the correct total kWh'; //CSM-12451 Emandolado 9/6/2017
        //End CSM-12443 GGrandea 9/8/2017
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE = 'This SIN has reached its maximum portal account enrollments.';
        //START CSM-12463 GGrandea 09.08.2017 revert changes of CSM-12391
    //Start CSM-12391 Emandolado  9/5/2017
    //START CSM-14153 Jerome To 10/27/2017
    
    //Start CSM-14638 Janah Intal 11/24/17
        //Start CSM-13469 Rabayon 10/05/17
        //public static final String PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE = 'This Service ID Number has already reached its maximum of 2 enrollments. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    public static final String PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE = 'This Service ID Number has already reached its maximum of 2 Meralco Online account enrollments. Please call us at our  24/7 hotline at 16211 or business hotline at 16210 for assistance.';
        //End CSM-13469 Rabayon
    //Start CSM-14638 Janah Intal 11/24/17
    
    public static final String PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE_REGISTRATION = 'Sorry, but this SIN has already reached its maximum of 2 enrollments. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_ENROLLED_TWICE = 'This service is registered to another portal account';
    //END CSM-14153 Jerome To 10/27/2017
    //EndSM-12391 Emandolado  9/5/2017
        //END CSM-12463 GGrandea 09.08.2017
    public static final String PORTAL_REGISTRATION_ERROR_SIN_INVALID_LENGTH = 'Your SIN should have 12 digits.';
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT = 'Please contact {0} for CBG SIN enrollment';
    // Start CSM-12462 Jerome To Added updated \' to \'\'
    // Start CSM-13469 Rabayon 10/05/17    
    // START CSM-14503 Jayson Sarion Error registration prompt for CBG Conglomerate
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT = 'Thank you for registering on Meralco Online! We\'ll get in touch with you soon to finalize your registration. For further assistance, please call us at our 24/7 business hotline at 16210.';
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT = 'Thank you for registering on Meralco Online! We\'ll get in touch with you soon to finalize your registration. For further assistance, please contact your Relationship Manager, {0}, or call us at our 24/7 business hotline at 16210.';
    //START CSM-14503 JRances - Registration prompt displayed upon registration of a CBG Conglomerate did not matched from the requirements.
    //START CSM-14958 RReyes DEC-22-17 R2C CR on error message	
    public static final String PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT = 'Thank you for your intent to register on Meralco Online! Your Relationship Manager will get in touch with you soon to guide you on the registration process. For further assistance, please call us at our 24/7 business hotline at 16210 or email us at customercare@meralco.com.ph.';
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_CBG_ACCOUNT = 'Thank you for registering on Meralco Online! We\'\'ll get in touch with you soon to finalize your registration. For further assistance, please contact your Relationship Manager,{0}, or call us at our 24/7 business hotline at 16210.';
    //END CSM-14958 RReyes DEC-22-17 R2C CR on error message
    	
    //END CSM-14503 JRances
    // END CSM-14503 Jayson Sarion Error registration prompt for CBG Conglomerate
    
    //End CSM-13469 Rabayon
    //START CSM-12888 JRances SEPT-22-2017 - Update Error Message
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_RES = 'Please contact MERALCO for Retailer enrollment';
    //public static final String PORTAL_REGISTRATION_ERROR_SIN_RES = 'Thanks for applying to create a Meralco Customer Portal account! We\'\'ll get in touch with you soon to finalize your portal enrollment. For further assistance, please speak to your Relationship Manager, {0}, or call us at our 24/7 business hotline at 16210.';
    //Start CSM-13469 Rabayon 10/05/17 - update error message  
    
    //START CSM-14857 JRances 12/11/2017 - [R3A REGRESSION] Notification Update
        //public static final String PORTAL_REGISTRATION_ERROR_SIN_RES = 'Enrollment of retailer accounts is currently unavailable. Please call us at our 24/7 hotline at 16211 for assistance.';
        public static final String PORTAL_REGISTRATION_ERROR_SIN_RES = 'Enrollment of retailer accounts is currently unavailable.';
    //END CSM-14857 JRances
    
    // End CSM-13469 Rabayon
    //END CSM-12888 JRances
    
    // End CSM-12462 Jerome To Added updated \' to \'\'
    public static final String CASE_RECORD_TYPE_BUSINESS_SELF_REGISTRATION = 'CXE_Portal_Registration_SIN_Enrollment';
    //public static final String PORTAL_REGISTRATION_NOTICE_SIN_HAS_BEEN_USED = 'This service is registered to another portal account.';
    public static final String PORTAL_REGISTRATION_NOTICE_SIN_HAS_BEEN_USED = 'This SIN is registered to another portal account. Please call our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    public static final String SERVICE_ENROLLMENT_TYPE_PAYOR = 'Payor';
    public static final String SERVICE_ENROLLMENT_TYPE_NON_PAYOR = 'Non-Payor';

    //public static final String PORTAL_COMMUNITY_PROFILE = 'MERALCO Customer Portal';wen jun proposed this changed
    public static final String PORTAL_COMMUNITY_PROFILE = 'MERALCO Customer Portal';

    public static final String MERALCO_CUSTOMER_COMMUNITY_PROFILE = 'Meralco Customer Community Profile';
    public static final String PORTAL_REGISTRATION_ERROR_NO_BILLING_DETAILS = 'No Billing Details.';
    public static final String PORTAL_REGISTRATION_ERROR_BILL_DID_NOT_MATCH_BILL_DATE = 'Bill Date did not match Bill Date provided.';
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_NEWLY_ENERGIZE = 'Invalid Billing Details.Please input the Deposit Amount paid for the service and the Payment Date.';
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_NOT_NEWLY_ENERGIZE = 'Invalid Billing Details.Please input the total kWh of one of his bills for the past 2 months and the corresponding bill date (bill generation date).';
    public static final String PORTAL_REGISTRATION_ERROR_BLANK_PAYOR = 'This SIN has no Payor.';
    public static final String PORTAL_REGISTRATION_EMAIL_TEMPLATE_CBG = 'CXE_CBG_RM_Notification_Registration'; // CSM-10769
    //Start CSM-13469 Rabayon 10/05/17 - update error message
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_TOTAL_KWH = 'You\'ve entered an invalid value. Please check your bill and enter the correct total kWh.';
    
    //START CSM-14857 JRances 12/11/2017 - [R3A REGRESSION] Notification Update
        //public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE = 'You\'ve entered an invalid bill date. Please check your bill from the past 2 months and enter the correct bill date.'; // CSM-13850 RBellalba /*** CSM-14679 - 11/29/2017 - start - JIntal***/
        public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DATE = 'You\'ve entered an invalid bill date. Please check any bill from the past 2 months and enter the correct bill date.';
    //END CSM-14857 JRances
    
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_BILL_DEPOSIT_AMT = 'You\'ve entered an invalid value. Please check your receipt and enter the correct bill deposit amount.';
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INCORRECT_PAYMENT_DATE = 'You\'ve entered an invalid payment date. Please check your receipt and enter the correct payment date.';
    //End CSM-13469 Rabayon
    //START CSM-14090 GGrandea 10.25.2017
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_EXISTING_BOTH_KWH_AND_BILL_DATE = 'You\'ve entered invalid details. Please check your bill and enter the correct total kWh and bill date.';
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_NEW_BOTH_BILLDEPOSIT_AND_PAYMENT_DATE = 'You\'ve entered invalid details. Please check your payment receipt and enter the correct bill deposit amount and payment date.';
    //END CSM-14090

    //START CSM-14091 GGrandea 10.25.2017
    //public static final String PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD = 'Sorry, but you\'re not allowed to register. The SIN already has billing record. Please select existing.'; //CSM-13974 Jerome To 10/18/2017
    public static final String PORTAL_REGISTRATION_ERROR_HAS_EXISTING_BILLING_RECORD = 'Please select Existing Service for this Service ID Number and input your bill details.'; //CSM-14091 GGrandea 10.25.2017
    //END CSM-14091
    // These values being inputted are already enrolled before from an already existing account

    // START CSM-13444 RBellalba OCT-06-17
    public static final String PORTAL_REGISTRATION_ERROR_INVALID_BILLING_DETAILS_INVALID_TOTAL_KWH = 'Please input only numbers.';
    // END CSM-13444 RBellalba OCT-06-17
    
    // CSM-XXXX RReyes JUL-20-17
    // public static final String SERVICE_ENROLLMENT_SUCCESSFUL = 'SIN has been successfully enrolled.';
    public static final String SERVICE_ENROLLMENT_HMB_NOT_ALLOWED = 'Your portal account is not allowed to add a Home/Micro Biz service.';
    
    // START CSM-13444 RBellalba OCT-05-17
    public static final String SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED = 'To add a Service ID Number under a business account, please call us at our 24/7 business hotline at 16210.';
    // END CSM-13444 RBellalba OCT-05-17
    
    // START CSM-13444 RBellalba OCT-06-17
    public static final String SERVICE_ENROLLMENT_SUCCESSFUL = 'Service successfully enrolled!'; // CSM-14655 Red 11-23-2017
    // END CSM-13444 RBellalba OCT-06-17
    //START CSM-10865 RReyes - JUL-28-17
    //public static final String SERVICE_ENROLLMENT_CONGLOMERATE_NOT_ALLOWED = 'To add a SIN under a business account, please call us at our 24/7 business hotline at 16210.';
    public static final String SERVICE_ENROLLMENT_CBG_BIZ_NOT_ALLOWED = 'Your portal account is not allowed to add a Business service.';
    //public static final String SERVICE_ENROLLMENT_CBG_BIZ_NOT_ALLOWED = 'Please contact {0} for CBG SIN enrollment'; // CSM-11982 Jerome To JULY 27, 2017
    //END CSM-10865 RReyes - JUL-28-17
    public static final String SERVICE_STATUS_PENDING = 'Pending';
    public static final String SERVICE_STATUS_ACTIVE_PENDING_TO_DISCONNECT = 'Active - Pending to Disconnect';
    public static final String SERVICE_STATUS_ACTIVE_DISCONNECTED = 'Active - Disconnected';
    
    //START CSM-13759 JRances - Update Error Message to v2.1 Error Message
    //START CSM-14892 JRances 12/15/17 - [R2C Regression] Incorrect prompt message is displayed upon adding SIN with retailer account
    //public static final String SERVICE_ENROLLMENT_SIN_RES = 'Enrollment of retailer accounts is currently unavailable. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';  //CSM-14735 - JIntal - 110517
    public static final String SERVICE_ENROLLMENT_SIN_RES = 'Enrollment of retailer accounts is currently unavailable.';
    //END CSM-14892 JRances
    //public static final String SERVICE_ENROLLMENT_SIN_RES = 'Sorry, but enrollment of retailer accounts is currently unavailable. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    //public static final String SERVICE_ENROLLMENT_SIN_RES = 'Sorry, but enrollment of retailer accounts is currently unavailable. Please call our 24/7 hotline at 16211 or business hotline at 16210 for assistance.';
    //END CSM-13759 JRances
    
    public static final String SERVICE_ENROLLMENT_SIN_NOT_UNDER_ACCOUNT = 'This SIN is not tagged under your account.';
    public static final String SERVICE_ENROLLMENT_SIN_INVALID_LENGTH = 'Sorry, but you\'ve entered an invalid SIN. Please check your bill and enter the correct SIN.';
    
    //START CSM-12932 JRances Update Error Message
        public static final String SERVICE_ENROLLMENT_NOTICE_SIN_HAS_BEEN_USED = 'Sorry, but this SIN is already registered under another portal account. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance.'; 
        //public static final String SERVICE_ENROLLMENT_NOTICE_SIN_HAS_BEEN_USED = 'This SIN is registered to another portal account'; // CSM-12460 Melvin CorbesThis service is registered to another portal account' 'Sorry, but this SIN is already registered under another portal account. Please call us at our 24/7 hotline at 16211 or business hotline at 16210 for assistance. ';
    //END CSM-12932 JRances
    
    public static final String SERVICE_ENROLLMENT_SIN_ALREADY_ENROLLED = 'This SIN is already enrolled to your portal account';
    // CSM-XXXX RReyes JUL-20-17

    //START CSM-11087, CSM-11093, CSM-11099, CSM-11015, CSM-11111, CSM-11117, CSM-11966 RReyes JUL-26-17
    public static final String VIEW_BILL_TOOLTIP_IPA = 'This bill is covered by an Installment Payment Agreement. Please pay the installments on or before their respective due dates at any Meralco Business Center.';
    public static final String VIEW_BILL_TOOLTIP_TRO = 'We’ve deferred the collection of payments for this bill, pending the lifting of the Temporary Restraining Order issued by the Court.';
    public static final String VIEW_BILL_TOOLTIP_UNDER_REVIEW = 'We’re still reviewing this bill. For further assistance, please call us at our 24/7 hotline at 16211 or business hotline at 16210.';
    public static final String VIEW_BILL_TOOLTIP_APA = 'We’ve sent this bill to your bank/credit card company for settlement. We’ll send you a confirmation message once payment has been processed.'; //START/END CSM-12355 RReyes SEP-06-17 - removed note in tooltip message
    public static final String VIEW_BILL_TOOLTIP_BILL_DEPOSIT = 'The bill deposit serves as a guarantee for payment of electric bills. It is equivalent to your estimated billing for one month and may be adjusted yearly based on your actual average monthly consumption.';
    //START CSM-14689 RReyes DEC-22-17 - change message
    public static final String VIEW_BILL_TOOLTIP_SERV_IRREG = 'We’ve issued this bill in connection with RA 7832 or the "Anti-electricity and Electric Transmission Lines/Materials Pilferage Act of 1994". For concerns, please call our hotlines 16211 or 16210 (for business).';
    //public static final String VIEW_BILL_TOOLTIP_SERV_IRREG = 'We’ve issued this bill in connection with RA 7832 or the "Anti-electricity and Electric Transmission Lines/Materials Pilferage Act of 1994". This bill indicates the amount due for electricity consumed but not registered in your electric meter due to an act in violation of the law. For concerns, please call us at our 24/7 hotline at 16211 or business hotline at 16210.';
    //END CSM-14689 RReyes DEC-22-17 - change message
    //END CSM-11087, CSM-11093, CSM-11099, CSM-11015, CSM-11111, CSM-11117, CSM-11966 RReyes JUL-26-17

    public static final String ORG_WIDE_EMAIL = 'donotreply@meralco.com.ph';
    
    public static final String EMAIL_TEMPLATE_ACCTDEACTIVATION_150_DAYS_INDIV = 'CXE_Inactivity_of_Portal_Account';
    public static final String EMAIL_TEMPLATE_ACCTDEACTIVATION_150_DAYS_BIZ = 'CXE_Inactivity_of_Portal_Account_BIZ';
    public static final String EMAIL_TEMPLATE_180_DAYS_INACTIVITY_INDIV = 'CXE_Inactivity_of_Portal_Account_Deact';
    public static final String EMAIL_TEMPLATE_180_DAYS_INACTIVITY_BIZ = 'CXE_Inactivity_of_Portal_Acnt_Deact_BIZ';
    public static final String EMAIL_TEMPLATE_SELF_DEACTIVATION_INDIV ='CXE_Portal_Account_Deactivation';
    public static final String EMAIL_TEMPLATE_SELF_DEACTIVATION_BIZ ='CXE_Portal_Account_Deactivation_BIZ';
    public static final String EMAIL_TEMPLATE_ALL_ENROLLED_SERVICE_TERMINATED = 'CXE_Deactivation_of_Portal_Terminated';
    public static final String EMAIL_TEMPLATE_ALL_ENROLLED_SERVICE_TERMINATED_BIZ = 'CXE_DeactivationPortal_Terminated_BIZ';
    public static final String EMAIL_TEMPLATE_SERVICE_TERMINATED_INDIV = 'CXE_Termination_of_service';
    public static final String EMAIL_TEMPLATE_SERVICE_TERMINATED_BIZ = 'CXE_Termination_of_service_BIZ';
    public static final String ALL_STR ='ALL';
    
    //Start Vincent - 8/10/2017
    public static final String BPM_PAPERLESS ='BILPRNT003';
    public static final String BPM_PAPER ='BILPRNT001';
    public static final String BPM_PAPERPLUS='BILPRNT002';
    //End Vincent
    
    //START RSongco - Aug-04-17
    //START CSM-12929 JRances SEP-25-2017 Change error message based from Customer Portal Notification v2.1
    //public static final String SERVICE_ENROLLMENT_MUST_BE_LESS_THAN_2_MONTHS_AGO = 'Sorry, but you\'ve entered an invalid bill date. Please check your bill and enter the correct bill date.';
    //public static final String SERVICE_ENROLLMENT_MUST_BE_LESS_THAN_2_MONTHS_AGO = 'Date must not be less than 2 months ago.';
    //END CSM-12929 JRances
    //END RSongco - Aug-04-17
    
    //START CSM-14857 JRances 12/11/2017 - [R3A REGRESSION] Notification Update
        //public static final String SERVICE_ENROLLMENT_MUST_BE_LESS_THAN_2_MONTHS_AGO = 'You\'ve entered an invalid bill date. Please check your bill and enter the correct bill date.';
        public static final String SERVICE_ENROLLMENT_MUST_BE_LESS_THAN_2_MONTHS_AGO = 'You\'ve entered an invalid bill date. Please check any bill from the past 2 months and enter the correct bill date.';
    //END CSM-14857 JRances
    
    public static final String PORTALUSER_TIMEZONESIDKEY = 'Asia/Hong_Kong';
    public static final String PORTALPORTALUSER_LOCALESIDKEY = 'en_PH';
    public static final String PORTALUSER_EMAILENCODINGKEY = 'ISO-8859-1';
    public static final String PORTALUSER_LANGUAGELOCALEKEY = 'en_US';
    public static final String PORTALUSER_NOTIF_EMAIL = 'Email';
    public static final String PORTALUSER_NOTIF_SMS = 'SMS';

    public static final String PORTAL_GUEST_PROFILE = 'Meralco Customer Community Profile';

    
    
    //RjRances - Aug-25-17
    //Start CSM-13469 Rabayon -update error message 10/05/17
    public static final String PORTAL_REGISTRATION_NOTICE_SIN_HAS_BEEN_USED2 = 'This Service ID Number is already enrolled under another Meralco Online account.';
    //End CSM-13469 Rabayon
    
    //CSM-11942
    public static final String CONTRACTREUSE_BILLING_ADDRESS_MISSING = 'Contract\'s billing address is missing.';
    public static final String CONTRACTREUSE_CASE_CONTRACT_ALREADY_CREATED = 'Cannot re-use a contract if Create Contract button has been pressed.';
    public static final String CONTRACTREUSE_CONTRACT_ALREADY_BEING_REUSED = 'Contract is already being reused by an open case record.';

    // CSM-12187 Jerome To
    public static final String ORG_WIDE_ADDRESS = 'donotreply@meralco.com.ph';
    public static final String CBG_RM_EMAIL_TEMPLATE= 'CXE_CBG_RM_Notification';
    
    // CSM-12372  Vincent
    public static final String PrivacyLink_Address = 'http://www.meralco.com.ph/privacy-policy';

    // START CSM-12401 GGrandea 09.04.2017
    public static final String BILLS_HAS_TOOLTIP = 'has tool tip';
    public static final String BILLS_BILL_DEPOSIT = 'Bill Deposit';
    public static final String BILLS_FOR_BANK_PROCESSING = 'For bank processing';
    public static final String BILLS_COMPLAINT_1 = '1';
    public static final String BILLS_UNDER_INST_AGREE = 'Under Installment Agreement';
    public static final String BILLS_SERVICE_IRREG = 'Service Irregularity';
    public static final String BILLS_TRO_DUEDATE = '2888-12-31';
    // END CSM-12401 GGrandea 09.04.2017

    //START RReyes SEP-12-17 CSM-XXXXX
    public static final String STATUS_APPROVED = 'Approved';
    public static final String BPMODE_PAPERLESS = 'Paperless';
    //END RReyes SEP-12-17 CSM-XXXXX
    
    // CSM-12516 Mike Verdad 09/13/2017
    public static final String DUPLICATE_CONTACT = 'Portal User already exists for contact.';

    //CSM-12599 GGrandea 09.18.2017
    public static final String CASE_PAPERLESSBILLING_TYPE_SUB = 'Paperless Billing Subscription';
    public static final String CASE_PAPERLESSBILLING_TYPE_CANCEL = 'Paperless Billing Cancellation';

    // START CSM-13715 Jerome TO Added Code Segment 10/05/17
    public static final String SERVICE_CODE_SEGMENT_BSEGTYP001 = 'BSEGTYP001';
    public static final String SERVICE_CODE_SEGMENT_1 = '1';
    // END CSM-13715 Jerome TO Added Code Segment 10/05/17

    // START CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
    // HMB
    public static final String SERVICE_CODE_SEGMENT_BSEGTYP002 = 'BSEGTYP002';
    public static final String SERVICE_CODE_SEGMENT_2 = '2';
    // SME
    public static final String SERVICE_CODE_SEGMENT_BSEGTYP003 = 'BSEGTYP003';
    public static final String SERVICE_CODE_SEGMENT_3 = '3';
    // END CSM-13764 Jerome To Registration logic update for segment checking 10/09/2017
    public static final String CASE_STATUS_OPEN  = 'Open'; // CSM-13719 Corbes Melvin 10-10-2017
    public static final String CASE_STATUS_SUCCESSFUL  = 'Successful'; //CSM-13657 GGrandea 10.10.2017
    public static final String CASE_STATUS_REJECTED  = 'Rejected'; //CSM-13657 GGrandea 10.10.2017
    public static final String CASE_STATUS_DOCUMENT_RECEIVED = 'Document Received'; //CSM-14405 JFernandez 11/15/2017

    //START CSM-13657 GGrandea 10.10.2017
    public static final String EMAIL_TEMP_SUCCESS_PB_SUB_IDV  = 'CXE_SUCCESS_PAPERLESS_BILLING_SUB_INDV';
    public static final String EMAIL_TEMP_SUCCESS_PB_SUB_BIZ  = 'CXE_SUCCESS_PAPERLESS_BILL_SUB_BIZ_CBG';
    public static final String EMAIL_TEMP_FAILED_PB_SUB_IDV  = 'CXE_FAILED_PAPERLESS_BILLING_SUB_INDV';
    public static final String EMAIL_TEMP_FAILED_PB_SUB_BIZ  = 'CXE_FAILED_PAPERLESS_BILLING_SUB_BIZCBG';

    public static final String EMAIL_TEMP_SUCCESS_PB_CANCEL_IDV  = 'CXE_SUCCESS_PAPERLESS_BILL_CANCEL_INDV';
    public static final String EMAIL_TEMP_SUCCESS_PB_CANCEL_BIZ  = 'CXE_SUCCESS_PAPERLESS_BILLCANCEL_BIZCBG';
    public static final String EMAIL_TEMP_FAILED_PB_CANCEL_IDV  = 'CXE_FAILED_PAPERLESS_BILL_CANCEL_INDV';
    public static final String EMAIL_TEMP_FAILED_PB_CANCEL_BIZ  = 'CXE_FAILED_PAPERLESS_BILL_CANCEL_BIZCBG';

    public static final String EMAIL_TEMP_RENEWAL_PB_SUB_IDV  = 'CXE_SUCCESSPAPERLESSBILLRENEWALSUBCINDV';
    public static final String EMAIL_TEMP_RENEWAL_PB_SUB_BIZ  = 'CXE_SUCCESS_PB_RENEWALSUBC_BIZCBG';
    
    //END CSM-13657 GGrandea 10.10.2017
    
    //START CSM-13144/CSM-13234 RReyes OCT-13-17 
    public static final String QUEUE_PAYMENT_OPERATIONS  = 'CXE_Payment_Operations_Team';
    //END CSM-13144/CSM-13234 RReyes OCT-13-17
    
    public static final String HEROKU_BILL_TYPE_TFGEN10006  = 'Deposit';//CSM-14038 Melvin Corbes 10-21-2017    
    
    //START JFernandez NOV-2-2017
    //START CSM-13159
    public static final String EMAIL_TEMP_APA_ENROLLMENTREQUEST_IDV = 'CXE_APA_Enrollment_Request_Resi';
    public static final String EMAIL_TEMP_APA_ENROLLMENTREQUEST_BIZ = 'CXE_APA_Enrollment_Request_BIZ';
    public static final String EMAIL_TEMP_APA_ENROLLMENTREQUEST_CBG = 'CXE_APA_Enrollment_Request_CBG';
    //END CSM-13159
    
    //START CSM-13244
    public static final String EMAIL_TEMP_APA_CANCELLATIONREQUEST_IDV = 'CXE_APA_Cancellation_Request_RESI';
    public static final String EMAIL_TEMP_APA_CANCELLATIONREQUEST_BIZ = 'CXE_APA_Cancellation_Request_BIZ';
    public static final String EMAIL_TEMP_APA_CANCELLATIONREQUEST_CBG = 'CXE_APA_Cancellation_Request_CBG'; 
    //END CSM-13244
    
    //START CSM-13199
    public static final String CASE_STATUS_SUCCESS = 'Success';
    public static final String CASE_STATUS_FAILED = 'Failed';
    public static final String EMAIL_TEMP_FAILED_CANCELLATIONREQUEST_APA_IDV = 'CXE_Failed_APA_Enrollment_RESI';
    public static final String EMAIL_TEMP_FAILED_CANCELLATIONREQUEST_APA_BIZ = 'CXE_Failed_APA_Enrollment_BIZ';
    public static final String EMAIL_TEMP_FAILED_CANCELLATIONREQUEST_APA_CBG = 'CXE_Failed_APA_Enrollment_CBG';
    
    public static final String EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_IDV = 'CXE_Failed_APA_Enrollment_RESI';
    public static final String EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_BIZ = 'CXE_Failed_APA_Enrollment_BIZ';
    public static final String EMAIL_TEMP_FAILED_ENROLLMENTREQUEST_APA_CBG = 'CXE_Failed_APA_Enrollment_CBG';
    
    public static final String EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_IDV = 'CXE_Successful_APA_Cancellation_RESI';
    public static final String EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_BIZ = 'CXE_Successful_APA_Cancellation_BIZ';
    public static final String EMAIL_TEMP_SUCCESS_CANCELLATIONREQUEST_APA_CBG = 'CXE_Successful_APA_Cancellation_CBG';
    
    public static final String EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_IDV = 'CXE_Successful_APA_Enrollment_RESI';
    public static final String EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_BIZ = 'CXE_Successful_APA_Enrollment_BIZ';
    public static final String EMAIL_TEMP_SUCCESS_ENROLLMENTREQUEST_APA_CBG = 'CXE_Successful_APA_Enrollment_CBG';
    
    //END CSM-13199
    
    public static final String SERVICE_REQ_APA_ENROLLMENT = 'APA Enrollment';//START/END CSM-13159 Add new Service Request for APA Enrollment
    public static final String SERVICE_REQ_APA_CANCELLATION = 'APA Cancellation';//START/END CSM-13159 Add new Service Request for APA Enrollment
    
    
    //END JFernandez NOV-2-2017

    // START CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User
    public static final String PORTAL_COMMUNITY_PROFILE_CONGLOMERATE = 'Conglomerate Portal User';
    // END CSM-14414 Jerome To [R2C Regression] Portal user is allowed to generate a case on a service not related to his Account or Portal User

    // Start CSM-14504: Jayson Sarion 12/1/2017
    public static final String CHANGE_PW_ERROR_1 = 'You cannot reuse this old password';
    public static final String CHANGE_PW_ERROR_2 = 'The passwords do not match';
    public static final String CHANGE_PW_ERROR_3 = 'Your old password is invalid';
    public static final String CHANGE_PW_NEW_ERROR_1 = 'Please set a password that you haven' + '\'' + 't used before.';
    public static final String CHANGE_PW_NEW_ERROR_2 = 'Your confirmation password doesn' + '\'' + 't match your new password.';
    public static final String CHANGE_PW_NEW_ERROR_3 = 'Please enter your current password.';
    // End CSM-14504: Jayson Sarion 12/1/2017
    //Start CSM-14795: John Mark Fernandez 12/6/2017
    public static final String TASK_STATUS_COMPLETED = 'Completed';
    public static final String TASK_PRIORITY_NORMAL = 'Normal';
    //END CSM-14795: John Mark Fernandez 12/6/2017
    
    public static final String TASK_SUBJECT_PORTAL_DEACTIVATION = 'Meralco Customer Portal Account Deactivation';
    public static final String TASK_SUBJECT_PORTAL_INACTIVITY = 'Inactive Meralco Online Account'; //START/END CSM-14979 RReyes DEC-29-17
    
    //Start R2C CSM-14836 Von Pernicia 12/13/2017
    public static final String EMAIL_TEMP_BIZ_CUST_ENROLLMENT =  'CXE_BIZ_Customer_Enrollment';
    public static final String EMAIL_TEMP_BIZ_RM_ADD_SIN =  'CXE_BIZ_RM_Notification_Case_Add_SIN';
    public static final String EMAIL_TEMP_CASE_CREATION =  'CXE_Case_Creation';
    //End R2C CSM-14836 Von Pernicia 12/13/2017


    //Start R2C CSM-14807 Von Pernicia 12/29/2017
    public static final String EMAIL_TEMP_ADD_SIN_INDV =  'CXE_Add_SIN';
    public static final String EMAIL_TEMP_ADD_SIN_BIZ =  'CXE_Add_SIN_BIZ';
    public static final String EMAIL_TEMP_DELETE_SIN_INDV =  'CXE_Delete_SIN_INDV';
    public static final String EMAIL_TEMP_DELETE_SIN_BIZ =  'CXE_Delete_SIN_BIZ';
    //End R2C CSM-14807 Von Pernicia 12/29/2017

    //Start R2C CSM-14884 Von Pernicia 1/4/2018
    public static final String PAYMENT_ORIGIN_PORTAL = 'Portal';
    public static final String PAYMENT_ORIGIN_MOBILE = 'Mobile';
    //End R2C CSM-14884 Von Pernicia 1/4/2018
    //CSM-14884 - [R3A REGRESSION] Payment confirmation page for Mobile/Kiosk
}