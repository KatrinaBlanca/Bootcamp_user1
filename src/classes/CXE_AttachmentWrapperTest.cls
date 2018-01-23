/* 
 * Description: Test Class for CXE_AttachmentWrapper
 * Author: Rom Edison Reyes (Accenture)
 * Date Created: JAN-02-2018
 */ 
@isTest
private class CXE_AttachmentWrapperTest {

   static testmethod void testAttachmentWrapper() {
      Test.startTest();
      CXE_AttachmentWrapper att = new CXE_AttachmentWrapper();
      
      att.parentId = null;
      att.fileName = 'fileNameTest';
      att.base64Data = 'base64DataTest';
      att.contentType = 'contentTypeTest';
      att.fileId = 'fileIdTest';

      System.assertEquals(att.parentId, null);
      System.assertEquals(att.fileName, 'fileNameTest');
      System.assertEquals(att.base64Data, 'base64DataTest');
      System.assertEquals(att.contentType, 'contentTypeTest');
      System.assertEquals(att.fileId, 'fileIdTest');
      Test.stopTest();
   }
}