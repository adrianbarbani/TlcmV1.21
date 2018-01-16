public with sharing class SCPTabController {
    
    public FiltroPrueba__c filtro{get;set;}
    public List<User> usuariosDelFiltro{get;set;}
    public List<UsuarioWrapper> usersWpp {get;set;}
    public Boolean eliminar {get; set;}
    
    public Set<Id> usuariosDebajoDeLaJerarquia {get;set;}
    public Id miId {get;set;}
    public List<Account> cuentasTotales{get;set;}
  
    //public transient List<Account> cuentas {get; set;}
    
    //Promedios
    public Decimal promedioCoeDesarrollo {get; set;}
    public Decimal promedioCompletitud {get; set;}
    public Decimal promedioCuentasConFourPlanning {get; set;}
    public Decimal resultadoCompetidores{get;set;}
    
    Public Decimal porcentajeSegundoGrafico {get;set;}
    public Decimal conocimientoTerritorio {get;set;}
    
    public String filtroDeNombre {get; set;}
    
    //Linea de tiempo
    public String miJson {get; set;}
    
    public Boolean mostrarLineaDeTiempo {get; set;}
    
    public List <String> vencimientos {get; set;}
    public List <String> eventoTelefonica {get; set;}
    public List <String> eventosDeTipoReto {get; set;}
    public List <String> vencimientoCompetencia {get; set;}
    public List <String> publicacionRFPComunicacion {get; set;}
    public List <String> publicacionRFPTI {get; set;}
    public List <String> eventoIndustria {get; set;}
    public List <String> previsionTOP3 {get; set;}
    public List <String> otroTipoDeEvento {get; set;}
    
    //filtro linea de tiempo
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
    
    public String cuentaASacarDelGrafico {get; set;}
    public String cuentaAPonerDelGrafico {get; set;}
    
    Public Set<String> idsASacarDelGrafico {get; set;}
    
    
	public ApexPages.StandardSetController setCuentas {get; set;}
    
    
    public SCPTabController(){
        
        List<Account> cuentas = new List<Account>();
        
        idsASacarDelGrafico = new Set<String>();
        mostrarLineaDeTiempo = false;
        
        Id miId = UserInfo.getUserId();
        
        User miUsuario = new User();
        if(Schema.sObjectType.user.isAccessible() && Schema.sObjectType.user.fields.UserRoleId.isAccessible() ){
            miUsuario = [select id, UserRoleId from user where id =: miId];
        }
        
        usuariosDebajoDeLaJerarquia = new Set<Id>();
        if(miUsuario.userRoleId != null){
            usuariosDebajoDeLaJerarquia.addAll(Util.getRoleSubordinateUsers(miUsuario.UserRoleId));
        }
        
        system.debug(usuariosDebajoDeLaJerarquia);
        
        //Si no hay usuarios debajo, el set vuelve vacio.
        usuariosDebajoDeLaJerarquia.add(miId);
        
        
        List<Account> cuentasTotales = new List<Account>();
        
        cuentasTotales = [SELECT name,  OwnerId, owner.name, Strategic_Context__c, Region__c, Micro_Industry__c, Industry,
                          Cuenta_Para_Los_Graficos__c
                          FROM Account where OwnerId IN: usuariosDebajoDeLaJerarquia 
                          ORDER BY Name ASC
                          LIMIT 2000 ];
                        
    	    	    
        Set <Id> dueniosDeCuentas = new Set<Id>();
        
        For(Account cuenta:cuentasTotales){
            
            dueniosDeCuentas.add(cuenta.ownerId);
            
        }   
        
        filtro = new FiltroPrueba__c();
        usuariosDelFiltro = new List<User>();  
        
        usersWpp = new List<UsuarioWrapper>();        
        
        setCuentas = new ApexPages.StandardSetController(cuentasTotales);
        setCuentas.setPageSize(6);
        
        promedioCoeDesarrollo = 0;
        promedioCompletitud = 0;
        conocimientoTerritorio = 0;
        promedioCuentasConFourPlanning = 0;
        obtenerPromedios(cuentasTotales);
        
        miJson = '';
        
        if(cuentasTotales.size()>0){
            generarJsonLineaDeTiempo(setCuentas.getRecords());
            
        }
        
    }
    
    public void sacarDelGrafico(){
        
        
        if(idsASacarDelGrafico.contains(cuentaASacarDelGrafico)){
            idsASacarDelGrafico.remove(cuentaASacarDelGrafico);
        }else{
            idsASacarDelGrafico.add(cuentaASacarDelGrafico);
        }
        
       	
        setCuentas.setPageSize(2000);
        List<Account> cuentas = setCuentas.getRecords();
        setCuentas.setPageSize(6);
		
        List<Id> idsCuentas = new List<Id>();
        for(Account cuenta: cuentas){
            idsCuentas.add(cuenta.id);
        }
        
        List<Account> cuentasTotales = new List<Account>();
        
        if(Schema.sObjectType.Account.isAccessible() 
        && Schema.sObjectType.Account.fields.Name.isAccessible() 
        && Schema.sObjectType.Account.fields.Strategic_Context__c.isAccessible() 
        && Schema.sObjectType.Account.fields.Region__c.isAccessible() 
        && Schema.sObjectType.Account.fields.Micro_Industry__c.isAccessible() 
        && Schema.sObjectType.Account.fields.Cuenta_Para_Los_Graficos__c.isAccessible()){
        
        cuentasTotales = [SELECT name,  OwnerId, owner.name, Strategic_Context__c, Region__c, Micro_Industry__c, Industry,
                                        Cuenta_Para_Los_Graficos__c
                                        FROM Account where id NOT IN: idsASacarDelGrafico
                                        AND ID IN: idsCuentas
                                        ORDER BY LastModifiedDate DESC
                                        LIMIT 2000 ];
        }
        
        //setCuentas = new ApexPages.StandardSetController(cuentasTotales);
        if(cuentasTotales.size()>0){
            obtenerPromedios(cuentasTotales);
        }else{
            porcentajeSegundoGrafico = 0;
            conocimientoTerritorio = 0;
        }        
        //pone el check en true,
        //actualiza los graficos,
        //render tabla y graficos
    }
    
    public void agrego(){
        
        system.debug(filtro.UsuarioFiltro__c);
        
        if(filtro.UsuarioFiltro__c != null){
            User usuarioX = new User();
            
            if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible() ){
                usuarioX = [SELECT id, name FROM User WHERE id =: filtro.UsuarioFiltro__c];
            }
            
            UsuarioWrapper userWpp = new UsuarioWrapper(usuarioX);
            usersWpp.add(userWpp);
            
            usuariosDelFiltro.add(usuarioX);
            system.debug(usuariosDelFiltro);
            
            filtro.UsuarioFiltro__c = null;
            system.debug(filtro.UsuarioFiltro__c);}
    }
    
    public void borrar(){
        
        List<UsuarioWrapper> listaNueva = new List<UsuarioWrapper>();
        
        for(UsuarioWrapper usr: usersWpp){
            
            if(usr.eliminar == false){
                listaNueva.add(usr);
            }
            
        }
        
        usersWpp = listaNueva;
        
    }
    
    public void removeObjectFromList(List<usuarioWrapper> lst, usuarioWrapper obj) {
        for (Integer i = lst.size() - 1; i >= 0;-- i) {
            if (lst.get(i) == obj) {
                lst.remove(i);
            }
        }
    }
    
    public PageReference filtrar(){
        List<Account> cuentas = filtrarSinGuardar();
        obtenerPromedios(cuentas);
        return null;
    }
    
    public List<Account> filtrarSinGuardar(){
        
        List<Account> cuentas = new List<Account>();
        
        List<Id> idDeLosUsuarios = new List<Id>();
        
        for (usuarioWrapper usr: usersWpp){
            
            if(usuariosDebajoDeLaJerarquia.contains(usr.usuario)){
                idDeLosUsuarios.add(usr.usuario);
            }
        }
        
        
        if(idDeLosUsuarios.size() == 0){
            idDeLosUsuarios.add(miId);
        }
        
        system.debug(idDeLosUsuarios);
        
        if(!String.isBlank(filtroDeNombre)){
            
            String queryName = '%' + filtroDeNombre + '%';
            
            if(Schema.sObjectType.account.isAccessible() && Schema.sObjectType.account.fields.Name.isAccessible() &&
    	    	    Schema.sObjectType.account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.account.fields.Region__c.isAccessible() 
    	    	    && Schema.sObjectType.account.fields.Micro_Industry__c.isAccessible() && Schema.sObjectType.account.fields.Industry.isAccessible()){
            
            cuentas = [select id, name, owner.name, Strategic_Context__c, Region__c, Micro_Industry__c, Industry 
                       from account 
                       where name LIKE :queryName AND OwnerId in :idDeLosUsuarios AND OwnerId IN: usuariosDebajoDeLaJerarquia 
                       ORDER BY LastModifiedDate DESC 
                       LIMIT 2000];
                       
    	    	    }
        }else{
    
        if(Schema.sObjectType.account.isAccessible() && Schema.sObjectType.account.fields.Name.isAccessible() &&
    	    Schema.sObjectType.account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.account.fields.Region__c.isAccessible() 
    	    && Schema.sObjectType.account.fields.Micro_Industry__c.isAccessible() && Schema.sObjectType.account.fields.Industry.isAccessible()){
            
            cuentas = [select id, name, owner.name, Strategic_Context__c, Region__c, Micro_Industry__c, Industry 
                       from account 
                       WHERE OwnerId  in :idDeLosUsuarios AND OwnerId IN: usuariosDebajoDeLaJerarquia 
                       ORDER BY LastModifiedDate DESC 
                       LIMIT 2000];
                       
    	    }
    	    
        }

        
        if (cuentas.size() == 0){
            if(!String.isBlank(filtroDeNombre)){
                
                String queryName = '%' + filtroDeNombre + '%';
                
        if(Schema.sObjectType.account.isAccessible() && Schema.sObjectType.account.fields.Name.isAccessible() &&
    	    Schema.sObjectType.account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.account.fields.Region__c.isAccessible() 
    	    && Schema.sObjectType.account.fields.Micro_Industry__c.isAccessible() && Schema.sObjectType.account.fields.Industry.isAccessible()
    	    && Schema.sObjectType.account.fields.Cuenta_Para_Los_Graficos__c.isAccessible()){
                
                cuentas = [select id, name, owner.name, Strategic_Context__c, Region__c, Micro_Industry__c, Industry,
                           Cuenta_Para_Los_Graficos__c
                           from account 
                           where name LIKE :queryName  
                           AND OwnerId IN: usuariosDebajoDeLaJerarquia
                           ORDER BY LastModifiedDate DESC 
                           LIMIT 2000]; 
                           
    	    	    }
            }else{
                
            if(Schema.sObjectType.account.isAccessible() && Schema.sObjectType.account.fields.Name.isAccessible() &&
    	    Schema.sObjectType.account.fields.Strategic_Context__c.isAccessible() && Schema.sObjectType.account.fields.Region__c.isAccessible() 
    	    && Schema.sObjectType.account.fields.Micro_Industry__c.isAccessible() && Schema.sObjectType.account.fields.Industry.isAccessible()
    	    && Schema.sObjectType.account.fields.Cuenta_Para_Los_Graficos__c.isAccessible()){
    	        
                cuentas = [SELECT name,  OwnerId, owner.name, Strategic_Context__c, Region__c, Micro_Industry__c, Industry,
                           Cuenta_Para_Los_Graficos__c
                           FROM Account where OwnerId IN: usuariosDebajoDeLaJerarquia 
                           ORDER BY LastModifiedDate DESC
                           LIMIT 2000 ];
                           
    	    }
    	    
            }
        }
        
        setCuentas = new ApexPages.StandardSetController(cuentas);
        setCuentas.setPageSize(6);
        
        
        if(cuentas.size()>0){
            generarJsonLineaDeTiempo(setCuentas.getRecords());
        }else{
            mostrarLineaDeTiempo = false;
        }
        
        system.debug(miJson);
        system.debug(setCuentas.getRecords());
        
        return cuentas;
    }
    
    public void renderizar(){}
    
    public void establecerValoresDeLaLineaDeTiempo(){
        generarJsonLineaDeTiempo(setCuentas.getRecords());
        
        system.debug(miJson);
    }
    
    public void obtenerPrimerPagina(){
        setCuentas.first();
    }
    
    public void obtenerUltimaPagina(){
        setCuentas.last();
    }
    
    public void obtenerSiguiente(){
        if(setCuentas.getHasNext()){
            system.debug('- siguiente -');
            setCuentas.next();
        }    
    }
    
    public void obtenerAnterior(){
        if(setCuentas.getHasPrevious()){
            system.debug('- anterior -');
            setCuentas.Previous();
        }
    }
    
    public List<Account> getCuentasSetController(){
        if(setCuentas == null){
            List <Account> cuentas = new List<Account>();
            return cuentas;
        }else{
            return (List<Account>) setCuentas.getRecords();  
        }
    }
    
    
    public void generarJsonLineaDeTiempo(List<Account> Setcuentas){
        
        vencimientos = new List<String>();
        eventoTelefonica = new List<String>();
        eventosDeTipoReto = new List<String>();
        vencimientoCompetencia = new List<String>();
        publicacionRFPComunicacion = new List<String>();
        publicacionRFPTI = new List<String>();
        eventoIndustria = new List<String>();
        previsionTOP3 = new List<String>();
        otroTipoDeEvento = new List<String>();
        miJson = '';
        
        String cabecera = '{"title":{"media":{"url":"","caption":"","credit":""},"text":{"headline":"","text":""}},"events":[';
        List<String> eventos = new List<String>();
        
        List<Id> idsCuentas = new List<Id>();
        
        for(Account cuenta: Setcuentas){
            idsCuentas.add(cuenta.id);
        }
        
        
        for(Contenedor_de_hito2__c contenedor: [select id, cuenta__r.name, (select Id, Fecha__c, Descripcion__c, Categoria__c FROM Hitos_Relevantes_2__r) from Contenedor_de_hito2__c where cuenta__c In: idsCuentas]){
            
            List<Hito_Relevante_2__c> hitos = contenedor.Hitos_Relevantes_2__r;
            if(hitos == null){
                hitos = new List<Hito_Relevante_2__c>();
            }
            
            if(hitos.size() > 0){
                
                String datosHitos = generarDatosHitos(hitos, contenedor.cuenta__r.name);
                if(datosHitos != ''){
                    eventos.add(datosHitos);
                }
            }            
        }
        
        
        List<Area_de_trabajo__c> areasDeLosIdsCuenta = new List<Area_de_trabajo__c>();
        if(Schema.sObjectType.Area_de_trabajo__c.isAccessible()){
            areasDeLosIdsCuenta = [select id from Area_de_trabajo__c where cuenta__c In: idsCuentas];
        }
        
        List<Id> idsAreas = new List<Id>();
        
        for(Area_de_trabajo__c area: areasDeLosIdsCuenta){
            idsAreas.add(area.id);
        }
        
        //me traigo todo los retos.
        List<Reto__c> retos = new List<Reto__c>();
        
        if(Schema.sObjectType.Reto__c.isAccessible() && Schema.sObjectType.Reto__c.fields.Area_de_trabajo__c.isAccessible() && 
        Schema.sObjectType.Reto__c.fields.Fecha_Compromiso__c.isAccessible() && Schema.sObjectType.Reto__c.fields.Nombre_del_Reto__c.isAccessible() &&
        Schema.sObjectType.Reto__c.fields.Nota__c.isAccessible()){
            
            retos = [select Id, Area_de_trabajo__r.cuenta__r.name, Fecha_Compromiso__c, Nombre_del_Reto__c, Nota__c 
                       from Reto__c 
                       where Area_de_trabajo__c in: idsAreas ];
                       
        }                   
        
        if(retos.size() > 0 ){
            
            String datosRetos = generarDatosRetos(retos);
            if(datosRetos!= ''){
                eventos.add(datosRetos);
            }
        }
        
        
        
        String eventosConcatenados = concatenarDatos(eventos);
        mostrarLineaDeTiempo = false;
        if(eventosConcatenados != '' && eventosConcatenados != null){
            mostrarLineaDeTiempo = true;
            
            filtroVencimiento = true;
            filtroEventoTelefonica = true;
            filtroEventosDeTipoReto = true;
            filtroVencimientoCompetencia = true;
            filtroPublicacionRFPComunicacion = true;
            filtroPublicacionRFPTI = true;
            filtroEventoIndustria = true;
            filtroPrevisionTOP3 = true;
            filtroOtroTipoDeEvento = true;
            
            todos = true;
        }
        
        miJson = cabecera + concatenarDatos(eventos) + ']}';
        
    }
    
    public String generarDatosRetos(List<Reto__c> retos){
        
        List<String> eventos = new List<String>();
        
        for(Reto__c reto: retos){
            
            if(reto.Fecha_Compromiso__c != null){
                String titulo = Label.reto;
                String descripcion = '';
                
                if(reto.Area_de_trabajo__r.cuenta__r.name != null){
                    descripcion += '<b>'+reto.Area_de_trabajo__r.cuenta__r.name.escapeHtml4()+'<b/>';
                }
                if(reto.Nombre_del_Reto__c != null){
                    descripcion += '<p><b>'+reto.Nombre_del_Reto__c.escapeHtml4()+'</b></p>';
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
    
    public String generarDatosHitos(List<Hito_Relevante_2__c> hitos, String cuenta){
        
        List<String> eventos = new List<String>();
        for(Hito_Relevante_2__c hito: Hitos){
            
            if(hito.Fecha__c != null){
                
                String titulo = Label.Otro;
                if(hito.Categoria__c != null){
                    titulo = hito.Categoria__c;
                    
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato Activo con Nosotros')){
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
                
                if(cuenta != null){
                    descripcion = '<b>'+cuenta.escapeHtml4()+'<b/>';
                }
                if(hito.Descripcion__c != null){
                    descripcion += '<p>'+hito.Descripcion__c.escapeJava().escapeHtml4()+'</p>';
                }
                
                
                String dato = generarDatosDeFecha(hito.Fecha__c, titulo, descripcion);
                eventos.add(dato);
                
                Boolean aniadidoAUnaCategoria = false;
                if(hito.categoria__c != null){
                    if(hito.categoria__c.equalsIgnoreCase('Vencimiento Contrato Activo con Nosotros')){
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
    
    public String concatenarDatos(List<String> eventos){
        
        String retorno = '';
        for(String evento: eventos){
            retorno = retorno + evento + ',';
        }
        //system.debug(retorno);
        retorno = retorno.removeEnd(',');
        
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
    
    public PageReference filtrarTimeLine(){
        
        List<String> eventos = new List<String>();
        
        String cabecera = '{"title":{"media":{"url":"","caption":"","credit":""},"text":{"headline":"","text":""}},"events":[';
        
        if(setCuentas.getRecords().size()>0){
            if(filtroVencimiento){
                eventos.addAll(vencimientos);
            }
            
            system.debug(eventos);
            
            if(filtroEventoTelefonica){
                system.debug('dentro de evento telefonica');
                eventos.addAll(eventoTelefonica);
            }
            if(filtroEventosDeTipoReto){
                eventos.addAll(eventosDeTipoReto);
            }
            system.debug(eventosDeTipoReto);
            system.debug(eventos);
            
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
    
    public void obtenerPromedios(List<Account> lasCuentasTotales){
        
        Double sumatoriaConocimientoDeLaCuenta = 0;
        Double sumatoriaCompletitud = 0;
        Integer cuentaConFourPlanning = 0;
        promedioCoeDesarrollo = 0;
        promedioCompletitud = 0;
        conocimientoTerritorio = 0;
        
        //////////////////////////////////ENCUESTA////////////////////////////////
        
        List<Descripcion_del_cliente__c> descripciones = new List<Descripcion_del_cliente__c>();
        
        
        if(Schema.sObjectType.Descripcion_del_cliente__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.El_n_mero_de_sucursales_crece_decrece__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.Cantidad_de_edificios__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.cantidad_de_empleados__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.cantidad_de_sucursales__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.dispone_de_parque_automotor__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.Parque_Automotor_Propio_o_Gestionado__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.Presupuesto_anual_que_maneja_tu_cliente__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.siguientes_pa_ses_tienen_negocio__c.isAccessible()
        && Schema.sObjectType.Descripcion_del_cliente__c.fields.veh_culos_dispone_el_parque__c.isAccessible()){
            
        descripciones = [select id, El_n_mero_de_sucursales_crece_decrece__c, Cantidad_de_edificios__c, cantidad_de_empleados__c,
                         cantidad_de_sucursales__c, dispone_de_parque_automotor__c, Parque_Automotor_Propio_o_Gestionado__c, Presupuesto_anual_que_maneja_tu_cliente__c,
                         siguientes_pa_ses_tienen_negocio__c, veh_culos_dispone_el_parque__c
                         from Descripcion_del_cliente__c
                         where cuenta__c in :lasCuentasTotales];
        }
        //system.debug(lasCuentasTotales);
        
        //system.debug(descripciones);
        Decimal resultadoEncuesta = 0;

        //system.debug(resultadoEncuesta);
        
        for(Descripcion_del_cliente__c des: descripciones){
            
            if(des.El_n_mero_de_sucursales_crece_decrece__c != null){
                resultadoEncuesta ++;
            }
            if(des.Cantidad_de_edificios__c != null){
                resultadoEncuesta ++;
            }
            if(des.cantidad_de_empleados__c != null){
                resultadoEncuesta ++;
            }
            if(des.cantidad_de_sucursales__c != null){
                resultadoEncuesta ++;
            }
            if(des.dispone_de_parque_automotor__c != null){
                resultadoEncuesta ++;
            }
            if(des.Parque_Automotor_Propio_o_Gestionado__c != null){
                resultadoEncuesta ++;
            }
            if(des.Presupuesto_anual_que_maneja_tu_cliente__c != null){
                resultadoEncuesta ++;
            }
            if(des.siguientes_pa_ses_tienen_negocio__c != null){
                resultadoEncuesta ++;
            }
            if(des.veh_culos_dispone_el_parque__c != null){
                resultadoEncuesta ++;
            }
            
        }
        
        //system.debug(resultadoEncuesta);
        
        //system.debug(descripciones.size());
        
        Decimal resultadoFinalEncuesta =0;
        Decimal otroResultado =0;
       
        if (descripciones.size() > 0){
        resultadoFinalEncuesta = ((resultadoEncuesta * 100) / (9 * descripciones.size()));
        otroResultado = resultadoFinalEncuesta / 100;
        }
        
        
        //system.debug(resultadoFinalEncuesta);
        //system.debug(otroResultado);
        Decimal parcial;
        parcial = otroResultado;
        system.debug(parcial);
        
        //////////////////////////////////ENCUESTA////////////////////////////////
        
        //////////////////STRATEGIC CONTEXT/////////////////////////////
        
        //auxiliarCuentas = new List<Account>();
        Decimal resultadoContext = 0;

        
        List<Id> regionsIds = new List<Id>();
        List<String> sectores = new List<String>();
        List<String> subsectores = new List<String>();
        
        List<Id> idsDeLasCuentas = new List<Id>();		
        
        
        for (Account cuenta : lasCuentasTotales){
            
            if(cuenta.Strategic_Context__c !=null){
                resultadoContext ++;
            }            
            
            regionsIds.add(cuenta.Region__c);
            sectores.add(cuenta.Industry);
            subsectores.add(cuenta.Micro_Industry__c);
            idsDeLasCuentas.add(cuenta.id);
        }
        
        system.debug(resultadoContext);
        
        Decimal auxiliar = 0;
        Decimal auxiliar2 = 0;
        if (lasCuentasTotales.size() >0){
            auxiliar = ((resultadoContext * 100) / (lasCuentasTotales.size()));
            auxiliar2 = auxiliar / 100;
        }
        
        parcial = parcial + auxiliar2;
        system.debug(parcial);
        
        //////////////////////////////STRATEGIC INITIATIVES//////////////////////
        
        List<Strategic_Initiative__c> temp = new List<Strategic_Initiative__c>();
        if(Schema.sObjectType.Strategic_Initiative__c.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.Strategic_Initiative__c.isAccessible() &&
        Schema.sObjectType.Strategic_Initiative__c.fields.Name.isAccessible() && Schema.sObjectType.Strategic_Initiative__c.fields.Strategic_Initiative_URL__c.isAccessible()){
            
            temp = [SELECT name,Strategic_Initiative__c,Strategic_Initiative_URL__c, LastModifiedDate, account__r.name  
                      FROM Strategic_Initiative__c 
                      WHERE Account__C IN :idsDeLasCuentas ];
                      
        }
        
        system.debug(temp);
        
        Decimal resultadoStrategic = 0;
        
        for(Strategic_Initiative__c str: temp){
            
            if(str.Strategic_Initiative__c != null){
                resultadoStrategic ++;
            }
            
        }
        
        if(lasCuentasTotales.size() >0){
            auxiliar = ((resultadoContext * 100) / (lasCuentasTotales.size()));}
        else {
            auxiliar = 0;
        }
        
        auxiliar2 = (auxiliar * 2) / 100;
        
        parcial = parcial + auxiliar2;
        
        system.debug(parcial);
        
        //////////////////////////////MAIN COMPETITORS//////////////////////
        
        
        List<Account_Competitor__c> competidores = new List<Account_Competitor__c>();
        
        if(Schema.sObjectType.Account_Competitor__c.isAccessible() && Schema.sObjectType.Account_Competitor__c.fields.Name.isAccessible()
        && Schema.sObjectType.Account_Competitor__c.fields.Fact__c.isAccessible()){
        
            competidores = [SELECT Id, Name, Fact__c, LastModifiedDate 
                            FROM Account_Competitor__c 
                            where Account__c IN: idsDeLasCuentas];
                        
        }
        
        system.debug(competidores);
        
        Decimal resultadoCompetidores = 0; 
        
        for(Account_Competitor__c com: competidores){
            
            
            if(com.Name != null){
                resultadoCompetidores ++;
            }
            
        }
        
        system.debug(resultadoCompetidores);
        
        if (lasCuentasTotales.size() >0){
            auxiliar = ((resultadoCompetidores * 100) / (lasCuentasTotales.size()));}
        else {auxiliar = 0;}
        
        auxiliar2 = (auxiliar * 2) / 100;
        
        parcial = parcial + auxiliar2;
        
        system.debug(parcial);
        
        ////////////////////////////////////INDUSTRY TRENDS
        
        
        
        //system.debug(regionsIds);
        //system.debug(sectores);
        //system.debug(subsectores);
        
        List <Industry_Trend__c> trends = new List<Industry_Trend__c>();
        
        if(Schema.sObjectType.Industry_Trend__c.isAccessible() && Schema.sObjectType.Industry_Trend__c.fields.Region__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.RelatedTo__c.isAccessible() && Schema.sObjectType.Industry_Trend__c.fields.Name.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Trend__c.isAccessible() && Schema.sObjectType.Industry_Trend__c.fields.URL_Attachment__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.title__c.isAccessible() && Schema.sObjectType.Industry_Trend__c.fields.Type__c.isAccessible()){
            
        
        trends = [SELECT
                   Region__c, Region__r.Name, LastModifiedDate, RelatedTo__c, RelatedTo__r.title__c, RelatedTo__r.Trend__c,
                   Name, Trend__c, URL_Attachment__c, title__c, Type__c
                   FROM Industry_Trend__c 
                   WHERE Region__c in :regionsIds AND 
                   (Sub_Sector__c = :sectores OR Sub_Sector__c = 'Todos' OR Sub_Sector__c = 'All') AND 
                   (Industry__c = :subsectores OR Industry__c = 'Todos' OR Industry__c = 'All') AND
                   Type__c != 'Soluciones'
                   ORDER BY Name ASC
                  ];
        }
        //system.debug(trends);
        
        Decimal contadorPlayers = 0;
        Decimal contadorTendencias = 0;
        Decimal contadorCasos = 0;
        Decimal contadorMetricas = 0;
        Decimal contadorContexto = 0;
        Decimal contadorCadena = 0;
        
        for(Industry_Trend__c tren : trends){
            
            if (tren.Type__c == Label.Principales_players) {
                contadorPlayers ++;
            } 
            
            if (tren.Type__c == Label.Tendencias) {
                contadorTendencias ++;
            }
            
            if (tren.Type__c == Label.Casos_exito_sectorial) {
                contadorCasos ++;
            }
            
            if (tren.Type__c == Label.Metricas_analisis_mercado) {
                contadorMetricas ++;
            }
            
            if (tren.Type__c == Label.Contexto_General) {
                contadorContexto ++;
            }
            
            if (tren.Type__c == Label.Cadena_valor_procesos) {
                contadorCadena ++;
            }    
            
        }

        
        Decimal parcial1 = 0;
        Decimal parcial2=0;
        Decimal parcial3=0;
        Decimal parcial4=0;
        Decimal parcial5=0;
        Decimal parcial6=0;
        
        if(trends.size() > 0 && lasCuentasTotales.size() > 0){
            parcial1 = contadorPlayers / lasCuentasTotales.size();
            
            if (parcial1 > 1){
                parcial1= 1;
            }
            
            parcial2 = contadorTendencias / lasCuentasTotales.size();
            
            if (parcial2 > 1){
                parcial2= 1;
            }
            parcial3 = contadorCasos / lasCuentasTotales.size();
            
            if (parcial3 > 1){
                parcial3= 1;
            }
            parcial4 = contadorMetricas / lasCuentasTotales.size();
            
            if (parcial4 > 1){
                parcial4= 1;
            }
            
            parcial5 = contadorContexto / lasCuentasTotales.size();
            
            if (parcial5 > 1){
                parcial5= 1;
            }
            
            parcial6 = contadorCadena / lasCuentasTotales.size();
            
            if (parcial6 > 1){
                parcial6= 1;
            }
        }

        auxiliar = parcial1 + parcial2 + parcial3 + parcial4 + parcial5 + parcial6;
        
        //system.debug(auxiliar);
        
        parcial = parcial + auxiliar;
        
        ////////////Cuando termino todo
        
        system.debug(parcial);
        
        conocimientoTerritorio = ((parcial * 100) / 12).setScale(2);
        
        if(conocimientoTerritorio >100){
            conocimientoTerritorio = 100;
        }
        
        system.debug(conocimientoTerritorio);
        
        obtenerPromedioDelSegundoGrafico(idsDeLasCuentas);

    }
    
    
    public void obtenerPromedioDelSegundoGrafico(List<Id> idsDeLasCuentas){
        
        List<Account> cuentas = new List<Account>();
        
        if(Schema.sObjectType.Account.isAccessible()
        && Schema.sObjectType.Opportunity.isAccessible()){
        cuentas = [SELECT Id,
                     (SELECT Id from Opportunities where isClosed = false limit 1)
                     FROM Account
                     WHERE id In: idsDeLasCuentas];
        }
        
        Decimal cuantasCuentasTienenOportunidades = 0;
        
        for(Account cuenta: cuentas){
        	
            if(cuenta.Opportunities.size()>0){
                cuantasCuentasTienenOportunidades ++;
            }
            
        }
        
        if(cuentas.size() > 0){
            porcentajeSegundoGrafico = (cuantasCuentasTienenOportunidades * 100) / cuentas.size();
            porcentajeSegundoGrafico = porcentajeSegundoGrafico.setScale(2);
        }else{
            porcentajeSegundoGrafico = 0;
        }
        
    }
    
    public class usuarioWrapper{
        
        public Boolean eliminar {get; set;}
        public Id usuario {get; set;}
        public String nombre {get; set;}
        
        public usuarioWrapper(User unUsuario){
            eliminar = false;
            usuario = unUsuario.id;
            nombre = unUsuario.name;
        }
    }
    
}