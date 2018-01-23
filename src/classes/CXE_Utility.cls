/* 
 * Description: CSM-610 - Controller class for CXE_CreateAccountOnCase_CMP Lightning Component
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-25-17
 */ 
public class CXE_Utility {

    //Begin CSM-973: Von Pernicia Feb-24-17
    /* 
     * Description: Pull the picklist value and code
     * Parameters: N/A
     * Returns: Picklist Value
     * Author: Von Pernicia (Accenture)
     * Date Created: FEB-25-17
    */  
    public static Map<String, String> picklistTransformationDesc(List<List<String>> arrayList) {
        
        Map<String, String> picklistTransCodeMapping = new Map<String, String>();
        List<String> sTypeList = new List<String>();
        
        for (Integer x = 0; x < arrayList.size(); x++)
        {
          sTypeList.add(arrayList[x][2]);
        }
        
        /*for (Picklist__c pct: 
            [Select 
            Name, 
            Code__c, 
            Type__c 
            from Picklist__c
            //where Type__c = 'Picklist'
            order by Type__c]) 
            {   
                picklistTransCodeMapping.put(pct.Code__c + pct.Type__c, pct.Name);
            }
        */
        for (Reference__c pct: 
            [Select 
            Name, 
            Name_Code__c, 
            Field__c 
            from Reference__c
            where Field__c in: sTypeList and Type__c = 'Picklist'
            order by Field__c]) 
            {   
                picklistTransCodeMapping.put(pct.Name_Code__c + pct.Field__c, pct.Name);
            }
        return picklistTransCodeMapping;
    }
/* 
 * Description: Pull the picklist value and code
 * Parameters: N/A
 * Returns: Picklist Code
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-25-17
*/    
    public static Map<String, String> picklistTransformationCode(List<List<String>> arrayList) {
        
        Map<String, String> picklistTransDescMapping = new Map<String, String>();
        List<String> sTypeList = new List<String>();
        
        for (Integer x = 0; x < arrayList.size(); x++)
        {
          sTypeList.add(arrayList[x][2]);
        }
        
        /*for (Picklist__c pct:
            [Select 
            Name, 
            Code__c, 
            Type__c 
            from Picklist__c
            //where Type__c = 'Picklist'
            order by Type__c]) 
            {   
                picklistTransDescMapping.put(pct.Name + pct.Type__c, pct.Code__c);
            }*/
        for (Reference__c pct: 
            [Select 
            Name, 
            Name_Code__c, 
            Field__c 
            from Reference__c
            where Field__c in: sTypeList and Type__c = 'Picklist'
            order by Field__c]) 
            {   
                picklistTransDescMapping.put(pct.Name + pct.Field__c, pct.Name_Code__c);
            }
        
        return picklistTransDescMapping;
    }
/* 
 * Description: Update the picklist value or code for an object
 * Parameters: objectNewMap, objectOldMap, Array Field of an object, List of Picklist Code, List of Picklist Description
 * Returns: Picklist Code
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-25-17
*/      
    public void picklistTransformationUpdate(Map<Id, SObject> objectMapping, Map<Id, SObject> objectOldMapping, List<List<String>> arrayList, Map<String, String> mapPicklistCode, Map<String, String> mapPicklistDesc) 
    {   
        for (SObject c: objectMapping.values())
        {   
            for (Integer x = 0; x < arrayList.size(); x++)
            {  
                //c.put(arrayList[x][0], mapPicklistCode.get(c.get(arrayList[x][1]) + arrayList[x][2]));
                // Update code base on picklist value
                if (c.get(arrayList[x][1]) != objectOldMapping.get(c.id).get(arrayList[x][1]))
                {
                    // Start CSM-7237: Von Pernicia Jun-20-17
                  if (arrayList[x][1] == 'CXE_Service_Request_s__c')
                    {
                        String concatValue = '';
                        String servReqValue = String.valueOf(c.get(arrayList[x][1]));
                        
                        if (servReqValue != null) // Check if CXE_Service_Request_s__c has value
                        {
                            String[] splitServReq = servReqValue.split(';');

                            for (String sr: splitServReq)
                            {
                                if (concatValue == '')
                                { 
                                    concatValue = mapPicklistCode.get(sr + arrayList[x][2]);
                                }
                                else
                                {
                                    concatValue += ';' + mapPicklistCode.get(sr + arrayList[x][2]);
                                }
                            }

                            c.put(arrayList[x][0], concatValue);
                        }
                    }
                    else
                    {
                        c.put(arrayList[x][0], mapPicklistCode.get(c.get(arrayList[x][1]) + arrayList[x][2]));
                    }
                    // Start CSM-7237: Von Pernicia Jun-20-17
                }
                
                // Update picklist value base on code
                else if (c.get(arrayList[x][0]) != objectOldMapping.get(c.id).get(arrayList[x][0]))
                {                    
                    // Start CSM-7237: Von Pernicia Jun-20-17
                    if (arrayList[x][0] == 'CXE_Code_Service_Request_s__c')
                    {
                        String concatValue = '';
                        String servReqValue = String.valueOf(c.get(arrayList[x][0]));

                        if (servReqValue != null)  // Check if CXE_Code_Service_Request_s__c has value
                        {
                            String[] splitServReq = servReqValue.split(';');

                            for (String sr: splitServReq)
                            {
                                if (concatValue == '')
                                { 
                                    concatValue = mapPicklistDesc.get(sr + arrayList[x][2]);
                                }
                                else
                                {
                                    concatValue += ';' + mapPicklistDesc.get(sr + arrayList[x][2]);
                                }
                            }

                            c.put(arrayList[x][1], concatValue);
                        }
                    }
                    else
                    {
                        c.put(arrayList[x][1], mapPicklistDesc.get(c.get(arrayList[x][0]) + arrayList[x][2]));
                    }
                    // Start CSM-7237: Von Pernicia Jun-20-17
                }
            }
        }
    } 
/* 
 * Description: Insert the picklist value or code for an object
 * Parameters: objectNewList Array Field of an object, List of Picklist Code, List of Picklist Description
 * Returns: Picklist Code
 * Author: Von Pernicia (Accenture)
 * Date Created: FEB-25-17
*/          
    public void picklistTransformationInsert(List<SObject> objectList, List<List<String>> arrayList, Map<String, String> mapPicklistCode, Map<String, String> mapPicklistDesc) 
    {   
        for (SObject c: objectList)
        {   
            for (Integer x = 0; x < arrayList.size(); x++)
            {
                // Update code base on picklist value
                if (c.get(arrayList[x][0]) == null)
            {
                  // Start CSM-7237: Von Pernicia Jun-20-17
                    if (arrayList[x][1] == 'CXE_Service_Request_s__c')
                    {
                        String concatValue = '';
                        String servReqValue = String.valueOf(c.get(arrayList[x][1]));

                        if (servReqValue != null)  // Check if CXE_Service_Request_s__c has value
                        {
                            String[] splitServReq = servReqValue.split(';');

                            for (String sr: splitServReq)
                            {
                                if (concatValue == '')
                                { 
                                    concatValue = mapPicklistCode.get(sr + arrayList[x][2]);
                                }
                                else
                                {
                                    concatValue += ';' + mapPicklistCode.get(sr + arrayList[x][2]);
                                }
                            }

                            c.put(arrayList[x][0], concatValue);
                        }
                    }
                    else
                    {
                        c.put(arrayList[x][0], mapPicklistCode.get(c.get(arrayList[x][1]) + arrayList[x][2]));
                    }
                    // Start CSM-7237: Von Pernicia Jun-20-17
            }
                
                // Update picklist value base on code
                if (c.get(arrayList[x][1]) == null)
            {
                  // Start CSM-7237: Von Pernicia Jun-20-17
                    if (arrayList[x][0] == 'CXE_Code_Service_Request_s__c')
                    {
                        String concatValue = '';
                        String servReqValue = String.valueOf(c.get(arrayList[x][0]));

                        if (servReqValue != null) // Check if CXE_Code_Service_Request_s__c has value
                        {
                            String[] splitServReq = servReqValue.split(';');

                            for (String sr: splitServReq)
                            {
                                if (concatValue == '')
                                { 
                                    concatValue = mapPicklistDesc.get(sr + arrayList[x][2]);
                                }
                                else
                                {
                                    concatValue += ';' + mapPicklistDesc.get(sr + arrayList[x][2]);
                                }
                            }

                            c.put(arrayList[x][1], concatValue);
                        }
                    }
                    else
                    {
                        c.put(arrayList[x][1], mapPicklistDesc.get(c.get(arrayList[x][0]) + arrayList[x][2]));
                    }
                    // Start CSM-7237: Von Pernicia Jun-20-17
            }
            }
        }
    } 
    
