/* Description: CXE_RetrieveTerminatedService_CMP lightning component controller
 * Author: Von Pernicia
 * Date Created: JUN-08-17
 * Story: CSM-6929
 */
public with sharing class CXE_RetrieveTerminatedService_CC {

    @AuraEnabled
    public static String updateCase(String caseId)
    {
        
      Id recontractRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();

      String caseAddress = '';
      String accountId = '';
      String dmlStatus = '';
      Agreement__c serviceRecord;

      CaseTriggerHandler.isRetrieveService = true; //Start/End CSM-11428 Von Pernicia JUL-12-17

      Case cas = [SELECT  Id,
                          CXE_Previous_SIN__c,
                          Application_for_Business_Customer__c,
                          CXE_Service_Address__c,
                          CXE_isServiceRetrieved__c,
                          Service_Address_Landmarks_Directions__c,
                          Last_Name_Business_Name__c,
                          Doing_Business_As__c,
                          Code_Salutation__c,
                          First_Name__c,
                          Last_Name__c,
                          Middle_Name__c,
                          Date_of_Birth__c,
                          Email_Address__c,
                          Code_Customer_Type__c,
                          Conglomerate_Tag__c,
                          Tax_Identification_No__c,
                          Service_Description__c,
                          Code_Business_Segment__c,
                          Applied_Load__c,
                          Code_Phase__c,
                          Code_Voltage__c,
                          Code_PSIC__c,
                          Demand_Factor__c,
                          Load_Factor__c,
                          Contracted_Capacity__c,
                          Code_Service_Rate_Type__c,
                          Code_Billing_Class__c,
                          CXE_Discount_Programs__c,
                          CXE_Rate_Programs__c,
                          Code_Service_Supply_Type__c,
                          Code_Metering_Scheme__c,
                          Code_Mode_of_Retrieval__c,
                          CXE_Code_Service_Wire_Phase__c,
                          CXE_Code_Service_Wire_Voltage__c,
                          Code_Service_Wire_Type__c,
                          TLN__c,
                          Pole_Code__c,
                          Service_Wire_Length__c,
                          Code_Wire_Size__c,
                          Code_Material__c,
                          CXE_Termination_Date_of_SIN__c,
                          CXE_Is_Required_to_Click_Retrieve_Button__c, // CSM-7104 JEROME TO   06/26/2017
                          CXE_Code_Rate_Programs__c,
                          AccountId,
                          Billing_Address_Landmarks_Directions__c 
                  FROM    Case 
                  WHERE   Id =: caseId LIMIT 1];

      // Validate if the SIN is already retrieved
      if (cas.CXE_isServiceRetrieved__c)
      {
        return CXE_Constants.CASE_ERROR_ALREADY_RETRIEVED;
      }
      //START CSM-7138 RReyes JUN-23-17 - Validate if case has previous SIN
      if(cas.CXE_Previous_SIN__c == null || cas.CXE_Previous_SIN__c == ''){
        return CXE_Constants.CASE_ERROR_NO_PREVIOUS_SIN;
      }
      //END CSM-7138 RReyes JUN-23-17 - Validate if case has previous SIN

      //START CSM-12224 Von Pernicia AUG-07-17: Logic has been moved to case trigger
      /*
      // Check if SIN already used for another Recontract record type
      for (Case checkReconCase: [SELECT   Id,
                                          Status
                                 FROM     Case
                                 WHERE    CXE_Previous_SIN__c =: cas.CXE_Previous_SIN__c 
                                 AND      Status <>: CXE_Constants.CASE_APPLICATION_CANCELLED
                                 AND      RecordTypeId =: recontractRecTypeId
                                 AND      Id <> : cas.Id])
      {

        if (checkReconCase.Status == CXE_Constants.CASE_APPLICATION_CLOSED)
        {
          return CXE_Constants.CASE_ERROR_SIN_ALREADY_RECONTRACTED; // Recontract where status is Application Closed
        }
        else
        {
          return CXE_Constants.CASE_MODIFICATION_ERROR_DUPLICATE_OR_PENDING_CASE_EXIST; // Recontract where status is still intransit
        }
      } 
      */   
      //End CSM-12224 Von Pernicia AUG-07-17: Logic has been moved to case trigger
      // End CSM-7049: Von Pernicia


      for (Agreement__c ser: [SELECT  Id,
                                      SIN__c,
                                      // Start CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
                                      Agreement_End_Date__c, 
                                      // End CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
                                      Service_Description__c,
                                      Code_Segment__c,
                                      Applied_Load__c,
                                      Code_Phase__c,
                                      Code_Voltage_Level__c,
                                      Code_PSIC__c,
                                      Demand_Factor__c,
                                      Load_Factor__c,
                                      Contracted_Capacity__c,
                                      Code_Service_Rate_Type__c ,
                                      Code_Billing_Class__c,
                                      CXE_Discount_Program__c,
                                      Rate_Program__c,
                                      Code_Service_Supply_Type__c,
                                      Code_Service_Wire_Phase__c,
                                      Code_Service_Wire_Voltage__c,
                                      Code_Service_Wire_Type__c,
                                      Service_Wire_TLN__c,
                                      Service_Wire_Pole_Number__c,
                                      Service_Wire_Length__c,
                                      Code_Service_Wire_Size__c,
                                      Code_Service_Wire_Material__c,
                                      Case__c,
                                      Account__r.Name,
                                      Account__r.Doing_Business_As__c,
                                      Account__r.Code_Salutation__c,
                                      Account__r.FirstName,
                                      Account__r.LastName,
                                      Account__r.MiddleName,
                                      Account__r.PersonBirthdate,
                                      Account__r.Email__c,
                                      Account__r.PersonEmail,
                                      Account__r.Code_Customer_Type__c,
                                      Account__r.Conglomerate__c,
                                      Account__r.Tax_Identification_No__c,
                                      Service_Status__c
                                      //START CSM-7138 RReyes JUN-23-17 - additional fields for mapping
                                      ,Segment__c, 
                                      Phase__c, 
                                      Service_Supply_Voltage__c, 
                                      PSIC__c, 
                                      Billing_Class__c, 
                                      Rate__c, 
                                      Account__r.Customer_Type__c,
                                      Service_Supply_Phase__c,
                                      Service_Supply_Type__c,
                                      Service_Wire_Phase__c,
                                      Service_Wire_Voltage__c,
                                      Service_Wire_Type__c,
                                      Service_Wire_Size__c,
                                      Service_Wire_Material__c,
                                      Deposit_Schedule__c,
                                      Deposit_Amount__c,
                                      Account__c,
                                      Account__r.RecordType.DeveloperName,
                                      Account__r.Mobile_Phone__c,
                                      //START CSM-11451 RReyes JUL-17-17
                                      //Account__r.PersonMobilePhone,
                                      Account__r.PersonHomePhone,
                                      Account__r.Mobile_1__pc,
                                      //END CSM-11451 RReyes JUL-17-17
                                      Case__r.Application_for_Business_Customer__c,
                                      Case__r.Application_for_Business_Service__c,
                                      Case__r.Application_for_Residential_Customer__c,
                                      Case__r.Application_for_Residential_Service__c,
                                      Case__r.Mode_of_Retrieval__c,
                                      Case__r.Metering_Scheme__c,
                                      Case__r.Initial_Responsible_Office__c,
                                      Case__r.Responsible_Office_Lookup__c,
                                      //END CSM-7138 RReyes JUN-23-17 - additional fields for mapping
                                      Account__r.Phone, //START/END CSM-7182 RReyes - JUN-28-17
                                      //START CSM-7331 RReyes JUL-09-17
                                      Case__r.Code_Metering_Scheme__c,
                                      Case__r.Code_Mode_of_Retrieval__c
                                      //END CSM-7331 RReyes JUL-09-17
                              FROM    Agreement__c
                              WHERE   SIN__c =: cas.CXE_Previous_SIN__c LIMIT 1])
      {
        serviceRecord = new Agreement__c();
        serviceRecord = ser;
      }

      if (serviceRecord != null)
      {
        dmlStatus = retrieveFromCXE(cas, serviceRecord);
      }
      else
      {
        dmlStatus = callout(cas, cas.CXE_Previous_SIN__c);
      }

      return dmlStatus;
    }

    public static String retrieveFromCXE(Case cas, Agreement__c serRecord)
    {
    
      String dmlStatus = CXE_Constants.STATUS_SUCCESS;  
      Boolean chkAddress = false;
	  //START CSM-13988 Clarissa Capagas OCT-24-17
	  Set<String> invalidStatus;
      invalidStatus = CXE_Constants.SERVICE_STATUS_PENDING_TERMINATED;
      System.debug('>> invalidStatus: ' + invalidStatus);
      //END CSM-13988 Clarissa Capagas OCT-24-17        

      try
      {
        // Check if SIN already used for another Recontract record type
        // Start CSM-7049 Von Pernicia
        //Check if the Previous SIN is aleady terminated
        
        //START OCT-19-17 CSM-13988 RACHELLE ALFORJA Check if the Previous SIN is already terminated or pending to terminate   || serRecord.Service_Status__c != CXE_Constants.SERVICE_STATUS_PENDING_TO_TERMINATE 
        //if (serRecord.Service_Status__c != CXE_Constants.SERVICE_STATUS_TERMINATED)
        //{
          //return CXE_Constants.CASE_ERROR_ONLY_TERMINATED; 
        //} 
        //END OCT-19-17 CSM-13988 RACHELLE ALFORJA Check if the Previous SIN is already terminated or pending to terminate 
		
        //START CSM-13988 Clarissa Capagas OCT-24-17
        System.debug('>> serRecord.Service_Status__c: ' + serRecord.Service_Status__c);        
        if (!invalidStatus.contains(serRecord.Service_Status__c))
        {
          System.debug('>> inside invalidstatus cond: ');                  
          return CXE_Constants.CASE_ERROR_ONLY_TERMINATED;
        }
        //END CSM-13988 Clarissa Capagas OCT-24-17
          
        // Retrieve address from previous SIN and concatinate the address
        Address__c add = [SELECT  Address_Province__r.Name,
                                Address_City_Municipality__r.Name,
                                Address_Barangay__r.Name,
                                Address_Subdivision__r.Name,
                                Address_Street_Name__r.Name,
                                Address_Unit_No__c,
                                Address_Street_No__c,
                                Landmarks_Directions__c,
                                Address_Province__c,
                                Address_City_Municipality__c,
                                Address_Barangay__c,
                                Address_Subdivision__c,
                                Address_Street_Name__c,
                                Code_Premises_Type__c
                               //START CSM-7138 RReyes - added mapping of premise type on Address
                               ,Premise_Type__c
                               //END CSM-7138 RReyes - added mapping of premise type on Address
                        FROM    Address__c
                        WHERE   Service__c =: serRecord.Id];
        //START CSM-7180/CSM-7198 RReyes JUN-28-17
        String caseAddress, barangay, city, province, streetName, streetNo, subdivision, unitNo;
        unitNo = add.Address_Unit_No__c != null ? add.Address_Unit_No__c : '';
        streetNo = add.Address_Street_No__c != null ? add.Address_Street_No__c : '';
        streetName = add.Address_Street_Name__r.Name != null ? add.Address_Street_Name__r.Name : '';
        subdivision = add.Address_Subdivision__r.Name != null ? add.Address_Subdivision__r.Name : '';
        barangay = add.Address_Barangay__r.Name != null ? add.Address_Barangay__r.Name : '';
        city = add.Address_City_Municipality__r.Name != null ? add.Address_City_Municipality__r.Name : '';
        province = add.Address_Province__r.Name != null ? add.Address_Province__r.Name : '';
            
        caseAddress = unitNo + ' ' + streetNo + ' ' + streetName + ' ' +  subdivision + ' ' + barangay + ' ' + city + ' ' + province;
        //END CSM-7180/CSM-7198 RReyes JUN-28-17

        // Start CSM-12180 Von Pernicia AUG-03-17
        // Update Case
        if(add.Address_Street_Name__c <> null){

          Office_Jurisdiction__c oj = getResponsibleOffice(add.Address_Street_Name__c);
          if (oj <> null)
          {
            cas.Initial_Responsible_Office__c = oj.Office__r.Name;
            cas.Responsible_Office_Lookup__c = oj.Office__c;
          }
        }
        
        // End CSM-12180 Von Pernicia AUG-03-17
        cas.AccountId = serRecord.Account__c;
        cas.CXE_Service_Address_R2__c = caseAddress;
        
        // Start CSM-12215 Von Pernicia
        if (cas.Application_for_Business_Customer__c)
        {
          cas.Last_Name_Business_Name__c = serRecord.Account__r.Name;  
          cas.Doing_Business_As__c = serRecord.Account__r.Doing_Business_As__c;
        }
        else
        {
          cas.Code_Salutation__c = serRecord.Account__r.Code_Salutation__c;
          cas.First_Name__c = serRecord.Account__r.FirstName;
          cas.Last_Name__c = serRecord.Account__r.LastName;
          cas.Middle_Name__c = serRecord.Account__r.MiddleName;
        }
        // End CSM-12215 Von Pernicia

        /* Start CSM-12215 Von Pernicia
        //cas.Doing_Business_As__c = serRecord.Account__r.Doing_Business_As__c;
        //cas.Code_Salutation__c = serRecord.Account__r.Code_Salutation__c;
        //cas.First_Name__c = serRecord.Account__r.FirstName;
        //cas.Last_Name__c = serRecord.Account__r.LastName;
        //cas.Middle_Name__c = serRecord.Account__r.MiddleName;
        End CSM-12215 Von Pernicia*/
        cas.Date_of_Birth__c = serRecord.Account__r.PersonBirthdate;
        cas.Email_Address__c = cas.Application_for_Business_Customer__c ? serRecord.Account__r.Email__c : serRecord.Account__r.PersonEmail;
        cas.Code_Customer_Type__c = serRecord.Account__r.Code_Customer_Type__c;
        cas.Conglomerate_Tag__c = serRecord.Account__r.Conglomerate__c;
        cas.Tax_Identification_No__c = serRecord.Account__r.Tax_Identification_No__c;
        cas.Service_Description__c = serRecord.Service_Description__c;
        cas.Code_Business_Segment__c = serRecord.Code_Segment__c;
        cas.Applied_Load__c = serRecord.Applied_Load__c;
        cas.Code_Phase__c = serRecord.Code_Phase__c;
        cas.Code_Voltage__c = serRecord.Code_Voltage_Level__c;
        cas.Code_PSIC__c = serRecord.Code_PSIC__c;
        cas.Demand_Factor__c = serRecord.Demand_Factor__c;
        cas.Load_Factor__c = serRecord.Load_Factor__c;
        cas.Contracted_Capacity__c = serRecord.Contracted_Capacity__c;
        //START CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
        if(cas.Contracted_Capacity__c != null){
            cas.Contracted_Capacity__c = cas.Contracted_Capacity__c.setScale(3);
        }
        //END CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
        cas.Code_Service_Rate_Type__c = serRecord.Code_Service_Rate_Type__c;
        cas.CXE_Orig_Code_Service_Rate_Type__c = serRecord.Code_Service_Rate_Type__c; //START/END CSM-12252 on Pernicia AUG-12-17
        cas.Code_Billing_Class__c = serRecord.Code_Billing_Class__c;
        cas.CXE_Discount_Programs__c = serRecord.CXE_Discount_Program__c;
        cas.CXE_Rate_Programs__c = serRecord.Rate_Program__c;
        cas.Code_Service_Supply_Type__c = serRecord.Code_Service_Supply_Type__c;
        //START CSM-7331 RReyes JUL-09-17 - pull from service's case
        cas.Code_Metering_Scheme__c = serRecord.Case__r.Code_Metering_Scheme__c;
        cas.Code_Mode_of_Retrieval__c = serRecord.Case__r.Code_Mode_of_Retrieval__c;
        //END CSM-7331 RReyes JUL-09-17 - pull from service's case
        cas.CXE_Code_Service_Wire_Phase__c = serRecord.Code_Service_Wire_Phase__c;
        cas.CXE_Code_Service_Wire_Voltage__c = serRecord.Code_Service_Wire_Voltage__c;
        cas.Code_Service_Wire_Type__c = serRecord.Code_Service_Wire_Type__c;
        cas.TLN__c = serRecord.Service_Wire_TLN__c;
        cas.Pole_Code__c = serRecord.Service_Wire_Pole_Number__c;
        cas.Service_Wire_Length__c = serRecord.Service_Wire_Length__c;
        cas.Code_Wire_Size__c = serRecord.Code_Service_Wire_Size__c;
        cas.Code_Material__c = serRecord.Code_Service_Wire_Material__c;
        // Start CSM-7334 Von Pernicia Change from Service_Termination_Date__c to Agreement_End_Date__c
        cas.CXE_Termination_Date_of_SIN__c = serRecord.Agreement_End_Date__c; 
        // Start CSM-7334 Von Pernicia Service_Termination_Date__c to Agreement_End_Date__c
        //START CSM-7138 RReyes JUN-23-17 - additional fields for mapping
        cas.CXE_Service_Address_R2__c = caseAddress;
        cas.Business_Segment__c = serRecord.Segment__c;
        cas.Phase__c = serRecord.Phase__c;
        cas.Voltage__c = serRecord.Service_Supply_Voltage__c;
        cas.PSIC__c = serRecord.PSIC__c;
        cas.Billing_Class__c = serRecord.Billing_Class__c;   
        cas.Service_Rate_Type__c = serRecord.Rate__c;
        cas.Customer_Type__c = serRecord.Account__r.Customer_Type__c;
        cas.Billing_Address_Landmarks_Directions__c  = add.Landmarks_Directions__c;
        // Start CSM-12265 Von Pernicia
        //cas.CXE_Service_Supply_Phase__c = serRecord.Service_Supply_Phase__c;
        cas.Phase__c = serRecord.Service_Supply_Phase__c;
        // End CSM-12265 Von Pernicia
        cas.Service_Supply_Type__c = serRecord.Service_Supply_Type__c;
        cas.CXE_Service_Wire_Phase__c = serRecord.Service_Wire_Phase__c;
        cas.CXE_Service_Wire_Voltage__c = serRecord.Service_Wire_Voltage__c;
        cas.Service_Wire_Type__c = serRecord.Service_Wire_Type__c;
        cas.Wire_Size__c = serRecord.Service_Wire_Size__c;
        cas.Material__c = serRecord.Service_Wire_Material__c;
        cas.Bill_Deposit_Schedule__c = serRecord.Deposit_Schedule__c;
        cas.CXE_Existing_Bill_Deposit_Amount__c = serRecord.Deposit_Amount__c;
        //START CSM-7182 RReyes JUN-28-17
        cas.CXE_Service_Status_Text__c = serRecord.Service_Status__c;
        //cas.Telephone_No__c = serRecord.Account__r.Phone;//START/END CSM-11451 Commented Out by RReyes JUL-17-17
        //END CSM-7182 RReyes JUN-28-17
        cas.CXE_Is_Required_to_Click_Retrieve_Button__c = false; // CSM-7104 JEROME TO   06/26/2017
        cas.CXE_isServiceRetrieved__c = true;
        // Start CSM-12269 Von Pernicia
        if(serRecord.Case__c != null){
            cas.Application_for_Business_Customer__c = serRecord.Case__r.Application_for_Business_Customer__c;
            //cas.Application_for_Business_Service__c = serRecord.Case__r.Application_for_Business_Service__c;
            cas.Application_for_Residential_Customer__c = serRecord.Case__r.Application_for_Residential_Customer__c;
            //cas.Application_for_Residential_Service__c = serRecord.Case__r.Application_for_Residential_Service__c;
            cas.Mode_of_Retrieval__c = serRecord.Case__r.Mode_of_Retrieval__c;
            cas.Metering_Scheme__c = serRecord.Case__r.Metering_Scheme__c;
        }

        if (serRecord.Rate__c == CXE_Constants.SERVICE_RATE_TYPE_RES)
        {
            cas.Application_for_Business_Service__c = false;
            cas.Application_for_Residential_Service__c = true;
        }
        else
        {
            cas.Application_for_Business_Service__c = true;
            cas.Application_for_Residential_Service__c = false;
        }
        // End CSM-12269 Von Pernicia

        if(serRecord.Account__c != null){
            if(serRecord.Account__r.RecordType.DeveloperName == CXE_Constants.ACCOUNT_RECORD_TYPE_CXE_BUSINESS_ACCOUNT){
              //START CSM-11451 RReyes JUL-17-17
              /* Start CSM-12155 Von Pernicia AUG-03-17
              cas.Telephone_No__c = serRecord.Account__r.Phone;
              //END CSM-11451 RReyes JUL-17-17
              cas.Mobile_No__c = serRecord.Account__r.Mobile_Phone__c;
              eND CSM-12155 Von Pernicia AUG-03-17 */
              cas.Email_Address__c = serRecord.Account__r.Email__c;
            }else if(serRecord.Account__r.RecordType.DeveloperName == CXE_Constants.ACCOUNT_RECORD_TYPE_CXE_INDIVIDUAL_ACCOUNT){
              //START CSM-11451 RReyes JUL-17-17
              /* Start CSM-12155 Von Pernicia AUG-03-17
              cas.Telephone_No__c = serRecord.Account__r.PersonHomePhone;
              cas.Mobile_No__c = serRecord.Account__r.Mobile_1__pc;
              End CSM-12155 Von Pernicia AUG-03-17 */
              //END CSM-11451 RReyes JUL-17-17
              cas.Email_Address__c = serRecord.Account__r.PersonEmail;
            }
        }
        //END CSM-7138 RReyes JUN-23-17 - additional fields for mapping
            
            
        // Check if the new has sevice address
        for (Address__c addRecord : [SELECT Id
                  FROM   Address__c
                  WHERE   Case__c =: cas.Id 
                  AND   Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE LIMIT 1])
        {
          chkAddress = true;
        }

        // If case has no service address, create new
        try
        {
          update cas; // CSM-14885 Mike Verdad 12/18/2017
          
          if (!chkAddress)
          {
            Address__c a = new Address__C(
            Type__c = CXE_Constants.ADDRESS_TYPE_SERVICE,
            Address_Unit_No__c = add.Address_Unit_No__c,
            Address_Street_No__c = add.Address_Street_No__c,
            Address_Barangay__c = add.Address_Barangay__c,
            Address_City_Municipality__c = add.Address_City_Municipality__c,
            Address_Province__c = add.Address_Province__c,
            Address_Subdivision__c = add.Address_Subdivision__c,
            Address_Street_Name__c = add.Address_Street_Name__c,
            Landmarks_Directions__c = add.Landmarks_Directions__c,
            Code_Premises_Type__c = add.Code_Premises_Type__c,
            Case__c = cas.Id,
            Premise_Type__c = add.Premise_Type__c //START/END CSM-7138 RReyes - added mapping of premise type on Address
            ,Account__c = serRecord.Account__c //START/END CSM-11446 RReyes - relate service account to service address
            );
            insert a;
          }
        
          //update cas; //START/END RReyes - move case update on end of all checks [CSM-14885 Mike Verdad 12/18/2017, relocated before "if (!chkAddress)"]
        }
        catch (DMLException e)
        {
          dmlStatus = e.getdmlMessage(0).Replace('&quot;','"');
        } 
      } catch (Exception error) {

        //cas.CXE_isServiceRetrieved__c = false;
        //cas.CXE_Is_Required_to_Click_Retrieve_Button__c = true;
        //update cas;
        dmlStatus = error.getMessage();            
        ErrorHandlerException.recordException(cas.Id, true, 'CXE_RetrieveTerminatedService_CC', 'retrieveFromCXE', error.getMessage());
      }

      return dmlStatus;
    }

    public static String callout(Case cas, String prevSIN)
    {

      String dmlStatus = CXE_Constants.STATUS_SUCCESS;  
      Boolean chkAddress = false;
      String intialResponsibleOffice;
      Id officeID;
      Id addressId;
      Id accountId;

      Integration_Settings__c integ = Integration_Settings__c.getValues('retrieveTerminatedService');

      Blob headerValue = Blob.valueOf(integ.Username__c + ':' + integ.Password__c);
      String authorizationHeader = EncodingUtil.base64Encode(headerValue);

      JSONGenerator g = JSON.createGenerator(false);
      g.writeStartObject();          
      g.writeFieldName('GetServiceDetailsRequest');
      g.writeStartObject();
      g.writeStringField('SIN', cas.CXE_Previous_SIN__c);
      g.writeEndObject();

      CXE_Wrapper_EXT.serviceObject serObject = new CXE_Wrapper_EXT.serviceObject();
      serObject.url = integ.Endpoint__c; 
      serObject.method = 'POST';
      serObject.authtype = 'Basic ';
      serObject.bearerTokenSessionId = authorizationHeader;
      serObject.codeBlock = g.getAsString();

      CXE_Utility util = new CXE_Utility();
      HttpResponse res = util.doSend(serObject);
      System.debug('>> rr res: ' + res);
      Map<String, Object> data = (Map<String, Object>)json.deserializeUntyped(res.getBody());
      System.debug('>> rr data: ' + data);
      Map<String, Object> dataServiceDetail = (Map<String, Object>)data.get('GetServiceDetailsResponse');
      System.debug('>> rr dataServiceDetail: ' + dataServiceDetail);
      Map<String, Object> dataAddress = (Map<String, Object>)dataServiceDetail.get('address');
      System.debug('>> rr dataAddress: ' + dataAddress);

      if (res.getStatus() == 'OK')
      {
        try 
        {
          if (String.valueOf(dataServiceDetail.get('status')) == 'S')
          {
            // Check if the new has sevice address
            for (Address__c addRecord : [SELECT Id
                          FROM   Address__c
                          WHERE   Case__c =: cas.Id 
                          AND   Type__c =: CXE_Constants.ADDRESS_TYPE_SERVICE LIMIT 1])
            {
            chkAddress = true;
            addressId = addRecord.Id;
            }

            //START CSM-11446 RReyes - move up to include account in mapping
            //Get Account ID
            for (Account acc: [SELECT   Id
                       FROM   Account
                       WHERE  V10_Customer_No__c =: String.valueOf(dataServiceDetail.get('customerNumber')) LIMIT 1
                       ])
            {
              accountId = acc.Id;
            }
            //END CSM-11446 RReyes - move up to include account in mapping

            if (!chkAddress)
            {
              Address__c a = new Address__C(Type__c = CXE_Constants.ADDRESS_TYPE_SERVICE,
                      Address_Unit_No__c = String.valueOf(dataAddress.get('unitNo')),
                      Address_Street_No__c = String.valueOf(dataAddress.get('streetNo')),
                      Code_Address_Barangay__c = String.valueOf(dataAddress.get('barangayCd')),
                      Code_Address_City_Municipality__c = String.valueOf(dataAddress.get('cityMunicipalCd')),
                      Code_Address_Province__c = String.valueOf(dataAddress.get('provinceCd')),
                      Code_Address_Subdivision__c = String.valueOf(dataAddress.get('subdivisionCd')),
                      Code_Address_Street_Name__c = String.valueOf(dataAddress.get('streetNameCd')),
                      Landmarks_Directions__c = String.valueOf(dataServiceDetail.get('landmarksDirection')),
                      Code_Premises_Type__c = String.valueOf(dataAddress.get('premiseTypeCd'))
                      );
              //START CSM-11446 RReyes JUL-14-17 - include account in mapping
              if(accountId != null){
                  a.Account__c = accountId;
              }
              //END CSM-11446 RReyes JUL-14-17 - include account in mapping

              insert a;
              addressId = a.Id;
            }

            // Address Concatination 
            Address__c add = [SELECT Address_Province__r.Name,
                                     Address_City_Municipality__r.Name,
                                     Address_Barangay__r.Name,
                                     Address_Subdivision__r.Name,
                                     Address_Street_Name__r.Name,
                                     Address_Unit_No__c,
                                     Address_Street_Name__c, // Start CSM-12180 Von Pernicia AUG-03-17
                                     Address_Street_No__c                                     
                              FROM   Address__c
                              WHERE  Id =: addressId LIMIT 1];
            //START CSM-7180/CSM-7198 RReyes JUN-28-17
            String unitNo, streetNo, barangay, city, province, streetName, subdivision;
            unitNo = add.Address_Unit_No__c != null ? add.Address_Unit_No__c : '';
            streetNo = add.Address_Street_No__c != null ? add.Address_Street_No__c : '';
            streetName = add.Address_Street_Name__r.Name != null ? add.Address_Street_Name__r.Name : '';
            subdivision = add.Address_Subdivision__r.Name != null ? add.Address_Subdivision__r.Name : '';
            barangay = add.Address_Barangay__r.Name != null ? add.Address_Barangay__r.Name : '';
            city = add.Address_City_Municipality__r.Name != null ? add.Address_City_Municipality__r.Name : '';
            province = add.Address_Province__r.Name != null ? add.Address_Province__r.Name : '';

            String caseAddress = unitNo + ' ';
            caseAddress += streetNo  + ' ';
            caseAddress += streetName  + ' ';
            caseAddress += subdivision  + ' ';
            caseAddress += barangay  + ' ';
            caseAddress += city  + ' ';
            caseAddress += province  + ' ';
            //END CSM-7180/CSM-7198 RReyes JUN-28-17
            
            //START CSM-11446 RReyes - Commented Out -  move up to include account in mapping
            //Get Account ID
            /*for (Account acc: [SELECT   Id
                       FROM   Account
                       WHERE  V10_Customer_No__c =: String.valueOf(dataServiceDetail.get('customerNumber')) LIMIT 1
                       ])
            {
              accountId = acc.Id;
            }*/
            //END CSM-11446 RReyes - Commented Out - move up to include account in mapping

            // Birthday
            Date birthDay;
            if (String.valueOf(dataServiceDetail.get('birthDate')) != '')
            {
              Integer bYear = Integer.valueOf(String.valueOf(dataServiceDetail.get('birthDate')).substring(0,4));
              Integer bMonth = Integer.valueOf(String.valueOf(dataServiceDetail.get('birthDate')).substring(5,7));
              Integer bDay = Integer.valueOf(String.valueOf(dataServiceDetail.get('birthDate')).substring(8,10));
              birthDay = Date.newinstance(bYear, bMonth, bDay);
            }              

            // SIN Termination Date
            Date terminationDate;
            if (String.valueOf(dataServiceDetail.get('terminationDate')) != '')
            {
              Integer tYear = Integer.valueOf(String.valueOf(dataServiceDetail.get('terminationDate')).substring(0,4));
              Integer tMonth = Integer.valueOf(String.valueOf(dataServiceDetail.get('terminationDate')).substring(5,7));
              Integer tDay = Integer.valueOf(String.valueOf(dataServiceDetail.get('terminationDate')).substring(8,10));
              terminationDate = Date.newinstance(tYear, tMonth, tDay);
            }

            // Start CSM-12180 Von Pernicia AUG-03-17
            //Start CSM-11452 Von Pernicia
            // Retrieve Responsible Office
            /*if (String.valueOf(dataServiceDetail.get('responsibleTeam')) != null)
            {
              for (Office__c o: [SELECT   Id,
                                          Name
                                 FROM     Office__c
                                 WHERE    CMSv10_Office_Code__c =: String.valueOf(dataServiceDetail.get('responsibleTeam')) ])
              {
                intialResponsibleOffice = o.Name;
                officeID = o.Id;
              }
            }

            cas.Initial_Responsible_Office__c = intialResponsibleOffice;
            cas.Responsible_Office_Lookup__c = officeID;
            */

            if(add.Address_Street_Name__c <> null){

              Office_Jurisdiction__c oj = getResponsibleOffice(add.Address_Street_Name__c);
              if (oj <> null)
              {
                cas.Initial_Responsible_Office__c = oj.Office__r.Name;
                cas.Responsible_Office_Lookup__c = oj.Office__c;
              }
            }
            //End CSM-11452 Von Pernicia
            // End CSM-12180 Von Pernicia AUG-03-17

            cas.AccountID = accountId;
            cas.CXE_Service_Address_R2__c = caseAddress;
            cas.Billing_Address_Landmarks_Directions__c = String.valueOf(dataServiceDetail.get('landmarksDirection'));
            // Start CSM-12215 Von Pernicia
            if (Boolean.valueOf(dataServiceDetail.get('isForBusinessCustomer')))
            {
              cas.Doing_Business_As__c = String.valueOf(dataServiceDetail.get('doingBusinessAs'));
              cas.Last_Name_Business_Name__c = String.valueOf(dataServiceDetail.get('name'));
            }
            else
            {
              cas.First_Name__c = String.valueOf(dataServiceDetail.get('firstName'));
              cas.Last_Name__c = String.valueOf(dataServiceDetail.get('lastName'));
              cas.Middle_Name__c = String.valueOf(dataServiceDetail.get('middleName'));
              cas.Code_Salutation__c = String.valueOf(dataServiceDetail.get('customerTitle'));
            }
            // End CSM-12215 Von Pernicia

            // Start CSM-12215 Von Pernicia
            //cas.Doing_Business_As__c = String.valueOf(dataServiceDetail.get('doingBusinessAs'));
            //cas.First_Name__c = String.valueOf(dataServiceDetail.get('firstName'));
            //cas.Last_Name__c = String.valueOf(dataServiceDetail.get('lastName'));
            //cas.Middle_Name__c = String.valueOf(dataServiceDetail.get('middleName'));
            // End CSM-12215 Von Pernicia
            if (birthDay != null)
            {
              cas.Date_of_Birth__c = birthDay;  
            }
            cas.Email_Address__c = String.valueOf(dataServiceDetail.get('emailAddress'));
            cas.Code_Customer_Type__c = String.valueOf(dataServiceDetail.get('customerTypeCd'));
            cas.Conglomerate_Tag__c = Boolean.valueOf(dataServiceDetail.get('isConglomerate'));
            cas.Tax_Identification_No__c = String.valueOf(dataServiceDetail.get('taxIdNumber'));
            cas.Service_Description__c = String.valueOf(dataServiceDetail.get('serviceDescription'));
            cas.Code_Business_Segment__c = String.valueOf(dataServiceDetail.get('businessSegmentCd'));
            cas.Applied_Load__c = Decimal.valueOf(String.valueOf(dataServiceDetail.get('appliedLoad')));
            cas.Code_Phase__c = String.valueOf(dataServiceDetail.get('phaseCd'));
            cas.Code_Voltage__c = String.valueOf(dataServiceDetail.get('voltageCd'));
            cas.Code_PSIC__c = String.valueOf(dataServiceDetail.get('psicCd'));
            cas.Demand_Factor__c = Decimal.valueOf(String.valueOf(dataServiceDetail.get('demandFactor')));
            cas.Load_Factor__c = Decimal.valueOf(String.valueOf(dataServiceDetail.get('loadFactor')));
            cas.Contracted_Capacity__c = Decimal.valueOf(String.valueOf(dataServiceDetail.get('contractedCapacity')));
            //START CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
            if(cas.Contracted_Capacity__c != null){
                cas.Contracted_Capacity__c = cas.Contracted_Capacity__c.setScale(3);
            }
            //END CSM-11925 RReyes JUL-23-17 - round off contracted capacity to 3 decimal places
            cas.Code_Service_Rate_Type__c = String.valueOf(dataServiceDetail.get('serviceRateTypeCd'));
            cas.CXE_Orig_Code_Service_Rate_Type__c = String.valueOf(dataServiceDetail.get('serviceRateTypeCd')); //START/END CSM-12252 on Pernicia AUG-12-17
            cas.Code_Billing_Class__c = Integer.valueOf(dataServiceDetail.get('billingClassCd'));
            cas.CXE_Discount_Programs__c = String.valueOf(dataServiceDetail.get('discountProgram'));
            cas.CXE_Code_Rate_Programs__c = String.valueOf(dataServiceDetail.get('rateProgram'));
            cas.Code_Service_Supply_Type__c = String.valueOf(dataServiceDetail.get('supplyTypeCd'));
            cas.Code_Metering_Scheme__c = String.valueOf(dataServiceDetail.get('meteringSchemeCd'));
            cas.Code_Mode_of_Retrieval__c = String.valueOf(dataServiceDetail.get('retrievalModeCd'));
            cas.CXE_Code_Service_Wire_Phase__c = String.valueOf(dataServiceDetail.get('serviceWirePhaseCd'));
            cas.CXE_Code_Service_Wire_Voltage__c = String.valueOf(dataServiceDetail.get('serviceWireVoltageCd'));
            cas.Code_Service_Wire_Type__c = String.valueOf(dataServiceDetail.get('serviceWireType'));
            cas.TLN__c = String.valueOf(dataServiceDetail.get('tln'));
            cas.Pole_Code__c = String.valueOf(dataServiceDetail.get('poleNumber'));
            cas.Service_Wire_Length__c = Integer.valueOf(dataServiceDetail.get('serviceWireLength'));
            cas.Code_Wire_Size__c = String.valueOf(dataServiceDetail.get('serviceWireSizeCd'));
            cas.Code_Material__c = String.valueOf(dataServiceDetail.get('materialCd'));
            if (terminationDate != null)
            {
              cas.CXE_Termination_Date_of_SIN__c = terminationDate;
            }

            //START CSM-12269 RReyes AUG-18-17 - map checkboxes based on service rate type
            if(cas.Code_Service_Rate_Type__c == '141TYSERRA'){
                cas.Application_for_Business_Service__c = false;
                cas.Application_for_Residential_Service__c = true;
            }else{
                cas.Application_for_Business_Service__c = true;
                cas.Application_for_Residential_Service__c = false;
            }
            //END CSM-12269 RReyes AUG-18-17 - map checkboxes based on service rate type

            cas.CXE_isServiceRetrieved__c = true;
            cas.CXE_Is_Required_to_Click_Retrieve_Button__c = false; // CSM-7104 JEROME TO   06/26/2017
            cas.CXE_Service_Status_Text__c = 'Terminated';//START/END CSM-7182 RReyes JUN-28-17
            
            try
            {
              update cas;
             
              //Relate Address record to Case
              add.Case__c = cas.Id;
              update add;
            }
            catch (DMLException e)
            {
              dmlStatus = e.getdmlMessage(0).Replace('&quot;','"'); 
            }
          }
          else
          {
            //cas.CXE_isServiceRetrieved__c = true;
            //cas.CXE_Is_Required_to_Click_Retrieve_Button__c = false;
            //update cas;
            dmlStatus = String.valueOf(dataServiceDetail.get('description'));          
            //ErrorHandlerException.recordException(cas.Id, true, 'CXE_RetrieveTerminatedService_CC', 'callout', String.valueOf(dataServiceDetail.get('description')));
          }

        } catch (Exception error){
          
          //cas.CXE_isServiceRetrieved__c = false;
          //cas.CXE_Is_Required_to_Click_Retrieve_Button__c = true;
          //update cas;
          //system.assertequals(error.getMessage() ,null);
          dmlStatus = error.getMessage();            
          ErrorHandlerException.recordException(cas.Id, true, 'CXE_RetrieveTerminatedService_CC', 'callout', error.getMessage());
        }
      }

      return dmlStatus;
    }
    
    //START CSM-7116 - method to validate if status is valid for service retrieval
    @AuraEnabled
    public static String validateCaseStatus(String caseId){
        Id recontractRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_RECONTRACT_OF_ELECTRIC_SERVICE).getRecordTypeId();
        String status = '';
        if(caseId != null){
            Case c = [SELECT Status, RecordTypeId FROM Case WHERE Id=:caseId];
            if(c != null){
                if(c.RecordTypeId == recontractRecTypeId){
                    if(CXE_Constants.CASE_STATUS_BEFORE_APPLICATION_EVALUATED.contains(c.Status)){
                        status = 'Success';
                    }else{
                        status = 'You cannot retrieve service if status is already Application Evaluated or beyond.';
                    }
                }else{
                    status = 'You can only retrieve service on recontract cases.';
                }
            }
        }else{
            status = 'Invalid Case Id.';
        }
        return status;
    }
    //END CSM-7116 - method to validate if status is valid for service retrieval

    public static Office_Jurisdiction__c getResponsibleOffice(String streetName)
    {

      Office_Jurisdiction__c officeJ;

      for (Office_Jurisdiction__c oj: [SELECT     Office__c,
                                                  Office__r.Name,
                                                  Street_Name__c
                                       FROM       Office_Jurisdiction__c
                                       WHERE      Street_Name__c =: streetName])
      {
          officeJ = oj;
      }

      return officeJ;
    }
}