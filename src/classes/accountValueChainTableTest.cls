@isTest
public class accountValueChainTableTest {

    static testMethod void test(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        VCFunction__c funcion = new VCFunction__c();
        funcion.name = 'nombre';
        funcion.Account__c = cuenta.id;
        insert funcion;
        
        Value_Chain__c value = new Value_Chain__c();
        //value.Name = 'nombrevalue';
        value.Function__c = funcion.id;
        insert value;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        accountValueChainTableController controller = new accountValueChainTableController();
        
        controller.getFunctionList();
        controller.newFunction();
        controller.saveChanges();
        
        controller.functionId = funcion.id;
        controller.deleteFunction();
        
        controller.vcId = value.id;
        controller.deleteVC();
     
        system.assertEquals(0, controller.functionSortList.size());
    }
    
}