@isTest
public class OpportunityTriggerTest {
    
    static testMethod void seGeneraUnaOportunidadYSeLeCargaLaUltimaCotizacion() {
        
        CotizacionDollarBudget__c unaCotizacion = new CotizacionDollarBudget__c();
        unaCotizacion.Cotizacion__c = 12;
        insert unaCotizacion;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'oportunidad'; 
        opp.StageName = 'etapa'; 
        opp.CloseDate = Date.today();
        insert opp;
        
        Opp = [select id, Dolar_Buget__c from opportunity];
        
        system.assertEquals(12, opp.Dolar_Buget__c);

    }
}