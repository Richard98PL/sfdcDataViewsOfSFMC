public without sharing class SFMCScheduleRetrieveDataViews implements Schedulable, BatchScheduler{
    private final String BATCH_NAME = '[SFMC] - DATA VIEWS';
    public String getBatchName(){
        return this.BATCH_NAME;
    }
    public void execute(SchedulableContext sc)
    {
        Database.executeBatch(new SFMCBatchRetrieveDataViews(new SFMCRetrieveDataViewsService(false, 1, 1)));
    }

    public String getNextScheduleExecutionTime() {
        Datetime now = Datetime.newInstanceGmt(System.today(), Time.newInstance(23,59,0,0));
        now = now.addDays(1);
        now = now.addHours(-3);
        return new RepeatableController().parseDateTimeToCronExpression(now);
    }
}