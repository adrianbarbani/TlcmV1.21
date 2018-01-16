@isTest
public class LineaDeTiempoTest {
	
    static testMethod void test1(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Area_de_trabajo__c area = new Area_de_trabajo__c();
        area.name = 'area1';
        area.Cuenta__c = cuenta.id;
        insert area;
        
        Reto__c reto = new Reto__c();
        reto.name = 'reto1';
        reto.Area_de_trabajo__c = area.id;
        reto.Fecha_Compromiso__c = Date.today();
        reto.Nombre_del_Reto__c = 'nombre';
        reto.Nota__c = 'dasdasdassa';
        insert reto; 
        
        Contenedor_de_hito2__c contenedorHito = new Contenedor_de_hito2__c();
        contenedorHito.name = 'Contenedor';
        contenedorHito.Cuenta__c = cuenta.id;
        insert contenedorHito;
                
        Hito_Relevante_2__c hito = new Hito_Relevante_2__c();
        hito.name = 'hito';
        hito.Contenedor_de_hito__c = contenedorHito.id;
        hito.Fecha__c = Date.today();
        hito.Categoria__c = 'Vencimiento Contrato Activo con la Competencia';
        hito.Descripcion__c = 'dasdasdasdasdasdasdasdsa';
        insert hito;
        
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        LineaDeTiempoController controller = new LineaDeTiempoController();
        
        controller.filtroVencimiento = true;
        controller.filtroEventoTelefonica = true;
        controller.filtroEventosDeTipoReto = true;
        controller.filtroVencimientoCompetencia = true;
        controller.filtroPublicacionRFPComunicacion =true;
        controller.filtroPublicacionRFPTI = true;
        controller.filtroEventoIndustria = true;
        controller.filtroPrevisionTOP3 = true;
        controller.filtroOtroTipoDeEvento = true;
        controller.todos = true;  
        
        controller.filtrarTimeLine();
        
        system.assertEquals(1, controller.hitos.size());
        system.assertEquals(1, controller.retos.size());
        
    }
    
}