@IsTest
public with sharing class ZuoraContactTest {

    @IsTest
    static void getRequest() {
        ZuoraTokenResponse token = new ZuoraTokenResponse();
        token.access_token = '890';
        HttpRequest req = ZuoraContact.getGetRequest(token, '1234');
        System.assert(String.isEmpty(req.getBody()));
        System.assert(req.getMethod() == 'GET');
        System.assert(req.getHeader('Authorization').contains(token.access_token));
        System.assert(req.getHeader('Content-Type').contains('application/json'));
        System.assert(req.getEndpoint().contains('1234'));
    }

    @IsTest
    static void updateRequest() {
        ZuoraTokenResponse token = new ZuoraTokenResponse();
        token.access_token = '890';
        ZuoraContact contact = new ZuoraContact();
        contact.FirstName = 'test';
        contact.Id = 'testId';
        HttpRequest req = contact.getUpdateRequest(token);
        System.assert(!String.isEmpty(req.getBody()));
        System.assert(req.getMethod() == 'PUT');
        System.assert(req.getHeader('Authorization').contains(token.access_token));
        System.assert(req.getHeader('Content-Type').contains('application/json'));
        System.assert(req.getEndpoint().contains(contact.Id));
    }

    @IsTest
    static void createRequest() {
        ZuoraTokenResponse token = new ZuoraTokenResponse();
        token.access_token = '890';
        ZuoraContact contact = new ZuoraContact();
        contact.FirstName = 'test';
        HttpRequest req = contact.getCreateRequest(token);
        System.assert(!String.isEmpty(req.getBody()));
        System.assert(req.getMethod() == 'POST');
        System.assert(req.getHeader('Authorization').contains(token.access_token));
        System.assert(req.getHeader('Content-Type').contains('application/json'));
    }

    @IsTest
    static void errorMessage(){
        ZuoraResponse response = new ZuoraResponse();
        response.message = 'message';
        ZuoraResponse.ZuoraError zuoraError1 = new ZuoraResponse.ZuoraError();
        zuoraError1.message = 'error1';
        ZuoraResponse.ZuoraError zuoraError2 = new ZuoraResponse.ZuoraError();
        zuoraError2.message = 'reason1';
        response.Errors = new List<ZuoraResponse.ZuoraError>{zuoraError1};
        response.reasons = new List<ZuoraResponse.ZuoraError>{zuoraError2};

        String errorMessage = response.getErrorMessage('Title');
        System.assert(errorMessage.contains('Title'));
        System.assert(errorMessage.contains('message'));
        System.assert(errorMessage.contains('error1'));
        System.assert(errorMessage.contains('reason1'));
    }

    @IsTest
    static void addressSplit_TwoLines(){
        String addr1 = 'a'.repeat(255);
        String addr2 = 'b'.repeat(255);
        String finalAddress = addr1 + addr2;

        Contact c = new Contact(MailingStreet = finalAddress);
        ZuoraContact zContact= new ZuoraContact(c, new ZuoraContact());
        System.assertEquals(addr1, zContact.Address1);
        System.assertEquals(addr2, zContact.Address2);
    }

    @IsTest
    static void addressSplit_ToLong(){
        String addr1 = 'a'.repeat(255);
        String addr2 = 'b'.repeat(255);
        String addr3 = 'c'.repeat(10);
        String finalAddress = addr1 + addr2 + addr3;

        Contact c = new Contact(MailingStreet = finalAddress);
        ZuoraContact zContact= new ZuoraContact(c, new ZuoraContact());
        System.assertEquals(addr1, zContact.Address1);
        System.assertEquals(addr2, zContact.Address2);
    }

    @IsTest
    static void addressSplit_OneLine(){
        String addr1 = 'a'.repeat(255);
        String finalAddress = addr1;

        Contact c = new Contact(MailingStreet = finalAddress);
        ZuoraContact zContact= new ZuoraContact(c, new ZuoraContact());
        System.assertEquals(addr1, zContact.Address1);
        System.assertEquals(null, zContact.Address2);
    }

    @IsTest
    static void addressSplit_NoAddress(){
        Contact c = new Contact();
        ZuoraContact zContact= new ZuoraContact(c, new ZuoraContact());
        System.assertEquals(null, zContact.Address1);
        System.assertEquals(null, zContact.Address2);
    }

    @IsTest
    static void addressSplit_EmptyAddress(){
        Contact c = new Contact(MailingStreet = '');
        ZuoraContact zContact= new ZuoraContact(c, new ZuoraContact());
        System.assertEquals('', zContact.Address1);
        System.assertEquals(null, zContact.Address2);
    }

    @IsTest
    static void getPhoneTypes(){
        List<SelectOption> phones = new ZuoraContact().getPhoneTypes();
        System.assertNotEquals(null, phones);
        System.assert(!phones.isEmpty());
    }

    @IsTest
    static void isChangedTrue(){
        ZuoraContact contact1 = new ZuoraContact();
        contact1.FirstName = 'Test';
        ZuoraContact contact2 = new ZuoraContact();
        contact2.FirstName = 'Test';
        contact2.Address1 = 'Street';
        System.assert(ZuoraContact.isChanged(contact1, contact2));
    }

    @IsTest
    static void isChangedFalse(){
        ZuoraContact contact1 = new ZuoraContact();
        contact1.FirstName = 'Test';
        contact1.Address1 = 'Street';
        ZuoraContact contact2 = new ZuoraContact();
        contact2.FirstName = 'Test';
        contact2.Address1 = 'Street';
        System.assert(!ZuoraContact.isChanged(contact1, contact2));
    }


    @IsTest
    static void isChangedFalse_EmptyString(){
        ZuoraContact contact1 = new ZuoraContact();
        contact1.FirstName = 'Test';
        ZuoraContact contact2 = new ZuoraContact();
        contact2.FirstName = 'Test';
        contact2.Address1 = '';
        System.assert(!ZuoraContact.isChanged(contact1, contact2));
    }

}