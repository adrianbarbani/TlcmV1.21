@isTest
private class test_AccountCapabilityMatrixController  {

    
    static testMethod void myUnitTest() {

        Account myAccount=new Account(Name = 'Test');
        insert myAccount;
        
        System.currentPagereference().getParameters().put('id',myAccount.id);
        accountCapabilityMatrixController acmc = new accountCapabilityMatrixController();
        
        acmc.newCapabilityArea.name = 'Test';
        acmc.newCapabilityArea();
        acmc.saveChanges();
        
        List<CapabilityArea__c> caResult = [select id from CapabilityArea__c where name = 'Test' limit 1];
        system.assert(caResult.size() > 0, 'No se creo el objeto CapabilityArea__c');
        
        Capability__c capability = new Capability__c();
        insert capability;
        
        acmc.capabilityId = capability.id;
        acmc.deleteVC();
        
        List<Capability__c> capabilityResult = [select id from Capability__c where id = :capability.id];
        system.assert(capabilityResult.size() == 0, 'No se elimino el objeto Capability__c');
                
        acmc.capabilityAreaId = caResult[0].id;
        acmc.deletecapabilityArea();

        List<CapabilityArea__c> caResult2 = [select id from CapabilityArea__c where name = 'Test' limit 1];
        system.assert(caResult2.size() == 0, 'No se elimino el objeto CapabilityArea__c');
        
        acmc.getCapabilityWrapperList();
    
    }
        

}