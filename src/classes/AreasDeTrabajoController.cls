public with sharing class AreasDeTrabajoController {
	
    public String idCuenta {get; set;}
    public List<WrapperArea> wrappersDeArea {get; set;}
    
    public String areaABorrarId {get; set;}
    
    public String solucionIdABorrar {get; set;}
    public String contactoIdABorrar {get; set;}
    public Id retoDeContactoABorrar {get; set;}
    
    
    public String idDelRetoDelContacto {get; set;}
    
    public Area_de_trabajo__c areaAInsertar {get; set;}
    public Retos_Contacto__c contactoAInsertar {get; set;}
    public Reto_tecnologia__c solucionAInsertar {get; set;}
    
    public List<Area_de_trabajo__c> areas {get; set;}
    public List<Reto__c> retos {get; set;}
    
    public AreasDeTrabajoController(){
        idCuenta = ApexPages.currentPage().getParameters().get('Id');
        
        areaAInsertar = new Area_de_trabajo__c();
        contactoAInsertar = new Retos_Contacto__c();
        solucionAInsertar = new Reto_tecnologia__c(); 
        
       	obtenerAreasYGenerarWpp();
        
    }

    public void obtenerAreasYGenerarWpp(){
        
        areas = new List<Area_de_trabajo__c>();
        retos = new List<Reto__c>();
        
        if(Schema.sObjectType.Area_de_trabajo__c.isAccessible() && Schema.sObjectType.Area_de_trabajo__c.fields.Conocimiento_del_Area__c.isAccessible()
        && Schema.sObjectType.Area_de_trabajo__c.fields.Tipo_de_Area__c.isAccessible()
        && Schema.sObjectType.Area_de_trabajo__c.fields.Titulo_Area__c.isAccessible()){
        areas = [select id, Conocimiento_del_Area__c, Tipo_de_Area__c, Titulo_Area__c
                 from Area_de_trabajo__c
                 where cuenta__c =: idCuenta];
        }
        
        Set<String> idAreas = new Set<String>();
        for(Area_de_trabajo__c area: areas){
            idAreas.add(area.id);
        }
        
        if(Schema.sObjectType.Reto__c.isAccessible() && Schema.sObjectType.Reto__c.fields.Competidor__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Etapa_del_Reto__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Fecha_Compromiso__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Nombre_del_Reto__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Nota__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Area_de_trabajo__c.isAccessible()){
        retos = [select id, Competidor__c, Etapa_del_Reto__c, Fecha_Compromiso__c, Nombre_del_Reto__c, Nota__c, Area_de_trabajo__c,
                 (select id, Contacto__c, Nivel_de_Relaci_n__c, Otro_contacto_del_cliente__c, Tipo_de_Contacto__c, Reto__c from Reto_Contactos__r),
                 (select id, Lista_de_Soluciones__c, Nivel_de_Desarrollo__c, Observaci_n_sobre_el_producto__c, Otra_Solucion__c, Reto__c from Reto_tecnologias__r)
                 from Reto__c
                 where Area_de_trabajo__c IN: idAreas];}
        
        Map<Area_de_trabajo__c, List<Reto__c>> areasConSusRetos = new Map<Area_de_trabajo__c, List<Reto__c>>();
        
        for(Area_de_trabajo__c area: areas){
            
            List<Reto__c> retosDelArea = new List<Reto__c>();
            for(Reto__c reto: retos){
                if(reto.Area_de_trabajo__c == area.id){
                    retosDelArea.add(reto);
                }
            }
            
            areasConSusRetos.put(area, retosDelArea); 
        }
        
        wrappersDeArea = new List<WrapperArea>();
        
        for(Area_de_trabajo__c area: areas){
            WrapperArea wppArea = new WrapperArea(area);
            wppArea.retos = areasConSusRetos.get(area);
            
            wrappersDeArea.add(wppArea);
        }
    }	
    
    public void guardar(){
        
        if(Schema.sObjectType.Area_de_trabajo__c.isUpdateable()){
            update areas;
        }
        
        if(Schema.sObjectType.Reto__c.isUpdateable()){
            update retos;
        }
    }
    
    public PageReference borrarArea(){
        
        Integer i = 0;
        
        for(WrapperArea wppArea : wrappersDeArea){
            
            if(wppArea.area.id == areaABorrarId){
                break;
            }
            else{
                i++;
            }   
        }
        
        if(wrappersDeArea[i].area.id != null){
            if(Area_de_trabajo__c.sObjectType.getDescribe().isDeletable()){
                delete wrappersDeArea[i].area;
            }    
        }
        
        
        wrappersDeArea.remove(i);        
        
        return null;
    }
    
    //Solucionar Borrar.
    public PageReference borrarContacto(){
        
        
        Reto__c retoDuenioDelContacto;
        for(Reto__c reto:retos){
            
            if(reto.id == retoDeContactoABorrar){
                retoDuenioDelContacto = reto; 
            }
            
        }
        
        if(retoDuenioDelContacto != null){
            
            Integer i = 0;
            
            for(Retos_Contacto__c contacto : retoDuenioDelContacto.Reto_Contactos__r){
                
                if(contacto.id == contactoIdABorrar){
                    break;
                }
                else{
                    i++;
                }   
            }
            
            if(retoDuenioDelContacto.Reto_Contactos__r[i].id != null){
                
                if(Retos_Contacto__c.sObjectType.getDescribe().isDeletable()){
                    delete retoDuenioDelContacto.Reto_Contactos__r[i];    
                }
            }
			
			
            obtenerAreasYGenerarWpp();
        }
        
        return null;
    }
    
    public PageReference borrarSolucion(){
        
        
        Reto__c retoDuenioDelContacto;
        for(Reto__c reto:retos){
            
            if(reto.id == retoDeContactoABorrar){
                retoDuenioDelContacto = reto; 
            }
            
        }
        
        if(retoDuenioDelContacto != null){
            
            Integer i = 0;
            
            for(Reto_tecnologia__c solucion : retoDuenioDelContacto.Reto_tecnologias__r){
                
                if(solucion.id == solucionIdABorrar){
                    break;
                }
                else{
                    i++;
                }   
            }
            
            if(retoDuenioDelContacto.Reto_tecnologias__r[i].id != null){
                
                if(Reto_tecnologia__c.sObjectType.getDescribe().isDeletable()){
                    delete retoDuenioDelContacto.Reto_tecnologias__r[i];
                }
            }
            
            
            obtenerAreasYGenerarWpp();       
            
            
        }
        return null;
    }
    
    public void insertarArea(){
        
        if(areaAInsertar.Titulo_Area__c != null){
             if (Schema.sObjectType.Area_de_trabajo__c.fields.Cuenta__c.isCreateable()){
                 areaAInsertar.Cuenta__c = idCuenta;}
            
            if (Schema.sObjectType.Area_de_trabajo__c.isCreateable()){
                insert areaAInsertar;
            }
            
            Reto__c reto1 = new Reto__c();
            
            if (Schema.sObjectType.Reto__c.fields.Area_de_trabajo__c.isCreateable()){
                reto1.Area_de_trabajo__c = areaAInsertar.id;}
            
            Reto__c reto2 = new Reto__c();
             
            if (Schema.sObjectType.Reto__c.fields.Area_de_trabajo__c.isCreateable()){
                 reto2.Area_de_trabajo__c = areaAInsertar.id;}
           
            Reto__c reto3 = new Reto__c();
             
            if (Schema.sObjectType.Reto__c.fields.Area_de_trabajo__c.isCreateable()){
                 reto3.Area_de_trabajo__c = areaAInsertar.id;}
            
            if (Schema.sObjectType.Reto__c.isCreateable()){
                insert reto1;
                insert reto2;
                insert reto3;
            }
        }
        
        areaAInsertar = new Area_de_trabajo__c();
        
        obtenerAreasYGenerarWpp();
    }
    
    public void insertarContacto(){
        
        if(!String.isBlank(idDelRetoDelContacto)){
            if (Schema.sObjectType.Retos_Contacto__c.fields.Reto__c.isCreateable()){
                contactoAInsertar.Reto__c = idDelRetoDelContacto;}
        }

        
        if(contactoAInsertar.Nivel_de_Relaci_n__c != null && contactoAInsertar.Tipo_de_Contacto__c != null && contactoAInsertar.Reto__c != null){
            system.debug(contactoAInsertar);
            
            if (Schema.sObjectType.Retos_Contacto__c.isCreateable()){
                insert contactoAInsertar;
            }
            
            contactoAInsertar = new Retos_Contacto__c();
            obtenerAreasYGenerarWpp();
        }
        
    }
    
    public void insertarSolucion(){

        if(!String.isBlank(idDelRetoDelContacto)){
            if (Schema.sObjectType.Reto_tecnologia__c.fields.Reto__c.isCreateable()){
                solucionAInsertar.Reto__c = idDelRetoDelContacto;}
        }
        
        
        if(solucionAInsertar.Nivel_de_Desarrollo__c != null && solucionAInsertar.Lista_de_Soluciones__c != null){
            
            if (Schema.sObjectType.Reto_tecnologia__c.isCreateable()){
                insert solucionAInsertar;
            }
            
            solucionAInsertar = new Reto_tecnologia__c();
            obtenerAreasYGenerarWpp();
        }
        
    }
    //======================================================================
    public class WrapperArea{
        
        public Area_de_trabajo__c area {get; set;}
        public List<Reto__c> retos {get; set;}
       // public List<WrapperReto> wppRetos {get; set;}
        
        public WrapperArea(Area_de_trabajo__c unArea){
            area = unArea;
            retos = new List<Reto__c>();
            //wppRetos = new List<WrapperReto>();
        }
    }
}