    public static Map<Id, String> getAddressCodeTransformation(Set<Id> proviceIdList)
    {
      Map<Id, String> addressMapping = new Map<Id, String>();
      String block = ''; 
      
      Reference__c r = [Select Block__c from Reference__c where Id =: proviceIdList];
      block = r.Block__c;
      
      for (Reference__c re: [Select Id,
            Name_Code__c
            from Reference__c
            where Block__c =: block])
      {
        addressMapping.put(re.Id, re.Name_Code__c);
      }
      
      return addressMapping;
    } 
    
    public static Map<String, Id> getAddressIdTransformation(Set<String> proviceCodeList)
    {
      Map<String, Id> addressMapping = new Map<String, Id>();
      String block = ''; 
      
      Reference__c r = [Select Block__c from Reference__c where Name_Code__c =: proviceCodeList];
      block = r.Block__c;
      
      for (Reference__c re: [Select Id,
            Name_Code__c
            from Reference__c
            where Block__c =: block])
      {
        addressMapping.put(re.Name_Code__c, re.Id);
      }
      
      return addressMapping;
    }  

//End CSM-973: Von Pernicia Feb-24-17
/* 
 * Description: Return Profile 
 * Parameters: String Name of Profile
 * Returns: Map of Id and Profile Name
 * Author: Jerson Poblete (Accenture)
 * Date Created: MAR-16-17
*/  
    public static Map<Id, String> getProfileIds (String profileNames)
    {
        Map<Id, String> newProfileMap = new Map<Id, String>();
        for(Profile p: [SELECT Id, Name FROM Profile WHERE  Name =: profileNames]){
           newProfileMap.put(p.Id, p.Name);
        }
        return newProfileMap;
    }

/* 
 * Description: HTTP callout 
 * Parameters: CXE_Wrapper_EXT.serviceObject
 * Returns: HttpResponse
 * Author: Von Pernicia (Accenture)
 * Date Created: MAY-25-17
*/  
    public HttpResponse doSend(CXE_Wrapper_EXT.serviceObject servObject)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(servObject.url);
        req.setMethod(servObject.method);
        req.setHeader('Content-Type', 'application/json');

