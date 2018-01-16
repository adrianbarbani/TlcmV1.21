@isTest
private class test_adminKPI {

    static testMethod void myUnitTest() {
    
    	Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionRegional.id);
        insert regionLocal;
        
        adminKPI p = new adminKPI();
        
        p.getRegions();
        p.getIndustries();
        p.checkStandardKPIs();
        
        p.regionId = regionGlobal.id;
        p.industry = 'Industry';
        
        p.doUpdate();
        
        p.tempAccount.Industry = 'Industry';
        p.tempAccount.Micro_Industry__c = 'Micro Industry';
        
        p.doUpdate();        
        system.assertEquals(0, p.getKPI().size());
        List<KPI__c> kpiList = [select id from KPI__c];
        system.assertEquals(0, kpiList.size());
        
        p.newKPI.Name__c = 'Name';
        p.newKPI.Unit__c = 'U';
        p.InsertNewKPI();
        
        system.assertEquals(1, p.getKPI().size());
        List<KPI__c> kpiList2 = [select id,Industry__c,Sub_Sector__c from KPI__c];
        system.assertEquals('Industry', kpiList2.get(0).Sub_Sector__c);     
        system.assertEquals('Micro Industry', kpiList2.get(0).Industry__c);
        
        p.getKPI().get(0).Name__c = 'Updated';        
        p.save();
        
        List<KPI__c> kpiList3 = [select id,Name__c from KPI__c];
        system.assertEquals('Updated', kpiList3.get(0).Name__c);
        
        p.IdtoDel = p.getKPI().get(0).id;        
        p.getHashIndustry();
        p.del();
        
        List<KPI__c> kpiList4 = [select id from KPI__c];
        system.assertEquals(0, kpiList4.size());
    }
}