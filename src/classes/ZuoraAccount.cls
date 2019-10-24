
public with sharing class ZuoraAccount {
    public String SoldToId { get; set; }
    public String BillToId { get; set; }
    public String Id { get; set; }

    public ZuoraAccount(){}

    public ZuoraAccount(String id){
        this.Id = id;
    }

    public HttpRequest getUpdateRequest(ZuoraTokenResponse token) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:__Zuora_REST_Api/v1/object/account/' + Id);
        req.setBody(JSON.serialize(this, true));
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('PUT');
        req.setHeader('Authorization', 'Bearer ' + token.access_token);
        System.debug(req.getBody());
        return req;
    }

    public static HttpRequest getGetRequest(ZuoraTokenResponse token, String id) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:__Zuora_REST_Api/v1/object/account/' + id);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token.access_token);
        return req;
    }
}