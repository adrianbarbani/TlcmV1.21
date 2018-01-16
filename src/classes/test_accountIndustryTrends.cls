@isTest
private class test_accountIndustryTrends {
	
    static testMethod void myUnitTest2() {
        
        Integer driversCount = 0;
                      
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionLocal;
		
        Account cuentaAbuelo=new Account();
        cuentaAbuelo.Name='test';
        cuentaAbuelo.Region__c=regionLocal.id;
        cuentaAbuelo.Strategic_Context__c = 'Test Cuenta Abuelo';
        insert cuentaAbuelo;
                
        Account cuentapapa=new Account();
        cuentapapa.Name='test';
        cuentapapa.Region__c=regionLocal.id;
        cuentapapa.ParentId = cuentaAbuelo.id;
        cuentapapa.Strategic_Context__c = 'Test Cuenta Padre';
        insert cuentapapa;        
        
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.ParentId = cuentapapa.id;
        cuenta.Strategic_Context__c = 'Test Cuenta';
        cuenta.Sector__c = 'sector';
        cuenta.Industry = 'industry';
        cuenta.Micro_Industry__c = 'Micro_Industry';
        insert cuenta;		        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test oppp';
        opp.StageName = 'Open';
        opp.CloseDate = system.today();
        opp.AccountId = cuenta.id;
        insert opp;
        
        Industry_Trend__c it = new Industry_Trend__c();
        it.Trend__c = 'test';
        it.Region__c = regionGlobal.id;
        it.Sector__c = cuenta.Sector__c;
        it.Sub_Sector__c = cuenta.Industry;
        it.Industry__c = cuenta.Micro_Industry__c;
        insert it;
        driversCount++;
        
        Strategic_Initiative__c si = new Strategic_Initiative__c();
        si.Account__c = cuenta.id;
        insert si;        
		driversCount++;
		
		Strategic_Initiative__c si2 = new Strategic_Initiative__c();
        si2.Account__c = cuentapapa.id;
        insert si2;
        driversCount++;
        
        PastProvenValueNew__c ppv = new PastProvenValueNew__c(account__c = cuenta.id);
        insert ppv;
        driversCount++;       
        
        System.currentPagereference().getParameters().put('id',cuenta.id);        
        accountIndustryTrends p_Test = new accountIndustryTrends();
        
        Integer trends = 0;
		for (ExtendedRegion region :p_Test.Regions) {
			trends += region.Trends.size();
		}
        
        Integer totalDrivers = p_Test.localStrategicInitiatives.size() + p_Test.globalStrategicInitiatives.size() + p_Test.provenValueWrapperList.size() + trends; 
		
		system.assert(p_Test.opportunities.size()==1);
		
		p_Test.oppid = opp.id;
		
		p_Test.trendid = it.id;
		p_Test.linkTrend();		
		List<OportunityIndustryTrend__c> oppItResult = [select id from OportunityIndustryTrend__c where opportunity__c = :opp.id];
		system.assert(oppItResult.size()==1);               
        p_Test.trendid = oppItResult.get(0).id;
        p_Test.unLinkTrend();
        List<OportunityIndustryTrend__c> oppItResult2 = [select id from OportunityIndustryTrend__c where opportunity__c = :opp.id];
		system.assert(oppItResult2.size()==0);   
		
		p_Test.getIndustry();
        p_Test.ExportToExcel();
        p_Test.getExcelName();
        p_Test.reverseList(p_Test.Regions);
        p_Test.ExportToExcelTrendWindows();     
        p_Test.getExcelNameTrendWindows();
    }

