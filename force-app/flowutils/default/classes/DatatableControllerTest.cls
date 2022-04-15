@IsTest
private with sharing class DatatableControllerTest {

    @TestSetup
    private static void setup(){
        Account a1 = new Account(Name='Test1',
                AccountNumber='1',
                AnnualRevenue=1000000,
                Website='https://trailblazer.me/id/ericsmith',
                Type='Type1',
                Description='D1');
        insert a1;

        Account a2 = new Account(Name='Test2',
                AccountNumber='2',
                AnnualRevenue=2000000,
                Website='https://ericsplayground.wordpress.com/blog/',
                Type='Type2',
                Description='D2');
        insert a2;
    }

    @IsTest
    static void test() {
        Account[] accts = [SELECT Id, Name, OwnerId FROM Account];
        String fieldnames = 'Name, Id, OwnerId, AccountNumber, Website, Type, Description, IsDeleted, CreatedDate, AnnualRevenue, Fax, LastActivityDate, NumberOfEmployees, ShippingLongitude';
        Boolean suppress = false;
        String testResponse = DatatableController.getReturnResults(accts, fieldnames, suppress);
        System.assert(testResponse.contains('"noEditFieldList":['));
        System.assert(testResponse.contains('"lookupFieldList":["OwnerId"]'));

        String testCPEResponse = DatatableController.getCPEReturnResults('Account');
        
        Account[] empty = [SELECT Id, Name, OwnerId FROM Account WHERE Name='NotInAccounts'];
        String testEmpty = DatatableController.getReturnResults(empty, fieldnames, suppress);
        System.assert(testEmpty.contains('"objectName":"EmptyCollection"'));
    }

    @IsTest
    private static void testUnknownFieldException() {
        String fieldNames = 'Id, Name, BogusField';
        String assert = '';
        Boolean suppress = false;
        List<Account> accts = [SELECT Id, Name, OwnerId FROM Account];

        try {
            DatatableController.getReturnResults(accts, fieldNames, suppress);
        } catch (Exception ex) {
            assert = ex.getMessage();
        }

        System.assertEquals('Could not find the field: BogusField on the object Account', assert);
    }

    @IsTest
    private static void testMultiCurrency() {
        String fieldNames = 'Id, Name, AnnualRevenue';
        List<Account> accts = [SELECT Id, Name, OwnerId FROM Account];
        Boolean suppress = false;
        DatatableController.isMultiCurrencyOrganization = true;
        String testResponse = DatatableController.getReturnResults(accts, fieldNames, suppress);
        System.assert(testResponse.contains('"AnnualRevenue":1000000'));
    }

    @IsTest
    private static void testGetNameUniqueField() {
        System.assertEquals('Name', DatatableController.getNameUniqueField('Account'));
        System.assertEquals('Name', DatatableController.getNameUniqueField('Contact'));
        System.assertEquals('OrderItemNumber', DatatableController.getNameUniqueField('OrderItem'));
        System.assertEquals('Subject', DatatableController.getNameUniqueField('Task'));
        System.assertEquals('CaseNumber', DatatableController.getNameUniqueField('Case'));
    }

    @IsTest
    private static void testGetIconName() {
        System.assertEquals('standard:account', DatatableController.getIconName('Account'));
        System.assertEquals('standard:contact', DatatableController.getIconName('Contact'));
    }

}