@isTest
private class test_accountSCPFullReport {

    static testMethod void myUnitTest() {
        
        Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionLocal;
        
         
        Account cuentaPadre =new Account();
        cuentaPadre.Name='testPadre';
        cuentaPadre.Region__c=regionGlobal.id;
        
        insert cuentaPadre;
        
        
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.parentId = cuentaPadre.id;
        
        insert cuenta;
        
        
        Opportunity opp = new Opportunity(Name='test', StageName='Prospecting', CloseDate=system.today());
        opp.accountId = cuenta.id;
        insert opp;
        
        Industry_Trend__c it = new Industry_Trend__c();
        it.Industry__c = 'All';
        it.Sub_Sector__c = 'All';
        it.Trend__c = 'test';
        it.Region__c = regionGlobal.id;        
        insert it;
        
        Strategic_Initiative__c si = new Strategic_Initiative__c();
        si.Account__c = cuenta.id;
        insert si;        

        Contact contacto = new Contact();
        contacto.LastName = 'test';
        contacto.AccountId = cuenta.id;
        insert contacto;
        
        Contact contacto2 = new Contact();
        contacto2.LastName = 'test';
        contacto2.AccountId = cuenta.id;
        contacto2.ReportsToId = contacto.id;
        insert contacto2;
        
        Contact_Influence__c ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacto.id;
        ci.Contact_Influences__c = contacto2.id;
        insert ci;
        
        
        Contact_Assessment__c ca = new Contact_Assessment__c();
        ca.Contact__c = contacto.id;
        ca.Opportunity__c = opp.id;
        insert ca;
        
        ca = new Contact_Assessment__c();
        ca.Contact__c = contacto2.id;
        ca.Opportunity__c = opp.id;
        ca.Focus__c = 'End User';
        ca.Influence__c = 'Negative';
        ca.Attitudes__c = 'Negative';
        ca.Authority__c = 'Positive';
        ca.Buying_Cycle__c = 'Assessments of Alternatives';
        ca.Our_Relationship__c = 'Positive';
        ca.Competing_Company_Relationship__c = 'Positive';
        insert ca;
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        accountSCPFullReportNew p = new accountSCPFullReportNew();
        
        system.assertEquals(1, p.localStrategicInitiatives.size());
        
    }
}