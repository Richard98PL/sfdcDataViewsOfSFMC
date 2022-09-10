public with sharing class SFMCRetrieveDataViewsService {
    public final String CONFIGURATION = 'Configuration';
    private Integer pageSize = 500;
    private Integer iteration = 1;
    private Boolean fullDataLoad = false;
    private Integer iterationNumbers = 4;
    private Integer count = 0;
    private Integer page = 1;

    public Integer getPage(){
        return this.page;
    }
    public Boolean shouldRunAnother(){
        return this.pageSize*(this.page) < this.count;
    }
    public Integer getIterationsNumbers(){
        return iterationNumbers;
    }
    public Integer getIteration(){
        return this.iteration;
    }
    public Boolean getFullDataLoad(){
        return this.fullDataLoad;
    }
    public SFMCRetrieveDataViewsService(Boolean fullDataLoad, Integer iteration, Integer page){
        this.iteration = iteration;
        this.fullDataLoad = fullDataLoad;
        this.page = page;
    }

    public class AuthWrapper{
        String grant_type = 'client_credentials';
        String client_id;
        String client_secret;
        public AuthWrapper(String client_id, String client_secret){
            this.client_id = client_id;
            this.client_secret = client_secret;
        }
    }

    public class AuthResponseWrapper{
        String access_token;
    }

    public String getAuthToken(){
        SFMC__mdt instance = SFMC__mdt.getInstance(CONFIGURATION);
        AuthWrapper wrapper = new AuthWrapper(instance.Client_Id__c, instance.Client_Secret__c);
        String clientId = instance.Client_Id__c;
        String authEndpoint = instance.Rest_Auth_Endpoint_Base__c;

        String method = 'POST';
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(authEndpoint);
        req.setTimeout(120000);
        req.setBody(JSON.serializePretty(wrapper));
        req.setHeader('Accept', '*/*');
        req.setHeader('Content-Type', 'application/json');

        try {
            HttpResponse res = new Http().send(req);
            if(res.getStatusCode() == 301 || res.getStatusCode() == 302)
            {
                req.setEndpoint(res.getHeader('Location'));
                res = new Http().send(req);
            }
            return ((AuthResponseWrapper) System.JSON.deserialize(res.getBody(), AuthResponseWrapper.class)).access_token;
        }catch(Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    public Iterable<items> delegateRecords() {
        String token = getAuthToken();
        if(String.isNotBlank(token) || Test.isRunningTest()){
            return getRecordsFromEndpoint(token);
        }else{
            return new List<items>();
        }
    }

    public class ResponseWrapperGeneric{
        String count;
    }

    private List<items> getRecordsFromEndpoint(String token) {
        String endpoint = getDataViewEndpoint();

        String method = 'GET';
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(endpoint);
        req.setTimeout(120000);
        req.setHeader('Accept', '*/*');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization','Bearer ' + token);

        try {
            HttpResponse res = new Http().send(req);
            if(res.getStatusCode() == 301 || res.getStatusCode() == 302)
            {
                req.setEndpoint(res.getHeader('Location'));
                res = new Http().send(req);
            }
            this.count = Integer.valueOf(((ResponseWrapperGeneric) System.JSON.deserialize(res.getBody(), ResponseWrapperGeneric.class)).count);
            return getObjectsFromBody(res.getBody());
        }catch(Exception e) {
            System.debug(e.getMessage());
        }
        return new List<items>();
    }

    @TestVisible private class keys {
        public String dataviewid;	//131101838261831100602022-09-0106:28:02.007
    }

    @TestVisible public class items {
        public keys keys;
        public values values;
    }

    @TestVisible private class values {
        public String subscriberid;	//131101838
        public String subscriberkey;	//0032o00002uGAC1AAO
        public String accountid;	//500009789
        public String oybaccountid;	//
        public String jobid;	//261831
        public String listid;	//14617
        public String batchid;	//1006
        public String eventdate;	//9/1/2022 6:28:02 AM
        public String domain;	//kozminski.edu.pl
        public String triggerersenddefinitionobjectid;	//E5B6FC3C-9F52-EC11-B861-B883035BE891
        public String triggeredsendcustomerkey;	//87908
        public String isunique;	//False
        public String versionid;	//075CA983-8E6C-4CE8-97DA-E7D6C68A6689
        public String journeyid;	//EE96982E-070C-4E5D-88D6-541F6A706C96
        public String journeyname;	//3_BK_Rozliczenie_Ankieta-do-Studenta
        public String versionnumber;	//25
        public String createddate;	//12/1/2021 6:06:21 AM
        public String lastpublisheddate;	//12/1/2021 6:07:46 AM
        public String modifieddate;	//12/1/2021 6:07:46 AM
        public String journeystatus;	//Running
        public String journeyactivityversionid;	//075CA983-8E6C-4CE8-97DA-E7D6C68A6689
        public String activityid;	//56823358-12CC-44D2-9DD5-D3A3E69919F9
        public String activityname;	//3_BK_Rozliczenie_Ankieta_do-Studenta_PL
        public String activityexternalkey;	//EMAILV2-1
        public String journeyactivityobjectid;	//E5B6FC3C-9F52-EC11-B861-B883035BE891
        public String activitytype;	//EMAILV2
        public String emailaddress;	//43755@kozminski.edu.pl
        public String status;	//active
        public String linkcontent;
        public String url;

        public String bouncecategoryid;	//3
        public String bouncecategory;	//Block bounce
        public String bouncesubcategoryid;	//1002
        public String bouncesubcategory;	//Blocked
        public String bouncetypeid;	//0
        public String bouncetype;	//immediate
        public String smtpbouncereason;	//5.5.4 (invalid command arguments) Your IP 161.71.37.115 address has a bad reputation. To unblock visit http://cloud-security.net/unblock?a=0909&b=ireneusz.golon@all-for-one.com&c=bounce-14617_html-277263027-261778-500009789-1047@bounce.email.kozminski.edu.pl&d=6&e=161.71.37.115-mx-gate07-hz1
        public String smtpmessage;	//{"Source":"MITS_LOG", "Machine":"FRA3S50MITS101"}
        public String smtpcode;	//554
    }

    public class Wrapper{
        public Integer count;	//10623
        public Integer top;	//0
        public List<items> items = new List<items>();
    }

    @TestVisible private List<items> getObjectsFromBody(String body) {
        return ((List<items>) ((Wrapper) System.JSON.deserialize(body, Wrapper.class)).items);
    }

    private String getDataViewEndpoint() {
        SFMC__mdt instance = SFMC__mdt.getInstance(CONFIGURATION);
        String endpoint = instance.Rest_Endpoint_Base__c;
        String deKey;
        switch on this.iteration {
            when 1 {
                if(this.fullDataLoad){
                    deKey = instance.All_Sents_External_Key__c;
                }else{
                    deKey = instance.Delta_Sents_External_Key__c;
                }
            }
            when 2 {
                if(this.fullDataLoad){
                    deKey = instance.All_Opens_External_Key__c;
                }else{
                    deKey = instance.Delta_Opens_External_Key__c;
                }
            }
            when 3 {
                if(this.fullDataLoad){
                    deKey = instance.All_Clicks_External_Key__c;
                }else{
                    deKey = instance.Delta_Clicks_External_Key__c;
                }
            }
            when 4 {
                if(this.fullDataLoad){
                    deKey = instance.All_Bounces_External_Key__c;
                }else{
                    deKey = instance.Delta_Bounces_External_Key__c;
                }
            }
        }
        return endpoint + '/' + deKey + '/rowset?$pageSize=' + this.pageSize + '&$page=' + this.page;
    }


    public void delegateActions(List<items> items) {
        upsert getSubscribersToUpsertFromScope(items) Subscriber_Id__c;
        upsert getJourneysToUpsertFromScope(items) Journey_Id__c;

        switch on this.iteration {
            when 1 {
                upsertSents(items);
            }
            when 2 {
               upsertOpens(items);
            }
            when 3 {
               upsertClicks(items);
            }
            when 4 {
               upsertBounces(items);
            }
        }
    }

    private void upsertBounces(List<items> scope) {
        List<SFMC_Bounce__c> results = new List<SFMC_Bounce__c>();
        for(items item : scope){
            String dataViewId = item.keys.dataviewid;
            SFMCRetrieveDataViewsService.values value = item.values;
            if(String.isBlank(value.journeyid) || String.isBlank(value.subscriberid)){
                continue;
            }
            Datetime eventDate = getDatetimeFromItems(value.eventdate);
            results.add(new SFMC_Bounce__c(
                    Journey__r = new SFMC_Journey__c(Journey_Id__c = value.journeyid),
                    Subscriber_SFMC__r = new SFMC_Subscriber__c(Subscriber_Id__c = value.subscriberid),
                    External_Key__c = dataViewId,
                    Event_Date__c = eventDate,
                    Domain__c = value.domain,
                    Activity_Name__c = value.activityname,
                    Subscriber_Id__c = value.subscriberid,
                    Subscriber_Key__c = value.subscriberkey,
                    Email_Address__c = value.emailaddress,
                    Is_Unique__c = Boolean.valueOf(value.isunique),
                    Bounce_Category__c = value.bouncecategory,
                    SMTP_Bounce_Reason__c = value.smtpbouncereason
            ));
        }
        upsert results External_Key__c;
    }

    private void upsertClicks(List<items> scope) {
        List<SFMC_Click__c> results = new List<SFMC_Click__c>();
        for(items item : scope){
            String dataViewId = item.keys.dataviewid;
            SFMCRetrieveDataViewsService.values value = item.values;
            if(String.isBlank(value.journeyid) || String.isBlank(value.subscriberid)){
                continue;
            }
            Datetime eventDate = getDatetimeFromItems(value.eventdate);
            results.add(new SFMC_Click__c(
                    Journey__r = new SFMC_Journey__c(Journey_Id__c = value.journeyid),
                    Subscriber_SFMC__r = new SFMC_Subscriber__c(Subscriber_Id__c = value.subscriberid),
                    External_Key__c = dataViewId,
                    Event_Date__c = eventDate,
                    Domain__c = value.domain,
                    Activity_Name__c = value.activityname,
                    Subscriber_Id__c = value.subscriberid,
                    Subscriber_Key__c = value.subscriberkey,
                    Email_Address__c = value.emailaddress,
                    Is_Unique__c = Boolean.valueOf(value.isunique),
                    URL__c = value.url,
                    Link_Content__c = value.linkcontent
            ));
        }
        upsert results External_Key__c;
    }

    private void upsertOpens(List<items> scope) {
        List<SFMC_Open__c> results = new List<SFMC_Open__c>();
        for(items item : scope){
            String dataViewId = item.keys.dataviewid;
            SFMCRetrieveDataViewsService.values value = item.values;
            if(String.isBlank(value.journeyid) || String.isBlank(value.subscriberid)){
                continue;
            }
            Datetime eventDate = getDatetimeFromItems(value.eventdate);
            results.add(new SFMC_Open__c(
                    Journey__r = new SFMC_Journey__c(Journey_Id__c = value.journeyid),
                    Subscriber_SFMC__r = new SFMC_Subscriber__c(Subscriber_Id__c = value.subscriberid),
                    External_Key__c = dataViewId,
                    Event_Date__c = eventDate,
                    Domain__c = value.domain,
                    Activity_Name__c = value.activityname,
                    Subscriber_Id__c = value.subscriberid,
                    Subscriber_Key__c = value.subscriberkey,
                    Email_Address__c = value.emailaddress,
                    Is_Unique__c = Boolean.valueOf(value.isunique)
            ));
        }
        upsert results External_Key__c;
    }

    private void upsertSents(List<items> scope) {
        List<SFMC_Sent__c> results = new List<SFMC_Sent__c>();
        for(items item : scope){
            String dataViewId = item.keys.dataviewid;
            SFMCRetrieveDataViewsService.values value = item.values;
            if(String.isBlank(value.journeyid) || String.isBlank(value.subscriberid)){
                continue;
            }
            Datetime eventDate = getDatetimeFromItems(value.eventdate);
            results.add(new SFMC_Sent__c(
                    Journey__r = new SFMC_Journey__c(Journey_Id__c = value.journeyid),
                    Subscriber_SFMC__r = new SFMC_Subscriber__c(Subscriber_Id__c = value.subscriberid),
                    External_Key__c = dataViewId,
                    Event_Date__c = eventDate,
                    Domain__c = value.domain,
                    Activity_Name__c = value.activityname,
                    Subscriber_Id__c = value.subscriberid,
                    Subscriber_Key__c = value.subscriberkey,
                    Email_Address__c = value.emailaddress
            ));
        }
        upsert results External_Key__c;
    }

    private Datetime getDatetimeFromItems(String eventDate) {
        Datetime result = null;
        if(String.isNotBlank(eventDate)){
            try{
                String firstPart = eventDate.split(' ')[0];
                String month = firstPart.split('/')[0];
                String day = firstPart.split('/')[1];
                String year = firstPart.split('/')[2];

                String secondPart = eventDate.split(' ')[1];

                result = DateTime.valueOf(year + '-' + month + '-' + day + ' ' + secondPart);
            }catch(Exception e){
                System.debug(e.getMessage());
            }
        }
        return result;
    }

    private List<SFMC_Subscriber__c> getSubscribersToUpsertFromScope(List<items> scope) {
        Map<String, SFMC_Subscriber__c> resultMap = new Map<String, SFMC_Subscriber__c>();
        for(items item : scope){
            SFMCRetrieveDataViewsService.values value = item.values;
            String key = value.subscriberid;
            if(String.isBlank(key)){
                continue;
            }
            resultMap.put(key, new SFMC_Subscriber__c(
                    Subscriber_Id__c = key,
                    Subscriber_Key__c = value.subscriberkey,
                    Email_Address__c = value.emailaddress,
                    Name = value.emailaddress,
                    Status__c = value.status
            ));
        }
        return resultMap.values();
    }

    private List<SFMC_Journey__c> getJourneysToUpsertFromScope(List<items> scope) {
        Map<String, SFMC_Journey__c> resultMap = new Map<String, SFMC_Journey__c>();
        for(items item : scope){
            SFMCRetrieveDataViewsService.values value = item.values;
            String key = value.journeyid;
            if(String.isBlank(key)){
                continue;
            }
            resultMap.put(value.journeyid, new SFMC_Journey__c(
                    Name = value.journeyname,
                    Journey_Status__c = value.status,
                    Journey_Id__c = value.journeyid
            ));
        }
        return resultMap.values();
    }
}