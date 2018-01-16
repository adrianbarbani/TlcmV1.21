@isTest
public class UpdatePorfolioTest {
    
    static testMethod void altaDeUnMiembroDelEquipoDeCuenta() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963873.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Alta';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'ejecutivo';
        batch.Asignado__c = 'u123';
        
        insert batch;
        
        List<AccountTeamMember> miembrosNuevos = [select id, account.cuit__c, account.idClienteLegado__c, user.FederationIdentifier, teamMemberRole from AccountTeamMember];
        system.assertEquals(1, miembrosNuevos.size());
        system.assertEquals(20379963873.00,miembrosNuevos[0].account.cuit__c);
        system.assertEquals('8888888888',miembrosNuevos[0].account.idClienteLegado__c);
        system.assertEquals('u123',miembrosNuevos[0].user.FederationIdentifier);
        system.assertEquals('ejecutivo',miembrosNuevos[0].teamMemberRole);
    }
    
    static testMethod void bajaDeUnMiembroDelEquipoDeCuenta() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963873.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Account cuenta2 = new Account();
        cuenta2.name = 'cuenta';
        cuenta2.CUIT__c = 20379963875.00;
        cuenta2.idClienteLegado__c = '8888888888';
        insert cuenta2;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        User usuario2 = new User();
        usuario2.Username = 'ricardo@agustin.com';
        usuario2.LastName = 'lastname'; 
        usuario2.Email = 'ricardo@a.com'; 
        usuario2.Alias = 'rick';
        usuario2.CommunityNickname = 'rick';
        usuario2.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario2.emailencodingkey='UTF-8';
        usuario2.languagelocalekey='en_US';
        usuario2.localesidkey='en_US';
        usuario2.ProfileId = perfil.id;
        usuario2.FederationIdentifier = 'u001';
        insert usuario2;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Alta';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'ejecutivo';
        batch.Asignado__c = 'u123';
        
        insert batch;
        
        batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Alta';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'gerente';
        batch.Asignado__c = 'u001';
        
        insert batch;
        
        batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Alta';
        batch.Cliente__c = '20379963875';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'gerente';
        batch.Asignado__c = 'u001';
        
        insert batch;
        
        List<AccountTeamMember> miembrosNuevos = [select id, account.cuit__c, account.idClienteLegado__c, user.FederationIdentifier, teamMemberRole from AccountTeamMember];
        system.assertEquals(3, miembrosNuevos.size());
        
        List<Update_Portfolio_batch__c> bajas = new List<Update_Portfolio_batch__c>();
        Update_Portfolio_batch__c batchBaja = new Update_Portfolio_batch__c();
        batchBaja.Accion__c = 'Baja';
        batchBaja.Cliente__c = '20379963873';
        batchBaja.idClienteLegado__c = '8888888888';
        batchBaja.Asignado__c = 'u123';
        
        Update_Portfolio_batch__c batchBaja2 = new Update_Portfolio_batch__c();
        batchBaja2.Accion__c = 'Baja';
        batchBaja2.Cliente__c = '20379963875';
        batchBaja2.idClienteLegado__c = '8888888888';
        batchBaja2.Asignado__c = 'u001';
        
        bajas.add(batchBaja);
        bajas.add(batchBaja2);
        
        insert bajas;
        
        miembrosNuevos = [select id, account.cuit__c, account.idClienteLegado__c, user.FederationIdentifier, teamMemberRole from AccountTeamMember];
        system.assertEquals(1, miembrosNuevos.size());
        
    }
    
    static testMethod void modificacionDeUnMiembroDelEquipoDeCuenta() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963873.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        User usuario2 = new User();
        usuario2.Username = 'unusuario109090@a.com';
        usuario2.LastName = 'a'; 
        usuario2.Email = 'unusuario10909@a.com'; 
        usuario2.Alias = 'usr100';
        usuario2.CommunityNickname = 'usr101';
        usuario2.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario2.emailencodingkey='UTF-8';
        usuario2.languagelocalekey='en_US';
        usuario2.localesidkey='en_US';
        usuario2.ProfileId = perfil.id;
        usuario2.FederationIdentifier = 'u111';
        insert usuario2;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Alta';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'super ejecutivo';
        batch.Asignado__c = 'u123';
        
        insert batch;
        
        List<AccountTeamMember> miembrosNuevos = [select id, account.cuit__c, account.idClienteLegado__c, user.FederationIdentifier, teamMemberRole from AccountTeamMember];
        system.assertEquals(1, miembrosNuevos.size());
        
        Update_Portfolio_batch__c batchModificacion = new Update_Portfolio_batch__c();
        batchModificacion.Accion__c = 'Modificacion';
        batchModificacion.Cliente__c = '20379963873';
        batchModificacion.idClienteLegado__c = '8888888888';
        batchModificacion.Descripcion_Rol__c = 'EJECUTIVO DE CUENTA';
        batchModificacion.Asignado__c = 'u123';
        
        insert batchModificacion;
        
        //Pruebo si se cambia el usuario de Rol.
        miembrosNuevos = [select id, account.cuit__c, account.idClienteLegado__c, user.FederationIdentifier, teamMemberRole from AccountTeamMember];
        system.assertEquals(1, miembrosNuevos.size());
        system.assertEquals(20379963873.00,miembrosNuevos[0].account.cuit__c);
        system.assertEquals('8888888888',miembrosNuevos[0].account.idClienteLegado__c);
        system.assertEquals('u123',miembrosNuevos[0].user.FederationIdentifier);
        system.assertEquals('EJECUTIVO DE CUENTA',miembrosNuevos[0].teamMemberRole);
        
        
        batchModificacion = new Update_Portfolio_batch__c();
        batchModificacion.Accion__c = 'Modificacion';
        batchModificacion.Cliente__c = '20379963873';
        batchModificacion.idClienteLegado__c = '8888888888';
        batchModificacion.Descripcion_Rol__c = 'EJECUTIVO DE CUENTA';
        batchModificacion.Asignado__c = 'u111';
        
        insert batchModificacion;
        
        //Pruebo si se cambia que usuario ocupa ese Rol.
        miembrosNuevos = [select id, account.cuit__c, account.idClienteLegado__c, user.FederationIdentifier, teamMemberRole from AccountTeamMember];
        system.assertEquals(1, miembrosNuevos.size());
        system.assertEquals(20379963873.00,miembrosNuevos[0].account.cuit__c);
        system.assertEquals('8888888888',miembrosNuevos[0].account.idClienteLegado__c);
        system.assertEquals('u111',miembrosNuevos[0].user.FederationIdentifier);
        system.assertEquals('EJECUTIVO DE CUENTA',miembrosNuevos[0].teamMemberRole);
        
        
    }
    
    static testMethod void insertoUnBatchConUnaAccionIncorrecta() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963873.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'asdasdasd';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'ejecutivo';
        batch.Asignado__c = 'u123';
        
        try{
            insert batch;
        }catch(Exception e){
            
        }

        
    }
    
    static testMethod void insertoUnBatchParaUnaCuentaInexistenteAlta() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963803.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Alta';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'ejecutivo';
        batch.Asignado__c = 'u123';
        
        try{
            insert batch;
        }catch(Exception e){
            
        }
        
        
    }
    
    static testMethod void insertoUnBatchParaUnaCuentaInexistenteBaja() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963803.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Baja';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'ejecutivo';
        batch.Asignado__c = 'u123';
        
        try{
            insert batch;
        }catch(Exception e){}
        
        
    }
    
    static testMethod void insertoUnBatchParaUnaCuentaInexistenteModificacion() {
        
        Account cuenta = new Account();
        cuenta.name = 'cuenta';
        cuenta.CUIT__c = 20379963803.00;
        cuenta.idClienteLegado__c = '8888888888';
        insert cuenta;
        
        Profile perfil = [SELECT Id FROM Profile LIMIT 1]; 
        
        User usuario = new User();
        usuario.Username = 'agustin@agustin.com';
        usuario.LastName = 'lastname'; 
        usuario.Email = 'a@a.com'; 
        usuario.Alias = 'asd';
        usuario.CommunityNickname = 'ads';
        usuario.TimeZoneSidKey = 'Pacific/Kiritimati'; 
        usuario.emailencodingkey='UTF-8';
        usuario.languagelocalekey='en_US';
        usuario.localesidkey='en_US';
        usuario.ProfileId = perfil.id;
        usuario.FederationIdentifier = 'u123';
        insert usuario;
        
        Update_Portfolio_batch__c batch = new Update_Portfolio_batch__c();
        batch.Accion__c = 'Modificacion';
        batch.Cliente__c = '20379963873';
        batch.idClienteLegado__c = '8888888888';
        batch.Descripcion_Rol__c = 'ejecutivo';
        batch.Asignado__c = 'u123';
        
        try{
            insert batch;
        }catch(Exception e){}
        
        
    }
}