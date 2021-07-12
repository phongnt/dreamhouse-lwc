@isTest
private with sharing class EmailManagerTest {
    static testMethod void testSendEmail() {
        EmailManager.sendEmail(
            'genycopedison@gmail.com',
            'Test subject',
            'Hello Edison,\n\nThis is test email.\n\nThank you,\nEdison Nguyen');
    }
}
