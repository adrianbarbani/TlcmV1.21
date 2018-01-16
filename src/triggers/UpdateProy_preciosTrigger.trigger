trigger UpdateProy_preciosTrigger on SCP_Certa_GC__Update_Project_batch__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        
        //IFB_S427_UpdateProy.
        List<String> idDeltaDeProyectosAModificar = new List<String>();
        List<String> idDeltaDeProductos = new List<String>();
        for(Update_Project_batch__c batch : Trigger.new){
            idDeltaDeProyectosAModificar.add(batch.idProyecto__c);
            idDeltaDeProductos.add(batch.idServicio__c);
        }
        
        List<Asociacion_de_producto_con_proyecto__c> proyectosAModificar = [select id, Plazo_contrato__c, cantidad__c, moneda__c, Monto_one__c, monto_Mensual__c, proyecto__r.ID_Delta__c,
                                                                            producto__r.externalId
                                                                            from Asociacion_de_producto_con_proyecto__c 
                                                                            where proyecto__r.ID_Delta__c in: idDeltaDeProyectosAModificar and producto__r.externalId in: idDeltaDeProductos];
        
        Map<String, Asociacion_de_producto_con_proyecto__c> mapaIdDeltaPorProyecto = new Map<String, Asociacion_de_producto_con_proyecto__c>();
        for(Asociacion_de_producto_con_proyecto__c proyecto: proyectosAModificar){
            mapaIdDeltaPorProyecto.put(proyecto.proyecto__r.ID_Delta__c+proyecto.producto__r.externalId, proyecto);
        }
        
        List<Asociacion_de_producto_con_proyecto__c> asociacionesAUpdatear = new List<Asociacion_de_producto_con_proyecto__c>();
        for(Update_Project_batch__c batch : Trigger.new){
            Asociacion_de_producto_con_proyecto__c proyecto = mapaIdDeltaPorProyecto.get(''+batch.idProyecto__c+batch.idServicio__c);
            
            if(proyecto == null){
                //batch.hayError__c = true;
                //batch.Descripci_n_Error__c = 'No se encontro una asociacion de producto con proyecto para el id de proyecto '+batch.idProyecto__c+' y el id de producto '+batch.idServicio__c;
            	batch.addError('No se encontro una asociacion de producto con proyecto para el id de proyecto '+batch.idProyecto__c+' y el id de producto '+batch.idServicio__c);
            }else{
                proyecto.cantidad__c = batch.cantidad__c;
                
                if(batch.Moneda__c == '$'){
                    proyecto.moneda__c = 'ARG'; 
                }
                
                if(batch.Moneda__c == 'u$s'){
                    proyecto.moneda__c = 'USD'; 
                }
                
                if(batch.Moneda__c != '$' && batch.Moneda__c != 'u$s'){
                    batch.addError('La moneda ingresada: '+batch.Moneda__c+' no es una moneda valida. (valores validos: $ y u$s)');
                }
                
                proyecto.monto_one__c = batch.Monto_uno__c;
                proyecto.monto_Mensual__c = batch.Monto_Mensual__c;
                proyecto.Plazo_contrato__c = batch.Plazo_contrato__c;
                proyecto.tmi__c = batch.TMI_Pr__c;
                
                asociacionesAUpdatear.add(proyecto);
            }
            
        }
        
        update asociacionesAUpdatear;
    }
}