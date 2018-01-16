@isTest
private class test_AccountContacts {

    static testMethod void myUnitTest() {
        Region__c regionGlobal = new Region__C(name='Global');
        regionGlobal.Currency_Name__c ='asd';
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        regionLocal.Currency_Name__c ='asd';
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
        contacto2.LastName = 'test';
        contacto2.AccountId = cuenta.id;
        contacto2.ReportsToId = contacto.id;
        insert contacto2;
        
        Contact_Influence__c ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacto.id;
        ci.Contact_Influences__c = contacto2.id;
        insert ci;
        
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        ApexPages.StandardController controllertest = new ApexPages.StandardController(cuenta);
        AccountContacts p_Test = new AccountContacts(controllertest);
        
        p_Test.getContacts();       
        
		List<Contact> temp = [SELECT Id, Name, ReportsToId,Closest_Account_Team_Member__r.name  FROM Contact WHERE AccountId = :cuenta.id];
        
        system.assertEquals(temp.size(),p_Test.contactList.size());
        
		AccountContacts p_Test2 = new AccountContacts();
		
		//DMLException
		Contact c = new Contact();
		p_Test2.getContacts();
		
		p_Test2.contactList.add(c);
		p_Test2.save();		

		
		p_Test2.goToNewContact();
		p_Test2.goToOrg();
		p_Test2.save();
		p_Test2.getExcelName();
		p_Test2.ExportToExcel();
        
    }
}