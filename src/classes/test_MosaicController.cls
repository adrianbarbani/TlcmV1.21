@isTest
private class test_MosaicController {


    static testMethod void myUnitTest() {
      
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.industry = 'Banking';
        
        insert cuenta;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Open';
        opp.CloseDate = System.Today();
        opp.accountId = cuenta.id;
        insert opp;
                
        List<Contact> contacts = new List<Contact>();
        Map<String, Contact> contactMap = new Map<String, Contact>();
        
        List<Contact_Assessment__c> contactAssessments = new List<Contact_Assessment__c>();
        Map<String, Contact_Assessment__c> contactAssessmentsMap = new Map<String, Contact_Assessment__c>();

        List<String> focus = new List<String> {'Controller','End User','Sponsor','Technical'};
        List<String> attitud = new List<String> {'Developer','Burning Platform','Statu Quo','Negative'};
        List<String> influence = new List<String> {'High','Low'};
        List<String> authority = new List<String> {'High','Low'};

        for (Integer i=0;i<focus.size();i++) {
            for (Integer j=0;j<attitud.size();j++) {
                for (Integer k=0;k<influence.size();k++) {
                    for (Integer l=0;l<authority.size();l++) {                        
                        Contact c = new Contact();
                        c.LastName = focus[i]+'-'+attitud[j]+'-'+influence[k]+'-'+authority[l];
                        c.AccountId = cuenta.id;
                        c.Active__c = true;
                        contacts.add(c);
                        contactMap.put(c.LastName,c);
                    }
                }
            }   
        }

        insert contacts;

        Contact_Influence__c ci = new Contact_Influence__c();
        ci.Contact_Influenced__c = contacts.get(0).id;
        ci.Contact_Influences__c = contacts.get(1).id;
        insert ci;

        for (Integer i=0;i<focus.size();i++) {
            for (Integer j=0;j<attitud.size();j++) {
                for (Integer k=0;k<influence.size();k++) {
                    for (Integer l=0;l<authority.size();l++) {                        
                        Contact_Assessment__c contAss = new Contact_Assessment__c();
                        contAss.Contact__c = contactMap.get(focus[i]+'-'+attitud[j]+'-'+influence[k]+'-'+authority[l]).id;
                        contAss.Opportunity__c = opp.id;
                        
                        contAss.Focus__c = focus[i];
                        contAss.Attitudes__c = attitud[j];
                        contAss.Influence__c = influence[k];
                        contAss.Authority__c = authority[l];
                        
                        contAss.Buying_Cycle__c = 'Assessments of Alternatives';
                        contAss.Our_Relationship__c = 'Positive';
                        contAss.Competing_Company_Relationship__c = 'Positive';
                        contactAssessments.add(contAss);
                        contactAssessmentsMap.put(focus[i]+'-'+attitud[j]+'-'+influence[k]+'-'+authority[l],contAss);
                    }
                }
            }   
        }

        insert contactAssessments;        
        List<Contact_Assessment__c> caResultsList = [select id, Focus__c, Attitudes__c, Influence__c, Authority__c from Contact_Assessment__c]; 
        system.assertEquals(64,caResultsList.size());        


        System.currentPagereference().getParameters().put('id',opp.id);
        MosaicController t = new MosaicController();

        system.debug(t.getAll());

        Contact_Assessment__c caResult;
        String s;

		system.assertEquals(1,t.getEndUserNegativeNegativeInfluencePositiveAuthority().size());
        caResult = t.getEndUserNegativeNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

        system.assertEquals(1,t.getEndUserNegativeNegativeInfluenceNegativeAuthority().size());
        caResult = t.getEndUserNegativeNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
                
    	system.assertEquals(1,t.getEndUserBurningPlatformNegativeInfluencePositiveAuthority().size());
        caResult = t.getEndUserBurningPlatformNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
        
    	system.assertEquals(1,t.getEndUserBurningPlatformNegativeInfluenceNegativeAuthority().size());
        caResult = t.getEndUserBurningPlatformNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
    
    	system.assertEquals(1,t.getEndUserNegativePositiveInfluencePositiveAuthority().size());
        caResult = t.getEndUserNegativePositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserNegativePositiveInfluenceNegativeAuthority().size());
        caResult = t.getEndUserNegativePositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserBurningPlatformPositiveInfluencePositiveAuthority().size());
        caResult = t.getEndUserBurningPlatformPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserBurningPlatformPositiveInfluenceNegativeAuthority().size());
        caResult = t.getEndUserBurningPlatformPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserDeveloperNegativeInfluencePositiveAuthority().size());
        caResult = t.getEndUserDeveloperNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
    
    	system.assertEquals(1,t.getEndUserDeveloperNegativeInfluenceNegativeAuthority().size());
        caResult = t.getEndUserDeveloperNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
      
    	system.assertEquals(1,t.getEndUserStatuQuoNegativeInfluencePositiveAuthority().size());
        caResult = t.getEndUserStatuQuoNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
    
    	system.assertEquals(1,t.getEndUserStatuQuoNegativeInfluenceNegativeAuthority().size());
        caResult = t.getEndUserStatuQuoNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserDeveloperPositiveInfluencePositiveAuthority().size());
        caResult = t.getEndUserDeveloperPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserDeveloperPositiveInfluenceNegativeAuthority().size());
        caResult = t.getEndUserDeveloperPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserStatuQuoPositiveInfluencePositiveAuthority().size());
        caResult = t.getEndUserStatuQuoPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getEndUserStatuQuoPositiveInfluenceNegativeAuthority().size());
        caResult = t.getEndUserStatuQuoPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
   // Technical
   
     	system.assertEquals(1,t.getTechnicalNegativeNegativeInfluencePositiveAuthority().size());
        caResult = t.getTechnicalNegativeNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

    	system.assertEquals(1,t.getTechnicalNegativeNegativeInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalNegativeNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalBurningPlatformNegativeInfluencePositiveAuthority().size());
        caResult = t.getTechnicalBurningPlatformNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalBurningPlatformNegativeInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalBurningPlatformNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalNegativePositiveInfluencePositiveAuthority().size());
        caResult = t.getTechnicalNegativePositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalNegativePositiveInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalNegativePositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalBurningPlatformPositiveInfluencePositiveAuthority().size());
        caResult = t.getTechnicalBurningPlatformPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalBurningPlatformPositiveInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalBurningPlatformPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalDeveloperNegativeInfluencePositiveAuthority().size());
        caResult = t.getTechnicalDeveloperNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalDeveloperNegativeInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalDeveloperNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalStatuQuoNegativeInfluencePositiveAuthority().size());
        caResult = t.getTechnicalStatuQuoNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalStatuQuoNegativeInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalStatuQuoNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalDeveloperPositiveInfluencePositiveAuthority().size());
        caResult = t.getTechnicalDeveloperPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalDeveloperPositiveInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalDeveloperPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalStatuQuoPositiveInfluencePositiveAuthority().size());
        caResult = t.getTechnicalStatuQuoPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getTechnicalStatuQuoPositiveInfluenceNegativeAuthority().size());
        caResult = t.getTechnicalStatuQuoPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
  // Controller
   
     	system.assertEquals(1,t.getControllerNegativeNegativeInfluencePositiveAuthority().size());
        caResult = t.getControllerNegativeNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
     	system.assertEquals(1,t.getControllerNegativeNegativeInfluenceNegativeAuthority().size());
        caResult = t.getControllerNegativeNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerBurningPlatformNegativeInfluencePositiveAuthority().size());
        caResult = t.getControllerBurningPlatformNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerBurningPlatformNegativeInfluenceNegativeAuthority().size());
        caResult = t.getControllerBurningPlatformNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerNegativePositiveInfluencePositiveAuthority().size());
        caResult = t.getControllerNegativePositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerNegativePositiveInfluenceNegativeAuthority().size());
        caResult = t.getControllerNegativePositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerBurningPlatformPositiveInfluencePositiveAuthority().size());
        caResult = t.getControllerBurningPlatformPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerBurningPlatformPositiveInfluenceNegativeAuthority().size());
        caResult = t.getControllerBurningPlatformPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerDeveloperNegativeInfluencePositiveAuthority().size());
        caResult = t.getControllerDeveloperNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerDeveloperNegativeInfluenceNegativeAuthority().size());
        caResult = t.getControllerDeveloperNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerStatuQuoNegativeInfluencePositiveAuthority().size());
        caResult = t.getControllerStatuQuoNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerStatuQuoNegativeInfluenceNegativeAuthority().size());
        caResult = t.getControllerStatuQuoNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerDeveloperPositiveInfluencePositiveAuthority().size());
        caResult = t.getControllerDeveloperPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerDeveloperPositiveInfluenceNegativeAuthority().size());
        caResult = t.getControllerDeveloperPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerStatuQuoPositiveInfluencePositiveAuthority().size());
        caResult = t.getControllerStatuQuoPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getControllerStatuQuoPositiveInfluenceNegativeAuthority().size());
        caResult = t.getControllerStatuQuoPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
   // Sponsor
   
     	system.assertEquals(1,t.getSponsorNegativeNegativeInfluencePositiveAuthority().size());
        caResult = t.getSponsorNegativeNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getSponsorNegativeNegativeInfluenceNegativeAuthority().size());
        caResult = t.getSponsorNegativeNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getSponsorBurningPlatformNegativeInfluencePositiveAuthority().size());
        caResult = t.getSponsorBurningPlatformNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getSponsorBurningPlatformNegativeInfluenceNegativeAuthority().size());
        caResult = t.getSponsorBurningPlatformNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getSponsorNegativePositiveInfluencePositiveAuthority().size());
        caResult = t.getSponsorNegativePositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
    	system.assertEquals(1,t.getSponsorNegativePositiveInfluenceNegativeAuthority().size());
        caResult = t.getSponsorNegativePositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
  
        system.assertEquals(1,t.getSponsorBurningPlatformPositiveInfluencePositiveAuthority().size());
        caResult = t.getSponsorBurningPlatformPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

        system.assertEquals(1,t.getSponsorBurningPlatformPositiveInfluenceNegativeAuthority().size());
        caResult = t.getSponsorBurningPlatformPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorDeveloperNegativeInfluencePositiveAuthority().size());
        caResult = t.getSponsorDeveloperNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorDeveloperNegativeInfluenceNegativeAuthority().size());
        caResult = t.getSponsorDeveloperNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorStatuQuoNegativeInfluencePositiveAuthority().size());
        caResult = t.getSponsorStatuQuoNegativeInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorStatuQuoNegativeInfluenceNegativeAuthority().size());
        caResult = t.getSponsorStatuQuoNegativeInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorDeveloperPositiveInfluencePositiveAuthority().size());
        caResult = t.getSponsorDeveloperPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorDeveloperPositiveInfluenceNegativeAuthority().size());
        caResult = t.getSponsorDeveloperPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorStatuQuoPositiveInfluencePositiveAuthority().size());
        caResult = t.getSponsorStatuQuoPositiveInfluencePositiveAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);

  		system.assertEquals(1,t.getSponsorStatuQuoPositiveInfluenceNegativeAuthority().size());
        caResult = t.getSponsorStatuQuoPositiveInfluenceNegativeAuthority().get(0).getContactEval();
        s = caResult.Focus__c + '-' + caResult.Attitudes__c + '-' + caResult.Influence__c + '-' + caResult.Authority__c;
        system.assertEquals(contactAssessmentsMap.get(s).id,caResult.id);
        
        System.currentPagereference().getParameters().put('id',cuenta.id);               
    	MosaicController ptest = new MosaicController();	            
    }
}