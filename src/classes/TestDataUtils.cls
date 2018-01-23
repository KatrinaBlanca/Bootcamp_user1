@isTest
public class TestDataUtils {
       
    public testmethod static Case getTestCase(){
        //Case cs = new Case();
        List<Case> testCaseList = CXE_TestDataFactory.createCase(1, 'New Electric Service,', 'Single Meter', 'Application Received', 'Private');
        Case cs = testCaseList.get(0);
        cs.Last_Name_Business_Name__c = 'Test';
        insert cs;
        return cs;
    }
    
    public testmethod  static List<Schedule__c> getTestBillSchedules(){

        for (Integer i = 1; i <= 6; i++) {

            string scheduleName = 'S-'+ i;
        	Schedule__c schd = new Schedule__c();
            schd.Schedule_Selector__c  = scheduleName;
        	schd.Residential_Rate__c = 100 * i;
        	schd.Non_Residential_Rate__c = 1000 * i;
        	insert schd;
        }
        List<Schedule__c> allSchedules =   [select id, Name , Non_Residential_Rate__c , Residential_Rate__c, Schedule_Selector__c 
                                                                from Schedule__c ];
        return allSchedules;
    }
}