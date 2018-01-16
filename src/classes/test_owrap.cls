@isTest
private class test_owrap {

    static testMethod void myUnitTest() {
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.industry = 'Banking';        
        insert cuenta;
        
        Opportunity opp = new Opportunity(Name='test opportunity');
        opp.StageName = 'Open';
        opp.CloseDate = System.Today();
        opp.accountId = cuenta.Id;
        
        Owrap o = new Owrap(opp);       
        system.assertEquals(0,o.opp2.Amount);

        system.assertEquals(null,o.getFull_Contract_Value()); 
        system.assertEquals(null,o.getUnique_Charges());
        system.assertEquals(null,o.getMonthly_Charges());
        system.assertEquals(null,o.getEstimated_Year_End_Revenue());
        system.assertEquals(null,o.getUnsold_Pipeline());
        system.assertEquals(null,o.getWeighted_Estimated_Year_End_Revenue());
        system.assertEquals(null,o.getEstimated_FCV());
        system.assertEquals(null,o.getEstimated_FCV_Calculated());
        system.assertEquals(null,o.getTotal_Forecasted_FCV());
        


        opp.Estimated_Year_End_Revenue__c = 10;
        opp.Full_Contract_Value__c = 10;
        opp.Unique_Charges__c = 10;
        opp.Monthly_Charges__c = 10;
        opp.Estimated_FCV__c = 10;
        opp.Estimated_FCV_Calculated__c = 10;
        opp.Contract_duration_months__c = 1;

        String userCurrency;       
        if(Util.checkMultiCurrencyEnabled()){
            userCurrency = UserInfo.getDefaultCurrency();
            opp.put('CurrencyIsoCode',userCurrency);
        } else {
            userCurrency = '$';
        }
        
        opp.Probability = 10;
        insert opp;    

        Opportunity oppResult = [select id, Total_Forecasted_FCV__c, Weighted_Estimated_Year_End_Revenue__c, Probability, Valor_Total_del_Contrato_calculado__c, Unsold_Pipeline__c, Estimated_Year_End_Revenue__c, Full_Contract_Value__c, Unique_Charges__c, Monthly_Charges__c, Estimated_FCV__c, Estimated_FCV_Calculated__c, Contract_duration_months__c from Opportunity where id = :opp.id];
        Decimal valor_Total_del_Contrato_calculado = opp.Monthly_Charges__c * opp.Contract_duration_months__c + opp.Unique_Charges__c;
        system.assertEquals(valor_Total_del_Contrato_calculado, oppResult.Valor_Total_del_Contrato_calculado__c);
        system.assertEquals(valor_Total_del_Contrato_calculado * opp.Probability / 100,oppResult.Unsold_Pipeline__c);

        Owrap o2 = new Owrap(oppResult);        

        system.assertEquals(userCurrency + '10',o2.getFull_Contract_Value()); 
        system.assertEquals(userCurrency + '10',o2.getUnique_Charges());
        system.assertEquals(userCurrency + '10',o2.getMonthly_Charges());
        system.assertEquals(userCurrency + '10',o2.getEstimated_Year_End_Revenue());
        system.assertEquals(userCurrency + '2',o2.getUnsold_Pipeline());
        system.assertEquals(userCurrency + '1',o2.getWeighted_Estimated_Year_End_Revenue());
        system.assertEquals(userCurrency + '10',o2.getEstimated_FCV());
        system.assertEquals(userCurrency + '10',o2.getEstimated_FCV_Calculated());
        o2.getTotal_Forecasted_FCV();
        
    }
}