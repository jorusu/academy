@isTest
private class AccountTestLuisEduardo {

    private static List<Account> getCreatedAccountsWithOpportunities(List<Account> accounts){
        return [SELECT Rating, (SELECT Probability, StageName, Name, CloseDate FROM Opportunities) FROM Account WHERE Id IN :accounts];
    }

    private static List<Account> createBulkAccount(String rating){
        List<Account> accounts = new List<Account>();
        for(integer i = 1; i <= 25; i++){
            Account newAccount = new Account(Name = ('New Account Test ' + i), Rating = rating);
            accounts.add(newAccount);
        }
        insert accounts;
        return getCreatedAccountsWithOpportunities(accounts);
    }

    private static List<Account> updateBulkAccountRating(String rating, List<Account> accounts){
        for(Account account : accounts){
            account.Rating = rating;
        }
        update accounts;
        return getCreatedAccountsWithOpportunities(accounts);
    }

    private static List<Account> createThenUpdateRating(String rating){
        List<Account> successAccounts = createBulkAccount('Warm');
        System.assert(successAccounts.size() > 0);
        List<Account> updatedAccounts = updateBulkAccountRating(rating, successAccounts);
        System.assert(updatedAccounts.size() > 0);
        return updatedAccounts;
    }

    @isTest
    private static void beforeInsertFailDueToRating(){
        String error = null;
        Test.startTest();
        try{
            createBulkAccount('');
        }
        catch(Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
        System.assert(String.isNotEmpty(error));
        System.assert(error.contains('Rating must be Warm for new Opportunities.'));
    }

    @isTest
    private static void afterInsertSuccessfulWithWarmRating(){
        Test.startTest();
        List<Account> successAccounts = createBulkAccount('Warm');
        Test.stopTest();
        System.assert(successAccounts.size() > 0);
        Date nextMonthDate = Date.today().addMonths(1);
        for(Account successAccount : successAccounts){
            System.assert(successAccount.Opportunities.size() == 1);
            System.assertEquals('Warm Opportunity', successAccount.Opportunities.get(0).Name);
            System.assertEquals('Prospecting', successAccount.Opportunities.get(0).StageName);
            System.assertEquals(nextMonthDate, successAccount.Opportunities.get(0).CloseDate);
        }
    }

    @isTest
    private static void afterUpdateFromWarmToHot(){
        Test.startTest();
        List<Account> updatedAccounts = createThenUpdateRating('Hot');
        Test.stopTest();
        for(Account updatedAccount : updatedAccounts){
            System.assert(updatedAccount.Opportunities.get(0).Probability == 90);
        }
    }

    @isTest
    private static void afterUpdateFromWarmToCold(){
        Test.startTest();
        List<Account> updatedAccounts = createThenUpdateRating('Cold');
        Test.stopTest();
        for(Account updatedAccount : updatedAccounts){
            System.assertEquals('Closed Lost', updatedAccount.Opportunities.get(0).StageName);
        }
    }

    @isTest
    private static void afterUpdateFromWarmToNone(){
        Test.startTest();
        List<Account> updatedAccounts = createThenUpdateRating('');
        Test.stopTest();
        for(Account updatedAccount : updatedAccounts){
            System.assert(updatedAccount.Opportunities.size() == 0);
        }
    }
}
