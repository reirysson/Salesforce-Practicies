/**
 * @description: Batch for processing Account processes
 * @author: Reirysson Costa
 */
public with sharing class AccountBatch implements Database.Batchable<SObject> {

    AccountBO accountBO;

    public AccountBatch() {
        this.accountBO = new AccountBO();
    }

    public Database.QueryLocator start( Database.BatchableContext context ) {
        return Database.getQueryLocator( [
            SELECT
                Id, Name, Inactive__c,
                ( SELECT Id, ActivityDate FROM Tasks ),
                ( SELECT Id, StageName, CloseDate FROM Opportunities )
            FROM Account
        ] );
    }

    public void execute ( Database.BatchableContext context, List<Account> accounts ) {
        this.accountBO.inactiveOldAccountsWithoutTasksAndOpportunities( accounts );
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Batch AccountBatch finished.');
    }

}