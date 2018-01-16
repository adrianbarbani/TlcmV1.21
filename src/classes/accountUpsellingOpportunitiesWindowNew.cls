public with sharing class accountUpsellingOpportunitiesWindowNew {
    
    public Account account { get; set; }
    public Date now {get; set;}
    public Boolean canEdit {get;set;}
    public List<Contract> ourContracts {get;set;}
    public List<Contract> competitorContracts {get;set;} 
    
    public accountUpsellingOpportunitiesWindowNew() {
        this.now = Date.today();
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
        && Schema.sObjectType.Account.fields.parentId.isAccessible()
        && Schema.sObjectType.Account.fields.Industry.isAccessible()
        && Schema.sObjectType.Account.fields.Region__c.isAccessible()
        ){
        this.account = [SELECT name, id, parentId, Industry, Region__c, Region__r.Currency__c, Region__r.Currency_Name__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        ourContracts = new List<Contract>();
        competitorContracts = new List<Contract>(); 
        
        if(Schema.sObjectType.Contract.fields.ContractNumber.isAccessible()
        && Schema.sObjectType.Contract.fields.description.isAccessible()
        && Schema.sObjectType.Contract.fields.StartDate.isAccessible()
        && Schema.sObjectType.Contract.fields.ContractTerm.isAccessible()
        && Schema.sObjectType.Contract.fields.EndDate.isAccessible()
        && Schema.sObjectType.Contract.fields.mrc__c.isAccessible()
        && Schema.sObjectType.Contract.fields.fcv__c.isAccessible()
        && Schema.sObjectType.Contract.fields.competitorName__c.isAccessible()
        && Schema.sObjectType.Contract.fields.isCompetitorContract__c.isAccessible()
        && Schema.sObjectType.Contract.isAccessible()){
        
        List<Contract> contrects = new List<Contract>();
        
        if(Schema.sObjectType.Contract.isAccessible() && Schema.sObjectType.Contract.fields.ContractNumber.isAccessible()
        && Schema.sObjectType.Contract.fields.description.isAccessible()
        && Schema.sObjectType.Contract.fields.StartDate.isAccessible()
        && Schema.sObjectType.Contract.fields.ContractTerm.isAccessible()
        && Schema.sObjectType.Contract.fields.EndDate.isAccessible()
        && Schema.sObjectType.Contract.fields.mrc__c.isAccessible()
        && Schema.sObjectType.Contract.fields.fcv__c.isAccessible()
        && Schema.sObjectType.Contract.fields.competitorName__c.isAccessible()
        && Schema.sObjectType.Contract.fields.isCompetitorContract__c.isAccessible()
        ){
        contrects = [select id, ContractNumber, description, StartDate, ContractTerm, EndDate, mrc__c, fcv__c, competitorName__c, isCompetitorContract__c from Contract where accountid = :account.id];
        }
        
        for (Contract c :contrects) {
            if (!c.isCompetitorContract__c) {
                ourContracts.add(c);
            } else {
                competitorContracts.add(c);
            }               
        }       
        }
        
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
    }
    
    public PageReference SaveChanges() {
        
        if(Schema.sObjectType.Contract.fields.ContractNumber.isUpdateable()
        && Schema.sObjectType.Contract.fields.description.isUpdateable()
        && Schema.sObjectType.Contract.fields.StartDate.isUpdateable()
        && Schema.sObjectType.Contract.fields.ContractTerm.isUpdateable()
        && Schema.sObjectType.Contract.fields.EndDate.isUpdateable()
        && Schema.sObjectType.Contract.fields.mrc__c.isUpdateable()
        && Schema.sObjectType.Contract.fields.fcv__c.isUpdateable()
        && Schema.sObjectType.Contract.fields.competitorName__c.isUpdateable()
        && Schema.sObjectType.Contract.fields.isCompetitorContract__c.isUpdateable()
        && Schema.sObjectType.Contract.isUpdateable()){
            update ourContracts;
            update competitorContracts;
        }
        return null;
    }
}