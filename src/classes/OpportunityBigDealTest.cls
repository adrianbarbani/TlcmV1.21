@isTest
public class OpportunityBigDealTest {
	public static testMethod void initiallyTheBigDealOpportunityAndAccountShouldBeLoaded() {
		Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal')); 
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		

		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
		
		System.assertEquals(anOpportunity.Id, controller.BigDealOpportunity.Id);
		System.assertEquals(anAccount.Id , controller.BigDealAccount.id); 
	}
	
	public static testMethod void initiallyASurveyObjectShouldBecreated() {
		Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal')); 
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
		
		System.assertNotEquals(null, controller.Survey);
	}
	
	public static testMethod void anOpportunityThatHasAlreadyHadItsBigDealSurveyFilledShouldHaveItLoaded() {
		Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Big_deals_Survey__c aSurvey = Build.aBigDealSurvey().withOpportunityId(anOpportunity.Id).build();
		insert aSurvey;
		
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal')); 
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
		
		System.assertEquals(aSurvey.Id, controller.Survey.Id);
	}
    
    public static testMethod void itShouldBePossibleToSaveTheSurvey() {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal')); 
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
		controller.save();
		System.assertNotEquals(null, controller.Survey.Id);
    }
	
    public static testMethod void ifThereIsTheNeedToHirePeopleAndTheAmountIsNotSpecified_TheSurveyShouldntBeSaved() {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal'));
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
        Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withNeedToAcquireResources(true).withAmountOfResourcesToIncorporate('').build();
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        
        controller.save();
        System.assertEquals(0, [SELECT id FROM Big_deals_Survey__c WHERE Oportunidad__c = :anOpportunity.Id].size());
        System.assert(ApexPages.hasMessages());
    }
    
    public static testMethod void ifTheSLAsAreDefined_TheSLAsShouldBeDetailedToBeAbleToSaveTheSurvey() {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal'));
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
        Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withSLADefined(true).withSLADetail('').build();
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        
        controller.save();
        System.assertEquals(0, [SELECT id FROM Big_deals_Survey__c WHERE Oportunidad__c = :anOpportunity.Id].size());
        System.assert(ApexPages.hasMessages());
    }
    
    public static testMethod void whenTheUserIsABigDealAdmin_TheQualificationFieldsShouldBeVisible() {
		Profile p = [SELECT Id FROM Profile WHERE Name='Custom: Marketing Profile']; 
        User aBigDealAdmin = new User(Alias = 'bgadmin', Email='bgadmin@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='bgadmin@testorg.com');
        User aStandardUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='bigDealstandarduser@testorg.com');
        insert new List<User> {aBigDealAdmin, aStandardUser};
        PermissionSet permissionSet = [Select id, Name from PermissionSet where name = 'Big_Deal_Admin'];
        PermissionSetAssignment permissionAssignment = new PermissionSetAssignment(PermissionSetId = permissionSet.id, AssigneeId = aBigDealAdmin.id); 
        insert permissionAssignment;
    	
        system.runAs(aStandardUser) {
            Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
    		insert anAccount;
    		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
    											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
    		insert anOpportunity;
            
            Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal'));
		    System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		    
            Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withSLADefined(true).build();
            OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
            system.assertEquals(false, controller.isBigDealAdmin);
        }
        
        system.runAs(aBigDealAdmin) {
            Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
            anAccount.cuit__c = 000;
    		insert anAccount;
    		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
    											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
    		insert anOpportunity;
            
            Test.setCurrentPageReference(new PageReference('Page.Certa_SCP.OpportunityBigDeal'));
		    System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		    
            Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withSLADefined(true).build();
            OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
            system.assertEquals(true, controller.isBigDealAdmin);
        }
    } 
    
    public static testMethod void ifReachIsDefinedAndTheDeliverablesNotSpecified_TheSurveyShouldntBeSaved () {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal'));
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
        Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withDefinedReach(true).withDeliverablesDescription('').build();
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        
        controller.save();
        
        System.assertEquals(0, [SELECT id FROM Big_deals_Survey__c WHERE Oportunidad__c = :anOpportunity.Id].size());
        System.assert(ApexPages.hasMessages());
    }
    
    public static testMethod void ifReachIsDefinedAndTheDeliberablesAreSpecified_TheSurveyShouldBeSaved () {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal'));
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
        Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withDefinedReach(true).withDeliverablesDescription('some description').build();
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        controller.save();
        
        System.assertEquals(1, [SELECT id FROM Big_deals_Survey__c WHERE Oportunidad__c = :anOpportunity.Id].size());
    }
    
    public static testMethod void ifThereExistsADescriptionOfTheTechnicalSolution_TheSurveyShouldntBeSavedWithoutIt() {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.OpportunityBigDeal'));
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
        Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withTechnicalDescriptionExistence(true).withTechnicalArchitectureDraft('').build();
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        
        controller.save();
        System.assertEquals(0, [SELECT id FROM Big_deals_Survey__c WHERE Oportunidad__c = :anOpportunity.Id].size());
        System.assert(ApexPages.hasMessages());
    }
    
    public static testMethod void ifThereExistsADescriptionOfTheTechnicalSolutionAndIsSpecified_TheSurveyShouldBeSaved () {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
		insert anAccount;
		Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
											.withAccountId(anAccount.id).withCloseDate(System.today()).build();
		insert anOpportunity;
		Test.setCurrentPageReference(new PageReference('Page.Certa_SCP.OpportunityBigDeal'));
		System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
		
        Big_deals_Survey__c aSurvey = Build.aFullBigDealSurvey(anOpportunity).withTechnicalDescriptionExistence(true).withTechnicalArchitectureDraft('technobable').build();
		OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        
        controller.save();
        System.assertEquals(1, [SELECT id FROM Big_deals_Survey__c WHERE Oportunidad__c = :anOpportunity.Id].size());
        System.assert(!ApexPages.hasMessages());
        
        controller.saveAndBlock();
        controller.saveAndUnblock();
    }
    
    public static testMethod void checkAllObligatoriFieldsAreComplete () {
        Account anAccount = Build.anAccount().withName('John Pepeson inc.').Build();
        insert anAccount;
        Opportunity anOpportunity = Build.anOpportunity().withName('testy opp').withStageName('F2 - Negociación')
            .withAccountId(anAccount.id).withCloseDate(System.today()).build();
        insert anOpportunity;
        Test.setCurrentPageReference(new PageReference('Page.scp-certa-gc.OpportunityBigDeal'));
        System.currentPageReference().getParameters().put('Id', anOpportunity.Id);
        
        Big_deals_Survey__c aSurvey =  new Big_deals_Survey__c();
        OpportunityBigDealController controller = new OpportunityBigDealController(new ApexPages.StandardController(anOpportunity));
        controller.Survey = aSurvey;
        
        controller.checkAllObligatoriFieldsAreComplete();
        
        system.assert(controller.missingObligatoriField.size() > 0);
        
    }
}