@isTest
private class test_accountHistoricalBusinessWindow {
    
    static testMethod void myUnitTest() {
    //Con industria
        Region__c regionGlobal = new Region__C(name='Global');
        regionGlobal.Currency_Name__c ='asd';
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        regionLocal.Currency_Name__c ='asd';
        insert regionLocal;
        
        List<Region__c> regionsList = [select id from Region__c];
        system.assertEquals(2, regionsList.size());
        
        Account cuentaPadre =new Account();
        cuentaPadre.Name='testPadre';
        cuentaPadre.Region__c=regionGlobal.id;
        
        insert cuentaPadre;
                
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.parentId = cuentaPadre.id;
        cuenta.industry = 'Banking';
        
        insert cuenta;
        
        List<Account> accountList = [select id from Account];
        system.assertEquals(2, accountList.size());

        System.currentPagereference().getParameters().put('id',cuenta.id);
        
        accountHistoricalBusinessWindow p_Test = new accountHistoricalBusinessWindow();
        //p_Test.getCurrencies();
        p_Test.SaveChanges();
        p_Test.SaveChanges();
        p_Test.getUserIsoCode();
        p_Test.getCompanyIsoCode();
        
        p_Test.thisyear.a__c = 1;
        p_Test.thisyear.b__c = 1;
        p_Test.thisyear.cc__c = 1;
        
        p_Test.lastyear.a__c = 1;
        p_Test.lastyear.b__c = 1;
        p_Test.lastyear.cc__c = 1;
        
        p_Test.last2year.a__c = 1;
        p_Test.last2year.b__c = 1;
        p_Test.last2year.cc__c = 1;
                
        p_Test.SaveChanges();
        
        List<PastActivity__c> pastList = [select id, a__c from PastActivity__c];
        system.assertEquals(3, pastList.size());
        
        for (PastActivity__c p :pastList) {
        	system.assertEquals(1, p.a__c);
        }
		
		p_Test.loadData();
		p_Test.ExportToExcel();
		p_Test.getExcelName();
                
    }
}