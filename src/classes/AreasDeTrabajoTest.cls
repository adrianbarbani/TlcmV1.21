@isTest
public class AreasDeTrabajoTest {
        
    static testMethod void insertarAreas(){
        
        Account obj = new Account();
        obj.name = 'Cuenta';
        insert obj;
        
        Area_de_trabajo__c area1 = new Area_de_trabajo__c();
        area1.name = 'Area 1';
        area1.cuenta__c = obj.id;
        insert area1;
        
        Reto__c reto1 = new Reto__c();
        reto1.name = 'Reto 1';
        reto1.Area_de_trabajo__c = area1.id;
        insert reto1;
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(obj.id));
        AreasDeTrabajoController controller = new AreasDeTrabajoController();
        
        system.assertEquals(1, controller.areas.size());
        system.assertEquals(1, controller.wrappersDeArea.size());
        
    }
    
    static testMethod void borrarYAgregarAreas(){
        
        Account obj = new Account();
        obj.name = 'Cuenta';
        insert obj;
        
        Area_de_trabajo__c area1 = new Area_de_trabajo__c();
        area1.name = 'Area 1';
        area1.cuenta__c = obj.id;
        insert area1;
        
        Reto__c reto1 = new Reto__c();
        reto1.name = 'Reto 1';
        reto1.Area_de_trabajo__c = area1.id;
        insert reto1;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(obj.id));
        AreasDeTrabajoController controller = new AreasDeTrabajoController();
        
        system.assertEquals(1, controller.areas.size());
        system.assertEquals(1, controller.wrappersDeArea.size());
        
        controller.areaABorrarId = area1.id;
        controller.borrarArea();
        controller.borrarSolucion();
        
        system.assertEquals(0, controller.wrappersDeArea.size());  
        
        Area_de_trabajo__c area2 = new Area_de_trabajo__c();
        area2.name = 'Area 2';
        area2.Titulo_Area__c = 'Area2';
                        
        controller.areaAInsertar = area2;
        controller.insertarArea();
        controller.obtenerAreasYGenerarWpp();
    	
        system.assertEquals(1, controller.wrappersDeArea.size());
        
     }
    
    static testMethod void borrarYAgregarTecnologias(){
        //List<String> listita = new List<String>();
        
        Account obj = new Account();
        obj.name = 'Cuenta';
        insert obj;
        
        Area_de_trabajo__c area1 = new Area_de_trabajo__c();
        area1.name = 'Area 1';
        area1.cuenta__c = obj.id;
        insert area1;
        
        Reto__c reto1 = new Reto__c();
        reto1.name = 'Reto 1';
        reto1.Area_de_trabajo__c = area1.id;
        insert reto1;
        
        Retos_Contacto__c retoContacto1 = new Retos_Contacto__c();
        retoContacto1.name = 'Reto Contacto 1';
        retocontacto1.Reto__c = reto1.id;
        insert retoContacto1;
        
        Reto_tecnologia__c retoTecnologia1 = new Reto_tecnologia__c();
        retoTecnologia1.name = 'Reto Tecno 1';
        retoTecnologia1.Reto__c = reto1.id;
        retoTecnologia1.Nivel_de_Desarrollo__c = 'Disponible';
        retoTecnologia1.Lista_de_Soluciones__c = 'Movilidad';
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(obj.id));
        AreasDeTrabajoController controller = new AreasDeTrabajoController();
        
        List<Reto_tecnologia__c> retos = new List<Reto_tecnologia__c>();
        
        retos = [select id, Lista_de_Soluciones__c, Nivel_de_Desarrollo__c, Observaci_n_sobre_el_producto__c, Otra_Solucion__c, Reto__c from Reto_tecnologia__c];
        
        system.assertEquals(0, retos.size());
        
        controller.solucionAInsertar = retoTecnologia1;
        
        controller.insertarSolucion();
        
        retos = [select id, Lista_de_Soluciones__c, Nivel_de_Desarrollo__c, Observaci_n_sobre_el_producto__c, Otra_Solucion__c, Reto__c from Reto_tecnologia__c];
        
        system.assertEquals(1, retos.size());
        
        controller.solucionIdABorrar = retoTecnologia1.id;
        
        controller.retoDeContactoABorrar = reto1.id;
        
        controller.borrarSolucion();
        
         retos = [select id, Lista_de_Soluciones__c, Nivel_de_Desarrollo__c, Observaci_n_sobre_el_producto__c, Otra_Solucion__c, Reto__c from Reto_tecnologia__c];
        
        system.assertEquals(0, retos.size());
                
        
    }
    
    static testMethod void borrarYAgregarContactos(){
        Account obj = new Account();
        obj.name = 'Cuenta';
        insert obj;
        
        Area_de_trabajo__c area1 = new Area_de_trabajo__c();
        area1.name = 'Area 1';
        area1.cuenta__c = obj.id;
        insert area1;
        
        Reto__c reto1 = new Reto__c();
        reto1.name = 'Reto 1';
        reto1.Area_de_trabajo__c = area1.id;
        insert reto1;
        
        Retos_Contacto__c retoContacto1 = new Retos_Contacto__c();
        retoContacto1.name = 'Reto Contacto 1';
        retoContacto1.Reto__c = reto1.id;
        retoContacto1.Nivel_de_Relaci_n__c = 'Fluida y Constante';
        retoContacto1.Tipo_de_Contacto__c = 'CEO';
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(obj);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(obj.id));
        AreasDeTrabajoController controller = new AreasDeTrabajoController();
        
        controller.contactoAInsertar = retoContacto1;
        controller.retoDeContactoABorrar = reto1.id;
        
        List<Retos_Contacto__c> contactos = new List<Retos_Contacto__c>();
        
        contactos = [select id, Nivel_de_Relaci_n__c, Otro_contacto_del_cliente__c, Tipo_de_Contacto__c, Reto__c from Retos_Contacto__c];
        
        system.assertEquals(0, contactos.size());
        
        controller.insertarContacto();
        
        contactos = [select id, Nivel_de_Relaci_n__c, Otro_contacto_del_cliente__c, Tipo_de_Contacto__c, Reto__c from Retos_Contacto__c];
        
        system.assertEquals(1, contactos.size());
        
        controller.contactoIdABorrar = retoContacto1.id;
        
        controller.borrarContacto();
        
        contactos = [select id, Nivel_de_Relaci_n__c, Otro_contacto_del_cliente__c, Tipo_de_Contacto__c, Reto__c from Retos_Contacto__c];
        
        system.assertEquals(0, contactos.size());
        
        
    }
}