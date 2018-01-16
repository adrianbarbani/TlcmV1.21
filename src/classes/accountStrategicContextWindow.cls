public with sharing class accountStrategicContextWindow {
    
    public List<Strategic_Initiative__c>  localStrategicInitiatives { get; set; }
    
    public List<Strategic_Initiative__c>  globalStrategicInitiatives { get; set; }
    
    public List<Account> globalStrategicContext { get; set; }
    
    public List<String> globalBuyingCriteria {get;set;}
    
    public Account account {get;set;}
    
    public Strategic_Initiative__c newInitiative {get;set;}
    
    public Account_Competitor__c newCompetitor {get;set;}
    
    public List<Account_Competitor__c> newCompetitors {get;set;}
    
    public List<Account_Competitor__c> competidores {get; set;}
    public Integer year {get;set;}
    
    public String delid {
        get;
        set {
            delid = value;
        }
    }
    public Boolean canEdit {get;set;}
    
    public Descripcion_del_cliente_New__c descripcionDelClienteActual {get; set;}
    
    public accountStrategicContextWindow(){
        
        if (Util.globalAccount==null) {
            
            this.account = [SELECT name, id, parentId, Industry,Region__c, Buying_Criteria_Last_Update__c , Strategic_Context__c, Buying_Criteria__c, Strategic_Context_Last_Update__c,
                            Brand_Strengths__c, Brand_Weakness__c, Brand_Opportunities__c, Brand_Threats__c,
                            Products_Services_Strengths__c, Products_Services_Weakness__c, Products_Services_Opportunities__c, Products_Services_Threats__c,
                            People_Strengths__c, People_Weakness__c, People_Opportunities__c, People_Threats__c,
                            Other_Strengths__c, Other_Weakness__c, Other_Opportunities__c, Other_Threats__c,
                            CSAT_Unit__c, CSAT_Current_Year__c, CSAT_Last_Year__c, CSAT_Second_To_Last_Year__c
                            FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        } else {
            this.account = Util.globalAccount; 
        }
        this.loadData();
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
        
        List<Descripcion_del_cliente_New__c> descripciones = new List<Descripcion_del_cliente_New__c>();
        
        
        descripciones = [select id, El_n_mero_de_sucursales_crece_decrece__c, Cantidad_de_edificios__c, cantidad_de_empleados__c,
                         cantidad_de_sucursales__c, dispone_de_parque_automotor__c, Parque_Automotor_Propio_o_Gestionado__c, Presupuesto_anual_que_maneja_tu_cliente__c,
                         siguientes_pa_ses_tienen_negocio__c, Strategic_Context__c, Strategic_Context_Last_Update__c, veh_culos_dispone_el_parque__c, CSAT_Current_Year__c, CSAT_Last_Year__c, CSAT_Second_To_Last_Year__c, CSAT_Unit__c
                         from Descripcion_del_cliente_New__c
                         where cuenta__c =: account.id
                         limit 1];
        
        
        if(descripciones.size() > 0){
            descripcionDelClienteActual = descripciones[0];
        }
        
        newCompetitors = new List<Account_Competitor__c>();
        
        newCompetitors = [SELECT Id, Name, Fact__c, LastModifiedDate FROM Account_Competitor__c where Account__c = :account.Id order by createdDate];
        system.debug(newCompetitors.size());
        //InsertCompetitor();
		
        /*
        Account_Competitor__c c = new Account_Competitor__c();
        c.name = 'asjfhjasdg';
        newCompetitors.add(c);
        */
        newCompetitor = new Account_Competitor__c(Account__c = account.id);
        
        Date today = Date.today();
        
        year = today.year();
        
        
    }
    
    public void insertarData(){
        
        List<Descripcion_del_cliente_New__c> tengoDescripciones = [select id, El_n_mero_de_sucursales_crece_decrece__c, Cantidad_de_edificios__c, cantidad_de_empleados__c,
                                                               cantidad_de_sucursales__c, dispone_de_parque_automotor__c, Parque_Automotor_Propio_o_Gestionado__c, Presupuesto_anual_que_maneja_tu_cliente__c,
                                                               siguientes_pa_ses_tienen_negocio__c, Strategic_Context__c, Strategic_Context_Last_Update__c, veh_culos_dispone_el_parque__c, CSAT_Current_Year__c, CSAT_Last_Year__c, CSAT_Second_To_Last_Year__c, CSAT_Unit__c
                                                               from Descripcion_del_cliente_New__c
                                                               where cuenta__c =: account.id
                                                               limit 1];
        
        if(tengoDescripciones.size()==0){
            
            descripcionDelClienteActual = new Descripcion_del_cliente_New__c();
            descripcionDelClienteActual.cuenta__c = account.id;
            insert descripcionDelClienteActual;
        }
    }
    
    public void loadData(){
        
        newInitiative = new Strategic_Initiative__c();
        globalStrategicContext = new List<Account>();
        globalBuyingCriteria = new List<String>();
        globalStrategicInitiatives = new List<Strategic_Initiative__c>();
        
        
        localStrategicInitiatives = [SELECT Name, Strategic_Initiative__c, Strategic_Initiative_URL__c, LastModifiedDate, account__r.name, Title__c, (SELECT name, Opportunity__c, Opportunity__r.Name FROM Opportunities__r WHERE Opportunity__r.Account.id = :this.account.id) FROM Strategic_Initiative__c WHERE Account__C = :this.account.id order by name];
        
        
        Account accents = new Account();
        
        
        List<Account> cuentas = [SELECT Name, id, parentId, Industry,Region__c, Buying_Criteria_Last_Update__c,Strategic_Context__c, Buying_Criteria__c, Strategic_Context_Last_Update__c FROM Account WHERE Id = :this.account.parentId];
        
        if(cuentas.size()>0){
            accents = cuentas[0];
        }
        
        
        
        
        
        if(account.parentId != null)
            getDataFromParents(accents);
    }
    
    public void getDataFromParents(Account a){
        Account accents2 = new Account();
        
        
        List<Account> cuentas = [SELECT name, id, parentId, Buying_Criteria_Last_Update__c,Industry,Region__c, Strategic_Context__c, Buying_Criteria__c, Strategic_Context_Last_Update__c FROM Account WHERE Id = :a.parentId];
        if(cuentas.size()>0)
            accents2 = cuentas[0];
        
        
        if(a.parentId != null){
            getDataFromParents(accents2);
        }
        if(a.Strategic_Context__c!=null && a.Strategic_Context__c!='') {
            globalStrategicContext.add(a);
        }
        
        if(a.Buying_Criteria__c!=null && a.Buying_Criteria__c!='') {
            globalBuyingCriteria.add(a.Buying_Criteria__c);
        }
        
        List<Strategic_Initiative__c> temp = new List<Strategic_Initiative__c>();
        
        
        temp = [SELECT name,Strategic_Initiative__c,Strategic_Initiative_URL__c, LastModifiedDate, account__r.name, (SELECT name, Opportunity__c, Opportunity__r.name FROM Opportunities__r  WHERE Opportunity__r.Account.Id = :this.account.id) FROM Strategic_Initiative__c WHERE Account__C = :a.id order by Name];
        
        
        System.Debug( temp);
        System.Debug( globalStrategicInitiatives);
        
        if(temp != null) {
            globalStrategicInitiatives.addAll(temp);
        }        
        
    }

    public PageReference SaveChanges() {        
        
        Account oldAccount = new Account();
        Descripcion_del_cliente_New__c oldDescription = new Descripcion_del_cliente_New__c();
        
        oldDescription =  [select id, Strategic_Context__c, Strategic_Context_Last_Update__c
                         from Descripcion_del_cliente_New__c
                         where cuenta__c =: account.id
                         limit 1];
        
        
        oldAccount = [select id, Strategic_Context__c, Buying_Criteria__c from Account where id = :account.id];
        
        
        if (descripcionDelClienteActual.Strategic_Context__c != oldDescription.Strategic_Context__c) {
            if (Schema.sObjectType.Descripcion_del_cliente_New__c.fields.Strategic_Context_Last_Update__c.isUpdateable() ){
                descripcionDelClienteActual.Strategic_Context_Last_Update__c=System.now();
            }
        }
        
        if (account.Buying_Criteria__c != oldAccount.Buying_Criteria__c) {
            if (Schema.sObjectType.account.fields.Buying_Criteria_Last_Update__c.isUpdateable() ){
                account.Buying_Criteria_Last_Update__c=System.now();
            }
        }
        
        if (Schema.sObjectType.account.isUpdateable() && Schema.sObjectType.Descripcion_del_cliente_New__c.isUpdateable() ){
            update account; 
            update descripcionDelClienteActual;
        }
        
        system.debug(newCompetitors);
        
        List<Account_Competitor__c> lista_ac=new List<Account_Competitor__c>();
        List<Account_Competitor__c> lista_ac2=new List<Account_Competitor__c>();
        
        if(newCompetitors == null){
            newCompetitors = new List<Account_competitor__C>();
        }
        for(Account_Competitor__c ac:newCompetitors){
            if((((ac.Name!='' && ac.Name!=null) || (ac.Fact__c!='' && ac.Fact__c!=null)) && ac.id==null) || ac.id!=null)
                lista_ac.add(ac);
        }
        
        Savepoint sp = Database.setSavepoint();
        try {
            
            system.debug('entre');
            upsert lista_ac;
            
            update account;		        
        } catch(DmlException ex){
            Database.rollback(sp);
            ApexPages.addMessages(ex);
        } 
        
        
        newCompetitors = [SELECT Id, Name, Fact__c, LastModifiedDate FROM Account_Competitor__c where Account__c = :account.Id order by createdDate];
        
        update descripcionDelClienteActual;
        
        
        
        upsert localStrategicInitiatives;
        
        
        return null;
    }
    
    public void InsertIniciative() {
        
        if (Schema.sObjectType.Strategic_Initiative__c.fields.account__c.isCreateable()){
            newInitiative.account__c = account.id;}
        
        if (Schema.sObjectType.Strategic_Initiative__c.isCreateable()){
            insert newInitiative;
        }
        
        loadData();
        
    }
    
    public void DeleteStrategicInitiatives() {
        
        Integer i = 0;
        
        for(Strategic_Initiative__c si : localStrategicInitiatives){
            
            if(si.id == this.delid){
                break;
            }
            else
                i++;
            
        }
        
        if(localStrategicInitiatives[i].id != null){
            List<OpportunityStrategicInitiative__c> osi = new List<OpportunityStrategicInitiative__c>();
            
            if(Schema.sObjectType.OpportunityStrategicInitiative__c.isAccessible()){
                osi=[select Id from OpportunityStrategicInitiative__c where Strategic_Initiative__c = :localStrategicInitiatives[i].id];}
            
            
            if(OpportunityStrategicInitiative__c.sObjectType.getDescribe().isDeletable()){
                delete osi;
            }
            
            if(Strategic_Initiative__c.sObjectType.getDescribe().isDeletable()){
                delete localStrategicInitiatives[i];
            }    
        }
        
        localStrategicInitiatives.remove(i);
        
    }
    
    public void borra(){
        if (Schema.sObjectType.Descripcion_del_cliente_New__c.fields.Strategic_Context_Last_Update__c.isUpdateable() && Schema.sObjectType.Descripcion_del_cliente_New__c.fields.Strategic_Context__c.isUpdateable() ){
            descripcionDelClienteActual.Strategic_Context_Last_Update__c=null;
            descripcionDelClienteActual.Strategic_Context__c=null;
            update descripcionDelClienteActual;
        }
        
        //init();
    }
    
    public void borra2(){
        account.Buying_Criteria__c=null;
        account.Buying_Criteria_Last_Update__c = null;
    }
    
    public PageReference ExportToExcel() {
        return Page.accountStrategicContextWindowExcel;
    }
    
    public String getExcelName() {
        String name = account.Name + '-' + Label.Client_Context + '.xls';
        return name.replaceAll(' ', '_').replaceAll(',','');
    }
    
    //Nuevas funcionalidades.
    public void DeleteCompetitor() {
        List<Account_Competitor__c> lista_ac=new List<Account_Competitor__c>();
        for(Account_Competitor__c ac:newCompetitors){
            if(ac.Id!=null && ac.Id==delid){
                if(Account_Competitor__c.sObjectType.getDescribe().isDeletable()){
                    delete ac;
                }
            }else{
                lista_ac.add(ac);
            }
        }
        newCompetitors=lista_ac;
    }
    
    public PageReference add() {
        
        insert newCompetitor;
        
        init();
        return null; 
    }
    
    public void InsertCompetitor() {
        newCompetitors.add(new Account_Competitor__c(Account__c = account.id));
    }
    
    private void init() {
        
        this.account = [SELECT name, id, parentId, Industry,Region__c, Buying_Criteria_Last_Update__c , Strategic_Context__c, Buying_Criteria__c, Strategic_Context_Last_Update__c,
                        Brand_Strengths__c, Brand_Weakness__c, Brand_Opportunities__c, Brand_Threats__c,
                        Products_Services_Strengths__c, Products_Services_Weakness__c, Products_Services_Opportunities__c, Products_Services_Threats__c,
                        People_Strengths__c, People_Weakness__c, People_Opportunities__c, People_Threats__c,
                        Other_Strengths__c, Other_Weakness__c, Other_Opportunities__c, Other_Threats__c,
                        CSAT_Unit__c, CSAT_Current_Year__c, CSAT_Last_Year__c, CSAT_Second_To_Last_Year__c
                        FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        
        newCompetitors = new List<Account_Competitor__c>();
        
        newCompetitors = [SELECT Id, Name, Fact__c, LastModifiedDate FROM Account_Competitor__c where Account__c = :account.Id order by createdDate];
        
        //InsertCompetitor();
        newCompetitor = new Account_Competitor__c(Account__c = account.id);
        
        Date today = Date.today();
        
        //this.year = today.year() -1;
        year = today.year();
        
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
    }
}