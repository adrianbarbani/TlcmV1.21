@isTest
private class test_AccountOrganizationChart {

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
                
        Contact contacto = new Contact();
        contacto.LastName = 'test';
        contacto.AccountId = cuenta.id;
        contacto.title = 'title';
        contacto.active__c = true;
        contacto.inOrg__c = true;        
        insert contacto;
        
        Contact contacto2 = new Contact();
        contacto2.LastName = 'test';
        contacto2.AccountId = cuenta.id;
        contacto2.ReportsToId = contacto.id;
        contacto2.title = 'title';
        contacto2.active__c = true;
        contacto2.inOrg__c = true;
        insert contacto2;
        
        Contact contacto3 = new Contact();
        contacto3.LastName = 'test';
        contacto3.AccountId = cuenta.id;        
        contacto3.title = 'title';
        contacto3.active__c = true;
        contacto3.inOrg__c = true;
        insert contacto3;
        
        Contact contacto4 = new Contact();
        contacto4.LastName = 'test';
        contacto4.AccountId = cuenta.id;        
        contacto4.ReportsToId = contacto3.id;
        contacto4.title = 'title';
        contacto4.active__c = true;
        contacto4.inOrg__c = true;
        insert contacto4;
        
        Contact_Influence__c ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacto.id;
        ci.Contact_Influences__c = contacto2.id;
        insert ci;
        
      
        ApexPages.StandardController controllertest = new ApexPages.StandardController(cuenta);
        AccountOrganizationChart p_Test = new AccountOrganizationChart(controllertest);
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        AccountOrganizationChart controller = new AccountOrganizationChart();
        
        Opportunity opp = new Opportunity(name='Test Opp', accountId = cuenta.id, stageName = 'Open', closeDate = system.today());
        insert opp;
        
        System.currentPagereference().getParameters().put('id',opp.id);
        AccountOrganizationChart controller2 = new AccountOrganizationChart();
        
        p_Test.getList();     
        
        AccountOrganizationChart.changeOrg(contacto3.id,contacto.id);  
        List<AccountOrganizationChart.JavascriptObject> jsOLisit = new List<AccountOrganizationChart.JavascriptObject>();
        
        AccountOrganizationChart.JavascriptObject jso = new AccountOrganizationChart.JavascriptObject();
        jso.value = 'Parent';
        jso.parent = 'Parent';
        jso.influences = '';
        
        jsOLisit.add(jso);
        
        AccountOrganizationChart.JavascriptObject jso1 = new AccountOrganizationChart.JavascriptObject();
        jso1.value = contacto.id;
        jso1.parent = 'Parent';
        jso1.influences = '';
        
        jsOLisit.add(jso1);
        
        AccountOrganizationChart.JavascriptObject jso2 = new AccountOrganizationChart.JavascriptObject();
        jso2.value = contacto2.id;
        jso2.parent = contacto.id;
        jso2.influences = '';
        
        jsOLisit.add(jso2);
        
        AccountOrganizationChart.JavascriptObject jso3 = new AccountOrganizationChart.JavascriptObject();
        jso3.value = contacto3.id;
        jso3.parent = 'Parent';
        jso3.influences = '';
        
        jsOLisit.add(jso3);
        
        AccountOrganizationChart.JavascriptObject jso4 = new AccountOrganizationChart.JavascriptObject();
        jso4.value = contacto4.id;
        jso4.parent = contacto3.id;
        jso4.influences = '';
        
        jsOLisit.add(jso4);
        
        AccountOrganizationChart.saveOrg(jsOLisit);
        
        List<Contact> contactsList = [select id, ReportsToId from Contact where id = :contacto4.id];
        system.assertEquals(1, contactsList.size());
        system.assertEquals(contacto3.id, contactsList.get(0).ReportsToId);
        
        p_Test.rerenderPageBlock();
        
        p_Test.saveContacts();
		
		System.currentPagereference().getParameters().put('id',cuenta.id);
        AccountOrganizationChart cont = new AccountOrganizationChart();
		
    }
}