trigger ContactTrigger on Contact (before insert, before update) {
    
    if(trigger.isBefore && trigger.isInsert){
        
        //solo puede crear una opp el ejecutivo de cuenta de la cuenta.
        if(!Test.isRunningTest()){
            String idPerfil = userinfo.getProfileId();
            Profile perfilDelUsuario = [select id, Name from profile where id = : idPerfil];
            
            if( perfilDelUsuario.name != 'Operaciones' && perfilDelUsuario.name != 'Integracion DataLoader' && 
                perfilDelUsuario.name != 'Administrador del sistema' && perfilDelUsuario.name !='SCP - Global'){
                utilTriggerOportunidad.soloSePuedeCrearUnContactoElEjecutivoDeCuenta(trigger.new);
            }
            
        }
        
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        
        if(!Test.isRunningTest()){
            
            String idPerfil = userinfo.getProfileId();
            Profile perfilDelUsuario = [select id, Name from profile where id = : idPerfil];
            
            if( perfilDelUsuario.name != 'Operaciones' && perfilDelUsuario.name != 'Integracion DataLoader' && 
                perfilDelUsuario.name != 'Administrador del sistema' && perfilDelUsuario.name !='SCP - Global'){
                utilTriggerOportunidad.soloSePuedeCrearUnContactoElEjecutivoDeCuenta(trigger.new);
            }
            
        }
        
    }
    
    
}