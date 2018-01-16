public with sharing class AdministrarServiciosController {
    
    public List<Categoria_Servicio__c> categoriasDeServicios {get; set;}
    
    public Categoria_Servicio__c categoriaServicioAInsertar {get; set;}
    
    public Id categoriaABorrarId {get; set;}
    
    public Id servicioABorrarId {get; set;}
    
    public Id categoriaPadreDelServicioAInsertar {get; set;}
    
    public Servicio__c servicioAInsertar {get;set;}
    
    public AdministrarServiciosController(){
        
        categoriasDeServicios = new List<Categoria_Servicio__c>();
        
        obtenerCategoriasDeServicios();
        
    }
    
    public void obtenerCategoriasDeServicios (){
        
        categoriaServicioAInsertar = new Categoria_Servicio__c();
        
        servicioAInsertar = new Servicio__c();
        
        if(Schema.sObjectType.Categoria_Servicio__c.isAccessible() && Schema.sObjectType.Categoria_Servicio__c.fields.Name.isAccessible() ){
        categoriasDeServicios = [select id, name,
                                 (select id, name from Servicios__r)
                                 from Categoria_Servicio__c
                                 ORDER BY createdDate DESC LIMIT 900];
        }
        
        
    }
    
    public void InsertarCategoriaDeServicio(){
        
        if(Schema.sObjectType.Categoria_Servicio__c.isCreateable()){
            insert categoriaServicioAInsertar;
        }
        
        obtenerCategoriasDeServicios();
    }
    
    public void InsertarServicio(){
        
        if (Schema.sObjectType.Servicio__c.fields.Categoria_Servicio__c.isCreateable()){
            servicioAInsertar.Categoria_Servicio__c = categoriaPadreDelServicioAInsertar;}
        
        if (Schema.sObjectType.Servicio__c.isCreateable()){
            insert servicioAInsertar;
        }
            
        obtenerCategoriasDeServicios();
    }
    
    public PageReference borrarCategoriaDeServicio(){
        
        Integer i = 0;
        
        for(Categoria_Servicio__c categoriaServicio : categoriasDeServicios){
            
            if(categoriaServicio.id == categoriaABorrarId){
                break;
            }
            else{
                i++;
            }   
        }
        
        if(categoriasDeServicios[i].id != null){
            if(Categoria_Servicio__c.sObjectType.getDescribe().isDeletable()){
                delete categoriasDeServicios[i];
            }    
        }
        
        
        categoriasDeServicios.remove(i);        
        obtenerCategoriasDeServicios();
        return null;
    }
    
    public PageReference borrarServicio(){
        
        Servicio__c aBorrar = new Servicio__c();
           if(Schema.sObjectType.Servicio__c.isAccessible() && Schema.sObjectType.Servicio__c.fields.Name.isAccessible() ){
           aBorrar = [select id, name from Servicio__c
                           where id =: servicioABorrarId];
           }
           if(Servicio__c.sObjectType.getDescribe().isDeletable()){
               delete aBorrar;
           }
                       
           
        obtenerCategoriasDeServicios();
        return null;
        
    }
}