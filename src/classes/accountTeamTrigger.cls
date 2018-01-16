global with sharing class accountTeamTrigger {
    
    public static void ejecutar(List<OportunidadAUpdatear> opps){
        
        List<String> idsCuentas = new List<String>();
        Map<String, String> obtenerDuenio = new Map<String,String>();
        for(OportunidadAUpdatear opp: opps){
            obtenerDuenio.put(opp.idCuenta,opp.idUsuario);
            idsCuentas.add(opp.idCuenta);
        }
        
        List<Opportunity> oportunidades = [select id, ownerId, AccountId from Opportunity where accountId in: idsCuentas and isClosed = false];
        List<Contact> contactos = [select id, ownerId, AccountId from Contact where accountId in: idsCuentas];
        
        for(Opportunity oportunidad: oportunidades){
            oportunidad.OwnerId = obtenerDuenio.get(oportunidad.AccountId);
        }
        
        for(contact contacto: contactos){
            contacto.OwnerId = obtenerDuenio.get(contacto.AccountId);
        }
        
        update contactos;
        update oportunidades;
    }
    


}