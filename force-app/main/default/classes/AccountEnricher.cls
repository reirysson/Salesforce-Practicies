/**
 * @description: Class responsible to enrich Accounts data
 * @author: Reirysson Costa
 */
public with sharing class AccountEnricher {
    
    AccountRepository repository;

    public AccountEnricher() {
        this.repository = new AccountRepository();
    }

    public List<Account> withInactive( List<Account> accounts ){

        for( Account account : accounts ) {
            account.Inactive__c = true;
        }

        return this.repository.save( accounts );
    }
}