@isTest
private class test_adminRegions {

    static testMethod void myUnitTest() {
     	Region__c regionGlobal = new Region__C(name='Global');
        insert regionGlobal;
        
        Region__c regionLocal = new Region__c(name='Local',Parent__c=regionGlobal.id);
        insert regionLocal;

        Account cuentapapa=new Account();
        cuentapapa.Name='test';
        cuentapapa.Region__c=regionLocal.id;
        
        insert cuentapapa;
      
        Account cuenta=new Account();
        cuenta.Name='test';
        cuenta.Region__c=regionLocal.id;
        cuenta.ParentId = cuentapapa.id;
        insert cuenta;
        
        User tempUser = new User();
        tempUser.FirstName = 'temp';
        tempUser.LastName = 'name';
        tempUser.Username = 'test1234567890lkjhgfdsxcv@test123.com';
        tempUser.Email = 'test@test234.com';
        tempUser.Alias = 'tst';
        tempUser.CommunityNickname = 'tstnk';
        tempUser.TimeZoneSidKey = 'GMT';
        tempUser.LocaleSidKey ='es_AR';
        tempUser.EmailEncodingKey = 'ISO-8859-1';
        tempUser.ProfileId = [select Id from Profile LIMIT 1][0].id;
        tempUser.LanguageLocaleKey = 'en_US';
        insert tempUser;
        
        Test.setCurrentPage(Page.adminRegions);
        adminRegions p = new adminRegions();
        
        p.getRegions();
        //p.getUsers();
        p.InsertNew();
        p.parent_s = '1';
        p.user_s = '1';
        p.InsertNew();
        p.parent_s = regionGlobal.id;
        p.dummyAccount.ownerId = UserInfo.getUserId();
        p.InsertNew();
        
        List<Region__Share> regionShareList = [select Id from Region__Share WHERE AccessLevel = 'Edit'];
        system.assertEquals(0,regionShareList.size());
        system.assert(ApexPages.hasMessages());
        
        p.parent_s = regionGlobal.id;
        p.dummyAccount.ownerId = tempUser.id;
        p.InsertNew();
        
        List<Region__Share> regionShareList1 = [select Id from Region__Share WHERE AccessLevel = 'Edit'];
        system.assertEquals(1,regionShareList1.size());
        
        p.seleccionado = regionShareList1.get(0).id;
        p.del();
        
        List<Region__Share> regionShareList2 = [select Id from Region__Share WHERE AccessLevel = 'Edit'];
        system.assertEquals(0,regionShareList2.size());
        
    }
}