@isTest
private class Test_tutorialController {

    static testMethod void myUnitTest() {
        
        Account myAccount=new Account(Name = 'Test');
        insert myAccount;
        
        PageReference pageRef = Page.accountindustrytrends;
        Test.setCurrentPage(pageRef);       
        System.currentPagereference().getParameters().put('id',myAccount.id);
        
        tutorialController tc = new tutorialController();
        system.assertEquals('scp_certa_gc__accountindustrytrends', tc.pageName);
        
		String s = Label.tutorial_accountindustrytrends;
        s = Label.tutorial_accountstrategiccontextwindow;
        s = Label.tutorial_accountkpiwindow;
        s = Label.tutorial_accountorganizationchartwindow;
        //s = Label.tutorial_accountorganizationchart;
        s = Label.tutorial_accounthistoricalbusinesswindow;
        s = Label.tutorial_accountpastprovenvaluenew;
        s = Label.tutorial_accountoverallrelationshipwindow;
        s = Label.tutorial_accountopportunitylist;
        s = Label.tutorial_accountrdmwindow;
        s = Label.tutorial_accountrdmchart;
        s = Label.tutorial_accountrdmchartattitude;
        s = Label.tutorial_accountindustrytrendswindownew;
        s = Label.tutorial_accountopportunitylistcriteria;
        s = Label.tutorial_dcmevaluatecriteria;
        s = Label.tutorial_dcmcriteria;
        s = Label.tutorial_accountopportunitylistsnapshot;
        s = Label.tutorial_opportunitysnapshot;
        s = Label.tutorial_accountgrowthstrategy;
        s = Label.tutorial_accountmasterplan;
        s = Label.tutorial_accountcustomreport;
        s = Label.tutorial_adminregions;
        s = Label.tutorial_adminindustrytrends;
        s = Label.tutorial_adminkpi;
        s = Label.tutorial_adminprovenvalue;
        s = Label.tutorial_accountRDMChartAttitude_Opp;
        s = Label.tutorial_accountRDMChart_Opp;
        s = Label.tutorial_accountRDMWindow_Opp;
    }
}