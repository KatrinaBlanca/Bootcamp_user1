public without sharing class CXE_CP_BillPrintModeIntegrationUtility { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    //START CSM-12954 GGrandea 09.26.2017 - code disabled
    /*public static void printmodeUpdateRequest(List<Contract> contractPassed , String updateType){
        
        Set<Id> contractIds = new Set<Id>();
        Map<String, String> bpmMap = new Map<String, String>();
        
        for(Contract conRec: contractPassed)
        {
            contractIds.add(conRec.Id);
            if(updateType == CXE_Constants.BPM_PAPERPLUS){
                bpmMap.put(conRec.Id, CXE_Constants.BPM_PAPERPLUS);
            }
            if(updateType == CXE_Constants.BPM_PAPER){
                bpmMap.put(conRec.Id, CXE_Constants.BPM_PAPER);
            }
            if(updateType == CXE_Constants.BPM_PAPERLESS){
                bpmMap.put(conRec.Id, CXE_Constants.BPM_PAPERLESS);
            }
            
        }
        system.debug('here1' + contractIds);
        system.debug('here2' + bpmMap);
        CXE_CP_BillPrintModeIntegrationUtility.printmodeUpdateRequestBulk(contractIds,bpmMap);
    }
    
    public static void printmodeUpdateRequestBulk(Set<Id> contractIds, Map<String, String> bpmMap){
        Map<String, Contract> contractMap = new Map<String, Contract>();
        Map<String, String> bpmContractMap = new Map<String, String>();
        
        if (contractIds != null)
        {
            for (Contract con: [SELECT  Bill_Print_Mode__c,
                                Contract_External_ID__c,
                                CXE_PaperlessBIllingCancelEffective__c,
                                CXE_PaperlessBIllingEnrollment_Effective__c,
                                CXE_Enrolled_to_Paperless_Billing__c,
                                Id
                                FROM    Contract
                                WHERE   Id in: contractIds])
            {
                contractMap.put(con.Contract_External_ID__c, con);
                bpmContractMap.put(con.Contract_External_ID__c, bpmMap.get(con.id));
            }
            
            if (!contractMap.keySet().isEmpty())
            {
                CXE_CP_BillPrintModeIntegrationUtility.updateContract(contractMap, bpmContractMap);
            }
        }
        
    }*/
    //END CSM-12954 GGrandea 09.26.2017 - code disabled
    
    public static void updateContract(Map<String,Contract> contractMap, Map<String, String> bpmContractMap){

        List<Contract> contractRecords = new List<Contract>();

        //CSM-13052 GGrandea 10.03.2017 - added try/catch block
        try{ 
        Integration_Settings__c integ = Integration_Settings__c.getValues('updateBillPrintMode');
        
        Blob headerValue = Blob.valueOf(integ.Username__c + ':' + integ.Password__c);
        String authorizationHeader = EncodingUtil.base64Encode(headerValue);
        
        JSONGenerator g = JSON.createGenerator(false);
        g.writeStartObject();          
        g.writeFieldName('BillPrintModeUpdateRequest');
        g.writeStartObject();
        g.writeFieldName('billPrintAccountList');
        g.writeStartObject();
        for (String conExternalId: contractMap.keySet())
        {
            g.writeFieldName('billPrintAccount');
            g.writeStartObject();
            g.writeStringField('billPrintMode', bpmContractMap.get(conExternalId));
            g.writeStringField('idPaymentForm', contractMap.get(conExternalId).Contract_External_ID__c);
            g.writeEndObject();
            
        }
        g.writeEndObject();
        
        CXE_Wrapper_EXT.serviceObject serObject = new CXE_Wrapper_EXT.serviceObject();
        serObject.url = integ.Endpoint__c; 
        serObject.method = 'POST';
        serObject.authtype = 'Basic ';
        serObject.bearerTokenSessionId = authorizationHeader;
        serObject.codeBlock = g.getAsString();
        
        CXE_Utility util = new CXE_Utility();
        HttpResponse res = util.doSend(serObject);
        Map<String, Object> data = (Map<String, Object>)json.deserializeUntyped(res.getBody());
        Map<String, Object> dataBillPrintRespond = (Map<String, Object>)data.get('BillPrintModeUpdateResponse');
        Map<String, Object> dataRespondList = (Map<String, Object>)dataBillPrintRespond.get('bpmResponseList');

        if(dataRespondList.get('bpmResponseItem') instanceof List<object>){
            //MULTIPLE
            List<Object> dataRespondItem = (List<Object>)dataRespondList.get('bpmResponseItem');
            for (Object resp: dataRespondItem)
            {   
                String sResp = JSON.serialize(resp);
                CXE_Wrapper_EXT.BillPrintModeWrapper bpmWrapper = (CXE_Wrapper_EXT.BillPrintModeWrapper) System.JSON.deserialize(sResp, CXE_Wrapper_EXT.BillPrintModeWrapper.class);               
                if (bpmWrapper.response == 'S'){
                    contractRecords.add(updateContractFields(bpmWrapper, contractMap, bpmContractMap));
                }else{
                        //START CSM-13052 GGrandea 10.03.2017
                        contractRecords.add(updateContractOnlyNewBPMfield(  bpmWrapper.idPaymentForm
                                                                            , contractMap
                                                                            , bpmContractMap));
                        //END CSM-13052 GGrandea 10.03.2017
                    ErrorHandlerException.recordException(null, true, 'CXE_CP_BillPrintModeIntegrationUtility', 'updateContract(multiple)', bpmWrapper.description);
                }
            }
        }else{
            //SINGLE
            String sResp = JSON.serialize(dataRespondList.get('bpmResponseItem'));
            CXE_Wrapper_EXT.BillPrintModeWrapper bpmWrapper = (CXE_Wrapper_EXT.BillPrintModeWrapper) System.JSON.deserialize(sResp, CXE_Wrapper_EXT.BillPrintModeWrapper.class);
            
            if (bpmWrapper.response == 'S'){
                contractRecords.add(updateContractFields(bpmWrapper, contractMap, bpmContractMap));
            }else{
                    //START CSM-13052 GGrandea 10.03.2017
                    contractRecords.add(updateContractOnlyNewBPMfield(  bpmWrapper.idPaymentForm
                                                                        , contractMap
                                                                        , bpmContractMap));
                    //END CSM-13052 GGrandea 10.03.2017
                ErrorHandlerException.recordException(null, true, 'CXE_CP_BillPrintModeIntegrationUtility', 'updateContract(single)', bpmWrapper.description);
            }
        }

            //START CSM-13052 GGrandea 10.03.2017 - transferred DML code to end of function
            //if (contractRecords <> null)
            //{
            //    update(contractRecords);
            //}
            //END CSM-13052 GGrandea 10.03.2017
        }
        catch(Exception ex){
            contractRecords.clear();
            for (String conExternalId: contractMap.keySet()){
                contractRecords.add(updateContractOnlyNewBPMfield(  conExternalId
                                                                    , contractMap
                                                                    , bpmContractMap));
            }
            ErrorHandlerException.recordException(null, true, 'CXE_CP_BillPrintModeIntegrationUtility', 'updateContract(main)', ex.getMessage());
        }

        //START CSM-13052 GGrandea 10.03.2017 - transferred DML code to end of function
        try{
            update contractRecords;
        }catch(Exception ex){
            ErrorHandlerException.recordException(null, true, 'CXE_CP_BillPrintModeIntegrationUtility', 'updateContract(DML)', ex.getMessage());
        }
        //END CSM-13052 GGrandea 10.03.2017
    }

    public static Contract updateContractFields(CXE_Wrapper_EXT.BillPrintModeWrapper bpmWrapper, 
                                            Map<String,Contract> contractMap, 
                                            Map<String, String> bpmContractMap){

        Contract con = contractMap.get(bpmWrapper.idPaymentForm);
        con.Bill_Print_Mode__c = bpmContractMap.get(bpmWrapper.idPaymentForm);
        con.New_Bill_Print_Mode__c = bpmContractMap.get(bpmWrapper.idPaymentForm); //CSM-13052 GGrandea 10.03.2017
        Date dt;
        if (bpmWrapper.description != '')
        {
            Integer bYear = Integer.valueOf(String.valueOf(bpmWrapper.description).substring(0,4));
            Integer bMonth = Integer.valueOf(String.valueOf(bpmWrapper.description).substring(5,7));
            Integer bDay = Integer.valueOf(String.valueOf(bpmWrapper.description).substring(8,10));
            dt = Date.newinstance(bYear, bMonth, bDay);
        }     
        
        
        if (bpmContractMap.get(bpmWrapper.idPaymentForm) == CXE_Constants.BPM_PAPERLESS)
        {
            con.CXE_PaperlessBIllingEnrollment_Effective__c = dt;
            con.CXE_Enrolled_to_Paperless_Billing__c = true;
        }
        else
        {
            // START LISEN 2017-09-21 --> fix for CSM-12876 only set CXE_PaperlessBIllingCancelEffective__c if it has ever been enrolled once (CXE_PaperlessBIllingEnrollment_Effective__c is not empty)
            if(con.CXE_PaperlessBIllingEnrollment_Effective__c != null){
                con.CXE_PaperlessBIllingCancelEffective__c = dt;
            }
            // END
            con.CXE_Enrolled_to_Paperless_Billing__c = false;
        }
        return con;
    }
    /* Description: CSM-13052 - for failed integration, system still needs to update New_Bill_Print_Mode__c
    * Parameters: String conExtId, Map<String,Contract> contractMap, Map<String, String> bpmContractMap
    * Returns: Contract
    * Author: Gavi Grandea 
    * Date Created: OCT-3-17
    */    
    public static Contract updateContractOnlyNewBPMfield(String conExtId, 
                                            Map<String,Contract> contractMap, 
                                            Map<String, String> bpmContractMap){

        Contract con = contractMap.get(conExtId);
        con.New_Bill_Print_Mode__c = bpmContractMap.get(conExtId);
        return con;
    }
    
    
    /* Description: CSM-12954 - non-asynchronous call to update Bill Print Mode of Contract record
    * Parameters: Set<Id> contractIds, Map<String, String> bpmMap
    * Returns: Void
    * Author: Gavi Grandea 
    * Date Created: SEPT-26-17
    */    
    /*@future(callout=true) //CSM-13005 GGrandea 09.27.2017 - change to non-future*/ 
                            //CSM-13009 GGrandea 09.27.2017 - change back to future method */ 
    @future(callout=true)
    public static void relateServiceAddress(Set<Id> contractIds, Map<String, String> bpmMap){
        
        //List<Contract> contractRecords = new List<Contract>();
        Map<String, Contract> contractMap = new Map<String, Contract>();
        Map<String, String> bpmContractMap = new Map<String, String>();
        
        if (contractIds != null)
        {
            for (Contract con: [SELECT  Bill_Print_Mode__c,
                                Contract_External_ID__c,
                                CXE_PaperlessBIllingCancelEffective__c,
                                CXE_PaperlessBIllingEnrollment_Effective__c,
                                CXE_Enrolled_to_Paperless_Billing__c,
                                Id
                                FROM    Contract
                                WHERE   Id in: contractIds])
            {
                contractMap.put(con.Contract_External_ID__c, con);
                bpmContractMap.put(con.Contract_External_ID__c, bpmMap.get(con.id));
            }
            
            if (!contractMap.keySet().isEmpty())
            {
                //Vincent MAndolado CXE_CP_V10IntergrationUtility
                CXE_CP_BillPrintModeIntegrationUtility.updateContract(contractMap, bpmContractMap);
                 
            }
        }
    }
    
    
    /* Description: CSM-12954 - asynchronous call to update Bill Print Mode of Contract record
                                Update of Case Cancellation Reason can be done thru this method
    * Parameters: Set<Id> contractIds, Map<String, String> bpmMap, Map<Id, String> bpReasonMap
    * Returns: Void
    * Author: Gavi Grandea 
    * Date Created: SEPT-26-17
    */    
    @future(callout=true)
    public static void relateServiceAddress(Set<Id> contractIds, Map<String, String> bpmMap, Map<Id, String> bpReasonMap){
        
        //List<Contract> contractRecords = new List<Contract>();
        Map<String, Contract> contractMap = new Map<String, Contract>();
        Map<String, String> bpmContractMap = new Map<String, String>();
        
        if (contractIds != null)
        {
            for (Contract con: [SELECT  Bill_Print_Mode__c,
                                Contract_External_ID__c,
                                CXE_PaperlessBIllingCancelEffective__c,
                                CXE_PaperlessBIllingEnrollment_Effective__c,
                                CXE_Enrolled_to_Paperless_Billing__c,
                                Id
                                FROM    Contract
                                WHERE   Id in: contractIds])
            {
                //check cancellation reason and set to Contract record
                if(bpReasonMap!=null && bpReasonMap.containsKey(con.id)){
                    con.CXE_ReasonsforCancellationPaperlessBill__c = bpReasonMap.get(con.id);
                }
                contractMap.put(con.Contract_External_ID__c, con);
                bpmContractMap.put(con.Contract_External_ID__c, bpmMap.get(con.id));
            }
            
            if (!contractMap.keySet().isEmpty())
            {
                //Vincent MAndolado CXE_CP_V10IntergrationUtility
                CXE_CP_BillPrintModeIntegrationUtility.updateContract(contractMap, bpmContractMap);
                 
            }
        }
    }
}