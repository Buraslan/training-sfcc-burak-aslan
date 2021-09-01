/*************************************************************************************
 * @Name         : UpdatePrimaryPhoneOnContact.trigger
 * @Description  : Trigger class for Update primary phone
 * @Created By   : Burak Aslan
 * @Created Date : Aug 31, 2021
 *************************************************************************************/



trigger UpdatePrimaryPhoneOnContact on Contact (after insert, after update) {

    Map<Id, String> accountsPhone = new Map<Id, String>();
    Set<Id> getId = new Set<Id>();
 
    // Trigger Functionality
    if(Trigger.isInsert || Trigger.isUpdate) {
     
        for(Contact cont: Trigger.New) {
         
            if(cont.Is_Primary_Contact__c == true) {
             
                accountsPhone.put(cont.AccountId, cont.Phone);
                getId.add(cont.AccountId);
            }
        }
    }
 
    // Fetching the other Contact
    List<contact> cList = [SELECT id, Phone 
                            FROM Contact 
                            WHERE AccountId IN: getId Limit 1000];

    
    //Updates contacts of accounts with primary number
    if(cList.size() > 0) {

        for(Id ids: getId){

            List<Contact> conList = new List<Contact>();

            for(Contact newClst: cList) {

                newClst.Primary_Contact_Phone__c = accountsPhone.get(ids);
                conList.add(newClst);
            }
            update conList;  
        }
    }
     
}