@isTest
private class test_EditContact {

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
        insert contacto;
        
        Contact contacto2 = new Contact();
        contacto2.LastName = 'test2';
        contacto2.AccountId = cuenta.id;
        contacto2.ReportsToId = contacto.id;
        insert contacto2;
        
        Contact contacto3 = new Contact();
        contacto3.LastName = 'test3';
        contacto3.AccountId = cuenta.id;
        contacto3.ReportsToId = contacto.id;
        insert contacto3;
        
        ApexPages.StandardController controllertest = new ApexPages.StandardController(contacto);
        System.currentPagereference().getParameters().put('id',contacto.id);
        EditContact p_Test = new EditContact(controllertest);
        
        p_Test.getcontact();
        p_Test.getContactInfluenced();
        p_Test.getContactInfluences();
        p_Test.CIs.Contact_Influences__c = contacto2.id;
        p_Test.CId.Contact_Influenced__c = contacto3.id;
        p_Test.InsertCId();
        p_Test.InsertCIs();
        p_Test.saveAndRedirect();
        
        List<Contact_Influence__c> influencesList = [select id from Contact_Influence__c];
        system.assertEquals(2, influencesList.size());
        
        Contact_Influence__c ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacto2.id;
        ci.Contact_Influences__c = contacto.id;
        insert ci;
        
        System.currentPagereference().getParameters().put('IdtoDelete',contacto2.id);
        p_Test.delCId();
        
        List<Contact_Influence__c> influencesList1 = [select id from Contact_Influence__c];
        system.assertEquals(2, influencesList1.size());
        
        ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacto.id;
        ci.Contact_Influences__c = contacto3.id;
        insert ci;
        
        System.currentPagereference().getParameters().put('IdtoDelete',contacto3.id);
        p_Test.delCIs();
        
        List<Contact_Influence__c> influencesList2 = [select id from Contact_Influence__c];
        system.assertEquals(2, influencesList2.size());
        
    }
}