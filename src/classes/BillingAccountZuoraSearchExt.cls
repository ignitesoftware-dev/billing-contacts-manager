/**
 * Created on 25/03/2019.
 */

public with sharing class BillingAccountZuoraSearchExt {

    public ApexPages.StandardSetController ctrl { get; set; }

    public String searchText { get; set; }

    public BillingAccountZuoraSearchExt(ApexPages.StandardSetController ctrl) {
        loadRecent();
    }

    public PageReference loadRecent() {
        this.ctrl = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT Id, Name, Zuora__AccountNumber__c FROM Zuora__CustomerAccount__c ORDER BY CreatedDate DESC LIMIT 1000'));
        return null;
    }

    public PageReference loadSearch() {
        this.ctrl = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT Id, Name, Zuora__AccountNumber__c FROM Zuora__CustomerAccount__c WHERE Name LIKE \'%' + searchText + '%\' OR Zuora__AccountNumber__c LIKE \'%' + searchText + '%\' ORDER BY Name LIMIT 1000'));
        return null;
    }

    public List<Zuora__CustomerAccount__c> getCustomerAccounts() {
        return (List<Zuora__CustomerAccount__c>) ctrl.getRecords();
    }

    public Integer getPages() {
        return (Integer) Math.ceil(ctrl.getResultSize() / (Double) ctrl.getPageSize());
    }
}