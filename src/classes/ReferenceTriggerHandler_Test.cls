/* Description: ConnectionTriggerHandler test class
 * Author: Christian Peter Doctolero
 * Date Created: MAR-13-17
 */
@isTest
private class ReferenceTriggerHandler_Test {

    static testMethod void createReference() {
        List<Reference__c> referenceList = CXE_TestDataFactory.createReference(1, 'City');
        Reference__c referenceProvince = referenceList[0];
        
        insert referenceProvince;
        
        List<Reference__c> referenceList2 = CXE_TestDataFactory.createReference(1, 'Barangay');
        Reference__c referenceBarangay = referenceList2[0];
        
        insert referenceBarangay;
        
        List<Reference__c> referenceList3 = CXE_TestDataFactory.createReference(1, 'Subdivision');
        Reference__c referenceSubdivision = referenceList3[0];
        
        insert referenceSubdivision;
        
        
         List<Reference__c> referenceList4 = CXE_TestDataFactory.createReference(1, 'Street');
        Reference__c referenceStreet = referenceList4[0];
        
        insert referenceStreet;
        
        Reference__c refUpdate = [Select Name_Code__c from Reference__c where id=:referenceProvince.id];
        refUpdate.Name_Code__c = 'Sample Name Code';
        system.assertequals(refUpdate.Name_Code__c, 'Sample Name Code');
        
        update refUpdate;
        
        delete refUpdate;
        //system.assertequals(connUpdate.Meter_Status, null);
        
        undelete refUpdate;
    }
}