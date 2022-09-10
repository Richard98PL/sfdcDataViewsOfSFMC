@IsTest public class SFMCMockHttpResponseGenerator implements HttpCalloutMock {
    String body = '';
    public SFMCMockHttpResponseGenerator(String body){
        this.body = body;
    }
    public SFMCMockHttpResponseGenerator(){

    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.body);
        res.setStatusCode(200);
        return res;
    }
}