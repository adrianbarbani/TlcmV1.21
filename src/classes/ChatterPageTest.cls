@isTest
public class ChatterPageTest {

    static testMethod void test (){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        ChatterPageController controller = new ChatterPageController();
        
        system.assertEquals(cuenta.id, controller.accountId);
    }
}