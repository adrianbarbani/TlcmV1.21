trigger Update_Project_EstadoTrigger on SCP_Certa_GC__Update_Project_Estado_batch__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        
        //IFB_S431_updateProjectEstado.        
        List<String> idDeltaDeProyectosAModificar = new List<String>();
        for(Update_Project_Estado_batch__c batch : Trigger.new){
            idDeltaDeProyectosAModificar.add(batch.idProyecto__c);
        }
        
        List<Proyecto__c> proyectosAModificar = [select id, Estado__c, ID_Delta__c from Proyecto__c where ID_Delta__c in: idDeltaDeProyectosAModificar];        
        
        Map<String, Proyecto__c> mapaIdDeltaPorProyecto = new Map<String, Proyecto__c>();
        for(Proyecto__c proyecto: proyectosAModificar){
            mapaIdDeltaPorProyecto.put(proyecto.ID_Delta__c, proyecto);
        }
        
        List<Proyecto__c> proyectosAActualizar = new List<Proyecto__c>();
        for(Update_Project_Estado_batch__c batch : Trigger.new){
            Proyecto__c proyecto = mapaIdDeltaPorProyecto.get(batch.idProyecto__c);
            
            if(proyecto == null){
                batch.addError('No se encontro un proyecto para el id '+batch.idProyecto__c);
            }else{
                proyecto.Estado__c = batch.estado__c;
                proyectosAActualizar.add(proyecto);
            }
            
        }
        
        update proyectosAActualizar;
    }
}