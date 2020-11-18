public inherited sharing class AccountTriggerHandler {
    public static void afterInsert(List<Account> accounts) {
        AccountTriggerHelper.onWarmRatingCreateOpportunity(accounts);
    }

    public static void afterUpdate(Map<Id, Account> oldAccountsById, List<Account> newAccounts) {
        AccountTriggerHelper.onRatingChangeProcessOpportunities(oldAccountsById, newAccounts);
    }

    public static void beforeInsert(List<Account> accounts) {
        AccountTriggerHelper.validateRating(accounts);
    }
}