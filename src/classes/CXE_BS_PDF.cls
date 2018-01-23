@RestResource(urlMapping='/getPDFURL')
global with sharing class CXE_BS_PDF {
	
	@HttpPost
    global static void post(String doc_id) {
    	CXE_Json.text(CXE_HerokuApps.presign(doc_id, 'PDF', doc_id.replace('|', '-')));
    }
}