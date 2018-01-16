public with sharing class AccountContacts {

    public Account account {get;set;}
    public Boolean canEdit {get;set;}
    public List<Contact> contactList {get;set;}

    public AccountContacts(ApexPages.StandardController controller) {        
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() ){
        this.account = [SELECT name, id, parentId FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
    }

	public AccountContacts() {
        if (Util.globalAccount==null) {
        	  if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() ){
            	this.account = [SELECT name, id, parentId FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];}
        } else {
    		this.account = Util.globalAccount; 
    	}
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
    }


    public List<ExtendedContactDetails> getContacts(){
    
        List<ExtendedContactDetails> ret = new List<ExtendedContactDetails>();
        
        if(Schema.sObjectType.Contact.isAccessible() && Schema.sObjectType.Contact.fields.Name.isAccessible() && Schema.sObjectType.Contact.fields.Title.isAccessible() && Schema.sObjectType.Contact.fields.ReportsToId.isAccessible() && Schema.sObjectType.Contact.fields.Closest_Account_Team_Member__c.isAccessible() ){

        contactList = [SELECT Id, Name, Title, ReportsToId,Closest_Account_Team_Member__r.name  FROM Contact WHERE active__c = true and AccountId = :ApexPages.currentPage().getParameters().get('Id')];
        }
        
        List<Contact_Influence__c> ci = new List<Contact_Influence__c>();
        
        if(Schema.sObjectType.Contact_Influence__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible() ){
        ci = [SELECT Contact_Influenced__c,Contact_Influences__c FROM Contact_Influence__c WHERE Contact_Influenced__c IN (SELECT id FROM Contact WHERE active__c = true and AccountId = :ApexPages.currentPage().getParameters().get('Id'))];      
        }
		Map<Id, Contact> contactMap = new Map<Id, Contact>();
		
		for (Contact c :contactList) {
			contactMap.put(c.id,c);
		} 
				
        for( Contact c: contactList ){
            ret.add( new ExtendedContactDetails(c,ci,contactList,contactMap));
        }
    
        return ret;
    
    }
    
    public PageReference goToNewContact (){
        string pageReturn = Page.accountOrganizationChartWindow.getUrl() + '?id='+account.Id;
        PageReference pageRef = new PageReference('/003/e?retURL=%2F' + pageReturn + '&accid='+account.Id + '&saveURL=%2F' + pageReturn);
        return pageRef;
    }
	
	public PageReference goToOrg() {		
        return new PageReference(Page.accountOrganizationChart.getUrl()  + '?id='+account.Id);
	}
	
	public PageReference save() {
		try {
            
            if(Schema.sObjectType.contact.fields.Name.isUpdateable() && Schema.sObjectType.contact.fields.Title.isUpdateable() ){
                if (Schema.sObjectType.contact.isUpdateable()){
                    update contactList;
                }
            }
            
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
		return null;
	}
	
 	public String getExcelName() {
    	String name = account.Name + '-' + Label.Influence_Org + '.xls';
    	return name.replaceAll(' ', '_').replaceAll(',','');
    } 
    
    public PageReference ExportToExcel() {      
        return Page.accountOrganizationChartWindowExcel;
    }
    
}