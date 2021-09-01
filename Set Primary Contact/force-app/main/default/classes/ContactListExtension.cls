/**
 * Description : Extension for SetPrimaryContact.page
 * Author : Burak
 * Created Date: 26.08.2021
 */


public with sharing class ContactListExtension {
 

    public Id currentContactId{get;set;}
    public String keyword{get;set;}
    public List<Contact> contacts {get;set;}
    private Id currentAccountId;
    
    
    
    public ContactListExtension(ApexPages.StandardController stdController) {   
        this.currentAccountId = stdController.getId();
        this.keyword = '';
        this.searchContacts();
        
   
    }
    //this is method for search
    public void searchContacts() {
       
        if(this.keyword == ' ') {
            return;
        }

        String searchString = '%'+String.escapeSingleQuotes(this.keyword)+'%';
        this.contacts = [SELECT Id, Name, Title, Is_Primary_Contact__c, Phone 
            FROM Contact 
            WHERE AccountId = :this.currentAccountId 
                AND Name LIKE :searchString
            LIMIT 1000];
        
    }
    //this is method for set primary contact
    public void setPrimary(){ 
        List<Contact> allContacts = [SELECT Id, Is_Primary_Contact__c 
            FROM Contact 
            WHERE AccountId = :this.currentAccountId];

        List<Contact> oldConts = new List<Contact>();
        

        for(Contact oldCon: allContacts){
            oldCon.Is_Primary_Contact__c = (oldCon.Id == currentContactId);
            
        }
        update allContacts;
        this.searchContacts();
        
    }


}