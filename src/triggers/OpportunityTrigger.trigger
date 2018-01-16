trigger OpportunityTrigger on Opportunity (before insert, before update) {
    
    if(trigger.isBefore && trigger.isInsert){
        
        //solo puede crear una opp el ejecutivo de cuenta de la cuenta.
        if(!Test.isRunningTest()){
            String idPerfil = userinfo.getProfileId();
            Profile perfilDelUsuario = [select id, Name from profile where id = : idPerfil];
            
            if(perfilDelUsuario.name != 'Operaciones' && perfilDelUsuario.name != 'Integracion DataLoader' && 
               perfilDelUsuario.name != 'Administrador del sistema' && perfilDelUsuario.name !='SCP - Global'){
                utilTriggerOportunidad.soloSePuedeCrearUnaOppElEjecutivoDeCuenta(trigger.new);
            }
        }
        
        //cotizacion dolar budget.
        CotizacionDollarBudget__c ultimaCotizacion = new CotizacionDollarBudget__c();
        
        List<CotizacionDollarBudget__c> cotizaciones = [select id, Cotizacion__c from CotizacionDollarBudget__c Order by createdDate DESC limit 1];
        system.debug([select id, Cotizacion__c, createdDate from CotizacionDollarBudget__c Order by createdDate DESC]);
        if(cotizaciones.size()>0){
            ultimaCotizacion = cotizaciones[0];
        }
        
        if(cotizaciones.size()>0){
            for(Opportunity opp : Trigger.new){
                if(ultimaCotizacion.Cotizacion__c != null){
                    opp.Dolar_Buget__c = ultimaCotizacion.Cotizacion__c;
                }
                
            }
        }
        
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        
        if(!Test.isRunningTest()){
            String idPerfil = userinfo.getProfileId();
            Profile perfilDelUsuario = [select id, Name from profile where id = : idPerfil];
            
            if( perfilDelUsuario.name != 'Operaciones' && perfilDelUsuario.name != 'Integracion DataLoader' && 
                perfilDelUsuario.name != 'Administrador del sistema' && perfilDelUsuario.name !='SCP - Global' && perfilDelUsuario.name !='SCP - Analista Planeamiento'){
                utilTriggerOportunidad.soloSePuedeCrearUnaOppElEjecutivoDeCuenta(trigger.new);
            }
        }
        
    }
    
}