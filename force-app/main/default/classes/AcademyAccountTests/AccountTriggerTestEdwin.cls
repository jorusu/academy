@isTest
private class AccountTriggerTestEdwin{
    /*
    @isTest static void TestInsertWarm() {
       List<Account> ListAcc = new List<Account>();
       for (integer i=0; i < 10; i++){
           Account objAcc = new Account();
           objAcc.Name='Test Account '+(i+1);
           objAcc.Rating='Warm;
           ListAcc.add(objAcc);


            //  ListAcc.add(new Account(Name='Test Account '+(i+1),Rating='Warm'));
            //  Name='Test Account '+(i+1),Rating='Warm'));
         }
         insert
       for (integer j=10; j < 20; j++){
             ListAcc.add(new Account(
             Name='New Account '+(j+1)));
        }
        Database.SaveResult[] updateResults = Database.insert(ListAcc, false);

        for(Database.SaveResult result : updateResults){
        //if(result.geterrors().size()==1){
            System.assertEquals('Rating must be Warm for new Opportunities.',updateResults.getErrors()[0]);
    			}
			}
       @isTest static void testCreateOpptyWarm() {
   		 List<Account> ListAccs = new list<Account>();
   		 for (integer i=0; i< 10; i++) {
       	 ListAccs.add(new Account(Name='New Account '+ (i+1), Rating='Warm'));
   		 }

    	 insert ListAccs;

    	List<Account> AccountsRelated = [Select Id, Rating, (Select Name, StageName, CloseDate  FROM Opportunities)FROM Account WHERE Id IN:ListAccs];
    	for (Account Acc : AccountsRelated){
        System.assertEquals(1, Acc.Opportunities.size());
        System.assertEquals ('Warm Opportunity', Acc.Opportunities[0].Name);
    }
}


    @isTest static void testChangeWarmtoCold(){
    list<Account> ListAccs = new list<Account>();

    	for (integer i=0; i< 10; i++) {
        ListAccs.add(new Account (Name='New Account ' + (i+1), Rating='Warm'));
    }
    insert ListAccs;

    test.startTest();

    for (Account Acc: ListAccs){
        Acc.rating ='Cold';
    }
    update ListAccs;

    Test.stopTest();

    List<Opportunity> Opp = [Select Id, StageName FROM Opportunity WHERE AccountId IN : ListAccs];
    for (Opportunity Opty : Opp)
        system.assertEquals ('Closed Lost', opty.StageName);
    }





	*/
    }