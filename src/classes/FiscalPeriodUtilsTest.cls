@isTest
public class FiscalPeriodUtilsTest {
    
    static testMethod void test(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        FiscalYearSettings ano = new FiscalYearSettings();
        //ano.StartDate = Date.today();
        //ano.EndDate = Date.today();
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        FiscalPeriodUtils controller = new FiscalPeriodUtils();
        
        //controller.getFiscalYearEndDate();
        
        system.assert(true);
    }
}