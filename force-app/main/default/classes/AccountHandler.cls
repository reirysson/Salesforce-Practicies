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
	private AccountBO accountBO;

    public AccountHandler() {
        this.tNew = (List<Account>) Trigger.new;
		this.tOld = (List<Account>) Trigger.old;
		this.tNewMap = (Map<Id, Account>) Trigger.newMap;
		this.tOldMap = (Map<Id, Account>) Trigger.oldMap;

        this.filter = new AccountFilter();
        this.accountBO = new AccountBO();
    }

    public override void beforeInsert() {
        validateAccountNumber();
    }

    public override void beforeUpdate() {
        validateAccountNumber();
    }

    public override void afterInsert() {
        createOpportunityPartner();
        createTaskAccountFinalConsumer();
    }

    public override void afterUpdate() {
        createOpportunityPartner();
        createTaskAccountFinalConsumer();
    }

    private void validateAccountNumber(){

        List<Account> acountsChangedAccountNumber = this.filter.accountWithAccountNumber( this.tNew );

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

    public void createOpportunityPartner(){
        Map<String, List<Account>> accountsByRecordType = this.filter.byRecordTypeDeveloperName( this.tNew );

        if( !accountsByRecordType.containsKey('Partner') ) return;

        this.accountBO.createOpportunityPartner(accountsByRecordType);
    }

    public void createTaskAccountFinalConsumer(){
        Map<String, List<Account>> accountsByRecordType = this.filter.byRecordTypeDeveloperName( this.tNew );

        if( !accountsByRecordType.containsKey('FinalConsumer') ) return;

        this.accountBO.createTaskAccountFinalConsumer(accountsByRecordType);
    }
}