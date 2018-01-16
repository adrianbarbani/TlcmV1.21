public with sharing class OpportunityBigDealController {
	public static final string DELIVERABLES_DESC = 'deliverables';
    public static final string TECHNICAL_DESC = 'technical';
    
	public Opportunity BigDealOpportunity {get;set;}
	public Account BigDealAccount {get; set;}

	public Boolean canEdit {get; set;}
    public boolean canRead {get; set;}
	public Boolean isBigDealAdmin {get; set;}
    public Boolean isBlocked {get; set;}

	public Big_deals_Survey__c Survey{get; set;}
    
    Public List<String> missingObligatoriField {get; set;}
    
	public OpportunityBigDealController(ApexPages.StandardController controller) {
        missingObligatoriField = new List<String>();
        
        loadPermissions();
        if(!canRead) {
            Survey = new Big_deals_Survey__c();
            BigDealOpportunity = new Opportunity();
            return;
        }
        
        if(Schema.sObjectType.Opportunity.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
        && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Amount.isAccessible()
        && Schema.sObjectType.Opportunity.fields.Description.isAccessible()
        && Schema.sObjectType.Opportunity.fields.CreatedDate.isAccessible())
		BigDealOpportunity = [
			SELECT id, Name, AccountId, Amount, Description, CreatedDate
			FROM Opportunity
			WHERE id = :ApexPages.currentPage().getParameters().get('Id')
		];
		
		List<Account> existingAccount = new List<Account>();
		if(Schema.sObjectType.Account.isAccessible()
		&& Schema.sObjectType.Account.fields.Name.isAccessible())
		existingAccount = [
			SELECT id, Name
			FROM Account
			WHERE id = :BigDealOpportunity.accountId
		];
		
        if(existingAccount.size() == 0) {
			BigDealAccount = new Account();
		}
		else {
			BigDealAccount = existingAccount[0];
		}
		//tdd compatible
		loadSurvey();

        checkSurveyState();   
	}
	
    private void checkSurveyState() {        
        if (Survey.state__c == 'Bloqueado') {
            isBlocked = true;
            if (!isBigDealAdmin) {
                canEdit = false;            
            }
        } else {
            isBlocked = false;
        }
    }

    private void loadPermissions() {
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        List<UserRecordAccess> recordAccessList = New List<UserRecordAccess>();
        
        if(Schema.sObjectType.UserRecordAccess.isAccessible()
        && Schema.sObjectType.UserRecordAccess.fields.RecordId.isAccessible()
        && Schema.sObjectType.UserRecordAccess.fields.HasReadAccess.isAccessible()
        && Schema.sObjectType.UserRecordAccess.fields.HasEditAccess.isAccessible()
        && Schema.sObjectType.UserRecordAccess.fields.MaxAccessLevel.isAccessible())
        recordAccessList = [SELECT RecordId, HasReadAccess, HasEditAccess, MaxAccessLevel FROM UserRecordAccess 
                                                   WHERE UserId=:UserInfo.getUserId() AND RecordId = :ApexPages.currentPage().getParameters().get('Id')];
        if(recordAccessList.size() > 0) {
            UserRecordAccess ura = recordAccessList[0];
            //userActions temp = new userActions();
            canEdit = ura.HasEditAccess;//temp.checkWrite(BigDealOpportunity.accountId);
            canRead = ura.HasReadAccess;
            isBigDealAdmin = false;
            
            List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
            if(Schema.sObjectType.PermissionSetAssignment.isAccessible()
            && Schema.sObjectType.PermissionSetAssignment.fields.PermissionSetId.isAccessible())
            psaList = [SELECT PermissionSetId, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name = 'Big_Deal_Admin'];
            
            if (psaList.size() > 0) {
                isBigDealAdmin = true;
            } 
        } else {
            canEdit = false;
            canRead = false;
            isBigDealAdmin = false;
        }
    }
    
	private void loadSurvey() {
	    List<Big_deals_Survey__c> existentSurveys = new List<Big_deals_Survey__c>();
	    if(Schema.sObjectType.Big_deals_Survey__c.isAccessible() 
            
            && Schema.sObjectType.Big_deals_Survey__c.fields.Name.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Fecha_comienzo_de_contrato__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Fecha_de_defensa__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.fecha_de_entrega__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Fecha_estimada_del_fallo__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Full_contract_value__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.NAV_o_ingresos_proximos_12_meses__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Valor_estimado_one_shot__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Valor_estimado_ingresos_recurrentes__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Duracion_de_responsabilidad_civil__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Capex_total__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Capex_a_o_en_curso__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Lineas_implicadas__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.l_neas_de_producto_principales__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Alcance_definido__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.arquitectura_tecnica__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Necesario_desarrollar_oferta_con_tercero__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Alcance_de_la_colaboracion_con_terceros__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Duracion_del_proyecto__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Plazo_de_ejecucion__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Experiencia_con_proyectos_similares__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Detalle_de_experiencia_en_el_Grupo__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Necesidad_de_incorporar_personas__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.FTE_que_se_aportaran__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.FTE_no_presentes__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.FTE_terceros_requeridos__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Detalle_de_perfiles_necesarios__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Actividades_durante_preventa__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Duracion_estimada_Preventa__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Condiciones_previas_para_licitar__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Importe_fianzas_depositar__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Duracion_de_la_garantia__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.SLA_definidos__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.SLA_Detalle__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Detalle_penalizaciones_indemnizaciones__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Cantidad_jornadas_preventa_y_oferta__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Tiempo_responsabilidad_terceros__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Grado_de_conocimiento_del_cliente__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Informacion_formalizada_suficiente__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.FCV_de_contratos_actuales__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Estabilidad_financiera_cliente__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Productos_clave_estan_en_porfolio__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Partners_necesarios_identificados__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Interrelacion_con_principales_decisores__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Impacto_en_el_cliente__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Estabilidad_organizacion_del_cliente__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Existe_experiencia_previa_con_solucion__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Grado_exigencia_SLA__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Capacidad_para_cumplir_los_SLA__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Grado_certeza_continuidad_plataforma__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Es_moroso_con_el_Grupo__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Existe_descripcion_tecnica__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Consumo_capex_activos_fijos__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.facturacion_estandar__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.porcentage_indemnizacion_total_importe__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Porcentaje_pasivo_laboral_importe__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Estan_perfiles_clave_necesarios__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.porcentaje_penalizacion_resicion__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Personal_clave_del_cliente_identificado__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Situacion_con_partners_favorable__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Productos_terceros_cumplen_SLA__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.porcentaje_penalizacion_incumplimiento__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Competencia__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Cantidad_de_personas_a_incorporar__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Pais__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Sector__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Tipo_de_oportunidad__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Tipo_de_negocio__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Responsable_comercial__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Nivel_de_interlocucion_con_el_cliente__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Es_cliente_actual_de_TEF__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Ambito_donde_ya_es_cliente_con_TEF__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.NAV_12_meses_naturales__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Valoracion_de_arquitectura_tecnica__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Valoracion_de_detalle_de_SLA__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Valoracion_de_relacion_de_entregables__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Descripcion_de_los_entregables_del__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.Codigo_en_Sales_Force_del_proyecto__c.isAccessible()
            && Schema.sObjectType.Big_deals_Survey__c.fields.State__c.isAccessible()
            )
            
		 existentSurveys = [
			SELECT ID, Name, Fecha_comienzo_de_contrato__c, Fecha_de_defensa__c, fecha_de_entrega__c,
				Fecha_estimada_del_fallo__c, Full_contract_value__c, NAV_o_ingresos_proximos_12_meses__c,
				Valor_estimado_one_shot__c, Valor_estimado_ingresos_recurrentes__c, Duracion_de_responsabilidad_civil__c,
				Capex_total__c, Capex_a_o_en_curso__c, Lineas_implicadas__c, l_neas_de_producto_principales__c,
				Alcance_definido__c, arquitectura_tecnica__c, Necesario_desarrollar_oferta_con_tercero__c,
				Alcance_de_la_colaboracion_con_terceros__c, Duracion_del_proyecto__c, Plazo_de_ejecucion__c,
				Experiencia_con_proyectos_similares__c, Detalle_de_experiencia_en_el_Grupo__c, Necesidad_de_incorporar_personas__c,
				FTE_que_se_aportaran__c, FTE_no_presentes__c, FTE_terceros_requeridos__c, Detalle_de_perfiles_necesarios__c,
            	Actividades_durante_preventa__c, Duracion_estimada_Preventa__c, Condiciones_previas_para_licitar__c,
            	Importe_fianzas_depositar__c, Duracion_de_la_garantia__c, SLA_definidos__c, SLA_Detalle__c,
            	Detalle_penalizaciones_indemnizaciones__c, Cantidad_jornadas_preventa_y_oferta__c, Tiempo_responsabilidad_terceros__c,
            	Grado_de_conocimiento_del_cliente__c, Informacion_formalizada_suficiente__c, FCV_de_contratos_actuales__c, 
            	Estabilidad_financiera_cliente__c, Productos_clave_estan_en_porfolio__c, Partners_necesarios_identificados__c,
            	Interrelacion_con_principales_decisores__c, Impacto_en_el_cliente__c, Estabilidad_organizacion_del_cliente__c,
            	Existe_experiencia_previa_con_solucion__c, Grado_exigencia_SLA__c, Capacidad_para_cumplir_los_SLA__c,
            	Grado_certeza_continuidad_plataforma__c, Es_moroso_con_el_Grupo__c, Existe_descripcion_tecnica__c,
            	Consumo_capex_activos_fijos__c, facturacion_estandar__c, porcentage_indemnizacion_total_importe__c,
            	Porcentaje_pasivo_laboral_importe__c, Estan_perfiles_clave_necesarios__c, porcentaje_penalizacion_resicion__c, 
            	Personal_clave_del_cliente_identificado__c, Situacion_con_partners_favorable__c, Productos_terceros_cumplen_SLA__c,
            	porcentaje_penalizacion_incumplimiento__c, Competencia__c, Cantidad_de_personas_a_incorporar__c,
            	Pais__c, Sector__c, Tipo_de_oportunidad__c, Tipo_de_negocio__c, Responsable_comercial__c,
            	Nivel_de_interlocucion_con_el_cliente__c, Es_cliente_actual_de_TEF__c, Ambito_donde_ya_es_cliente_con_TEF__c,
            	NAV_12_meses_naturales__c, Valoracion_de_arquitectura_tecnica__c, Valoracion_de_detalle_de_SLA__c,
            	Valoracion_de_relacion_de_entregables__c, Descripcion_de_los_entregables_del__c, Codigo_en_Sales_Force_del_proyecto__c, State__c
				
			FROM Big_deals_Survey__c
			WHERE Oportunidad__c = :BigDealOpportunity.Id
		];
        
		if(existentSurveys.size() == 0) {
			Survey = new Big_deals_Survey__c(Oportunidad__c = BigDealOpportunity.id);
		}
		else {
			Survey = existentSurveys[0];
		}

	}

    public PageReference saveAndUnblock() {
        
        Big_deals_Survey__c tmpSurvey = new Big_deals_Survey__c();
        if(Schema.sObjectType.Big_deals_Survey__c.isAccessible())
        tmpSurvey = [select id from Big_deals_Survey__c where id = :Survey.id];
		
        if (Schema.sObjectType.Big_deals_Survey__c.fields.state__c.isUpdateable()){
            Survey.state__c = 'Desbloqueado';
            tmpSurvey.state__c = 'Desbloqueado';
        }
        
        if(Schema.sObjectType.Big_deals_Survey__c.isUpdateable())
        update tmpSurvey;
        
        checkSurveyState();        
        return null;
    }  

    public PageReference saveAndBlock() {

        checkAllObligatoriFieldsAreComplete();
        checkSurveyState();
        return null;
    }
	
    public void checkAllObligatoriFieldsAreComplete(){
    	        
        missingObligatoriField = new List<String>();
	
        // No se puede validar en visual, regla de validacion, etc. para que pueda guardarce a la hora de ingresar un archivo adjunto. 
        if(Survey.fecha_de_entrega__c == null){
            missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','fecha_de_entrega__c') + '" ' + Label.inSeccion + ' "' + Label.offer_schedule  +'". '  );  
        }
        
        if(Survey.NAV_o_ingresos_proximos_12_meses__c == null){ 
            missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','NAV_o_ingresos_proximos_12_meses__c') + '" ' + Label.inSeccion + ' "' + Label.Economical_information  +'". '  ); 
        }
        
        if(Survey.Capex_a_o_en_curso__c == null){
            missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','Capex_a_o_en_curso__c') + '" ' + Label.inSeccion + ' "' + Label.Economical_information  +'". '  ); 
        }
        
        if(Survey.Lineas_implicadas__c == null){
            missingObligatoriField.add(Label.falta_Detallar_el_de_la_soluci_n); 
        }
        
        if(Survey.Duracion_del_proyecto__c == null){
            missingObligatoriField.add(Label.falta_Duraci_n_total_del_proyecto);  
        }
        
        if(Survey.Plazo_de_ejecucion__c == null){
            missingObligatoriField.add(Label.falta_Cu_l_es_el_plazo_de_ejecuci_n); 
        }
        
        if(Survey.Experiencia_con_proyectos_similares__c == null){
            missingObligatoriField.add(Label.falta_Existe_experiencia_en_el);  
        }
        
        if(Survey.Cantidad_de_personas_a_incorporar__c == null){
            missingObligatoriField.add(Label.falta_N_de_personas);   
        }
        
        if(Survey.FTE_que_se_aportaran__c == null){
            missingObligatoriField.add(Label.falta_Concretar_el_n_mero_FTEs);   
        }
        
        if(Survey.FTE_terceros_requeridos__c == null){
            missingObligatoriField.add(Label.falta_Concretar_el_n_mero_de_FTEs_de_terceros);    
        }
        
        if(Survey.Cantidad_jornadas_preventa_y_oferta__c == null){
            missingObligatoriField.add(Label.falta_Calcular_el_n_de_jornadas);     
        }
        
        if(Survey.Actividades_durante_preventa__c == null){
            missingObligatoriField.add(Label.falta_Actividades_a_realizar_durante);      
        }
        
        if(Survey.Duracion_estimada_Preventa__c == null){
            missingObligatoriField.add(Label.falta_Duraci_n_estimada);       
        }
        
        if(Survey.Grado_de_conocimiento_del_cliente__c == null){
            missingObligatoriField.add(Label.falta_Cu_l_es_el_nivel_de_conocimiento);        
        }
        
        if(Survey.Interrelacion_con_principales_decisores__c == null){
            missingObligatoriField.add(Label.falta_Cu_l_es_el_grado_de_interrelaci_n);        
        }
        
        if(Survey.Impacto_en_el_cliente__c == null){
            missingObligatoriField.add(Label.falta_Cu_l_es_el_impacto_del_proyecto);         
        }
        
        if(Survey.Grado_exigencia_SLA__c == null){
            missingObligatoriField.add(Label.falta_Cu_l_es_el_grado_de_exigencia);          
        }
        
        if(Survey.Capacidad_para_cumplir_los_SLA__c == null){
            missingObligatoriField.add(Label.falta_Cu_nta_es_la_facilidad_para_TEF);            
        }
        
        if(Survey.Grado_certeza_continuidad_plataforma__c == null){
            missingObligatoriField.add(Label.falta_Cu_l_es_el_grado_de_fiabilidad_sobre);               
        }
        
        if(Survey.Importe_fianzas_depositar__c == null){
            missingObligatoriField.add(Label.falta_Cuantificar_el_importe_de_las_Fianzas);                 
        }
        
        if(Survey.Detalle_penalizaciones_indemnizaciones__c == null){
            missingObligatoriField.add(Label.falta_Detallar_el_importe);                  
        }
        
        if(Survey.porcentaje_penalizacion_incumplimiento__c == null){
            missingObligatoriField.add(Label.falta_Es_el_volumen_de_penalizaci_n);                   
        }
        
        if(Survey.porcentaje_penalizacion_resicion__c == null){
            missingObligatoriField.add(Label.falta_Es_el_volumen_de_penalizaci_n_m_ximo);                    
        }
        
        if(Survey.porcentage_indemnizacion_total_importe__c == null){
            missingObligatoriField.add(Label.falta_Es_significativo_el_volumen_de_indemnizaci_n);                    
        }
        
        if(Survey.Porcentaje_pasivo_laboral_importe__c == null){
            missingObligatoriField.add(Label.falta_Es_el_volumen_de_pasivo_laboral_m_ximo_significativo_respecto);                    
        }
        if(Survey.Fecha_estimada_del_fallo__c == null){
            missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','Fecha_estimada_del_fallo__c') + '" ' + Label.inSeccion + ' "' + Label.offer_schedule  +'". '  );
        }
        if(Survey.Fecha_comienzo_de_contrato__c == null){
           missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','Fecha_comienzo_de_contrato__c') + '" ' + Label.inSeccion + ' "' + Label.offer_schedule  +'". '  ); 
        }
        if(Survey.Full_contract_value__c == null){
           missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','Full_contract_value__c') + '" ' + Label.inSeccion + ' "' + Label.Economical_information  +'". '  );  
        }
        if(Survey.NAV_12_meses_naturales__c == null){
           //Los textos de ayuda por algun motivo estan alternados entre "nav 12 meses naturales" con "nav o ingresos 12 meses naturales". 
           missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','NAV_o_ingresos_proximos_12_meses__c') + '" ' + Label.inSeccion + ' "' + Label.Economical_information  +'". '  );
        }
        if(Survey.Capex_total__c == null){
           missingObligatoriField.add( Label.falta_completar + ' "' + obtenerTextoDeAyudaDe('Big_deals_Survey__c','Capex_total__c') + '" ' + Label.inSeccion + ' "' + Label.Economical_information  +'". '  ); 
        }
        
        
        //if i dont have errors i can save.
        if(missingObligatoriField.size() == 0){
            
            if (Schema.sObjectType.Big_deals_Survey__c.fields.state__c.isUpdateable() && Schema.sObjectType.Big_deals_Survey__c.fields.state__c.isCreateable()){
                Survey.state__c = 'Bloqueado';
                save();
            }

        }
    }
    
    public String obtenerTextoDeAyudaDe (String nombreObjeto, String nombreCampo){
        
        //Mapa para conseguir los nombres de todos los campos de Big deals Survey.
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(nombreObjeto); 
        
        String nombreDelCampoSeleccionado = '';
        
        if(leadSchema != null){
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            
            nombreDelCampoSeleccionado = fieldMap.get(nombreCampo).getDescribe().getinlineHelpText();
        }
        
        return nombreDelCampoSeleccionado;
    }
    
	public PageReference save() {
		try {
            //check for missing fields
            List<string> missingFields = new List<string>();
            //-----------------------------------------------
            if(Survey.Alcance_definido__c) {
                if(Survey.Descripcion_de_los_entregables_del__c == null || Survey.Descripcion_de_los_entregables_del__c == '') {
                    missingFields.add(Label.Deliberables_description);
                }
            }
            //-----------------------------------------------
            if(Survey.Existe_descripcion_tecnica__c){
                if(Survey.Arquitectura_tecnica__c == null || Survey.Arquitectura_tecnica__c == '') {
                    missingFields.add(Schema.Big_deals_Survey__c.fields.Arquitectura_tecnica__c.getDescribe().getInlineHelpText());
                }//
            }
            //-----------------------------------------------
            if(Survey.Necesidad_de_incorporar_personas__c) {
                if(Survey.Cantidad_de_personas_a_incorporar__c == null || Survey.Cantidad_de_personas_a_incorporar__c == '') {
                    missingFields.add(Schema.Big_deals_Survey__c.fields.Cantidad_de_personas_a_incorporar__c.getDescribe().getInlineHelpText());
                }
            }
            //-----------------------------------------------
            if(Survey.SLA_definidos__c) {
                if(Survey.SLA_Detalle__c == null || Survey.SLA_Detalle__c == '') {
                    missingFields.add(Schema.Big_deals_Survey__c.fields.SLA_Detalle__c.getDescribe().getInlineHelpText());
                }
            }
            //-----------------------------------------------
            if(missingFields.size() > 0) {
                for(string field : missingFields) {
                    string message = Label.Missing_field_error_base;
                    message = message.replace('%f', field);
                    apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
                }
                return null;
            }
            //---------------------------------------------------------------------------------------------------------------------------------
            //Since no fields where missing, upsert
			
			
            
             if(Big_deals_Survey__c.sObjectType.getDescribe().isCreateable() && Big_deals_Survey__c.sObjectType.getDescribe().isUpdateable()){    
                upsert Survey;      
        }
            
            
            
		} catch(DmlException ex){
	        ApexPages.addMessages(ex);
        }
		return null;
	}
}