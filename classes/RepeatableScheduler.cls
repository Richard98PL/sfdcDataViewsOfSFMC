public class RepeatableScheduler implements Schedulable{
    private BatchScheduler scheduler;
    public RepeatableScheduler(BatchScheduler scheduler){
        this.scheduler = scheduler;
    }

    public void execute(SchedulableContext sc)
    {
        new RepeatableController().repeat(this.scheduler);
    }
}