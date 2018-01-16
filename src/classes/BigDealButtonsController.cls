public with sharing class BigDealButtonsController {

	public Opportunity opp {get;set;}
    public Boolean isBigDealAdmin {get;set;}
    public Boolean isLightning {get;set;}    
    public String url {get;set;}
    private Id oppId;    

    public BigDealButtonsController(ApexPages.StandardController stdController) {
        oppId = stdController.getRecord().id;
        init();

        isBigDealAdmin = false;
        List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
        
        if(Schema.sObjectType.PermissionSetAssignment.isAccessible() && Schema.sObjectType.PermissionSetAssignment.fields.PermissionSetId.isAccessible()){
        psaList = [SELECT PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name = 'Big_Deal_Admin'];
        }
        
        if (psaList.size() > 0) {
            system.debug('es Admin big deal');
            isBigDealAdmin = true;
        }

        url = ApexPages.currentPage().getUrl();
        if (url.contains('lightning')) {
            system.debug('es Lightning');
            isLightning = true;
        } else {
            system.debug('No es Lightning');
            isLightning = false;
        }
        
    }

    private void init() {
        if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.bigDeals__c.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Manual_Big_Deal__c.isAccessible()){
        this.opp = [select id, bigDeals__c, Manual_Big_Deal__c from Opportunity where id = :oppId];
        }
    }

    public void check() {
        
        if (Schema.sObjectType.Opportunity.fields.manual_Big_Deal__c.isUpdateable()){
            opp.manual_Big_Deal__c = true;
            update opp;
        }

        init();
    }

    public void uncheck() {
        
        if (Schema.sObjectType.Opportunity.fields.manual_Big_Deal__c.isUpdateable()){
            opp.manual_Big_Deal__c = false;
            update opp;
        }
        
        init();
    }

    public PageReference gotoSurvey() {
        return new PageReference(Page.opportunityBigDeal + '?id=' + opp.id);
    }
}