@isTest
private with sharing class AccountOppTestAngel {
    @isTest static void validateRatingTest() {
        try{
            List<Account> acntsNr = AccountDataFactoryAngel.createAccountsNoRating();

            List<Database.SaveResult> resultsNr = Database.insert(acntsNr,false);

            for (Database.SaveResult res : resultsNr){
                System.assertEquals(res.isSuccess(), false);
            }

            List<Account> acnts = AccountDataFactoryAngel.createAccountsRating();
            List<Database.SaveResult> results = Database.insert(acnts,false);

            for (Database.SaveResult res : results){
                System.assertEquals(res.isSuccess(), true);
            }

        } catch(Exception e) {
            String expectedMessage = 'Rating must be Warm for new Opportunities.';
            System.assertEquals(e.getMessage(),expectedMessage);
        }
     }

     @isTest static void onWarmCreateOppTest() {
         List<Account> acnts = AccountDataFactoryAngel.createAccountsRating();
         Set<Id> selectedAccountsId = new Set<Id>();
          for (Account ac: acnts){
              selectedAccountsId.add(ac.Id);
         }
         AccountTriggerHelper.onWarmRatingCreateOpportunity(acnts);
         List<Opportunity> opps= AccountDataFactoryAngel.createWarmOpps(selectedAccountsId);

          List<Database.SaveResult> results = Database.insert(opps,false);
           for (Database.SaveResult res : results){
                System.assertEquals(res.isSuccess(), true);
            }
     }

     @isTest static void updateOpportunitiesProbabilityTest()
     {
         try {
         Set<Id> accountIds = AccountDataFactoryAngel.getOppAccountIds();
         List<Opportunity> warmOpps = AccountDataFactoryAngel.createWarmOpps(accountIds);
         insert warmOpps;
         List<Opportunity> opportunities = new List<Opportunity>([SELECT Id, StageName FROM Opportunity WHERE AccountId IN :accountIds AND Name = 'Warm Opportunity']);

         for(Opportunity opp : opportunities) {
             opp.Probability = 90;
         }

           AccountTriggerHelper.updateOpportunitiesProbability(accountIds);
           List<Database.SaveResult> results = Database.update(opportunities, false);
              for (Database.SaveResult res : results){
                System.assertEquals(res.isSuccess(), true);
            }
         } catch(DMLException e) {
             Boolean expMsg = e.getMessage().contains('Error deleting all Opportunities.') ? true : false;
             System.assertEquals(true, expMsg);
         }
     }
     @isTest static void loseOpportunitiesTest()
     {
         Set<Id> accountIds = AccountDataFactoryAngel.getOppAccountIds();
         List<Opportunity> warmOpps = AccountDataFactoryAngel.createWarmOpps(accountIds);

         try {
         insert warmOpps;
         List<Opportunity> opportunities = new List<Opportunity>([SELECT Id, StageName FROM Opportunity WHERE AccountId IN :accountIds AND Name = 'Warm Opportunity']);

          for(Opportunity opp : opportunities) {
             opp.StageName = 'Closed Lost';
         }

         AccountTriggerHelper.loseOpportunities(accountIds);
         List<Database.SaveResult> results = Database.update(opportunities, false);

         for (Database.SaveResult res : results){
              System.assertEquals(res.isSuccess(), true);
         }

         } catch(DMLException e) {
             Boolean expMsg = e.getMessage().contains('Error deleting all Opportunities.') ? true : false;
             System.assertEquals(true, expMsg);
         }
     }
     @isTest static void deleteAllOpportunitiesTest()
     {
         Set<Id> accountIds = AccountDataFactoryAngel.getOppAccountIds();
         List<Opportunity> warmOpps = AccountDataFactoryAngel.createWarmOpps(accountIds);
         try {
         insert warmOpps;
         List<Opportunity> opportunityIds = new List<Opportunity>([SELECT Id FROM Opportunity WHERE AccountId IN :accountIds]);

         List<Database.DeleteResult> results = Database.delete(opportunityIds, false);
         AccountTriggerHelper.deleteAllOpportunities(accountIds);

          for (Database.DeleteResult res : results){
                System.assertEquals(res.isSuccess(), true);
            }
         } catch(DMLException e) {
             Boolean expMsg = e.getMessage().contains('Error deleting all Opportunities.') ? true : false;
             System.assertEquals(true, expMsg);
         }
     }
}
