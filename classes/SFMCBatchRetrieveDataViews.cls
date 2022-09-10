public without sharing class SFMCBatchRetrieveDataViews implements Database.Batchable<SFMCRetrieveDataViewsService.items>, Database.AllowsCallouts, Repeatable, Database.Stateful{
    private SFMCRetrieveDataViewsService service;
    public SFMCBatchRetrieveDataViews(SFMCRetrieveDataViewsService service){
        this.service = service;
    }

    public Iterable<SFMCRetrieveDataViewsService.items> start(Database.BatchableContext info) {
       return service.delegateRecords();
    }

    public void execute(Database.BatchableContext info, List<SFMCRetrieveDataViewsService.items> scope) {
        service.delegateActions(scope);
    }

    public void finish(Database.BatchableContext info) {
        SFMCRetrieveDataViewsService newService = null;
        if(service.shouldRunAnother()){
            newService = new SFMCRetrieveDataViewsService(service.getFullDataLoad(), service.getIteration(), service.getPage() + 1);
            Database.executeBatch(new SFMCBatchRetrieveDataViews(newService));
        }else{
            if(service.getIteration() < service.getIterationsNumbers()){
                newService = new SFMCRetrieveDataViewsService(service.getFullDataLoad(), service.getIteration() + 1, 1);
                Database.executeBatch(new SFMCBatchRetrieveDataViews(newService));
            }else{
                //repeat(new RepeatableController(), new SFMCScheduleRetrieveDataViews());
            }
        }

    }

    public void repeat(RepeatableController controller, BatchScheduler scheduler) {
        controller.repeat(scheduler);
    }
}