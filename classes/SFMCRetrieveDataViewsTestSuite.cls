@isTest public without sharing class SFMCRetrieveDataViewsTestSuite {
    @isTest public static void parseTest(){
        SFMCRetrieveDataViewsService service = new SFMCRetrieveDataViewsService(false, 1, 1);
        Integer iterationNumbers = service.getIterationsNumbers();
        for(Integer i = 1 ; i < iterationNumbers ; i++){
            List<SFMCRetrieveDataViewsService.items> objects = service.getObjectsFromBody(body);
            for(SFMCRetrieveDataViewsService.items item : objects){
                SFMCRetrieveDataViewsService.keys key = item.keys;
                String dataViewId = key.dataviewid;
                System.assert(String.isNotBlank(dataViewId), 'Key should always be populated.');
                SFMCRetrieveDataViewsService.values value = item.values;
                System.assert(value != null, 'Value should be populated.');
            }
        }
    }

    @isTest public static void fullLoadTest(){
        Test.setMock(HttpCalloutMock.class, new SFMCMockHttpResponseGenerator(body));
        Test.startTest();
        {
            new SFMCScheduleRetrieveDataViews().execute(null);
        }
        Test.stopTest();

        System.assertEquals(1, [SELECT Id FROM SFMC_Journey__c].size(), 'Journeys should be upserted in the transaction.');
        System.assertEquals(1, [SELECT Id FROM SFMC_Subscriber__c].size(), 'Subscribers should be upserted in the transaction.');
        System.assertEquals(2, [SELECT Id FROM SFMC_Open__c].size(), 'Opens should be upserted in the transaction.');
        System.assertEquals(2, [SELECT Id FROM SFMC_Sent__c].size(), 'Sent should be upserted in the transaction.');
        System.assertEquals(2, [SELECT Id FROM SFMC_Click__c].size(), 'Click should be upserted in the transaction.');
        System.assertEquals(2, [SELECT Id FROM SFMC_Bounce__c].size(), 'Bounce should be upserted in the transaction.');
    }

    public static String body = '{\n' +
            '    "links": {\n' +
            '        "self": "/v1/customobjectdata/token/1869f189-8d37-4e8e-850a-8d36d66a8ee5/rowset?$page=1",\n' +
            '        "next": "/v1/customobjectdata/token/1869f189-8d37-4e8e-850a-8d36d66a8ee5/rowset?$page=2"\n' +
            '    },\n' +
            '    "requestToken": "1869f189-8d37-4e8e-850a-8d36d66a8ee5",\n' +
            '    "tokenExpireDateUtc": "2022-09-11T12:19:10.79",\n' +
            '    "customObjectId": "00454c26-f630-ed11-a5b9-f40343dfb5f0",\n' +
            '    "customObjectKey": "E9A7DC43-1B6B-43FE-8609-BAD85E7795C5",\n' +
            '    "pageSize": 2,\n' +
            '    "page": 1,\n' +
            '    "count": 10623,\n' +
            '    "top": 0,\n' +
            '    "items": [\n' +
            '        {\n' +
            '            "keys": {\n' +
            '                "dataviewid": "131101838261831100602022-09-0106:28:02.007"\n' +
            '            },\n' +
            '            "values": {\n' +
            '                "subscriberid": "131101838",\n' +
            '                "subscriberkey": "0032o00002uGAC1AAO",\n' +
            '                "accountid": "500009789",\n' +
            '                "oybaccountid": "",\n' +
            '                "jobid": "261831",\n' +
            '                "listid": "14617",\n' +
            '                "batchid": "1006",\n' +
            '                "eventdate": "9/1/2022 6:28:02 AM",\n' +
            '                "domain": "kozminski.edu.pl",\n' +
            '                "triggerersenddefinitionobjectid": "E5B6FC3C-9F52-EC11-B861-B883035BE891",\n' +
            '                "triggeredsendcustomerkey": "87908",\n' +
            '                "isunique": "False",\n' +
            '                "versionid": "075CA983-8E6C-4CE8-97DA-E7D6C68A6689",\n' +
            '                "journeyid": "EE96982E-070C-4E5D-88D6-541F6A706C96",\n' +
            '                "journeyname": "3_BK_Rozliczenie_Ankieta-do-Studenta",\n' +
            '                "versionnumber": "25",\n' +
            '                "createddate": "12/1/2021 6:06:21 AM",\n' +
            '                "lastpublisheddate": "12/1/2021 6:07:46 AM",\n' +
            '                "modifieddate": "12/1/2021 6:07:46 AM",\n' +
            '                "journeystatus": "Running",\n' +
            '                "journeyactivityversionid": "075CA983-8E6C-4CE8-97DA-E7D6C68A6689",\n' +
            '                "activityid": "56823358-12CC-44D2-9DD5-D3A3E69919F9",\n' +
            '                "activityname": "3_BK_Rozliczenie_Ankieta_do-Studenta_PL",\n' +
            '                "activityexternalkey": "EMAILV2-1",\n' +
            '                "journeyactivityobjectid": "E5B6FC3C-9F52-EC11-B861-B883035BE891",\n' +
            '                "activitytype": "EMAILV2",\n' +
            '                "emailaddress": "43755@kozminski.edu.pl",\n' +
            '                "status": "active"\n' +
            '            }\n' +
            '        },\n' +
            '        {\n' +
            '            "keys": {\n' +
            '                "dataviewid": "131101838261831100602022-09-0301:55:33.000"\n' +
            '            },\n' +
            '            "values": {\n' +
            '                "subscriberid": "131101838",\n' +
            '                "subscriberkey": "0032o00002uGAC1AAO",\n' +
            '                "accountid": "500009789",\n' +
            '                "oybaccountid": "",\n' +
            '                "jobid": "261831",\n' +
            '                "listid": "14617",\n' +
            '                "batchid": "1006",\n' +
            '                "eventdate": "9/3/2022 1:55:33 AM",\n' +
            '                "domain": "kozminski.edu.pl",\n' +
            '                "triggerersenddefinitionobjectid": "E5B6FC3C-9F52-EC11-B861-B883035BE891",\n' +
            '                "triggeredsendcustomerkey": "87908",\n' +
            '                "isunique": "False",\n' +
            '                "versionid": "075CA983-8E6C-4CE8-97DA-E7D6C68A6689",\n' +
            '                "journeyid": "EE96982E-070C-4E5D-88D6-541F6A706C96",\n' +
            '                "journeyname": "3_BK_Rozliczenie_Ankieta-do-Studenta",\n' +
            '                "versionnumber": "25",\n' +
            '                "createddate": "12/1/2021 6:06:21 AM",\n' +
            '                "lastpublisheddate": "12/1/2021 6:07:46 AM",\n' +
            '                "modifieddate": "12/1/2021 6:07:46 AM",\n' +
            '                "journeystatus": "Running",\n' +
            '                "journeyactivityversionid": "075CA983-8E6C-4CE8-97DA-E7D6C68A6689",\n' +
            '                "activityid": "56823358-12CC-44D2-9DD5-D3A3E69919F9",\n' +
            '                "activityname": "3_BK_Rozliczenie_Ankieta_do-Studenta_PL",\n' +
            '                "activityexternalkey": "EMAILV2-1",\n' +
            '                "journeyactivityobjectid": "E5B6FC3C-9F52-EC11-B861-B883035BE891",\n' +
            '                "activitytype": "EMAILV2",\n' +
            '                "emailaddress": "43755@kozminski.edu.pl",\n' +
            '                "status": "active"\n' +
            '            }\n' +
            '        }\n' +
            '    ]\n' +
            '}';
}