@isTest
public class Build {

	public class AccountBuilder {
		Account ac = new Account();
		
		public AccountBuilder withName(string name) {
			ac.Name = name;
			return this;
		}
		
        public AccountBuilder withRegion(string value) {
			ac.Region__c = value;
			return this;
		}
        
        public AccountBuilder withIndustry(string value) {
            ac.Industry = value;
            return this;
        }
        
        public AccountBuilder withMicroIndustry(string value) {
            ac.Micro_Industry__c = value;
            return this;
        }
        
        public AccountBuilder withSector(string value) {
            ac.Sector__c = value;
            return this;
        }
        
		public Account build() {
			return ac;
		}
	}
	
	public static AccountBuilder anAccount() {
		return new AccountBuilder();
	}    
//---------------------------------------------------------------------------------------------------------------
// Opportunity
//---------------------------------------------------------------------------------------------------------------
	public class OpportunityBuilder {
		Opportunity op = new Opportunity();
		
		public OpportunityBuilder withaccountId(string accId) {
			op.AccountId = accId;
			return this;
		}
		
		public OpportunityBuilder withName(String name) {
			op.Name = name;
			return this;
		}
		
		public OpportunityBuilder withStageName(String stage) {
			op.stageName = stage;
			return this;
		}
		
		public OpportunityBuilder withCloseDate(Date closeDate) {
			op.CloseDate = closeDate;
			return this;
		}
		
        public OpportunityBuilder withBigDeal(boolean value) {
			op.BigDeals__c = value;
			return this;
		}
        
		public Opportunity build() {
			return op;
		}
	}
	
	public static OpportunityBuilder anOpportunity() {
		return new OpportunityBuilder();
	}    
// ------ Solicitud Builder --------------------    
    public class SolicitudBuilder {
        Solicitud_capex__c sol = new Solicitud_capex__c();
        
        public SolicitudBuilder withAplicantName (String name){
            sol.applicant_name__c = name;
            return this;
        }
        
        public SolicitudBuilder withAttachBusiness (String str){
            sol.Attach_Business_case__c = str;
            return this;
        }
        
        public SolicitudBuilder withMultiyearDisposition (String str){
            sol.Multiyear_Disposition__c = str;
            return this;
        }
        
        public SolicitudBuilder withOIBDA (Double num){
            sol.OIBDA__c = num;
            return this;
        }
        
        public SolicitudBuilder withRequestedCapex (Double num){
            sol.Requested_Capex__c = num;
            return this;
        }
        
        public SolicitudBuilder withReviewedByManagement (String str){
            sol.Reviewed_by_management_control__c = str;
            return this;
        }
        
        public SolicitudBuilder withSolicitationConcept (String str){
            sol.Solicitation_Concept__c = str;
            return this;
        }
        
        public SolicitudBuilder withTIR (Double num){
            sol.TIR__c = num;
            return this;
        }
        
        public Solicitud_capex__c build(){
            return sol;
        }
    }
    
    public static SolicitudBuilder aSolution() {
        return new SolicitudBuilder();
    }
    
//---------------------------------------------------------------------------------------------------------------
// Limite de Big deal por pais
//---------------------------------------------------------------------------------------------------------------
    public class CountryLimitBuilder {
        Limite_de_Big_deal_por_pais__c lim = new Limite_de_Big_deal_por_pais__c();
        
        public CountryLimitBuilder withName(String name) {
            lim.Name = name;
            return this;
        }
        
        public CountryLimitBuilder withShortName(String shName) {
            lim.Pais_corto__c = shName;
            return this;
        }
        
        public CountryLimitBuilder withFCV(double fcv) {
            lim.FCV__c = fcv;
            return this;
        }
        
        public CountryLimitBuilder withCAPEX(double capex) {
            lim.CAPEX__c = capex;
            return this;
        }
        
        public CountryLimitBuilder withNAV(double nav) {
            lim.NAV__c = nav;
            return this;
        }
        
        public Limite_de_Big_deal_por_pais__c build(){
            return lim;
        }
    }
    
