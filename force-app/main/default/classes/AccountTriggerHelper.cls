public inherited sharing class AccountTriggerHelper {
    public static void validateRating(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Rating != 'Warm') {
                acc.addError('Rating must be Warm for new Opportunities.');
            }
        }
    }

    public static void onWarmRatingCreateOpportunity(List<Account> accounts) {
        Set<Id> selectedAccountIds = new Set<Id>();
        for (Account acc : accounts) {
            if (acc.Rating == 'Warm') {
                selectedAccountIds.add(acc.Id);
            }
        }
        createFirstSaleOpportunities(selectedAccountIds);
    }

    public static void onRatingChangeProcessOpportunities(Map<Id, Account> oldAccountsById, List<Account> newAccounts) {
        Set<Id> hotRatingAccountIds = new Set<Id>();
        Set<Id> coldRatingAccountIds = new Set<Id>();
        Set<Id> noRatingAccountIds = new Set<Id>();
        for (Account acc : newAccounts) {
            Account oldAccount = oldAccountsById.get(acc.Id);
            if (oldAccount.Rating != acc.Rating) {
                if(oldAccount.Rating == 'Warm') {
                    if(acc.Rating == 'Hot') {
                        hotRatingAccountIds.add(acc.Id);
                    } else if(acc.Rating == 'Cold') {
                        coldRatingAccountIds.add(acc.Id);
                    } else {
                        noRatingAccountIds.add(acc.Id);
                    }
                }
            }
        }
        updateOpportunitiesProbability(hotRatingAccountIds);
        loseOpportunities(coldRatingAccountIds);
        deleteAllOpportunities(noRatingAccountIds);
    }

    public static void updateOpportunitiesProbability(Set<Id> accountIds) {
        List<Opportunity> opportunities = new List<Opportunity>([SELECT Id, StageName FROM Opportunity WHERE AccountId IN :accountIds AND Name = 'Warm Opportunity']);
        for(Opportunity opp : opportunities) {
            opp.Probability = 90;
        }

        try {
            update opportunities;
        } catch(DMLException e) {
            throw new AccountTriggerException('Error updating the probability of First Sales Opportunities. '+e.getMessage());
        }
    }

    public static void loseOpportunities(Set<Id> accountIds) {
        List<Opportunity> opportunities = new List<Opportunity>([SELECT Id, StageName FROM Opportunity WHERE AccountId IN :accountIds AND Name = 'Warm Opportunity']);
        for(Opportunity opp : opportunities) {
            opp.StageName = 'Closed Lost';
        }

        try {
            update opportunities;
        } catch(DMLException e) {
            throw new AccountTriggerException('Error closing First Sales Opportunities. '+e.getMessage());
        }
    }

    public static void deleteAllOpportunities(Set<Id> accountIds) {
        List<Opportunity> opportunities = new List<Opportunity>([SELECT Id FROM Opportunity WHERE AccountId IN :accountIds]);
        try {
            delete opportunities;
        } catch(DMLException e) {
            throw new AccountTriggerException('Error deleting all Opportunities. '+e.getMessage());
        }
    }

    public static void createFirstSaleOpportunities(Set<Id> accountIds) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Id accountId : accountIds) {
            Opportunity opp = new Opportunity();
            opp.AccountId = accountId;
            opp.CloseDate = Date.today().addMonths(1);
            opp.Name = 'Warm Opportunity';
            opp.StageName = 'Prospecting';

            opportunities.add(opp);
        }

        try {
            insert opportunities;
        } catch(DMLException e) {
            throw new AccountTriggerException('Error inserting First Sales Opportunities. '+e.getMessage());
        }
    }

    public class AccountTriggerException extends Exception {}
}
