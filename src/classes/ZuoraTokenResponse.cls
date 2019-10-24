public with sharing class ZuoraTokenResponse {
    public String access_token;
    String token_type;
    Integer expires_in;
    String scope;
    String jti;
    String message;

    public static ZuoraTokenResponse getSessionToken() {
        Http http = new Http();

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:__Zuora_REST_Api/oauth/token');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('client_id={!$Credential.UserName}&client_secret={!$Credential.Password}&grant_type=client_credentials');
        String jsonResponseBody = '';
        HttpResponse res = http.send(req);
        jsonResponseBody = res.getBody();
        ZuoraTokenResponse token = (ZuoraTokenResponse) JSON.deserialize(jsonResponseBody, ZuoraTokenResponse.class);

        if (res.getStatusCode() != 200 || token.access_token == null) {
            throw new ZuoraResponseException('Zuora Connection Error [' + res.getStatusCode() + '] - ' + res.getStatus() + '-' + token.message);
        }
        return token;
    }
}