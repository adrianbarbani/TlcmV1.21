@isTest
  private class test_MosaicCellController {

      static testMethod void myUnitTest() {
        
      	Account acc=new Account();
        acc.name='test';
        acc.industry = 'Banking';        
        insert acc;		        

        System.currentPagereference().getParameters().put('id',acc.id);
        
        MosaicCellController ptest = new MosaicCellController();
        
        system.assertEquals(acc.id,ptest.getId());
      
      }
    }