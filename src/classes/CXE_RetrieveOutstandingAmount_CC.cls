/* Description: CXE_RetrieveOutstandingAmount_CMP lightning component controller
 * Author: Von Pernicia
 * Date Created: JUN-06-17
 * Story: CSM-3808, CSM-3848, CSM-3771
 */
public with sharing class CXE_RetrieveOutstandingAmount_CC {

    @AuraEnabled
    public static String updateCase(String caseId){
        
		String dmlStatus = '';

		// Start CSM-12243 Von Pernicia AUG-23-17
		Id newServRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(CXE_Constants.CASE_NEW_SERVICE_APPLICATION).getRecordTypeId();

		Case cas = [SELECT  CXE_Previous_SIN__c,
		            		V10_Customer_No__c,
		            		RecordTypeId
		            FROM    Case 
		            WHERE   Id =: caseId LIMIT 1];   


		if (cas.RecordTypeId == newServRecTypeId)
		{
			return CXE_Constants.CASE_ERROR_RETRIEVED_OUTSTANDING;
		}
		// End CSM-12243 Von Pernicia AUG-23-17

		try {

			Integration_Settings__c integ = Integration_Settings__c.getValues('getArrears');
			String v10CustomerNo = '';

			Blob headerValue = Blob.valueOf(integ.Username__c + ':' + integ.Password__c);
			String authorizationHeader = EncodingUtil.base64Encode(headerValue);


			if (cas.V10_Customer_No__c != null)
			{
				v10CustomerNo = cas.V10_Customer_No__c;
			}

			JSONGenerator g = JSON.createGenerator(false);
			g.writeStartObject();          
			g.writeFieldName('ArrearsDepositRetrievalRequest');
			g.writeStartObject();
			g.writeStringField('customerNumber', v10CustomerNo);
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

			Map<String, Object> data = (Map<String, Object>)json.deserializeUntyped(res.getBody());
			Map<String, Object> dataCase =  (Map<String, Object>)data.get('ArrearsDepositRetrievalResponse'); 
			
			if (res.getStatus() == 'OK')
			{
				if (String.valueOf(dataCase.get('status')) == 'S')
				{
					try
					{
						Case c = new Case(id = caseId,
						         CXE_Total_Outstanding_Amount__c = Decimal.valueOf(String.valueOf(dataCase.get('totalOutstanding'))),
						         CXE_Existing_Bill_Deposit_Amount__c = Decimal.valueOf(String.valueOf(dataCase.get('existingBillDeposit'))),
						         Arrears_Tag__c = Decimal.valueOf(String.valueOf(dataCase.get('totalOutstanding'))) > 0 ? true : false,
						         //START CSM-12251 RReyes AUG-11-17
						         // Start CSM-12223 Von Pernicia
						         CXE_isRequireArrears__c = true
						         // End CSM-12223 Von Pernicia
						         //END CSM-12251 RReyes AUG-11-17
						         );

						CasetriggerHandler.isClickOutstandingAmount = true; //START/END CSM-12256 Von Pernicia AUG-16-17
						update c;
						dmlStatus = CXE_Constants.STATUS_SUCCESS;
					}
					catch (DMLException e)
					{
						dmlStatus = e.getdmlMessage(0);            
					}
				}
				else
				{
					dmlStatus = String.valueOf(dataCase.get('description'));            
				}
			}
		} catch (Exception error){
		    dmlStatus = error.getMessage();            
		    ErrorHandlerException.recordException(caseId, true, 'CXE_RetrieveOutstandingAmount_CC', 'updateCase', error.getMessage());
		}

		return dmlStatus;
	}
}