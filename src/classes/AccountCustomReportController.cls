public with sharing class AccountCustomReportController {
    
    public Account account {get;set;}
    public Boolean canEdit {get;set;}
    public CustomReport__c customReport {get;set;}
    
    public AccountCustomReportController() {        
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() && Schema.sObjectType.Account.fields.Industry.isAccessible() && Schema.sObjectType.Account.fields.Region__c.isAccessible() && Schema.sObjectType.Account.fields.Sector__C.isAccessible() && Schema.sObjectType.Account.fields.Micro_Industry__c.isAccessible() && Schema.sObjectType.Account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.Account.fields.Strategic_Context_Last_Update__c.isAccessible() && Schema.sObjectType.Account.fields.Buying_Criteria__c.isAccessible()  && Schema.sObjectType.Account.fields.Region__c.isAccessible() ){
        account = [SELECT name, id, parentId, Industry, Region__c, Sector__C, Micro_Industry__c, Strategic_Context__c, Strategic_Context_Last_Update__c, Buying_Criteria__c, parent.Name, Region__r.Currency__c, Region__r.Currency_Name__c, (select name, Potential_New_Business__c, Potential_New_Business__r.Name from Potential_New_Business_Strategic_Cnt__r) FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];    
        }
        
        Util.globalAccount = account;
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Custom_Report_Msg));                
        init();        
    }
    
    private void init() {
        
        List<CustomReport__c> customReportList = new List<CustomReport__c>();
        
        if(Schema.sObjectType.CustomReport__c.isAccessible() && Schema.sObjectType.CustomReport__c.fields.account__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.industryTrend__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.clientContext__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.kpi__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.competitors__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.netActivity__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.influenceMap__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.provenValue__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.valueDrivers__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.growthStrategy__c.isAccessible()  && Schema.sObjectType.CustomReport__c.fields.actionPlan__c.isAccessible()  ){
        customReportList = [select id, account__c, industryTrend__c, clientContext__c, kpi__c, competitors__c, netActivity__c, influenceMap__c, provenValue__c, valueDrivers__c, growthStrategy__c, actionPlan__c from CustomReport__c where account__c = :account.id];   
        }
        
        
        
        if (customReportList.size() > 0) {
            customReport = customReportList.get(0);
        } else {
            customReport = new CustomReport__c(account__c = account.id);
        }
    }
    
    public PageReference save() {
        try {
            if(Schema.sObjectType.CustomReport__c.fields.account__c.isCreateable()
            && Schema.sObjectType.CustomReport__c.isCreateable()
            && Schema.sObjectType.CustomReport__c.fields.account__c.isUpdateable()
            && Schema.sObjectType.CustomReport__c.isUpdateable())
	        upsert customReport;
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        init();
        return null;        
    }
    
    public PageReference ExportToWord() {      
        save();
        return Page.accountCustomReportWord;
    }
    
    public String getWordName() {
        String name = account.Name + '-' + Label.Custom_Report + '.doc';
        return name.replaceAll(' ', '_').replaceAll(',','');
    }

}