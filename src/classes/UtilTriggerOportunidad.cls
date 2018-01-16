global with sharing class UtilTriggerOportunidad {
    
    public static void soloSePuedeCrearUnaOppElEjecutivoDeCuenta(List<Opportunity> oppnew){
        
        List<String> usuariosDuenios = new List<String>();
        
        for(Opportunity opp : oppnew){
            usuariosDuenios.add(opp.OwnerId);
        }
        
        List<AccountTeamMember> integrantesDeEquiposDeCuenta = [select id, accountId, userId 
                                                                from AccountTeamMember 
                                                                where userId in: usuariosDuenios and teamMemberRole = 'EJECUTIVO DE CUENTA'];
        
        Map<String, AccountTeamMember> mapaDeIntegrantes = new Map<String, AccountTeamMember>();
        for(AccountTeamMember integrante: integrantesDeEquiposDeCuenta){
            mapaDeIntegrantes.put(''+integrante.userId+integrante.accountId, integrante);
        }
        
        for(Opportunity opp : oppnew){
            if(mapaDeIntegrantes.get(''+opp.OwnerId+opp.AccountId) == null && opp.AccountId != null){
                opp.addError('Solo el "Ejecutivo de cuenta" de la cuenta asignada a la oportunidad, puede crear o editar la misma.');
            }
        } 
    }
    
    public static void soloSePuedeCrearUnContactoElEjecutivoDeCuenta(List<Contact> contactNew){
        
        List<String> usuariosDuenios = new List<String>();
        
        for(Contact cnt : contactNew){
            usuariosDuenios.add(cnt.OwnerId);
        }
        
        List<AccountTeamMember> integrantesDeEquiposDeCuenta = [select id, accountId, userId 
                                                                from AccountTeamMember 
                                                                where userId in: usuariosDuenios and teamMemberRole = 'EJECUTIVO DE CUENTA'];
        
        Map<String, AccountTeamMember> mapaDeIntegrantes = new Map<String, AccountTeamMember>();
        for(AccountTeamMember integrante: integrantesDeEquiposDeCuenta){
            mapaDeIntegrantes.put(''+integrante.userId+integrante.accountId, integrante);
        }
        
        for(Contact cnt : contactNew){
            if(mapaDeIntegrantes.get(''+cnt.OwnerId+cnt.AccountId) == null && cnt.AccountId != null){
                cnt.addError('Solo el "Ejecutivo de cuenta" de la cuenta asignada al contacto, puede crear o editar el mismo.');
            }
        } 
    }
}