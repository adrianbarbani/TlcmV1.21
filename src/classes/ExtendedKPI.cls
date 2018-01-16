public with sharing class ExtendedKPI{

    public AccountKPI__c thisyear {get;set;}
    public AccountKPI__c lastyear {get;set;}
    public AccountKPI__c last2year {get;set;}
    public AccountKPI__c last3year {get;set;}
    public KPI__c kpi {get;set;}
    public String source {get;set;}
	
	public ExtendedKPI(KPI__C kpi,List<AccountKPI__C> kpisData,Integer year,String AccountId, String source){
		this(kpi,kpisData,year,AccountId);	
		this.source = source.replace('Todos - Todos', 'Todos').replace('All - All', 'All');
	}
	
    public ExtendedKPI(KPI__C kpi,List<AccountKPI__C> kpisData,Integer year,String AccountId){
    
        this.kpi = kpi;
        
        for(AccountKPI__C k : kpisData){
        
            if(k.KPI__R.id == kpi.id){
            
                if(k.Year__c == year)
                    thisyear = k;
                else if(k.Year__c == (year-1))
                    lastyear = k;
                else if(k.Year__c == (year-2))
                    last2year = k;
                else if(k.Year__c == (year-3))
                    last3year = k;    
            
            }
        
        }
        
        if(thisyear==null)
            thisyear = new AccountKPI__c(Account__c = AccountId, KPI__c = kpi.id, Year__c = year); 
        if(lastyear==null)
            lastyear = new AccountKPI__c(Account__c = AccountId, KPI__c = kpi.id, Year__c = (year-1)); 
        if(last2year==null)
            last2year = new AccountKPI__c(Account__c = AccountId, KPI__c = kpi.id, Year__c = (year-2));
        if(last3year==null)
            last3year = new AccountKPI__c(Account__c = AccountId, KPI__c = kpi.id, Year__c = (year-3));
    
    }


    public void save(){
    
        if(thisyear.id == null)
            if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isCreateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.isCreateable())
            insert thisyear;
        else
                    if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isUpdateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.isUpdateable())
            update thisyear;    
            
            
        if(lastyear.id == null)
                    if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isCreateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.isCreateable())
            insert lastyear;
        else
                            if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isUpdateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.isUpdateable())
            update lastyear;   
             
             
        if(last2year.id == null)
                    if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isCreateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.isCreateable())
            insert last2year;
        else
                            if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isUpdateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.isUpdateable())
            update last2year;
            
        if(last3year.id == null)
                    if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isCreateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isCreateable() &&
                Schema.sObjectType.AccountKPI__c.isCreateable())
            insert last3year;
        else
                            if(Schema.sObjectType.AccountKPI__c.fields.Account__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.fields.KPI__c.isUpdateable() && 
                Schema.sObjectType.AccountKPI__c.fields.Year__c.isUpdateable() &&
                Schema.sObjectType.AccountKPI__c.isUpdateable())
            update last3year;
    
    }
}