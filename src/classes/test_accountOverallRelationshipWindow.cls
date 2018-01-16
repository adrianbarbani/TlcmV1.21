@isTest
private class test_accountOverallRelationshipWindow {

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
        cuenta.industry = 'Banking';
        
        insert cuenta;
        
        System.currentPagereference().getParameters().put('id',cuenta.id);
        
	    accountOverallRelationshipWindow p_Test = new accountOverallRelationshipWindow();
	    
	    p_Test.account.Brand_Strengths__c = 'Test';  
	    
	    p_Test.InsertCompetitor();
	    p_Test.newCompetitors.get(0).Name = 'Test';
	    p_Test.newCompetitors.get(0).Fact__c = 'Fact';
	    
	    p_Test.SaveChanges();
	    
	    Account accResult = [select id,Brand_Strengths__c from Account where id = :cuenta.id];
	    system.assertEquals('Test', accResult.Brand_Strengths__c);
	    
	    List<Account_Competitor__c> accCompList = [select id, Name, Fact__c from Account_Competitor__c where account__c = :cuenta.id]; 
	    system.assertEquals(1, accCompList.size());
	    
	    p_Test.add();
	    
	    List<Account_Competitor__c> accCompList2 = [select id, Name, Fact__c from Account_Competitor__c where account__c = :cuenta.id]; 
	    system.assertEquals(2, accCompList2.size());
	    
	    p_Test.delid = accCompList.get(0).id;
	    p_Test.DeleteCompetitor();
	    
	    List<Account_Competitor__c> accCompList3 = [select id, Name, Fact__c from Account_Competitor__c where account__c = :cuenta.id]; 
	    system.assertEquals(1, accCompList3.size());
	    
	    //Test DmlException
	    p_Test.newCompetitor = accCompList3.get(0);
	    p_Test.add();
	    system.assert(ApexPages.hasMessages());
	    
  }
}