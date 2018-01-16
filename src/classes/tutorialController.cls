public  with sharing class tutorialController {
	
	public String pageName {get;set;}
	public String text {get;set;}
	
	public tutorialController() {
		
		pageName = ApexPages.currentPage().getUrl();
		if (pageName.contains('certa_scp__')) {
			pageName = pageName.split('certa_scp__')[1];
		} else {
			pageName = pageName.split('apex/')[1];
		}
		pageName = pageName.replace('?', '####').split('####')[0];
		
	}
	
}