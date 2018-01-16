public with sharing class MosaicController {

    private List<ExtendedEvaluation> all;
    
    public Opportunity opportunity {get;set;}    
    public Id accountId {get;set;}

	public Id objectId {get;set;}
	public String objectAPIName {get;set;}

	public MosaicController(){
    	
    	objectId = (Id) ApexPages.currentPage().getParameters().get('Id');
    	objectAPIName = objectId.getSObjectType().getDescribe().getName();
    	
        all = new List<ExtendedEvaluation>();
    	List<Contact_Assessment__c> ret;
    	
    	if (objectAPIName == 'Opportunity') {
    	    if(Schema.sObjectType.Opportunity.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.name.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.accountId.isAccessible()
    	    && Schema.sObjectType.Account.fields.parentId.isAccessible()
    	    && Schema.sObjectType.Account.fields.Name.isAccessible()
    	    && Schema.sObjectType.Opportunity.fields.Description.isAccessible())
        	opportunity = [SELECT name, id, accountId, Account.parentId, Account.Name, Description FROM Opportunity WHERE Id = :objectId];
        	accountId = opportunity.AccountId; 
        	
        	if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
        	&& Schema.sObjectType.contact.fields.name.isAccessible()
        	&& Schema.sObjectType.contact.fields.title.isAccessible()
        	&& Schema.sObjectType.contact.fields.FirstName.isAccessible()
        	&& Schema.sObjectType.contact.fields.LastName.isAccessible()
        	&& Schema.sObjectType.contact.fields.Closest_Account_Team_Member__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Opportunity__c.isAccessible()
        	&& Schema.sObjectType.Opportunity.fields.Buying_Cycle__c.isAccessible())
        	ret = [SELECT  Id, Contact__c, Contact__r.name,Contact__r.title, Contact__r.Account.name, 
        	        Contact__r.FirstName, Contact__r.LastName, Contact__r.Closest_Account_Team_Member__r.name,
        	        Focus__c , Attitudes__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c , 
        	        Generation__c, Authority__c, Influence__c, Opportunity__c, Opportunity__r.Buying_Cycle__c 
        	        FROM Contact_Assessment__c
            	    WHERE Opportunity__c = :objectId and Contact__r.active__c = true];
    	} else if (objectAPIName == 'Account') {
    	    
        	if(Schema.sObjectType.Contact_Assessment__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Contact__c.isAccessible()
        	&& Schema.sObjectType.contact.fields.name.isAccessible()
        	&& Schema.sObjectType.contact.fields.title.isAccessible()
        	&& Schema.sObjectType.contact.fields.FirstName.isAccessible()
        	&& Schema.sObjectType.contact.fields.LastName.isAccessible()
        	&& Schema.sObjectType.contact.fields.Closest_Account_Team_Member__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Focus__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Attitudes__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Our_Relationship__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Competing_Company_Relationship__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Buying_Cycle__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Generation__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Authority__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Influence__c.isAccessible()
        	&& Schema.sObjectType.Contact_Assessment__c.fields.Opportunity__c.isAccessible()
        	&& Schema.sObjectType.Opportunity.fields.Buying_Cycle__c.isAccessible())
    		ret = [SELECT  Id, Contact__c, Contact__r.name,Contact__r.title, Contact__r.Account.name, Contact__r.FirstName, Contact__r.LastName, Contact__r.Closest_Account_Team_Member__r.name, Focus__c , Attitudes__c, Our_Relationship__c, Competing_Company_Relationship__c, Buying_Cycle__c , Generation__c, Authority__c, Influence__c, Opportunity__c, Opportunity__r.Buying_Cycle__c FROM Contact_Assessment__c
            	WHERE Account__c = :objectId and Contact__r.active__c = true];
    	}
						     	
        List<Id> contactAssassmentIds = new List<Id>(); 
        for (Contact_Assessment__c c : ret){
            contactAssassmentIds.add(c.Contact__c);
        }
     
        List<Id> requiredContactsIds = new List<Id>();

        Map<Id,List<Id>> mapContactInfluecedIds = new Map<Id,List<Id>>(); 
        Map<Id,List<Id>> mapContactInfluecesIds = new Map<Id,List<Id>>();
                
        if(Schema.sObjectType.Contact_Influence__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){        
        for(Contact_Influence__c ci: [ SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c 
                                      WHERE Contact_Influenced__c in :contactAssassmentIds]){
            requiredContactsIds.add(ci.Contact_Influenced__c);
            if (mapContactInfluecedIds.get(ci.Contact_Influences__c) == null) {
                mapContactInfluecedIds.put(ci.Contact_Influences__c, new List<Id>());               
            }
            mapContactInfluecedIds.get(ci.Contact_Influences__c).add(ci.Contact_Influenced__c);     
            
        }
        }
        
                if(Schema.sObjectType.Contact_Influence__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influenced__c.isAccessible()
        && Schema.sObjectType.Contact_Influence__c.fields.Contact_Influences__c.isAccessible()){ 
        for(Contact_Influence__c ci: [ SELECT Contact_Influenced__c, Contact_Influences__c FROM Contact_Influence__c 
                                      WHERE Contact_Influences__c in :contactAssassmentIds]){
            requiredContactsIds.add(ci.Contact_Influences__c);
            if (mapContactInfluecesIds.get(ci.Contact_Influenced__c) == null) {
                mapContactInfluecesIds.put(ci.Contact_Influenced__c, new List<Id>());               
            }
            mapContactInfluecesIds.get(ci.Contact_Influenced__c).add(ci.Contact_Influences__c);     
                                                        
        }
        }
        
        Map<Id,Contact> RequiredContactsMap = new Map<Id,Contact>(); 
        
        if(Schema.sObjectType.Contact.isAccessible()
        && Schema.sObjectType.Contact.fields.name.isAccessible())
        RequiredContactsMap = new Map<Id,Contact>([SELECT Id, Name FROM Contact WHERE Id in :requiredContactsIds]);
                                      
        Map<Id,List<Contact>> contactsInfluencedMap = new Map<Id,List<Contact>>();
        for (Id id : mapContactInfluecedIds.keySet()) {
            List<Contact> contactsInfluenced = new List<Contact>();
            for (Id influencedId : mapContactInfluecedIds.get(id)) {
                contactsInfluenced.add(requiredContactsMap.get(influencedId));
            }
            contactsInfluencedMap.put(id, contactsInfluenced);
        }

        Map<Id,List<Contact>> contactsInfluencesMap = new Map<Id,List<Contact>>();
        for (Id id : mapContactInfluecesIds.keySet()) {
            List<Contact> contactsInfluences = new List<Contact>();
            for (Id influencesId : mapContactInfluecesIds.get(id)) {
                contactsInfluences.add(requiredContactsMap.get(influencesId));
            }
            contactsInfluencesMap.put(id, contactsInfluences);
        }
        
        List<Acciones__c> AllActions = new List<Acciones__c>();
        
        if(Schema.sObjectType.Acciones__c.isAccessible()
        && Schema.sObjectType.Acciones__c.fields.Descripcion__c.isAccessible()
        && Schema.sObjectType.Acciones__c.fields.Accion__c.isAccessible()
        && Schema.sObjectType.Acciones__c.fields.Tipo__c.isAccessible())
        AllActions = [SELECT Descripcion__c, Accion__c, Tipo__c  FROM Acciones__c limit 10000];
       
        for (Contact_Assessment__c c : ret){
            all.add(new ExtendedEvaluation(c,AllActions,contactsInfluencedMap.get(c.Contact__c), contactsInfluencesMap.get(c.Contact__c)));
        }
       
    }

    public List<ExtendedEvaluation> getAll() {
        return all;
    }
   
    
    private List<ExtendedEvaluation> getSOQLQuery(String Focus, String Attitude, String Influence, String Authority){
    
        //I use this query to unify in a single method the access to the object structure. This way if I need to change something I dont have to do it 64 times.
        //This is because Salesforce doesn't give me the posibility to call get methods with parameters (or at least I haven't found a way yet [7/3/12])
        
        if(Influence == 'Positive')
            Influence = 'High';
        else
            Influence = 'Low';
            
        if(Authority == 'Positive')
            Authority = 'High';
        else
            Authority = 'Low';
        
        List<ExtendedEvaluation> temp = new List<ExtendedEvaluation>();
        
        for(ExtendedEvaluation ee : this.all){
        
            if( (ee.getContactEval().Focus__c == Focus ) && (ee.getContactEval().Attitudes__c == Attitude ) && (ee.getContactEval().Influence__c == Influence) && (ee.getContactEval().Authority__c == Authority) ){
        
               temp.add(ee);
            }
        }

        return temp;
    
    }

    public List<ExtendedEvaluation> getEndUserNegativeNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Negative','Negative','Positive');
    }


    public List<ExtendedEvaluation> getEndUserNegativeNegativeInfluenceNegativeAuthority() {
    
        return getSOQLQuery('End User','Negative','Negative','Negative');
 
    }


    public List<ExtendedEvaluation> getEndUserBurningPlatformNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Burning Platform','Negative','Positive');
    }


    public List<ExtendedEvaluation> getEndUserBurningPlatformNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Burning Platform','Negative','Negative');
    }


    public List<ExtendedEvaluation> getEndUserNegativePositiveInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Negative','Positive','Positive');
    }


    public List<ExtendedEvaluation> getEndUserNegativePositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Negative','Positive','Negative');
    }


    public List<ExtendedEvaluation> getEndUserBurningPlatformPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Burning Platform','Positive','Positive');
    }


    public List<ExtendedEvaluation> getEndUserBurningPlatformPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Burning Platform','Positive','Negative');
    }


    public List<ExtendedEvaluation> getEndUserDeveloperNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Developer','Negative','Positive');
    }


    public List<ExtendedEvaluation> getEndUserDeveloperNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Developer','Negative','Negative');
    }


    public List<ExtendedEvaluation> getEndUserStatuQuoNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Statu Quo','Negative','Positive');
    }


    public List<ExtendedEvaluation> getEndUserStatuQuoNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Statu Quo','Negative','Negative');
    }


    public List<ExtendedEvaluation> getEndUserDeveloperPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Developer','Positive','Positive');
    }


    public List<ExtendedEvaluation> getEndUserDeveloperPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Developer','Positive','Negative');
    }


    public List<ExtendedEvaluation> getEndUserStatuQuoPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('End User','Statu Quo','Positive','Positive');
    }


    public List<ExtendedEvaluation> getEndUserStatuQuoPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('End User','Statu Quo','Positive','Negative');
    }

 // Technical
 
     public List<ExtendedEvaluation> getTechnicalNegativeNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Negative','Negative','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalNegativeNegativeInfluenceNegativeAuthority() {
    
        return getSOQLQuery('Technical','Negative','Negative','Negative');
 
    }


    public List<ExtendedEvaluation> getTechnicalBurningPlatformNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Burning Platform','Negative','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalBurningPlatformNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Burning Platform','Negative','Negative');
    }


    public List<ExtendedEvaluation> getTechnicalNegativePositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Negative','Positive','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalNegativePositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Negative','Positive','Negative');
    }


    public List<ExtendedEvaluation> getTechnicalBurningPlatformPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Burning Platform','Positive','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalBurningPlatformPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Burning Platform','Positive','Negative');
    }


    public List<ExtendedEvaluation> getTechnicalDeveloperNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Developer','Negative','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalDeveloperNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Developer','Negative','Negative');
    }


    public List<ExtendedEvaluation> getTechnicalStatuQuoNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Statu Quo','Negative','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalStatuQuoNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Statu Quo','Negative','Negative');
    }


    public List<ExtendedEvaluation> getTechnicalDeveloperPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Developer','Positive','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalDeveloperPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Developer','Positive','Negative');
    }


    public List<ExtendedEvaluation> getTechnicalStatuQuoPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Technical','Statu Quo','Positive','Positive');
    }


    public List<ExtendedEvaluation> getTechnicalStatuQuoPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Technical','Statu Quo','Positive','Negative');
    }