        if (servObject.bearerTokenSessionId != '')
        {
            req.setHeader('Authorization', servObject.authtype + servObject.bearerTokenSessionId);    
        }        
        
        if(servObject.codeBlock != null )
        { 
            req.setBody(servObject.codeBlock);
        }
        
        HttpResponse res = new http().send(req);
        return res;
    }

    /* 
     * Description: CSM-6151 Check if user's profile is Admin
     * Parameters: none
     * Returns: Boolean
     * Author: Jerome To
     * Date Created: MAY-29-17
    */  
    public static Boolean isAdmin(){
        return ([SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name == CXE_Constants.PROFILE_NAME_SYSTEM_ADMINISTRATOR);
    }

    /* 
     * Description: Check if user's profile is Admin
     * Parameters: none
     * Returns: 
     * Author: Jerome To
     * Date Created: JUN-14-2017
    */  
    public static List<Case_State_Transition__c> getCaseTransitions(String referenceNumber, String lastName ){
        return ([Select Id, To_State__c, To_Date_Stamp__c, Case_Status__c, Case__c, Case__r.CaseNumber, Case__r.Account.Lastname 
                 FROM Case_State_Transition__c 
                 WHERE Case__r.CaseNumber = :referenceNumber 
                 AND Case__r.Account.Lastname =:lastName
                 ORDER BY To_Date_Stamp__c DESC]);
    }

    /* 
     * Description: View / Track Application Status by keying in a reference number
     * CSM-6740, CSM-7100
     * Parameters: Case, Map<String, Case_Status_Setting__mdt>
     * Returns: List<CXE_CaseHistoryWrapper>
     * Author: Jerome To
     * Date Created: JUN-17-2017
    */  
    public static List<CXE_CaseHistoryWrapper> getCaseStatusHistory(Case caseRecord, Map<String, Case_Status_Setting__mdt> statusJourneyMap){
        List<CXE_CaseHistoryWrapper> chwList = new List<CXE_CaseHistoryWrapper>();        
        Map<String, List<Field_Order__c>> fieldOrders = new Map<String, List<Field_Order__c>>();
        Map<String, Integer> foCounter = new Map<String, Integer>();
        
        for(Field_Order__c fo : [SELECT RecordType.DeveloperName, Schedule_Date__c 
                                  FROM Field_Order__c 
                                  WHERE Case__c =:caseRecord.Id
                                  AND Schedule_Date__c != NULL
                                  AND (RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_INSPECTION_FO OR 
                                       RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_METER_SOCKET_FO OR 
                                       RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_RE_INSPECTION_FO OR 
                                       RecordType.DeveloperName = :CXE_Constants.FIELD_ORDER_RECORD_TYPE_SURVEY_FO) 
                                  ORDER BY CreatedDate ASC]) {
            if(fieldOrders.containsKey(fo.RecordType.DeveloperName)) {
                List<Field_Order__c> foList = fieldOrders.get(fo.RecordType.DeveloperName);
                foList.add(fo);
                fieldOrders.put(fo.RecordType.DeveloperName, foList);
                Integer ctr = foCounter.get(fo.RecordType.DeveloperName);
                ctr += 1;             
                foCounter.put(fo.RecordType.DeveloperName, ctr);
            }
            else{
                fieldOrders.put(fo.RecordType.DeveloperName, new List<Field_Order__c> { fo });
                foCounter.put(fo.RecordType.DeveloperName, 1);
            }
        }
        for(CaseHistory ch :[Select Id, CaseId, Field, NewValue, OldValue, CreatedDate 
                             FROM CaseHistory 
                             WHERE Field ='Status'
                             AND CaseId = :caseRecord.Id
                             ORDER BY CreatedDate DESC]) {
            CXE_CaseHistoryWrapper chw = new CXE_CaseHistoryWrapper();
            chw.CaseId = ch.CaseId;
            chw.Field = ch.Field;
            chw.NewValue = ch.NewValue;
            chw.OldValue = ch.OldValue;
            chw.CreatedDate = ch.CreatedDate;
            if(statusJourneyMap.containsKey((String)ch.NewValue) && statusJourneyMap.get((String)ch.NewValue).Service_Application_Journey_Remarks__c != null){
                String remarks = statusJourneyMap.get((String)ch.NewValue).Service_Application_Journey_Remarks__c;   
                if(fieldOrders.containsKey(remarks)) {
                    Integer ctr = foCounter.get(remarks);
                    if(ctr == 0){
                        continue;
                    } else {
                        chw.Remarks = fieldOrders.get(remarks).get(ctr-1).Schedule_Date__c.format();
                        foCounter.put(remarks,ctr-1);
                    }
                }else {
                    chw.Remarks =  remarks;
                }          
            }
            chwList.add(chw);
        }

        return chwList;
    }

    /* Description: CSM-7223: Creation of Requirement records
     * Parameters: Set<String>, CaseID
     * Returns: N/A
     * Author: Von Pernica 
     * Date Created: JUL-03-17
    */
    public static List<Requirement__c> createRequirement(Set<String> listRequirement, Id CaseId, Set<String> createdRequirement){
        
        List<Requirement__c> createRequirement = new List<Requirement__c>();

        for (String reqType: listRequirement)
        {
            if (!createdRequirement.contains(caseId + reqType))
            {
                Requirement__c req = new Requirement__c(

                    Case__c = CaseId,
                    Requirement_Type__c = reqType
                    );
                createRequirement.add(req);
            }
        }

        return createRequirement;
    }

    /* Description: CSM-7223: Creation of Requirement records
     * Parameters: List<String>, CaseID
     * Returns: N/A
     * Author: Von Pernica 
     * Date Created: JUL-03-17
    */
    public static Set<String> createdRequirements(Set<String> listRequirement, Id CaseId){
        
        Set<String> createdRequirement = new Set<String>();

        for (String reqType: listRequirement)
        {
            createdRequirement.add(CaseId + reqType);
        }

        return createdRequirement;
    }

    public static String getSecureToken(){
        return aes128(
            Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss')
            , UserInfo.getOrganizationId().left(15) + '!'
        );
    }

    public static String aes128(String data, String vector_16){
        Blob encrypted = Crypto.encrypt(
            'AES128'
            , EncodingUtil.base64Decode('XxQ+q/DIHviL0Fb8i11CTA==')
            , Blob.valueOf(vector_16.left(16))
            , Blob.valueOf(data)
        );

        return EncodingUtil.base64Encode(encrypted);
    }


    public static Map<String, String> q(){
        return System.currentPageReference().getParameters();
    }

    public static String q(String name){
        return CXE_Utility.q().get(name);
    }

    public static List<String> my_account_number(){
        List<String> result = new List<String>();

        Id uid = UserInfo.getUserId();
        List<Agreement__c> service = [   
            select  Contract__r.V10_Account_No__c
            from    Agreement__c
            where   Id in (
                select  CXE_ServiceId__c from CXE_Service_Enrollment__c where CXE_UserId__c = :uid
            )
        ];

        for(Agreement__c e : service){
            if(e.Contract__r != null && e.Contract__r.V10_Account_No__c != null)
                result.add(e.Contract__r.V10_Account_No__c);
        }

        return result;
    }


    public static String json(Object obj){
        RestContext.response.addHeader('Content-Type', 'application/json');
        return JSON.serialize(obj);
    }
    
    public static Messaging.SingleEmailMessage emailNotif(List<String> emailAddresses, Boolean saveAsActivity,Id targetObjectId, Id whatId, Id orgWideEmailAddressId, Id templateId){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(emailAddresses);
        email.setSaveAsActivity(saveAsActivity);
        email.setTargetObjectId(targetObjectId);
        email.setWhatId(whatId);
        email.setorgWideEmailAddressId(orgWideEmailAddressId);
        email.setTemplateId(templateId);
        
        return email;
    }
    /* Description: CSM-14795: Creation of Task Record
     * Parameters: Date, String, String, OwnerId, String, String, WhatId, String, WhoId
     * Returns: N/A
     * Author: John Mark Fernandez
     * Date Created: DEC-20-17
    */
    public static Task taskCreation(Date activityDate, String notifChannel, String notifType, Id ownerId, String priority, String status, Id whatId, String subject, Id whoId){
        Task taskRec = new Task();
        taskRec.ActivityDate = activityDate;
        taskRec.Notification_Channel__c = notifChannel;
        taskRec.Notification_Type__c = notifType;
        taskRec.OwnerId = ownerId;
        taskRec.Priority = priority;
        taskRec.Status = status;
        taskRec.WhatId = whatId;
        taskRec.Subject = subject;
        
        if(whoId!=null){
            taskRec.WhoId = whoId;
        }
        
        
        return taskRec;
    }
    
    /* Description: CSM-14914: Return Email Template
     * Parameters: List<EmailTemplate>
     * Returns: N/A
     * Author: John Mark Fernandez
     * Date Created: DEC-20-17
    */
    public static List<EmailTemplate> emailTemplateQuery(List<String> devName){
        
        List<EmailTemplate> et = [Select Id, Subject, DeveloperName from EmailTemplate where DeveloperName in: devName];
        
        return et;
    }
}