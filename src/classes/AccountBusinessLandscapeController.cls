public with sharing class AccountBusinessLandscapeController {

    public Account account {get;set;}
    public Boolean canEdit {get;set;}
    public List<Business_Landscape__c> businessLandscapeList {get;set;}
    public List<Categoria_Servicio__c> categoriasDeServicios {get; set;}
    
    public String categoriaSeleccionada {get; set;}
    public String servicioSeleccionado {get; set;}
    //public Date fechaSeleccionada {get;set;}
    
    public Contenedor_de_hito2__c contenedor {get; set;}
    public Hito_Relevante_2__c hitoAInsertar {get; set;}
    
    public Id toDel {get;set;}
    public Id idCuenta {get;set;}
    public List<BusinessLandscapeWrapper> businessLandscapeWrapperList {get;set;}
    public Business_Landscape__c newBusinesLandscape {get;set;}
    
    public AccountBusinessLandscapeController() {
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() ){
            account = [SELECT id, Name FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        
        idCuenta = ApexPages.currentPage().getParameters().get('Id');
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
        
        if(Schema.sObjectType.Categoria_Servicio__c.isAccessible() && Schema.sObjectType.Categoria_Servicio__c.fields.Name.isAccessible() ){
		    categoriasDeServicios = [select id, name,
                                 (select id, name from Servicios__r)
                                 from Categoria_Servicio__c
                                 ORDER BY createdDate DESC LIMIT 90];
        }
			        
        init();        
    }
    
    public List<SelectOption> getItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('--Ninguno--','--Ninguno--'));
        for(Categoria_Servicio__c categoriaServicio : categoriasDeServicios){
            
            options.add(new SelectOption(categoriaServicio.name,categoriaServicio.name));
            
        }
        
        return options;
    }
    
    public List<SelectOption> getServicios() {
        
        List<Servicio__c> serviciosSeleccionados = new List<Servicio__c>();
        
         if(Schema.sObjectType.Servicio__c.isAccessible() && Schema.sObjectType.Servicio__c.fields.Name.isAccessible() ){
        serviciosSeleccionados = [select id, name from servicio__c where Categoria_Servicio__r.name =: categoriaSeleccionada];
         }
         
        List<SelectOption> options = new List<SelectOption>();

        for(Servicio__c servicio : serviciosSeleccionados){
            
            options.add(new SelectOption(servicio.name,servicio.name));
            
        }
        
        return options;
    }
    
    //public void prueba(){
      //  system.debug(categoriaSeleccionada);
    //}
    
    private void init() {
        hitoAInsertar = new Hito_Relevante_2__c();
        
        if(Schema.sObjectType.Business_Landscape__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.level__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.CurrentProvider__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.Sub_Category_Service__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.AnnualSpend__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.Country__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.ContractEndDate__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.NumberOfChannels__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.OtherInformation__c.isAccessible()  && Schema.sObjectType.Business_Landscape__c.fields.service__c.isAccessible()  && Schema.sObjectType.Business_Landscape__c.fields.Category_Service__c.isAccessible()  && Schema.sObjectType.Business_Landscape__c.fields.Decision_maker__c.isAccessible() && Schema.sObjectType.Business_Landscape__c.fields.Compra_a_nivel__c.isAccessible()){
        businessLandscapeList = [select id, level__c, CurrentProvider__c, Sub_Category_Service__c, AnnualSpend__c, Country__c, ContractEndDate__c, NumberOfChannels__c, 
                                 OtherInformation__c, service__c, Category_Service__c, Decision_maker__c, Compra_a_nivel__c 
                                 from Business_Landscape__c 
                                 where account__c = :account.id 
                                 order by createdDate];
         
        }
                
        
        newBusinesLandscape = new Business_Landscape__c(Account__c = account.id);

        Map<String, BusinessLandscapeWrapper> CategoryMap = new Map<String, BusinessLandscapeWrapper>();
        businessLandscapeWrapperList = new List<BusinessLandscapeWrapper>(); 
        
        for (Business_Landscape__c bl :businessLandscapeList) {
            
            if (CategoryMap.get(bl.Category_Service__c) == null) {
                BusinessLandscapeWrapper nuevoCategoriaDeServicio = new BusinessLandscapeWrapper(bl);
                
                //Creo el wrapper para el servicio.
                ServiciosWrapper servicioWpp = new ServiciosWrapper(bl);
                nuevoCategoriaDeServicio.servicios.add(servicioWpp);
                
                //Pongo el wrapper de categoria de servicio en el mapa.
                CategoryMap.put(bl.Category_Service__c, nuevoCategoriaDeServicio);
                
                //Pongo el wpp contenedor de la categoria en la lista para mostrarlo.
                businessLandscapeWrapperList.add(nuevoCategoriaDeServicio);
                
            } else { 
                
                //Obtengo el wpp de la categoria.
                BusinessLandscapeWrapper CategoriaDeServicioConocida = 	CategoryMap.get(bl.Category_Service__c);
                
                //Creo el wrapper para el servicio.
                ServiciosWrapper servicioWpp = new ServiciosWrapper(bl);
                
                //Se lo agrego a la categoria que corresponda.
                CategoriaDeServicioConocida.servicios.add(servicioWpp);
            }
        }
        
    }
    
    public PageReference save() {
        
        if(Schema.sObjectType.Business_Landscape__c.isCreateable() && Schema.sObjectType.Business_Landscape__c.isUpdateable()){
            upsert businessLandscapeList;
        }
        
        init();
        return null;
    }
    
    public PageReference add() {
        
        if(Schema.sObjectType.Business_Landscape__c.fields.Category_Service__c.isCreateable()){
            newBusinesLandscape.Category_Service__c = categoriaSeleccionada;
        }
        if(Schema.sObjectType.Business_Landscape__c.fields.Service__c.isCreateable()){
            newBusinesLandscape.Service__c = servicioSeleccionado;
        }
        if(Schema.sObjectType.Business_Landscape__c.fields.ContractEndDate__c.isCreateable()){
            newBusinesLandscape.ContractEndDate__c = hitoAInsertar.Fecha__c;
        }
        
        if( newBusinesLandscape.ContractEndDate__c == null){
            if(Schema.sObjectType.Business_Landscape__c.fields.ContractEndDate__c.isCreateable()){
                newBusinesLandscape.ContractEndDate__c = Date.today();
            }
        }
        
        List<Contenedor_de_hito2__c> contenedores = new  List<Contenedor_de_hito2__c>();
        
        
        contenedores = [select id, Fecha_vencimiento_otros_servicios__c, vencimiento_datos_fijos__c, vencimiento_servicios_moviles__c,
                        (select id, Categoria__c, Descripcion__c, Fecha__c from Hitos_Relevantes_2__r)
                        from Contenedor_de_hito2__c
                        where cuenta__c =: idCuenta
                        Limit 1];
        
        
        if(contenedores.size()>0){
            contenedor = contenedores[0];
        }else{
            contenedor = new Contenedor_de_hito2__c();
            contenedor.cuenta__c = idCuenta;
            insert contenedor;
        }
		

            hitoAInsertar.Categoria__c = 'Vencimiento Contrato del Servicio';
            hitoAInsertar.Descripcion__c = (Label.Servicio + ': ' + servicioSeleccionado);
            hitoAInsertar.Contenedor_de_hito__c = contenedor.id;
            insert hitoAInsertar;       

        
        Task tareaDelHito = new Task();
        if(Schema.sObjectType.Task.fields.ActivityDate.isCreateable()){
            tareaDelHito.ActivityDate = hitoAInsertar.Fecha__c;
        }
        if(Schema.sObjectType.Task.fields.Subject.isCreateable()){
            tareaDelHito.Subject = hitoAInsertar.Categoria__c;}
        if(Schema.sObjectType.Task.fields.Description.isCreateable()){
            tareaDelHito.Description = hitoAInsertar.Descripcion__c;}
        if(Schema.sObjectType.Task.fields.WhatId.isCreateable()){
            tareaDelHito.WhatId = idCuenta;
        }
        
        tareaDelHito.Hito_Relevante_2__c = hitoAInsertar.id;    
        
        insert tareaDelHito;
    
    

        if (newBusinesLandscape.Category_Service__c != null && newBusinesLandscape.Service__c != null){
            insert newBusinesLandscape;
        }
        
        init();
        return null;
    }
    
    public PageReference del() {        
        if (toDel != null) {
            Business_Landscape__c prueba = new Business_Landscape__c();
            
            if(Schema.sObjectType.Business_Landscape__c.isAccessible()){
            prueba = [select id from Business_Landscape__c where id = :toDel];
            }
            
            if(Business_Landscape__c.sObjectType.getDescribe().isDeletable()){
                delete prueba;
            }
            
            init();
        }       
        return null;
    }
    
    public PageReference ExportToExcel() { 
        save();
        return Page.accountBusinessLandscapeExcel;
    }
    
    public PageReference siNoHayCreadoUnRegistroEnParqueDeServiciosGeneroUnoDeCadaUno(){
        
        if(businessLandscapeList.size() == 0){
            system.debug('siNoHayCreadoUnRegistroEnParqueDeServiciosGeneroUnoDeCadaUno');
        	crearUnRegistroPorCategoria();
            init();
        }
        return null;
    }
    
    private void crearUnRegistroPorCategoria(){
        
        system.debug('crearUnRegistroPorCategoria');
        
        List<String> categorias = new List<String>();
        categorias.add('IoT');
        categorias.add('Seguridad');
        categorias.add('Comunicaciones unificadas y servicios de colaboración');
        categorias.add('Cloud');
        categorias.add('Big Data');
        
        //cargo el mapa de subCategorias por cada categoria.
        Map<String, List<String>> subCategoriaDeCadaCategoria = new Map<String, List<String>>();
        
        //cargo de cada categoria su lista de subcategorias.
        List<String> categoriaIoT = new List<String>{'Conectividad IoT','Smart Mobility','Smart Cities','Smart Retail','Nuevo Negocio IoT'};
        List<String> categoriaSeguridad = new List<String>{'Almacenamiento','Seguridad Mgmt','Seguridad en Comunicaciones','Seguridad Cloud','Identidad & Privacidad'};
        List<String> categoriaComunicacion = new List<String>{'Gestión de Servicios Móviles','Unificación de Comunicaciones y Servicios de Colaboración','Servicios de Red'};
        List<String> categoriaCloud = new List<String>{'Almacenamiento','laaS & PaaS','Gestión de Servicios Cloud','SaaS','Enterprise Mobile IT'};
        List<String> categoriaBigData = new List<String>{'Smart Steps','Smart Digits'};
        
        subCategoriaDeCadaCategoria.put('IoT',categoriaIoT);
        subCategoriaDeCadaCategoria.put('Seguridad',categoriaSeguridad);
        subCategoriaDeCadaCategoria.put('Comunicaciones unificadas y servicios de colaboración',categoriaComunicacion);
        subCategoriaDeCadaCategoria.put('Cloud',categoriaCloud);
        subCategoriaDeCadaCategoria.put('Big Data',categoriaBigData);
            
        List<Business_Landscape__c> servicios = new List<Business_Landscape__c>();
        
        Business_Landscape__c servicio = new Business_Landscape__c();
        for(String categoria: categorias){
            for(String subCategoria: subCategoriaDeCadaCategoria.get(categoria)){
                servicio = new Business_Landscape__c();
                if(Schema.sObjectType.Business_Landscape__c.fields.Category_Service__c.isCreateable()){
                    servicio.Category_Service__c = categoria;}
                if(Schema.sObjectType.Business_Landscape__c.fields.Service__c.isCreateable()){
                    servicio.Service__c = subCategoria;}
                if(Schema.sObjectType.Business_Landscape__c.fields.Account__c.isCreateable()){
                    servicio.Account__c = account.id;}
                servicios.add(servicio);
            }
        }
		
        system.debug(servicios);
        
        if (Schema.sObjectType.Business_Landscape__c.isCreateable()){
            insert servicios;
        }
        
    }
    
    public String getExcelName() {
        String name = account.Name + '-' + Label.Account_Business_Landscape +'.xls';
        return name.replaceAll(' ', '_');
    }    
    
    class BusinessLandscapeWrapper {
        
        public Business_Landscape__c bl {get;set;}
        public List<serviciosWrapper> servicios {get;set;}        
        
        public BusinessLandscapeWrapper(Business_Landscape__c n) {
            bl = n;
            servicios = new List<serviciosWrapper>();
        }
    }
    
    class serviciosWrapper {
        
        public Business_Landscape__c servicio {get; set;}
        
        public serviciosWrapper(Business_Landscape__c unServicio){
            servicio = unServicio;
        }
    }
    
}