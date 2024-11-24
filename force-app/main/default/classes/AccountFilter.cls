/**
 * @description: Filter to Accounts objects in test context
 * Utilizado método de Filter inspirado no Eduardo Carvalho - Salesforce Apex (trecho codificado a partir da classe Filter do livro - Implemente soluções com padrões e técnicas de orientações a objetos)
 * @author: Reirysson Costa
 */
public with sharing class AccountFilter {

    private String accountPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();
    private String accountFinalConsumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('FinalConsumer').getRecordTypeId();
    
    public List<Account> byChangedAccountNumber( List<Account> newAccounts, Map<Id,Account> oldAccounts ) {

        List<Account> accountsChanged = new List<Account>();

        for( Account account : newAccounts){

            if( account.AccountNumber == null ) continue;

            Account oldAccount = oldAccounts.get(account.Id);

            if( account.AccountNumber == oldAccount.AccountNumber ) continue;
            
            accountsChanged.add(account);
        }

        return accountsChanged;
    }

    public Map<String, Account> byRecordTypeDeveloperName( List<Account> newAccounts ) {

        Map<String, Account> accountsByRecordTypeDeveloperName = new Map<String, Account>();

        for( Account account : newAccounts){

            if( account.RecordTypeId == accountPartnerRecordTypeId) accountsByRecordTypeDeveloperName.put('Partner', account);

            if( account.RecordTypeId == accountFinalConsumerRecordTypeId) accountsByRecordTypeDeveloperName.put('FinalConsumer', account);
        }
        
        return accountsByRecordTypeDeveloperName;
    }
}