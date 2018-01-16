@isTest
public class accountTriggerTest {

    static testMethod void noSeCreaUnaCuentaSiYaExisteUnaConElMismoId() {
        
        Account cuenta = new Account();
        cuenta.name = 'nueva';
        cuenta.cuit__c = 12345678910.0;
        insert cuenta;
        
        try{
            Account cuenta2 = new Account();
            cuenta2.name = 'asd';
            cuenta2.cuit__c = 12345678910.0;
            insert cuenta2;
        }catch(Exception e){
            
        }
        
        List<Account> cuentas = [select id from account];
        
        system.assertEquals(1, cuentas.size());
    }
}