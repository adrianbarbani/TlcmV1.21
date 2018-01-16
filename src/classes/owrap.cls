public with sharing class owrap{
    
        public Opportunity opp {get;set;}
        public Opportunity opp2 {get;set;}
        private static Map<String,Decimal> map_currency {get;set;}
        
        public owrap(Opportunity opp){
 
            initCurrency();        
            this.opp = opp;
            this.opp2 = new Opportunity();
            if(opp.Estimated_Year_End_Revenue__c == null || opp.Probability == null){
                opp2.Amount = 0;
            }else{
                opp2.Amount = opp.Estimated_Year_End_Revenue__c * opp.Probability / 100;
            }
        
        }
        
        private String getUserCurrency() {
            if (Util.checkMultiCurrencyEnabled()) {
                return UserInfo.getDefaultCurrency();
            } else {
                return '$';
            }
        }
        
        public String getFull_Contract_Value() { 
          if (opp.Full_Contract_Value__c != null) {    
              Decimal result;
              if (Util.checkMultiCurrencyEnabled()) {
                  result = opp.Full_Contract_Value__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());                             
              } else {
                  result = opp.Full_Contract_Value__c;
                  return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));              
              }              
              return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));  
            } else {
              return null;
            }
        }
        
        public String getUnique_Charges() {            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Unique_Charges__c+'').replace('.',','));
            if (opp.Unique_Charges__c != null){
               Decimal result;
               
               if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Unique_Charges__c/map_currency.get((String) opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());                   
               }else{
                    result = opp.Unique_Charges__c;   
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
               }
               return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
               return null;
            }   
        }
        
        public String getMonthly_Charges(){            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Monthly_Charges__c+'').replace('.',','));
            if (opp.Monthly_Charges__c != null){
                Decimal result;
                
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Monthly_Charges__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Monthly_Charges__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;
            }
        }
        
        public String getEstimated_Year_End_Revenue() {  
            if (opp.Estimated_Year_End_Revenue__c != null){
                Decimal result;
                
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Estimated_Year_End_Revenue__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Estimated_Year_End_Revenue__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;
            }            
        }
        public String getUnsold_Pipeline() {            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Unsold_Pipeline__c+'').replace('.',','));

            if (opp.Unsold_Pipeline__c != null){
                Decimal result;
            
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Unsold_Pipeline__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Unsold_Pipeline__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;
            }
        }
        
        public String getWeighted_Estimated_Year_End_Revenue() {            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Weighted_Estimated_Year_End_Revenue__c+'').replace('.',','));
            if (opp.Weighted_Estimated_Year_End_Revenue__c != null){
                Decimal result;
                
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Weighted_Estimated_Year_End_Revenue__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Weighted_Estimated_Year_End_Revenue__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;    
            }
        }       
                
        public String getEstimated_FCV() {            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Weighted_Estimated_Year_End_Revenue__c+'').replace('.',','));
            if (opp.Estimated_FCV__c != null){
                Decimal result;                
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Estimated_FCV__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Estimated_FCV__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;    
            }
        }
        
        public String getEstimated_FCV_Calculated() {            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Weighted_Estimated_Year_End_Revenue__c+'').replace('.',','));
            if (opp.Estimated_FCV_Calculated__c != null){
                Decimal result;                
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Estimated_FCV_Calculated__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Estimated_FCV_Calculated__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;    
            }
        }        
        
        public String getTotal_Forecasted_FCV() {            
//            return UserInfo.getDefaultCurrency() + ' ' + Util.transforma_miles((opp.Weighted_Estimated_Year_End_Revenue__c+'').replace('.',','));
            if (opp.Total_Forecasted_FCV__c != null){
                Decimal result;                
                if (Util.checkMultiCurrencyEnabled()) {
                    result = opp.Total_Forecasted_FCV__c/map_currency.get((String)opp.get('CurrencyIsoCode'))*map_currency.get(getUserCurrency());
                }else{
                    result = opp.Total_Forecasted_FCV__c;
                    return getUserCurrency() + Util.transforma_miles((result+'').replace('.',','));
                }
                
                return getUserCurrency() + ' ' + Util.transforma_miles((result+'').replace('.',','));
            }else{
                return null;    
            }
        }
        
        private static void initCurrency() {                        
            if (map_currency == null) { 
                /*
                List<CurrencyType> ratios=[select IsoCode, ConversionRate from CurrencyType];
                map_currency=new Map<String,Decimal>();
                for(CurrencyType ct:ratios) {
                    map_currency.put(ct.IsoCode,ct.ConversionRate);
                }
                */
                map_currency = Util.getCurrencyMap();
                system.debug('>>>>> map_currency == null -> map_currency: ' + map_currency);
            } else {
                system.debug('>>>>> map_currency != null -> map_currency: ' + map_currency);            
            }          
        }
    }