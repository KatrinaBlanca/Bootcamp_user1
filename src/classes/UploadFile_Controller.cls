public with sharing class UploadFile_Controller {
    public transient Attachment objAttachment;

    //Use getter so we can make attachment transient
    public Attachment getObjAttachment(){
        objAttachment = new Attachment();
        return objAttachment;
    }

    public Boolean fileUploadProcessed{get;set;}
    public String message{get;set;}
    public String messageType{get;set;}

    public void uploadFile(String recordId){
        try {
            objAttachment.ParentId = recordId;

            insert objAttachment;

            message = 'File was uploaded successfully';
            messageType = 'success';
        }catch(Exception e){
            message = e.getMessage();
            messageType = 'error';
        }
        fileUploadProcessed = true;
    }
}