trigger AccountTrigger on Account (before insert) {
    
    if(trigger.isBefore && trigger.isInsert){
        
        system.debug('trigger cuentas');
        
        List<Double> cuitCuentas = new List<Double>();
        for(Account acc : Trigger.new){
            cuitCuentas.add(acc.cuit__c);
        }
        system.debug(cuitCuentas);
        
        List<Account> nuevasCuentas = [select id, cuit__c from account where cuit__c in: cuitCuentas];
        
        system.debug(nuevasCuentas);
        
        for(Account accNuevas: nuevasCuentas){
            for(Account acc : Trigger.new){
                if(accNuevas.cuit__c == acc.cuit__c && acc.ParentId == null){
                    acc.addError('No puede haber mas de una cuenta cabecera con el mismo cuit, o una cuenta de gestion sin una cuenta padre asignada.');
                }
            }
        }
        
    }

}