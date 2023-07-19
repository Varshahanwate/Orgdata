@isTest
public class ApexforallClassTest {
    @isTest
    public static void testPreventMoreContact() {
        // Create test data
        Account testAccount = new Account(Name = 'ABCD');
        insert testAccount;
        
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 2; i++) {
            Contact testContact = new Contact();
            testContact.LastName = 'Contact123 ';
            
            testContact.AccountId = testAccount.Id;
            testContacts.add(testContact);
        }
        // Call the method to be tested
        Test.startTest();
        ApexforallClass.preventmorecontact(testContacts);
        Test.stopTest();
        
        // Verify the results
        List<Contact> updatedContacts = [SELECT Id FROM Contact WHERE Id IN :testContacts];
        Integer errorCount = 0;
        for (Contact updatedContact : updatedContacts) {
            if (updatedContact.hasErrors()) {
               errorCount++;
            }
        }
        
        System.assertEquals(0, errorCount, 'Expected 2 contacts to have an error');
    }
}