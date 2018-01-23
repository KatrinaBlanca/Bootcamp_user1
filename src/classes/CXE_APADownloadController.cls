/* 
 * Description: All constants that are used in multiple classes outside Click.
 * Author: Von Pernicia (Accenture)
 * Date Created: NOV-09-17
 * Story: CSM-13169
 */
public with sharing class CXE_APADownloadController {

	public String apaId {get; set;}

	public CXE_APADownloadController() {
		
		Map<String, String> q = ApexPages.currentPage().getParameters();
		apaId = q.get('Id');
	}

	public PageReference redirectToDownloadURL()
	{
		Boolean isDownloaded = true;
		PageReference retURL;
		For(Auto_Payment_Arrangement__c apa: [SELECT Status__c, Date__c
											   FROM Auto_Payment_Arrangement__c
											   WHERE Id=: apaId AND Status__c = 'Available'])
		{
			DateTime newDate = apa.Date__c;
			String folderName = newDate.format('MMddyyyy');

			retURL = new PageReference(CXE_HerokuApps.download_sign('APA','APA|'+ folderName +'|all', 'APA_' + folderName + '.zip'));
			
			retURL.setRedirect(true);

			apa.Last_Downloaded_Time__c = date.today();
			apa.Status__c = 'Downloaded';
			update apa;

			isDownloaded = false;
		}

		if (isDownloaded)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'File has already been downloaded.'));
		}

		return retURL;
	}
}