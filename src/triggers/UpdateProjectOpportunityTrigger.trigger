trigger UpdateProjectOpportunityTrigger on SCP_Certa_GC__Update_Project_Opportunity__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        //IFB_S426_UpdateProjectOpportunity
        
        List<Proyecto__c> proyectosAInsertar = new List<Proyecto__c>();
        List<String> idsproyectosAEliminar = new List<String>();
        List<String> idsDeltaDeProyectosAModifircar = new List<String>();
        Map<String, Update_Project_Opportunity__c> proyectosBatchporIdDelta = new Map<String, Update_Project_Opportunity__c>();
        
        List<String> listaIdDeServiciosABuscar = new List<String>();
        List<String> listaIdDeProyectosABuscar = new List<String>();
        
        List<String> listaIdDeServiciosAModificar = new List<String>();
        List<String> listaIdDeProyectosAModificar = new List<String>();
        
        for(Update_Project_Opportunity__c batch : Trigger.new){
            if(batch.Id_proyecto__c != null && batch.ID_Servicio__c != null && batch.accion__c != null && batch.cantidad__c != null){
                listaIdDeServiciosABuscar.add(String.valueOf(batch.ID_Servicio__c));
                listaIdDeProyectosABuscar.add(String.valueOf(batch.Id_proyecto__c));
                
                if(batch.accion__c == 'Modificacion' || batch.accion__c == 'Modificación'){
                    listaIdDeServiciosAModificar.add(String.valueOf(batch.ID_Servicio__c));
                    listaIdDeProyectosAModificar.add(String.valueOf(batch.Id_proyecto__c));
                }
            }
        }
        
        List<Asociacion_de_producto_con_proyecto__c> asociacionesAModificar = [select id, cantidad__c, proyecto__r.id_delta__c, producto__r.externalId from Asociacion_de_producto_con_proyecto__c 
                                                                               where proyecto__r.id_delta__c in: listaIdDeProyectosAModificar and producto__r.externalId in: listaIdDeServiciosAModificar];
        
        Map<String,Asociacion_de_producto_con_proyecto__c> asociacionesPorIds = new Map<String,Asociacion_de_producto_con_proyecto__c>();
        for(Asociacion_de_producto_con_proyecto__c aso: asociacionesAModificar){
            asociacionesPorIds.put(''+aso.proyecto__r.id_delta__c+aso.producto__r.externalId, aso);
        }
        
        List<Proyecto__c> proyectosAModificar = [select id, Producto__c, cantidad__c, ID_Delta__c from Proyecto__c where ID_Delta__c in: listaIdDeProyectosABuscar];
        List<Product2> productosAAsignar = [select id, externalId from product2 where externalId in: listaIdDeServiciosABuscar];
        
        Map<String, Proyecto__c> proyectosMap = new Map<String, Proyecto__c>();
        Map<String, String> productosMap = new Map<String, String>();
        
        for(Proyecto__c proy: proyectosAModificar){
            proyectosMap.put(proy.ID_Delta__c, proy);
        }
        
        for(Product2 pro: productosAAsignar){
            productosMap.put(pro.externalId, pro.id);
        }
        
        List<Asociacion_de_producto_con_proyecto__c> asociacionesAInsertar = new List<Asociacion_de_producto_con_proyecto__c>();
        List<String> idsAsociacionDeProyectoAEliminarProyecto = new List<String>();
        List<String> idsAsociacionDeProyectoAEliminarProducto = new List<String>();
        List<Asociacion_de_producto_con_proyecto__c> asociacionesAActualizar = new List<Asociacion_de_producto_con_proyecto__c>();
        for(Update_Project_Opportunity__c batch : Trigger.new){
            
            //Proyectos.
            if(batch.Id_proyecto__c != null && batch.descripci_n_proyecto__c != null && batch.ID_Oportunidad__c != null && batch.accion__c != null){
                
                //alta
                if(batch.Accion__c == 'Alta'){
                    Proyecto__c proyecto = new Proyecto__c();
                    proyecto.name = batch.descripci_n_proyecto__c;
                    proyecto.ID_Delta__c = String.valueOf(batch.Id_proyecto__c);
                    proyecto.Oportunidad__c = batch.ID_Oportunidad__c;
                    
                    proyectosAInsertar.add(proyecto);
                }
                //baja
                if(batch.Accion__c == 'Baja'){
                    idsproyectosAEliminar.add(String.valueOf(batch.Id_proyecto__c));
                }
                //modificacion
                if(batch.Accion__c == 'Modificación' || batch.Accion__c == 'Modificacion'){
                    idsDeltaDeProyectosAModifircar.add(String.valueOf(batch.Id_proyecto__c));
                    proyectosBatchporIdDelta.put(String.valueOf(batch.Id_proyecto__c), batch);
                }
                
                if(batch.Accion__c != 'Modificación' && batch.Accion__c != 'Modificacion' && batch.Accion__c != 'Baja' && batch.Accion__c != 'Alta'){
                    //batch.hayError__c = true;
                    //batch.descripcion_del_error__c = 'la accion: '+batch.id_proyecto__c+' no es valida, acciones validas (Alta, Baja, Modificacion/Modificación)';
                    batch.addError('la accion: '+batch.id_proyecto__c+' no es valida, acciones validas (Alta, Baja, Modificacion/Modificación)');
                }
            }
            
            //Servicios.
            if(batch.Id_proyecto__c != null && batch.ID_Servicio__c != null && batch.accion__c != null && batch.cantidad__c != null){
                
                if(proyectosMap.get(String.valueOf(batch.Id_proyecto__c)) != null ){
                    //alta
                    if(batch.Accion__c == 'Alta'){
                        if(productosMap.get(String.valueOf(batch.ID_Servicio__c)) != null){
                            
                            Asociacion_de_producto_con_proyecto__c asociacion = new Asociacion_de_producto_con_proyecto__c();
                            asociacion.proyecto__c = proyectosMap.get(String.valueOf(batch.Id_proyecto__c)).id;
                            asociacion.producto__c = productosMap.get(String.valueOf(batch.ID_Servicio__c));
                            asociacion.cantidad__c = batch.cantidad__c;
							
                            asociacionesAInsertar.add(asociacion);
                            
                        }else{
                            //batch.hayError__c = true;
                            //batch.descripcion_del_error__c = 'no existe un servicio con id delta: '+batch.ID_Servicio__c;
                            batch.addError('no existe un servicio con id delta: '+batch.ID_Servicio__c);
                        }
                    }
                    //baja
                    if(batch.Accion__c == 'Baja'){
                        
                        if(proyectosMap.get(String.valueOf(batch.Id_proyecto__c)).id == null || productosMap.get(String.valueOf(batch.ID_Servicio__c)) == null){
                            //batch.hayError__c = true;
                            //batch.descripcion_del_error__c = 'Ambos ids son obligatorios para la baja de una asociacion de un producto a un proyecto';
							batch.addError('Ambos ids son obligatorios para la baja de una asociacion de un producto a un proyecto');                            
                        }else{
                            idsAsociacionDeProyectoAEliminarProyecto.add(proyectosMap.get(String.valueOf(batch.Id_proyecto__c)).id);
                            idsAsociacionDeProyectoAEliminarProducto.add(productosMap.get(String.valueOf(batch.ID_Servicio__c)));
                        }
                        
                    }
                    //modificacion
                    if(batch.Accion__c == 'Modificación' || batch.Accion__c == 'Modificacion'){
                        asociacionesPorIds.get(''+batch.Id_proyecto__c+batch.ID_Servicio__c).cantidad__c = batch.cantidad__c;
                        asociacionesAActualizar.add(asociacionesPorIds.get(''+batch.Id_proyecto__c+batch.ID_Servicio__c));
                    }
                    
                    if(batch.Accion__c != 'Modificación' && batch.Accion__c != 'Modificacion' && batch.Accion__c != 'Baja' && batch.Accion__c != 'Alta'){
                        //batch.hayError__c = true;
                        //batch.descripcion_del_error__c = 'la accion: '+batch.id_proyecto__c+' no es valida, acciones validas (Alta, Baja, Modificacion/Modificación)';
                        batch.addError('la accion: '+batch.id_proyecto__c+' no es valida, acciones validas (Alta, Baja, Modificacion/Modificación)');
                    }
                    
                }else{
                    //batch.hayError__c = true;
                    //batch.descripcion_del_error__c = 'no existe un proyecto con id delta: '+batch.id_proyecto__c;
                    batch.addError('no existe un proyecto con id delta: '+batch.id_proyecto__c);
                }
            }
            
        }
        
        //Proyectos.
        //Alta
        if(proyectosAInsertar.size()>0){
            insert proyectosAInsertar;
        }
        
        //Baja
        if(idsproyectosAEliminar.size()>0){
            delete [select id from proyecto__c where Id_delta__c in: idsproyectosAEliminar];
        }
        
        //Modificacion
        if(idsDeltaDeProyectosAModifircar.size()>0){
            List<Proyecto__c> proyectosQueSeTienenQueModificar = [select id, name, ID_Delta__c from proyecto__c where ID_Delta__c in: idsDeltaDeProyectosAModifircar];
            
            for(Proyecto__c proyecto: proyectosQueSeTienenQueModificar){
                proyecto.name = proyectosBatchporIdDelta.get(proyecto.ID_Delta__c).descripci_n_proyecto__c;
            }
            
            update proyectosQueSeTienenQueModificar;
        }
        
        //Servicios
        //Alta
        if(asociacionesAInsertar.size()>0){
            insert asociacionesAInsertar;
        }
        
        //Baja
        if(idsAsociacionDeProyectoAEliminarProducto.size()>0 && idsAsociacionDeProyectoAEliminarProyecto.size()>0){
            delete [select id from Asociacion_de_producto_con_proyecto__c 
                    where proyecto__r.Id_delta__c in: idsAsociacionDeProyectoAEliminarProyecto and producto__r.externalId in: idsAsociacionDeProyectoAEliminarProducto];
        }
        
        //modificacion.
        if(asociacionesAActualizar.size()>0){
            update asociacionesAActualizar;
        }
        
    }
}