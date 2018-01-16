@isTest
private class Test_DCMEvaluateCriteriaController {

    static testMethod void myUnitTest() {
        
        PageReference pageRef = Page.DCMEvaluateCriteria;
        Test.setCurrentPage(pageRef);
        
        Account acc = new Account(Name = 'Account test');
        insert acc;        
        Opportunity opp = new Opportunity(Name = 'Test Opp', accountid = acc.id, stageName = 'Open', closeDate = system.today());
        insert opp;
        
        
        ApexPages.currentPage().getParameters().put('id', opp.id);
        DCMEvaluateCriteriaController dcmController = new DCMEvaluateCriteriaController();
        
		dcmController.newCriteria = 'Test Criteria';
		
		dcmController.addNewCriteria();
		
		dcmController.criteriaToEvaluate = 'Test Criteria';
		dcmController.popCriteriaEvaluation();
		SCP_Criteria_DCM__c myMewEval = new SCP_Criteria_DCM__c(Criteria__c = 'Test Criteria', Our_Competitive_Standing__c = 'HIGH', Customer_Consideration__c = 'HIGH', Competitors_Competitive_Standing__c = 'HIGH');
		                 
        dcmController.newEval = myMewEval;
        dcmController.newEval.Customer_Consideration__c = 'Test';
        dcmController.InsertEvaluation();
        
        List<SCP_Criteria_DCM__c> criteriaList = [select id from SCP_Criteria_DCM__c];
        system.assertEquals(1, criteriaList.size());
        
        
        dcmController.saveEvaluatedDCM();
        
        List<SCP_Criteria_DCM__c> criteriaList1 = [select id, Customer_Consideration__c from SCP_Criteria_DCM__c];
        system.assertEquals('Test', criteriaList1.get(0).Customer_Consideration__c);
        
        dcmController.delid = myMewEval.id;
        dcmController.DeleteEvaluation();
        
        List<SCP_Criteria_DCM__c> criteriaList2 = [select id from SCP_Criteria_DCM__c];
        system.assertEquals(0, criteriaList2.size());
        
        dcmController.getNotEvaluatedDCM();
        
        dcmController.getOurVK();
		dcmController.getOurVW();
		dcmController.getOurVS();
		dcmController.getOurNV();
		dcmController.getCompetitorVK();
		dcmController.getCompetitorVW();
		dcmController.getCompetitorVS();
		dcmController.getCompetitorNV();         
		dcmController.getNotEvaluatedDCM();
        
    }
}