@isTest
public class ExtendedRegionTest {
	
    static testMethod void test(){
        
        Region__C region = new Region__C();
        region.name = 'regioncita';
        
        List< Industry_Trend__c > lista = new List<Industry_Trend__c>();
        
        ExtendedRegion controller = new ExtendedRegion(region, lista);
        
        system.assertEquals(region.id, controller.Region.id);
    }
}