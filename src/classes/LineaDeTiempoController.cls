public with sharing class LineaDeTiempoController {
	
    public String miJson {get;set;}
    
    public String idCuenta {get; set;}
    
    public List<Reto__c> retos {get; set;}
 
    public List<Hito_Relevante_2__c> Hitos {get; set;}
    
    public Boolean mostrar {get; set;}
    
    public String eventosJson {get; set;}
    
    public Boolean mostrarLineaDeTiempo {get; set;}
    
    //Lista de eventos por categoria.
    public List <String> vencimientos {get; set;}
    public List <String> eventoTelefonica {get; set;}
    public List <String> eventosDeTipoReto {get; set;}
    public List <String> vencimientoCompetencia {get; set;}
    public List <String> publicacionRFPComunicacion {get; set;}
    public List <String> publicacionRFPTI {get; set;}
    public List <String> eventoIndustria {get; set;}
    public List <String> previsionTOP3 {get; set;}
    public List <String> otroTipoDeEvento {get; set;}
    
    //filtro linea de tiempo.
    public Boolean filtroVencimiento {get; set;}
    public Boolean filtroEventoTelefonica {get; set;}
    public Boolean filtroEventosDeTipoReto {get; set;}
    public Boolean filtroVencimientoCompetencia {get; set;}
    public Boolean filtroPublicacionRFPComunicacion {get; set;}
    public Boolean filtroPublicacionRFPTI {get; set;}
    public Boolean filtroEventoIndustria {get; set;}
    public Boolean filtroPrevisionTOP3 {get;set;}
    public Boolean filtroOtroTipoDeEvento {get; set;}
    public Boolean todos {get; set;}
    
    public LineaDeTiempoController(){
    	
        filtroEventosDeTipoReto = false;
        filtroEventoTelefonica = false;
        
        idCuenta = ApexPages.currentPage().getParameters().get('Id');

        mostrar = false;
        if(idCuenta != null){
            mostrar = true;
        }
		
        //Consigo Las Areas
        
        List<Area_de_trabajo__c> areas = new List<Area_de_trabajo__c>();
        
        
        areas = [select id, Conocimiento_del_Area__c, Tipo_de_Area__c, Titulo_Area__c
                                          from Area_de_trabajo__c
                                          where cuenta__c =: idCuenta];
        
        Set<String> idAreas = new Set<String>();
        for(Area_de_trabajo__c area: areas){
            idAreas.add(area.id);
        }
        
        //Consigo los Retos
        
        
        retos = [select id, Etapa_del_Reto__c, Fecha_Compromiso__c, Nombre_del_Reto__c, Nota__c, Area_de_trabajo__c,
                 (select id, Nivel_de_Relaci_n__c, Otro_contacto_del_cliente__c, Tipo_de_Contacto__c, Reto__c from Reto_Contactos__r),
                 (select id, Lista_de_Soluciones__c, Nivel_de_Desarrollo__c, Observaci_n_sobre_el_producto__c, Otra_Solucion__c, Reto__c from Reto_tecnologias__r)
                 from Reto__c
                 where Area_de_trabajo__c IN: idAreas];
        

        //Consigo los Hitos
        List<Contenedor_de_hito2__c> contenedores = new List<Contenedor_de_hito2__c>();
        
         
         contenedores = [select id, Fecha_vencimiento_otros_servicios__c, vencimiento_datos_fijos__c, vencimiento_servicios_moviles__c,
                                                    (select id, Categoria__c, Descripcion__c, Fecha__c from Hitos_Relevantes_2__r)
                                                    from Contenedor_de_hito2__c
                                                    where cuenta__c =: idCuenta
                                                    Limit 1];
        if(contenedores.size() > 0){
            hitos = contenedores[0].Hitos_Relevantes_2__r;
            if(hitos == null){
                hitos = new List<Hito_Relevante_2__c>();
            }
        }
		
        
        eventosJson = generarJson();
    
        miJson = generarJson();
		system.debug(miJson);
    }
    
    public String generarJson(){
        
        vencimientos = new List<String>();
        eventoTelefonica = new List<String>();
        eventosDeTipoReto = new List<String>();
        vencimientoCompetencia = new List<String>();
        publicacionRFPComunicacion = new List<String>();
        publicacionRFPTI = new List<String>();
        eventoIndustria = new List<String>();
        previsionTOP3 = new List<String>();
        otroTipoDeEvento = new List<String>();
        
        String retorno = '';
        
        String cabecera = '{"title":{"media":{"url":"","caption":"","credit":""},"text":{"headline":"","text":""}},"events":[';
        
        List<String> eventos = new List<String>();
        
        if(retos.size() > 0 ){
            
            String datosRetos = generarDatosRetos();
            if(datosRetos!= ''){
                eventos.add(datosRetos);
            }
        }

        if(hitos != null){
            if(hitos.size() > 0){
                String datosHitos = generarDatosHitos();
                if(datosHitos != ''){
                    eventos.add(datosHitos);
                }
            }
        }
        
        mostrarLineaDeTiempo = true;
        String eventosConcatenados = concatenarDatos(eventos);
        if(eventosConcatenados == '' || eventosConcatenados == null){
            mostrarLineaDeTiempo = false;
        }
        
        retorno = cabecera + concatenarDatos(eventos) + ']}';
        
        system.debug(vencimientos.size());
        return retorno;
    }
    
      
    public String generarDatosRetos(){
        
        List<String> eventos = new List<String>();
        for(Reto__c reto: retos){
            
            if(reto.Fecha_Compromiso__c != null){
                String titulo = Label.reto;
                String descripcion = '';
                
                if(reto.Nombre_del_Reto__c != null){
                    descripcion = '<b>'+reto.Nombre_del_Reto__c.escapeHtml4()+'</b>';
                }
                if(reto.Nota__c != null){
                    descripcion += '<p>'+reto.Nota__c.escapeJava().escapeHtml4()+'</p>';
                }
                    
                String dato = generarDatosDeFecha(reto.Fecha_Compromiso__c, titulo, descripcion);
                eventos.add(dato);
                eventosDeTipoReto.add(dato);
            }
        }
        
		String retorno = concatenarDatos(eventos);
		//System.debug(retorno);        
        return retorno;
    }
    
    public String generarDatosHitos(){
        
        List<String> eventos = new List<String>();
        for(Hito_Relevante_2__c hito: Hitos){
            
            if(hito.Fecha__c != null){
                
                String titulo = Label.Otro;
                if(hito.Categoria__c != null){
                    titulo = hito.Categoria__c;
                    
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato Activo Con Nosotros')){
						titulo = Label.Venicmiento_Contrato_Nosotros;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Reto')){
						titulo = Label.reto;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato Activo con la Competencia')){
						titulo = Label.Vencimiento_Contrato_Activo_con_la_Competencia;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Publicación RFP Comunicaciones')){
						titulo = Label.Publicaci_n_RFP_Comunicaciones;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Publicación RFP TI')){
						titulo = Label.Publicaci_n_RFP_TI;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Evento para Nuestros Clientes')){
						titulo = Label.Evento_Clientes;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Evento Relevante de la industria')){
						titulo = Label.Evento_Relevante_de_la_industria;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato del Servicio')){
						titulo = Label.Vencimiento_Contrato_Servicio;
                    }
                }
               
                
                String descripcion = '';
                
                if(hito.Descripcion__c != null){
                    descripcion = hito.Descripcion__c.escapeJava().escapeHtml4();
                }
                
                String dato = generarDatosDeFecha(hito.Fecha__c, titulo, descripcion);
                eventos.add(dato);
                
                Boolean aniadidoAUnaCategoria = false;
                if(hito.categoria__c != null){
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato Activo Con Nosotros')){
                        vencimientos.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Reto')){
                        eventosDeTipoReto.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato Activo con la Competencia')){
                        vencimientoCompetencia.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Publicación RFP Comunicaciones')){
                        publicacionRFPComunicacion.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Publicación RFP TI')){
                        publicacionRFPTI.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Evento para Nuestros Clientes')){
                        eventoTelefonica.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Evento Relevante de la industria')){
                        eventoIndustria.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato del Servicio')){
                        previsionTOP3.add(dato);
                        aniadidoAUnaCategoria = true;
                    }
                }
                
                if(!aniadidoAUnaCategoria){
                    otroTipoDeEvento.add(dato);
                }
            }
        }
        
        
		String retorno = concatenarDatos(eventos);
		//system.debug(retorno);        
        return retorno;
    }
     
    public String generarDatosDeFecha(Date fecha, String titulo, String descripcion){
        
        String datos = '';
        
        Integer dia = fecha.day();
        Integer mes = fecha.month();
        Integer anio = fecha.year();
        
        datos = '{"media":{"url":"","caption":".","credit":""},"start_date":{"month":"'+mes+'","day":"'+dia+'","year":"'+anio+'"},"text":{"headline":"'+titulo+'","text":"'+descripcion+'","tag":"Categoria 1"}}';
        
        return datos;
    }
    
    public String concatenarDatos(List<String> eventos){
        
        String retorno = '';
        for(String evento: eventos){
            retorno = retorno + evento + ',';
        }
        //system.debug(retorno);
        retorno = retorno.removeEnd(',');
        
        return retorno;
    }
    
    
    public PageReference filtrarTimeLine(){
        
        List<String> eventos = new List<String>();
        
        String cabecera = '{"title":{"media":{"url":"","caption":"","credit":""},"text":{"headline":"","text":""}},"events":[';
        

        if(filtroVencimiento){
            eventos.addAll(vencimientos);
        }
        system.debug(vencimientos);
        system.debug(vencimientos.size());
        if(filtroEventoTelefonica){
            eventos.addAll(eventoTelefonica);
        }
        if(filtroEventosDeTipoReto){
            eventos.addAll(eventosDeTipoReto);
        }        
        if(filtroVencimientoCompetencia){
            eventos.addAll(vencimientoCompetencia);
        }
        if(filtroPublicacionRFPComunicacion){
            eventos.addAll(publicacionRFPComunicacion);
        }
        if(filtroPublicacionRFPTI){
            eventos.addAll(publicacionRFPTI);
        }
        if(filtroEventoIndustria){
            eventos.addAll(eventoIndustria);
        }
        if(filtroPrevisionTOP3){
            eventos.addAll(previsionTOP3);
        }
        if(filtroOtroTipoDeEvento){
            eventos.addAll(otroTipoDeEvento);
        }

        
        mostrarLineaDeTiempo = false;
        String eventosConcatenados = '';
        
        if(eventos.size() > 0){
            eventosConcatenados = concatenarDatos(eventos);
            if(eventosConcatenados != '' && eventosConcatenados != null){
                mostrarLineaDeTiempo = true;
            }
            
        }
        
        system.debug(eventosConcatenados);
        
        miJson = cabecera + eventosConcatenados + ']}';
        
        system.debug(miJson);
        return null;
    }

}