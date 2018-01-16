@isTest
public class BigDealButtonsTest {
	
    static testMethod void test (){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.name = 'dasdsa';
        oportunidad.StageName = 'Prospecting';
        oportunidad.CloseDate = Date.today();
        insert oportunidad;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(oportunidad);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(oportunidad.id));
        PageReference pageRef = Page.AdministrarServicios;
		Test.setCurrentPage(pageRef);
        BigDealButtonsController controller = new BigDealButtonsController(stdController);
        
        
        
        controller.check();
        controller.uncheck();
        controller.gotosurvey();
        
    }
}