@isTest
public class MenuSCPEnCuentaTest {

    static testMethod void test(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        MenuSCPEnCuentaController controller = new MenuSCPEnCuentaController();
        
        system.assertEquals(cuenta.id, controller.Acctid);
        
    }
}