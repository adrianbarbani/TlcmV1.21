public with sharing class accountHistoricalBusinessWindow {

    public Account account { get; set; }
    public PastActivity__c thisyear {get;set;}
    public PastActivity__c lastyear {get;set;}
    public PastActivity__c last2year {get;set;}
    public Integer year {get;set;}
    
    public Boolean canEdit {get;set;}
    public PastActivity__c TempNet {get;set;}
    public Boolean multiCurrencyEnabled {get;set;}
    
    public accountHistoricalBusinessWindow(){
        if (Util.globalAccount==null) {
        	if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
        	&& Schema.sObjectType.Account.fields.parentId.isAccessible()
        	&& Schema.sObjectType.Account.fields.Industry.isAccessible()
        	&& Schema.sObjectType.Account.fields.Region__c.isAccessible()){
        	this.account = [SELECT name, id, parentId, Industry, Region__c, Region__r.Currency__c, Region__r.Currency_Name__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        	}
        } else {
    		this.account = Util.globalAccount; 
    	}
        
        Date today = Date.today();
        
        this.year = today.year();
        
        this.loadData();
        
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
        multiCurrencyEnabled = Util.checkMultiCurrencyEnabled(); 
    }
    
    public void loadData(){
        
        List<PastActivity__c> temp = new List<PastActivity__c>();
        
        if(Schema.sObjectType.PastActivity__c.isAccessible() && Schema.sObjectType.PastActivity__c.fields.year__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.a__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.b__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.cc__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.Share_of_Wallet__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.Net_Activity_With_Client__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.Account__C.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.initDate__c.isAccessible()
        && Schema.sObjectType.PastActivity__c.fields.endDate__c.isAccessible()){
        temp = [SELECT year__c, a__c, b__c , cc__c, Share_of_Wallet__c, Net_Activity_With_Client__c, Account__C, initDate__c, endDate__c FROM PastActivity__c WHERE Account__C =:account.id];
        }
          for(PastActivity__c pa : temp){
        
                if(pa.Year__c == year)
                    thisyear = pa;
                else if(pa.Year__c == (year-1))
                    lastyear = pa;
                else if(pa.Year__c == (year-2))
                    last2year = pa;            
        }
        
        if(thisyear==null) {
            thisyear = new PastActivity__c(a__c =0, b__c = 0, cc__c = 0, Account__c = account.id, Year__c = year); 
        }
        if(lastyear==null) {
            lastyear = new PastActivity__c(a__c =0, b__c = 0, cc__c = 0, Account__c = account.id, Year__c = (year-1));
        } 
        if(last2year==null) {
            last2year = new PastActivity__c(a__c =0, b__c = 0, cc__c = 0, Account__c = account.id, Year__c = (year-2));
        }
    }
    

    public PageReference SaveChanges() {
		Savepoint sp = Database.setSavepoint();
		try {
		    
		    if(Schema.sObjectType.PastActivity__c.isCreateable()
		    && Schema.sObjectType.PastActivity__c.fields.a__c.isCreateable()
		    && Schema.sObjectType.PastActivity__c.fields.b__c.isCreateable()
		    && Schema.sObjectType.PastActivity__c.fields.cc__c.isCreateable()
		    && Schema.sObjectType.PastActivity__c.fields.Account__c.isCreateable()
		    && Schema.sObjectType.PastActivity__c.fields.Year__c.isCreateable()
		    && Schema.sObjectType.PastActivity__c.isUpdateable()
		    && Schema.sObjectType.PastActivity__c.fields.a__c.isUpdateable()
		    && Schema.sObjectType.PastActivity__c.fields.b__c.isUpdateable()
		    && Schema.sObjectType.PastActivity__c.fields.cc__c.isUpdateable()
		    && Schema.sObjectType.PastActivity__c.fields.Account__c.isUpdateable()
		    && Schema.sObjectType.PastActivity__c.fields.Year__c.isUpdateable()){
		        
    	        upsert thisyear;
    	        upsert lastyear;
    	        upsert last2year;
		    }
	    } catch(DmlException ex){
	        Database.rollback(sp);
	        ApexPages.addMessages(ex);
	    }
    
        loadData();
        return null;
    }
    
    public String getUserIsoCode() {
        return Util.getUserIsoCode();
    }
    
    public String getCompanyIsoCode() { 
       return Util.getCompanyIsoCode();
    } 
    
    public PageReference ExportToExcel() {
    	return Page.accountHistoricalBusinessWindowExcel;
    }
 	
 	public String getExcelName() {
    	String name = account.Name + '-' + Label.net_activity + '.xls';
    	return name.replaceAll(' ', '_').replaceAll(',','');
    }    
}