public with sharing class accountKPIWindow {
    
    public Account account { get; set; }
    
    public List<KPI__C> KPIs { get; set; }
    
    public List <AccountKPI__c> KPIData {get;set;}
    
    public List <ExtendedKPI> Data {get;set;}
    
    public List <ExtendedKPI> parentData {get;set;}
    
    public List <ExtendedKPI> localData {get;set;}
    
    public Integer year {get;set;}
    
    public Boolean canEdit {get;set;}
    
    public String delid {get;set;}
    
    private Region__c region {get;set;}
    
    public KPI__c newKPI {get;set;}
    
    public accountKPIWindow(){
        if (Util.globalAccount==null) {
            if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible()
               && Schema.sObjectType.Account.fields.parentId.isAccessible()
               && Schema.sObjectType.Account.fields.Industry.isAccessible()
               && Schema.sObjectType.Account.fields.Region__c.isAccessible()
               && Schema.sObjectType.Account.fields.Micro_Industry__c.isAccessible()){
                   
                   system.debug('entre');
                   this.account = [SELECT name, id, parentId, parent.Name, Industry, Region__c, Micro_Industry__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];}
        } else {
            this.account = Util.globalAccount; 
        }
        
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
        
        init();    
    }
    
    private void init() {
        
        this.KPIs = new List<KPI__C>();
        
        region = Util.getRegionFromAccount(account.Id, account.region__c);
        initNewKpi();
        
        this.loadKPIs(region,this.account.Industry);
        
        if(Schema.sObjectType.AccountKPI__c.isAccessible() && Schema.sObjectType.AccountKPI__c.fields.KPI__c.isAccessible()
           && Schema.sObjectType.AccountKPI__c.fields.Value__c.isAccessible()
           && Schema.sObjectType.AccountKPI__c.fields.Year__c.isAccessible()){
               system.debug('entre');
               this.KPIData = [SELECT KPI__c, Value__c, Year__c, KPI__R.Id FROM AccountKPI__c WHERE Account__c = :this.account.id];
           }
        
        this.Data = new List<ExtendedKPI>();
        
        this.parentData = new List<ExtendedKPI>();
        
        this.localData = new List<ExtendedKPI>();
        
        Date today = Date.today();
        
        this.year = today.year();
        
        for(KPI__C k : KPIs){
            this.Data.add( new ExtendedKPI(k,this.KPIData,year,this.account.id, getRegionKPIName(k)));
        }
        
        List<KPI__C> lista1 = new List<KPI__C>();
        
        if(Schema.sObjectType.KPI__c.isAccessible() && Schema.sObjectType.KPI__c.fields.Name__c.isAccessible()
           && Schema.sObjectType.KPI__c.fields.Unit__c.isAccessible()){
               lista1 = [SELECT Name__c,Unit__c FROM KPI__c WHERE account__c = :account.id];
           }
        
        for(KPI__C k : lista1) {
            this.localData.add( new ExtendedKPI(k,this.KPIData,year,this.account.id, getLocalKPIName()));
        }       
        
        if (account.ParentId != null) {
            
            List<KPI__C> lista2 = new List<KPI__C>();
            
            if(Schema.sObjectType.KPI__c.isAccessible() && Schema.sObjectType.KPI__c.fields.Name__c.isAccessible()
               && Schema.sObjectType.KPI__c.fields.Unit__c.isAccessible()){
                   lista2 =  [SELECT Name__c,Unit__c FROM KPI__c WHERE account__c = :account.ParentId];
               }
            for(KPI__C k : lista2) {
                this.parentData.add( new ExtendedKPI(k,this.KPIData,year,this.account.id, getParentKPIName()));
            }
        }
        
    }
    
    private void initNewKpi() {
        if (account.region__c == null) {
            
            if(Schema.sObjectType.KPI__c.fields.region__c.isCreateable() && Schema.sObjectType.KPI__c.fields.account__c.isCreateable()){
                newKPI = new KPI__c(region__c = region.id, account__c = account.id);
            }
            
        } else {
            
            if(Schema.sObjectType.KPI__c.fields.region__c.isCreateable() && Schema.sObjectType.KPI__c.fields.account__c.isCreateable()){
                newKPI = new KPI__c(region__c = account.region__c, account__c = account.id);
            }
            
        }
    }
    
    public void loadKPIs(Region__c region, String industry){
        /*
KPIs.addAll([SELECT Name__c,Id,Name,Unit__c, region__r.Name, sub_sector__c, Industry__c FROM KPI__C WHERE Region__C = : region.Id AND sub_sector__c != null and (sub_sector__c = :account.Industry or sub_sector__c = 'All' or sub_sector__c = 'Todos') And (Industry__c = :account.Micro_Industry__c or Industry__c = 'All' or Industry__c = 'Todos')]);

if(region.parent__c != null){
Region__c parent = [SELECT Id,Name, parent__c FROM Region__c WHERE id = :region.parent__c];
loadKPIs(parent,industry);
}
*/
        
        Map<Id, Region__c> regionsMap = new Map<Id, Region__c>();
        
        List<Region__c> regionesX = new List<Region__c>();
        
        if(Schema.sObjectType.Region__c.isAccessible() && Schema.sObjectType.Region__c.fields.Name.isAccessible()
           && Schema.sObjectType.Region__c.fields.parent__c.isAccessible()){
               regionesX = [select id, Name, parent__c from Region__c limit 1000];
           }
        
        for (Region__c reg : regionesX) {
            regionsMap.put(reg.id,reg);        	
        } 
        
        List<Region__c> regionsToSerch = new List<Region__c>();
        Id regionId = region.id;
        
        while (regionId != null) {
            Region__c r = regionsMap.get(regionId);
            regionsToSerch.add(r);
            regionId = r.parent__c;
        }
        
        List <KPI__C> kpis = new List<KPI__C>();
        
        
        if(Schema.sObjectType.KPI__C.isAccessible() && Schema.sObjectType.KPI__C.fields.Name__c.isAccessible()
           && Schema.sObjectType.KPI__C.fields.Name.isAccessible()
           && Schema.sObjectType.KPI__C.fields.Unit__c.isAccessible()
           && Schema.sObjectType.KPI__C.fields.sub_sector__c.isAccessible()
           && Schema.sObjectType.KPI__C.fields.Industry__c.isAccessible()){
               
               kpis = [SELECT Name__c,Id,Name,Unit__c, region__r.Name, sub_sector__c, Industry__c FROM KPI__C WHERE Region__C in :regionsToSerch AND sub_sector__c != null and (sub_sector__c = :account.Industry or sub_sector__c = 'All' or sub_sector__c = 'Todos') And (Industry__c = :account.Micro_Industry__c or Industry__c = 'All' or Industry__c = 'Todos')];
           }
        
        KPIs.addAll(kpis);
    }
    
    public PageReference SaveChanges() {
        try {
            
            if(Schema.sObjectType.Account.isUpdateable() && Schema.sObjectType.Account.fields.Name.isUpdateable()
               && Schema.sObjectType.Account.fields.parentId.isUpdateable()
               && Schema.sObjectType.Account.fields.Industry.isUpdateable()
               && Schema.sObjectType.Account.fields.Region__c.isUpdateable()
               && Schema.sObjectType.Account.fields.Micro_Industry__c.isUpdateable())
                update account;
            
        } catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        
        List<AccountKPI__c> accountKPIToUpsert = new List<AccountKPI__c>();
        List<KPI__c> kpiToUpdate = new List<KPI__c>(); 
        
        for(ExtendedKPI ekpi : Data){
            accountKPIToUpsert.add(ekpi.thisyear);
            accountKPIToUpsert.add(ekpi.lastyear);
            accountKPIToUpsert.add(ekpi.last2year);        
        }
        
        for(ExtendedKPI ekpi : parentData){
            accountKPIToUpsert.add(ekpi.thisyear);
            accountKPIToUpsert.add(ekpi.lastyear);
            accountKPIToUpsert.add(ekpi.last2year);
        }
        
        for(ExtendedKPI ekpi : localData){
            accountKPIToUpsert.add(ekpi.thisyear);
            accountKPIToUpsert.add(ekpi.lastyear);
            accountKPIToUpsert.add(ekpi.last2year);
            kpiToUpdate.add(ekpi.kpi);
        }       
        
        Savepoint sp = Database.setSavepoint();        
        try {
            
            if(Schema.sObjectType.AccountKPI__c.isCreateable()
               && Schema.sObjectType.AccountKPI__c.fields.KPI__c.isCreateable()
               && Schema.sObjectType.AccountKPI__c.fields.Value__c.isCreateable()
               && Schema.sObjectType.AccountKPI__c.fields.Year__c.isCreateable()
               && Schema.sObjectType.AccountKPI__c.isUpdateable()
               && Schema.sObjectType.AccountKPI__c.fields.KPI__c.isUpdateable()
               && Schema.sObjectType.AccountKPI__c.fields.Value__c.isUpdateable()
               && Schema.sObjectType.AccountKPI__c.fields.Year__c.isUpdateable())
                upsert accountKPIToUpsert;
            
            if(Schema.sObjectType.KPI__C.isAccessible() && Schema.sObjectType.KPI__C.fields.Name__c.isCreateable()
               && Schema.sObjectType.KPI__C.fields.Name.isCreateable()
               && Schema.sObjectType.KPI__C.fields.Unit__c.isCreateable()
               && Schema.sObjectType.KPI__C.fields.sub_sector__c.isCreateable()
               && Schema.sObjectType.KPI__C.fields.Industry__c.isCreateable() &&
               Schema.sObjectType.KPI__C.isUpdateable() && Schema.sObjectType.KPI__C.fields.Name__c.isUpdateable()
               && Schema.sObjectType.KPI__C.fields.Name.isUpdateable()
               && Schema.sObjectType.KPI__C.fields.Unit__c.isUpdateable()
               && Schema.sObjectType.KPI__C.fields.sub_sector__c.isUpdateable()
               && Schema.sObjectType.KPI__C.fields.Industry__c.isUpdateable()){
                   upsert kpiToUpdate;
               }
            
        } catch(DmlException ex){
            Database.rollback(sp);
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public PageReference addKPI() {
        
        try {
            if(Schema.sObjectType.KPI__c.isCreateable()){
                insert newKPI;
            }
        } catch(DmlException ex){
            ApexPages.addMessages(ex);
        }        
        
        AccountKPI__c a1 = new AccountKPI__c(account__c = account.id);
        AccountKPI__c a2 = new AccountKPI__c(account__c = account.id);
        AccountKPI__c a3 = new AccountKPI__c(account__c = account.id);     
        List<AccountKPI__c> accountKPIs = new List<AccountKPI__c>(); 
        
        localData.add(new ExtendedKPI(newKPI,accountKPIs,year,this.account.id, getLocalKPIName()));
        
        initNewKpi();        
        return null;
    }
    
    public PageReference deleteKPI() {
        
        KPI__c k = new KPI__c(id=delid);
        try {
            if(KPI__c.sObjectType.getDescribe().isDeletable()){
                delete k;
            }
        } catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        
        init();
        
        return null;
    }
    
    public String getIndustry(){
        if(account.industry != null && account.Micro_Industry__c != null)
            return account.Micro_Industry__c.replaceAll('[^a-zA-Z]', '');
        else
            return '';
    }
    
    private String getLocalKPIName() {
        return account.Name + ' (Local)';
    }
    
    private String getParentKPIName() {
        return account.Parent.Name + ' (Parent)';
    }
    
    private String getRegionKPIName(KPI__c k) {
        return 'Sector: ' + k.sub_sector__c + ' - ' + k.industry__c + ' (' + k.region__r.Name + ')';
    }
    
    public PageReference ExportToExcel() {
        return Page.accountKPIWindowExcel;
    }
    
    public String getExcelName() {
        String name = account.Name + '-' + Label.KPI + '.xls';
        return name.replaceAll(' ', '_').replaceAll(',','');
    }   
}