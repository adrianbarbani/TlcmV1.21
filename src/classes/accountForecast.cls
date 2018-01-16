public with sharing class accountForecast {
        
    public Account account { get; set; }
    //public List<Report> informe { get; set; }
    private ApexPages.StandardController controller;
    //private final Account acct;
    public List<Opportunity> opportunities {get;set;}
    public List<owrap> opps {get;set;}
    public Boolean canEdit {get;set;}
    public Opportunity newopp {get;set;}
    
    public Boolean noForce { get; set; }

    //public String CurrentCurrencySymbol { get; set; }
    //public String CurrentCurrency {get;set;}
    
    public String s_fcv { get; set; }
    public String s_estimated { get; set; }
    public String s_unsold { get; set; }
    public String s_westimated { get; set; }

    public String s_Estimated_FCV { get; set; }
    public String s_Estimated_FCV_Calculated { get; set; }
    public String s_Total_Forecasted_FCV { get; set; }
           
    public accountForecast(){
        
        if(Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Name.isAccessible() && Schema.sObjectType.Account.fields.id.isAccessible() && Schema.sObjectType.Account.fields.parentId.isAccessible() && Schema.sObjectType.Account.fields.Industry.isAccessible() && Schema.sObjectType.Account.fields.Region__c.isAccessible() && Schema.sObjectType.Account.fields.ID_Cliente__c.isAccessible() ){
        this.account = [SELECT name, id, parentId, Industry, Region__c, ID_Cliente__c FROM Account WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        }
        //this.CurrentCurrency = '#ORIGINAL#CURRENCY';
        //this.CurrentCurrencySymbol = '';
        
        this.controller = controller;
        //this.acct = (Account)controller.getRecord();
        this.loadOpps();
        this.newopp = new Opportunity();
        newopp.AccountId = this.account.id;
        //Funcion que engloba si el el usuario acutal puede o no escribir en esta cuenta, 
        userActions temp = new userActions();
        canEdit = temp.checkWrite(this.account.id);
        noForce=(String.valueOf(UserInfo.getProfileId()).contains('00eb0000000XejJ'))?false:true;
    }
    
    public void loadOpps(){

        if (Util.checkMultiCurrencyEnabled()) {
               
                if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.Full_Contract_Value__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.id.isAccessible()
                && Schema.sObjectType.Opportunity.fields.accountId.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Buying_Cycle__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Description.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Amount.isAccessible()
                && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_Year_End_Revenue__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_FCV__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_FCV_Calculated__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Total_Forecasted_FCV__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Weighted_Estimated_Year_End_Revenue__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Unsold_Pipeline__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.BIG__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Monthly_Charges__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Unique_Charges__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_Billing_Start_Date__c.isAccessible()){
               
                opportunities = database.query('SELECT Full_Contract_Value__c,id,accountId, Name, Buying_Cycle__c, Probability, Description, ' + 
                                        'Amount, StageName, Estimated_Year_End_Revenue__c, Estimated_FCV__c, Estimated_FCV_Calculated__c, Total_Forecasted_FCV__c,' + 
                                        'Weighted_Estimated_Year_End_Revenue__c, Unsold_Pipeline__c, CurrencyIsoCode,' +
                                        'BIG__c, Monthly_Charges__c, Unique_Charges__c, Estimated_Billing_Start_Date__c, ' +  
                                        '(select id from ContactsAssessments__r) ' +
                                        'FROM Opportunity ' +
                                        'WHERE accountId = \'' + account.Id + '\' and StageName != \'Cancelled\' and StageName != \'Closed Won\' and StageName != \'Closed Lost\''); 
                }
        } else {
                
                if(Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.Full_Contract_Value__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.id.isAccessible()
                && Schema.sObjectType.Opportunity.fields.accountId.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Name.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Buying_Cycle__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Probability.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Description.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Amount.isAccessible()
                && Schema.sObjectType.Opportunity.fields.StageName.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_Year_End_Revenue__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_FCV__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_FCV_Calculated__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Total_Forecasted_FCV__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Weighted_Estimated_Year_End_Revenue__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Unsold_Pipeline__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.BIG__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Monthly_Charges__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Unique_Charges__c.isAccessible()
                && Schema.sObjectType.Opportunity.fields.Estimated_Billing_Start_Date__c.isAccessible()){
                
                opportunities = [SELECT Full_Contract_Value__c,id,accountId, Name, Buying_Cycle__c, Probability, Description, 
                                        Amount, StageName, Estimated_Year_End_Revenue__c, Estimated_FCV__c, Estimated_FCV_Calculated__c, Total_Forecasted_FCV__c, 
                                        Weighted_Estimated_Year_End_Revenue__c, Unsold_Pipeline__c, 
                                        BIG__c, Monthly_Charges__c, Unique_Charges__c, Estimated_Billing_Start_Date__c,
                                        (select id from ContactsAssessments__r)  
                                        FROM Opportunity
                                        WHERE accountId = :account.Id and StageName != 'Cancelled' and StageName != 'Closed Won' and StageName != 'Closed Lost'];                
        
                }
        }
        
            
        opps = new List<owrap>();
            
        Decimal fcv=0;
        Decimal estimated=0;
        Decimal unsold=0;
        Decimal westimated=0;

        Decimal Estimated_FCV = 0;
        Decimal Estimated_FCV_Calculated = 0;
        Decimal Total_Forecasted_FCV = 0;
        
        String moneda;
        if (Util.checkMultiCurrencyEnabled()) {
            User u = new User();
            
            //if(Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.DefaultCurrencyIsoCode.isAccessible() ){
            u = (User)database.query('select DefaultCurrencyIsoCode FROM User where Id = \'' + UserInfo.getUserId() + '\' limit 1');
            //}
            moneda= (String)u.get('DefaultCurrencyIsoCode');
        } else {
            moneda = 'EUR';            
        }
   
        Map<String,Decimal> mapa_monedas=Util.getCurrencyMap();
        
        for(Opportunity o : opportunities){
            opps.add(new owrap(o));

            if(o.Full_Contract_Value__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {                                                
                    if(o.get('CurrencyIsoCode')=='EUR')
                            fcv+=o.Full_Contract_Value__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    fcv+=o.Full_Contract_Value__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    fcv+=0;
                    }
                } else {
                    fcv+=o.Full_Contract_Value__c;
                }
            }
                
            if(o.Estimated_Year_End_Revenue__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {
                    if(o.get('CurrencyIsoCode')=='EUR')
                            estimated+=o.Estimated_Year_End_Revenue__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    estimated+=o.Estimated_Year_End_Revenue__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    estimated+=0;
                    }
                } else {
                    estimated+=o.Estimated_Year_End_Revenue__c;
                }
            }
                
            if(o.Unsold_Pipeline__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {
                    if(o.get('CurrencyIsoCode')=='EUR')
                            unsold+=o.Unsold_Pipeline__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    unsold+=o.Unsold_Pipeline__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    unsold+=0;
                    }
                } else {
                    unsold+=o.Unsold_Pipeline__c;    
                }
            }
                
            if(o.Weighted_Estimated_Year_End_Revenue__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {
                    if(o.get('CurrencyIsoCode')=='EUR')
                            westimated+=o.Weighted_Estimated_Year_End_Revenue__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    westimated+=o.Weighted_Estimated_Year_End_Revenue__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    westimated+=0;
                    }
                } else {
                    westimated+=o.Weighted_Estimated_Year_End_Revenue__c;
                }
            }               
            
            if(o.Estimated_FCV__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {
                    if(o.get('CurrencyIsoCode')=='EUR')
                            Estimated_FCV+=o.Estimated_FCV__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    Estimated_FCV+=o.Estimated_FCV__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    Estimated_FCV+=0;
                    }
                } else {
                    Estimated_FCV+=o.Estimated_FCV__c;
                }
            }
            
            if(o.Estimated_FCV_Calculated__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {
                    if(o.get('CurrencyIsoCode')=='EUR')
                            Estimated_FCV_Calculated+=o.Estimated_FCV_Calculated__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    Estimated_FCV_Calculated+=o.Estimated_FCV_Calculated__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    Estimated_FCV_Calculated+=0;
                    }
                } else {
                    Estimated_FCV_Calculated+=o.Estimated_FCV_Calculated__c;
                }
            }
            
            if(o.Total_Forecasted_FCV__c!=null){
                if (Util.checkMultiCurrencyEnabled()) {
                    if(o.get('CurrencyIsoCode')=='EUR')
                            Total_Forecasted_FCV+=o.Total_Forecasted_FCV__c;
                    else{
                            if(mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=null && mapa_monedas.get((String)o.get('CurrencyIsoCode'))!=0)
                                    Total_Forecasted_FCV+=o.Total_Forecasted_FCV__c/mapa_monedas.get((String)o.get('CurrencyIsoCode'));
                            else
                                    Total_Forecasted_FCV+=0;
                    }
                } else {
                    Total_Forecasted_FCV+=o.Total_Forecasted_FCV__c;
                }
            }                      
        }        
        
        String fcv_euros=''+fcv.setScale(2);
        String fcv_otros='';
        String estimated_euros=''+estimated.setScale(2);
        String estimated_otros='';
        String unsold_euros=''+unsold.setScale(2);
        String unsold_otros='';
        String westimated_euros=''+westimated.setScale(2);
        String westimated_otros='';
        
        if(Util.checkMultiCurrencyEnabled() && moneda!='EUR'){
                fcv_otros=String.valueOf((fcv.setScale(2)*mapa_monedas.get(moneda)).setScale(2));
                estimated_otros=String.valueOf((estimated.setScale(2)*mapa_monedas.get(moneda)).setScale(2));
                unsold_otros=String.valueOf((unsold.setScale(2)*mapa_monedas.get(moneda)).setScale(2));
                westimated_otros=String.valueOf((westimated.setScale(2)*mapa_monedas.get(moneda)).setScale(2));               
        }
        
        fcv_otros=fcv_otros.replace('.',',');
        fcv_euros=fcv_euros.replace('.',',');
        fcv_euros=Util.transforma_miles(fcv_euros);
        estimated_otros=estimated_otros.replace('.',',');
        estimated_euros=estimated_euros.replace('.',',');
        estimated_euros=Util.transforma_miles(estimated_euros);
        unsold_otros=unsold_otros.replace('.',',');
        unsold_euros=unsold_euros.replace('.',',');
        unsold_euros=Util.transforma_miles(unsold_euros);
        westimated_otros=westimated_otros.replace('.',',');
        westimated_euros=westimated_euros.replace('.',',');
        westimated_euros=Util.transforma_miles(westimated_euros);
        
        if (Util.checkMultiCurrencyEnabled()) {
            if(moneda=='EUR'){
                    s_fcv='EUR '+fcv_euros;
                    s_estimated='EUR '+estimated_euros;
                    s_unsold='EUR '+unsold_euros;
                    s_westimated='EUR '+westimated_euros;
                    
                    s_Estimated_FCV = 'EUR '+Util.transforma_miles(Estimated_FCV);
                    s_Estimated_FCV_Calculated = 'EUR '+Util.transforma_miles(Estimated_FCV_Calculated);
                    s_Total_Forecasted_FCV = 'EUR '+Util.transforma_miles(Total_Forecasted_FCV);
            }else{
                    if(mapa_monedas.get(moneda)!=null){
                            //s_fcv=moneda+' '+Util.transforma_miles(fcv_otros)+' (EUR '+fcv_euros+')';
                            s_fcv=moneda+' '+Util.transforma_miles(fcv_otros);
                            s_estimated=moneda+' '+Util.transforma_miles(estimated_otros);
                            s_unsold=moneda+' '+Util.transforma_miles(unsold_otros);
                            s_westimated=moneda+' '+Util.transforma_miles(westimated_otros);
                            
                            s_Estimated_FCV = moneda+' '+Util.transforma_miles((String.valueOf((Estimated_FCV.setScale(2)*mapa_monedas.get(moneda)).setScale(2))).replace('.',','));
                            s_Estimated_FCV_Calculated = moneda+' '+Util.transforma_miles((String.valueOf((Estimated_FCV_Calculated.setScale(2)*mapa_monedas.get(moneda)).setScale(2))).replace('.',','));
                            s_Total_Forecasted_FCV = moneda+' '+Util.transforma_miles((String.valueOf((Total_Forecasted_FCV.setScale(2)*mapa_monedas.get(moneda)).setScale(2))).replace('.',','));                        
                    }else{
                            s_fcv='0';
                            s_estimated='0';
                            s_unsold='0';
                            s_westimated='0';
                            
                            s_Estimated_FCV ='0';
                            s_Estimated_FCV_Calculated ='0';
                            s_Total_Forecasted_FCV ='0';                        
                    }
            }
        } else {
            s_fcv= '$'+fcv_euros;
            s_estimated= '$'+estimated_euros;
            s_unsold= '$'+unsold_euros;
            s_westimated= '$'+westimated_euros;
            
            s_Estimated_FCV = '$'+Util.transforma_miles(Estimated_FCV);
            s_Estimated_FCV_Calculated = '$'+Util.transforma_miles(Estimated_FCV_Calculated);
            s_Total_Forecasted_FCV = '$'+Util.transforma_miles(Total_Forecasted_FCV);   
        }
    }

}