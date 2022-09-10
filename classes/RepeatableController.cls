public with sharing class RepeatableController{
    public void repeat(BatchScheduler scheduler){
        try{
            List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger
            WHERE CronJobDetail.Name = :scheduler.getBatchName()];
            if(!cronTriggers.isEmpty()){
                for(CronTrigger cronTrigger : cronTriggers){
                    System.abortJob(cronTrigger?.Id);
                }
            }
            schedule(scheduler, scheduler.getNextScheduleExecutionTime());
        }catch(Exception e){
            System.debug(e);
            retry(scheduler);
        }
    }

    public void schedule(BatchScheduler scheduler, String scheduledTime){
        System.debug(scheduledTime);
        System.schedule(
                scheduler.getBatchName(),
                scheduledTime,
                (Schedulable) scheduler);
    }

    public void retry(BatchScheduler scheduler){
        System.schedule(
                scheduler.getBatchName() + '_RETRY_' + String.valueOf(System.now()),
                parseDateTimeToCronExpression(System.now().addMinutes(5)),
                new RepeatableScheduler(scheduler)
        );
    }

    public String parseDateTimeToCronExpression(Datetime datetimeInstance) {
        System.debug(datetimeInstance);
        return  '0 ' +
                String.valueOf(datetimeInstance.minute()) +
                ' ' +
                String.valueOf(datetimeInstance.hour()) +
                ' ' +
                String.valueOf(datetimeInstance.day()) +
                ' ' +
                String.valueOf(datetimeInstance.month()) +
                ' ?' +
                ' ' +
                String.valueOf(datetimeInstance.year());
    }
}