public with sharing class AccountPastProvenValueNewController {
	
	public Account account {get;set;}
	public Boolean canEdit {get;set;}
	public List<PastProvenValueNew__c> pastProvenValueNewList {get;set;}	
	public String toDel {get;set;}
	public List<ProvenValueWrapper> provenValueWrapperList {get;set;}
	public PastProvenValueNew__c newProvenValue {get;set;}	
	
	public AccountPastProvenValueNewController() {        
        if (Util.globalAccount==null) {
        	if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
        	&& Schema.sObjectType.Account.fields.parentId.isAccessible()
        	&& Schema.sObjectType.Account.fields.Industry.isAccessible()
        	&& Schema.sObjectType.Account.fields.Region__c.isAccessible()
        	&& Schema.sObjectType.Account.fields.micro_industry__c.isAccessible()){
        	account = [SELECT id, Name, parentId, Industry, micro_industry__c, Region__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];}    
        } else {
    		this.account = Util.globalAccount; 
    	}
    	
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);                
        init();        
    }

	private void init() {
	
		newProvenValue = new PastProvenValueNew__c(account__c = account.id);
		
		pastProvenValueNewList = new List<PastProvenValueNew__c>();
		
		provenValueWrapperList = new List<ProvenValueWrapper>();	
		if (account.parentId != null) {
			List<Id> accountIdList = new List<Id>();
			List<account> accents = new List<account>();
		    
		    if(Schema.sObjectType.Account.isAccessible() ){	
		   	accents = [select id from account where (id = :account.parentId or parentId = :account.parentId) and id != :account.id];
		}
			for (Account acc : accents) {
				accountIdList.add(acc.id);				
			}
			
			List<PastProvenValueNew__c> valuesnewx = new List<PastProvenValueNew__c>();
			
			if(Schema.sObjectType.PastProvenValueNew__c.isAccessible() && Schema.sObjectType.PastProvenValueNew__c.fields.Name.isAccessible()
			&& Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isAccessible()
			&& Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isAccessible()
			&& Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isAccessible()
			&& Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isAccessible()
			&& Schema.sObjectType.PastProvenValueNew__c.fields.LastModifiedDate.isAccessible()){
			valuesnewx = [select id, name, account__c, Unique_Value__c, type__c, region__c, account__r.Name, LastModifiedDate, (SELECT name, Opportunity__c, Opportunity__r.Name FROM OpportunityPastProvenValueNew__r WHERE Opportunity__r.Account.id = :this.account.id), (SELECT name, Potential_New_Business__c, Potential_New_Business__r.Name, Potential_New_Business__r.Potential_New_Business__c  FROM Potential_New_Business_Past_Provent__r) from PastProvenValueNew__c where account__c in :accountIdList];}
			
			for (PastProvenValueNew__c p :valuesnewx) {
				provenValueWrapperList.add(new ProvenValueWrapper(p,p.account__r.Name,false));
			}	
		}
		
		Region__c region = Util.getRegionFromAccount(account.Id, account.region__c);		
		        
        loadProvenValueRegion(region, account.industry, account.micro_industry__c);
		
		List<PastProvenValueNew__c> valuesnewx2 = new List<PastProvenValueNew__c>();
		
		if(Schema.sObjectType.PastProvenValueNew__c.isAccessible() && Schema.sObjectType.PastProvenValueNew__c.fields.Name.isAccessible()
		&& Schema.sObjectType.PastProvenValueNew__c.fields.title__c.isAccessible()
		&& Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isAccessible()
		&& Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isAccessible()
		&& Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isAccessible()
		&& Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isAccessible()
		&& Schema.sObjectType.PastProvenValueNew__c.fields.LastModifiedDate.isAccessible()){
		valuesnewx2 = [select id, title__c, name, account__c, Unique_Value__c, type__c, region__c, LastModifiedDate, (SELECT name, Opportunity__c, Opportunity__r.Name FROM OpportunityPastProvenValueNew__r WHERE Opportunity__r.Account.id = :this.account.id), (SELECT name, Potential_New_Business__c, Potential_New_Business__r.Name, Potential_New_Business__r.Potential_New_Business__c  FROM Potential_New_Business_Past_Provent__r) from PastProvenValueNew__c where account__c = :account.id];}
		
		for (PastProvenValueNew__c p :valuesnewx2) {
			provenValueWrapperList.add(new ProvenValueWrapper(p,account.Name,true));
			pastProvenValueNewList.add(p);
		}
				
	}
	
	private void loadProvenValueRegion(Region__c region, String industry, String micro_industry) {
		
		Map<Id, Region__c> regionsMap = new Map<Id, Region__c>();
        List<Region__c> regionesx = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible()
        && Schema.sObjectType.Region__c.fields.parent__c.isAccessible()){
        regionesx = [select id, Name, parent__c from Region__c limit 1000];}
        
        for (Region__c reg : regionesx) {
        	regionsMap.put(reg.id,reg);        	
        } 
        
        List<Region__c> regionsToSerch = new List<Region__c>();
        Id regionId = region.id;
        
        while (regionId != null) {
        	Region__c r = regionsMap.get(regionId);
        	regionsToSerch.add(r);
        	regionId = r.parent__c;
        }
        
        List<PastProvenValueNew__c> provenvalueneewX = new List<PastProvenValueNew__c>();
        
        if(Schema.sObjectType.PastProvenValueNew__c.isAccessible() && Schema.sObjectType.PastProvenValueNew__c.fields.Name.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.industry__c.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.micro_industry__c.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isAccessible()
        && Schema.sObjectType.PastProvenValueNew__c.fields.LastModifiedDate.isAccessible()){
        provenvalueneewX = [select id, name, account__c, Unique_Value__c, type__c, industry__c, micro_industry__c, region__c, region__r.Name, LastModifiedDate, (SELECT name, Opportunity__c, Opportunity__r.Name FROM OpportunityPastProvenValueNew__r WHERE Opportunity__r.Account.id = :this.account.id), (SELECT name, Potential_New_Business__c, Potential_New_Business__r.Name, Potential_New_Business__r.Potential_New_Business__c  FROM Potential_New_Business_Past_Provent__r) from PastProvenValueNew__c where (industry__c = :industry or industry__c = 'All' or industry__c = 'Todos') and (micro_industry__c = :micro_industry or micro_industry__c = 'All' or micro_industry__c = 'Todos') and region__c in :regionsToSerch];}
        
        for (PastProvenValueNew__c p :provenvalueneewX) {
			provenValueWrapperList.add(new ProvenValueWrapper(p,p.region__r.Name+' ('+p.industry__c+' - '+ p.micro_industry__c +')',false));
		}
	}
	
	public PageReference add() {
		try {
		    if(Schema.sObjectType.PastProvenValueNew__c.fields.Account__c.isCreateable() &&
	        Schema.sObjectType.PastProvenValueNew__c.isCreateable()){
			    insert newProvenValue;
	        }
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
		init();
		return null;
	}
	
	public PageReference save() {
		boolean errors = false;
		
		for (PastProvenValueNew__c past :pastProvenValueNewList) {
			if (past.type__c == null) {
				errors = true;
				past.type__c.addError('Debe escribir un valor');
			}
		}
		
		if (!errors) { 
			try {
			    
                system.debug(Schema.sObjectType.PastProvenValueNew__c.isCreateable());
                system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.title__c.isCreateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.name.isCreateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isCreateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isCreateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isCreateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isCreateable());
				//system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.LastModifiedDate.isCreateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.isUpdateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.title__c.isUpdateable());
				//system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.name.isUpdateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isUpdateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isUpdateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isUpdateable());
				system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isUpdateable());
                //system.debug( Schema.sObjectType.PastProvenValueNew__c.fields.LastModifiedDate.isUpdateable());
				
                
                if(Schema.sObjectType.PastProvenValueNew__c.isCreateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.title__c.isCreateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isCreateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isCreateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isCreateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isCreateable()

                   && Schema.sObjectType.PastProvenValueNew__c.isUpdateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.title__c.isUpdateable()

                   && Schema.sObjectType.PastProvenValueNew__c.fields.account__c.isUpdateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isUpdateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.type__c.isUpdateable()
                   && Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isUpdateable()){
                       upsert pastProvenValueNewList;
                   }
                
		    } catch(DmlException ex){
		        ApexPages.addMessages(ex);
		    }
			init();
		}
		
		return null;		
	}
	
	public PageReference del() { 
		try {
			PastProvenValueNew__c aBorrar = new PastProvenValueNew__c();
			
			if(Schema.sObjectType.PastProvenValueNew__c.isAccessible()){
           aBorrar = [select id from PastProvenValueNew__c where id = :toDel];}
          
            if (!PastProvenValueNew__c.sObjectType.getDescribe().isDeletable()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                           'Acceso insuficiente.')); 
                return null;
            }
            
           if(PastProvenValueNew__c.sObjectType.getDescribe().isDeletable()){
               delete aBorrar;
           }
            
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }			   	
    	init();
    	return null;
    }
    
    public PageReference ExportToExcel() { 
		save();   	
    	return Page.accountPastProvenValueNewExcel;
    }
    
    public String getExcelName() {
    	String name = account.Name + '-' + Organization.Name + ' ' + Label.account_past_proven_value + '.xls';
    	return name.replaceAll(' ', '_').replaceAll(',','');
    }
        
    public class ProvenValueWrapper {
    	public PastProvenValueNew__c provenValue {get;set;}
    	public String source {get;set;}
    	public Boolean canEdit {get;set;}
    
    	public ProvenValueWrapper(PastProvenValueNew__c p, String s, Boolean c) {
    		provenValue = p;
    		source = s.replace('Todos - Todos', 'Todos').replace('All - All', 'All');	
    		canEdit = c;
    	}
    		
    }
	
}