@isTest
private class Test_AdminProvenValueController {

    static testMethod void myUnitTest() {
        
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionRegional.id);
        insert regionLocal;
        
        AdminProvenValueController p = new AdminProvenValueController();
        
        p.getRegions();
        p.getIndustries();
        p.getMicro_Industries();
        p.getProvenValueTypes();
        
        p.regionId = regionGlobal.id;
        p.industry = 'Industry';
        p.micro_industry = 'Micro_industry';
        
        p.doUpdate();
        
        p.tempAccount.Industry = 'Industry';
        p.tempAccount.Micro_Industry__c = 'Micro Industry';
        
        p.doUpdate();        
        system.assertEquals(0, p.provenValueList.size());
        List<PastProvenValueNew__c> provenList = [select id from PastProvenValueNew__c];
        system.assertEquals(0, provenList.size());
        
        p.newPruvenValue.Unique_Value__c = 'value';
        p.newPruvenValue.Type__c = 'type';
        p.InsertNew();
        
        system.assertEquals(1, p.provenValueList.size());
        List<PastProvenValueNew__c> provenValueList2 = [select id,Industry__c,Micro_Industry__c from PastProvenValueNew__c];
        system.assertEquals('Micro Industry', provenValueList2.get(0).Micro_Industry__c);     
        system.assertEquals('Industry', provenValueList2.get(0).Industry__c);
        
        p.provenValueList.get(0).Unique_Value__c = 'Updated';
        p.save();
        
        List<PastProvenValueNew__c> provenValueList3 = [select id,Unique_Value__c from PastProvenValueNew__c];
        system.assertEquals('Updated', provenValueList3.get(0).Unique_Value__c);
        
		p.IdtoDelete = p.provenValueList.get(0).id;        
        p.del();
        
        List<PastProvenValueNew__c> provenValueList4 = [select id from PastProvenValueNew__c];
        system.assertEquals(0, provenValueList4.size());
 		       
    }

}