trigger ContactFillInterestCountry on Contact (after update) {
    //after any contact has updated
    for (Contact contact : Trigger.new) {
        String oldValue = Trigger.oldMap.get(contact.Id).Interested_Country_Region__c;
        String newValue = contact.Interested_Country_Region__c;
        //check who filled the Interested Country/Region
        if (String.isEmpty(oldValue) && String.isNotEmpty(newValue)) {
            //send email
            CoronaCasesEmailProcessor.send(contact);
        }
    }
}