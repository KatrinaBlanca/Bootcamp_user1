@isTest
private class ErrorHandlerException_Test
{
	static testMethod void recordExceptionTrue()
	{
	    ErrorHandlerException.recordException(null, true, 'AddressTriggerHandler', 'populateCaseResponsibleOffice', 'sample');

	
	}

	static testMethod void recordExceptionFalse()
	{
		ErrorHandlerException.recordException(null, false, 'AddressTriggerHandler', 'populateCaseResponsibleOffice', 'sample');
	}

	public class OtherException extends Exception {}

	static testMethod void recordException()
	{
		try{
			throw new OtherException('This is bad');
		}catch(Exception ex){
			ErrorHandlerException.recordException(null, true, 'AddressTriggerHandler', 'populateCaseResponsibleOffice', ex);
		}
		
	}
}