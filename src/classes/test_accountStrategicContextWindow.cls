@isTest
private class test_accountStrategicContextWindow {

    static testMethod void myUnitTest() {
                
        Account parentAccount =new Account();
        parentAccount.Name='testPadre';
        parentAccount.Strategic_Context__c = 'Parent Strategic';
        parentAccount.Buying_Criteria__c = 'Parent Buying';
        
        insert parentAccount;
        
        Account acct=new Account();
        acct.Name='test';
        acct.Strategic_Context__c = 'Strategic';
        acct.Buying_Criteria__c = 'Buying';
        acct.parentId = parentAccount.id;
        
        insert acct;
        
        Strategic_Initiative__c newInitiative = new Strategic_Initiative__c();
        newInitiative.account__c = parentAccount.id;
        insert newInitiative;
        
        System.currentPagereference().getParameters().put('id',acct.id);
        accountStrategicContextWindow p_Test = new accountStrategicContextWindow();
		
        p_test.insertarData();
        
		system.assertEquals(1, p_Test.globalStrategicContext.size());
		system.assertEquals('Parent Strategic', p_Test.globalStrategicContext.get(0).Strategic_Context__c);
		
		system.assertEquals(1, p_Test.globalBuyingCriteria.size());
		system.assertEquals('Parent Buying', p_Test.globalBuyingCriteria.get(0));
	     
        p_Test.InsertIniciative();
        system.assertEquals(1, p_Test.localStrategicInitiatives.size());
        
        List<Strategic_Initiative__c> strategicList = [select id from Strategic_Initiative__c where account__c = :acct.id];     
		system.assertEquals(1, strategicList.size());        
        
        p_Test.account.Strategic_Context__c = 'Updated';
        p_Test.account.Buying_Criteria__c = 'Updated';
        
        p_Test.localStrategicInitiatives.get(0).Strategic_Initiative__c = 'Updated';
        
        p_Test.SaveChanges();    
        
        List<Strategic_Initiative__c> strategicList2 = [select id, Strategic_Initiative__c from Strategic_Initiative__c where account__c = :acct.id];
        system.assertEquals(1, strategicList2.size());
        system.assertEquals('Updated', strategicList2.get(0).Strategic_Initiative__c);
        
        Account acctResult = [Select id, Strategic_Context__c, Buying_Criteria__c from Account where id = :acct.id];
        system.assertEquals('Updated', acctResult.Strategic_Context__c);
        system.assertEquals('Updated', acctResult.Buying_Criteria__c);
                
        p_Test.delid = p_Test.localStrategicInitiatives.get(0).Id;
        p_Test.DeleteStrategicInitiatives();
        
        system.assertEquals(0, p_Test.localStrategicInitiatives.size());
        
        List<Strategic_Initiative__c> strategicList3 = [select id from Strategic_Initiative__c where account__c = :acct.id];     
		system.assertEquals(0, strategicList3.size());
 
		p_Test.borra();
		p_Test.borra2();
		p_Test.getExcelName();
		p_Test.ExportToExcel();
		
		//Account acctResult2 = [Select id, Strategic_Context__c, Buying_Criteria__c from Account where id = :acct.id];
        //system.assertEquals(null, acctResult2.Strategic_Context__c);
		
		
    }
}