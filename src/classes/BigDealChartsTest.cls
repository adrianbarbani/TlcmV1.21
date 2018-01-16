@isTest
public class BigDealChartsTest {
	public static testMethod void whenTheOpportunityIsLoaded_TheBigDealShouldBeLoaded () {
		Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).build();
		insert aSurvey;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
		
		system.assertEquals(aSurvey.Id, controller.BigDealSurvey.Id);
	}
	
	public static testMethod void theScoreForTheFullContractValueShouldBeObtainable() {
		Map<double, integer> PointsForValues = new Map<double, integer>{
			200 => 100, 150 => 90, 100 => 80, 75 => 70, 50 => 60, 
			20 => 50, 10 => 40, 5 => 30, 2 => 20, 1 => 10, 0 => 0
		};//from excel: 0	0-2	2-5	5-10	10 - 20	20 - 50	> 50	> 75	> 100	> 150	> 200
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(double value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyFullContractValue(value));
		}
	}
	
	public static testMethod void theTrafficLightColorsForAScoreShouldBeObtainable() {
		string red = BigDealChartsController.red;
		string green = BigDealChartsController.green;
		string yellow = BigDealChartsController.yellow;
		string black = BigDealChartsController.black;
		
		Map<integer, string> ColorsForPoints = new Map<integer, string>{
			100 => green, 90 => green, 80 => green, 70 => green, 60 => green, 
			50 => yellow, 40 => yellow, 30 => yellow, 20 => red, 10 => red, 
			0 => red, -1 => black
		};
		
		for(integer points : ColorsForPoints.keySet()) {
			System.assertEquals(ColorsForPoints.get(points), BigDealChartsController.getColorForPercentage(points));
		}
	}
	
	public static testMethod void theScoreForTheIncomeForNext12MonthsShouldBeObtainable () {
		Map<double, integer> PointsForValues = new Map<double, integer>{
			50 => 100, 30 => 90, 20 => 80, 15 => 70, 10 => 60, 
			4 => 50, 2 => 40, 1 => 30, 0.5 => 20, 0.25 => 10, 0 => 0
		};//from excel: 0	0-0,5	0,5-1	1-2	2-4	4-8	> 10	> 15	> 20	> 30	> 50
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(double value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyIncomeForNext12Months(value));
		}
	}
	
	public static testMethod void theScoreForTotalCapexShouldBeObtainable () {
		Map<double, integer> PointsForValues = new Map<double, integer>{
			0 => 100, 2 => 90, 5 => 80, 10 => 70, 15 => 60, 
			25 => 50, 40 => 40, 60 => 30, 75 => 20, 90 => 10, 100 => 0, 101 => -1
		};//from excel: > 100	90 - 100	75 - 90	60 - 75	40 - 60	25 - 40	15 - 25	10 - 15	5 - 10	< 5	< 2	0
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(double value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyTotalCapex(value));
		}
	}
	
	public static testMethod void ifTheOpportunityDoesntHaveASurvey_TheControllerShouldNotLoadIt() {
		Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
		
		system.assertEquals(null , controller.BigDealSurvey.Id);
	}
	
	public static testMethod void whenTheSurveyIsLoaded_TheScoreForEconomicalInformationShouldBeObtainable() {
		Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).build();
		insert aSurvey;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
		
		double totalScore = controller.EconomicalInfoData.FullContractValue.Score +
                            controller.EconomicalInfoData.FCVSecondary.Score +
                            controller.EconomicalInfoData.IncomeForNext12Months.Score +
                            controller.EconomicalInfoData.IncomeForNext12MonthsSecondary.Score +
                            controller.EconomicalInfoData.TotalCapex.Score +
                            controller.EconomicalInfoData.NaturalYearNAV.Score +
                            controller.EconomicalInfoData.NaturalYearNAVSecondary.Score;
		system.assertEquals(totalScore, controller.EconomicalInfoData.Score);
	} 
	
	public static testMethod void theScoreForContractStartDateShouldBeObtainable () {
		Date aDecisionDate = System.today();
		integer week = 7;//days
		Map<Date, integer> PointsForValues = new Map<Date, integer>{
			aDecisionDate.addDays(7 * week) => 100, aDecisionDate.addDays(7 * week - 1) => 90, 
			aDecisionDate.addDays(6 * week - 1) => 80, aDecisionDate.addDays(5 * week - 1) => 70, 
			aDecisionDate.addDays(4 * week - 1) => 60, aDecisionDate.addDays(3 * week - 1) => 50, 
			aDecisionDate.addDays(2 * week - 1) => 20
		};//from excel: Fecha < Fallo +2s	Fecha < Fallo +3s	Fecha < Fallo +4s	Fecha < Fallo +5s	Fecha < Fallo +6s	Fecha < Fallo +7s	Fecha >= Fallo +7s
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(Date ContractStartDate : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(ContractStartDate), controller.qualifyContractStartDate(ContractStartDate, aDecisionDate));
		}
	}
	
	public static testMethod void theScoreForOfferTurnInDateShouldBeObtainable () {
		Date aDecisionDate = System.today();
		integer week = 7;//days
		Map<Date, integer> PointsForValues = new Map<Date, integer>{
			aDecisionDate.addDays(11 * week) => 100, aDecisionDate.addDays(11 * week - 1) => 90, 
			aDecisionDate.addDays(10 * week - 1) => 80, aDecisionDate.addDays(9 * week - 1) => 70, 
			aDecisionDate.addDays(8 * week - 1) => 60, aDecisionDate.addDays(7 * week - 1) => 50, 
			aDecisionDate.addDays(6 * week - 1) => 40, aDecisionDate.addDays(5 * week - 1) => 30,
			aDecisionDate.addDays(4 * week - 1) => 20, aDecisionDate.addDays(3 * week - 1) => 0, 
			aDecisionDate.addDays(14) => -1
		};//from excel: Fecha < hoy+15d	Fecha < hoy +3s 	Fecha < hoy +4s	Fecha < hoy +5s	Fecha < hoy +6s	
		  //			Fecha < hoy +7s	Fecha < hoy +8s	Fecha < hoy +9s	Fecha < hoy +10s	Fecha < hoy +11s	Fecha >= hoy +11s
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(Date OfferTurnInDate : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(OfferTurnInDate), controller.qualifyOfferTurnInDate(OfferTurnInDate));
		}
	}
	
	public static testMethod void whenTheSurveyIsLoaded_TheScoreAndColorForScheduleShouldBeObtainable() {
		Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).build();
		insert aSurvey;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
		
		double totalScore = controller.ScheduleData.OfferTurnInDate.Score + controller.ScheduleData.ContractStartDate.Score;
		string color = BigDealChartsController.getColorForPercentage(totalScore * 100 / controller.ScheduleData.Weight);
		system.assertEquals(totalScore, controller.ScheduleData.Score);
		system.assertEquals(color, controller.ScheduleData.Color);
	}
    
    public static testMethod void ifTheOpportunityIsNotABigDeal_TheScoresShouldLoadEmptyDataToAvoidCrashingTheVisualforcePage () {
        Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(false).build();
		insert anOpportunity;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
        
		system.assertEquals(0, controller.ScheduleData.Score);
    }
    
    public static testMethod void theSecondaryScoreForTheEconomicalInformationValuesShouldBeObtainable() {
		decimal aCountryLimit = 4.1;
        Map<double, integer> PointsForValues = new Map<double, integer>{
			aCountryLimit * 3 => 100, aCountryLimit * 2 => 90, 
            aCountryLimit * 1.5 => 80, aCountryLimit * 1.2 => 70, 
            aCountryLimit => 60, aCountryLimit * 0.8 => 50, 
            aCountryLimit * 0.7 => 40, aCountryLimit * 0.5 => 30, 
            aCountryLimit * 0.4 => 20, aCountryLimit * 0.2 => 10, 
            aCountryLimit * 0.1 => 0
		};//from excel: < 20%	< 40%	< 50%	< 70%	< 80%	< 100%	< 120%	< 150%	< 200%	< 300%	> 300%
		
		BigDealChartsController controller = new BigDealChartsController();
        
		for(double value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyEconomicalInfoSecondaryScores(value, aCountryLimit));
		}
	}
    
    public static testMethod void theScoreForDefinedReachShouldBeObtainable () {
        Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 100, false => -1
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyDefinedReach(value));
		}
    }
    
    public static testMethod void whenAnOpportunityIsLoadedThatDoesntHaveBeenEvaluated_TheControllerShouldntCrash () {
		Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withDeliberablesDescriptionScore(null).withTechnicalArchitectureScore(null).build();
		insert aSurvey;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
		
		system.assertEquals(aSurvey.Id, controller.BigDealSurvey.Id);
	}
    
    public static testMethod void theScoreForDefinedTechnicalDescriptionShouldBeObtainable () {
        Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 100, false => 0
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyTechnicalArchitectureDescription(value));
		}
    }
    
    public static testMethod void theScoreForReachOfThirdPartyInvolvementShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'< 10%' => 90, '< 20%' => 80, '< 30%' => 70, '< 40%' => 60, 
            '< 50%' => 50, '< 60%' => 30, '< 70%' => 20, '< 80%' => 0, '> 80%' => -1
		};//from excel: > 80%	< 80%	< 70%	< 60%	< 50%	< 40%	< 30%	< 20%	< 10%
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyReachOfThirdPartyInvolvement(value));
		}
	}
    
    public static testMethod void theScoreForAmountOfResourcesToIncorporateShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'+5' => 80, '+10' => 70, '+15' => 50, '+20' => 40, 
            '+30' => 30, '+40' => 20, '+50' => 10, '+70' => 0, '+80' => -1
		};//from excel: +80	+70	+50	+40	+30	+20	+15	+10	+5
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyAmountOfResourcesToIncorporate(value));
		}
	}
    
    public static testMethod void theScoreForAmountOfContributedFTEShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'+5' => 100, '5' => 80, '4' => 60, '3' => 40, 
            '2' => 20, '1' => 10, '0' => -1
		};//from excel: 0	1	2	3	4	5	+5
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyAmountOfContributedFTE(value));
		}
	}
    
    public static testMethod void theScoreForAmountOfThirdPartyFTERequiredShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'+5' => 0, '5' => 20, '4' => 30, '3' => 50, 
            '2' => 60, '1' => 80, '0' => 100
		};//from excel: 0	1	2	3	4	5	+5
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyAmountOfThirdPartyFTERequired(value));
		}
	}
    
    public static testMethod void theScoreForActivitiesDuringPresaleShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'Solo Oferta' => 30,
            'Solo preventa especialista sectorial' => 50, 
            'Preventa especialista sectorial + Oferta' => 100
		};//from excel: Solo Oferta		Solo preventa especialista sectorial	Preventa especialista sectorial + Oferta
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyActivitiesDuringPresale(value));
		}
	}
    
	public static testMethod void theScoreForEstimatedPresaleAndOfferDurationShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'+9' => -1, '9' => 0, '7' => 10,
            '6' => 20, '5' => 30, '4' => 40, 
            '3' => 60, '2' => 80, '1' => 100
		};//from excel: +9	9	7	6	5	4	3	2	1
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyEstimatedPresaleAndOfferDuration(value));
		}
	}
    
    public static testMethod void theScoreForMostRisksShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'Alto' => 100, 'Alta' => 100, 
            'Medio' => 60, 'Media' => 60, 
            'Bajo' => 30, 'Baja' => 30,
            'Escaso' => 0, 'Escasa' => 0
		};//from excel: Escaso	Bajo	Medio	Alto
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyMostRisks(value));
            System.assertEquals(100 - PointsForValues.get(value), controller.qualifyMostRisksInverse(value));
		}
	}
    
    public static testMethod void theScoreForEnoughFormalInformationShouldBeObtainable() {
        Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 100, false => 0
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyEnoughFormalInformation(value));
		}
    }
    
    public static testMethod void theScoreForBailsShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'+200' => 0, '200' => 30, '150' => 50,
            '100' => 60, '50' => 80, '0' => 100
		};//from excel: +200	200	150	100	50	0
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyBails(value));
		}
	}
    
    public static testMethod void theScoreForIndemnizationsShouldBeObtainable () {
		Map<string, integer> PointsForValues = new Map<string, integer>{
			'+200' => 10, '200' => 30, '150' => 50,
            '100' => 60, '50' => 80, '0' => 100, 'no conocidas' => 0
		};//from excel: no conocidas	+200	200	150	100	50	0
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyIndemnizations(value));
		}
	}
    
    public static testMethod void theScoreForDefinedSLAShouldBeObtainable () {
		Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 100, false => 0
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyDefinedSLA(value));
		}
	}
    
    public static testMethod void theScoreForClientFinancialStabilityShouldBeObtainable() {
        Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 0, false => 100
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyClientFinancialStability(value));
		}
    }
    
    public static testMethod void theScoreForCapexConsumptionShouldBeObtainable() {
        Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 30, false => 100
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyCapexConsumption(value));
		}
    }
    
    public static testMethod void theScoreForPenaltyOnLevelService_PenaltyOnContractCancellationAndWorkingLiabilityVSValueShouldBeObtainable() {
        Map<string, integer> PointsForValues = new Map<string, integer>{
			'<1%' => 100, '1 - 2%' => 60, 
            '3 - 5%' => 30, '>5%' => 0
		};//from excel: >5%	3-5%	1-2%	<1%
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyMostFinancialRisks(value));
		}
    }
    
    public static testMethod void theScoreForIndemnizationsVSValueShouldBeObtainable() {
        Map<string, integer> PointsForValues = new Map<string, integer>{
			'<10%' => 100, '10 - 30%' => 60, 
            '30 - 50%' => 30, '50 - 100%' => 0, '>100%' => -1
		};//from excel: >100%	50-100%	30-50%	10-30%	<10%
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(string value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyIndemnizationsVSValue(value));
		}
    }
    
    public static testMethod void theScoreForOrganizationAndThirdPartyRisksShouldBeObtainable() {
        Map<boolean, integer> PointsForValues = new Map<boolean, integer>{
			true => 100, false => 0
		};//from excel: no	si
		
		BigDealChartsController controller = new BigDealChartsController();
		
		for(boolean value : PointsForValues.keySet()) {
			System.assertEquals(PointsForValues.get(value), controller.qualifyOrganizationAndThirdPartyRisks(value));
		}
    }
    
    public static testMethod void itShouldBePosibleToSaveTheAdditionalDetails () {
        Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).build();
		insert aSurvey;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
		
        string SomeDetails = 'Some unimportant details';
        controller.BigDealSurvey.Detalles_Adicionales__c = SomeDetails;
        controller.save();
        
        System.assertEquals(SomeDetails, [SELECT Detalles_Adicionales__c FROM Big_deals_Survey__c WHERE Id = :aSurvey.Id][0].Detalles_Adicionales__c);
    }
    
    public static testMethod void whenThePageIsReloadedAndTheOpportunitySetAgain_TheAdditionalDetailsShouldBeKept () {
        Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).build();
		insert aSurvey;
		
		BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
        
        string SomeDetails = 'Some unimportant details';
        controller.BigDealSurvey.Detalles_Adicionales__c = SomeDetails;
        controller.BigDealOpportunity = anOpportunity;
        
        System.assertEquals(SomeDetails, controller.BigDealSurvey.Detalles_Adicionales__c);
    }
    
    public static testMethod void ifTheSurveyIsIncompleteTheDataShouldNotBeGraded () {
        Opportunity anOpportunity = Build.anOpportunity().withName('Master op').withStageName('F4 - Desarrollo de la oferta').withCloseDate(System.today()).withBigDeal(true).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withTotalCapex(null).build();
		insert aSurvey;
        
        BigDealChartsController controller = new BigDealChartsController();
		controller.BigDealOpportunity = anOpportunity;
        
        System.assertEquals(false, controller.SurveyIsComplete);
    }
}