/* 
 * Description: Exception Handler
 * Author: Michael Lasala (Accenture)
 * Date Created: JAN-26-17
 */
public class ErrorHandlerException extends Exception {

    /* Public Properties */ 
    /* Static Variables */
    public static final String EXCEPTION_TYPE_GENERAL = 'General';
    public static final String EXCEPTION_TYPE_WEB_SERVICE = 'Web Service';
        
    /* Private Properties */ 
    /* Constructors */ 
    /* Public Methods */ 
    
    /*
     * Description: Method which creates and inserts Exception_Log__c records
     * Parameters: Record Id (Salesforce Id)
                   Type (General/Web Service)
                   Class Name
                   Method Name
                   Exception
     * Returns: Void
     * Author: Michael Lasala (Accenture)
     * Date Created: JAN-26-17
     */
    public static void recordException(Id recordId, 
                                       Boolean isGeneral, 
                                       String className, 
                                       String methodName, 
                                       String exceptionMessage){
        
        //Map parameters to new record
        Exception_Log__c exceptionLog = new Exception_Log__c(Salesforce_ID__c = recordId, 
                                                             Class_Name__c = className,
                                                             Method_Name__c = methodName, 
                                                             Exception__c = exceptionMessage);

        //Assign type based on parameter
        if(isGeneral) {
            exceptionLog.Type__c = EXCEPTION_TYPE_GENERAL;
        } else {
            exceptionLog.Type__c = EXCEPTION_TYPE_WEB_SERVICE;
        }
        
        //Insert exception log
        try {
            insert exceptionLog;
        } catch (DMLException error){
            System.debug('$$$ ErrorHandlerException.recordException error: '+error.getMessage());
        }
    }


    public static void recordException(Id recordId, 
                                       Boolean isGeneral, 
                                       String className, 
                                       String methodName, 
                                       Exception e){
        
        String exceptionMessage = UserInfo.getUserId() + ' : ' + e.getLineNumber() + ' --- ' + e.getMessage() + ' --- ' + e.getStackTraceString() + ' --- ' + e.getTypeName();

        recordException(recordId, isGeneral, className, methodName, exceptionMessage);
    }

    /* Private Methods */ 
    /* Inner classes and methods */ 
    /* Static initializers */ 
}