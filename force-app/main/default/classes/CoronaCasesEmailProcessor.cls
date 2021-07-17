public with sharing class CoronaCasesEmailProcessor {
    public static void send(Contact con) {
        if (String.isNotBlank(con.Email) && String.isNotBlank(con.Interested_Country_Region__c)) {
            EmailManager.sendEmail(con.Email, 'Explore your favorite country\'s house',
                                   getEmailBody(con.Name, con.Interested_Country_Region__c));
        }
    }

    @future(callout=true)
    public static void sendLatestUpdated() {
        for (Contact con : [SELECT Name, Email, Interested_Country_Region__c FROM Contact ORDER BY LastModifiedDate DESC]) {
            send(con);
            break;
        }
    }

    @future(callout=true)
    public static void sendAll() {
        for (Contact con : [SELECT Name, Email, Interested_Country_Region__c FROM Contact]) {
            send(con);
        }
    }
    
    private static Broker__c getBroker() {
        List<Broker__c> brokers = [SELECT Name, Phone__c FROM Broker__c];
        Integer randomNum = (Integer) (Math.random() * brokers.size());
        return brokers.get(randomNum);
    }

    public static String getEmailBody(String name, String country) {
        Broker__c b = getBroker(); 
        String body = '<body>'
            + '<p>Hi ' + name + ',</p>'
            + '<p>We kindly send you the latest Corona cases of ' + Date.today().format() + '.</p>'
            + CoronaCasesService.getCoronaCasesOfWorld(DateTime.now())
            + CoronaCasesService.getCoronaCasesByCountry(country, DateTime.now())
            + '<p>We are launching a new site http://www.dreamhouseapp.io/ to help you explore the houses at home. If you have any questions, feel free to contact the broker: ' + b.Name + ': ' + b.Phone__c + '</p>'
            + '<p>Hope you stay safe and healthy.<br>'
            + 'Sincerely,<br>DreamHouse Realty<br>' + Date.today().format() + '</p>'
            + '</body>';
        return body;
    }
}