/**
 * @description: Filter to Accounts objects in test context
 * Utilizado método de Filter inspirado no Eduardo Carvalho - Salesforce Apex (trecho codificado a partir da classe Filter do livro - Implemente soluções com padrões e técnicas de orientações a objetos)
 * @author: Reirysson Costa
 */
public with sharing class AccountFilter {
    
    public List<Account> byChangedAccountNumber( List<Account> newAccounts, Map<Id,Account> oldAccounts ) {

        List<Account> accountsChanged = new List<Account>();

        for( Account account : newAccounts){

            Account oldAccount = oldAccounts.get(account.Id);

            if( account.AccountNumber == oldAccount.AccountNumber ) continue;
            
            accountsChanged.add(account);
        }

        return accountsChanged;
    }
}