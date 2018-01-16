@isTest
public class AdministrarServiciosTest {
    
    static testMethod void obtenerCategoriasDeServicios(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Categoria_Servicio__c categoria2 = new Categoria_Servicio__c();
        categoria2.name = 'Categoria2';
        
        Categoria_Servicio__c categoria = new Categoria_Servicio__c();
        categoria.name = 'Categoria1';
              
        Servicio__c servicio = new Servicio__c();
        servicio.name = 'Servicio1';
                        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        AdministrarServiciosController controller = new AdministrarServiciosController();
		
        system.assertEquals(0, controller.categoriasDeServicios.size());
        
        controller.categoriaServicioAInsertar = categoria2;
        controller.InsertarCategoriaDeServicio();
        controller.categoriaServicioAInsertar = categoria;
        controller.InsertarCategoriaDeServicio();
               
        system.assertEquals(2, controller.categoriasDeServicios.size());
        
        List<Servicio__c> servicios = new List<Servicio__c>(); 
        
        servicios = [select id, name from Servicio__c where Categoria_Servicio__c =: categoria.id];
        
        system.assertEquals(0, servicios.size());
        
        controller.servicioAInsertar = servicio;
        controller.categoriaPadreDelServicioAInsertar = categoria.id;
        controller.InsertarServicio();
        
        servicios = [select id, name from Servicio__c where Categoria_Servicio__c =: categoria.id];
        system.assertEquals(1, servicios.size());
        
        controller.servicioABorrarId = servicio.id;
        controller.borrarServicio();
        
        servicios = [select id, name from Servicio__c where Categoria_Servicio__c =: categoria.id];
        system.assertEquals(0, servicios.size());
        
        controller.categoriaABorrarId = categoria.id;
        controller.borrarCategoriaDeServicio();
        
        system.assertEquals(1, controller.categoriasDeServicios.size());
    }
    
}