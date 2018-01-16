global class UtilTriggers {

    global static void ContractTrigger(List<Contract> contractList) {
        for (Contract c :contractList) {
            if ((c.isCompetitorContract__c && c.competitorName__c == null)||(!c.isCompetitorContract__c && c.competitorName__c != null)) {
                c.addError(Label.ContractError);
            }       
        }
    }
    
    global static void deleteContactInfluences(List<Contact> contactList) {
        List<Id> contactIDs = new List<Id>();
    
        for (Contact c :contactList){      
            contactIDs.add(c.id);
        }
        
        
        Contact_Influence__c aBorrar = new Contact_Influence__c();
        if(Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible() && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible() &&
           Schema.sObjectType.Contact_Influence__c.isAccessible() ){
           aBorrar = [SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c WHERE Contact_Influences__c in :contactIDs or Contact_Influenced__c in :contactIDs];
        }
        
        if(Contact_Influence__c.sObjectType.getDescribe().isDeletable()){
            delete aBorrar;
        }
        
        Contact_Assessment__c aBorrar2 = new Contact_Assessment__c();
        if(Schema.sObjectType.Contact_Assessment__c.isAccessible()){
            aBorrar2 = [SELECT Id from Contact_Assessment__c where Contact__c in :contactIDs];
        }
        if(Contact_Assessment__c.sObjectType.getDescribe().isDeletable()){
            delete aBorrar2;
        }
        
    }
    
    global static void opportunitySetCurrentYearCharges(List<Opportunity> oportunityList) {
        //Full Contract Value
        Boolean isUpdateable = Opportunity.Full_Contract_Value__c.getDescribe().isUpdateable();
    
        Date fiscalYearEndDate = FiscalPeriodUtils.getFiscalYearEndDate(); 
    
        for (Opportunity opp :oportunityList) {
            if (opp.Estimated_Billing_Start_Date__c != null && opp.Estimated_Billing_Start_Date__c < fiscalYearEndDate) {
                Double totalChargesForCurrentFiscalYear = 0;
                if (opp.Monthly_Charges__c != null) {
                    Date billingStartDate = opp.Estimated_Billing_Start_Date__c;
                    Integer days = billingStartDate.daysBetween(fiscalYearEndDate);
                    opp.Estimated_Year_End_Revenue__c = (days*opp.Monthly_Charges__c)/30; // use 30 day months
                } else {
                    System.debug('Monthly Charges is null');
                }
                if (opp.Unique_Charges__c != null) {
                    opp.Estimated_Year_End_Revenue__c += opp.Unique_Charges__c;
                } else {
                    System.debug('Unique Charges is null');
                }
            } else {
                System.debug('Estimated billing start date is null or after year end. Estimated Billing Start Date: ' + opp.Estimated_Billing_Start_Date__c + ', Year end: ' + fiscalYearEndDate);
            }
            //Full Contract Value
            //Si el perfil del usuario no es Admin o Admin LATAM, entonces calculo el Valor Total del Contrato como: Cargo Mensual Total * Duraci�n del contrato (meses) + Cargos por �nica vez
            if (!isUpdateable) {  
              if (opp.Monthly_Charges__c != null && opp.contract_duration_months__c != null && opp.Unique_Charges__c != null) {    
                opp.Full_Contract_Value__c = opp.Monthly_Charges__c * opp.contract_duration_months__c + opp.Unique_Charges__c;
              }      
            }
        }
    }
    
    global static void setStrategicContextLastUpdate(List<Account> accountList, Map<Id,Account> accountOldMap, Boolean isInsert) {
        for (Account client :accountList) {
            if (isInsert || (client.Strategic_Context__c != accountOldMap.get(client.Id).Strategic_Context__c && (client.Strategic_Context_Last_Update__c != null || client.Strategic_Context__c != Null))) {
                client.Strategic_Context_Last_Update__c = System.now();
            }    
        }
    }
    
    global static void rellenaDescripcionEvent(List<Event> eventList) {
        
        for(Event e:eventList){
            if(e.Description!=null) {
                if(e.Description.length()>255) {
                    e.Description__c = e.Description.substring(0,255);
                } else {
                    e.Description__c = e.Description;
                }
            }
        }
    }
    
    global static void rellenaDescripcionTask(List<Task> taskList) {
        
        for(Task t:taskList){
            if(t.Description!=null) {
                if(t.Description.length()>255) {
                    t.Description__c = t.Description.substring(0,255);
                } else {
                    t.Description__c = t.Description;
                }
            }
        }
    }
}