global with sharing class InfoSCPForAccountBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	global Map<Id,Account_Data__c> accountDataMap; 

	global InfoSCPForAccountBatch() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		accountDataMap = new Map<Id,Account_Data__c>();				
		
        List <Account> accounts = new List<Account>();
        
        if(Util.checkMultiCurrencyEnabled() ){
            if(Schema.sObjectType.account.isAccessible()
            && Schema.sObjectType.Strategic_Initiative__c.fields.lastModifiedDate.isAccessible()
            && Schema.sObjectType.Potential_New_Business__c.isAccessible()
            && Schema.sObjectType.Potential_New_Business__c.fields.Estimated_FCV__c.isAccessible()
            && Schema.sObjectType.Strategic_Initiative__c.isAccessible()
            && Schema.sObjectType.Account_Competitor__c.fields.lastModifiedDate.isAccessible()
            && Schema.sObjectType.Account_Competitor__c.isAccessible()
            && Schema.sObjectType.PastActivity__c.isAccessible()
            && Schema.sObjectType.Account_Review__c.isAccessible())
            accounts = [select id,
                        (select id, lastModifiedDate from StrategicInitiatives__r order by lastModifiedDate desc),
                        (select id, convertCurrency(Estimated_FCV__c) from GAP_Potential_New_Business__r),
                        (select id, lastModifiedDate from Account_Competitors__r order by lastModifiedDate desc),
                        (select id from Past_Activitys__r order by year__c desc Limit 1),
                        (select id from Accounts_Reviews__r order by lastModifiedDate desc Limit 1)
                        from account];
        }
        else{
                        if(Schema.sObjectType.account.isAccessible()
            && Schema.sObjectType.Strategic_Initiative__c.fields.lastModifiedDate.isAccessible()
            && Schema.sObjectType.Potential_New_Business__c.isAccessible()
            && Schema.sObjectType.Potential_New_Business__c.fields.Estimated_FCV__c.isAccessible()
            && Schema.sObjectType.Strategic_Initiative__c.isAccessible()
            && Schema.sObjectType.Account_Competitor__c.fields.lastModifiedDate.isAccessible()
            && Schema.sObjectType.Account_Competitor__c.isAccessible()
            && Schema.sObjectType.PastActivity__c.isAccessible()
            && Schema.sObjectType.Account_Review__c.isAccessible())
            accounts = [select id,
                        (select id, lastModifiedDate from StrategicInitiatives__r order by lastModifiedDate desc),
                        (select id, Estimated_FCV__c from GAP_Potential_New_Business__r),
                        (select id, lastModifiedDate from Account_Competitors__r order by lastModifiedDate desc),
                        (select id from Past_Activitys__r order by year__c desc Limit 1),
                        (select id from Accounts_Reviews__r order by lastModifiedDate desc Limit 1)
                        from account];
        }
        
        List<Account_Data__c> aBorrar = new List<Account_Data__c>();
         if(Schema.sObjectType.Account_Data__c.isAccessible())
        aBorrar = [select id from Account_Data__c limit 900];
        
        if(Account_Data__c.sObjectType.getDescribe().isDeletable()){
            delete aBorrar;
        }
        
       	For (Account a : accounts) {

			Account_Data__c accountData = new Account_Data__c();
			accountData.account__c = a.id;
			accountData.competitors_Number__c = a.account_Competitors__r.size();
			if (!a.account_Competitors__r.isEmpty()) {
				accountData.competitors_Last_update__c = a.account_Competitors__r.get(0).lastModifiedDate;
			}
			if (!a.Past_Activitys__r.isEmpty()) {
				accountData.SCP_past_Activity__c = a.Past_Activitys__r.get(0).id;
			}
			accountData.pnb_Amount__c = 0;
			for (Potential_New_Business__c pnb :a.GAP_Potential_New_Business__r) {
				if (pnb.Estimated_FCV__c != null) {
				    accountData.pnb_Amount__c += pnb.Estimated_FCV__c;
				}
			}

			accountData.strategic_Initiative_Number__c = a.StrategicInitiatives__r.size();
			if (!a.StrategicInitiatives__r.isEmpty()) {
				accountData.Strategic_Initiative_Last_Update__c = a.StrategicInitiatives__r.get(0).lastModifiedDate;
			}
			accountData.opportunities_With_RDM__c = 0;
			accountData.opportunities_With_VD__c = 0;
                                    
			if (!a.Accounts_Reviews__r.isEmpty()) {
				accountData.Account_Review__c = a.Accounts_Reviews__r.get(0).id;
			}
			
      		if(util.checkMultiCurrencyEnabled()){
                   accountData.CurrencyIsoCode__c = Util.getCompanyIsoCode();
                
            } else {
              accountData.CurrencyIsoCode__c = '$';  
            }
                                    
			accountDataMap.put(a.id,accountData);
			
		}
		String query = '';
		
		if(Schema.sObjectType.Opportunity.isAccessible()
            && Schema.sObjectType.Opportunity.fields.accountId.isAccessible()
            && Schema.sObjectType.Industry_Trend__c.isAccessible()
            && Schema.sObjectType.OpportunityPastProvenValueNew__c.isAccessible()
            && Schema.sObjectType.Strategic_Initiative__c.isAccessible()
            && Schema.sObjectType.Account_Competitor__c.fields.lastModifiedDate.isAccessible()
            && Schema.sObjectType.Contact_Assessment__c.isAccessible()){
		
		query = 'select id, accountId, ' +
						'(select id from IndustryTrends__r), ' +
						'(select id from OpportunityPastProvenValueNew__r), ' +
						'(select id from StrategicInitiatives__r), ' +
						'(select id from ContactsAssessments__r) ' +
						'from Opportunity';	
            }
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		for(Sobject s : scope) {
			Opportunity opp = (Opportunity)s;

			Account_Data__c accountData = accountDataMap.get(opp.accountId);
			if (!opp.IndustryTrends__r.isEmpty() || !opp.OpportunityPastProvenValueNew__r.isEmpty() || !opp.StrategicInitiatives__r.isEmpty()) {
				accountData.opportunities_With_VD__c++;
			}
			if (!opp.ContactsAssessments__r.isEmpty()) {
				accountData.opportunities_With_RDM__c++;
			}
		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
		if(Schema.sObjectType.Account_Data__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.account__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.competitors_Number__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.competitors_Last_update__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.SCP_past_Activity__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.pnb_Amount__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.Strategic_Initiative_Last_Update__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.opportunities_With_RDM__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.opportunities_With_VD__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.Account_Review__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.fields.CurrencyIsoCode__c.isCreateable()
		&& Schema.sObjectType.Account_Data__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.account__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.competitors_Number__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.competitors_Last_update__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.SCP_past_Activity__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.pnb_Amount__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.Strategic_Initiative_Last_Update__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.opportunities_With_RDM__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.opportunities_With_VD__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.Account_Review__c.isUpdateable()
		&& Schema.sObjectType.Account_Data__c.fields.CurrencyIsoCode__c.isUpdateable())
		upsert accountDataMap.values();
	}
	
}