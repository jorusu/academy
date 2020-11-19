@isTest
public class AccountTest {

    private static List<Account> createAccountsDataFactory(String name, String rating) {
        List<Account> accs = new List<Account>();
        for(Integer i=0; i<=3; i++) {
            Account acc = new Account(Name=name + i , Rating=rating);
            accs.add(acc);
        }
        return accs;
    }

    @isTest
    private static void itShouldBlockOpportunitiesOnInsertWhenRatingIsNotWarm() {
        //Arrange
        List<Account> accs = AccountTest.createAccountsDataFactory('Test ','Cold');
        try{
        //Act
        Test.startTest();
        Database.SaveResult result = Database.insert(accs[0]);
        System.debug(result);
        Test.stopTest();
        } catch(Exception e) {
			//Asssert
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('Rating must be Warm for new Opportunities.'));

        }
    }

    @isTest
    private static void itShouldSelecteAccountsWithRatingWarmAndCreateARelatedOpportunity() {
        //Arrange
        List<Account> accs = AccountTest.createAccountsDataFactory('Test ','Warm');

        //Act
        Test.startTest();
        Database.SaveResult result = Database.insert(accs[0]);
        System.debug(result);
        Test.stopTest();
        //Asssert
        System.assert(result.isSuccess());
    }

    @isTest
    private static void itShouldAllowUpdateTheAccountsWithDifferentRating() {
        //Arrange
        List<Account> oldAccs = createAccountsDataFactory('Test ', 'Warm');
        insert oldAccs;

        oldAccs[0].Rating = 'Hot';
        oldAccs[1].Rating = 'Cold';

        //Act
        Test.startTest();
        Database.SaveResult[] results = Database.update(oldAccs);
        System.debug(results);
        Test.stopTest();
        //Asssert
        for(Database.SaveResult rs: results){
            System.assert(rs.isSuccess());
        }
    }

}