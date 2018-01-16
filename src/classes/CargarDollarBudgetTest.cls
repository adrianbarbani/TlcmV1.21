@isTest
public class CargarDollarBudgetTest {
	
    static testMethod void test1(){
        
        CargarDollarBudgetController controller = new CargarDollarBudgetController();
        
        system.assertEquals(0, controller.listaDollarBudget.size());
        
        CotizacionDollarBudget__c db1 = new CotizacionDollarBudget__c();
        db1.name = 'nombre';
        controller.DollarBudgetNuevo = db1;
        controller.saveDollarBudget();
        
        system.assertEquals(1, controller.listaDollarBudget.size());

        
    }
    
}