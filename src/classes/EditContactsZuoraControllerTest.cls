@IsTest
public with sharing class EditContactsZuoraControllerTest {

    @TestSetup
    static void setup() {
        Account account = new Account();
        account.Name = 'TestAccount';
        insert account;
        Zuora__CustomerAccount__c bAccount = new Zuora__CustomerAccount__c();
        bAccount.Zuora__Zuora_Id__c = '1';
        bAccount.Zuora__Account__c = account.Id;
        bAccount.Name = 'Test';
        insert bAccount;
        Contact contact = new Contact(FirstName = 'Test', LastName = 'LastTest', AccountId = account.Id);
        insert contact;
    }

    @IsTest
    static void loadingAccount_Ok() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        Test.stopTest();
        System.assertNotEquals(null, controller.account);
        System.assertNotEquals(null, controller.soldToContact);
        System.assertNotEquals(null, controller.billToContact);
        System.assertNotEquals(null, controller.soldToContact.NickName);
        System.assertNotEquals(null, controller.billToContact.NickName);
    }

    @IsTest
    static void loadingAccount_ErrorAccount() {
        Zuora__CustomerAccount__c account = [
                SELECT Id,
                        Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setInternalErrorAccount();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        Test.stopTest();
        System.assertNotEquals(null, controller.account);
        System.assertNotEquals(null, controller.soldToContact);
        System.assertNotEquals(null, controller.billToContact);
    }

    @IsTest
    static void loadingAccount_ErrorContact() {
        Zuora__CustomerAccount__c account = [
                SELECT Id,
                        Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setInternalErrorContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        Test.stopTest();
        System.assertNotEquals(null, controller.account);
        System.assertNotEquals(null, controller.soldToContact);
        System.assertNotEquals(null, controller.billToContact);
    }

    @IsTest
    static void loadingAccount_ErrorWithoutBody() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setInternalErrorAccount();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        Test.stopTest();
        System.assertNotEquals(null, controller.account);
        System.assertNotEquals(null, controller.soldToContact);
        System.assertNotEquals(null, controller.billToContact);
    }

    @IsTest
    static void changeWithNewSoldTo() {
        EditContactsZuoraController controller = new EditContactsZuoraController();
        ZuoraContact oldContact = controller.soldToContact;
        controller.newSoldTo();

        System.assertNotEquals(null, controller.soldToContact);
        System.assertNotEquals(oldContact, controller.soldToContact);
    }


    @IsTest
    static void changeWithNewSoldToWithData() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkContact();
        mock.setOkAccount();
        EditContactsZuoraController controller = new EditContactsZuoraController();

        ZuoraContact oldContact = controller.soldToContact;
        controller.newSoldToWithData();

        System.assertNotEquals(null, controller.soldToContact);
        System.assertEquals(null, controller.soldToContact.Id);
        System.assertEquals(oldContact.NickName, controller.soldToContact.NickName);
    }

    @IsTest
    static void changeWithNewBillToWithData() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkContact();
        mock.setOkAccount();
        EditContactsZuoraController controller = new EditContactsZuoraController();

        ZuoraContact oldContact = controller.billToContact;
        controller.newBillToWithData();

        System.assertNotEquals(null, controller.billToContact);
        System.assertEquals(null, controller.billToContact.Id);
        System.assertEquals(oldContact.NickName, controller.billToContact.NickName);
    }


    @IsTest
    static void changeWithNewBillTo() {
        EditContactsZuoraController controller = new EditContactsZuoraController();
        ZuoraContact oldContact = controller.billToContact;
        controller.newBillTo();

        System.assertNotEquals(null, controller.billToContact);
        System.assertNotEquals(oldContact, controller.billToContact);
    }

    @IsTest
    static void changeWithExistingBillTo_Ok() {
        Contact contact = [
                SELECT Id, FirstName
                FROM Contact
                LIMIT 1
        ];
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];

        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.idToFind = contact.Id;
        controller.changeBillToContact();
        Test.stopTest();
        System.assertEquals(contact.FirstName, controller.billToContact.FirstName);
    }

    @IsTest
    static void changeWithExistingBillTo_WrongContactId() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkContact();
        mock.setOkAccount();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.idToFind = '456';
        controller.changeBillToContact();
        Test.stopTest();
        System.assertNotEquals(null, controller.billToContact);
    }

    @IsTest
    static void changeWithExistingSoldTo_Ok() {
        Contact contact = [
                SELECT Id,FirstName
                FROM Contact
                LIMIT 1
        ];
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];

        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.idToFind = contact.Id;
        controller.changeSoldToContact();
        Test.stopTest();
        System.assertEquals(contact.FirstName, controller.soldToContact.FirstName);
    }


    @IsTest
    static void changeWithExistingSoldTo_WrongContactId() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.idToFind = '456';
        controller.changeSoldToContact();
        Test.stopTest();
        System.assertNotEquals(null, controller.soldToContact);
    }

    @IsTest
    static void validateFields() {
        EditContactsZuoraController controller = new EditContactsZuoraController();
        Boolean valid = controller.validateFields();
        System.assert(!valid);
    }

    @IsTest
    static void saveToZuora_Ok() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        mock.setSuccessAccount();
        mock.setSuccessContact();
        controller.saveToZuora();
        Test.stopTest();
        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }

    @IsTest
    static void saveToZuora_OkWithChanges() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.billToContact.FirstName='newTestName';
        controller.soldToContact.FirstName='newTestName';
        controller.billToContact.Id='1';
        controller.soldToContact.Id='2';
        mock.setSuccessAccount();
        mock.setSuccessContact();
        controller.saveToZuora();
        Test.stopTest();
        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }

    @IsTest
    static void saveToZuora_OkSameId() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.billToContact.Id='sameId';
        controller.soldToContact.Id='sameId';
        controller.billToContact.FirstName='newTestName';
        mock.setSuccessAccount();
        mock.setSuccessContact();
        controller.saveToZuora();
        Test.stopTest();
        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }

    @IsTest
    static void saveToZuora_OkNewContacts() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.billToContact.Id=null;
        controller.soldToContact.Id=null;
        controller.billToContact.FirstName='newTestName';
        controller.soldToContact.FirstName='newTestName';
        mock.setSuccessAccount();
        mock.setSuccessContact();
        controller.saveToZuora();
        Test.stopTest();
        System.assert(!ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }

    @IsTest
    static void saveToZuora_ErrorContact() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.billToContact.Id=null;
        controller.billToContact.FirstName='newTestName';
        mock.setInternalErrorContact();
        controller.saveToZuora();
        Test.stopTest();
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }

    @IsTest
    static void saveToZuora_ErrorAccount() {
        Zuora__CustomerAccount__c account = [
                SELECT Id, Zuora__Zuora_Id__c
                FROM Zuora__CustomerAccount__c
                LIMIT 1
        ];
        Test.startTest();
        HttpMock mock = new HttpMock();
        Test.setMock(HttpCalloutMock.class, mock);
        ApexPages.currentPage().getParameters().put('Id', account.Id);
        mock.setOkAccount();
        mock.setOkContact();
        EditContactsZuoraController controller = new EditContactsZuoraController();
        controller.billToContact.Id=null;
        controller.billToContact.FirstName='newTestName';
        mock.setSuccessContact();
        mock.setInternalErrorAccount();
        controller.saveToZuora();
        Test.stopTest();
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }

    public class HttpMock implements HttpCalloutMock {
        HttpResponse response = new HttpResponse();
        HttpResponse responseAccount = new HttpResponse();
        Integer id = 1;

        public void setInternalErrorContact() {
            response = new HttpResponse();
            response.setStatusCode(501);
            response.setBody('{"message": "Internal Server Error"}');
        }

        public void setInternalErrorAccount() {
            responseAccount = new HttpResponse();
            responseAccount.setStatusCode(501);
            responseAccount.setBody('{"message": "Internal Server Error"}');
        }

        public void setOkAccount() {
            responseAccount = new HttpResponse();
            ZuoraAccount zc = new ZuoraAccount();

            zc.BillToId = '1';
            zc.SoldToId = '2';
            zc.Id = '1';

            responseAccount.setBody(JSON.serialize(zc));
            responseAccount.setStatusCode(200);
        }

        public void setOkContact() {
            response = new HttpResponse();
            ZuoraContact zc = new ZuoraContact();
            zc.Id = String.valueOf(id++);
            zc.NickName = 'NickName1';
            zc.FirstName = 'NickName2';
            zc.LastName = 'NickName3';
            response.setBody(JSON.serialize(zc));
            response.setStatusCode(200);
        }

        public void setSuccessAccount() {
            responseAccount = new HttpResponse();
            ZuoraResponse zuoraResponse = new ZuoraResponse();
            zuoraResponse.success = true;
            responseAccount.setBody(JSON.serialize(zuoraResponse));
            responseAccount.setStatusCode(200);
        }

        public void setSuccessContact() {
            response = new HttpResponse();
            ZuoraResponse zuoraResponse = new ZuoraResponse();
            zuoraResponse.success = true;
            response.setBody(JSON.serialize(zuoraResponse));
            response.setStatusCode(200);
        }

        public HttpResponse respond(HttpRequest request) {
            if (request.getEndpoint().endsWith('/token')) {
                ZuoraTokenResponse tResponse = new ZuoraTokenResponse();
                tResponse.access_token = '789';
                HttpResponse httpResponse = new HttpResponse();
                httpResponse.setBody(JSON.serialize(tResponse));
                httpResponse.setStatusCode(200);
                return httpResponse;
            }
            if (request.getEndpoint().contains('account')) {
                return responseAccount;
            }
            if (request.getEndpoint().contains('contact')) {
                return response;
            }
            return null;
        }
    }


}