// Controller
 
     public List<ExtendedEvaluation> getControllerNegativeNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Negative','Negative','Positive');
    }


    public List<ExtendedEvaluation> getControllerNegativeNegativeInfluenceNegativeAuthority() {
    
        return getSOQLQuery('Controller','Negative','Negative','Negative');
 
    }


    public List<ExtendedEvaluation> getControllerBurningPlatformNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Burning Platform','Negative','Positive');
    }


    public List<ExtendedEvaluation> getControllerBurningPlatformNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Burning Platform','Negative','Negative');
    }


    public List<ExtendedEvaluation> getControllerNegativePositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Negative','Positive','Positive');
    }


    public List<ExtendedEvaluation> getControllerNegativePositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Negative','Positive','Negative');
    }


    public List<ExtendedEvaluation> getControllerBurningPlatformPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Burning Platform','Positive','Positive');
    }


    public List<ExtendedEvaluation> getControllerBurningPlatformPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Burning Platform','Positive','Negative');
    }


    public List<ExtendedEvaluation> getControllerDeveloperNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Developer','Negative','Positive');
    }


    public List<ExtendedEvaluation> getControllerDeveloperNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Developer','Negative','Negative');
    }


    public List<ExtendedEvaluation> getControllerStatuQuoNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Statu Quo','Negative','Positive');
    }


    public List<ExtendedEvaluation> getControllerStatuQuoNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Statu Quo','Negative','Negative');
    }


    public List<ExtendedEvaluation> getControllerDeveloperPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Developer','Positive','Positive');
    }


    public List<ExtendedEvaluation> getControllerDeveloperPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Developer','Positive','Negative');
    }


    public List<ExtendedEvaluation> getControllerStatuQuoPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Controller','Statu Quo','Positive','Positive');
    }


    public List<ExtendedEvaluation> getControllerStatuQuoPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Controller','Statu Quo','Positive','Negative');
    }

 // Sponsor
 
     public List<ExtendedEvaluation> getSponsorNegativeNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Negative','Negative','Positive');
    }


    public List<ExtendedEvaluation> getSponsorNegativeNegativeInfluenceNegativeAuthority() {
    
        return getSOQLQuery('Sponsor','Negative','Negative','Negative');
 
    }


    public List<ExtendedEvaluation> getSponsorBurningPlatformNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Burning Platform','Negative','Positive');
    }


    public List<ExtendedEvaluation> getSponsorBurningPlatformNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Burning Platform','Negative','Negative');
    }


    public List<ExtendedEvaluation> getSponsorNegativePositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Negative','Positive','Positive');
    }


    public List<ExtendedEvaluation> getSponsorNegativePositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Negative','Positive','Negative');
    }


    public List<ExtendedEvaluation> getSponsorBurningPlatformPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Burning Platform','Positive','Positive');
    }


    public List<ExtendedEvaluation> getSponsorBurningPlatformPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Burning Platform','Positive','Negative');
    }


    public List<ExtendedEvaluation> getSponsorDeveloperNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Developer','Negative','Positive');
    }


    public List<ExtendedEvaluation> getSponsorDeveloperNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Developer','Negative','Negative');
    }


    public List<ExtendedEvaluation> getSponsorStatuQuoNegativeInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Statu Quo','Negative','Positive');
    }


    public List<ExtendedEvaluation> getSponsorStatuQuoNegativeInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Statu Quo','Negative','Negative');
    }


    public List<ExtendedEvaluation> getSponsorDeveloperPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Developer','Positive','Positive');
    }


    public List<ExtendedEvaluation> getSponsorDeveloperPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Developer','Positive','Negative');
    }


    public List<ExtendedEvaluation> getSponsorStatuQuoPositiveInfluencePositiveAuthority() {
        return getSOQLQuery('Sponsor','Statu Quo','Positive','Positive');
    }


    public List<ExtendedEvaluation> getSponsorStatuQuoPositiveInfluenceNegativeAuthority() {
        return getSOQLQuery('Sponsor','Statu Quo','Positive','Negative');
    }


}