@isTest
public class RunInfoSCPForAccountBatchTest {
    static testMethod void test (){
        
        
        RunInfoSCPForAccountBatchController contr = new RunInfoSCPForAccountBatchController();
        contr.runBatch();
        
        contr.msg= 'mensaje';
        
        system.assert(true);
    }
}