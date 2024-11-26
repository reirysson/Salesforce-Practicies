/**
 * @description: Filter to Accounts objects in test context
 * Utilizado método de Filter inspirado no Eduardo Carvalho - Salesforce Apex (trecho codificado a partir da classe Filter do livro - Implemente soluções com padrões e técnicas de orientações a objetos)
 * @author: Reirysson Costa
 */
public with sharing class AccountFilter {

    private String accountPartnerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Partner').getRecordTypeId();
    private String accountFinalConsumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('FinalConsumer').getRecordTypeId();
    
    public List<Account> accountWithAccountNumber( List<Account> newAccounts ) {

        List<Account> accountWithAccountNumber = new List<Account>();

        for( Account account : newAccounts){

            if( account.AccountNumber == null ) continue;
            
            accountWithAccountNumber.add(account);
        }

        return accountWithAccountNumber;
    }

    public Map<String, List<Account>> byRecordTypeDeveloperName( List<Account> newAccounts ) {

        Map<String, List<Account>> accountsByRecordTypeDeveloperName = new Map<String, List<Account>>();

        for( Account account : newAccounts){

            if (account.RecordTypeId == accountPartnerRecordTypeId) {
                if (!accountsByRecordTypeDeveloperName.containsKey('Partner')) {
                    accountsByRecordTypeDeveloperName.put('Partner', new List<Account>());
                }
                accountsByRecordTypeDeveloperName.get('Partner').add(account);
            }

            if (account.RecordTypeId == accountFinalConsumerRecordTypeId) {
                if (!accountsByRecordTypeDeveloperName.containsKey('FinalConsumer')) {
                    accountsByRecordTypeDeveloperName.put('FinalConsumer', new List<Account>());
                }
                accountsByRecordTypeDeveloperName.get('FinalConsumer').add(account);
            }
        }
        
        return accountsByRecordTypeDeveloperName;
    }
}