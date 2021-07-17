public with sharing class CoronaCasesService {
    class WorldStatus {
        public Integer NewConfirmed;
        public Integer TotalConfirmed;
        public Integer NewDeaths;
        public Integer TotalDeaths;
        public Integer NewRecovered;
        public Integer TotalRecovered;
        public DateTime Updated;
    }

    class CountryStatus {
        public String Country;
        public String CountryCode;
        public Integer Confirmed;
        public Integer Active;
        public Integer Recovered;
        public Integer Deaths;
    }
    
    class Country {
        public String Country;
        public String Slug;
        public String ISO2;
    }
    
    private static Country getCountry(String countryCode) {
        HttpRequest req = new HttpRequest();
        String url = 'https://api.covid19api.com/countries';
        req.setEndpoint(url);
        req.setMethod('GET');
        try {
            Http http = new Http();
            HttpResponse response = http.send(req);    
            if (response.getStatusCode() == 200 ) {
                List<Country> countries = (List<Country>) JSON.deserialize(
                    response.getBody(), List<Country>.class);
                for (Country country : countries) {
                    if (countryCode.startsWith(country.ISO2)) {
                        return country;
                    }
                }
            }
        } catch( System.Exception e) {
            System.debug(e);
        }
        return null;
    }
    
    private static String printWorldStatus(List<WorldStatus> statuses) {
        if (statuses.size() == 0) {
            return '<div>'
                + '<p>The total stats around the globe of today:</p>'
                + '<ul>'
                + '<li>Total confirmed cases: N/A</li>'
                + '<li>New confirmed cases: N/A</li>'
                + '<li>New recovered cases: N/A</li>'
                + '<li>New deaths: N/A</li>'
                + '</ul>'
                + '</div>';
        } else {
            WorldStatus status = statuses[0];
            return '<div>'
                + '<p>The total stats around the globe of today:</p>'
                + '<ul>'
                + '<li>Total confirmed cases: ' + status.TotalConfirmed + '</li>'
                + '<li>New confirmed cases: ' + status.NewConfirmed + '</li>'
                + '<li>New recovered cases: ' + status.NewRecovered + '</li>'
                + '<li>New deaths: ' + status.NewDeaths + '</li>'
                + '</ul>'
                + '</div>';
        }
    }
    
    private static String printCountryStatus(List<CountryStatus> statuses) {
        if (statuses.size() == 0) {
            return '<p>The stats of your interested country: N/A</p>';
        } else {
            CountryStatus status = statuses[0];
            return '<div>'
                + '<p>About ' + status.Country + ':</p>'
                + '<ul>'
                + '<li>Total confirmed cases: ' + status.Confirmed + '</li>'
                + '<li>Current infected cases: ' + status.Active + '</li>'
                + '<li>Recovered cases: ' + status.Recovered + '</li>'
                + '<li>Deaths: ' + status.Deaths + '</li>'
            	+ '</ul>'
                + '</div>';
        }
    }

    public static String getCoronaCasesOfWorld(DateTime searchDate) {
        String url = 'https://api.covid19api.com/world'
            + '?from=' + searchDate.formatGmt('yyyy-MM-dd') + 'T00:00:00Z'
            + '&to=' + searchDate.formatGmt('yyyy-MM-dd\'T\'hh:00:00') + 'Z';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        //String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        //req.setHeader('Authorization', authorizationHeader);
        try {
            Http http = new Http();
            HttpResponse response = http.send(req);    
            if (response.getStatusCode() != 200 ) {
                return '<p>' + response.getStatus() + '</p>';
            } else {
                System.debug(response.getBody());
                List<WorldStatus> statuses = (List<WorldStatus>) JSON.deserialize(
                    response.getBody().replace('"Date":', '"Updated":'),
                    List<WorldStatus>.class);
                return printWorldStatus(statuses);
            }
        } catch( System.Exception e) {
            System.debug(e);
        	return '<p>Error</p>';
        }
    }

    public static String getCoronaCasesByCountry(String countryCode, DateTime searchDate) {
        Country country = getCountry(countryCode);
        if (country == null)
            return 'Not found country code ' + countryCode;
        String url = 'https://api.covid19api.com/country/' + country.Slug
            + '?from=' + searchDate.format('yyyy-MM-dd') + 'T00:00:00Z'
            + '&to=' + searchDate.formatGmt('yyyy-MM-dd\'T\'hh:00:00') + 'Z';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        //String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        //req.setHeader('Authorization', authorizationHeader);
        try {
            Http http = new Http();
            HttpResponse response = http.send(req);    
            if (response.getStatusCode() != 200 ) {
                return '<p>' + response.getStatus() + '</p>';
            } else {
                System.debug(response.getBody());
                List<CountryStatus> statuses = (List<CountryStatus>) JSON.deserialize(
                    response.getBody(), List<CountryStatus>.class);
                return printCountryStatus(statuses);
            }
        } catch( System.Exception e) {
            System.debug(e);
        	return '<p>Error</p>';
        }
    }
}