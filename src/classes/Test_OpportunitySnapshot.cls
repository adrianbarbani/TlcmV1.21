@isTest
private class Test_OpportunitySnapshot {

    static testMethod void myUnitTest() {
		
		/* Create Region */
		Region__c regionGlobal = new Region__C(name='Global');
        regionGlobal.Currency_Name__c ='asd';
        insert regionGlobal;
		
		/* Create Account */
		String accountName = 'Account Test';
		Account acct = new Account(Name=accountName, Region__c=regionGlobal.id);
		insert acct;
		
		List<Account> acctResult = [select id from Account where name = :accountName];
		system.Assert(acctResult.size()>0, 'Error to create Account: ' + acct);
		
		Opportunity opp = new Opportunity(name='Test Opp', accountId = acct.id, stageName = 'Open', closeDate = system.today());
		insert opp;
		
		Industry_Trend__c trend = new Industry_Trend__c(Region__c=regionGlobal.id);
		insert trend;
		OportunityIndustryTrend__c oppIndTrd = new OportunityIndustryTrend__c(Opportunity__c = opp.id, Industry_Trend__c = trend.id);
		insert oppIndTrd;
		
		Strategic_Initiative__c strategic = new Strategic_Initiative__c();
		insert strategic;
		OpportunityStrategicInitiative__c oppStrIni = new OpportunityStrategicInitiative__c(Opportunity__c = opp.id, Strategic_Initiative__c=strategic.id);
		insert oppStrIni;
		
		OpportunityPastProvenValueNew__c oppPtPrVa = new OpportunityPastProvenValueNew__c(Opportunity__c = opp.id);
		insert oppPtPrVa;
		
		/* Set Page and Create Controller*/
		ApexPages.StandardController sc = new ApexPages.StandardController(opp);
		OpportunitySnapshotController oppSnpCtr = new OpportunitySnapshotController(sc);
		
		system.assert(oppSnpCtr.valueArgumentsList.size()==3);
		
		oppSnpCtr.opp.Value_Proposition__c = 'Test Value Proposition';
		oppSnpCtr.save();		
		
		Opportunity oppResult = [select id, Value_Proposition__c from Opportunity where id = :opp.id];		
		system.assertEquals(oppSnpCtr.opp.Value_Proposition__c, oppResult.Value_Proposition__c);
		
		Task t = new Task(WhatId = opp.id);
		insert t;
		
		OpportunitySnapshotController oppSnpCtr2 = new OpportunitySnapshotController(sc);
		
		system.assert(oppSnpCtr2.taskList.size()==1);
		
		oppSnpCtr2.taskList.get(0).description__c = 'Test Description';
		
		oppSnpCtr2.saveTask();
		Task taskResult = [select id, description__c from Task where id = :t.id];
		system.assertEquals(oppSnpCtr2.taskList.get(0).description__c, taskResult.description__c);
		
    }
}