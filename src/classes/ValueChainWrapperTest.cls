@isTest
public class ValueChainWrapperTest {
    static testMethod void test (){
        
        List<Value_Chain__c> valueChainList = new List<Value_Chain__c>();
        VCFunction__c function = new VCFunction__c();
        
        ValueChainWrapper controller = new ValueChainWrapper(function, valueChainList);
        
        system.assertEquals(function, controller.function);
    }
}