public with sharing class CoronaCasesEmailProcessor {
    public static void send(Contact con) {
        if (String.isNotBlank(con.Email) && String.isNotBlank(con.Interested_Country_Region__c)) {
            EmailManager.sendEmail(con.Email, 'Explore your favorite country\'s house',
                                   getEmailBody(con.Name, con.Interested_Country_Region__c));
        }
    }

    public static void sendAll() {
        for (Contact con : [SELECT Name, Email FROM Contact]) {
            send(con);
        }
    }
    
    private static Broker__c getBroker() {
        List<Broker__c> brokers = [SELECT Name, Phone__c FROM Broker__c];
        Integer randomNum = (Integer) (Math.random() * brokers.size());
        return brokers.get(randomNum);
    }

    private static String getEmailBody(String name, String country) {
        Broker__c b = getBroker(); 
        String body = 'Hi ' + name + ',\n\n'
            + 'Thanks for your interest in the property of ' + country + '. We kindly send you the latest Corona cases of ' + Date.today().format() + '.\n\n'
            + '<The total stats around the globe of today>\n\n'
            + '<The stats of his/her interested country/region of today>\n\n'
            + 'We are launching a new site http://www.dreamhouseapp.io/ to help you explore the houses at home. If you have any questions, feel free to contact the broker: ' + b.Name + ': ' + b.Phone__c + '\n\n'
            + 'Hope you stay safe and healthy.\n\n'
            + 'Sincerely,\nDreamHouse Realty\n' + Date.today().format() + '\n';
        return body;
    }
}