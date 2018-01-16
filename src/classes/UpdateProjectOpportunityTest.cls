@isTest
public class UpdateProjectOpportunityTest {

    static testMethod void InsertoUnProyectOpportunityBatchYseCreaUnProyecto() {

        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.descripci_n_proyecto__c = '123';
        batch.accion__c = 'Alta';
        batch.ID_Oportunidad__c = opp.id;
        
        insert batch;
        
        List<Proyecto__c> proyectos = [select id, Oportunidad__c, name from proyecto__c];
        system.assertEquals(1, proyectos.size());
        system.assertEquals(opp.id, proyectos[0].Oportunidad__c);
        system.assertEquals('123', proyectos[0].name);
    }
    
    static testMethod void doyDeBajaUnProyecto() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.descripci_n_proyecto__c = '123';
        batch.accion__c = 'Alta';
        batch.ID_Oportunidad__c = opp.id;
        
        insert batch;
        
        List<Proyecto__c> proyectos = [select id, Oportunidad__c, name from proyecto__c];
        system.assertEquals(1, proyectos.size());
        
        Update_Project_Opportunity__c batchBaja = new Update_Project_Opportunity__c();
        batchBaja.Id_proyecto__c = 123;
        batchBaja.descripci_n_proyecto__c = '123';
        batchBaja.accion__c = 'Baja';
        batchBaja.ID_Oportunidad__c = opp.id;
        
        insert batchBaja;
        
        proyectos = [select id, Oportunidad__c, name from proyecto__c];
        system.assertEquals(0, proyectos.size());
    }
    
    static testMethod void modificoUnProyecto() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.descripci_n_proyecto__c = '123';
        batch.accion__c = 'Alta';
        batch.ID_Oportunidad__c = opp.id;
        
        insert batch;
        
        List<Proyecto__c> proyectos = [select id, Oportunidad__c, name from proyecto__c];
        system.assertEquals(1, proyectos.size());
        
        Update_Project_Opportunity__c batchModificacion = new Update_Project_Opportunity__c();
        batchModificacion.Id_proyecto__c = 123;
        batchModificacion.descripci_n_proyecto__c = 'modificado';
        batchModificacion.accion__c = 'Modificacion';
        batchModificacion.ID_Oportunidad__c = opp.id;
        
        insert batchModificacion;
        
        proyectos = [select id, Oportunidad__c, name from proyecto__c];
        system.assertEquals(1, proyectos.size());
        system.assertEquals('modificado', proyectos[0].name);
    }
    
    static testMethod void doyDeAltaLaRelacionConUnServicio() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        proyecto__c proy = new proyecto__c();
        proy.Oportunidad__c = opp.id;
        proy.ID_Delta__c = '123';
        insert proy;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.ID_Servicio__c = 321;
        batch.accion__c = 'Alta';
        batch.cantidad__c = 1;
        
        insert batch;
        
        List<Asociacion_de_producto_con_proyecto__c> asociaciones = [select id, Producto__c, cantidad__c, proyecto__c from Asociacion_de_producto_con_proyecto__c];
        
        system.assertEquals(1, asociaciones.size());
        system.assertEquals(producto.id, asociaciones[0].Producto__c);
    }
    
    static testMethod void doyDeBajaLaRelacionConUnServicio() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        proyecto__c proy = new proyecto__c();
        proy.Oportunidad__c = opp.id;
        proy.ID_Delta__c = '123';
        insert proy;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.ID_Servicio__c = 321;
        batch.accion__c = 'Alta';
        batch.cantidad__c = 1;
        
        insert batch;
        
        List<Proyecto__c> proyectos = [select id, Producto__c from proyecto__c];
        
        system.assertEquals(1, proyectos.size());
		
        Update_Project_Opportunity__c batchBaja = new Update_Project_Opportunity__c();
        batchBaja.Id_proyecto__c = 123;
        batchBaja.ID_Servicio__c = 321;
        batchBaja.accion__c = 'Baja';
        batchBaja.cantidad__c = 1;
        
        insert batchBaja;

		proyectos = [select id, Producto__c from proyecto__c];
        
        system.assertEquals(1, proyectos.size());
        system.assertEquals(null, proyectos[0].producto__c);        
    }
    
    static testMethod void modificoLaRelacionConUnServicio() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        proyecto__c proy = new proyecto__c();
        proy.Oportunidad__c = opp.id;
        proy.ID_Delta__c = '123';
        insert proy;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.ID_Servicio__c = 321;
        batch.accion__c = 'Alta';
        batch.cantidad__c = 1;
        
        insert batch;
        
        List<Proyecto__c> proyectos = [select id, Producto__c from proyecto__c];
        
        system.assertEquals(1, proyectos.size());
        
        Update_Project_Opportunity__c batchModificacion = new Update_Project_Opportunity__c();
        batchModificacion.Id_proyecto__c = 123;
        batchModificacion.ID_Servicio__c = 321;
        batchModificacion.accion__c = 'Modificacion';
        batchModificacion.cantidad__c = 12;
        
        insert batchModificacion;
        
        List<Asociacion_de_producto_con_proyecto__c> asociaciones = [select id, Producto__c, cantidad__c, proyecto__c from Asociacion_de_producto_con_proyecto__c];
        
        system.assertEquals(1, asociaciones.size());
        system.assertEquals(proy.id, asociaciones[0].proyecto__c);
        system.assertEquals(producto.id, asociaciones[0].Producto__c);
        system.assertEquals(12, asociaciones[0].cantidad__c);        
    }
    
    static testMethod void manejoDeErrorIdProyectoNoValido() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        proyecto__c proy = new proyecto__c();
        proy.Oportunidad__c = opp.id;
        proy.ID_Delta__c = '123';
        insert proy;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 1223;
        batch.ID_Servicio__c = 321;
        batch.accion__c = 'Alta';
        batch.cantidad__c = 1;
        
        try{
            insert batch;
        }catch(Exception e){}     
    }
    
    static testMethod void manejoDeErrorIdServicioNoValido() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        proyecto__c proy = new proyecto__c();
        proy.Oportunidad__c = opp.id;
        proy.ID_Delta__c = '123';
        insert proy;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.ID_Servicio__c = 3211;
        batch.accion__c = 'Alta';
        batch.cantidad__c = 1;
        
        try{
            insert batch;
        }catch(Exception e){}       
    }
    
    static testMethod void manejoDeErrorAccionNoValida() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        proyecto__c proy = new proyecto__c();
        proy.Oportunidad__c = opp.id;
        proy.ID_Delta__c = '123';
        insert proy;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.ID_Servicio__c = 321;
        batch.accion__c = 'Altaasdasd';
        batch.cantidad__c = 1;
        
        try{
            insert batch;
        }catch(Exception e){}       
    }
    
    static testMethod void InsertoUnProyectAccionNoValida() {
        
        Opportunity opp = new Opportunity();
        opp.name = 'hola';
        opp.StageName = 'cerrada';
        opp.CloseDate = Date.today();
        insert opp;
        
        Update_Project_Opportunity__c batch = new Update_Project_Opportunity__c();
        batch.Id_proyecto__c = 123;
        batch.descripci_n_proyecto__c = '123';
        batch.accion__c = 'Altaasdasd';
        batch.ID_Oportunidad__c = opp.id;
        
        try{
            insert batch;
        }catch(Exception e){}
    }
}