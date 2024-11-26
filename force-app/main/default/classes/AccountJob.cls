/**
 * @description: Schedulable Job class to inactive old accounts without tasks and opportunities
 * @author: Reirysson Costa
 */
public with sharing class AccountJob implements Schedulable {

    public static void execute(SchedulableContext context) {
        Database.executeBatch( new AccountBatch() );
    }

    public static void start() {
        System.schedule('AccountInactiveJob 8 AM', '0 0 8 ? * 2-6', new AccountJob());
        System.schedule('AccountInactiveJob 12 PM', '0 0 12 ? * 2-6', new AccountJob());
        System.schedule('AccountInactiveJob 4 PM', '0 0 16 ? * 2-6', new AccountJob());
        System.schedule('AccountInactiveJob 8 PM', '0 0 20 ? * 2-6', new AccountJob());
    }

    public static void abort() {

        List<CronTrigger> jobsToAbort = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name LIKE '%AccountInactiveJob%' LIMIT 4];

        if (jobsToAbort != null) {
            
            for(CronTrigger job : jobsToAbort){
                System.abortJob(job.Id);
                System.debug('Job aborted: ' + job.CronJobDetail.Name);
            }
        }
    }
}