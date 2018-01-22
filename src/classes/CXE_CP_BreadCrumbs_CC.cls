public without sharing class CXE_CP_BreadCrumbs_CC {

	public class BreadCrumbWrapper{
        @AuraEnabled
        public String name;
        
        @AuraEnabled
        public String link;

        @AuraEnabled
        public Boolean isActive;
    }

	public CXE_CP_BreadCrumbs_CC() {
		
	}

	@AuraEnabled
	public static List<BreadCrumbWrapper> getBreadCrumbs(String breadCrumbStringList, List<String> sourcePages) {
		List<BreadCrumbWrapper> breadCrumbWrapperList = new List<BreadCrumbWrapper>();
		List<String> breadCrumbList = new List<String>();
        Map<String, CXE_Breadcrumb__mdt> breadCrumbMap = new Map<String, CXE_Breadcrumb__mdt>();

		// call metadata
		for (CXE_Breadcrumb__mdt breadCrumb : [SELECT MasterLabel, Link__c, UI_Label__c FROM CXE_Breadcrumb__mdt]) {         
			breadCrumbMap.put(breadCrumb.MasterLabel, breadCrumb);
  		}
 		
        if(breadCrumbStringList != null) {
            breadCrumbList = breadCrumbStringList.split(',');
        } else if(sourcePages!= null && !sourcePages.isEmpty()) {
            Integer ctr = 0;
            for(String page : sourcePages) {
                BreadCrumbWrapper bCrumb = new BreadCrumbWrapper();
                if(breadCrumbMap.containsKey(page)) {                    
                    bCrumb.name = breadCrumbMap.get(page).UI_Label__c;
                    bCrumb.link = breadCrumbMap.get(page).Link__c;                                      
                }
                if(ctr == sourcePages.size() - 1) {
                    bCrumb.name = page;
                    bCrumb.link = '';
                    bCrumb.isActive = true;
                }
                  
                breadCrumbWrapperList.add(bCrumb);
                ctr++;
            }
        }
		return breadCrumbWrapperList;
	}
}