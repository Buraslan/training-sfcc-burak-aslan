/**
 * Description : extention for SetPrimaryContact.page
 * Author : Burak
 * Created Date : 
 */
public with sharing class ContactListExtension {
    //constants
    //public variables
    //private variables
    //constructor
    //public methods
    //private methods
    
    // ALL Queries and DML (insert/update/delete) have to be in try/catch
    // when you catch exception - add ApexPages.addPageMessage();
    private Id currentAccountId;
    public String keyword{get;set;}
    public List<Contact> contacts {get;set;}

    
    public ContactListExtension(ApexPages.StandardController stdController) {   
        this.currentAccountId = stdController.getId();
        this.keyword = '';
        this.searchContacts();
    }

    //this is method for search
    public void searchContacts() {
        //read about difference between String.isBlank() and String.isEmpty();
        if(this.keyword == NULL) {
            return;
        }

        String searchString = '%'+String.escapeSingleQuotes(this.keyword)+'%';
        this.contacts = [SELECT Id, Name, Title, Is_Primary_Contact__c, Phone 
            FROM Contact 
            WHERE AccountId = :this.currentAccountId 
                AND Name LIKE :searchString
            LIMIT 1000];
        
    }
}
