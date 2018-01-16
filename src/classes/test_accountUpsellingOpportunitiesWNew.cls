@isTest 
public with sharing class test_accountUpsellingOpportunitiesWNew {

    static testMethod void myUnitTest() {
        
        Region__c r1=new Region__c();
        r1.Currency__c='aa';
        r1.Currency_Name__c='test';
        r1.Name='test1';
        insert r1;
        
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.industry = 'Banking';
        cuenta.Region__c=r1.Id;
        insert cuenta;
        
        Contract c = new Contract(accountId = cuenta.id, isCompetitorContract__c = false);
        insert c;
        
        Contract c1 = new Contract(accountId = cuenta.id, isCompetitorContract__c = true, competitorName__c = 'test');
        insert c1;
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        
        accountUpsellingOpportunitiesWindowNew p_Test = new accountUpsellingOpportunitiesWindowNew();
            
        p_Test.SaveChanges();
        
        system.assertEquals(1, p_Test.ourContracts.size());
        system.assertEquals(1, p_Test.competitorContracts.size());
        
    }
}