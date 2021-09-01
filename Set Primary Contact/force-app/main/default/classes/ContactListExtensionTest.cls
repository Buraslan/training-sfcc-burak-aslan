/*************************************************************************************
 * @Name         : ContactListExtensionTest.cls
 * @Description  : Test class for ContactListExtension class
 * @Created By   : Burak
 * @Created Date : Aug 31, 2021
 *************************************************************************************/
@isTest
public class ContactListExtensionTest {
    private static Account testAccount;
    private static List<Contact> testContacts = new List<Contact>();
    private static void initData(String actionToDo) {
        switch on actionToDo {
            when 'searchContactsTestSuccess','setPrimaryTestSuccess' {
                testAccount = new Account(Name = 'testAccount');
                insert testAccount;
                testContacts = new List<Contact>();
                testContacts.add(new Contact(FirstName = 'A',LastName = 'test', AccountId = testAccount.Id));
                testContacts.add(new Contact(FirstName = 'A',LastName = 'nametest', AccountId = testAccount.Id));
                testContacts.add(new Contact(FirstName = 'A',LastName = 'nametest1', AccountId = testAccount.Id));
                testContacts.add(new Contact(FirstName = 'A',LastName = 'nametest2', AccountId = testAccount.Id));
                insert testContacts;
            }
            when 'searchContactsTestFailure','setPrimaryTestFailure' {
                testAccount = new Account(Name = 'testAccount');
                testContacts = new List<Contact>();
            }
        }
    }
    @isTest 
    static void searchContactsTestSuccess() {
        initData('searchContactsTestSuccess');
        Test.startTest();
            PageReference testPage = Page.SetPrimaryContact;
            Test.setCurrentPage(testPage);
            ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
            ContactListExtension contactController = new ContactListExtension(sc);
            contactController.contacts = testContacts;
            contactController.keyword = 'nametes';
            contactController.searchContacts(); 
        Test.stopTest();
        System.assertEquals(contactController.contacts.size(),3);
    }
    @isTest static void searchContactsTestFailure() {
        initData('searchContactsTestFailure');
        Test.startTest();
            PageReference testPage = Page.SetPrimaryContact;
            Test.setCurrentPage(testPage);
            ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
            ContactListExtension contactController = new ContactListExtension(sc);
            contactController.keyword = ' ';
            contactController.searchContacts();
        Test.stopTest();
        System.assertEquals(contactController.contacts.size(), 0);
    }
    @isTest static void setPrimaryTestSuccess() {
        initData('setPrimaryTestSuccess');
        Test.startTest();
            PageReference testPage = Page.SetPrimaryContact;
            Test.setCurrentPage(testPage);
            ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
            ContactListExtension contactController = new ContactListExtension(sc);
            contactController.contacts = testContacts;
            contactController.currentContactId = testContacts[1].Id;
            contactController.setPrimary();
        Test.stopTest();
        Contact primaryCont = [SELECT Id FROM Contact WHERE Is_Primary_Contact__c = true LIMIT 1];
        System.assertEquals(primaryCont.Id, testContacts[1].Id);

    }
    @isTest static void setPrimaryTestFailure() {
        initData('setPrimaryTestFailure');
        Test.startTest();
            PageReference testPage = Page.SetPrimaryContact;
            Test.setCurrentPage(testPage);
            ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
            ContactListExtension contactController = new ContactListExtension(sc);
            contactController.contacts = testContacts;
            contactController.currentContactId = null;
            contactController.setPrimary();
        Test.stopTest();
        List<Contact> primaryCont = [SELECT Id FROM Contact WHERE Is_Primary_Contact__c = true LIMIT 1];
        System.assertEquals(primaryCont.size(), 0);
    }
}