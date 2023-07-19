/*Scenario 1 : When we are trying to insert new record into object. If there is any record existing with 
same account name it should prevent duplicate record*/
public class ApexforallClass {
    public static void preventduplicate(List<Account>acclist){
        set<String>accontName = New Set <String>();
        for(Account acc:acclist){
            accontName.add(acc.Name);
            System.debug('accontName: ' + accontName);
        }
        // Query for existing accounts with the same name
        List<Account>existingaccount =[SELECT Id, Name FROM Account WHERE Name IN :accontName];
        // If any existing accounts are found, throw a custom exception
        if (existingaccount.size() > 0) {
            for (Account acc : acclist) {
                if(accontName.Contains(acc.Name)){
                    acc.Name.addError(' this Account Name already exists.');
                    
                }
            }
            
        }
    }
    /*Scenario 2: Write a trigger to prefix Account Name with ‘Mr’ when new record is inserted. and when account create related contact also created*/
    public static void prefixAccountName(List<Account>acclist){
        List<Contact>conlist = new List<Contact>();
        for(Account acc:acclist){
            //acc.Name ='Mr.'+acc.Name; 
            Contact con = new Contact ();
            con.LastName =acc.Name;
            con.Title = 'Titel';
            con.AccountId = acc.Id;
            conlist.add(con);
        }
        insert conlist;
    }
    /*  3.Contact trigger to limit an account to not have more than 2 contacts*/
    public static void preventmorecontact(List<Contact>conlist){
        set<Id> IdSet =new set<Id>();
        for(Contact cot : conlist) {
            if(cot.accountID != null) {
                IdSet.add(cot.accountId);
            }
        }
        Integer contactListCount = [Select count() from contact where accountID IN: IdSet];
        
        if(contactListCount > 2) {
            for(contact cop : conlist) {
                cop.addError('cannot have more than 2 contacts per account');
            }
        }
    }
    //STEP 1 Scenario :- If case status = new and related Account update than it will  send a email
    public static void SemdemailupdateAccount(List<Account> accList,Map<Id,Account> oldMap){
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc:accList){
            
            if(acc !=null && oldMap != null){
                if(acc.Type != oldMap.get(acc.Id).Type || acc.Phone !=oldMap.get(acc.Id).Phone||acc.Industry !=oldMap.get(acc.Id).Industry)
                {
                    accMap.put(acc.Id, acc);                
                }
            }
        }  
        List<Case> caseList = new List<Case>();
        if(!accMap.isEmpty()){
            for(Case objCon : [select Id, Status,AccountId from Case where AccountId IN : accMap.keySet()]){
                caseList.add(objCon);
            }
        }
        //STEP 3
        if(!caseList.isEmpty()){
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            for(Case objCon : caseList){
                if(accMap.containsKey(objCon.AccountId) ){
                    
                    if(objCon.Status== 'New'){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new String[] {'VarshaBopche.sfdc@gmail.com'});
                        mail.setSenderDisplayName('Testing');
                        mail.setSubject('Account Rating Updated');
                        mail.setPlainTextBody('Account Rating Updated');
                        mailList.add(mail);
                        
                    }  
                    if(!mailList.isEmpty())
                    {
                        Messaging.sendEmail(mailList);
                    }
                    
                }
            }
                      
            Database.update(caseList,false);        
        }
    }
}