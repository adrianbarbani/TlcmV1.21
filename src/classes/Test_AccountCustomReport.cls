@isTest
private class Test_AccountCustomReport {

    static testMethod void myUnitTest() {
        Account myAccount=new Account(Name = 'Test');
        insert myAccount;
        
        PageReference pageRef = Page.AccountCustomReport;
        Test.setCurrentPage(pageRef);       
        System.currentPagereference().getParameters().put('id',myAccount.id);
        
        AccountCustomReportController acr = new AccountCustomReportController();
        acr.save();
        
        List<CustomReport__c> customReports = [select id from CustomReport__c where account__c = :myAccount.id];
        system.assertEquals(1, customReports.size());
        system.assertEquals(customReports.get(0).id, acr.customReport.id);
        
        AccountCustomReportController acr2 = new AccountCustomReportController();
        acr2.ExportToWord();
        acr2.getWordName();
        
                
    }
}