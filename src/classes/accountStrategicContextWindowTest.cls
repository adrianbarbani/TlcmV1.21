@isTest
public class accountStrategicContextWindowTest {

    static testMethod void test1(){
        
            
        Account cuenta2 = new Account();
        cuenta2.name = 'CuentaPrueba';
        cuenta2.Strategic_Context__c = 'dasdasdasas';
        cuenta2.Buying_Criteria__c = 'dasdasbdgdgbvbv';
        insert cuenta2;
        
        Strategic_Initiative__c strategy = new Strategic_Initiative__c();
        //strategy.name = 'estrategia';
        strategy.Account__c = cuenta2.id;
        insert strategy;
        
        
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        cuenta.Strategic_Context__c = 'arnoezio';
        cuenta.Buying_Criteria__c = 'rogueonetoday';
        cuenta.ParentId = cuenta2.id;
        insert cuenta;
        
        Strategic_Initiative__c strategy2 = new Strategic_Initiative__c();
        //strategy.name = 'estrategia';
        strategy2.Account__c = cuenta.id;
        insert strategy2;
        
        Descripcion_del_cliente_New__c descr = new Descripcion_del_cliente_New__c();
        descr.name = 'desc';
        //descr.Cuenta__c = cuenta.id;
        //insert descr;
        
        Account_Competitor__c competidor = new Account_Competitor__c();
        competidor.name = 'comp';
        competidor.Account__c = cuenta.id;
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        AccountStrategicContextWindow controller = new accountStrategicContextWindow();
        
        controller.insertarData();
        
        controller.account = cuenta;
        
        controller.InsertIniciative();
        
        system.assertEquals(2, controller.localStrategicInitiatives.size());
        
        controller.delid = strategy2.id;
        controller.DeleteStrategicInitiatives();
        
        system.assertEquals(1, controller.localStrategicInitiatives.size());
        
        cuenta.Strategic_Context__c = 'dasda4353454354';
        cuenta.Buying_Criteria__c = 'lalalalalalal';
        controller.SaveChanges();
        
		controller.getExcelName();
		controller.ExportToExcel(); 
        
        controller.newCompetitor = competidor;
        controller.add();
        
        controller.InsertCompetitor();
        
        //system.assertEquals(2, controller.newCompetitors.size());
        
        controller.delid = competidor.id;
        controller.DeleteCompetitor();

		system.assertEquals(1, controller.newCompetitors.size());

		controller.borra();
		controller.borra2();

		system.assertEquals(null, controller.account.Buying_Criteria__c);
        system.assertEquals(null, controller.account.Buying_Criteria_Last_Update__c);
    }
    
}