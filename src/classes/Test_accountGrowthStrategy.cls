@isTest
private class Test_accountGrowthStrategy {
	
	static testMethod void myUnitTest() {
    	/* Create Regions */
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__C(name='Regional', parent__c = regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__C(name='Local', parent__c = regionRegional.id);
        insert regionLocal;
        
        List<Region__c> regionsList = [select id from Region__c];
        system.assertEquals(3, regionsList.size());
        
        /* Create Account */
        String industry = 'Industry';
        String micro_industry = 'Micro_Industry';
        
        String accountName = 'Account Test';
        Account acctGrandparent = new Account(Name=accountName, Region__c = regionRegional.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acctGrandparent;
        
        Account acctParent = new Account(Name=accountName, Region__c = regionRegional.id, parentId = acctGrandparent.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acctParent;
        
        Account acct = new Account(Name=accountName, Region__c = regionLocal.id, parentId = acctParent.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acct;        
        
        List<Account> accountList = [select id from Account];
        system.assertEquals(3, accountList.size()); 
    	
    	 /* Create Strategic Iniciatives */
        List<Strategic_Initiative__c> strategics = new List<Strategic_Initiative__c>(); 
        
        Strategic_Initiative__c strategicGP = new Strategic_Initiative__c(account__c = acctGrandparent.id);
        strategics.add(strategicGP);
        
        Strategic_Initiative__c strategicP = new Strategic_Initiative__c(account__c = acctParent.id);
        strategics.add(strategicP);
        
        Strategic_Initiative__c strategic = new Strategic_Initiative__c(account__c = acct.id);
        strategics.add(strategic);
        
        insert strategics;
        
        List<Strategic_Initiative__c> strategicList = [select id from Strategic_Initiative__c];
        system.assertEquals(3, strategicList.size());
        
        System.currentPagereference().getParameters().put('id',acct.id);
        AccountGrowthStrategyController agsc = new AccountGrowthStrategyController();
        
        /* Test Strategic Iniciatives */
        system.assertEquals(3,agsc.localStrategicInitiatives.size() + agsc.globalStrategicInitiatives.size());
        
        /* Test Link and UnLink Iniciatives */
        agsc.iniciativeid = strategic.id;
        agsc.linkIniciative();        
        List<Potential_New_Business_Strategic_Ini__c> pnbsList = [select id from Potential_New_Business_Strategic_Ini__c];
        system.assertEquals(1, pnbsList.size());
        
        agsc.iniciativeid = pnbsList.get(0).id;  
        agsc.unlinkIniciative();
        List<Potential_New_Business_Strategic_Ini__c> pnbsList2 = [select id from Potential_New_Business_Strategic_Ini__c];
        system.assertEquals(0, pnbsList2.size());
	}
	
	static testMethod void myUnitTest2() {
    	/* Create Regions */
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__C(name='Regional', parent__c = regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__C(name='Local', parent__c = regionRegional.id);
        insert regionLocal;
        
        List<Region__c> regionsList = [select id from Region__c];
        system.assertEquals(3, regionsList.size());
        
        /* Create Account */
        String industry = 'Industry';
        String micro_industry = 'Micro_Industry';
        
        String accountName = 'Account Test';
        Account acctGrandparent = new Account(Name=accountName, Region__c = regionRegional.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acctGrandparent;
        
        Account acctParent = new Account(Name=accountName, Region__c = regionRegional.id, parentId = acctGrandparent.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acctParent;
        
        Account acct = new Account(Name=accountName, Region__c = regionLocal.id, parentId = acctParent.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acct;        
        
        List<Account> accountList = [select id from Account];
        system.assertEquals(3, accountList.size());
    	
    	/* Create Industry Trends */
        List<Industry_Trend__c> industries = new List<Industry_Trend__c>();  
        
        Industry_Trend__c it1 = new Industry_Trend__c();
        it1.sub_sector__c = industry;
        it1.industry__c = micro_industry;
        it1.Region__c = regionGlobal.id;
        it1.trend__c = 'it1';
        industries.add(it1);
        
        Industry_Trend__c it2 = new Industry_Trend__c();
        it2.sub_sector__c = industry;
        it2.industry__c = micro_industry;
        it2.Region__c = regionRegional.id;
        it2.trend__c = 'it2';
        industries.add(it2);
        
        Industry_Trend__c it3 = new Industry_Trend__c();
        it3.sub_sector__c = industry;
        it3.industry__c = micro_industry;
        it3.Region__c = regionLocal.id;
        it3.trend__c = 'it3';
        industries.add(it3);
        
        Industry_Trend__c it4 = new Industry_Trend__c();
        it4.sub_sector__c = industry;
        it4.industry__c = 'All';
        it4.Region__c = regionRegional.id;
        it4.trend__c = 'it4';
        industries.add(it4);
        
        Industry_Trend__c it5 = new Industry_Trend__c();
        it5.sub_sector__c = 'All';
        it5.industry__c = 'All';
        it5.Region__c = regionRegional.id;
        it5.trend__c = 'it5';
        industries.add(it5);
        
        insert industries;
        List<Industry_Trend__c> trendsList = [select id from Industry_Trend__c];
        system.assertEquals(5,trendsList.size());
        
        System.currentPagereference().getParameters().put('id',acct.id);
        AccountGrowthStrategyController agsc = new AccountGrowthStrategyController();
        
        /* Test Industry Trends */
        List<Industry_Trend__c> trendsResultList = new List<Industry_Trend__c>();
        for (ExtendedRegion er :agsc.Regions) {
        	trendsResultList.addAll(er.Trends);
        }
        
        /* Test Link and UnLink Trends */
        agsc.trendid = it1.id;
        agsc.linkTrend();        
        List<Potential_New_Business_Trend__c> pnbtList = [select id from Potential_New_Business_Trend__c];
        system.assertEquals(1, pnbtList.size());
        
        agsc.trendid = pnbtList.get(0).id;
        agsc.unlinkTrend();
        List<Potential_New_Business_Trend__c> pnbtList2 = [select id from Potential_New_Business_Trend__c];
        system.assertEquals(0, pnbtList2.size());
	}
	
	static testMethod void myUnitTest3() {
    	/* Create Regions */
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__C(name='Regional', parent__c = regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__C(name='Local', parent__c = regionRegional.id);
        insert regionLocal;
        
        List<Region__c> regionsList = [select id from Region__c];
        system.assertEquals(3, regionsList.size());
        
        /* Create Account */
        String industry = 'Industry';
        String micro_industry = 'Micro_Industry';
        
        String accountName = 'Account Test';
        Account acctGrandparent = new Account(Name=accountName, Region__c = regionRegional.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acctGrandparent;
        
        Account acctParent = new Account(Name=accountName, Region__c = regionRegional.id, parentId = acctGrandparent.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acctParent;
        
        Account acct = new Account(Name=accountName, Region__c = regionLocal.id, parentId = acctParent.id, Industry = industry, Micro_Industry__c = micro_industry);
        insert acct;        
        
        List<Account> accountList = [select id from Account];
        system.assertEquals(3, accountList.size());
    	
    	/* Create Proven Value*/
        List<PastProvenValueNew__c> provens = new List<PastProvenValueNew__c>();
        
        PastProvenValueNew__c prov1 = new PastProvenValueNew__c();
        prov1.Industry__c = industry;
        prov1.Micro_Industry__c = micro_industry;
        prov1.region__c = regionGlobal.id;
        prov1.Unique_Value__c = 'prov1'; 
        provens.add(prov1);
        
        PastProvenValueNew__c prov2 = new PastProvenValueNew__c();
        prov2.Industry__c = industry;
        prov2.Micro_Industry__c = micro_industry;
        prov2.region__c = regionRegional.id;
        prov2.Unique_Value__c = 'prov2';
        provens.add(prov2);
        
        PastProvenValueNew__c prov3 = new PastProvenValueNew__c();
        prov3.Industry__c = industry;
        prov3.Micro_Industry__c = micro_industry;
        prov3.region__c = regionLocal.id;
        prov3.Unique_Value__c = 'prov3';
        provens.add(prov3);
        
        PastProvenValueNew__c prov4 = new PastProvenValueNew__c();
        prov4.Industry__c = industry;
        prov4.Micro_Industry__c = 'All';
        prov4.region__c = regionLocal.id;
        prov4.Unique_Value__c = 'prov4';
        provens.add(prov4);
        
        PastProvenValueNew__c prov5 = new PastProvenValueNew__c();
        prov5.Industry__c = 'All';
        prov5.Micro_Industry__c = 'All';
        prov5.region__c = regionLocal.id;
        prov5.Unique_Value__c = 'prov5';
        provens.add(prov5);
        
        PastProvenValueNew__c prov6 = new PastProvenValueNew__c();
        prov6.account__c = acct.id;
        prov6.Unique_Value__c = 'prov6';
        provens.add(prov6);
        
        PastProvenValueNew__c prov7 = new PastProvenValueNew__c();
        prov7.account__c = acctParent.id;
        prov7.Unique_Value__c = 'prov7';
        provens.add(prov7);
        
        insert provens;
        
        List<PastProvenValueNew__c> provList = [select id from PastProvenValueNew__c];
        system.assertEquals(7, provList.size()); 
        
        System.currentPagereference().getParameters().put('id',acct.id);
        AccountGrowthStrategyController agsc = new AccountGrowthStrategyController();
        
        /* Test Proven Value*/
        system.assertEquals(7, agsc.provenValueWrapperList.size(), agsc.provenValueWrapperList);
        
        agsc.add();
        List<Potential_New_Business__c> potentialsList = [select id from Potential_New_Business__c where account__c = :acct.id];
        
        system.assertEquals(1, potentialsList.size());
        system.assertEquals(agsc.PotentialNewBusinessList.size(), potentialsList.size());
        
        agsc.PotentialNewBusinessList.get(0).Potential_new_Business__c = 'Test';

        agsc.save();
        
        List<Potential_New_Business__c> potentialsList2 = [select id from Potential_New_Business__c where account__c = :acct.id and Potential_new_Business__c = 'Test'];        
        system.assertEquals(1, potentialsList2.size());
        
        agsc.pnbid = agsc.PotentialNewBusinessList.get(0).id;
        
        /* Test Link and UnLink Proven Value */
        agsc.pastProventValueid = prov1.id;
        agsc.linkPastProventValue();        
        List<Potential_New_Business_Past_Provent__c> pnbpList = [select id from Potential_New_Business_Past_Provent__c];
        system.assertEquals(1, pnbpList.size());
        
        agsc.pastProventValueid = pnbpList.get(0).id;
        agsc.unlinkPastProventValue();
        List<Potential_New_Business_Past_Provent__c> pnbpList2 = [select id from Potential_New_Business_Past_Provent__c];
        system.assertEquals(0, pnbpList2.size());
        
        /* Export */
        agsc.getExcelName();
        agsc.ExportToExcel();
	}
	
	
}