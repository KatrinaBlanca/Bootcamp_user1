public without sharing class CXE_CP_MyAccountsAccountDetail { //CSM-12485 GGrandea 09.08.2017 - changed to "without sharing"
    
    @AuraEnabled
    public static String checkSinToDelete(String myAccount, String mySin){ //CXE_CP_PortalUtility.PortalData
        String returnMsg = 'error';
        String RTN_MSG_PAPERLESS = 'PAPERLESS';
        String RTN_MSG_PAYOR = 'PAYOR';
        String RTN_MSG_SUCCESS = 'SUCCESS';
        
        try{
            
            //GET SIN BILL PRINT MODE THRU AGREEMENT__c /PAPER, PAPERLESS, AND ETC.
            List<Agreement__c> checkBillPrintMode= [SELECT payor__r.Bill_Print_Mode__c
                                                      , Payor__c //CSM-12359
                                                    FROM Agreement__c WHERE SIN__c =: mySin];
            
            if(!checkBillPrintMode.isEmpty()){
                
                String billPrintMode = String.ValueOf(checkBillPrintMode[0].payor__r.Bill_Print_Mode__c);
                
                if (billPrintMode == CXE_Constants.BPM_PAPERLESS){
                    
                    returnMsg = RTN_MSG_PAPERLESS;    
                    
                } else {
                    
                    //GET SPECIFIC SIN UNDER THE USER
                    List<CXE_Service_Enrollment__c> listofEnrollments = [Select Id, CXE_ServiceId__c, CXE_Alias__c, CXE_IsActive__c , CXE_Unenrollment_Date__c, CXE_Type__c
                                                                         , CXE_ServiceId__r.SIN__c
                                                                         , CXE_ServiceId__r.Account__c
                                                                         , CXE_ServiceId__r.Payor__c
                                                                         , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                         From CXE_Service_Enrollment__c 
                                                                         Where CXE_UserId__c=:UserInfo.getUserId() 
                                                                         AND CXE_ServiceId__r.SIN__c =: mySin
                                                                         //START - CSM-13024 JRances Added CXE_IsActive__c for filtering to get only Active SIN for unenrollment
                                                                         AND CXE_IsActive__c = True
                                                                         //END - CSM-13024 JRances
                                                                        ];
                    
                    if(!listofEnrollments.isEmpty()){
                        
                        //START CSM-12359 GGrandea 09.20.2017
                        //GET ALL THE SIN THE USER ENROLLED, AND SELECTING THE SIN NEEDED FOR DELETION
                        /*List<Agreement__c> listofServiceAgreements = [Select ID ,Payor__c,Payor__r.V10_Account_No__c, SIN__c,Account__c,Service_Status__c
                                                                      ,(Select Address__c from Billing_Preferences__r) 
                                                                      from Agreement__c 
                                                                      where Account__c =: listofEnrollments[0].CXE_ServiceId__r.Account__c
                                                                      AND SIN__c =: mySin];
                        
                        String AcctServiceAgreement = String.ValueOf(listofServiceAgreements[0].Account__c);
                        String AcctEnrollment = String.ValueOf(listofEnrollments[0].CXE_ServiceId__r.Account__c);
                        String sinType = String.ValueOf(listofEnrollments[0].CXE_Type__c); */
                        
                        //if(sinType == CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR){
                        if(listofEnrollments[0].CXE_Type__c==CXE_Constants.SERVICE_ENROLLMENT_TYPE_PAYOR){
                        //END CSM-12359 GGrandea 09.20.2017
                            
                            returnMsg = RTN_MSG_PAYOR;
                            
                        } else {
                            
                            //if(AcctServiceAgreement == AcctEnrollment){ //CSM-12359 disabled IF

                                // integration comes first before DML
                                //vincent V10 integration

                                //START CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                                /*List<CXE_Service_Enrollment__c> listofRelatedAccounts = [Select Id, CXE_ServiceId__c, CXE_Alias__c, CXE_IsActive__c , CXE_Unenrollment_Date__c, CXE_Type__c
                                                                                         , CXE_ServiceId__r.SIN__c
                                                                                         , CXE_ServiceId__r.Account__c
                                                                                         , CXE_ServiceId__r.Payor__r.V10_Account_No__c
                                                                                         From CXE_Service_Enrollment__c 
                                                                                         //Where CXE_ServiceId__r.SIN__c =: mySin //CSM-12359
                                                                                         WHERE CXE_ServiceId__r.Payor__c =: checkBillPrintMode[0].Payor__c //CSM-12359
                                                                                         and CXE_IsActive__c = true
                                                                                         AND Id != :listofEnrollments[0].Id
                                                                                        ];*/
                                //END CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class

                                //START CSM-12359 GGrandea 09.20.2017
                                /*List<CXE_Service_Enrollment__c> checkType = [Select Id,CXE_Type__c 
                                                                                           From CXE_Service_Enrollment__c
                                                                                           Where Id =: listofEnrollments[0].Id];*/
                                //END CSM-12359 GGrandea 09.20.2017
                                
                                //START CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                                /*system.debug('hereiam: ' + listofRelatedAccounts.size());
                                system.debug('billPrintMode: ' + billPrintMode);
                                if (billPrintMode == CXE_Constants.BPM_PAPERPLUS && listofRelatedAccounts.size() == 0){
                                    
                                    List<Contract> contractRecords = [Select Id,Contract_External_ID__c,Bill_Print_Mode__c
                                                                      from Contract 
                                                                      where id=:listofEnrollments[0].CXE_ServiceId__r.Payor__c];
                                    
                                    system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>here'+contractRecords);
                                    
                                    system.debug('8/11/2017' + contractRecords.size());
                                    //START CSM-12359 GGrandea 09.20.2017
                                    //if(contractRecords.size() > 0 && checkType[0].CXE_Type__c == 'Payor'){
                                    if(contractRecords.size() > 0){
                                    //END CSM-12359 GGrandea 09.20.2017
                                        system.debug('8/11/2017' + contractRecords.size());
                                        CXE_CP_BillPrintModeIntegrationUtility.printmodeUpdateRequest (contractRecords , CXE_Constants.BPM_PAPER);
                                    } 
                                }*/
                                //END CSM-12877 GGrandea 09.22.2017 disable BillPrintMode invocation from this class
                                
                                
                                listofEnrollments[0].CXE_IsActive__c = false;
                                listofEnrollments[0].CXE_Unenrollment_Date__c = System.now();
                                update listofEnrollments[0];
                                
                                
                                returnMsg = RTN_MSG_SUCCESS;  
                                
                            //} //CSM-12359
                        }
                    }
                }
            }
            
        } catch(exception e){
            returnMsg = e.getMessage();
                ErrorHandlerException.recordException(null, true, 'CXE_CP_MyAccountsAccountDetail', 'checkSinToDelete', e.getMessage());
        }
        
        return returnMsg;
    }
}