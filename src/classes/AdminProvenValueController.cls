public with sharing class AdminProvenValueController {
    
    public List<PastProvenValueNew__c> ProvenValueList {get;set;}
    public String regionId { get; set;}
    public String industry { get; set; }
    public String micro_industry { get; set; }
    public String IdtoDelete {get; set;}
    public PastProvenValueNew__c newPruvenValue {get;set;}
    public Boolean canEdit {get;set;}
    public Account tempAccount{get;set;}
    
    public AdminProvenValueController() {
        init();
    }
    
    private void init() {
        newPruvenValue = new PastProvenValueNew__c();
        ProvenValueList = new List<PastProvenValueNew__c>();
        tempAccount = new Account();
    }
    
    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();

        List<Region__c> temp = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible() ){
        temp =  [SELECT Name,Id From Region__c ORDER BY name ASC limit 1000];
        }
        
       for( Region__c c : temp) {
          options.add(new SelectOption(c.Id,c.Name));
       }  
       return options;
        
    }
    
    public List<SelectOption> getIndustries(){
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple) {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }
       options.add(new SelectOption('All', 'All'));       
       return options;
    }
    
    public List<SelectOption> getMicro_Industries(){
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Account.Micro_Industry__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple) {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }
       options.add(new SelectOption('All', 'All'));       
       return options;
    }
    
    public List<SelectOption> getProvenValueTypes() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption(Label.Industry_Offering,Label.Industry_Offering));
        options.add(new SelectOption(Label.Industry_Success_Stories,Label.Industry_Success_Stories));
        options.add(new SelectOption(Label.Industry_Competitive_Differenciators,Label.Industry_Competitive_Differenciators));
        
        return options;
    }
    
    public PageReference save(){
        
        if(Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isUpdateable()
        && Schema.sObjectType.PastProvenValueNew__c.fields.Type__c.isUpdateable()
        && Schema.sObjectType.PastProvenValueNew__c.isUpdateable())
    	Update ProvenValueList;
    	return null;
    }
    
    public void doUpdate() {
        
        if (tempAccount.Industry == 'Todos') {
        	tempAccount.Micro_Industry__c = 'Todos';
        } else if ( tempAccount.Industry == 'All') {
        	tempAccount.Micro_Industry__c = 'All';
        }
       	        
        if (Schema.sObjectType.PastProvenValueNew__c.fields.region__c.isCreateable()){
            newPruvenValue.region__c = regionId;}
        //newPruvenValue.Industry__c = industry;
        if (Schema.sObjectType.PastProvenValueNew__c.fields.Industry__c.isCreateable()){
            newPruvenValue.Industry__c = tempAccount.Industry;}
        if (Schema.sObjectType.PastProvenValueNew__c.fields.Micro_Industry__c.isCreateable()){
            newPruvenValue.Micro_Industry__c = tempAccount.micro_industry__c;}
        canEdit = false;
        
        List<Region__Share> tempedit = new List<Region__Share>();
        
        if(Schema.sObjectType.Region__Share.isAccessible()){
        tempedit = [select Id from Region__Share WHERE (AccessLevel = 'Edit' OR AccessLevel = 'All') AND ParentId =:regionId AND UserOrGroupId =:UserInfo.getUserId()];
        }
        
        if(tempedit.size() > 0)
            canEdit = true;
        else
            canEdit = false;
        
        if (regionId == null || regionId == '' || tempAccount.Industry == null || tempAccount.Industry == '' || tempAccount.Micro_Industry__c == null || tempAccount.Micro_Industry__c == '') {
            canEdit = false;
        }
        
        if(Schema.sObjectType.PastProvenValueNew__c.isAccessible() && Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isAccessible()
         && Schema.sObjectType.PastProvenValueNew__c.fields.Type__c.isAccessible()){
        ProvenValueList = [select id, Unique_Value__c, Type__c from PastProvenValueNew__c where region__c = :regionId and industry__c = :tempAccount.industry and micro_industry__c = :tempAccount.micro_industry__c];
        }
            
        }
    
    public PageReference InsertNew() {        
        if (newPruvenValue.Type__c != null && newPruvenValue.Unique_Value__c != null) {
            try {
                
                if (Schema.sObjectType.PastProvenValueNew__c.isCreateable()){
                    insert newPruvenValue;
                }
                
            } catch(DmlException ex){
		        ApexPages.addMessages(ex);
		    }
            newPruvenValue = new PastProvenValueNew__c();           
            doUpdate();
        }
        return null;
    }
    
    public PageReference del(){
        
        List<PastProvenValueNew__c> provenValue = new List<PastProvenValueNew__c>();
        if(Schema.sObjectType.PastProvenValueNew__c.isAccessible()){
        provenValue = [select id from PastProvenValueNew__c where id = :IdtoDelete];}
        try {	
        	if(PastProvenValueNew__c.sObjectType.getDescribe().isDeletable()){
                delete provenValue;
            }
        } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        doUpdate();
        return null;
    }
}