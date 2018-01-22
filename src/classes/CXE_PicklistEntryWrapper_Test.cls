@isTest
public class CXE_PicklistEntryWrapper_Test {
    
    @isTest static void  CXE_PicklistEntryWrapperTest(){
        CXE_PicklistEntryWrapper cpw = new CXE_PicklistEntryWrapper();
        Test.startTest();
        
        cpw.active ='True';
        cpw.defaultValue ='false';
        cpw.label ='label';
        cpw.value ='value';
        cpw.validFor ='valid for';
        Test.stopTest();
        
      System.assert(cpw!=null);
        
    }   



}