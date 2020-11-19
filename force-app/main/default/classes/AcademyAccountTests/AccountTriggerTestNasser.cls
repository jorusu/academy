@isTest
private class AccountTriggerTestNasser {

    Private static List<Account>  dataFactory() {
        List<Account> listAccount = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            listAccount.add(new Account(
                Name='Test Account '+(i+1),Rating='Warm'
            ));
        }
        for (Integer j = 100; j < 200; j++) {
            listAccount.add(new Account(
                Name='Test Account '+(j+1)
            ));
        }
        return listAccount;
    }

    @isTest
    public static void createAccountOpportunity(){
        List<Account> listTest = dataFactory();
        Test.startTest();
        List<Database.SaveResult> results= Database.insert(listTest, false);
        Test.stopTest();
        for(Database.SaveResult result:results){
            if(result.getErrors().size()==1){
                System.assertEquals('Rating must be Warm for new Opportunities.', result.getErrors().get(0).getMessage());
            }
        }
        List<Account> resultAccounts = [select id from Account];
        List<Opportunity> resultOppotunities = [select id from Opportunity where Accountid in :resultAccounts];
        System.assertEquals(100, resultAccounts.size());
        System.assertEquals(100, resultOppotunities.size());

    }

    @isTest
    public static void updateRankAccountToHot(){
        List<Account> listTest = dataFactory();
        Test.startTest();
        List<Database.SaveResult> results= Database.insert(listTest, false);
        List<Account> resultAccounts = [select id from Account];
        List<Opportunity> resultOppotunities = [select id from Opportunity where Accountid in :resultAccounts and Name = 'Warm Opportunity'];
        List<Opportunity> resultOppotunitiesWithProability = [select id from Opportunity where Accountid in :resultAccounts and Probability=90 and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Cambiar el rating de warm a hot y validar el cambio de las oportunidades
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='Hot';
        }
        update resultAccounts;
        List<Opportunity> newResultOppotunitiesWithProability = [select id from Opportunity where Accountid in :resultAccounts and Probability=90 and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Cambiar el rating de hot a otro estado y validar que las oportunidades no cambien
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='Cold';
        }
        update resultAccounts;
        List<Opportunity> newResultOppotunitiesRatingCold = [select id from Opportunity where Accountid in :resultAccounts and StageName = 'Closed Lost' and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Quitar el rating de la cuenta y validar que las oportunidades no cambien
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='';
        }
        update resultAccounts;
        List<Opportunity> newResultOppotunitiesNoRating = [select id from Opportunity where Accountid in :resultAccounts and Name = 'Warm Opportunity'];
        Test.stopTest();

        System.assertEquals(100, resultAccounts.size());
        System.assertEquals(100, resultOppotunities.size());
        System.assertEquals(0, resultOppotunitiesWithProability.size());
        System.assertEquals(100, newResultOppotunitiesWithProability.size());
        System.assertEquals(0, newResultOppotunitiesRatingCold.size());
        System.assertEquals(100, newResultOppotunitiesNoRating.size());
    }

    @isTest
    public static void updateRankAccountToCold(){
        List<Account> listTest = dataFactory();
        Test.startTest();
        List<Database.SaveResult> results= Database.insert(listTest, false);
        List<Account> resultAccounts = [select id from Account];
        List<Opportunity> resultOppotunities = [select id from Opportunity where Accountid in :resultAccounts and Name = 'Warm Opportunity'];
        List<Opportunity> resultLoseOppotunities = [select id from Opportunity where Accountid in :resultAccounts and StageName = 'Closed Lost' and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Cambiar el rating de warm a Cold y validar el cambio de las oportunidades
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='Cold';
        }
        update resultAccounts;
        List<Opportunity> newResultLoseOppotunities = [select id from Opportunity where Accountid in :resultAccounts and StageName = 'Closed Lost' and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Cambiar el rating de cold a otro estado y validar que las oportunidades no cambien
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='Hot';
        }
        update resultAccounts;
        List<Opportunity> newResultOppotunitiesRatingHot = [select id from Opportunity where Accountid in :resultAccounts and Probability=90 and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Quitar el rating de la cuenta y validar que las oportunidades no cambien
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='';
        }
        update resultAccounts;
        List<Opportunity> newResultOppotunitiesNoRating = [select id from Opportunity where Accountid in :resultAccounts  and Name = 'Warm Opportunity'];
        Test.stopTest();

        System.assertEquals(100, resultAccounts.size());
        System.assertEquals(100, resultOppotunities.size());
        System.assertEquals(0, resultLoseOppotunities.size());
        System.assertEquals(100, newResultLoseOppotunities.size());
        System.assertEquals(0, newResultOppotunitiesRatingHot.size());
        System.assertEquals(100, newResultOppotunitiesNoRating.size());
    }

    @isTest
    public static void updateRankAccountToNoRating(){
        List<Account> listTest = dataFactory();
        Test.startTest();
        List<Database.SaveResult> results= Database.insert(listTest, false);
        List<Account> resultAccounts = [select id from Account];
        List<Opportunity> resultOppotunities = [select id from Opportunity where Accountid in :resultAccounts and Name = 'Warm Opportunity'];
        //------------------------------------------
        //Cambiar el rating de warm a no rating y validar que las oportunidades se borren
        //------------------------------------------
        for (Account account : resultAccounts){
            account.Rating='';
        }
        update resultAccounts;
        List<Opportunity> newResultOppotunities = [select id from Opportunity where Accountid in :resultAccounts  and Name = 'Warm Opportunity'];

        Test.stopTest();

        System.assertEquals(100, resultAccounts.size());
        System.assertEquals(100, resultOppotunities.size());
        System.assertEquals(0, newResultOppotunities.size());
    }
}
