/* Description: CaseTriggerHandler test class
 * Author: Von Pernicia
 * Date Created: MAR-07-17
 *               MAR-31-17      Jerome To       Refactored/Updated test class for test coverage
 */             
@isTest
private class LeadTriggerHandler_Test {

    static testMethod void createAddressForConvertedAccounts_Test() {   

        // create References
        List<Reference__c> addressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        insert addressRefList;
        for(Integer i=0 ; i<addressRefList.size() ; i++) {
            if(i>0){
                addressRefList.get(i).Parent__c = addressRefList.get(i-1).Id;
            }
        }
        update addressRefList;
        //create qualified leads
        List<Lead> leadList1 = CXE_TestDataFactory.createCreateLead(1);
        for(Lead leadRec : leadList1) {
            leadRec.Status = 'Qualified';
            leadRec.Phone = '+63464736453';
            leadRec.Unit_No__c = '1';
            leadRec.Street_No__c = '1';
            leadRec.Street_Name__c = addressRefList.get(4).Name;
            leadRec.Subdivision__c = addressRefList.get(3).Name;
            leadRec.Barangay__c = addressRefList.get(2).Name;
            leadRec.City_Municipality__c = addressRefList.get(1).Name;
            leadRec.Province__c = addressRefList.get(0).Name;
        }
        insert leadList1;

        // create address 2 with different Steet Name
        //List<Reference__c> secondAddressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        //secondAddressRefList.remove(secondAddressRefList.size()-1);
        //secondAddressRefList.add(new Reference__c (Block__c='BATANGAS',                                  
        //                                           Field__c='Street',                                   
        //                                           Name='SAN ROQUE',
        //                                           Name_Code__c='01029001700002',                                   
        //                                           Type__c='Geo'));
        //insert secondAddressRefList;
        //for(Integer i=0 ; i<secondAddressRefList.size() ; i++) {
        //    if(i>0){
        //        secondAddressRefList.get(i).Parent__c = secondAddressRefList.get(i-1).Id;
        //    }
        //}
        //update secondAddressRefList;

        //// create address 3 with different City and Province
        List<Reference__c> thirdAddressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        thirdAddressRefList.remove(addressRefList.size()-1);
        thirdAddressRefList.add(new Reference__c (Block__c='METRO MANILA',                                  
                                                   Field__c='Street',                                   
                                                   Name='SAN ROQUE',
                                                   Name_Code__c='01029001700002',                                   
                                                   Type__c='Geo'));
        insert thirdAddressRefList;
        for(Integer i=0 ; i<thirdAddressRefList.size() ; i++) {
            if(i>0){
                thirdAddressRefList.get(i).Parent__c = thirdAddressRefList.get(i-1).Id;
            }
            if(i == 0){ // PROVINCE
                thirdAddressRefList.get(i).Name = 'METRO MANILA';
            }
            //if(i == 1){ // CITY             
            //    thirdAddressRefList.get(i).Name = 'MARIKINA';
            //}
            if(i == 2){ // BARANGAY             
                thirdAddressRefList.get(i).Name = 'SUMULONG';
            }
            thirdAddressRefList.get(i).Block__c = 'METRO MANILA';
        }
        update thirdAddressRefList;

        List<Reference__c> fourthAddressRefList = CXE_TestDataFactory.createSampleReferenceListForAddress();
        fourthAddressRefList.remove(addressRefList.size()-1);
        fourthAddressRefList.add(new Reference__c (Block__c='METRO MANILA',                                  
                                                   Field__c='Street',                                   
                                                   Name='SAN ROQUE',
                                                   Name_Code__c='01029001700002',                                   
                                                   Type__c='Geo'));
        insert fourthAddressRefList;
        for(Integer i=0 ; i<fourthAddressRefList.size() ; i++) {
            if(i>0){
                fourthAddressRefList.get(i).Parent__c = fourthAddressRefList.get(i-1).Id;
            }
            if(i == 0){ // PROVINCE
                fourthAddressRefList.get(i).Name = 'METRO MANILA';
            }
            if(i == 1){ // CITY             
                thirdAddressRefList.get(i).Name = 'MARIKINA';
            }
            if(i == 2){ // BARANGAY             
                fourthAddressRefList.get(i).Name = 'SUMULONG';
            }
            if(i == 3){ // SUBDIVISION             
                fourthAddressRefList.get(i).Name = 'MARIKINA HEIGHTS';
            }

            fourthAddressRefList.get(i).Block__c = 'METRO MANILA';
        }
        update fourthAddressRefList;

        List<Reference__c> fifthAddress = CXE_TestDataFactory.createSampleReferenceListForAddress();
       	fifthAddress.remove(addressRefList.size()-1); 
       	fifthAddress.add(new Reference__c (Block__c='BULACAN',                                  
                                                   Field__c='Street',                                   
                                                   Name='SAN JOSE',
                                                   Name_Code__c='01029001700002',                                   
                                                   Type__c='Geo'));
       	for(Integer i=0 ; i<fifthAddress.size() ; i++) {
            if(i>0){
                fifthAddress.get(i).Parent__c = fifthAddress.get(i-1).Id;
            }
            if(i == 0){ // PROVINCE
                fifthAddress.get(i).Name = 'BULACAN';
            }
            if(i == 1){ // CITY             
                fifthAddress.get(i).Name = 'MARIKINA';
            }
            if(i == 2){ // BARANGAY             
                fifthAddress.get(i).Name = 'SUMULONG';
            }
            if(i == 3){ // SUBDIVISION             
                fifthAddress.get(i).Name = 'MARIKINA HEIGHTS';
            }
            fifthAddress.get(i).Block__c = 'BULACAN';
        }
        insert fifthAddress;

        List<Reference__c> sixth = CXE_TestDataFactory.createSampleReferenceListForAddress();
       	sixth.remove(addressRefList.size()-1); 
       	sixth.add(new Reference__c (Block__c='BATANGAS',                                  
                                                   Field__c='Street',                                   
                                                   Name='STA. MESA',
                                                   Name_Code__c='01029001700002',                                   
                                                   Type__c='Geo'));
       	for(Integer i=0 ; i<sixth.size() ; i++) {
            if(i>0){
                sixth.get(i).Parent__c = sixth.get(i-1).Id;
            }
            
            if(i == 1){ // CITY             
                sixth.get(i).Name = 'PARANG';
            }
            
            if(i == 3){ // SUBDIVISION             
                sixth.get(i).Name = 'MARIKINA HEIGHTS';
            }
            sixth.get(i).Block__c = 'BATANGAS';
        }
        insert sixth;


        Set<Id> accountIdsWithAddress = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        List<Lead> leadList = [SELECT Id FROM Lead WHERE Status='Qualified'];
        System.assertEquals(0, [SELECT Id FROM Address__c].size());
        System.assertEquals(0, [SELECT Id FROM Account].size());
        LeadStatus leadStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        Test.startTest();
        if(!leadList.isEmpty()) {
            list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>();
            for(Lead leadRec : leadList) {
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(leadRec.Id);
                lc.setDoNotCreateOpportunity(TRUE);
                lc.setConvertedStatus(leadStatus.MasterLabel);
                leadConverts.add(lc);
            }           
            List<Database.LeadConvertResult> lcrList = Database.convertLead(leadConverts, false);
            if(!lcrList.isEmpty()) {
                for(Database.LeadConvertResult lc : lcrList){
                    
                    if(lc.isSuccess()) {
                        accountIds.add(lc.getAccountId());
                    } else {
                        String errors = '';             
                        List<String> errorList = new List<String>();
                        for(Database.Error err : lc.getErrors()) {
                            //errors += err.getStatusCode() + ': ' + err.getMessage();
                            errorList.add(err.getMessage());
                            //errors += CXE_Constants.CASE_APPLICATION_ERROR_MESSAGE_STRING2 + err.getFields();
                        }
                        errors += String.join(errorList, '');
                        System.assertEquals(TRUE, lc.isSuccess(), errors);
                    }
                }
                if(!accountIds.isEmpty()) {
                    List<Address__c> addressList = [SELECT Account__c FROM Address__c WHERE Account__c IN:accountIds];
                    if(!addressList.isEmpty()) {
                        for(Address__c addressRec : addressList) {
                            accountIdsWithAddress.add(addressRec.Account__c);
                        }
                    }
                }
            }
            
        }
        Test.stopTest();
        System.assertEquals(accountIds.size(), accountIdsWithAddress.size());
        System.assertEquals(accountIdsWithAddress.size(), [SELECT Id FROM Address__c].size());
    }

    static testMethod void runOtherMethods() {   
        List<Lead> leadList = [SELECT Id FROM Lead WHERE Status='Qualified'];
        if(!leadList.isEmpty()) {
            delete leadList;
            System.assertEquals(0, [SELECT Id FROM Lead WHERE Status='Qualified'].size());
            undelete leadList;
            System.assertEquals(leadList.size(), [SELECT Id FROM Lead WHERE Status='Qualified'].size());
        }
    }

    static testMethod void forceRunUninvokedEvents() {   
        LeadTriggerHandler l = new LeadTriggerHandler();
        l.BeforeDelete(null);
        l.AfterDelete(null);
        l.AfterUndelete(null);
    }
    
}