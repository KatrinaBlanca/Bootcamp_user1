/* Description: ConnectionTriggerHandler test class
 * Author: Christian Peter Doctolero
 * Date Created: MAR-10-17
 */
@isTest
private class ConnectionTriggerHandler_Test {

    static testMethod void createConnection() {
        List<Connection__c> connectionList = CXE_TestDataFactory.createConnection(1);
        Connection__c connectionRecord = connectionList[0];
        
        insert connectionRecord;
        
        Connection__c connUpdate = [Select Meter_Status__c from Connection__c where id=:connectionRecord.id];
        connUpdate.Meter_Status__c = 'Active';
        system.assertequals(connUpdate.Meter_Status__c, 'Active');
        
        update connUpdate;
        
        delete connUpdate;
        //system.assertequals(connUpdate.Meter_Status, null);
        
        undelete connUpdate;
    }
}