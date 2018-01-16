@isTest
public class HitosRelevantesTest {
	
    static testMethod void test1() {
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Contenedor_de_hito2__c contenedorHito = new Contenedor_de_hito2__c();
        contenedorHito.name = 'Contenedor';
        contenedorHito.Cuenta__c = cuenta.id;
        insert contenedorHito;
        
        
         Hito_Relevante_2__c hito2 = new Hito_Relevante_2__c();
        hito2.name = 'hito';
        
        Hito_Relevante_2__c hito = new Hito_Relevante_2__c();
        hito.name = 'hito';
        
       
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        HitosRelevantesController controller = new HitosRelevantesController();
        
        controller.hitoAInsertar = hito;
        controller.insertHito();
        controller.guardar();
        
        controller.hitoAInsertar = hito2;
        controller.insertHito();
        controller.guardar();
        
        List<Hito_Relevante_2__c> hitos = new List<Hito_Relevante_2__c>();
        hitos = [select id, Categoria__c, Descripcion__c, Fecha__c from Hito_Relevante_2__c];
        
        system.assertEquals(2, hitos.size());
        
        controller.hitoABorrarId = hito2.id;
        controller.BorrarHito();
        controller.guardar();
        
        hitos = [select id, Categoria__c, Descripcion__c, Fecha__c from Hito_Relevante_2__c];
        
        system.assertEquals(1, hitos.size());
        
        system.assertEquals(controller.idCuenta, cuenta.id);
        
    }
    
    
    static testMethod void test2() {
        
        //Sin contenedor de hito creado
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Hito_Relevante_2__c hito = new Hito_Relevante_2__c();
        hito.name = 'hito';
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        HitosRelevantesController controller = new HitosRelevantesController();
        
        controller.hitoAInsertar = hito;
        controller.insertHito();
        
        List<Hito_Relevante_2__c> hitos = new List<Hito_Relevante_2__c>();
        hitos = [select id, Categoria__c, Descripcion__c, Fecha__c from Hito_Relevante_2__c];
        
        system.assertEquals(1, hitos.size());
        
        controller.hitoABorrarId = hito.id;
        controller.BorrarHito();
        
        hitos = [select id, Categoria__c, Descripcion__c, Fecha__c from Hito_Relevante_2__c];
        
        system.assertEquals(0, hitos.size());
        
    }
}