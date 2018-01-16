public class CargarDollarBudgetController {
    
    public CotizacionDollarBudget__c DollarBudgetNuevo{get;set;}
    public List<CotizacionDollarBudget__c> listaDollarBudget {get;set;} 
    
    public CargarDollarBudgetController(){
        conseguirCotizaciones();
    }
    
    public void conseguirCotizaciones(){
        
        DollarBudgetNuevo = new CotizacionDollarBudget__c();

        listaDollarBudget = new List<CotizacionDollarBudget__c>();
        listaDollarBudget = [SELECT id, Name, Cotizacion__c, createdBy.name, createdDate FROM CotizacionDollarBudget__c ORDER BY createdDate DESC LIMIT 900];

    }
    
    public void saveDollarBudget(){
        
        if(Schema.sObjectType.CotizacionDollarBudget__c.isCreateable()){
            
            String q = 'SELECT id, Dolar_Buget__c FROM Opportunity WHERE isClosed=false';
            
            insert DollarBudgetNuevo;
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Se ha cargado una nueva cotización.');
            ApexPages.addMessage(myMsg);
            
            Id batchInstanceId = Database.executeBatch(new DollarBudgetUpdateBatch(q, DollarBudgetNuevo));
            conseguirCotizaciones();
            
        }
    }
    
}