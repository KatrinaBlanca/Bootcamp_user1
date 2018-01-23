public class ConnectionSearchComponentController {
 
    //private static final String ALL_FOR_ACCOUNT_MODE = 'AllForAccount';
    //private static final String SEARCH_FIELDS_MODE = 'SearchFields';
    //public Opportunity opportunity {get; set;}
    //public List<ConnectionWrapper> returnList;
    //public String postalCode {get; set;}
    //private Boolean firstSetPostalCodeDupeCall = true;
    //public String postalCodeDupe {
    //    get; set {
    //        if (firstSetPostalCodeDupeCall) {
    //            postalCode = value;
    //            postalCodeDupe = value;
    //            firstSetPostalCodeDupeCall = false;
    //        }
    //    }
            
    //}
    //public String street {get; set;}
    //private Boolean firstSetStreetDupeCall = true;
    //public String streetDupe {
    //    get; set {
    //        if (firstSetStreetDupeCall) {
    //            street = value;
    //            streetDupe = value;
    //            firstSetStreetDupeCall = false;
    //        }
    //    }
    //}
    
    //public String City {get; set;}
    //private Boolean firstSetCityDupeCall = true;
    //public String CityDupe {
    //    get; set {
    //        if (firstSetCityDupeCall) {
    //            city = value;
    //            cityDupe = value;
    //            firstSetCityDupeCall = false;
    //        }
                    
    //    }
    //}
    //public Boolean electricity {get; set;}
    //private Boolean firstSetElecDupeCall = true;
    //public Boolean elecdupe {
    //    get; set {
    //        if(firstSetElecDupeCall) {
    //            electricity = True;
    //            elecdupe = True;
    //            firstSetElecDupeCall = false;
    //        }
    //    }
    //}
    //public Boolean gas {get; set;}
    //private Boolean firstSetGasDupeCall = true;
    //public Boolean gasdupe {
    //    get; set {
    //        if(firstSetgasDupeCall) {
    //            gas = True;
    //            gasdupe = True;
    //            firstSetGasDupeCall = false;
    //        }
    //    }
    //}            
    //public Map<Id, ConnectionWrapper> connectionWrapperMap = new Map<Id, ConnectionWrapper>(); 
    //public ConnectionSearchListener connectionSearchListener {get; set;}
    //public Boolean AutoSearching {get; set;}
    //public String mode {get; set;}
    //public String actId {get; set;}
    //Public list<Opportunitylineitem> opportunityLineItems;  
    
    ////Constructor
    public ConnectionSearchComponentController()
    {    

        
    //    if(ApexPages.currentPage() != null && ApexPages.currentPage().getParameters().get('id') != null)
    //    {
    //        Id objectId = Id.valueOf(ApexPages.currentPage().getParameters().get('id'));
    //        initilize(objectId );
    //    }            
    }    
    
    //public void initilize(id objectId )
    //{
    //    if (Util.isOpportunityId(objectId))
    //    {
    //        opportunity = [select Id,Name, accountId from Opportunity where Id = :objectId limit 1][0];
    //        opportunityLineItems = [select Connection__c, Product2Id from OpportunityLineItem
    //                                where OpportunityId = :opportunity.Id and Connection__c != null];
            
    //    }    
    //}                
    //public List<Connection__c> selectedConnections() {
        
    //        List<Connection__c> selectedConnections = new List<Connection__c>();
    //        for (Id id: connectionWrapperMap.keySet()) {
    //            if (connectionWrapperMap.get(id).Selected) {
    //                selectedConnections.add(connectionWrapperMap.get(id).connection);
    //            }
    //        }
    //        system.debug(' selectedConnections  '+selectedConnections);
    //        return selectedConnections;
        
    //}
    
    //public List<ConnectionWrapper> connectionWrappers {
    //    get {
    //         returnList = new List<ConnectionWrapper>();
    //        //system.debug('postalCodedupe:'+postalCodedupe);
                                  
    //            string soql = 'Select Name, EAN__c, Delivery_Street__c, Delivery_City__c, Delivery_Postal_Code__c, Utility_Type__c from Connection__c where Name!= null';
                
    //            if(postalcode  != null && MODE == SEARCH_FIELDS_MODE)
    //            {
    //                system.debug('postalCode:'+postalCode);
    //                soql = soql + ' and Delivery_Postal_Code__c Like \''+String.escapeSingleQuotes(postalcode)+'%\'';
    //            }
    //            if(street != null && MODE == SEARCH_FIELDS_MODE)
    //            {
    //                soql = soql + ' and Delivery_Street__c Like \''+String.escapeSingleQuotes(street)+'%\'';
    //            }   
    //            if(City != null && MODE == SEARCH_FIELDS_MODE)
    //            {
    //                soql = soql + ' and Delivery_City__c Like \''+String.escapeSingleQuotes(city)+'%\'';
    //            }
    //            if(electricity && !gas)
    //            {
    //                soql = soql + ' and Utility_Type__c Like \''+String.escapeSingleQuotes('Electricity')+'%\'';
    //            }
    //            if(!electricity && gas)
    //            {
    //                soql = soql + ' and Utility_Type__c Like \''+String.escapeSingleQuotes('Gas')+'%\'';
    //            }
    //            if(electricity && gas)
    //            {
    //                soql = soql + ' and (Utility_Type__c Like \''+String.escapeSingleQuotes('Electricity')+'%\' Or Utility_Type__c Like \''+String.escapeSingleQuotes('Gas')+'%\')';
    //            }    
                     
    //            if (ActId != null && MODE == ALL_FOR_ACCOUNT_MODE) {
    //                soql += ' and Account__c = \'' + actId + '\'';
    //            }
                
                                       
    //            system.debug('Query'+soql);  
    //            if(street != null || postalcode != null || City != null || actId != null)
    //            {
    //                List<Connection__c> connections =  Database.query(soql);     
    //                    for (Connection__c connection: connections)
    //                    {
    //                        if (!connectionWrapperMap.containsKey(connection.Id))
    //                        {
    //                            connectionWrapperMap.put(connection.Id, new ConnectionWrapper(connection, connectionSearchListener));    
    //                        } 
    //                        returnList.add(connectionWrapperMap.get(connection.Id));
    //                    }
    //             }
    //             if(inOpportunityMode())
    //             {
    //                 for (OpportunityLineItem oli: opportunityLineItems)
    //                 {
    //                     for(ConnectionWrapper cw: returnList)
    //                     {
    //                         if(cw.connection.id ==  oli.Connection__c)
    //                         {
    //                             cw.selected = True;
    //                         }
    //                     }
    //                 }
    //             }                      
            
    //        return returnList;
    //    }
    //}    
    
  
    //public class ConnectionWrapper {
        
    //    public ConnectionSearchListener connectionSearchListener {get; set;}
    //    public Connection__c connection {get; set;}
    //    public Boolean selected {
    //        get;                     
    //        set {
    //        System.debug('inside set');
    //            // Handle situation in which a new connection is selected
    //            if (value && !selected) {
    //                System.debug('inside if');
                  
    //              // connectionSearchListener.newConnectionSelected(connection);
    //            } 
                
    //            selected = value;
    //       }
    //    }
     
    //    public ConnectionWrapper(Connection__c connection, ConnectionSearchListener connectionSearchListener) {
    //        this.connection = connection;
    //        this.selected = false;
    //        this.connectionSearchListener = connectionSearchListener;
    //    }
        
    //}
    
    //public void actiont(){
    //CommodityProductsConfiguratorController c=new CommodityProductsConfiguratorController();
    //c.connectionIdToProductIdMap.clear();
    //connectionSearchListener.clearMap();
    //system.debug('insize===='+c.connectionIdToProductIdMap.size());
    //for(ConnectionWrapper cw:returnList){
    //    if(cw.selected==true){
    //       connectionSearchListener.newConnectionSelected(cw.connection);
    //        system.debug('cw'+cw.connection);
    //    }
    //}
    
       
    //}
    //public Boolean inOpportunityMode() {
    //    return opportunity != null;
    //}
    
        
}