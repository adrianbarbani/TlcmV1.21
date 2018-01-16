public with sharing class OpportunitySnapshotController {
	
	public Opportunity opp {get;set;}
	public List<valueArguments> valueArgumentsList {get;set;}
    public List<valueArguments> solutionsList {get;set;}
	public List<Task> taskList {get;set;}
	public String isoCode {get;set;}
	public Decimal fcv {get;set;}
	public Integer chartSum {get;set;}
	public List<PieWedgeData> pieData {get;set;}
	
	/*
	public List<OportunityIndustryTrend__c> trendList {get;set;}
	public List<OpportunityStrategicInitiative__c> strategicList {get;set;}
	public List<OpportunityPastProvenValueNew__c> pastPtovenValueList {get;set;} 
	*/
	
	public OpportunitySnapshotController(ApexPages.StandardController controller) {        
        opp = (Opportunity)controller.getRecord();
        if (Util.checkMultiCurrencyEnabled()) {
        	isoCode = UserInfo.getDefaultCurrency()+' ';
        	
        	if(Schema.sObjectType.Opportunity.isAccessible()){
        	fcv = [select convertCurrency(amount) from Opportunity where id = :opp.id limit 1].get(0).amount;
        	}
        } else {
        	isoCode = '$';
        	if(Schema.sObjectType.Opportunity.isAccessible()
        	&& Schema.sObjectType.Opportunity.fields.amount.isAccessible()){
        	fcv = fcv = [select amount from Opportunity where id = :opp.id limit 1].get(0).amount;
        	}
        }   
        init();        
    }
    
    private void init() {		
		/*
		trendList = [select Industry_Trend__c, Industry_Trend__r.Name, Industry_Trend__r.Trend__c from OportunityIndustryTrend__c where Opportunity__c = :opp.id];			
		strategicList = [select Strategic_Initiative__c, Strategic_Initiative__r.Name, Strategic_Initiative__r.Strategic_Initiative__c from OpportunityStrategicInitiative__c where Opportunity__c = :opp.id];  
		pastPtovenValueList = [select PastProvenValueNew__c, PastProvenValueNew__r.Name, PastProvenValueNew__r.Unique_Value__c from OpportunityPastProvenValueNew__c where Opportunity__c = :opp.id]; 	
    	*/
    	valueArgumentsList = new List<valueArguments>();
    	
    	if(Schema.sObjectType.OportunityIndustryTrend__c.isAccessible()
    	&& Schema.sObjectType.OportunityIndustryTrend__c.fields.Industry_Trend__c.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.Name.isAccessible()
    	&& Schema.sObjectType.Industry_Trend__c.fields.Trend__c.isAccessible()){
    	for (OportunityIndustryTrend__c trend :[select Industry_Trend__c, Industry_Trend__r.Name, Industry_Trend__r.Trend__c from OportunityIndustryTrend__c where Opportunity__c = :opp.id  and Industry_Trend__r.type__c != 'Soluciones']) {
    		valueArgumentsList.add(new valueArguments(trend.Industry_Trend__r.Name, trend.Industry_Trend__r.Trend__c, Label.Trend));
    	}
    	}
    	
    	if(Schema.sObjectType.OpportunityStrategicInitiative__c.isAccessible()
    	&& Schema.sObjectType.OpportunityStrategicInitiative__c.fields.Strategic_Initiative__c.isAccessible()
    	&& Schema.sObjectType.Strategic_Initiative__c.fields.Name.isAccessible()
    	&& Schema.sObjectType.Strategic_Initiative__c.fields.Strategic_Initiative__c.isAccessible()){
    	    
    	for (OpportunityStrategicInitiative__c strategic :[select Strategic_Initiative__c, Strategic_Initiative__r.Name, Strategic_Initiative__r.Strategic_Initiative__c from OpportunityStrategicInitiative__c where Opportunity__c = :opp.id]) {
    		valueArgumentsList.add(new valueArguments(strategic.Strategic_Initiative__r.Name, strategic.Strategic_Initiative__r.Strategic_Initiative__c, Label.Iniciativa));
    	}
    	}
    	
    	if(Schema.sObjectType.OpportunityPastProvenValueNew__c.isAccessible()
    	&& Schema.sObjectType.OpportunityPastProvenValueNew__c.fields.PastProvenValueNew__c.isAccessible()
    	&& Schema.sObjectType.PastProvenValueNew__c.fields.Name.isAccessible()
    	&& Schema.sObjectType.PastProvenValueNew__c.fields.Unique_Value__c.isAccessible()
    	&& Schema.sObjectType.PastProvenValueNew__c.fields.Type__c.isAccessible()){
    	    
    	for (OpportunityPastProvenValueNew__c ppv :[select PastProvenValueNew__c, PastProvenValueNew__r.Name, PastProvenValueNew__r.Unique_Value__c, PastProvenValueNew__r.Type__c from OpportunityPastProvenValueNew__c where Opportunity__c = :opp.id]) {
    		valueArgumentsList.add(new valueArguments(ppv.PastProvenValueNew__r.Name, ppv.PastProvenValueNew__r.Unique_Value__c, ppv.PastProvenValueNew__r.Type__c));
    	}
    	}
    	
    	
        solutionsList = new List<valueArguments>();
        if(Schema.sObjectType.OportunityIndustryTrend__c.isAccessible()
        && Schema.sObjectType.OportunityIndustryTrend__c.fields.Industry_Trend__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.title__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.type__c.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Name.isAccessible()
        && Schema.sObjectType.Industry_Trend__c.fields.Trend__c.isAccessible()){
            
        for (OportunityIndustryTrend__c trend :[select Industry_Trend__c, Industry_Trend__r.title__c, Industry_Trend__r.type__c, Industry_Trend__r.Name, Industry_Trend__r.Trend__c from OportunityIndustryTrend__c where Opportunity__c = :opp.id and Industry_Trend__r.type__c = 'Soluciones']) {
            solutionsList.add(new valueArguments(trend.Industry_Trend__r.Name, trend.Industry_Trend__r.title__c, trend.Industry_Trend__r.trend__c));
        }
        }
    	/*
    	for (OpportunityStrategicContext__c strategicCont :[select Account__c, Account__r.Id, Account__r.Strategic_Context__c from OpportunityStrategicContext__c where Opportunity__c = :opp.id]) {
    		valueArgumentsList.add(new valueArguments(strategicCont.Account__r.Id, strategicCont.Account__r.Strategic_Context__c, 'Strategic Context'));
    	}
    	*/
    	
    	if(Schema.sObjectType.Task.isAccessible()
    	&& Schema.sObjectType.Task.fields.subject.isAccessible()
    	&& Schema.sObjectType.Task.fields.Description.isAccessible()
    	&& Schema.sObjectType.Task.fields.ActivityDate.isAccessible()
    	&& Schema.sObjectType.Task.fields.Status.isAccessible()
    	&& Schema.sObjectType.Task.fields.Priority.isAccessible()
    	&& Schema.sObjectType.Task.fields.End_date__c.isAccessible()
    	&& Schema.sObjectType.Task.fields.OwnerId.isAccessible()
    	&& Schema.sObjectType.Task.fields.CreatedDate.isAccessible()
    	&& Schema.sObjectType.Task.fields.URL__C.isAccessible()){
    	    
            system.debug('entre');
    	taskList = [select subject, Description, ActivityDate, Status,Priority,End_date__c, 
    	            OwnerId, CreatedDate, Owner.Name, URL__C FROM Task WHERE WhatId = :opp.id];
    	}
    	
    	generatePieData();
    }
	
	public PageReference save() {
	    
	    if(Schema.sObjectType.Opportunity.isUpdateable())
		update opp;
		return null;		
	}
	
	public PageReference saveTask() {
        
        if(Schema.sObjectType.Task.isUpdateable()
           && Schema.sObjectType.Task.fields.subject.isUpdateable()
           && Schema.sObjectType.Task.fields.Description.isUpdateable()
           && Schema.sObjectType.Task.fields.ActivityDate.isUpdateable()
           && Schema.sObjectType.Task.fields.Status.isUpdateable()
           && Schema.sObjectType.Task.fields.Priority.isUpdateable()
           && Schema.sObjectType.Task.fields.End_date__c.isUpdateable()
           && Schema.sObjectType.Task.fields.OwnerId.isUpdateable()
           && Schema.sObjectType.Task.fields.URL__C.isUpdateable()){
               system.debug('entre');
               update taskList;
           }
        
		return null;		
	}
	
	class valueArguments {
		
		public String id {get;set;}
		public String argument {get;set;}
		public String argType {get;set;}
		
		public valueArguments(String i, String arg, String argT) {
			id = i;
			argument = arg;
			argType = argT;
		}
		
	}
	
	private void generatePieData() {  
        
        pieData = new List<PieWedgeData>();
        
        if(Schema.sObjectType.Big_Deal__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question1__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question2__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question3__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question4__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question5__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question6__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question7__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.question8__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.date1__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.date2__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.currency1__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.currency2__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.number1__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.number2__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.number3__c.isAccessible()
        && Schema.sObjectType.Big_Deal__c.fields.number4__c.isAccessible()){
            
        for(Big_Deal__c bd :[select id, question1__c, question2__c, 
        question3__c, question4__c, question5__c, question6__c, question7__c, question8__c, 
        date1__c, date2__c, currency1__c, currency2__c, number1__c, number2__c, number3__c, number4__c from Big_Deal__c where opportunity__c = :opp.id]) {           
            
            Integer calendar = 0;
            if (bd.date1__c != null) {
            	calendar += 10;
            }
            if (bd.date2__c != null) {
            	calendar += 10;
            }
            
            Integer economic = 0;
            if (bd.currency1__c != null) {
            	economic += 10;
            }
            if (bd.currency2__c != null) {
            	economic += 10;
            }
            
            Integer alc = 0;
            if (bd.number1__c != null) {
            	alc += 10;
            }
            if (bd.number2__c != null) {
            	alc += 10;
            }
            
            Integer prev = 0;
            if (bd.number3__c != null) {
            	prev += 10;
            }
            if (bd.number4__c != null) {
            	prev += 10;
            }
            
            Integer rie = 0;
            if (bd.question1__c != null) {
            	rie += 10;
            }
            if (bd.question2__c != null) {
            	rie += 10;
            }
            
            chartSum = calendar + economic + alc + prev + rie;
            integer chartTotal = 10;
            
            //pieData.add(new PieWedgeData('Empty',chartTotal - chartSum));
            pieData.add(new PieWedgeData('Calendario',calendar));
            pieData.add(new PieWedgeData('Datos Económicos',economic));
            pieData.add(new PieWedgeData('Alcance',alc));
            pieData.add(new PieWedgeData('Preventa y Oferta',prev));
            pieData.add(new PieWedgeData('Riesgos',rie));
        }
        }
            
        }  
    
    // Wrapper class  
    public class PieWedgeData 
    {  
        public String name { get; set; }  
        public Integer data { get; set; }  
        
        public PieWedgeData(String name, Integer data) {  
              
            if (data != null) {
            	this.data = data;
            } else {
            	this.data = 0;
            } 
            this.name = name;
        }  
    } 
	
}