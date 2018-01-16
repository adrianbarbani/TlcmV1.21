@isTest
private class test_adminIndustryTrends {

    static testMethod void myUnitTest() {
		
		Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionRegional.id);
        insert regionLocal;
        
        adminIndustryTrends p = new adminIndustryTrends();
        
        p.getRegions();
        p.getSectors();
        p.getIndustries();
        
        p.regionId = regionGlobal.id;
        p.sector = 'Private';
        p.industry = 'Industry';
        
        p.doUpdate();
        
        p.tempAccount.Micro_Industry__c = 'Micro Industry';
        
        p.doUpdate();        
        system.assertEquals(0, p.getTrends().size());
        List<Industry_Trend__c> trendsList = [select id from Industry_Trend__c];
        system.assertEquals(0, trendsList.size());
        
        p.newTrend.Title__c = 'Title';
        p.newTrend.Trend__C = 'Trend__c';
        p.InsertNewTrend();
        
        system.assertEquals(1, p.getTrends().size());
        List<Industry_Trend__c> trendsList2 = [select id,Industry__c,Sub_Sector__c from Industry_Trend__c];

        
        p.getTrends().get(0).Trend__c = 'Updated';
        p.save();
        
        List<Industry_Trend__c> trendsList3 = [select id,Trend__c from Industry_Trend__c];
        system.assertEquals('Updated', trendsList3.get(0).Trend__c);
         
		p.IdtoDel = p.getTrends().get(0).id;        
        p.getHashIndustry();
        p.del();
        
        List<Industry_Trend__c> trendsList4 = [select id from Industry_Trend__c];
    }
}