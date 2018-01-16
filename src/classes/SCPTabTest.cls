@isTest
public class SCPTabTest {
	
    static testMethod void test(){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Area_de_trabajo__c area = new Area_de_trabajo__c();
        area.Name = 'area1';
        area.Cuenta__c = cuenta.id;
        insert area;
        
        Reto__c reto = new Reto__c();
        reto.Name = 'reto1';
        reto.Area_de_trabajo__c = area.id;
        reto.Fecha_Compromiso__c = Date.today();
        reto.Nombre_del_Reto__c = 'nombrereto';
        reto.Nota__c = 'dasdasdasdas';
        insert reto;
        
        Contenedor_de_hito__c contenedorHito = new Contenedor_de_hito__c();
        contenedorHito.name = 'Contenedor';
        contenedorHito.Cuenta__c = cuenta.id;
        insert contenedorHito;
        
        Hito_Relevante__c hito = new Hito_Relevante__c();
        hito.name = 'hito';
        hito.Contenedor_de_hito__c = contenedorHito.id;
        hito.Fecha__c = Date.today();
        hito.Categoria__c = 'Vencimiento Contrato Activo con la Competencia';
        hito.Descripcion__c = 'dasdasas';
        
        insert hito;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(cuenta);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(cuenta.id));
        SCPTabController controller = new SCPTabController();
        
        controller.filtroVencimiento = true;
        controller.filtroEventoTelefonica = true;
        controller.filtroEventosDeTipoReto = true;
        controller.filtroVencimientoCompetencia = true;
        controller.filtroPublicacionRFPComunicacion = true;
        controller.filtroPublicacionRFPTI = true;
        controller.filtroEventoIndustria = true;
        controller.filtroPrevisionTOP3 = true;
        controller.filtroOtroTipoDeEvento = true;
   		controller.todos = true;        
        
        controller.filtroDeNombre = '';
        controller.filtrar();
        
        system.assertEquals(1, controller.setCuentas.getRecords().size());
        
        controller.filtroDeNombre = 'Cuent';
        controller.filtrar();
        
        system.assertEquals(1, controller.setCuentas.getRecords().size());
        
        controller.establecerValoresDeLaLineaDeTiempo();
        controller.obtenerAnterior();
        controller.obtenerSiguiente();
        controller.obtenerPrimerPagina();
        controller.obtenerUltimaPagina();
        controller.filtrarTimeLine();
        
        List<Reto__c> listaRetos = new List<Reto__c>();
        listaRetos.add(reto);
        
        controller.generarDatosRetos(listaRetos);
       
        
    }
}