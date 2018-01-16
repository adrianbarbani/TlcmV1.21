trigger ProductoTrigger on Product2 (before Delete) {
	
    if(trigger.isBefore && trigger.isDelete){
        
        String idPerfil = userinfo.getProfileId();
        Profile perfilDelUsuario = [select id, Name from profile where id = : idPerfil];
        system.debug(perfilDelUsuario.name);
        for(Product2 prd : trigger.old){
            
            if(perfilDelUsuario.name != 'Administrador del sistema'){
                   if(prd.productogeneradoporDelta__c){
                       prd.addError('No se pueden eliminar productos que vienen de la integracion de delta.');
                   }
               }

        }
        
    }
}