@isTest
public class AccountTriggerTestLuisAlberto {

    @isTest
    static void testFailOnNonWarmInsert() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i < 20; i++) {
            testAccounts.add(new Account(Name='Test Account ' + (i+1), Rating='Cold'));
        }

        List<Database.SaveResult> results = Database.insert(testAccounts, false);

        for (Database.SaveResult result : results) {
            System.assert(!result.isSuccess());
            System.assertEquals('Rating must be Warm for new Opportunities.',
                                result.getErrors()[0].getMessage());
        }
    }

    @isTest
    static void testCreateOpportunityOnWarmInsert() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i < 20; i++) {
            testAccounts.add(new Account(Name='Test Account ' + (i+1), Rating='Warm'));
        }

        insert testAccounts;

        List<Account> insertedAccounts = [SELECT Id, Rating, (SELECT Name, CloseDate, StageName FROM Opportunities) FROM Account WHERE Id IN :testAccounts];
        for (Account account : insertedAccounts) {
            System.assertEquals(1, account.Opportunities.size());
            System.assertEquals('Warm Opportunity', account.Opportunities[0].Name);
            // Test today?
            System.assertEquals('Prospecting', account.Opportunities[0].StageName);
        }
    }

    @isTest
    static void testUpdateWarmToHot() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i < 20; i++) {
            testAccounts.add(new Account(Name='Test Account ' + (i+1), Rating='Warm'));
        }
        insert testAccounts;
        List<Opportunity> opportunities = [SELECT Id, Probability FROM Opportunity WHERE AccountId IN :testAccounts];
        for (Opportunity opp : opportunities) {
            opp.Probability = 10;  // Pre-assign probability
        }
        update opportunities;

        Test.startTest();
        for (Account account : testAccounts) {
            account.Rating = 'Hot';
        }
        update testAccounts;
        Test.stopTest();

        opportunities = [SELECT Id, Probability FROM Opportunity WHERE AccountId IN :testAccounts];
        for (Opportunity opp : opportunities) {
            System.assertEquals(90, opp.Probability);
        }
    }

    @isTest
    static void testUpdateWarmToCold() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i < 20; i++) {
            testAccounts.add(new Account(Name='Test Account ' + (i+1), Rating='Warm'));
        }
        insert testAccounts;
        // Auto created opportunities have a StageName of Prospecting by trigger

        Test.startTest();
        for (Account account : testAccounts) {
            account.Rating = 'Cold';
        }
        update testAccounts;
        Test.stopTest();

        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId IN :testAccounts];
        for (Opportunity opp : opportunities) {
            System.assertEquals('Closed Lost', opp.StageName);
        }
    }



    @isTest
    static void testUpdateWarmToNone() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i < 20; i++) {
            testAccounts.add(new Account(Name='Test Account ' + (i+1), Rating='Warm'));
        }
        insert testAccounts;
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId IN :testAccounts];
        System.assertEquals(20, opportunities.size());

        Test.startTest();
        for (Account account : testAccounts) {
            account.Rating = '';
        }
        update testAccounts;
        Test.stopTest();

        opportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId IN :testAccounts];
        System.assertEquals(0, opportunities.size());
    }
}