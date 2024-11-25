/**
 * @description: AccountBO
 * @author Reirysson Costa
 */
public with sharing class AccountBO {

    OpportunityRepository opportunityRepository;
    TaskRepository taskRepository;

    public AccountBO(){
        this.opportunityRepository = new OpportunityRepository();
        this.taskRepository = new TaskRepository();
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

}