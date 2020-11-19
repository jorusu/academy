public with sharing class AccountDataFactoryAngel {

    public static List<Account> createAccountsRating()
    {
         List<Account> accs = new List<Account>();
         for (Integer i = 0; i<100;i++){
              accs.add(new Account(Rating='Warm',Name ='Warm Opportunity'));
         }
         return accs;
     }

      public static List<Account> createAccountsNoRating()
      {
         List<Account> accs = new List<Account>();
         for (Integer i = 0; i<100;i++){
              accs.add(new Account(Name ='Account NoWarm Test: '+i));
         }
         return accs;
     }

     public static List<Opportunity> createWarmOpps(Set<Id> accountIds)
     {
         List<Opportunity> opportunities = new List<Opportunity>();
         for (Id accountId : accountIds) {
             Opportunity opp = new Opportunity();
             opp.AccountId = accountId;
             opp.CloseDate = Date.today().addMonths(1);
             opp.Name = 'Warm Opportunity';
             opp.StageName = 'Prospecting';
             opportunities.add(opp);
         }
         return opportunities;
     }

     public static Set<Id> getOppAccountIds()
     {
         Set<Id> accountsIds = new Set<Id>();
         List<Account> acct = createAccountsRating();
         insert acct;
         for (Account a: acct){
             accountsIds.add(a.Id);
         }
         return accountsIds;
     }

}
