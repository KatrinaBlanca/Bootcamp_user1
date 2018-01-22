/* Description: CXE_CreateAddress_CMP lightning component controller
* Author: Michael Lasala
* Date Created: FEB-28-17
*/
public with sharing class CXE_CreateAddress_CC {
    /* Description: Identify record sObject type
    * Parameters: Record Id
    * Returns: String
    * Author: Michael Lasala
    * Date Created: MAR-03-17
    */
    @AuraEnabled
    public static String getSobjectType(String sobjectId){
        return String.valueOf(Id.valueOf(sobjectId).getSobjectType());
    }
    
    /* Description: Retrieve Service Address count for Service (Agreement__c)
    * Parameters: Service Id
    * Returns: Integer
    * Author: Michael Lasala
    * Date Created: MAR-04-17
    */
    @AuraEnabled
    public static Integer getServiceAddressCount(String serviceId){
        return [SELECT COUNT() FROM Address__c WHERE Service__c =: serviceId AND Type__c = 'Service'];
    }
    
    /* Description: Query Accounts based on parameter
    * Parameters: Account Name
    * Returns: List<Account>
    * Author: Michael Lasala
    * Date Created: MAR-03-17
    */
    @AuraEnabled
    public static List<Account> getAccounts(String accountName){        
        List<Account> accountList;
        
        if(!String.isBlank(accountName)){
            
            String queryFilter = accountName+'%';
            
            accountList = [SELECT  Id, 
                           Name
                           FROM    Account
                           WHERE   Name LIKE: queryFilter];
        }
        System.debug('accountList: '+accountList);
        return accountList;
    }
    
    /* Description: Query Addresses related to Account
    * Parameters: Account Id, sObject Id
    * Returns: List<Account>
    * Author: Michael Lasala
    * Date Created: MAR-03-17
    */
    @AuraEnabled
    public static List<Address__c> getAccountAddresses(String accountId, String sobjectId){        
        List<Address__c> addressList;
        
        if(!String.isBlank(accountId)){
            
            String typeFilter = '';
            String addressTypeFilter = '';
            
            //Get record sobject type
            String sObjectType = String.valueOf(Id.valueOf(sobjectId).getSobjectType());
            
            //Add filter based on sobject type
            if(sObjectType == 'Agreement__c' || 
               sObjectType == 'Contract' || 
               sObjectType == 'Contact'){
                   
                   addressTypeFilter = 'AND Type__c =: typeFilter';
                   
                   if(sObjectType == 'Agreement__c'){
                       typeFilter = 'Service';
                   } else if(sObjectType == 'Contract'){
                       typeFilter = 'Billing';
                   } else if(sObjectType == 'Contact'){
                       typeFilter = 'Customer';
                   }
               }
            
            String queryString = 'SELECT Id, Type__c, Address__c FROM Address__c WHERE Account__c =: accountId '+addressTypeFilter;
            System.debug('queryString: '+queryString);
            
            addressList = Database.query(queryString);
        }
        System.debug('addressList: '+addressList);
        return addressList;
    }
    
    /* Description: Relate selected Addresses to record
    * Parameters: Record Id, Selected Address Ids
    * Returns: String
    * Author: Michael Lasala
    * Date Created: MAR-03-17
    */
    @AuraEnabled
    public static String updateSelectedAddresses(String sobjectId, List<String> addressIdList){
        System.debug('$$$: '+sobjectId+', '+addressIdList);
        String dmlStatus = '';
        Id acctId = null; //START/END RREYES MAR-18-17 CSM-1832
    //START RReyes MAY-29-17  - prevent relating customer address to account
    Integer custAddCount = 0;
    Boolean hasCustomerAccount = false;
    //END RReyes MAY-29-17  - prevent relating customer address to account
        if(!String.isBlank(sobjectId)){
            
            List<Address__c> addressList = new List<Address__c>();
            
            //Get record sobject type
            String sObjectType = String.valueOf(Id.valueOf(sobjectId).getSobjectType());
            
            //Rename field name due to different label and api names
            if(sObjectType == 'Agreement__c'){
                sObjectType = 'Service__c';
            } else if(sObjectType == 'Contract' || 
                      sObjectType == 'Account' || 
                      sObjectType == 'Case' || 
                      sObjectType == 'Contact'){  //Michael Lasala MAR-27-17 CSM-1995
                          
                          sObjectType += '__c';
                      }
            //START RREYES MAR-18-17 - relate account to address
            if(sobjectId != '' && sobjectId != null){
                if(sObjectType == 'Case__c'){
                    acctId = [SELECT AccountId FROM Case WHERE Id =: sobjectId LIMIT 1].AccountId;
          //START RReyes MAY-29-17  - prevent relating customer address to account
          if(acctId != null){
            custAddCount = [SELECT COUNT() FROM Address__c WHERE Account__c =: acctId AND Type__c = 'Customer' LIMIT 1];
          }
          //END RReyes MAY-29-17  - prevent relating customer address to account
                }
        //START RReyes MAY-29-17  - prevent relating customer address to account
        else if(sObjectType == 'Account__c'){
          custAddCount = [SELECT COUNT() FROM Address__c WHERE Account__c =: sobjectId AND Type__c = 'Customer' LIMIT 1];
        }else if(sObjectType == 'Service__c'){
          custAddCount = [SELECT COUNT() FROM Address__c WHERE Service__c =: sobjectId AND Type__c = 'Customer' LIMIT 1];
        }else if(sObjectType == 'Contract__c'){
          custAddCount = [SELECT COUNT() FROM Address__c WHERE Contract__c =: sobjectId AND Type__c = 'Customer' LIMIT 1];
        }else if(sObjectType == 'Contact__c'){
          custAddCount = [SELECT COUNT() FROM Address__c WHERE Contact__c =: sobjectId AND Type__c = 'Customer' LIMIT 1];
        }
        //END RReyes MAY-29-17  - prevent relating customer address to account
        
            }
            //END RREYES MAR-18-17 - relate account to address
            
            //BEGIN Michael Lasala MAR-12-17 CSM-1800
            //Added fields for cloning
            for(Address__c address: [SELECT Id, 
                                            Type__c, 
                                            Premise_Type__c, 
                                            Address_Unit_No__c, 
                                            Address_Street_No__c, 
                                            Address_Street_Name__c, 
                                            Address_Subdivision__c, 
                                            Address_Barangay__c, 
                                            Address_City_Municipality__c, 
                                            Address_Province__c
                                     FROM   Address__c 
                                     WHERE  Id IN: addressIdList]){
                                         
                 //Clone record
                 Address__c cloneAddress = address.clone(false, true, false, false);
                 
                 //Clear lookup values
                 cloneAddress.Account__c = null;
                 cloneAddress.Case__c = null;
                 cloneAddress.Contract__c = null;
                 cloneAddress.Service__c = null;
                 cloneAddress.Connection__c = null;
         //START RReyes MAY-29-17  - prevent relating customer address to account if there is already one
                 //START RREYES MAR-18-17 - relate account to address
                 if(acctId != null && (address.Type__c == 'Billing' || address.Type__c == 'Service' || (address.Type__c == 'Customer' && custAddCount < 1))){
                     cloneAddress.Account__c = acctId;
                 }
                 //END RREYES MAR-18-17 - relate account to address
         //END RReyes MAY-29-17  - prevent relating customer address to account if there is already one
                 
                 //Assign lookup valuemike
         //START RReyes MAY-29-17  - prevent relating customer address to account if there is already one
         if(!(sObjectType == 'Account__c' && custAddCount > 0 && address.Type__c == 'Customer')){
          cloneAddress.put(sObjectType, !String.isBlank(sobjectId) ? sobjectId : null);
         }
         //END RReyes MAY-29-17  - prevent relating customer address to account if there is already one
                 cloneAddress.OwnerId = UserInfo.getUserId();   
                 addressList.add(cloneAddress);
             }
            
            if(!addressList.isEmpty()){
                System.debug('addressList: '+addressList);
                
                //Insert address records
                try {
                    insert addressList;
                    //END Michael Lasala MAR-12-17 CSM-1800
                    
                    dmlStatus = 'Success';
                    System.debug('addressList: '+addressList);
          //START RReyes MAY-29-17  - prevent relating customer address to account if there is already one
          if(sObjectType == 'Account__c' && custAddCount > 0){
            for(Address__c add : addressList){
              if(add.Type__c == 'Customer'){
                dmlStatus = 'accountHasCustomer';
                if(addressList.size() == 1){
                    dmlStatus = 'singleAccountisCustomer';
                }
              }
            }
          }
          //END RReyes MAY-29-17  - prevent relating customer address to account if there is already one
                    
                } catch (DMLException error){
                    dmlStatus = error.getDmlMessage(0);
                    System.debug('insert address__c error: '+error.getMessage());
                    ErrorHandlerException.recordException(sobjectId, true, 'CXE_CreateAddress_CC', 'updateSelectedAddresses', error.getMessage());
                }
            }
        }
        return dmlStatus;
    }
    
    /* Description: Retrieve record name
    * Parameters: sObject Id
    * Returns: String
    * Author: Michael Lasala
    * Date Created: FEB-28-17
    */
    @AuraEnabled
    public static List<String> getObject(String sobjectId){
        List<String> objectList = new List<String>();
        
        if(!String.isBlank(sobjectId)){
            String sObjectType = String.valueOf(Id.valueOf(sobjectId).getSobjectType());
            
            String nameField = 'Name';
            
            //Rename Name fields for Case and Contract
            if(sObjectType == 'Case' || 
               sObjectType == 'Contract'){
                   
                   nameField = sObjectType+'Number';
               }
            
            String queryString = 'SELECT '+nameField+' FROM '+sObjectType+' WHERE Id =: sobjectId LIMIT 1';
            System.debug('queryString: '+queryString);
            
            List<sObject> sobjectList = Database.query(queryString);
            if(!sobjectList.isEmpty()){
                
                //Remove __c for custom objects
                sObjectType = sObjectType.replace('__c', '');
                
                //Rename label due to different label and api names for Service/Agreement
                if(sObjectType == 'Agreement'){
                    sObjectType = 'Service';
                }
                
                objectList.add(sObjectType);
                objectList.add((String)sobjectList.get(0).get(nameField));
                System.debug('sobjectList: '+sobjectList);
                System.debug('objectList: '+objectList);
            }
        }
        return objectList;
    }
    
    /* Description: Retrieve User Full Name
    * Parameters: None
    * Returns: String
    * Author: Michael Lasala
    * Date Created: FEB-28-17
    */
    @AuraEnabled
    public static String getUser(){
        String userName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
        return userName;
    }
    
    /* Description: Map field values and insert Address record
    * Parameters: Object Id, Address Type, Premise Type, Unit #, Street #, Street Lookup Id, Subdivision Lookup Id, 
    Barangay Lookup Id, City Lookup Id, Province Lookup Id
    * Returns: Address__c
    * Author: Michael Lasala
    * Date Created: FEB-28-17
    */
    @AuraEnabled
    public static String insertAddress(String objectId, 
                                       String addressType, 
                                       String premiseType, 
                                       String landmark, 
                                       String unitNo, 
                                       String streetNo, 
                                       String streetId, 
                                       String subdivisionId, 
                                       String barangayId, 
                                       String cityId, 
                                       String provinceId){
                                           
       String dmlStatus = '';
       Address__c newAddress = new Address__c();
       
       //Map address values based on parameters
       String sObjectType = String.valueOf(Id.valueOf(objectId).getSobjectType());
       //START RReyes MAY-29-17  - prevent relating customer address to account
     Integer custAddCount = 0;
     //END RReyes MAY-29-17  - prevent relating customer address to account
     
       //Rename field name due to different label and api names
       if(sObjectType == 'Agreement__c'){
           sObjectType = 'Service__c';
       } else if(sObjectType == 'Contract' || 
                 sObjectType == 'Account' || 
                 sObjectType == 'Case' || 
                 sObjectType == 'Contact'){  //Michael Lasala MAR-27-17 CSM-1995
                     
                     sObjectType += '__c';
                 }
       
       //Assign lookup value
       newAddress.put(sObjectType, !String.isBlank(objectId) ? objectId : null);
       
       newAddress.OwnerId = UserInfo.getUserId();
       newAddress.Type__c = addressType;
       
       if(premiseType != 'Please Select'){
           newAddress.Premise_Type__c = premiseType;
       }
       
       newAddress.Landmarks_Directions__c = !String.isBlank(landmark) ? landmark : null;
       newAddress.Address_Unit_No__c = !String.isBlank(unitNo) ? unitNo : null;
       newAddress.Address_Street_No__c = !String.isBlank(streetNo) ? streetNo : null;
       newAddress.Address_Street_Name__c = !String.isBlank(streetId) ? streetId : null;
       newAddress.Address_Subdivision__c = !String.isBlank(subdivisionId) ? subdivisionId : null;
       newAddress.Address_Barangay__c = !String.isBlank(barangayId) ? barangayId : null;
       newAddress.Address_City_Municipality__c = !String.isBlank(cityId) ? cityId : null;
       newAddress.Address_Province__c = !String.isBlank(provinceId) ? provinceId : null;
       //START RREYES MAR-16-17 - relate account to address
       System.debug('RR objectId: ' + objectId);
       if(objectId != '' && objectId != null){
           System.debug('RR sObjectType: ' + sObjectType);
           System.debug('RR addressType: ' + addressType);
           if(sObjectType == 'Case__c' && addressType != 'Meter'){
               Id acctId = [SELECT AccountId FROM Case WHERE Id =: objectId LIMIT 1].AccountId;
               System.debug('RR acctId: ' + acctId);
         //START RReyes MAY-29-17  - prevent relating customer address to account
         if(acctId != null){
           if(addressType == 'Customer'){
            custAddCount = [SELECT COUNT() FROM Address__c WHERE Account__c =: acctId AND Type__c = 'Customer' LIMIT 1];
           }
           if(custAddCount < 1){
             newAddress.Account__c = acctId;
          }
        }
        //END RReyes MAY-29-17  - prevent relating customer address to account
           }//START RReyes MAY-29-17  - prevent relating customer address to account
       else if(sObjectType == 'Account__c' && addressType == 'Customer'){
         if(objectId != null){
            custAddCount = [SELECT COUNT() FROM Address__c WHERE Account__c =: objectId AND Type__c = 'Customer' LIMIT 1];
        }
        //END RReyes MAY-29-17  - prevent relating customer address to account
           }
       //END RReyes MAY-29-17  - prevent relating customer address to account
       }
       //END RREYES MAR-16-17 - relate account to address
     
       //Insert address record
       try {
       //START RReyes MAY-29-17  - prevent relating customer address to account
       if(!(sObjectType == 'Account__c' && custAddCount > 0)){
         insert newAddress;
         dmlStatus = 'Success';
       }else{
         dmlStatus = 'You cannot add more than one customer address for an account.';
       }
       //END RReyes MAY-29-17  - prevent relating customer address to account
           System.debug('newAddress: '+newAddress);
           
       } catch (DMLException error){
           dmlStatus = error.getDmlMessage(0);
           System.debug('insert address__c error: '+error.getMessage());
           ErrorHandlerException.recordException(objectId, true, 'CXE_CreateAddress_CC', 'insertAddress', error.getMessage());
       }
       return dmlStatus;
   }
    
    /* Description: Query Street
    * Parameters: Street, Subdivision Id
    * Returns: List<Reference__c>
    * Author: Michael Lasala
    * Date Created: MAR-08-17
    */
    //@AuraEnabled
    //public static List<Reference__c> getStreet(String street, String subdivisionId){
    //    List<Reference__c> streetList = new List<Reference__c>();
    //    System.debug('street: '+street);
    //    if(!String.isBlank(street)){
            
    //        streetList = [SELECT  Id
    //                      FROM    Reference__c 
    //                      WHERE   Name =: street
    //                      AND     Type__c = 'Geo'
    //                      AND     Field__c = 'Street'
    //                      AND     Parent__c =: subdivisionId LIMIT 1];
    //    }
    //    System.debug('streetList: '+streetList);
    //    return streetList;
    //}
    
    /* Description: Query Streets based on Subdivision
    * Parameters: Street, Subdivision Id
    * Returns: List<Reference__c>
    * Author: Michael Lasala
    * Date Created: MAR-08-17
    */
    @AuraEnabled
    public static List<Reference__c> getStreets(String street, String subdivisionId){
        List<Reference__c> streetList = new List<Reference__c>();
        System.debug('subdivisionId: '+subdivisionId);
        if(!String.isBlank(street)){
            
            streetList = [SELECT  Id, 
                                  Name
                          FROM    Reference__c 
                          WHERE   Name =: street
                          AND     Type__c = 'Geo'
                          AND     Field__c = 'Street'
                          AND     Parent__c =: subdivisionId LIMIT 1];

            if(streetList.isEmpty()){
                streetList = [SELECT  Id, 
                                      Name
                              FROM    Reference__c 
                              WHERE   Type__c = 'Geo'
                              AND     Field__c = 'Street'
                              AND     Parent__c =: subdivisionId
                              ORDER BY Name];
            }
        }
        System.debug('streetList: '+streetList);
        return streetList;
    }

    /* Description: Query Subdivisions based on parameter and block records
    * Parameters: Subdivision
    * Returns: List<Reference__c>
    * Author: Michael Lasala
    * Date Created: MAR-10-17
    */
    @AuraEnabled
    public static List<Reference__c> getSubdivisions(String subdivision){        
        List<Reference__c> subdivisionList = new List<Reference__c>();
        System.debug('subdivision: '+subdivision);
        
        if(!String.isBlank(subdivision)){
            
            Set<String> blockSet = new Set<String>();
            String queryFilter = subdivision+'%';
            
            //Retrieve similar subdivisions based on parameter
            for(Reference__c sub: [SELECT   Id, 
                                   Name, 
                                   Field__c, 
                                   Parent_Code__c, 
                                   Name_Code__c, 
                                   Parent__r.Name, 
                                   Parent__r.Parent__r.Name, 
                                   Parent__r.Parent__r.Parent__r.Name, 
                                   Block__c
                                   FROM     Reference__c 
                                   WHERE    Name LIKE: queryFilter
                                   AND      Type__c = 'Geo'
                                   AND      Field__c = 'Subdivision']){
                                       
                                       subdivisionList.add(sub);
                                       
                                       //Add block value for query filter
                                       if(!blockSet.contains(sub.Block__c)){
                                           blockSet.add(sub.Block__c);
                                       }
                                   }
            
            //Retrieve block results based on subdivision
            for(Reference__c sub: [SELECT   Id, 
                                            Name, 
                                            Field__c, 
                                            Parent_Code__c, 
                                            Name_Code__c, 
                                            Parent__r.Name, 
                                            Parent__r.Parent__r.Name, 
                                            Block__c
                                   FROM     Reference__c 
                                   WHERE    Block__c IN: blockSet
                                   AND      Type__c = 'Geo'
                                   AND      Field__c != 'Subdivision'
                                   AND      Field__c != 'Street']){
                                       
                subdivisionList.add(sub);
            }
        }
        System.debug('subdivisionList: '+subdivisionList);
        return subdivisionList;
    }
    
    /* Description: Retrieve Address__c.Type__c picklist values
    * Parameters: Record Id
    * Returns: List<String>
    * Author: Michael Lasala
    * Date Created: FEB-28-17
    */
    @AuraEnabled
    public static List<String> getAddressType(String sobjectId){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Address__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('Please Select');
        for (Schema.PicklistEntry f: ple) {
            
            //Remove meter if sobject is account
            if(String.valueOf(Id.valueOf(sobjectId).getSobjectType()) == 'Account'){ 
                
                if(f.getLabel() != 'Meter'){
                    options.add(f.getLabel());
                }
                
            } else {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    
    /* Description: Retrieve Address__c.Premise_Type__c picklist values
    * Parameters: None
    * Returns: List<String>
    * Author: Michael Lasala
    * Date Created: MAR-04-17
    */
    @AuraEnabled
    public static List<String> getPremiseType(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Address__c.Premise_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('Please Select');
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }

    /* Description: Retrieve Billing Address count for Contract - CSM-6137, CSM-6135
    * Parameters: Contract Id
    * Returns: Integer
    * Author: Jerome To
    * Date Created: MAR-04-17
    */
    @AuraEnabled
    public static Integer getBillingAddressCount(String contractId){
        return [SELECT COUNT() FROM Address__c WHERE Contract__c =:contractId AND Type__c =:CXE_Constants.ADDRESS_TYPE_BILLING];
    }
    
}