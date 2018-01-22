@isTest
public class UploadFile_Controller_Test{
        
    @isTest
    static void getObjAttachment_Test(){
        
        Test.startTest();
        UploadFile_Controller upf = new UploadFile_Controller();
        upf.uploadFile('1232132');
        
        Attachment attch =upf.getObjAttachment();
        System.assert(attch !=null);
        
        Test.stopTest();
        

    }


}