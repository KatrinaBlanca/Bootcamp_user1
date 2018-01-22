trigger DMS_Document on DMS_Document__c (after delete, after undelete) {
    system.debug('>>>>> delete ' + util.is_active('DMS_Heroku_Delete_From_S3'));
    // Start R2C CSM-14435 Von Pernicia 11-22-17
    if(Trigger.isAfter && Trigger.isDelete && util.is_active('DMS_Heroku_Delete_From_S3')){
        system.debug('>>>>> delete');
        /*
        CXE_Heroku.delete_from_s3(
            dms_acc(Trigger.old)
            , UserInfo.getSessionId()
        );
        */
        CXE_Heroku.dms_delete(
            dms_acc(Trigger.old)
        );
    }
    /*
    if(Trigger.isAfter && Trigger.isDelete && util.is_active('DMS_Heroku_Restore_From_S3')){
        CXE_Heroku.restore_from_s3(
            dms_acc(Trigger.old)
            , UserInfo.getSessionId()
        );
    }
    End R2C CSM-14435 Von Pernicia 11-22-17*/

    private Map<Id, Id> dms_acc(List<DMS_Document__c> sobj){
        Map<Id, Id> result = new Map<Id, Id>();

        for(DMS_Document__c doc : sobj){
            result.put(doc.Id, doc.CXE_Account__c);
        }

        return result;
    }
}