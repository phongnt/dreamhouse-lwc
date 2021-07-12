public class WelcomeEmailProcessor {
    public static void send() {
        for(Contact con : [SELECT Name, Email FROM Contact]) {
            if(String.isNotBlank(con.Email)) {
                EmailManager.sendEmail(con.Email, 'Explore houses at home',
                                       getEmailBody(con.Name));
            }
        }
    }
    
    private static Broker__c getBroker() {
        List<Broker__c> brokers = [SELECT Name, Phone__c FROM Broker__c];
        Integer randomNum = (Integer) (Math.random() * brokers.size());
        return brokers.get(randomNum);
    }

    private static String getEmailBody(String name) {
        Broker__c b = getBroker(); 
        String body = 'Hi ' + name + ',\n\n'
            + 'Hope you stay safe and healthy during the COVID-19.\n\n'
            + 'Still looking for houses? We are launching a new site http://www.dreamhouseapp.io/ to help you explore the houses at home. If you have any questions, feel free to contact the broker: ' + b.Name + ': ' + b.Phone__c + '\n\n'
            + 'Sincerely,\nDreamHouse Realty\n' + Date.today().format() + '\n';
        return body;
    }
}