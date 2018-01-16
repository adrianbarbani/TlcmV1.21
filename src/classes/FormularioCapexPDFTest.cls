@isTest
public class FormularioCapexPDFTest {

    static testMethod void test(){
        
		Solicitud_Capex__c solicitud = new Solicitud_Capex__c();
		solicitud.name = 'nombre';
        solicitud.Fecha_de_Licitacion__c = Date.today();
        insert solicitud;

		ApexPages.StandardController stdController = new ApexPages.StandardController(solicitud);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(solicitud.id));
        FormularioCapexPDFController controller = new FormularioCapexPDFController();        
        
        //Dia de la fecha en que se hace el test (Date.today)
        system.assertEquals(Date.today().day()+'/'+Date.today().month()+'/'+Date.today().year(), controller.fechaLicitacion);
    }	
}