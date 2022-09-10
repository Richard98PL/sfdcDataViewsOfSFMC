public interface BatchScheduler {
    String getNextScheduleExecutionTime();
    String getBatchName();
}