/**
 * @description: AccountBO
 * @author Reirysson Costa
 */
public with sharing class AccountBO {

    OpportunityRepository opportunityRepository;

    public AccountBO(){
        this.opportunityRepository = new OpportunityRepository();
    }
    
    public void createOpportunityPartner( Map<String, Account> accountsPartner ){

        List<Opportunity> opportunitiesEnriched = new List<Opportunity>();

        for (Account account : accountsPartner.values()){

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
    
}