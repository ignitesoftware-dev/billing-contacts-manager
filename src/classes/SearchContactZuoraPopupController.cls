public with sharing class SearchContactZuoraPopupController {
    public String searchText { get; set; }
    public List<Contact> searchResult { get; set; }

    public SearchContactZuoraPopupController() {
        searchResult = [
                SELECT
                        Id,
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
                WHERE AccountId = :ApexPages.currentPage().getParameters().get('AccountId')
                LIMIT 50
        ];
    }

    public void search() {
        String searchString = '*' + searchText + '*';
        String accountId = ApexPages.currentPage().getParameters().get('AccountId');
        try {
            List<List<Contact>> result = [
                    FIND :searchString
                    IN ALL FIELDS
                            RETURNING Contact( Id,
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
                            WHERE AccountId = :accountId
                    )
                    LIMIT 50
            ];
            searchResult = result[0];
        } catch (SearchException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
}