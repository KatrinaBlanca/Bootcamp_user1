public with sharing class CXE_AttachmentWrapper {

	@AuraEnabled
	public Id parentId {get; set;}
	@AuraEnabled
	public String fileName {get; set;}
	@AuraEnabled
	public String base64Data {get; set;}
	@AuraEnabled
	public String contentType {get; set;}
	@AuraEnabled
	public String fileId {get; set;}
	
}