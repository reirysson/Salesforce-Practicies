/**
 * @description: Class to test the AccountHandler class
 * @author: Reirysson Costa
 */
@isTest
public class AccountHandlerTest {

    private static String accountPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();
    private static String accountFinalConsumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('FinalConsumer').getRecordTypeId();
    
    @isTest
    public static void itShouldReturnAccountWithCNPJValid() {

        Account account = new Account();
        account.Name = 'Test';
        account.AccountNumber = '09028720000130';
        
        Test.startTest();
        
        insert account;

        Test.stopTest();

        Account accountInserted = [SELECT Id, AccountNumber FROM Account LIMIT 1];

        Assert.isNotNull(accountInserted);
        Assert.areEqual('09028720000130', accountInserted.AccountNumber);
    }

    @isTest
    public static void itShouldReturnAccountWithCNPJInvalid() {

        Account account = new Account();
        account.Name = 'Test';
        insert account;

        Account accountInserted = [SELECT Id FROM Account LIMIT 1];

        accountInserted.AccountNumber = '12345678901234';
        
        Test.startTest();
        
        try{
            update accountInserted;
        }catch( Exception e ) {
            Assert.isTrue( e.getMessage().contains( 'Número do cliente é inválido' ) );
        }

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnAccountWithCPFValid() {

        Account account = new Account();
        account.Name = 'Test';
        account.AccountNumber = '12345678909';
        
        Test.startTest();
        
        insert account;

        Test.stopTest();

        Account accountInserted = [SELECT Id, AccountNumber FROM Account LIMIT 1];

        Assert.isNotNull(accountInserted);
        Assert.areEqual('12345678909', accountInserted.AccountNumber);
    }

    @isTest
    public static void itShouldReturnAccountWithCPFInvalid() {

        Account account = new Account();
        account.Name = 'Test';
        insert account;

        Account accountInserted = [SELECT Id, AccountNumber FROM Account LIMIT 1];

        accountInserted.AccountNumber = '12345678901';
        
        Test.startTest();
        
        try{
            update accountInserted;
        }catch( Exception e ) {
            Assert.isTrue( e.getMessage().contains( 'Número do cliente é inválido' ) );
        }

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnOpportunityPartner() {

        Account account = new Account();
        account.Name = 'Test';
        account.RecordTypeId = accountPartnerRecordTypeId;
        
        Test.startTest();
        
        insert account;

        Test.stopTest();

        Account accountInserted = [SELECT Id FROM Account LIMIT 1];

        Opportunity opportunityCreated = [SELECT Id, Name, CloseDate, StageName, AccountId FROM Opportunity LIMIT 1];

        Assert.isNotNull(opportunityCreated);
        Assert.areEqual('Test --opp Partner', opportunityCreated.Name);
        Assert.areEqual(Date.today().addDays(30), opportunityCreated.CloseDate);
        Assert.areEqual('Qualification', opportunityCreated.StageName);
        Assert.areEqual(accountInserted.Id, opportunityCreated.AccountId);
    }

    @isTest
    public static void itShouldReturnOpportunityPartnerUpdated() {

        Account account = new Account();
        account.Name = 'Test';
        insert account;

        Account accountUpdate = [SELECT Id, RecordTypeId FROM Account LIMIT 1];
        accountUpdate.RecordTypeId = accountPartnerRecordTypeId;
        
        Test.startTest();
        
        update accountUpdate;

        Test.stopTest();

        Account accountInserted = [SELECT Id FROM Account LIMIT 1];

        Opportunity opportunityCreated = [SELECT Id, Name, CloseDate, StageName, AccountId FROM Opportunity LIMIT 1];

        Assert.isNotNull(opportunityCreated);
        Assert.areEqual('Test --opp Partner', opportunityCreated.Name);
        Assert.areEqual(Date.today().addDays(30), opportunityCreated.CloseDate);
        Assert.areEqual('Qualification', opportunityCreated.StageName);
        Assert.areEqual(accountInserted.Id, opportunityCreated.AccountId);
    }

    @isTest
    public static void itNotShouldReturnOpportunityPartner() {

        Account account = new Account();
        account.Name = 'Test';
        account.RecordTypeId = accountPartnerRecordTypeId;
        account.AccountNumber = '12345678901';
        
        Test.startTest();
        
        try{
            insert account;
        }catch( Exception e ) {
            Assert.isTrue( e.getMessage().contains( 'Número do cliente é inválido' ) );
        }

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturnTaskFinalConsumer() {

        Account account = new Account();
        account.Name = 'Test';
        account.RecordTypeId = accountFinalConsumerRecordTypeId;
        
        Test.startTest();
        
        insert account;

        Test.stopTest();

        Account accountInserted = [SELECT Id FROM Account LIMIT 1];

        Task taskCreated = [SELECT Id, Subject, WhatId, Status, Priority FROM Task LIMIT 1];

        Assert.isNotNull(taskCreated);
        Assert.areEqual('FinalConsumer', taskCreated.Subject);
        Assert.areEqual(accountInserted.Id, taskCreated.WhatId);
        Assert.areEqual('Not Started', taskCreated.Status);
        Assert.areEqual('Normal', taskCreated.Priority);
    }

    @isTest
    public static void itNotShouldReturnTaskFinalConsumer() {

        Account account = new Account();
        account.Name = 'Test';
        account.RecordTypeId = accountFinalConsumerRecordTypeId;
        account.AccountNumber = '12345678901';
        
        Test.startTest();
        
        try{
            insert account;
        }catch( Exception e ) {
            Assert.isTrue( e.getMessage().contains( 'Número do cliente é inválido' ) );
        }

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturn200OpportunitiesPartner() {

        List<Account> accountsToInsert = new List<Account>();

        for (Integer i = 0; i < 200; i++) {
            Account account = new Account();
            account.Name = 'Test ' + i;
            account.RecordTypeId = accountPartnerRecordTypeId;

            accountsToInsert.add(account);
        }
        
        Test.startTest();
        
        insert accountsToInsert;

        Test.stopTest();

        List<Account> accountsInserted = [SELECT Id FROM Account LIMIT 200];

        Assert.isNotNull(accountsInserted);
        Assert.areEqual(200, accountsInserted.size());

        List<Opportunity> opportunitiesCreated = [SELECT Id, Name, CloseDate, StageName, AccountId FROM Opportunity LIMIT 200];

        Assert.isNotNull(opportunitiesCreated);
        Assert.areEqual(200, opportunitiesCreated.size());
        Assert.areEqual('Test 0 --opp Partner', opportunitiesCreated[0].Name);
        Assert.areEqual(Date.today().addDays(30), opportunitiesCreated[0].CloseDate);
        Assert.areEqual('Qualification', opportunitiesCreated[0].StageName);
        Assert.areEqual(accountsInserted[0].Id, opportunitiesCreated[0].AccountId);
    }

    @isTest
    public static void itNotShouldReturn200OpportunitiesPartner() {

        List<Account> accountsToInsert = new List<Account>();

        for (Integer i = 0; i < 199; i++) {
            Account account = new Account();
            account.Name = 'Test ' + i;
            account.RecordTypeId = accountPartnerRecordTypeId;

            accountsToInsert.add(account);
        }

        Account wrongAccount = new Account();
        wrongAccount.Name = 'Test wrong';
        wrongAccount.RecordTypeId = accountPartnerRecordTypeId;
        wrongAccount.AccountNumber = '12345678901';

        accountsToInsert.add(wrongAccount);
        
        Test.startTest();
        
        try{
            insert accountsToInsert;
        }catch( Exception e ) {
            Assert.isTrue( e.getMessage().contains( 'Número do cliente é inválido' ) );
        }

        Test.stopTest();
    }

    @isTest
    public static void itShouldReturn200TasksFinalConsumer() {

        List<Account> accountsToInsert = new List<Account>();

        for (Integer i = 0; i < 200; i++) {
            Account account = new Account();
            account.Name = 'Test ' + i;
            account.RecordTypeId = accountFinalConsumerRecordTypeId;

            accountsToInsert.add(account);
        }
        
        Test.startTest();
        
        insert accountsToInsert;

        Test.stopTest();

        List<Account> accountsInserted = [SELECT Id FROM Account LIMIT 200];

        Assert.isNotNull(accountsInserted);
        Assert.areEqual(200, accountsInserted.size());

        List<Task> tasksCreated = [SELECT Id, Subject, WhatId, Status, Priority FROM Task LIMIT 200];

        Assert.isNotNull(tasksCreated);
        Assert.areEqual(200, tasksCreated.size());
        Assert.areEqual('FinalConsumer', tasksCreated[0].Subject);
        Assert.areEqual(accountsInserted[0].Id, tasksCreated[0].WhatId);
        Assert.areEqual('Not Started', tasksCreated[0].Status);
        Assert.areEqual('Normal', tasksCreated[0].Priority);
    }
}