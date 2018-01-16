public with sharing class adminIndustryTrends {
    public String title { get; set; }

    public String regionId { get; set;}

    public String industry { get; set; }

    public String sector { get; set; }
    
    public Region__c region { get; set;}  
    
    private List<Industry_Trend__c> trends;
    
    public Industry_Trend__c newTrend { get; set; }
    
    public String IdtoDel {get; set;}

    public Boolean canEdit {get;set;}
    
    public AdministracionContextoSectorial__c tempAccount{get;set;}
    
    public adminIndustryTrends(){
    
        trends = new List<Industry_Trend__c>();
        title = 'Choose a Region and Industry to start';
        tempAccount = new AdministracionContextoSectorial__c();
        tempAccount.Micro_Industry__c = 'Todos';
        
        List<Region__c> regions = [SELECT Name,Id From Region__c where name = 'Global' ORDER BY id ASC limit 1];
        if(regions.size()>0){
            regionId = regions[0].id;    
        }
        
    }
	
    public void insertarRegionGlobal(){
        
        List<Region__c> regions = [SELECT Name,Id From Region__c where name = 'Global' ORDER BY id ASC limit 1];
        if(regions.size() == 0){
            
            Region__c regionglobal = new Region__c();
            regionglobal.name = 'Global';
            insert regionglobal;
            
            regionId = regionglobal.id;    
        }
    }
    public List<Industry_Trend__c> getTrends(){
        return trends;
    }
    

    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();
        
        List<Region__c> temp = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible() ){
        temp =  [SELECT Name,Id From Region__c ORDER BY id ASC limit 1000];
        }
        
       for( Region__c c : temp)
       {
          options.add(new SelectOption(c.Id,c.Name));
       }  
       return options;
        
    }
    
    public List<SelectOption> getSectors(){
        List<SelectOption> options = new List<SelectOption>();

            
       Schema.DescribeFieldResult fieldResult = Account.Sector__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
        
    }
    
    public List<SelectOption> getIndustries(){
      List<SelectOption> options = new List<SelectOption>();
            
       Schema.DescribeFieldResult fieldResult = Account.segmento_vertical__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    public PageReference save(){
    	try {
    		Update trends;
    	} catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }    	
    	return null;
    }
    
    public void doUpdate(){
        
        region = [SELECT Id, Name, OwnerId FROM Region__c WHERE Id = :regionId];

        
        List<Region__Share> tempedit = new List<Region__Share>();
        
        if(Schema.sObjectType.Region__Share.isAccessible() ){
        tempedit = [select Id from Region__Share WHERE AccessLevel = 'Edit' AND ParentId =:regionId AND UserOrGroupId =:UserInfo.getUserId()];
        }
        if(tempedit.size() > 0 || region.OwnerId == UserInfo.getUserId())
            canEdit = true;
        else
            canEdit = false;
            
       
       	if (tempAccount.segmento_vertical__c == 'Todos') {
        	tempAccount.Micro_Industry__c = 'Todos';
        } else if ( tempAccount.Segmento_vertical__c == 'All') {
        	tempAccount.Micro_Industry__c = 'Todos';
        }
       	

        if(tempAccount.Segmento_vertical__c == 'All'){
            
            trends = [SELECT Trend__c,Name, type__c, URL_Attachment__c, title__c FROM Industry_Trend__c WHERE Region__c = :regionId];
        }else{
            
            trends = [SELECT Trend__c,Name, type__c, URL_Attachment__c, title__c FROM Industry_Trend__c 
                      WHERE Region__c = :regionId AND Industry__c = :tempAccount.Micro_Industry__c AND /*Sector__C = :tempAccount.Sector__c AND*/ 
                      Sub_Sector__c = :tempAccount.segmento_vertical__c ORDER BY Name ASC];
            
            system.debug(tempAccount.Micro_Industry__c);
            system.debug(trends);
        }
        
        newTrend = new Industry_Trend__c();
        if (Schema.sObjectType.Industry_Trend__c.fields.Region__c.isCreateable()){
            newTrend.Region__c = regionId;}
        if (Schema.sObjectType.Industry_Trend__c.fields.Industry__c.isCreateable()){
            newTrend.Industry__c = tempAccount.Micro_Industry__c;}
        if (Schema.sObjectType.Industry_Trend__c.fields.Sub_Sector__c.isCreateable()){
            newTrend.Sub_Sector__c = tempAccount.segmento_vertical__c;}
        /*newTrend.Sector__C = tempAccount.Sector__c;*/
        title = region.Name + ' > '+tempAccount.segmento_vertical__c+' > '  + tempAccount.Micro_Industry__c;
                
        if(tempAccount.Micro_Industry__c == '' || tempAccount.segmento_vertical__c == '' || 
           tempAccount.Micro_Industry__c == '--None--' || tempAccount.segmento_vertical__c == '--None--' || 
           tempAccount.Micro_Industry__c == null || tempAccount.segmento_vertical__c == null){
            tempAccount.segmento_vertical__c=null;
            canEdit = false;
            title = 'Debe seleccionar un Sector y un Subsector';
        }
    
    }
    

    public PageReference InsertNewTrend() {
        if(newTrend.Trend__C != null) {
            try {
            	
                if (Schema.sObjectType.Industry_Trend__c.isCreateable()){
                    insert newTrend;
                }
                
            } catch(DmlException ex){
	        	ApexPages.addMessages(ex);
	    	}
        }
        this.doUpdate();
        return null;
    }


    public PageReference del(){
    
        //this.IdtoDel = Apexpages.currentPage().getParameters().get('IdtoDelete');  
        
        Industry_Trend__c toDel = new Industry_Trend__c();
        
        if(Schema.sObjectType.Industry_Trend__c.isAccessible()){
        toDel= [ SELECT id FROM Industry_Trend__c WHERE Id = :this.IdtoDel];
        }
        
        try {
        	if(Industry_Trend__c.sObjectType.getDescribe().isDeletable()){
                delete toDel;
            }
        } catch(DmlException ex){
	        ApexPages.addMessages(ex);
	    }
        
        doUpdate();
        
        return null;       
    }

    public String getHashIndustry(){
        if(tempAccount.Micro_Industry__c !=null)
            return tempAccount.Micro_Industry__c.replaceAll('[^a-zA-Z]', '');
        else
            return '*';
    }
    


}