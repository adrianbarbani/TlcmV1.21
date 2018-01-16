@isTest
private class test_AccountOpportunities { 
    
    static testMethod void myUnitTest() {
        
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionLocal;
        
        Account cuenta=new Account();
        cuenta.region__c = regionLocal.id;
        cuenta.Name='test';
        
        insert cuenta;
        
        Opportunity opp = new Opportunity(Name = 'Test Opp', accountId = cuenta.id, StageName = 'Prospect', CloseDate = System.Today());
        
        opp.full_contract_value__c = 1000;
        opp.Estimated_Year_End_Revenue__c = 1000;        
        opp.Estimated_FCV__c = 1000;
        opp.Estimated_FCV_Calculated__c = 1000;
        
        insert opp;
        
        Opportunity opp1 = new Opportunity(Name = 'Test Opp', accountId = cuenta.id, StageName = 'Prospect', CloseDate = System.Today(), Amount = 1000);
        insert opp1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(cuenta);
        AccountOpportunities p = new AccountOpportunities(controller);
        
        system.assertEquals(2, p.oppWrappers.size());
        system.assertEquals(2, p.opportunities.size());

    }

}