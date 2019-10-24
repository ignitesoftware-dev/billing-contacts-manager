@IsTest
public with sharing class BillingAccountZuoraSearchExtTest {

    @TestSetup
    static void setup() {
        Account account = new Account(Name='Test Account');
        insert account;
        Zuora__CustomerAccount__c z1 = new Zuora__CustomerAccount__c(Name = 'Test', Zuora__Zuora_Id__c = '1', Zuora__Account__c = account.Id);
        Zuora__CustomerAccount__c z2 = new Zuora__CustomerAccount__c(Name = 'Name', Zuora__Zuora_Id__c = '1', Zuora__Account__c = account.Id);
        insert new List<Zuora__CustomerAccount__c>{
                z1, z2
        };
    }

    @IsTest
    static void loadSearch_NullSearch() {
        Boolean hasException = false;
        try {
            ApexPages.StandardSetController stdc = new ApexPages.StandardSetController(new List<Zuora__CustomerAccount__c>());
            BillingAccountZuoraSearchExt ctrl = new BillingAccountZuoraSearchExt(stdc);
            ctrl.loadSearch();
        } catch (Exception e) {
            System.debug(e);
            hasException = true;
        }
        System.assert(!hasException);
    }

    @IsTest
    static void loadRecent() {
        ApexPages.StandardSetController stdc = new ApexPages.StandardSetController(new List<Zuora__CustomerAccount__c>());
        BillingAccountZuoraSearchExt ctrl = new BillingAccountZuoraSearchExt(stdc);
        ctrl.loadRecent();
        System.assertEquals(2, ctrl.getCustomerAccounts().size());
    }

    @IsTest
    static void loadSearch() {
        ApexPages.StandardSetController stdc = new ApexPages.StandardSetController(new List<Zuora__CustomerAccount__c>());
        BillingAccountZuoraSearchExt ctrl = new BillingAccountZuoraSearchExt(stdc);
        ctrl.searchText = 'Name';
        ctrl.loadSearch();
        System.assertEquals(1, ctrl.getCustomerAccounts().size());
    }

    @IsTest
    static void getPages() {
        Account account = [
                SELECT Id
                FROM Account
                LIMIT 1
        ];
        List<Zuora__CustomerAccount__c> customerAccounts = new List<Zuora__CustomerAccount__c>();
        for (Integer i = 0; i < 24; i++) {
            customerAccounts.add(new Zuora__CustomerAccount__c(Name = 'Test' + i, Zuora__Zuora_Id__c = '1', Zuora__Account__c = account.Id));
        }
        insert customerAccounts;
        ApexPages.StandardSetController stdc = new ApexPages.StandardSetController(new List<Zuora__CustomerAccount__c>());
        BillingAccountZuoraSearchExt ctrl = new BillingAccountZuoraSearchExt(stdc);
        System.assertEquals(2, ctrl.getPages());
    }
}