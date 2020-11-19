@isTest()
public class AccountTriggerTestJonathan {


   @isTest static void validateRatingTest(){
        List<Account> listAccountWarm = new list<Account>();
        for(integer i=0;i<100;i++){
            listAccountWarm.add(new Account(
                Name='Test '+i , Rating='Cold'
            ));
        }
       List<Database.SaveResult> results= Database.insert(listAccountWarm, false);
       for(Database.SaveResult result : results){
           System.assert(!result.isSuccess());
           System.assertEquals('Rating must be Warm for new Opportunities.', result.getErrors().get(0).getMessage());
       }
   }

   @isTest static void onWarmRatingCreateOpportunityTest(){
         List<Account> listAccountWarm = new list<Account>();
        for(integer i=0;i<100;i++){
            listAccountWarm.add(new Account(
                Name='Test '+i , Rating='Warm'
            ));
        }
       insert listAccountWarm;
       List<Opportunity> listOpp= [select id , Name from Opportunity where AccountId in :listAccountWarm];
       System.assertEquals(100, listOpp.size());
   }
    @isTest static void onRatingChangeProcessOpportunitiesTest1(){

        List<Account> listAccountWarm = new list<Account>();
        for(integer i=0;i<100;i++){
            listAccountWarm.add(new Account(
                Name='Test '+i , Rating='Warm'
            ));
        }
       insert listAccountWarm;
       List<Account> listToUpdate = new list<Account>();
        for (Account a :listAccountWarm){
            a.Rating = 'Hot';
            listToUpdate.add(a);
        }
        update listToUpdate;
        List<Opportunity> listOpp= [select id , Name, Probability from Opportunity where AccountId in :listToUpdate];
        for (Opportunity opp : listOpp){
            System.assertEquals(90, opp.Probability);
        }
   }
   @isTest static void onRatingChangeProcessOpportunitiesTest2(){
       List<Account> listAccountWarm = new list<Account>();
        for(integer i=0;i<100;i++){
            listAccountWarm.add(new Account(
                Name='Test '+i , Rating='Warm'
            ));
        }
       insert listAccountWarm;
       List<Account> listToUpdate = new list<Account>();
        for (Account a :listAccountWarm){
            a.Rating = 'Cold';
            listToUpdate.add(a);
        }
        update listToUpdate;
       List<Opportunity> listOpp= [select id , Name, StageName from Opportunity where AccountId in :listToUpdate];
        for (Opportunity opp : listOpp){
            System.assertEquals('Closed Lost', opp.StageName);
        }
   }
   @isTest static void onRatingChangeProcessOpportunitiesTest3(){
        List<Account> listAccountWarm = new list<Account>();
        for(integer i=0;i<100;i++){
            listAccountWarm.add(new Account(
                Name='Test '+i , Rating='Warm'
            ));
        }
       insert listAccountWarm;
       List<Account> listToUpdate = new list<Account>();
        for (Account a :listAccountWarm){
            a.Rating = '';
            listToUpdate.add(a);
        }
        update listToUpdate;
       List<Opportunity> listOpp= [select id , Name, StageName from Opportunity where AccountId in :listToUpdate];
        System.assertEquals(0, listOpp.size());

   }
}