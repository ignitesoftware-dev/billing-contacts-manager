@IsTest
public with sharing class SearchContactZuoraPopupControllerTest {

    @IsTest
    static void emptySearch() {
        ApexPages.currentPage().getParameters().put('AccountId', '1234');
        SearchContactZuoraPopupController controller = new SearchContactZuoraPopupController();
        controller.searchText = '';
        controller.search();

        System.assert(controller.searchResult.isEmpty());
    }

    @IsTest
    static void nullSearch() {
        ApexPages.currentPage().getParameters().put('AccountId', '1234');
        SearchContactZuoraPopupController controller = new SearchContactZuoraPopupController();
        controller.search();
        System.assert(controller.searchResult.isEmpty());
    }

    @IsTest
    static void searchWithResult() {
        Account account = new Account(Name = 'Test', Type = 'Private Practice');
        insert account;
        Contact contact = new Contact(AccountId = account.Id, FirstName = 'Test', LastName = 'Test');
        insert contact;
        ApexPages.currentPage().getParameters().put('AccountId', account.Id);
        Test.setFixedSearchResults(new List<Id>{
                contact.Id
        });

        Test.startTest();
        SearchContactZuoraPopupController controller = new SearchContactZuoraPopupController();
        controller.searchText = 'Tes';
        controller.search();
        Test.stopTest();

        System.assertEquals(1, controller.searchResult.size());
    }

}