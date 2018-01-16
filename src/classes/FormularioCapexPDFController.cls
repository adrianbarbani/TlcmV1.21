public with sharing class FormularioCapexPDFController {
    
    public Solicitud_Capex__c solicitud{get; set;}
    public String fechaLicitacion {get; set;}
    
    public FormularioCapexPDFController(){
        Id idSol = ApexPages.currentPage().getParameters().get('id');
        
        
        if(Schema.sObjectType.Solicitud_Capex__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Operator_or_country__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.applicant_name__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Applicant_Position__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Application_Date__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Proyect_Name__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Salesforce_code__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Proyect_description__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Client_Name__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Fecha_de_Licitacion__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.FCV__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.NAV__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Total_Capex__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Requested_Capex__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Multiyear_Disposition__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Capex_Import_for_this_year__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Solicitation_Concept__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Capex_Investor_current_year__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Capex_Investor_commited__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Attach_Business_case__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Reviewed_by_management_control__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.approved_by_management_control__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Description_Not_Approved__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.Aditional_information__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.OIBDA__c.isAccessible()
        && Schema.sObjectType.Solicitud_Capex__c.fields.TIR__C.isAccessible())

        solicitud = [select ID, Operator_or_country__c, applicant_name__c, Applicant_Position__c, Application_Date__c, 
                     Proyect_Name__c, Salesforce_code__c, Proyect_description__c, Client_Name__c, Fecha_de_Licitacion__c,
                     FCV__c, NAV__c, Total_Capex__c, Requested_Capex__c, Multiyear_Disposition__c, Capex_Import_for_this_year__c,
                     Solicitation_Concept__c, Capex_Investor_current_year__c, Capex_Investor_commited__c, Attach_Business_case__c,
                     Reviewed_by_management_control__c, approved_by_management_control__c, Description_Not_Approved__c, Aditional_information__c, OIBDA__c, TIR__C 
                     from Solicitud_Capex__c where id =: idSol ];
        
        fechaLicitacion = '';
        if(solicitud.Fecha_de_Licitacion__c != null){
           fechaLicitacion =  solicitud.Fecha_de_Licitacion__c.day() + '/' + solicitud.Fecha_de_Licitacion__c.month() + '/' + solicitud.Fecha_de_Licitacion__c.year();
        }
    }
}