public with sharing class accountOpportunities {

    private ApexPages.StandardController controller;
    private final Account acct;
    public List<Opportunity> opportunities {get;set;}
    public List<OpportunityWrapper> oppWrappers {get;set;}
    public Boolean canEdit {get;set;}
    public String isoCode {get;set;}

    public accountOpportunities(ApexPages.StandardController controller) {
        
        this.controller = controller;
        this.acct = (Account)controller.getRecord();

        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.acct.id);

        loadOpps();
    }
    
    public void loadOpps(){
    	oppWrappers = new List<OpportunityWrapper>();
    	 
    	if (Util.checkMultiCurrencyEnabled()) {
    		isoCode = UserInfo.getDefaultCurrency()+' ';
	    	
	    	if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
	    	&& Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
	    	&& Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
	    	&& Schema.sObjectType.Opportunity.fields.Amount.isAccessible()
	    	&& Schema.sObjectType.Contact_Assessment__c.isAccessible()){
	    	Opportunities = [SELECT id, Name, Probability, StageName, fcv__c, convertCurrency(Amount), (select id from ContactsAssessments__r) 
    					  FROM Opportunity
                          WHERE accountId = :acct.Id and StageName != 'Cancelled' and StageName != 'Closed Won' and StageName != 'Closed Lost' order by amount desc];}	
    		
    	} else {
    		isoCode = '$';
	    	
	    	if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
	    	&& Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
	    	&& Schema.sObjectType.Opportunity.fields.Amount.isAccessible()
	    	&& Schema.sObjectType.Opportunity.fields.StageName.isAccessible()){
	    	Opportunities = [SELECT id, Name, Probability, StageName, Amount, fcv__c, (select id from ContactsAssessments__r) 
    					  FROM Opportunity
                          WHERE accountId = :acct.Id and StageName != 'Cancelled' and StageName != 'Closed Won' and StageName != 'Closed Lost' order by amount desc];}	
    		
    	}
    	Integer i = 0;    	    	
    	for (Opportunity opp :Opportunities) {
    		oppWrappers.add(new OpportunityWrapper(opp, opp.amount, i));
    		i++;
    	}
    	    
    }    
    
    public class OpportunityWrapper {
    	
    	public Opportunity opp {get;set;}
    	public Decimal amount {get;set;}
    	public Integer position {get;set;}
    	
    	public OpportunityWrapper(Opportunity op, Decimal am, Integer i) {
    		opp = op;
    		position = i;    		
    		if (am != null) {
    			amount = am;    		
    		} else {
    			amount = 0;
    		}
    	}
    	
    }
}