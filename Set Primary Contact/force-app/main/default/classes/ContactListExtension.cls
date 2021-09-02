/**
 * Description : Extension for SetPrimaryContact.page
 * Author : Burak
 * Created Date: 26.08.2021
 */


public with sharing class ContactListExtension {
 

    public Id currentContactId{get;set;}
    public String keyword{get;set;}
    public List<Contact> contacts {get;set;}
    public Id currentAccountId;
    public List<Contact> allContacts;
    
    
    
    public ContactListExtension(ApexPages.StandardController stdController) {   
        this.currentAccountId = stdController.getId();
        this.keyword = '';
        this.searchContacts();
        
   
    }
    //this is method for search
    public void searchContacts() {
       
        if(this.keyword == NULL) {
            return;
        }

        String searchString = '%'+String.escapeSingleQuotes(this.keyword)+'%';

        try{
            this.contacts = [SELECT Id, Name, Title, Is_Primary_Contact__c, Phone 
            FROM Contact 
            WHERE AccountId = :this.currentAccountId 
                AND Name LIKE :searchString
            LIMIT 1000];

        }catch(QueryException e){
            System.debug('Query exception hit');

        }
        
        
    }
    //this is method for set primary contact
    public void setPrimary(){ 
        
            try{
                this.allContacts = [SELECT Id, Is_Primary_Contact__c 
            FROM Contact 
            WHERE AccountId = :this.currentAccountId];

    
            }catch(QueryException e){
                System.debug('Query exception hit');
    
            }

        List<Contact> oldConts = new List<Contact>();
        

        for(Contact oldCon: allContacts){
            oldCon.Is_Primary_Contact__c = (oldCon.Id == currentContactId);
            
        }
        update allContacts;
        this.searchContacts();
        
    }


}