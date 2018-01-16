@isTest
public class EjesDeTrabajoTest {

    static testMethod void test1(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Area_de_trabajo__c area1 = new Area_de_trabajo__c();
        area1.Name = 'Area1';
        area1.Cuenta__c = cuenta.id;
        area1.Tipo_de_Area__c = 'Comunicaciones';
        area1.Conocimiento_del_Area__c = 'Alto';
        insert area1;
        
        Reto__c reto1 = new Reto__c();
        reto1.Nombre_del_Reto__c = 'Reto1';
        reto1.Area_de_trabajo__c = area1.id;
        reto1.Competidor__c = 'dasdasdas';
        reto1.Etapa_del_Reto__c = 'Compras';
        insert reto1;        
        
        Reto__c reto2 = new Reto__c();
        reto2.Nombre_del_Reto__c = 'Reto2';
        reto2.Area_de_trabajo__c = area1.id;
        reto2.Competidor__c = 'lolololo';
        reto1.Etapa_del_Reto__c = 'Diseño';
        insert reto2; 
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        EjesDeTrabajoController controller = new EjesDeTrabajoController();
        
        system.assertEquals(1, controller.areasDeTrabajo.size());
        system.assertEquals(1, controller.areas.size());
        system.assertEquals(2, controller.retosAreas.size());
    }
    	
}