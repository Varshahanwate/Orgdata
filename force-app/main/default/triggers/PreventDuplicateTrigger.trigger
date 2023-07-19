trigger PreventDuplicateTrigger on Account (before insert, before update,After Insert ,After update) {
    // ApexforallClass.preventduplicate(Trigger.new);
    If(trigger.isbefore && trigger.isInsert){
       // ApexforallClass.preventduplicate(Trigger.new);
        //ApexforallClass.prefixAccountName(Trigger.new);
    }
    If(trigger.isAfter && trigger.isInsert){
        //ApexforallClass.preventduplicate(Trigger.new);
        //ApexforallClass.prefixAccountName(Trigger.new);
    }
    If(trigger.isbefore && trigger.isupdate){
        ApexforallClass.SemdemailupdateAccount(Trigger.new,Trigger.oldMap);
    }
    
}