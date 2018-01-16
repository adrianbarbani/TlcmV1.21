@isTest
private class test_FastTaskController {

    static testMethod void myUnitTest() {
      //Con industria
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
        
        FastTaskController p_Test = new FastTaskController();
        p_Test.getcanEdit();
        p_Test.accountId = cuenta.id;
        p_Test.savetask();
        
        List<Task> taskList = [select id from Task];
        system.assertEquals(1, taskList.size());
    }
}