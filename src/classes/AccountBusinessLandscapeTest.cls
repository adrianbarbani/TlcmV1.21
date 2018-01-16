@isTest
public class AccountBusinessLandscapeTest {

    static testMethod void test1(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Contenedor_de_hito2__c contenedor2 = new Contenedor_de_hito2__c();
        contenedor2.name = 'Contenedor';
        contenedor2.Cuenta__c = cuenta.id;
        insert contenedor2;
        
        Categoria_Servicio__c categoria = new Categoria_Servicio__c();
        categoria.name = 'Categoria1';
		insert categoria;
        
        Servicio__c servicio = new Servicio__c();
        servicio.name = 'Servicio1';
        servicio.Categoria_Servicio__c = categoria.id;
		insert servicio;
        
        Business_Landscape__c business = new Business_Landscape__c();
        business.name = 'business';
        business.Account__c = cuenta.id;
        business.Category_Service__c = categoria.name;
        insert business;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        AccountBusinessLandscapeController controller = new AccountBusinessLandscapeController();
        
        controller.getItems();
        controller.getServicios();
        
        //controller.hitoAInsertar = hito;
        controller.contenedor = contenedor2;
        
        system.assertEquals(1, controller.categoriasDeServicios.size());
        system.assertEquals(1, controller.businessLandscapeList.size());
        
        controller.categoriaSeleccionada = categoria.name;
        controller.servicioSeleccionado = servicio.name;
        controller.add();
        
        system.assertEquals(2, controller.businessLandscapeList.size());
        
        controller.toDel = business.id;
        controller.del();
        
        controller.save();
        
        //List<Business_Landscape__c> prueba2 = new List<Business_Landscape__c>();
        //prueba2 = [select id from Business_Landscape__c];
        
        system.assertEquals(1, controller.businessLandscapeList.size());
    }
    
    
    static testMethod void test2(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Contenedor_de_hito2__c contenedor2 = new Contenedor_de_hito2__c();
        contenedor2.name = 'Contenedor';
        contenedor2.Cuenta__c = cuenta.id;
        insert contenedor2;
        
        Categoria_Servicio__c categoria = new Categoria_Servicio__c();
        categoria.name = 'Categoria1';
		insert categoria;
        
        Servicio__c servicio = new Servicio__c();
        servicio.name = 'Servicio1';
        servicio.Categoria_Servicio__c = categoria.id;
		insert servicio;
        
        /*Business_Landscape__c business = new Business_Landscape__c();
        business.name = 'business';
        business.Account__c = cuenta.id;
        business.Category_Service__c = categoria.name;
        insert business;*/
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        AccountBusinessLandscapeController controller = new AccountBusinessLandscapeController();
        
        controller.siNoHayCreadoUnRegistroEnParqueDeServiciosGeneroUnoDeCadaUno();
        
        controller.contenedor = contenedor2;
        
        system.assertEquals(1, controller.categoriasDeServicios.size());
        
        List<Business_Landscape__c> prueba = new List<Business_Landscape__c>();
        prueba = [select id from Business_Landscape__c];
        
        system.assertEquals(20, prueba.size());
        
        controller.getExcelName();
        controller.ExportToExcel();
        
        
     }
    
}