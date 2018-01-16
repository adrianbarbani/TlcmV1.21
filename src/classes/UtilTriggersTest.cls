@isTest
public class UtilTriggersTest {
	
    static testMethod void test (){
        
        Account cuenta = new Account();
        cuenta.name = 'CuentaPrueba';
        insert cuenta;
        
        Contract contrato = new Contract();
        contrato.competitorName__c = 'nombre';
        contrato.AccountId = cuenta.id;
        insert contrato;
        
        Contact contacto = new Contact();
        contacto.LastName = 'nombre';
        insert contacto;
        
        Contact_Influence__c influencia = new Contact_Influence__c();
        influencia.Contact_Influenced__c = contacto.id;
        influencia.Contact_Influences__c = contacto.id;
        insert influencia;
        
        Contact_Assessment__c ca = new Contact_Assessment__c();
        ca.Contact__c = contacto.id;
        insert ca;
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.Estimated_Billing_Start_Date__c = Date.today();
        oportunidad.Monthly_Charges__c = 222;
        oportunidad.Unique_Charges__c = 800;
        oportunidad.Name = 'dasdas';
        oportunidad.StageName = 'Qualification';
        oportunidad.CloseDate = Date.today();
        insert oportunidad;
        
        Event evento = new Event();
        evento.Description = 'dkahsdkjashdjksadhjsa';
        evento.DurationInMinutes = 12;
        evento.ActivityDateTime = Date.today();
		insert evento;
        
        Task tarea = new Task();
        tarea.Description = 'dhaksjdhajs';
        insert tarea;
            
        List<Contract> contractList = new List<Contract>();
        contractList.add(contrato);
        UtilTriggers.ContractTrigger(contractList);
        
        List<Contact> contactList = new List<Contact>();
        contactList.add(contacto);
        UtilTriggers.deleteContactInfluences(contactList);
        
        List<Opportunity> oportunityList = new List<Opportunity>();
        oportunityList.add(oportunidad);
        
        UtilTriggers.opportunitySetCurrentYearCharges(oportunityList);
        
        List<Event> lista = new List<Event>();
        lista.add(evento);
        
        UtilTriggers.rellenaDescripcionEvent(lista);
        
        List<Task> lista2 = new List<Task>();
        lista2.add(tarea);
        
        UtilTriggers.rellenaDescripcionTask(lista2);
        
        List<Account> listaCuentas = new List<Account>();
        listaCuentas.add(cuenta);
        
        Map<Id,Account> mapa = new map<Id, Account>();
        
        UtilTriggers.setStrategicContextLastUpdate(listaCuentas, mapa, true);
        
        List<Opportunity> oportunidades = [select id from opportunity];
        
        system.assertEquals(1, oportunidades.size());
    }
}