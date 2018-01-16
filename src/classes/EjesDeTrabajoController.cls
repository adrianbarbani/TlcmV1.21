public with sharing class EjesDeTrabajoController {

    public String idCuenta {get; set;}
    
    public List<Reto__c> retosAreas {get; set;}
    
    public List<AreaWrapper> areas {get; set;}
    
    public Boolean mostrar {get; set;}
    public Boolean hayDatos {get; set;}
    
    map<Id, List<retoWrapper> > areasConSusRetos {get; set;}
    
    public ObjetoJsonD3 objetoASerializar {get; set;}
    public String js {get; set;}
    
    public List<Area_de_trabajo__c> areasDeTrabajo {get; set;}
    
    public EjesDeTrabajoController(){
        
        idCuenta = ApexPages.currentPage().getParameters().get('Id');
        
        areasConSusRetos = new Map<Id, List<retoWrapper> >();
        
        mostrar = false;
        if(idCuenta != null){
            mostrar = true;
        }
        
        
        retosAreas = new List<Reto__c>();
        
        if(Schema.sObjectType.Area_de_trabajo__c.isAccessible() && Schema.sObjectType.Area_de_trabajo__c.fields.Conocimiento_del_Area__c.isAccessible()
        && Schema.sObjectType.Area_de_trabajo__c.fields.Tipo_de_Area__c.isAccessible()
        && Schema.sObjectType.Area_de_trabajo__c.fields.Titulo_Area__c.isAccessible()){
        areasDeTrabajo = [select id, Conocimiento_del_Area__c, Tipo_de_Area__c, Titulo_Area__c
                          from Area_de_trabajo__c
                          where cuenta__c =: idCuenta];
        }
        
        Set<String> idAreas = new Set<String>();
        for(Area_de_trabajo__c area: areasDeTrabajo){
            idAreas.add(area.id);
        }
        
        if(Schema.sObjectType.Reto__c.isAccessible() && Schema.sObjectType.Reto__c.fields.Competidor__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Etapa_del_Reto__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Fecha_Compromiso__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Nombre_del_Reto__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Nota__c.isAccessible()
        && Schema.sObjectType.Reto__c.fields.Area_de_trabajo__c.isAccessible()){
        retosAreas = [select id, Competidor__c, Etapa_del_Reto__c, Fecha_Compromiso__c, Nombre_del_Reto__c, Nota__c, Area_de_trabajo__c,
                     (select id, Nivel_de_Relaci_n__c, Otro_contacto_del_cliente__c, Tipo_de_Contacto__c, Reto__c from Reto_Contactos__r),
                     (select id, Lista_de_Soluciones__c, Nivel_de_Desarrollo__c, Observaci_n_sobre_el_producto__c, Otra_Solucion__c, Reto__c from Reto_tecnologias__r)
                     from Reto__c
                     where Area_de_trabajo__c IN: idAreas];
        }

        hayDatos = false;
        if(retosAreas.size()>0){
            hayDatos = true;
        }
        
        crearRetosWrappers();
        
        areas = new List<AreaWrapper>();
        
        for(Area_de_trabajo__c area: areasDeTrabajo){
            
            List<retoWrapper> retosWrapperDelArea = areasConSusRetos.get(area.id);
            if(retosWrapperDelArea == null){
                retosWrapperDelArea = new List<retoWrapper>();
            }
            
            areas.add(new AreaWrapper(area.Titulo_Area__c, retosWrapperDelArea ,area.Conocimiento_del_Area__c));
        }
		
        crearObjetoD3();

        js = JSON.serialize(objetoASerializar);
		system.debug(js);       
    }
    
    
    public void crearRetosWrappers(){
        
        for(Area_de_trabajo__c area: areasDeTrabajo){
            
            List<Reto__c> retosArea =  new List<Reto__c>();
            for(reto__c reto: retosAreas){
                if(area.id == reto.Area_de_trabajo__c){
                    retosArea.add(reto);
                }
            }
            
            
            generarWrapperPara(area.id, retosArea);
            
        }

    }
    
    public void generarWrapperPara(Id area, List<Reto__c> retosArea){
        
        List<retoWrapper> retosWrapperArea = new List<retoWrapper>();
        for(Reto__c reto: retosArea){    
            RetoWrapper unRetoWrapper = new RetoWrapper(reto);
            retosWrapperArea.add(unRetoWrapper);
        }
        
        areasConSusRetos.put(area, retosWrapperArea);
    }
    
    
    public void crearObjetoD3(){
        
        List<ObjetoJsonD3> hijosDeArea = new List<ObjetoJsonD3>();
        
        objetoASerializar = new ObjetoJsonD3();
        objetoASerializar.name = 'Areas';
        objetoASerializar.parent = 'null';
        objetoASerializar.level = 'null';
		objetoASerializar.children = hijosDeArea;	
        
        for(AreaWrapper area: areas){
            
            List<ObjetoJsonD3> hijosDeReto = new List<ObjetoJsonD3>();
            
            ObjetoJsonD3 objArea = new ObjetoJsonD3();
            objArea.name = area.area;
            objArea.parent = 'null';
            
            /*
            if(area.conocimientoArea == 'Alto'){
                objArea.level = 'green';
                objArea.type = 'green';
            }
            if(area.conocimientoArea == 'Medio'){
                objArea.level = 'yellow';
                objArea.type = 'yellow';
            }
            if(area.conocimientoArea == 'Bajo'){
                objArea.level = 'red';
                objArea.type = 'red';
            }*/
            
            objArea.children = hijosDeReto;
            hijosDeArea.add(objArea);
            
            
            for(RetoWrapper reto: area.retos){
                List<ObjetoJsonD3> subdiviciones = new List<ObjetoJsonD3>();
                
                ObjetoJsonD3 objReto = new ObjetoJsonD3();
                objReto.name = reto.reto.Nombre_del_Reto__c;
                objReto.parent = 'null';
               	objReto.children = subdiviciones;
                hijosDeReto.add(objReto);
                
                if(reto.reto.Etapa_del_Reto__c == 'Diseño' || reto.reto.Etapa_del_Reto__c == 'Prospección'){
                    objReto.level = 'green';
                    objReto.type = 'green';
                }
                if(reto.reto.Etapa_del_Reto__c == 'RFP' || reto.reto.Etapa_del_Reto__c == 'RFI'){
                    objReto.level = 'yellow';
                    objReto.type = 'yellow';
                }
                if(reto.reto.Etapa_del_Reto__c == 'Compras' || reto.reto.Etapa_del_Reto__c == 'Implementación'){
                    objReto.level = 'red';
                    objReto.type = 'red';
                }
                
                
                List<ObjetoJsonD3> todasLasTecnologias = new List<ObjetoJsonD3>();
                ObjetoJsonD3 objTecnologia = new ObjetoJsonD3();
                objTecnologia.name = 'Tecnologias';
                //objTecnologia.parent = 'null';
                //objTecnologia.level = 'null';
                objTecnologia.children = todasLasTecnologias;
                subdiviciones.add(objTecnologia);
                
                List<ObjetoJsonD3> todosLosContactos = new List<ObjetoJsonD3>();
                ObjetoJsonD3 objContactoTotal = new ObjetoJsonD3();
                objContactoTotal.name = 'Contactos';
                //objContactoTotal.parent = 'null';
                //objContactoTotal.level = 'null';
                objContactoTotal.children = todosLosContactos;
                subdiviciones.add(objContactoTotal);
                
                for(Retos_Contacto__c contacto: reto.contactosDelCliente){
                    ObjetoJsonD3 objContacto = new ObjetoJsonD3();
                    objContacto.name = contacto.Tipo_de_Contacto__c;
                    //objContacto.parent = 'null';
                    //objContacto.level = 'null';
					
                    /*
                    if(contacto.Nivel_de_Relaci_n__c == 'Fluida y Constante'){
                        objContacto.level = 'green';
                        objContacto.type = 'green';
                    }
                    if(contacto.Nivel_de_Relaci_n__c == 'Intensa y Difícil' || contacto.Nivel_de_Relaci_n__c == 'Ocasional pero Cordial'){
                        objContacto.level = 'yellow';
                        objContacto.type = 'yellow';
                    }
                    if(contacto.Nivel_de_Relaci_n__c == 'Es “Anti-Telefonica”' || contacto.Nivel_de_Relaci_n__c == 'No lo conozco'){
                        objContacto.level = 'red';
                        objContacto.type = 'red';
                    }*/
                    
                    todosLosContactos.add(objContacto);
                }
                
                for(Reto_tecnologia__c solucion: reto.solucionesDelCliente){
                    ObjetoJsonD3 objSolucion = new ObjetoJsonD3();
                    objSolucion.name = solucion.Lista_de_Soluciones__c;
                    //objSolucion.parent = 'null';
                    //objSolucion.level = 'null';
                    
                    /*
                    if(solucion.Nivel_de_Desarrollo__c == 'Disponible'){
                        objSolucion.level = 'green';
                        objSolucion.type = 'green';
                    }
                    if(solucion.Nivel_de_Desarrollo__c == 'En Desarrollo'){
                        objSolucion.level = 'yellow';
                        objSolucion.type = 'yellow';
                    }
                    if(solucion.Nivel_de_Desarrollo__c == 'No Disponible'){
                        objSolucion.level = 'red';
                        objSolucion.type = 'red';
                    }*/
                    
                    todasLasTecnologias.add(objSolucion);
                }

            }
            
        }
        
    }
    //=========================================================
    class RetoWrapper {
        
        public Reto__c reto {get; set;}
        public List<Retos_Contacto__c> contactosDelCliente {get; set;}
        public List<Reto_tecnologia__c> solucionesDelCliente {get; set;}
        
        public retoWrapper(Reto__c unReto){
            reto = unReto;
            
            contactosDelCliente = unReto.Reto_Contactos__r;
            
            if(contactosDelCliente == null){
                contactosDelCliente = new List<Retos_Contacto__c>();
            }
			
            solucionesDelCliente = unReto.Reto_tecnologias__r;
            
            if(solucionesDelCliente == null){
                solucionesDelCliente = new List<Reto_tecnologia__c>();
            }
            
        }
        
    }
    
    public class AreaWrapper {
        
        public String area {get; set;}
        public List<RetoWrapper> retos {get; set;}
        public String conocimientoArea {get; set;}
        
        public AreaWrapper(String titulo, List<RetoWrapper> retosWrapper, String unConocimiento){
            area = titulo;
            
            retos = new List<RetoWrapper>();
            for(RetoWrapper reto : retosWrapper){
                if(reto.reto.Nombre_del_Reto__c != null && reto.reto.Nombre_del_Reto__c != ''){
                    retos.add(reto);
                }
            }
            
            conocimientoArea = '';
            if(unConocimiento != null){
                conocimientoArea = unConocimiento;
            }
        }
    }
    
    
}