public with sharing class EditContactsZuoraController {
    public ZuoraAccount account { get; set; }
    public ZuoraContact soldToContact { get; set; }
    public ZuoraContact billToContact { get; set; }
    private ZuoraContact soldToContactOriginal { get; set; }
    private ZuoraContact billToContactOriginal { get; set; }
    public Zuora__CustomerAccount__c bAccount { get; set; }
    public String idToFind { get; set; } // set by js after close search window

    public EditContactsZuoraController() {
        Id bAccId = ApexPages.currentPage().getParameters().get('Id');
        try {
            bAccount = [
                    SELECT Name, Id, Zuora__Zuora_Id__c, Zuora__Account__c
                    FROM Zuora__CustomerAccount__c
                    WHERE Id = :bAccId
            ];
        } catch (Exception e) {
            addMessage(ApexPages.Severity.ERROR, 'Error Account not exists');
        }

        //retrieve account and contacts from zuora
        loadContactsAndAccount(true);
    }

    private void loadContactsAndAccount(Boolean sync) {
        account = new ZuoraAccount();
        soldToContact = new ZuoraContact();
        billToContact = new ZuoraContact();
        try {
            ZuoraTokenResponse token = ZuoraTokenResponse.getSessionToken();
            account = getAccount(bAccount.Zuora__Zuora_Id__c, token);
            billToContact = getContact(account.BillToId, token);
            soldToContact = getContact(account.SoldToId, token);
            if (sync) {
                scheduleZuoraSync();
            }
        } catch (Exception e) {
            addMessage(ApexPages.Severity.ERROR, 'Error retrieving Account or Contact: ' + e.getMessage());
        }

        soldToContactOriginal = soldToContact.copy();
        billToContactOriginal = billToContact.copy();
    }

    private void scheduleZuoraSync() {
        if (!Test.isRunningTest()) {
            try {
                Zuora.OnDemandSyncManager syncManager = new Zuora.OnDemandSyncManager();
                syncManager.emailNotificationEnabled = false;
                syncManager.syncObjectIdSet = new Set<Id>{
                        bAccount.Id
                };
                List<Zuora.SyncResult> result = syncManager.sendRequest();
                for (Zuora.SyncResult syncResult : result) {
                    if (syncResult.success) {
                        addMessage(ApexPages.Severity.INFO, syncResult.statusMessage);
                    } else {
                        addMessage(ApexPages.Severity.ERROR, syncResult.statusMessage);
                    }
                }
            } catch (Exception e) {
                ApexPages.addMessages(e);
            }
        }
    }

    private void addMessage(ApexPages.Severity severity, String message) {
        ApexPages.addMessage(new ApexPages.Message(severity, message));
    }

    @TestVisible
    private Boolean validateFields() {
        Boolean hasErrors = false;
        if (String.isBlank(soldToContact.FirstName)) {
            addMessage(ApexPages.Severity.ERROR, 'First Name is required');
            hasErrors = true;
        }

        if (String.isBlank(soldToContact.LastName)) {
            addMessage(ApexPages.Severity.ERROR, 'Last Name is required');
            hasErrors = true;
        }

        if (String.isBlank(billToContact.FirstName)) {
            addMessage(ApexPages.Severity.ERROR, 'First Name is required');
            hasErrors = true;
        }

        if (String.isBlank(billToContact.LastName)) {
            addMessage(ApexPages.Severity.ERROR, 'Last Name is required');
            hasErrors = true;
        }

        return !hasErrors;
    }

    public PageReference saveToZuora() {
        if (!validateFields()) return null;
        try {
            ZuoraTokenResponse token = ZuoraTokenResponse.getSessionToken();
            Boolean accountNeedUpdate = false;
            ZuoraAccount accountUpdate = new ZuoraAccount(bAccount.Zuora__Zuora_Id__c);
            if (soldToContact.Id == billToContact.Id && soldToContact.Id != null) {
                //if contact bill to and sold to are the same, then update only bill to contact.
                executeContactRequest(billToContact.getUpdateRequest(token), 'Bill To and Sold To Contact');
            } else {
                if (ZuoraContact.isChanged(soldToContact, soldToContactOriginal)) {
                    if (soldToContact.Id != null) { // if id is null we need to create ne contact
                        executeContactRequest(soldToContact.getUpdateRequest(token), 'Contact Sold To');
                    } else {
                        accountUpdate.SoldToId = executeContactRequest(soldToContact.getCreateRequest(token), 'Contact Sold To');
                        accountNeedUpdate = true; // we need to update account because new contact has been created. (Contact Id has been changed.)
                    }
                }
                if (ZuoraContact.isChanged(billToContact, billToContactOriginal)) {
                    if (billToContact.Id != null) { // if id is null we need to create ne contact
                        executeContactRequest(billToContact.getUpdateRequest(token), 'Contact Bill To');
                    } else {
                        accountUpdate.BillToId = executeContactRequest(billToContact.getCreateRequest(token), 'Contact Bill To');
                        accountNeedUpdate = true; // we need to update account because new contact has been created. (Contact Id has been changed.)
                    }
                }
            }
            if (accountNeedUpdate) {
                executeContactRequest(accountUpdate.getUpdateRequest(token), 'Account');
            }
            if(!ApexPages.hasMessages(ApexPages.Severity.ERROR)) {
                loadContactsAndAccount(true); //load contacts after changes to keep form in sync.
            }
        }catch (Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }


    private String executeContactRequest(HttpRequest request, String name) {
        String contactId = null;
        try {
            HttpResponse response = new Http().send(request);
            ZuoraResponse zuoraResponse = (ZuoraResponse) JSON.deserialize(response.getBody(), ZuoraResponse.class);
            if (response.getStatusCode() == 200 && zuoraResponse.success) {
                addMessage(ApexPages.Severity.CONFIRM, name + ' updated.');
                contactId = zuoraResponse.Id;
            } else {
                addMessage(ApexPages.Severity.ERROR, zuoraResponse.getErrorMessage('Error during update ' + name));
            }
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        return contactId;
    }

    private Contact findContact(String id) {
        return [
                SELECT Id,
                        MailingStreet,
                        MailingCity,
                        MailingCountry,
                        Fax,
                        FirstName,
                        LastName,
                        HomePhone,
                        MobilePhone,
                        OtherPhone,
                        MailingPostalCode,
                        MailingState,
                        Email,
                        Phone
                FROM Contact
                WHERE Id = :id
        ];
    }

    public void changeSoldToContact() {
        try {
            if (soldToContact.Id == billToContact.Id && soldToContact.Id != null) {
                return;// Can't replace sold to contact when bill to contact is the same.
            }
            soldToContact = new ZuoraContact(findContact(idToFind), soldToContact);
        } catch (QueryException e) {
            addMessage(ApexPages.Severity.ERROR, 'Error during loading sold to contact');
        }
    }

    public void changeBillToContact() {
        try {
            billToContact = new ZuoraContact(findContact(idToFind), billToContact);
        } catch (QueryException e) {
            addMessage(ApexPages.Severity.ERROR, 'Error during loading bill to contact');
        }
    }

    public PageReference newSoldTo() {
        String accountId = soldToContact.AccountId;
        soldToContact = new ZuoraContact();
        soldToContact.AccountId = accountId;
        return null;
    }

    public PageReference newBillTo() {
        String accountId = billToContact.AccountId;
        billToContact = new ZuoraContact();
        billToContact.AccountId = accountId;
        return null;
    }

    public PageReference newBillToWithData() {
        billToContact = billToContact.copy();
        billToContact.Id = null;
        return null;
    }

    public PageReference newSoldToWithData() {
        soldToContact = soldToContact.copy();
        soldToContact.Id = null;
        return null;
    }

    private ZuoraAccount getAccount(String id, ZuoraTokenResponse token) {
        HttpResponse response = new Http().send(ZuoraAccount.getGetRequest(token, id));
        if (response.getStatusCode() != 200) {
            ZuoraResponse error = (ZuoraResponse) JSON.deserialize(response.getBody(), ZuoraResponse.class);
            addMessage(ApexPages.Severity.ERROR, error.getErrorMessage('Error during load account: '));
            throw new ZuoraResponseException();
        }
        return (ZuoraAccount) JSON.deserialize(response.getBody(), ZuoraAccount.class);
    }

    private ZuoraContact getContact(String id, ZuoraTokenResponse token) {
        HttpResponse response = new Http().send(ZuoraContact.getGetRequest(token, id));
        if (response.getStatusCode() != 200) {
            ZuoraResponse error = (ZuoraResponse) JSON.deserialize(response.getBody(), ZuoraResponse.class);
            addMessage(ApexPages.Severity.ERROR, error.getErrorMessage('Error during load contact: '));
            throw new ZuoraResponseException();
        }
        return (ZuoraContact) JSON.deserialize(response.getBody(), ZuoraContact.class);
    }
}