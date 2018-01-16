@isTest
private class Test_AccountPastProvenValueNewController {

	static testMethod void myUnitTest() {
		

		/* Create Region */
		Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__C(name='Latam', parent__c = regionGlobal.id);
        insert regionLocal;
		
		/* Create Account */
		String accountName = 'Account Test';
		Account acctParent = new Account(Name=accountName);
		insert acctParent;		
				
		Account acct = new Account(Name=accountName, Region__c=regionLocal.id, parentId = acctParent.id);
		insert acct;
		
		List<Account> acctResult = [select id from Account where name = :accountName];
		system.Assert(acctResult.size()>0, 'Error to create Account: ' + acct);
		
		String description = 'Update Descr';
		PastProvenValueNew__c ppvNew = new PastProvenValueNew__c(Unique_Value__c = description, account__c = acctParent.id);
		
		/* Set Page and Create Controller*/
		System.currentPagereference().getParameters().put('id',acct.id);
		AccountPastProvenValueNewController controller = new AccountPastProvenValueNewController();
		
		controller.add();
		List<PastProvenValueNew__c> ppvList = [select id from PastProvenValueNew__c where account__c = :acct.id]; 
		system.assert(ppvList.size() == 1);
						
		controller.pastProvenValueNewList.get(0).Unique_Value__c = description;
		controller.pastProvenValueNewList.get(0).type__c = 'Account Success Stories';
		controller.save();
		
		List<PastProvenValueNew__c> ppvList2 = [select id, Unique_Value__c from PastProvenValueNew__c where account__c = :acct.id];				
		system.assertEquals(description,ppvList2.get(0).Unique_Value__c);		
		
		AccountPastProvenValueNewController controller2 = new AccountPastProvenValueNewController();
		controller2.toDel = controller2.pastProvenValueNewList.get(0).id;
		
		controller2.del();
		List<PastProvenValueNew__c> ppvList3 = [select id from PastProvenValueNew__c where account__c = :acct.id];				
		system.assert(ppvList3.size()==0);
		
		controller2.getExcelName();
		controller2.ExportToExcel();
		
	}

}