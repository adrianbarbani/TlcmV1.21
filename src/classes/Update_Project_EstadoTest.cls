@isTest
public class Update_Project_EstadoTest {

    static testMethod void InsertoUnProyectoBatchYseActualizaElEstadoDelProyecto() {
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.name = 'nueva';
        oportunidad.CloseDate = Date.today();
        oportunidad.StageName = 'Contacto Inicial';
        insert oportunidad;
        
        Proyecto__c proyecto = new Proyecto__c();
        proyecto.ID_Delta__c = '123';
        proyecto.Oportunidad__c = oportunidad.id;
        insert proyecto;
        
		Update_Project_Estado_batch__c batch = new Update_Project_Estado_batch__c();
		batch.idProyecto__c = '123';
        batch.estado__c = 'un estado';
        
        insert batch;
        
        Proyecto__c unProyectoYaActualizado = [select id, estado__c from Proyecto__c];
        
        system.assertEquals('un estado', unProyectoYaActualizado.estado__c);
        
    }
    
    static testMethod void InsertoUnProyectoBatchYNoHayUnProyectoConEseId() {
        
        Update_Project_Estado_batch__c batch = new Update_Project_Estado_batch__c();
        batch.idProyecto__c = '123';
        batch.estado__c = 'un estado';
        
        try{
            insert batch;
        }catch(Exception e){}
        
    }
}