@isTest
public class UpdateProy_preciosTest {

    static testMethod void InsertoUnProyectoBatchYseActualizaLosPreciosDelProyecto() {
        Opportunity oportunidad = new Opportunity();
        oportunidad.name = 'nueva';
        oportunidad.CloseDate = Date.today();
        oportunidad.StageName = 'Contacto Inicial';
        insert oportunidad;
        
        Proyecto__c proyecto = new Proyecto__c();
        proyecto.ID_Delta__c = '123';
        proyecto.Oportunidad__c = oportunidad.id;
        insert proyecto;
        
        Product2 producto = new Product2();
        producto.externalId = '321';
        producto.name = 'nuevo';
        insert producto;
        
        Asociacion_de_producto_con_proyecto__c asociacion = new Asociacion_de_producto_con_proyecto__c();
        asociacion.proyecto__c = proyecto.id;
        asociacion.producto__c = producto.id;
        insert asociacion;
        
        Update_Project_batch__c batch = new Update_Project_batch__c();
        batch.idProyecto__c = '123';
        batch.cantidad__c = 1;
        batch.idServicio__c = '321';
        batch.Moneda__c = '$';
        batch.Monto_uno__c = 100;
        batch.Monto_Mensual__c = 50;
        insert batch;
        
        Asociacion_de_producto_con_proyecto__c unProyectoYaActualizado = [select id, cantidad__c, moneda__c, monto_one__c, monto_Mensual__c from Asociacion_de_producto_con_proyecto__c];
        
        system.assertEquals(1, unProyectoYaActualizado.cantidad__c);
        system.assertEquals('ARG', unProyectoYaActualizado.moneda__c);
        system.assertEquals(100, unProyectoYaActualizado.monto_one__c);
        system.assertEquals(50, unProyectoYaActualizado.monto_Mensual__c);
    }
    
    static testMethod void InsertoUnProyectoBatchYNoHayUnProyectoConEseId() {
        
        Update_Project_batch__c batch = new Update_Project_batch__c();
        batch.idProyecto__c = '123';
        batch.cantidad__c = 1;
        batch.Moneda__c = 'ARG';
        batch.Monto_uno__c = 100;
        batch.Monto_Mensual__c = 50;
        try{
            insert batch;
        }catch(Exception e){}
        
    }
}