public with sharing class DCMEvaluateCriteriaController {

    public Opportunity opportunity {get; set;}
    public List<SCP_Criteria_DCM__c> evaluatedDCM {get; set;}
    public Set<String> notEvaluatedDCM;
    public SCP_Criteria_DCM__c newEval { get; set; }
    public Account account {get; set;}
    public Boolean canEdit {get;set;}
    public String criteriaToEvaluate {get;set;}
    public String delid {get;set;}
    public String newCriteria {get;set;}

    public List<SCP_Criteria_DCM__c> ourVK;
    public List<SCP_Criteria_DCM__c> ourVW;
    public List<SCP_Criteria_DCM__c> ourNV;
    public List<SCP_Criteria_DCM__c> ourVS;  

    public List<SCP_Criteria_DCM__c> competitorVK;
    public List<SCP_Criteria_DCM__c> competitorVW;
    public List<SCP_Criteria_DCM__c> competitorNV;
    public List<SCP_Criteria_DCM__c> competitorVS;

    public DCMEvaluateCriteriaController(){        
        if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
        && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()){
        this.opportunity = [SELECT name, id, AccountId FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        
        if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
        this.evaluatedDCM = [Select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id];        
        }
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
        && Schema.sObjectType.Account.fields.parentId.isAccessible()
        && Schema.sObjectType.Account.fields.Industry.isAccessible()
        && Schema.sObjectType.Account.fields.Region__c.isAccessible()){
        this.account = [SELECT name, id, parentId, Industry, Region__c, parent.name FROM Account WHERE Id = :opportunity.accountid];
        }
        
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);        
    }
    
    public PageReference DeleteEvaluation() {
        try {
	        system.debug('>>>>> Delete');
	        
            SCP_Criteria_DCM__c aBorrar = new SCP_Criteria_DCM__c();
           
           if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible()){
           aBorrar = [SELECT id FROM SCP_Criteria_DCM__c WHERE id = :this.delid];
           }
           
           if(SCP_Criteria_DCM__c.sObjectType.getDescribe().isDeletable()){
               delete aBorrar;
           }
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
	        this.evaluatedDCM = [Select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id];       
            }
            
	        resetLists();
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        return null;
    }

    public PageReference popCriteriaEvaluation() {              
        
        this.newEval = new SCP_Criteria_DCM__c();
        
        if(Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isCreateable())
        this.newEval.Criteria__c = criteriaToEvaluate;
        if(Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isCreateable())
        this.newEval.SCP_Oportunidad__c = opportunity.id;        
        return null;
    }
    
    public PageReference InsertEvaluation() {        
        
        try {
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isCreateable())
            insert newEval;
            newEval = null;
            criteriaToEvaluate = null;        
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            this.evaluatedDCM = [Select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id];        
            
        }
            resetLists();
        } catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        
        return null;        
    }
    
    public Set<String> getNotEvaluatedDCM() {       
        //this.notEvaluatedDCM = Criteria__c.getAll().keySet();
        this.notEvaluatedDCM = new Set<String>();
        
        List<SCP_Criteria_DCM__c> decems = new List<SCP_Criteria_DCM__c>();
        
        if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
        && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()){
        decems = [select Criteria__c, SCP_Oportunidad__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = null or (SCP_Oportunidad__r.accountId = :opportunity.accountId and SCP_Oportunidad__c != :opportunity.id)];
        }
        
        for (SCP_Criteria_DCM__c dcm :decems) {
        	this.notEvaluatedDCM.add(dcm.Criteria__c);
        }
        for (SCP_Criteria_DCM__c dcm :evaluatedDCM) {
            this.notEvaluatedDCM.remove(dcm.Criteria__c);
        }   
        return this.notEvaluatedDCM;
    }
    
     public PageReference addNewCriteria() {        
        try {
	        if (newCriteria != null && newCriteria.replace(' ','') != '' && !Criteria__c.getAll().keySet().contains(newCriteria)) {
	            
	            Criteria__c criteria = new Criteria__c();
	            if(Schema.sObjectType.Criteria__c.fields.Name.isCreateable())
	            criteria = new Criteria__c(Name = newCriteria);
	            if(Schema.sObjectType.Criteria__c.isCreateable())
	            insert criteria;
	        }
	    } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
	    newCriteria = null;                
        return null;
    }
    
    public PageReference saveEvaluatedDCM() {       
        Boolean errors = false;
        
        for (SCP_Criteria_DCM__c c :evaluatedDCM) {
        	if (c.Criteria__c == null) {
        		errors = true;
        		c.Criteria__c.addError('Debe escribir un valor');
        	}else if (c.Customer_Consideration__c == null) {
        		errors = true;
        		c.Customer_Consideration__c.addError('Debe escribir un valor');
        	}else if (c.Our_Competitive_Standing__c == null) {
        		errors = true;
        		c.Our_Competitive_Standing__c.addError('Debe escribir un valor');
        	}else if (c.Competitors_Competitive_Standing__c == null) {
        		errors = true;
        		c.Competitors_Competitive_Standing__c.addError('Debe escribir un valor');
        	}
        }
        
        if (!errors) {
        	try {
        	    
	        	update evaluatedDCM;
	        	
	        	resetLists();
		    } catch(DmlException ex){
		        ApexPages.addMessages(ex);
		    }
        }
        return null;
    }
    
    public List<SCP_Criteria_DCM__c> getOurVK() {        
        if (ourVK == null) {
            ourVK = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems2 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems2 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'HIGH' and Our_Competitive_Standing__c = 'LOW'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems2) {
                ourVK.add(dcm);
            }           
        }   
        return ourVK;
    }
    
    public List<SCP_Criteria_DCM__c> getOurVW() {        
        if (ourVW == null) {
            ourVW = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems3 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems3 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'HIGH' and Our_Competitive_Standing__c = 'HIGH'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems3) {
                ourVW.add(dcm);
            }                       
        }   
        return ourVW;
    }
    
    public List<SCP_Criteria_DCM__c> getOurNV() {        
        if (ourNV == null) {
            ourNV = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems4 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems4 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'LOW' and Our_Competitive_Standing__c = 'LOW'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems4) {
                ourNV.add(dcm);
            }                       
                        
        }   
        return ourNV;
    }
    
    public List<SCP_Criteria_DCM__c> getOurVS() {        
        if (ourVS == null) {
            ourVS = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems5 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems5 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'LOW' and Our_Competitive_Standing__c = 'HIGH'];
            }
            for (SCP_Criteria_DCM__c dcm :decems5) {
                ourVS.add(dcm);
            }           
        }   
        return ourVS;
    }

    public List<SCP_Criteria_DCM__c> getCompetitorVK() {     
        if (competitorVK == null) {
            competitorVK = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems6 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems6 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'HIGH' and Competitors_Competitive_Standing__c = 'LOW'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems6) {
                competitorVK.add(dcm);
            }           
        }   
        return competitorVK;
    }
    
    public List<SCP_Criteria_DCM__c> getCompetitorVW() {     
        if (competitorVW == null) {
            competitorVW = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems7 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems7 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'HIGH' and Competitors_Competitive_Standing__c = 'HIGH'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems7) {
                competitorVW.add(dcm);
            }           
        }   
        return competitorVW;
    }
    
    public List<SCP_Criteria_DCM__c> getCompetitorNV() {     
        if (competitorNV == null) {
            competitorNV = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems8 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems8 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'LOW' and Competitors_Competitive_Standing__c = 'LOW'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems8) {
                competitorNV.add(dcm);
            }           
        }   
        return competitorNV;
    }
    
    public List<SCP_Criteria_DCM__c> getCompetitorVS() {     
        if (competitorVS == null) {
            competitorVS = new List<SCP_Criteria_DCM__c>();
            
            List<SCP_Criteria_DCM__c> decems9 = new List<SCP_Criteria_DCM__c>();
            
            if(Schema.sObjectType.SCP_Criteria_DCM__c.isAccessible() && Schema.sObjectType.SCP_Criteria_DCM__c.fields.SCP_Oportunidad__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Customer_Consideration__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Criteria__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitors_Competitive_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Approach__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Our_Standing__c.isAccessible()
            && Schema.sObjectType.SCP_Criteria_DCM__c.fields.Competitor_Standing__c.isAccessible()){
            decems9 = [select SCP_Oportunidad__c, Our_Competitive_Standing__c, Customer_Consideration__c, Criteria__c, Competitors_Competitive_Standing__c, Approach__c, Our_Standing__c, Competitor_Standing__c from SCP_Criteria_DCM__c where SCP_Oportunidad__c = :opportunity.id and Customer_Consideration__c = 'LOW' and Competitors_Competitive_Standing__c = 'HIGH'];
            }
            
            for (SCP_Criteria_DCM__c dcm :decems9) {
                competitorVS.add(dcm);
            }           
        }   
        return competitorVS;
    }
    
    private void resetLists() {
        ourVK = null;
        ourVW = null;
        ourNV = null;
        ourVS = null;   
        
        competitorVK = null;
        competitorVW = null;
        competitorNV = null;
        competitorVS = null;
        
    }
    
    public PageReference ExportToExcel() {      
        saveEvaluatedDCM();
        return Page.DCMEvaluateCriteriaExcel;
    }
    
    public String getExcelName() {
        String name = account.Name + '-' + Label.DCM + '.xls';
        return name.replaceAll(' ', '_').replaceAll(',','');
    }
}