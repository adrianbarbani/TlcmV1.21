public with sharing class AccountGrowthStrategyController {

    public Account account {get;set;}
    public Boolean canEdit {get;set;}
 
    public Id toDel {get;set;}
    
    public List<Strategic_Initiative__c>  localStrategicInitiatives { get; set; }
    public List<Strategic_Initiative__c>  globalStrategicInitiatives { get; set; }
    public List<ExtendedRegion> Regions {get;set;}

    public List<AccountPastProvenValueNewController.ProvenValueWrapper> provenValueWrapperList {get;set;}
    
    public List<Potential_New_Business__c> PotentialNewBusinessList {get;set;}
    public Potential_New_Business__c potentialNewBusiness {get;set;}
    
        public String pnbid {
        get;
        // *** setter is NOT being called ***
        set {
            pnbid = value;
        }
    }
    public String trendid {
        get;
        // *** setter is NOT being called ***
        set {
            trendid = value;
        }
    }

    public String iniciativeid {
        get;
        // *** setter is NOT being called ***
        set {
            iniciativeid = value;
        }
    }
    
    public String pastProventValueid {
        get;
        // *** setter is NOT being called ***
        set {
            pastProventValueid = value;
        }
    }   
  
    public AccountGrowthStrategyController() {        
        if (Util.globalAccount==null) {
        	if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() && Schema.sObjectType.Account.fields.Industry.isAccessible() && Schema.sObjectType.Account.fields.Region__c.isAccessible() && Schema.sObjectType.Account.fields.Micro_Industry__c.isAccessible() && Schema.sObjectType.Account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.Account.fields.Strategic_Context_Last_Update__c.isAccessible() ){
        	account = [SELECT name, id, parentId, Industry, Region__c, /*Sector__C,*/ Micro_Industry__c, Strategic_Context__c, Strategic_Context_Last_Update__c, /*(select id from OpportunityStrategicContext__r),*/ (select name, Potential_New_Business__c, Potential_New_Business__r.Name from Potential_New_Business_Strategic_Cnt__r) FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        	}
        } else {
    		this.account = Util.globalAccount; 
    	}
        
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);                
        init();        
    }
    
    private void init() {
 
        toDel = null;
        
        if(Schema.sObjectType.Strategic_Initiative__c.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.Name.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.title__c.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.Strategic_Initiative__c.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.LastModifiedDate.isAccessible() ){        
        localStrategicInitiatives = [SELECT title__c , name, Strategic_Initiative__c, LastModifiedDate, (select id from Opportunities__r where opportunity__r.accountId = :account.id), (SELECT name, Potential_New_Business__c, Potential_New_Business__r.Name, Potential_New_Business__r.Potential_New_Business__c  FROM Potential_New_Business_Strategic_Ini__r) FROM Strategic_Initiative__c WHERE Account__C = :this.account.id];
        }
        globalStrategicInitiatives = new List<Strategic_Initiative__c>();
 
        provenValueWrapperList = new AccountPastProvenValueNewController().provenValueWrapperList;
        
        Region__c region = Util.getRegionFromAccount(account.Id, account.region__c);
                
        Regions = new List<ExtendedRegion>();
        loadData(region);
                
        if(account.parentId != null) {
            //getDataFromParents([SELECT name, id, parentId, Industry,Region__c, Strategic_Context__c, Strategic_Context_Last_Update__c /*, (select name, Opportunity__c from OpportunityStrategicContext__r)*/ FROM Account WHERE Id = :this.account.parentId]);        
            getDataFromParents();
        }
        if(Schema.sObjectType.Potential_New_Business__c.isAccessible() 
        && Schema.sObjectType.Potential_New_Business__c.fields.Name.isAccessible() 
        && Schema.sObjectType.Potential_New_Business__c.fields.Comments__c.isAccessible() 
        && Schema.sObjectType.Potential_New_Business__c.fields.Contact_to_approach__c.isAccessible()
        && Schema.sObjectType.Potential_New_Business__c.fields.Estimated_FCV__c.isAccessible()
        && Schema.sObjectType.Potential_New_Business__c.fields.Potential_new_Business__c.isAccessible()
        && Schema.sObjectType.Potential_New_Business__c.fields.Status__c.isAccessible() ){
        PotentialNewBusinessList = [select id, Name, Comments__c, Contact_to_approach__c, Estimated_FCV__c, Potential_new_Business__c, Status__c, (SELECT Industry_Trend__c, Industry_Trend__r.name, Industry_Trend__r.Trend__c FROM Potential_New_Business_Trend__r), (SELECT Strategic_Initiative__c, Strategic_Initiative__r.name, Strategic_Initiative__r.Strategic_Initiative__c FROM Potential_New_Business_Strategic_Ini__r ORDER BY Strategic_Initiative__r.name DESC), (select Past_Proven_Value__c, Past_Proven_Value__r.Name, Past_Proven_Value__r.Unique_Value__c from Potential_New_Business_Past_Provent__r) from Potential_New_Business__c where account__c = :account.id];
        }
        
        potentialNewBusiness = new  Potential_New_Business__c(Account__c = account.id); 
    }
    
    public void loadData(Region__c region){
    	        
        Map<Id, Region__c> regionsMap = new Map<Id, Region__c>();
        List<Region__c> regiones = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.parent__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible() ){
        regiones = [select id, Name, parent__c from Region__c limit 1000];
        }
        
        for (Region__c reg :regiones) {
        	regionsMap.put(reg.id,reg);        	
        } 
        
        List<Region__c> regionsToSerch = new List<Region__c>();
        Id regionId = region.id;
        
        while (regionId != null) {
        	Region__c r = regionsMap.get(regionId);
        	regionsToSerch.add(r);
        	regionId = r.parent__c;
        }
        
        List< Industry_Trend__c > Trends = new List< Industry_Trend__c >();
        
        if(Schema.sObjectType.Industry_Trend__c.isAccessible() 
        && Schema.sObjectType.Industry_Trend__c.fields.LastModifiedDate.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.type__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Title__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Name.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Trend__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.URL_Attachment__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Region__c.isAccessible()){
        Trends = [SELECT LastModifiedDate, type__c, Title__c, Name, Trend__c, URL_Attachment__c, Region__c, 
                                           (SELECT id FROM Opportunities__r WHERE opportunity__r.accountId = :account.id), 
                                           (SELECT name, Potential_New_Business__c, Potential_New_Business__r.name, Potential_New_Business__r.Potential_New_Business__c 
                                            FROM Potential_New_Business_Trend__r) 
                                            FROM Industry_Trend__c 
                                            WHERE Region__c in :regionsToSerch AND 
                                            (Sub_Sector__c = :account.Industry OR Sub_Sector__c = 'Todos' OR Sub_Sector__c = 'All') AND 
                                            (Industry__c = :account.Micro_Industry__c OR Industry__c = 'Todos' OR Industry__c = 'All') AND
                                            (type__c = 'Tendencias' OR type__c = 'Casos de éxito Sectorial') 
                                            ORDER BY Name ASC];
        }
 		Map<Id,List<Industry_Trend__c>> regionTrendsMap = new Map<Id,List<Industry_Trend__c>>();
 		
 		for (Industry_Trend__c trend :Trends) {
 			if (regionTrendsMap.get(trend.Region__c) == null) {
 				regionTrendsMap.put(trend.Region__c, new List<Industry_Trend__c>());
 			}
 			regionTrendsMap.get(trend.Region__c).add(trend);
 		}
 		
 		for (Id regId :regionTrendsMap.keySet()) {			
	        Regions.add(new ExtendedRegion(regionsMap.get(regId),regionTrendsMap.get(regId)));
 		}
    }
    
    public void getDataFromParents() {    	
    	List<Id> parentAccountIds = new List<Id>(); 
    	Account parent = new Account();
    	
    	if (account.parentId != null) {
    		parentAccountIds.add(account.parentId);
    		if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() ){
    		parent = [select id, Name, parentId, parent.parentId from account where id = :account.parentId];
    		}
    		if (parent.parentId != null) {
    			parentAccountIds.add(parent.parentId);
    			if (parent.parent.parentId != null) {
    				parentAccountIds.add(parent.parent.parentId);	
    			}	
    		}
    	}
    	
    	List<Strategic_Initiative__c> temp = new List<Strategic_Initiative__c>();
    	
    	if(Schema.sObjectType.Strategic_Initiative__c.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.Title__c.isAccessible()
    	&& Schema.sObjectType.Strategic_Initiative__c.fields.Name.isAccessible()
    	&& Schema.sObjectType.Strategic_Initiative__c.fields.Strategic_Initiative__c.isAccessible()
    	&& Schema.sObjectType.Strategic_Initiative__c.fields.LastModifiedDate.isAccessible()){
    	temp = [SELECT Title__c, name, Strategic_Initiative__c, LastModifiedDate, (select id from Opportunities__r where opportunity__r.accountId = :account.id), (SELECT name, Potential_New_Business__c, Potential_New_Business__r.Name, Potential_New_Business__r.Potential_New_Business__c  FROM Potential_New_Business_Strategic_Ini__r) FROM Strategic_Initiative__c WHERE Account__C in :parentAccountIds];
    	}
                
        if(temp != null) {
            globalStrategicInitiatives.addAll(temp);
        }
    	
    }
    
    public PageReference save() {
        try {
            if(Schema.sObjectType.Potential_New_Business__c.isUpdateable() 
        && Schema.sObjectType.Potential_New_Business__c.fields.Comments__c.isUpdateable() 
        && Schema.sObjectType.Potential_New_Business__c.fields.Contact_to_approach__c.isUpdateable()
        && Schema.sObjectType.Potential_New_Business__c.fields.Estimated_FCV__c.isUpdateable()
        && Schema.sObjectType.Potential_New_Business__c.fields.Potential_new_Business__c.isUpdateable()
        && Schema.sObjectType.Potential_New_Business__c.fields.Status__c.isUpdateable() ){
	        update PotentialNewBusinessList;
        }
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        init();
        return null;        
    }
    
    public PageReference add() {
        try {
            
            if(Schema.sObjectType.Potential_New_Business__c.isUpdateable() 

               && Schema.sObjectType.Potential_New_Business__c.fields.Comments__c.isUpdateable() 
               && Schema.sObjectType.Potential_New_Business__c.fields.Contact_to_approach__c.isUpdateable()
               && Schema.sObjectType.Potential_New_Business__c.fields.Estimated_FCV__c.isUpdateable()
               && Schema.sObjectType.Potential_New_Business__c.fields.Potential_new_Business__c.isUpdateable()
               && Schema.sObjectType.Potential_New_Business__c.fields.Status__c.isUpdateable()
               && Schema.sObjectType.Potential_New_Business__c.isCreateable() 

               && Schema.sObjectType.Potential_New_Business__c.fields.Comments__c.isCreateable() 
               && Schema.sObjectType.Potential_New_Business__c.fields.Contact_to_approach__c.isCreateable()
               && Schema.sObjectType.Potential_New_Business__c.fields.Estimated_FCV__c.isCreateable()
               && Schema.sObjectType.Potential_New_Business__c.fields.Potential_new_Business__c.isCreateable()
               && Schema.sObjectType.Potential_New_Business__c.fields.Status__c.isCreateable() ){
					upsert potentialNewBusiness;
               }
	        
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        init();
        return null;        
    }
    
    public PageReference linkTrend() {        
        try {
            
            if(Schema.sObjectType.Potential_New_Business_Trend__c.fields.Industry_Trend__c.isCreateable() &&
            Schema.sObjectType.Potential_New_Business_Trend__c.fields.Potential_New_Business__c.isCreateable() &&
            Schema.sObjectType.Potential_New_Business_Trend__c.isCreateable()){
	            insert new Potential_New_Business_Trend__c(Industry_Trend__c = trendid, Potential_New_Business__c = pnbid);
            }
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        save();
        return null;
    }

    public PageReference linkIniciative() {
        try {
            
            if(Schema.sObjectType.Potential_New_Business_Strategic_Ini__c.fields.Strategic_Initiative__c.isCreateable() &&
            Schema.sObjectType.Potential_New_Business_Strategic_Ini__c.fields.Potential_New_Business__c.isCreateable() &&
            Schema.sObjectType.Potential_New_Business_Strategic_Ini__c.isCreateable()){
	            insert new Potential_New_Business_Strategic_Ini__c(Strategic_Initiative__c = iniciativeid, Potential_New_Business__c = pnbid);
            }
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        save();        
        return null;
    }
    
    public PageReference linkPastProventValue() {
        try {
            
            if(Schema.sObjectType.Potential_New_Business_Past_Provent__c.fields.Past_Proven_Value__c.isCreateable() &&
            Schema.sObjectType.Potential_New_Business_Past_Provent__c.fields.Potential_New_Business__c.isCreateable() &&
            Schema.sObjectType.Potential_New_Business_Past_Provent__c.isCreateable()){
	            insert new Potential_New_Business_Past_Provent__c(Past_Proven_Value__c = pastProventValueid, Potential_New_Business__c = pnbid);
            }
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        save();
        return null;
    }
   
    public PageReference unlinkTrend() {
        try {
	        
           Potential_New_Business_Trend__c aBorrar = new Potential_New_Business_Trend__c();
           if(Schema.sObjectType.Potential_New_Business_Trend__c.isAccessible()){
           aBorrar = [SELECT id FROM Potential_New_Business_Trend__c WHERE id = :trendid];
           }
           if(Potential_New_Business_Trend__c.sObjectType.getDescribe().isDeletable()){
                delete aBorrar;
            }
        
        
        
        } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        save();
        return null;
    }
    
    
    
    
	
    public PageReference unlinkIniciative() {
        try {
	        
           Potential_New_Business_Strategic_Ini__c aBorrar = new Potential_New_Business_Strategic_Ini__c();
          if(Schema.sObjectType.Potential_New_Business_Strategic_Ini__c.isAccessible()){
           aBorrar = [SELECT id FROM Potential_New_Business_Strategic_Ini__c WHERE id = :iniciativeid];
          }
           if(Potential_New_Business_Strategic_Ini__c.sObjectType.getDescribe().isDeletable()){
               delete aBorrar;
           }
                      
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        save();
        return null;
    }
    
    public PageReference unlinkPastProventValue() {
        try {
	        
           Potential_New_Business_Past_Provent__c aBorrar = new Potential_New_Business_Past_Provent__c();
            if(Schema.sObjectType.Potential_New_Business_Past_Provent__c.isAccessible()){
           aBorrar = [SELECT id FROM Potential_New_Business_Past_Provent__c WHERE id = :pastProventValueid];
            }
           if(Potential_New_Business_Past_Provent__c.sObjectType.getDescribe().isDeletable()){
               delete aBorrar;
           }
           
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        save();
        return null;
    }
   
    public PageReference ExportToExcel() {      
        save();
        return Page.accountGrowthStrategyExcel;
    }
    
    public String getExcelName() {
        String name = account.Name + '-' + Label.GAP_Growth_Strategy + '.xls';
        return name.replaceAll(' ', '_').replaceAll(',','');
    }
     
}