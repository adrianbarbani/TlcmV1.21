trigger UpdatePortfolioTrigger on SCP_Certa_GC__Update_Portfolio_batch__c (before insert) {

    if(trigger.isBefore && trigger.isInsert){
        
        //IFB_S424_updatePortfolio.        
        List<String> idDeltaDeUsuarios = new List<String>();
        List<Double> idCuentas = new List<Double>();
        List<String> idCuentasClienteLegado = new List<String>();
        List<OportunidadAUpdatear> listaDeOportuniadadesAUpdatear = new List<OportunidadAUpdatear>();
        
        
        for(Update_Portfolio_batch__c batch : Trigger.new){
            idDeltaDeUsuarios.add(batch.Asignado__c);
            idCuentas.add(Double.valueOf(batch.Cliente__c));
            idCuentasClienteLegado.add(batch.idClienteLegado__c);
        }
        
        List<Account> cuentas = [select id, CUIT__c, idClienteLegado__c from account where CUIT__c in: idCuentas and idClienteLegado__c In: idCuentasClienteLegado];
        
        Map<String, String> mapaIdCuentas = new Map<String, String>();
        for(Account cuenta: cuentas){
            mapaIdCuentas.put(cuenta.CUIT__c+cuenta.idClienteLegado__c, cuenta.id);
        }
        
        List<User> usuarios = [select id, FederationIdentifier from User where FederationIdentifier in: idDeltaDeUsuarios];
        
        Map<String, String> mapaIdUsuarios = new Map<String, String>();
        for(User usuario: usuarios){
            mapaIdUsuarios.put(usuario.FederationIdentifier, usuario.id);
        }
        
        //Alta
        List<AccountTeamMember> miembroDeEquipoDeCuentaAAgregar = new List<AccountTeamMember>();
        //baja
        List<String> idsCuentasBaja = new List<String>();
        List<String> iduserAsignadoBaja = new List<String>();
        Map<String, String> mapaDeBajaDeEquipoDeCuenta = new Map<String, String>();
        //modificacion
        List<String> idsCuentasModificacion = new List<String>();
        List<String> iduserAsignadoModificacion = new List<String>();
        Map<String,String> mapaDeBajaEnModificacion = new map<String,String>();
        
        for(Update_Portfolio_batch__c batch : Trigger.new){
            
            if(batch.Accion__c == 'Alta'){
                if(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c) != null){
                    
                    batch.hayError__c = false;
                    AccountTeamMember a = new AccountTeamMember();
                    
                    a.accountId = mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c);
                    a.teamMemberRole = batch.Descripcion_Rol__c;
                    a.userId = mapaIdUsuarios.get(batch.Asignado__c);
                    
                    if(a.teamMemberRole.equalsIgnoreCase('EJECUTIVO DE CUENTA')){
                        a.accountAccessLevel = 'Read';
                        a.contactAccessLevel = 'Edit';
                        a.OpportunityAccessLevel = 'Edit';
                        
                        OportunidadAUpdatear oppUp = new oportunidadAUpdatear(a.accountId, a.userId);
                        listaDeOportuniadadesAUpdatear.add(oppUp);
                        
                    }else{
                        
                        if(a.teamMemberRole.equalsIgnoreCase('INGENIERO DE CUENTA')){
                            a.accountAccessLevel = 'Read';
                            a.OpportunityAccessLevel = 'Read';
                            
                        }else{
                            a.accountAccessLevel = 'Read';
                        }
                        
                    }
                    
                    if(!batch.hayError__c){
                        miembroDeEquipoDeCuentaAAgregar.add(a);    
                    }
                    
                }else{
                    //batch.hayError__c = true;
                    //batch.Descripcion_del_error__c = 'no existe una cuenta con cuit:'+batch.Cliente__c+' idClienteLegado:'+batch.idClienteLegado__c;
                    batch.addError('no existe una cuenta con cuit:'+batch.Cliente__c+' idClienteLegado:'+batch.idClienteLegado__c);
                }
            }
            
            if(batch.Accion__c == 'Baja'){
                if(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c) != null){
                    idsCuentasBaja.add(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c));
                    iduserAsignadoBaja.add(batch.Asignado__c);
                    mapaDeBajaDeEquipoDeCuenta.put(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c)+batch.Asignado__c, 'Eliminar');
                }else{
                    //batch.hayError__c = true;
                    //batch.Descripcion_del_error__c = 'no existe una cuenta con cuit:'+batch.Cliente__c+' idClienteLegado:'+batch.idClienteLegado__c;
                    batch.addError('no existe una cuenta con cuit:'+batch.Cliente__c+' idClienteLegado:'+batch.idClienteLegado__c);
                }
            }
            
            if(batch.Accion__c == 'Modificacion' || batch.Accion__c == 'Modificación'){
                if(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c) != null){
                    
                    //Hago la Modificacion.

                    idsCuentasModificacion.add(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c));
                    iduserAsignadoModificacion.add(batch.Descripcion_Rol__c.toUpperCase());
                    mapaDeBajaEnModificacion.put(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c)+batch.Descripcion_Rol__c.toUpperCase(), 'Eliminar');

                    
                    //y hago la alta
                    if(mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c) != null){
                        
                        batch.hayError__c = false;
                        AccountTeamMember a = new AccountTeamMember();
                        
                        a.accountId = mapaIdCuentas.get(batch.Cliente__c+batch.idClienteLegado__c);
                        a.teamMemberRole = batch.Descripcion_Rol__c;
                        a.userId = mapaIdUsuarios.get(batch.Asignado__c);
                        
                        if(a.teamMemberRole.equalsIgnoreCase('EJECUTIVO DE CUENTA')){
                            a.accountAccessLevel = 'Read';
                            a.contactAccessLevel = 'Edit';
                            a.OpportunityAccessLevel = 'Edit';
                            
                            OportunidadAUpdatear oppUp = new oportunidadAUpdatear(a.accountId, a.userId);
                            listaDeOportuniadadesAUpdatear.add(oppUp);
                            
                        }else{
                            
                            if(a.teamMemberRole.equalsIgnoreCase('INGENIERO DE CUENTA')){
                                a.accountAccessLevel = 'Read';
                                a.OpportunityAccessLevel = 'Read';
                                
                            }else{
                                a.accountAccessLevel = 'Read';
                            }
                            
                        }
                        
                        if(!batch.hayError__c){
                            miembroDeEquipoDeCuentaAAgregar.add(a);    
                        }
                        
                    }else{
                        batch.addError('no existe una cuenta con cuit:'+batch.Cliente__c+' idClienteLegado:'+batch.idClienteLegado__c);
                    }
                    

                }else{
                    batch.addError('no existe una cuenta con cuit:'+batch.Cliente__c+' idClienteLegado:'+batch.idClienteLegado__c);
                }
            }
            
            if(batch.Accion__c != 'Modificacion' && batch.Accion__c != 'Modificación' && batch.Accion__c != 'Baja' && batch.Accion__c != 'Alta'){
                //batch.hayError__c = true;
                //batch.Descripcion_del_error__c = batch.Accion__c+' no es una accion valida.';
                batch.addError(batch.Accion__c+' no es una accion valida.');
            }
            
        }
        
        //El orden de primero ejecutar la modificacion y luego la alta debe respetarce para el correcto funcionamiento
        
        //Modificacion
        if(idsCuentasModificacion.size()>0 && iduserAsignadoModificacion.size()>0){
            List<AccountTeamMember> miembroAModificar = [select id, teamMemberRole, accountId 
                                                         from AccountTeamMember where AccountId in: idsCuentasModificacion and teamMemberRole in: iduserAsignadoModificacion];
            
            List<AccountTeamMember> miembrosABajar = new List<AccountTeamMember>();
            for(AccountTeamMember miembro: miembroAModificar){
                if(mapaDeBajaEnModificacion.get(miembro.accountId+miembro.TeamMemberRole) == 'Eliminar'){
                    miembrosABajar.add(miembro);
                }
            }
            
            if(miembrosABajar.size()>0){
                delete miembrosABajar;    
            }
            
        }
        
        //Baja
        if(idsCuentasBaja.size()>0 && iduserAsignadoBaja.size()>0){
            List<AccountTeamMember> posibleListaAEliminar = [select id, accountId, user.FederationIdentifier from AccountTeamMember where AccountId in: idsCuentasBaja and user.FederationIdentifier in: iduserAsignadoBaja];
            List<AccountTeamMember> listaAEliminar = new List<AccountTeamMember>();
            for(AccountTeamMember aEliminar: posibleListaAEliminar){
                if(mapaDeBajaDeEquipoDeCuenta.get(aEliminar.accountId+aEliminar.user.FederationIdentifier) == 'Eliminar'){
                    listaAEliminar.add(aEliminar);
                }
            }
            
            if(listaAEliminar.size()>0){
                delete listaAEliminar;
            }
        }
        
        //Alta
        if(miembroDeEquipoDeCuentaAAgregar.size()>0){
            system.debug(miembroDeEquipoDeCuentaAAgregar);
            insert miembroDeEquipoDeCuentaAAgregar;
            if(listaDeOportuniadadesAUpdatear.size()>0){
                accountTeamTrigger.ejecutar(listaDeOportuniadadesAUpdatear);
            }
        }


        
    }

}