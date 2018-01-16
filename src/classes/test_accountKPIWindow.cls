@isTest
private class test_accountKPIWindow {
	
    static testMethod void myUnitTest2() {
        
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionRegional = new Region__C(name='Region',Parent__c=regionGlobal.id);
        insert regionRegional;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionRegional.id);
        insert regionLocal;
        
        Account cuentaPadre =new Account();
        cuentaPadre.Name='testPadre';
        cuentaPadre.Region__c=regionGlobal.id;
        
        insert cuentaPadre;
        
        String industry = 'Financial';
        String micro_industry = 'Bank';
        
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.industry = industry;
        cuenta.micro_industry__c = micro_industry;
        cuenta.ParentId = cuentaPadre.id;
        
        insert cuenta;
        
        List<KPI__c> kpiList = new List<KPI__c>();
        
        //Kpi Parent
        KPI__c temp = new KPI__c();
        temp.Name__c = 'Parent KPI';
        temp.Unit__c = 'Units';
        temp.Region__c = regionLocal.id;
        temp.Account__c = cuentaPadre.id;
        kpiList.add(temp);
        
        //Kpi Account
        KPI__c accountKPI = new KPI__c();
        accountKPI.Name__c = 'Account KPI';
        accountKPI.Unit__c = 'Units';
        accountKPI.Region__c = regionLocal.id;
        accountKPI.Account__c = cuenta.id;
        kpiList.add(accountKPI);
        
        //Kpis Global.
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionGlobal.id;
        temp.Industry__c = 'All';
        temp.Sub_Sector__c = 'All';
        kpiList.add(temp);
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionGlobal.id;
        temp.Industry__c = micro_industry;
        temp.Sub_Sector__c = 'All';
        kpiList.add(temp);
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionGlobal.id;
        temp.Industry__c = micro_industry;
        temp.Sub_Sector__c = industry;
        kpiList.add(temp);
        
        //Kpis Regional
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionRegional.id;
        temp.Industry__c = 'All';
        temp.Sub_Sector__c = 'All';
        kpiList.add(temp);
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionRegional.id;
        temp.Industry__c = micro_industry;
        temp.Sub_Sector__c = 'All';
        kpiList.add(temp);
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionRegional.id;
        temp.Industry__c = micro_industry;
        temp.Sub_Sector__c = industry;
        kpiList.add(temp);
        
        //Kpis Local
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionLocal.id;
        temp.Industry__c = 'All';
        temp.Sub_Sector__c = 'All';
        kpiList.add(temp);
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionLocal.id;
        temp.Industry__c = micro_industry;
        temp.Sub_Sector__c = 'All';
        kpiList.add(temp);
        
        temp = new KPI__c();
        temp.Name__c = 'Number of Branches';
        temp.Unit__c = 'Units';
        temp.Region__c = regionLocal.id;
        temp.Industry__c = micro_industry;
        temp.Sub_Sector__c = industry;
        kpiList.add(temp);
        
        insert kpiList;  
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        accountKPIWindow p_Test = new accountKPIWindow();
        
        System.assertEquals(1, p_Test.parentData.size());
        
        System.assertEquals(1, p_Test.localData.size());
        
        //System.assertEquals(9, p_Test.Data.size());
        
        p_Test.SaveChanges();
        p_Test.addKPI();
        
        System.assertEquals(2, p_Test.localData.size());
		
		p_Test.getIndustry();
        p_Test.ExportToExcel();
        p_Test.getExcelName();        
        p_Test.delid = accountKPI.id;
        p_Test.deleteKPI();
        
        System.assertEquals(1, p_Test.localData.size());
        
    }
}