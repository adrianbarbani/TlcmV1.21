public with sharing class ChatterPageController {
	
	public String accountId {get;set;}
	
	public ChatterPageController() {
		accountId = ApexPages.currentPage().getParameters().get('Id');
	}
	
}