    public static CountryLimitBuilder aCountryLimit() {
        return new CountryLimitBuilder();
    }    
//---------------------------------------------------------------------------------------------------------------
// Questionario Big deals
//---------------------------------------------------------------------------------------------------------------
    public class BigDealSurveyBuilder {
        private Big_deals_Survey__c survey = new Big_deals_Survey__c();
        
        public BigDealSurveyBuilder withOpportunityId(string opId) {
            survey.Oportunidad__c = opId;
            return this;
        }
        
        public BigDealSurveyBuilder withOfferTurnInDate(Date val) {
            survey.fecha_de_entrega__c = val;
            return this;
        }
        
        public BigDealSurveyBuilder withContractStartDate(Date val) {
            survey.Fecha_comienzo_de_contrato__c = val;
            return this;
        }
        
        public BigDealSurveyBuilder withDecisionDate(Date val) {
            survey.Fecha_estimada_del_fallo__c = val;
            return this;
        }
        
        public BigDealSurveyBuilder withDefinedReach(boolean value) {
            survey.Alcance_definido__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withTechnicalDescriptionExistence(boolean value) {
            survey.Existe_descripcion_tecnica__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withSLADefined(boolean value) {
            survey.SLA_definidos__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withCountry(string country) {
            survey.Pais__c = country;
            return this;
        }
        
        public BigDealSurveyBuilder withAffectedLines(string value) {
            survey.Lineas_implicadas__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withDeliberablesDescriptionScore(string value) {
            survey.Valoracion_de_relacion_de_entregables__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withTechnicalArchitectureScore (string value) {
        	survey.Valoracion_de_arquitectura_tecnica__c = value;
        	return this;
        }
        
        public BigDealSurveyBuilder withNeedOfThirdPartyInvolvement(boolean value) {
            survey.Necesario_desarrollar_oferta_con_tercero__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withReachOfThirdPartyInvolvement(string value) {
            survey.Alcance_de_la_colaboracion_con_terceros__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withNeedToAcquireResources(boolean value) {
            survey.Necesidad_de_incorporar_personas__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withAmountOfResourcesToIncorporate(string value) {
            survey.Cantidad_de_personas_a_incorporar__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withAmountOfContributedFTE(string value) {
            survey.FTE_que_se_aportaran__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withAmountOfThirdPartyFTERequired(string value) {
            survey.FTE_terceros_requeridos__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withActivitiesDuringPresale(string value) {
            survey.Actividades_durante_preventa__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withEstimatedPresaleAndOfferDuration(string value) {
            survey.Duracion_estimada_Preventa__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withTechnicalArchitectureDraft(string value) {
            survey.Arquitectura_tecnica__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withKnowledgeOnTheClient(string value) {
            survey.Grado_de_conocimiento_del_cliente__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withRelationWithPrincipalDecisionMakers(string value) {
            survey.Interrelacion_con_principales_decisores__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withProjectImpactOnClient(string value) {
            survey.Impacto_en_el_cliente__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withEnoughFormalInformation(boolean value) {
            survey.Informacion_formalizada_suficiente__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withSLADemandDegree(string value) {
            survey.Grado_exigencia_SLA__c = value;
            return this;
        } 
        
        public BigDealSurveyBuilder withCapacityToSatisfySLA(string value) {
            survey.Capacidad_para_cumplir_los_SLA__c = value;
            return this;
        } 
        
        public BigDealSurveyBuilder withDegreeOfCertainityStabilityOfPlatform(string value) {
            survey.Grado_certeza_continuidad_plataforma__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withSLADetailScore(string value) {
            survey.Valoracion_de_detalle_de_SLA__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withSLADetail(string value) {
            survey.SLA_Detalle__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withBails(string value) {
            survey.Importe_fianzas_depositar__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withIndemnizations(string value) {
            survey.Detalle_penalizaciones_indemnizaciones__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withPenaltyOnLevelService(string value) {
            survey.porcentaje_penalizacion_incumplimiento__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withPenaltyOnContractCancellation(string value) {
            survey.porcentaje_penalizacion_resicion__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withIndemnizationsVSValue(string value) {
            survey.porcentage_indemnizacion_total_importe__c = value;
            return this;
        }
        public BigDealSurveyBuilder withWorkingLiabilities(string value) {
            survey.Porcentaje_pasivo_laboral_importe__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withClientFinancialStability(boolean value) {
            survey.Estabilidad_financiera_cliente__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withCapexConsumption(boolean value) {
            survey.Consumo_capex_activos_fijos__c = value;
            return this;
        }
		
        public BigDealSurveyBuilder withClientKeyPersonnel(boolean value) {
            survey.Personal_clave_del_cliente_identificado__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withRequiredProfiles(boolean value) {
            survey.Estan_perfiles_clave_necesarios__c = value;
            return this;
        }
        
		public BigDealSurveyBuilder withKeyProductsInPortfolio(boolean value) {
            survey.Productos_clave_estan_en_porfolio__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withPartnersIdentified(boolean value) {
            survey.Partners_necesarios_identificados__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withSituationWithPartnersFavorable(boolean value) {
            survey.Situacion_con_partners_favorable__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withDeliverablesDescription(string value) {
            survey.Descripcion_de_los_entregables_del__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withFullContractValue(double value) {
            survey.Full_contract_value__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withIncomeForNext12Months(double value) {
            survey.NAV_o_ingresos_proximos_12_meses__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withNaturalYearNAV(double value) {
        	survey.NAV_12_meses_naturales__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withTotalCapex(double value) {
            survey.Capex_total__c = value;
            return this;
        }
        
        public BigDealSurveyBuilder withCapexDuringTheYear(double value) {
            survey.Capex_a_o_en_curso__c = value;
            return this;
        }
        
        public Big_deals_Survey__c build() {
            return survey;
        }
    }
    
    public static BigDealSurveyBuilder aBigDealSurvey() {
        return new BigDealSurveyBuilder();
    }
    
    public static BigDealSurveyBuilder aFullBigDealSurvey(Opportunity op) {//creates a survey with predefined dummy data.
        Limite_de_Big_deal_por_pais__c aCountryLimit = Build.aCountryLimit().withName('Robonia').withShortName('RBN').withFCV(10).withCAPEX(5).withNAV(5).build();
        if(Schema.sObjectType.Limite_de_Big_deal_por_pais__c.isCreateable())
        insert aCountryLimit;
        return new BigDealSurveyBuilder().withOpportunityId(op.Id).withFullContractValue(23).withNaturalYearNAV(15)
        	.withIncomeForNext12Months(15).withTotalCapex(12).withCapexDuringTheYear(5)
            .withOfferTurnInDate(System.today().addDays(47)).withContractStartDate(System.today().addDays(26))
            .withDecisionDate(System.today()).withDefinedReach(false).withTechnicalDescriptionExistence(true)
            .withSLADefined(true).withCountry(aCountryLimit.Pais_corto__c).withAffectedLines('80%').withDeliberablesDescriptionScore('80%')
            .withTechnicalArchitectureScore('90%').withNeedOfThirdPartyInvolvement(true).withReachOfThirdPartyInvolvement('< 10%')
            .withNeedToAcquireResources(true).withAmountOfResourcesToIncorporate('1').withAmountOfContributedFTE('5')
            .withAmountOfThirdPartyFTERequired('1').withActivitiesDuringPresale('Solo preventa especialista sectorial')
            .withEstimatedPresaleAndOfferDuration('2').withTechnicalArchitectureDraft('El motor mueve al universo, no a la nave')
            .withKnowledgeOnTheClient('Medio').withRelationWithPrincipalDecisionMakers('Medio').withProjectImpactOnClient('Escaso')
            .withEnoughFormalInformation(true).withSLADemandDegree('Escaso').withCapacityToSatisfySLA('Media').withDegreeOfCertainityStabilityOfPlatform('Media')
            .withSLADetailScore('60%').withSLADetail('whatevah').withBails('50').withIndemnizations('50').withWorkingLiabilities('1 - 2%')
            .withIndemnizationsVSValue('10 - 30%').withPenaltyOnContractCancellation('1 - 2%').withPenaltyOnLevelService('1 - 2%')
            .withClientFinancialStability(true).withCapexConsumption(false).withClientKeyPersonnel(true).withRequiredProfiles(true)
            .withKeyProductsInPortfolio(true).withPartnersIdentified(true).withSituationWithPartnersFavorable(true);
    }    
}