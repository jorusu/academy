@isTest
public class AccountTest {

    @IsTest
    static void itShouldCreateOpportunityOnWarmRatingTest() {
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Rating = 'Warm'));
        }

		List<Database.SaveResult> saveResults = Database.insert(accounts, false);

        for(Database.SaveResult saveResult : saveResults) {
            System.assert(saveResult.getErrors().size() == 0);
        }
    }
    @IsTest
    static void itShouldNotCreateOpportunityOnHotRatingTest() {
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Rating = 'Hot'));
        }

		List<Database.SaveResult> saveResults = Database.insert(accounts, false);

        for(Database.SaveResult saveResult : saveResults) {
            System.assert(saveResult.getErrors().size() > 0);
            for(Database.Error error : saveResult.getErrors()) {
                System.assertEquals(error.getMessage(), 'Rating must be Warm for new Opportunities.');
            }
        }
    }

    @IsTest
    static void itShouldUpdateOpportunityProbabilityOnWarmToHotRatingTest() {
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Rating = 'Warm'));
        }

        insert accounts;

        for(Account account : accounts) {
            account.Rating = 'Hot';
        }

        update accounts;

        List<Opportunity> opportunities = [SELECT Name, Probability FROM Opportunity WHERE AccountId IN :accounts];

        System.assert(opportunities.size() > 0);
        for(Opportunity opp : opportunities) {
            System.assert(opp.Probability == 90);
        }
    }

    @IsTest
    static void itShouldUpdateOpportunityProbabilityOnWarmToColdRatingTest() {
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Rating = 'Warm'));
        }

        insert accounts;

        for(Account account : accounts) {
            account.Rating = 'Cold';
        }

        update accounts;

        List<Opportunity> opportunities = [SELECT Name, StageName FROM Opportunity WHERE AccountId IN :accounts];


        for(Opportunity opp : opportunities) {
            System.assertEquals(opp.StageName, 'Closed Lost');
        }
    }

    @IsTest
    static void itShouldUpdateOpportunityProbabilityOnWarmToNoneRatingTest() {
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 50; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Rating = 'Warm'));
        }

        insert accounts;

        for(Account account : accounts) {
            account.Rating = '';
        }

        update accounts;

        List<Opportunity> opportunities = [SELECT Name, StageName FROM Opportunity WHERE AccountId IN :accounts];

		System.assert(opportunities.size() == 0);
    }

}