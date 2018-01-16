@isTest
private class test_SCPMenu {

    static testMethod void myUnitTest() {
    	
    	Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.industry = 'Banking';
        
        insert cuenta;
        
        Contact c = new Contact();
        c.accountId = cuenta.id;
        c.LastName = 'test';
        
        insert c;
        
        Opportunity opp = new Opportunity(Name='test', StageName='Prospecting', CloseDate=system.today());
        opp.accountId = cuenta.id;
        
        insert opp;
    	
        SCPMenu p_Test = new SCPMenu();      
        system.assertEquals(null, p_Test.Acct);
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        SCPMenu p_Test1 = new SCPMenu();  
		system.assertEquals(cuenta.id, p_Test1.Acct.id);
		system.assertEquals('Account', p_Test1.ObjectType);
		
		System.currentPagereference().getParameters().put('id',opp.id);
        SCPMenu p_Test2 = new SCPMenu(); 
		system.assertEquals(cuenta.id, p_Test2.Acct.id);
		system.assertEquals('Opportunity', p_Test2.ObjectType);
		
		System.currentPagereference().getParameters().put('id',c.id);
        SCPMenu p_Test3 = new SCPMenu();
        system.assertEquals(cuenta.id, p_Test3.Acct.id);
        system.assertEquals('Contact', p_Test3.ObjectType);
    }
    
}