    static testMethod void myUnitTest3() {
        
        Integer driversCount = 0;
                      
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionLocal;
		
        Account cuentaAbuelo=new Account();
        cuentaAbuelo.Name='test';
        cuentaAbuelo.Region__c=regionLocal.id;
        cuentaAbuelo.Strategic_Context__c = 'Test Cuenta Abuelo';
        insert cuentaAbuelo;
                
        Account cuentapapa=new Account();
        cuentapapa.Name='test';
        cuentapapa.Region__c=regionLocal.id;
        cuentapapa.ParentId = cuentaAbuelo.id;
        cuentapapa.Strategic_Context__c = 'Test Cuenta Padre';
        insert cuentapapa;        
        
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.ParentId = cuentapapa.id;
        cuenta.Strategic_Context__c = 'Test Cuenta';
        cuenta.Sector__c = 'sector';
        cuenta.Industry = 'industry';
        cuenta.Micro_Industry__c = 'Micro_Industry';
        insert cuenta;		        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test oppp';
        opp.StageName = 'Open';
        opp.CloseDate = system.today();
        opp.AccountId = cuenta.id;
        insert opp;
        
        Industry_Trend__c it = new Industry_Trend__c();
        it.Trend__c = 'test';
        it.Region__c = regionGlobal.id;
        it.Sector__c = cuenta.Sector__c;
        it.Sub_Sector__c = cuenta.Industry;
        it.Industry__c = cuenta.Micro_Industry__c;
        insert it;
        driversCount++;
        
        Strategic_Initiative__c si = new Strategic_Initiative__c();
        si.Account__c = cuenta.id;
        insert si;        
		driversCount++;
		
		Strategic_Initiative__c si2 = new Strategic_Initiative__c();
        si2.Account__c = cuentapapa.id;
        insert si2;
        driversCount++;
        
        PastProvenValueNew__c ppv = new PastProvenValueNew__c(account__c = cuenta.id);
        insert ppv;
        driversCount++;       
        
        System.currentPagereference().getParameters().put('id',cuenta.id);        
        accountIndustryTrends p_Test = new accountIndustryTrends();
        
        Integer trends = 0;
		for (ExtendedRegion region :p_Test.Regions) {
			trends += region.Trends.size();
		}
        
        Integer totalDrivers = p_Test.localStrategicInitiatives.size() + p_Test.globalStrategicInitiatives.size() + p_Test.provenValueWrapperList.size() + trends; 
		
		p_Test.oppid = opp.id;
		
        p_Test.iniciativeid = si.id;
		p_Test.linkIniciative();	
		List<OpportunityStrategicInitiative__c> oppIsResult = [select id from OpportunityStrategicInitiative__c where opportunity__c = :opp.id];
		system.assert(oppIsResult.size()==1);
		p_Test.iniciativeid = oppIsResult.get(0).id;
		p_Test.unLinkIniciative();		
		List<OpportunityStrategicInitiative__c> oppIsResult2 = [select id from OpportunityStrategicInitiative__c where opportunity__c = :opp.id];
		system.assert(oppIsResult2.size()==0);
    }

    static testMethod void myUnitTest4() {
                      
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionLocal;
		
        Account cuentaAbuelo=new Account();
        cuentaAbuelo.Name='test';
        cuentaAbuelo.Region__c=regionLocal.id;
        cuentaAbuelo.Strategic_Context__c = 'Test Cuenta Abuelo';
        insert cuentaAbuelo;
        
        Account cuentapapa=new Account();
        cuentapapa.Name='test';
        cuentapapa.Region__c=regionLocal.id;
        cuentapapa.ParentId = cuentaAbuelo.id;
        cuentapapa.Strategic_Context__c = 'Test Cuenta Padre';
        insert cuentapapa;
        
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.ParentId = cuentapapa.id;
        cuenta.Strategic_Context__c = 'Test Cuenta';
        cuenta.Sector__c = 'sector';
        cuenta.Industry = 'industry';
        insert cuenta;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test oppp';
        opp.StageName = 'Open';
        opp.CloseDate = system.today();
        opp.AccountId = cuenta.id;
        insert opp;
        
        PastProvenValueNew__c ppv = new PastProvenValueNew__c(account__c = cuenta.id);
        insert ppv;
        
        System.currentPagereference().getParameters().put('id',cuenta.id);        
        accountIndustryTrends p_Test = new accountIndustryTrends();
		
		p_Test.oppid = opp.id;
   
    	p_Test.pastProventValueid = ppv.id;
		p_Test.linkPastProventValue();		
		List<OpportunityPastProvenValueNew__c> oppPpvResult = [select id from OpportunityPastProvenValueNew__c where opportunity__c = :opp.id];
		system.assert(oppPpvResult.size()==1);
		p_Test.pastProventValueid = oppPpvResult.get(0).id;
		p_Test.unLinkPastProventValue();		
		List<OpportunityPastProvenValueNew__c> oppPpvResult2 = [select id from OpportunityPastProvenValueNew__c where opportunity__c = :opp.id];
		system.assert(oppPpvResult2.size()==0);
    }
	
}