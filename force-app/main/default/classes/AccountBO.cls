/**
 * @description: AccountBO
 * @author Reirysson Costa
 */
public with sharing class AccountBO {

    OpportunityRepository opportunityRepository;
    TaskRepository taskRepository;
    AccountEnricher enricher;

    public AccountBO(){
        this.opportunityRepository = new OpportunityRepository();
        this.taskRepository = new TaskRepository();
        this.enricher = new AccountEnricher();
    }
    
    public void createOpportunityPartner( Map<String, List<Account>> accountsPartner ){

        List<Account> partnerAccounts = accountsPartner.get('Partner');

        List<Opportunity> opportunitiesEnriched = new List<Opportunity>();

        for (Account account : partnerAccounts){

            Opportunity opportunity = new Opportunity();
            opportunity.Name = account.Name + ' --opp Partner';
            opportunity.CloseDate = Date.today().addDays(30);
            opportunity.StageName = 'Qualification';
            opportunity.AccountId = account.Id;
            opportunitiesEnriched.add(opportunity);
        }

        try{
            this.opportunityRepository.save(opportunitiesEnriched);
        } catch (Exception e){
            throw e;
        }
    }

    public void createTaskAccountFinalConsumer( Map<String, List<Account>> accountsFinalConsumer ){

        List<Account> finalConsumerAccounts = accountsFinalConsumer.get('FinalConsumer');

        List<Task> tasksEnriched = new List<Task>();

        for (Account account : finalConsumerAccounts){

            Task task = new Task();
            task.Subject = 'FinalConsumer';
            task.WhatId = account.Id;
            task.Status = 'Not Started';
            task.Priority = 'Normal';
            tasksEnriched.add(task);
        }

        try{
            this.taskRepository.save(tasksEnriched);
        } catch (Exception e){
            throw e;
        }
    }

    public List<Account> inactiveOldAccountsWithoutTasksAndOpportunities(List<Account> accounts) {

        if ( accounts.isEmpty() ) return new List<Account>();

        List<Account> accountsToInactive = new List<Account>();

        for ( Account account : accounts ) {

            if ( this.hasOldTasksAndOpportunities(account) ) accountsToInactive.add( account );
        }

        return this.enricher.withInactive( accountsToInactive );
    }

    private Boolean hasOldTasksAndOpportunities( Account account ) {

        Boolean hasOldTasksAndOpportunities = false;

        if ( account.Tasks.isEmpty() || account.Opportunities.isEmpty() ) return hasOldTasksAndOpportunities;

        for( Task task : account.Tasks ){
            
            if( task.ActivityDate > System.today().addDays(90) ) hasOldTasksAndOpportunities = true;
        }

        for( Opportunity Opportunity : account.Opportunities ){

            if( Opportunity.StageName == 'Closed Won' && Opportunity.CloseDate > System.today().addDays(120) ) hasOldTasksAndOpportunities = true;

            if( Opportunity.StageName == 'Negotiation/Review') hasOldTasksAndOpportunities = true;
        }

        return hasOldTasksAndOpportunities;
    }

}