global class DollarBudgetUpdateBatch implements Database.Batchable<sObject>{
   
    global final String Query;
	global final CotizacionDollarBudget__c DollarBudget;
    
    global DollarBudgetUpdateBatch(String q, CotizacionDollarBudget__c db){
        Query=q;
        DollarBudget=db;
    }

    
    global Database.QueryLocator start(Database.BatchableContext bc) {
         return Database.getQueryLocator(Query);
    }

    
    global void execute(Database.BatchableContext BC, list<Opportunity> oportunidades){
        for(Opportunity op : oportunidades){
            op.Dolar_Buget__c = DollarBudget.Cotizacion__c;
        }
        update oportunidades;
    }

    global void finish(Database.BatchableContext BC){
        
    }

    
}