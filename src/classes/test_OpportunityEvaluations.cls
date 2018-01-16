@isTest
private class test_OpportunityEvaluations {
	    
    static testMethod void myUnitTest() {
    	
    	Account acctParent=new Account();
        acctParent.Name='test';
        acctParent.industry = 'Banking';
        
        insert acctParent;
    	
    	Account acct=new Account();
        acct.Name='test';
        acct.industry = 'Banking';
        acct.ParentId = acctParent.id;
        
        insert acct;
        
        Contact contact = new Contact();
        contact.LastName = 'test';
        contact.AccountId = acct.id;
        insert contact;
        
        Contact contact2 = new Contact();
        contact2.LastName = 'test';
        contact2.AccountId = acctParent.id;
        insert contact2;
        
        System.currentPagereference().getParameters().put('id',acct.id);
        OpportunityEvaluations p = new OpportunityEvaluations();
        
        system.assertEquals(1, p.getNotEvaluated().size());
        system.assertEquals(1, p.contatsFromParents.size());
        
        p.contactIdToEvaluate = contact.id;
        p.popContactEvaluation();
        
        p.newEval.Focus__c = 'End User';
        p.newEval.Attitudes__c = 'Negative';
        p.newEval.Authority__c = 'Positive';
        p.newEval.Influence__c = 'Negative';
        p.newEval.Our_Relationship__c = 'Positive';
        p.newEval.Competing_Company_Relationship__c = 'Positive';
        p.newEval.Generation__c = 'X';
        p.newEval.Buying_Cycle__c = 'Assessments of Alternatives';
        
        p.InsertEvaluation();
        system.assertEquals(0, p.getNotEvaluated().size());
        system.assertEquals(1, p.evaluated.size());
        
        List<Contact_Assessment__c> contactAssesmentList = [select id from Contact_Assessment__c];
        system.assertEquals(1, contactAssesmentList.size());
        
        p.contactIdToEvaluate = contact2.id;
        p.popContactEvaluation();
        
        p.newEval.Focus__c = 'End User';
        p.newEval.Attitudes__c = 'Negative';
        p.newEval.Authority__c = 'Positive';
        p.newEval.Influence__c = 'Negative';
        p.newEval.Our_Relationship__c = 'Positive';
        p.newEval.Competing_Company_Relationship__c = 'Positive';
        p.newEval.Generation__c = 'X';
        p.newEval.Buying_Cycle__c = 'Assessments of Alternatives';
        
        p.InsertEvaluation();
        system.assertEquals(0, p.contatsFromParents.size());
        system.assertEquals(2, p.evaluated.size());
        
        List<Contact_Assessment__c> contactAssesmentList1 = [select id from Contact_Assessment__c];
        system.assertEquals(2, contactAssesmentList1.size());
        
        p.evaluated.get(0).Influence__c = 'Positive';
        p.SaveChanges();
        
        List<Contact_Assessment__c> contactAssesmentList2 = [select id,Influence__c from Contact_Assessment__c where id = :p.evaluated.get(0).id];
        system.assertEquals('Positive', contactAssesmentList2.get(0).Influence__c);
        
        p.delid = contactAssesmentList2.get(0).id;
        p.DeleteEvaluation();
        
		system.assertEquals(1, p.evaluated.size());
		                
        List<Contact_Assessment__c> contactAssesmentList3 = [select id from Contact_Assessment__c];
        system.assertEquals(1, contactAssesmentList3.size());
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Open';
        opp.CloseDate = System.Today();
        opp.accountId = acct.id;
        insert opp;
        
        System.currentPagereference().getParameters().put('id',opp.id);
        OpportunityEvaluations p1 = new OpportunityEvaluations();
        
        p1.copyRDM();
        
        OpportunityEvaluations p2 = new OpportunityEvaluations();
        system.assertEquals(1, p2.evaluated.size());
        
        p2.getFooterStyle();
        
        p2.evaluated.get(0).Focus__c = null;
        p2.evaluated.get(0).Attitudes__c = null;
        p2.evaluated.get(0).Authority__c = null;
        p2.evaluated.get(0).Influence__c = null;
        p2.evaluated.get(0).Our_Relationship__c = null;
        p2.evaluated.get(0).Competing_Company_Relationship__c = null;
        p2.evaluated.get(0).Generation__c = null;
        p2.evaluated.get(0).Buying_Cycle__c = null;
        
        p2.SaveChanges();
        
        
    }
}