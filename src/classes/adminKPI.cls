public with sharing class adminKPI {

    public String title { get; set; }

    public String regionId { get; set;}

    public String industry { get; set; }
    
    public Region__c region { get; set;} 
    
    public List< KPI__c > KPI;
    
    public List< KPI__c > globalKPI {get; set;}
    
    public KPI__c newKPI { get; set; }
    
    public String IdtoDel {get; set;}

    
    public Boolean canEdit {get;set;}
    
    
    public Account tempAccount{get;set;}

    
    public adminKPI(){
    
        KPI = new List<KPI__c>();
        title = 'Choose a Region and Industry to start';
        tempAccount = new Account();
    }

    public List<KPI__c> getKPI(){
        return KPI;
    }
    

    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();
        
        List<Region__c> temp = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible() ){
        temp =  [SELECT Name,Id From Region__c ORDER BY name ASC limit 1000];
        }
        
       for( Region__c c : temp)
       {
          options.add(new SelectOption(c.Id,c.Name));
       }  
       return options;
        
    }
    
    public List<SelectOption> getIndustries(){
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple) {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }
       options.add(new SelectOption('All', 'All'));
       return options;
    }
    
    public PageReference save(){
    	
    	Savepoint sp = Database.setSavepoint();
    	try {
    	    
    	    if(Schema.sObjectType.KPI__c.fields.Unit__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.fields.Name__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.isUpdateable())
    		Update globalKPI;
    		
    		if( Schema.sObjectType.KPI__c.fields.Name__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.fields.Industry__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.fields.Sub_Sector__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.fields.Sector__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.fields.Unit__c.isUpdateable()
    	    && Schema.sObjectType.KPI__c.isUpdateable())
    		Update KPI;
    		
    	} catch(DmlException ex){
    		Database.rollback(sp);
	        ApexPages.addMessages(ex);
	    }    	
    	return null;
    }
    
    public void doUpdate(){
      
		industry=tempAccount.Industry;      

        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible() ){
        region = [SELECT Id, Name FROM Region__c WHERE Id = :regionId];
        }
        
        if (tempAccount.Industry == 'Todos') {
        	tempAccount.Micro_Industry__c = 'Todos';
        } else if ( tempAccount.Industry == 'All') {
        	tempAccount.Micro_Industry__c = 'All';
        }
       	
       	List<Region__Share> tempedit = new List<Region__Share>();
       	
       	if(Schema.sObjectType.Region__Share.isAccessible()){        
        tempedit = [select Id from Region__Share WHERE (AccessLevel = 'Edit' OR AccessLevel = 'All') AND ParentId =:regionId AND UserOrGroupId =:UserInfo.getUserId()];
       	}
       	
        if(tempedit.size() > 0)
            canEdit = true;
        else
            canEdit = false;
        
        //canEdit=true;  
        //system.debug('KPI '+regionId+'-'+tempAccount.Micro_Industry__c+'-'+tempAccount.Sector__c+'-'+tempAccount.Industry); 
        if(Schema.sObjectType.KPI__c.isAccessible() && Schema.sObjectType.KPI__c.fields.Name.isAccessible()
        && Schema.sObjectType.KPI__c.fields.Industry__c.isAccessible()
        && Schema.sObjectType.KPI__c.fields.Sub_Sector__c.isAccessible()
        && Schema.sObjectType.KPI__c.fields.Sector__c.isAccessible()
        && Schema.sObjectType.KPI__c.fields.Name__c.isAccessible()
        && Schema.sObjectType.KPI__c.fields.Unit__c.isAccessible()){
        KPI = [SELECT Name,Industry__c,Sub_Sector__c,Sector__c,Name__c,Unit__c FROM KPI__c WHERE Region__c = :regionId AND Industry__c = :tempAccount.Micro_Industry__c AND /*Sector__c = :tempAccount.Sector__c AND*/ Sub_Sector__c = :tempAccount.Industry ORDER BY Name ASC];
        }
        //KPI = [SELECT Name,Industry__c,Sub_Sector__c,Sector__c,Name__c,Unit__c FROM KPI__c WHERE Region__c = :regionId AND Sector__c = :tempAccount.Sector__c AND Sub_Sector__c = :tempAccount.Industry ORDER BY Name ASC];
        //system.debug('KPI : SELECT Name,Industry__c,Sub_Sector__c,Sector__c FROM KPI__c WHERE Region__c = \''+regionId+'\' AND Industry__c = \''+tempAccount.Micro_Industry__c+'\' AND Sector__c = \''+tempAccount.Sector__c+'\' AND Sub_Sector__c = \''+tempAccount.Industry+'\' ORDER BY Name ASC');
        newKPI = new KPI__c();
        if (Schema.sObjectType.KPI__c.fields.Region__c.isCreateable()){
            newKPI.Region__c = regionId;}
        if (Schema.sObjectType.KPI__c.fields.Industry__c.isCreateable()){
            newKPI.Industry__c = tempAccount.Micro_Industry__c;}
        if (Schema.sObjectType.KPI__c.fields.Sub_Sector__c.isCreateable()){
            newKPI.Sub_Sector__c = tempAccount.Industry;}
        if (Schema.sObjectType.KPI__c.fields.Sector__c.isCreateable()){
            newKPI.Sector__c = tempAccount.Sector__c;}
        
        title = region.Name + ' > '+tempAccount.Industry+' > '  + tempAccount.Micro_Industry__c;
        //title = 'Viewing ' + region.Name + ' > '+tempAccount.Industry+ ' ('+tempAccount.Sector__c + ' Sector)';
         if(tempAccount.Micro_Industry__c == '' || tempAccount.Industry == '' ||
           tempAccount.Micro_Industry__c == '--None--' || tempAccount.Industry == '--None--' ||
           tempAccount.Micro_Industry__c == null || tempAccount.Industry == null ){
            canEdit = false;
            title = 'Debe seleccionar un Sector y un Subsector';
            industry=null;
        }
    }
    

    public PageReference InsertNewKPI() {
        
        try {
            
            if (Schema.sObjectType.KPI__c.isCreateable()){
                insert newKPI;
            }
            
        } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    } 
        this.doUpdate();
        return null;
    }


    public PageReference del(){
    

        //this.IdtoDel = Apexpages.currentPage().getParameters().get('IdtoDelete');  
    
        KPI__c toDel = new KPI__c();
        
        if(Schema.sObjectType.KPI__c.isAccessible()){
        toDel= [ SELECT id FROM KPI__c WHERE Id = :this.IdtoDel];
        }
        
        try {
	        if(KPI__c.sObjectType.getDescribe().isDeletable()){
                delete toDel;
            }
        } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    } 
        
        doUpdate();
        
        return null;       
    }
    
    
    public void checkStandardKPIs(){
        if(Schema.sObjectType.KPI__c.isAccessible() && Schema.sObjectType.KPI__c.fields.Name__c.isAccessible()
        && Schema.sObjectType.KPI__c.fields.Unit__c.isAccessible()){
        globalKPI = [SELECT Name__c,Unit__c FROM KPI__c WHERE Industry__c = 'All'];}
    }
    
    public String getHashIndustry(){
        if(industry !=null)
            return industry.replaceAll('[^a-zA-Z]', '');
        else
            return '*';
    }
}