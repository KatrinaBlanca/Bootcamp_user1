public without sharing class CXE_FileController {
    

    @AuraEnabled
    public static Id init_attachment(Id parent_id, String name, String type){
        Attachment a = new Attachment();
        a.parentId = parent_id;

        a.Body = EncodingUtil.base64Decode(EncodingUtil.urlDecode('', 'UTF-8'));
        a.Name = name;
        a.ContentType = type;
        insert a;

        return a.Id;
    }

    @AuraEnabled
    public static Integer append_attachment(Id oid, String base64){
        try{
            base64 = EncodingUtil.urlDecode(base64, 'UTF-8');

            Attachment a = [
                SELECT Id, Body, BodyLength, ContentType
                FROM Attachment
                WHERE Id = :oid
            ];
            
            a.Body = EncodingUtil.base64Decode(EncodingUtil.base64Encode(a.Body) + base64);
            a.ContentType = a.ContentType;
            update a;

            return [
                SELECT Id, BodyLength
                FROM Attachment
                WHERE Id = :oid
            ].BodyLength;
        }
        catch(Exception ex){
            System.debug(ex);
        }

        return 0;
    }



    @AuraEnabled
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) { 
        // Start CSM-12409 Von Pernicia: Added Try Catch
        try{
            base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
            
            //ContentVersion conVer = new ContentVersion();
            //conVer.Title = fileName;
            //conVer.PathOnClient = fileName;
            //conVer.VersionData = EncodingUtil.base64Decode(base64Data);
            //conVer.IsMajorVersion = false;
            
            //insert conVer;

            Attachment a = new Attachment();
            a.parentId = parentId;

            a.Body = EncodingUtil.base64Decode(base64Data);
            a.Name = fileName;
            a.ContentType = contentType;
            a.IsPrivate = false;
            insert a;

            //tieFileToCase(conVer.Id, parentId);
            
            return a.Id;
            //return conVer.Id;
        } catch(DmlException e) {
            throw e;
        }
        // End CSM-12409 Von Pernicia: Added Try Catch
    }
    
    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        if (String.isBlank(fileId)) { // Start/End CSM-12409 Von Pernicia: Change the codition to isBlank
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id = :fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        a.IsPrivate = false;
        update a;
    }

/* Start CSM-12409 Von Pernicia: Comment out method
    @AuraEnabled
    public static void tieFileToCase(Id contentVersionId, Id parentId){
        ContentDocumentLink conDocLink = new ContentDocumentLink();
        ContentVersion conVer = new ContentVersion();
        
        conVer = [SELECT id, title, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId];
        
        conDocLink.ContentDocumentId = conVer.ContentDocumentId;
        conDocLink.LinkedEntityId = ParentId;
        conDocLink.ShareType = 'V';
        conDocLink.Visibility = 'AllUsers';

        insert conDocLink;
        
        //return conVer.ContentDocumentId;
    }
End CSM-12409 Von Pernicia: Comment out method*/
}