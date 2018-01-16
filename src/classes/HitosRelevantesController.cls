public with sharing class HitosRelevantesController {
    
    public String idCuenta {get; set;}
    public Contenedor_de_hito2__c contenedor {get; set;}
    
    public String hitoABorrarId {get;set;}
    public Hito_Relevante_2__c hitoAInsertar {get; set;}
    
    public HitosRelevantesController(){
        
        idCuenta = ApexPages.currentPage().getParameters().get('Id');
        
        
        hitoAInsertar = new Hito_Relevante_2__c();
        
        
        obtenerContenedores();  
        //insertarContenedor();
    }
    
    public void obtenerContenedores(){
        List<Contenedor_de_hito2__c> contenedores = new List<Contenedor_de_hito2__c>();
        
        contenedores = [select id, Fecha_vencimiento_otros_servicios__c, vencimiento_datos_fijos__c, vencimiento_servicios_moviles__c,
                        (select id, Categoria__c, Descripcion__c, Fecha__c from Hitos_Relevantes_2__r)
                        from Contenedor_de_hito2__c
                        where cuenta__c =: idCuenta
                        Limit 1];
        if(contenedores.size()>0){
            contenedor = contenedores[0];
        }
    }
    
    public void insertarContenedor(){
        if(contenedor == null){
            contenedor = new Contenedor_de_hito2__c();
            
            
            contenedor.Cuenta__c = idCuenta;
            
            
            
            insert contenedor;
            
            
        }
    }
    
    public void guardar(){
        
        update contenedor;
    }
    
    public PageReference BorrarHito(){
        
        Integer i = 0;
        
        for(Hito_Relevante_2__c hito : contenedor.Hitos_Relevantes_2__r){
            
            if(hito.id == hitoABorrarId){
                break;
            }
            else{
                i++;
            }   
        }
        
        
        if(contenedor.Hitos_Relevantes_2__r[i].id != null){
            
            List<task> aBorrar = new List <task>();
            if(Schema.sObjectType.task.isAccessible())
                aBorrar = [SELECT ID FROM task WHERE Hito_Relevante_2__c =: contenedor.Hitos_Relevantes_2__r[i].id];
            
            if(Task.sObjectType.getDescribe().isDeletable()){
                delete aBorrar;
            }
            
            if(Hito_relevante__c.sObjectType.getDescribe().isDeletable()){
                delete contenedor.Hitos_Relevantes_2__r[i];
            }
            
        }
        
        
        obtenerContenedores();
        return null;    	
        
    }
    
    public void insertHito(){
        
        insertarContenedor();
        
        
        hitoAInsertar.Contenedor_de_hito__c = contenedor.id;
        
        
        if(Hito_relevante__c.sObjectType.getDescribe().isCreateable()){ 
            
            insert hitoAInsertar;       
        }
        
        
        Task tareaDelHito = new Task();
        
        if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
            tareaDelHito.ActivityDate = hitoAInsertar.Fecha__c;
        }
        if(Schema.sObjectType.Task.fields.Subject.isCreateable()){
            tareaDelHito.Subject = hitoAInsertar.Categoria__c;
        }
        if(Schema.sObjectType.Task.fields.Description.isCreateable()){
            tareaDelHito.Description = hitoAInsertar.Descripcion__c;
        }
        if(Schema.sObjectType.Task.fields.WhatId.isCreateable()){
            tareaDelHito.WhatId = idCuenta;
        }
        
        tareaDelHito.Hito_Relevante_2__c = hitoAInsertar.id;

        
        if(Task.sObjectType.getDescribe().isCreateable()){ 
            
            insert tareaDelHito;      
        }
        
        
        
        hitoAInsertar = new Hito_Relevante_2__c();
        
        obtenerContenedores();
    }
    
}