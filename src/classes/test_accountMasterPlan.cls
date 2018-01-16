@isTest
private class test_accountMasterPlan {

    static testMethod void myUnitTest() {
      
      
		Account acct=new Account();
        acct.Name='test';
        acct.industry = 'Banking';
        
        insert acct;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test';
        opp.StageName = 'Prospect';
        opp.CloseDate = system.today().addDays(365);
        opp.AccountId = acct.id;      
      	
      	insert opp;
      	
      	List<Task> taskList = new List<Task>();
      	
		Task task = new Task();
  		task.WhatId = acct.id;
  		task.Subject = 'Step 1';
  		taskList.add(task);

		Task task2 = new Task();
		task2.WhatId = acct.id;
		task2.Subject = 'Step 1';
		taskList.add(task2); 
  		
  		Task task3 = new Task();
  		task3.WhatId = opp.id;
  		task3.Subject = 'Step 1';
  		taskList.add(task3);
  		
  		Task task4 = new Task();
  		task4.WhatId = opp.id;
  		task4.Subject = 'Step 1';
  		taskList.add(task4);
  		
  		insert taskList;
  		
		System.currentPagereference().getParameters().put('id',acct.id);
		accountMasterPlan p_Test = new accountMasterPlan();

		system.assertEquals(4, p_Test.tasks.size());


      	for(accountMasterPlan.TaskWrapper tw :p_Test.tasks){
        	tw.task.Subject = 'Updated';        	
      	}
      	
      	p_Test.SaveChanges();
      	
      	for (Task t :[select id, Subject from Task]) {
      		system.assertEquals('Updated', t.Subject);
      	}
      	
      	p_Test.tasks.get(0).selected = true;
      	p_Test.DeleteTasks();
      	
      	List<Task> taskResults = [select id from Task];
      	system.assertEquals(3, taskResults.size());
      	
      	for(accountMasterPlan.TaskWrapper tw :p_Test.tasks){
        	tw.selected = true;        	
      	}
      	      
      	p_Test.MergeTasks();
      	
      	List<Task> taskResults2 = [select id, Subject from Task];
      	
      	system.assertEquals(1, taskResults2.size());
      	system.assertEquals('Updated', taskResults2.get(0).Subject);
      
		p_Test.getAssignedToList();
  		p_Test.getPriorityList();
  		p_Test.getSubjectList();
  		p_Test.getTaskStatusList();
  		p_Test.ExportToExcel();
  		p_Test.getExcelName();    
      	p_Test.tasks.get(0).save();
      
    }
}