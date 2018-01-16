public with sharing class accountIndustryTrendsNew {
	
	public List<Industry_Trend__c> trends {get;set;}
	public Boolean canEdit {get;set;}
	public Account account {get;set;}
	public List<TrendsWrapper> trendsWrapperList {get;set;}
    public List<SolutionWrapper> Solutions {get; set;}
    public String SolutionsLabel {get; set;}
    
	public accountIndustryTrendsNew(){
        loadData();
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        
        canEdit = temp.checkWrite(this.account.id);
    }
    
    public void loadData(){
    	if (Util.globalAccount==null) {
        	if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
        	&& Schema.sObjectType.Account.fields.parentId.isAccessible()
        	&& Schema.sObjectType.Account.fields.Industry.isAccessible()
        	&& Schema.sObjectType.Account.fields.Region__c.isAccessible()
        	&& Schema.sObjectType.Account.fields.Sector__C.isAccessible()
        	&& Schema.sObjectType.Account.fields.Micro_Industry__c.isAccessible()
        	&& Schema.sObjectType.Account.fields.Strategic_Context_Last_Update__c.isAccessible()
        	&& Schema.sObjectType.Account.fields.Strategic_Context__c.isAccessible()){
        	account = [SELECT name, id, parentId, Segmento_Vertical__c, Industry, Region__c, Sector__C, Micro_Industry__c, Strategic_Context__c, Strategic_Context_Last_Update__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        	}
        	    
        } else {
    		account = Util.globalAccount; 
    	}

       
       system.debug(account);
        	
        List<Schema.PicklistEntry> Types = Industry_Trend__c.Type__c.getDescribe().getPicklistValues();
        system.debug(Types);
    	trendsWrapperList = new List<TrendsWrapper>();
        Map<String, TrendsWrapper> trendsMap = new Map<String, TrendsWrapper>();
        Map<String, String> TypeValToLabel = new Map<String, String>();
        for (Schema.PicklistEntry pe : Types) {
            if(pe.getValue() != 'Soluciones') {
                TrendsWrapper tw = new TrendsWrapper(pe.getLabel());
    			trendsMap.put(pe.getLabel(), tw);
    			trendsWrapperList.add(tw);
            }
            TypeValToLabel.put(pe.getValue(), pe.getLabel());
        }
    	List<Id> regionsIds = Util.getParentsRegions(Util.getRegionFromAccount(account.Id, account.region__c));    	
    	
    	List<Industry_Trend__c> trendsX = new List<Industry_Trend__c>();
    	
    	
    	if(Schema.sObjectType.Industry_Trend__c.isAccessible() && Schema.sObjectType.Industry_Trend__c.fields.Region__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.LastModifiedDate.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.RelatedTo__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.Name.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.Trend__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.URL_Attachment__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.title__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.type__c.isAccessible()
    	){
    	
    	trendsX =[SELECT Region__c, Region__r.Name, LastModifiedDate, RelatedTo__c, RelatedTo__r.title__c, RelatedTo__r.Trend__c,
                           Name, Trend__c, URL_Attachment__c, title__c, type__c
                                       FROM Industry_Trend__c 
                                       WHERE Region__c in :regionsIds AND 
                                       		 (Sub_Sector__c = :account.Segmento_Vertical__c OR Sub_Sector__c = 'Todos' OR Sub_Sector__c = 'All') AND 
                                       		(Industry__c = :account.Micro_Industry__c OR Industry__c = 'Todos' OR Industry__c = 'All') AND
                                       		Type__c != 'Soluciones'
                                       ORDER BY Name ASC
                                       ];
    	}                             
    	
        for (Industry_Trend__c trend :trendsX) {
    		
           if(trendsMap.get(TypeValToLabel.get(trend.type__c)) != null){                               
               
               trendsMap.get(TypeValToLabel.get(trend.type__c)).trends.add(trend);
           }
    	}
        
        Solutions = new List<SolutionWrapper>();
        
        List<Industry_trend__c> solucionesX = new  List<Industry_trend__c>();
        
        if(Schema.sObjectType.Industry_Trend__c.isAccessible() && Schema.sObjectType.Industry_Trend__c.fields.Region__c.isAccessible()
         && Schema.sObjectType.Industry_Trend__c.fields.LastModifiedDate.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.RelatedTo__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.Name.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.Trend__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.URL_Attachment__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.title__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.type__c.isAccessible()
                ){
        
        solucionesX = [SELECT Region__c, Region__r.Name, LastModifiedDate, RelatedTo__c, RelatedTo__r.title__c, RelatedTo__r.Trend__c, RelatedTo__r.RelatedTo__r.title__c, RelatedTo__r.RelatedTo__r.Trend__c,
                           	Name, Trend__c, URL_Attachment__c, title__c, type__c, 
                                       		(SELECT 
                                             	name, Opportunity__c, Opportunity__r.name 
                                             FROM Opportunities__R  
                                             WHERE Opportunity__r.Account.id = :account.id AND 
                                             	Opportunity__r.stagename != 'Closed Won' AND 
                                             	Opportunity__r.stagename != 'Closed Lost') , 
                                       		(SELECT
                                             	Name, Current_state__c, Industry_Trend__c
                                             FROM Accounts_Industry_Trends__r
                                             WHERE Account__r.Id = :account.Id)
                                       	FROM Industry_Trend__c 
                                       	WHERE Region__c in :regionsIds AND 
                                       		(Sub_Sector__c = :account.Segmento_Vertical__c OR Sub_Sector__c = 'Todos' OR Sub_Sector__c = 'All') AND 
                                       		(Industry__c = :account.Micro_Industry__c OR Industry__c = 'Todos' OR Industry__c = 'All') AND
                                       		Type__c = 'Soluciones'
       									ORDER BY Name ASC];
        }							
        
        for(Industry_trend__c solution : solucionesX) {
            SolutionWrapper sw = new SolutionWrapper();
            if(solution.Accounts_Industry_Trends__r.size() == 0) {
                sw.Status = new Account_Industry_Trend__c(Industry_Trend__c = solution.Id, Account__c = account.Id);
            }
            else {
                sw.Status = solution.Accounts_Industry_Trends__r[0];
            }
            sw.Trend = solution;
            Solutions.add(sw);
        }
        SolutionsLabel = TypeValToLabel.get('Soluciones');
    }
    
    public PageReference save() {
        if(canEdit) {
            List<Account_Industry_Trend__c> acInTrs = new List<Account_Industry_Trend__c>();
            for(SolutionWrapper sw : Solutions) {
                acInTrs.add(sw.Status);
            }
            try {
                if(Schema.sObjectType.Account_Industry_Trend__c.isCreateable()
                && Schema.sObjectType.Account_Industry_Trend__c.fields.Industry_Trend__c.isCreateable()
                && Schema.sObjectType.Account_Industry_Trend__c.fields.Account__c.isCreateable()
                && Schema.sObjectType.Account_Industry_Trend__c.isUpdateable()
                && Schema.sObjectType.Account_Industry_Trend__c.fields.Industry_Trend__c.isUpdateable()
                && Schema.sObjectType.Account_Industry_Trend__c.fields.Account__c.isUpdateable())
                upsert acInTrs;
            } catch(DmlException ex){
                ApexPages.addMessages(ex);
            }
        }
        return null;
    }
    
    public PageReference ExportToExcel() {
    	return Page.accountIndustryTrendsExcel;
    	return null;
    }
 	
 	public String getExcelName() {
    	String name = account.Name + '-' + Label.Trend + '.xls';
    	return name.replaceAll(' ', '_').replaceAll(',','');
    }
	
    class SolutionWrapper {
        public Industry_Trend__c Trend {get; set;}
        public Account_Industry_Trend__c Status {get; set;}
    }
    
	class TrendsWrapper {
		
		public String type {get;set;}
        public String typeClass {get;set;}
		public List<Industry_Trend__c> trends {get;set;}
		
		public trendsWrapper(String t) {
			type = t;
            if (t == Label.Principales_players) {
                typeClass = 'Pla';
            } 
            
            if (t == Label.Tendencias) {
                typeClass = 'Ten';
            }
            
            if (t == Label.Casos_exito_sectorial) {
                typeClass = 'Cas';
            }
            
            if (t == Label.Metricas_analisis_mercado) {
                typeClass = 'Mét';
            }
            
            if (t == Label.Contexto_General) {
                typeClass = 'Con';
            }
            
            if (t == Label.Cadena_valor_procesos) {
                typeClass = 'Cad';
            }
            
            //else {
                //typeClass = t.substring(0, 3);
            //}
            
			trends = new List<Industry_Trend__c>();
		}
		
	}
	
}