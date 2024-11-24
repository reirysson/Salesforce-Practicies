/**
 * @description: This is an exclusive class to process and delegate operations to triggered Account records.
 * @author: Reirysson Costa
 */
public with sharing class AccountHandler extends TriggerHandler {

    private List<Account> tNew;
	private List<Account> tOld;
	private Map<Id, Account> tNewMap;
	private Map<Id, Account> tOldMap;
    
	private AccountFilter filter;

    public AccountHandler() {
        this.tNew = (List<Account>) Trigger.new;
		this.tOld = (List<Account>) Trigger.old;
		this.tNewMap = (Map<Id, Account>) Trigger.newMap;
		this.tOldMap = (Map<Id, Account>) Trigger.oldMap;

        this.filter = new AccountFilter();
    }

    public override void beforeInsert() {
        validateAccountNumber();
    }

    public override void beforeUpdate() {
        validateAccountNumber();
    }

    private void validateAccountNumber(){

        List<Account> acountsChangedAccountNumber = this.filter.byChangedAccountNumber( this.tNew, this.tOldMap );

        if( acountsChangedAccountNumber.isEmpty() ) return;

        for( Account account : acountsChangedAccountNumber){

            if( account.AccountNumber.length() > 14 ) account.addError('Número do cliente é inválido');

            if( account.AccountNumber.length() == 14){

                if( Utils.validaCNPJ(account.AccountNumber) ) continue;

                else account.addError('Número do cliente é inválido');
            }
            
            if( account.AccountNumber.length() == 11){

                if( Utils.validaCPF(account.AccountNumber) ) continue;

                else account.addError('Número do cliente é inválido');
            }
        }

    }
}