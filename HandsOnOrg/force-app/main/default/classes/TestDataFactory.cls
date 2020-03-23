/**
 * @File Name          : TestDataFactory.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/16/2020, 12:10:16 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    3/12/2020   Advait Yermalkar     Initial Version
**/

public class TestDataFactory {

    public static List<Campaign> createCampaigns (
        Integer numberOfCampaigns,
		String name,
        String medium,
        String source,
		String longUrl,
		String shortUrl,
		Integer totalClicks,
		Boolean isInsert
    ) {
        List<Campaign> businessCampaigns = new List<Campaign>();

        if(longUrl == null){
            for (Integer i = 0 ; i < numberOfCampaigns ; i++) {
                businessCampaigns.add(
                    new Campaign(
                        Name = name+i
                        ,Type = medium
                        ,CampaignSource__c = source
                    )
                );
            }
            if (isInsert && !businessCampaigns.isEmpty()) {
                insert businessCampaigns;
            }

        }else{
            for (Integer i = 0 ; i < numberOfCampaigns ; i++) {
                businessCampaigns.add(
                    new Campaign(
                        Name = name+i
                        ,Type = medium
                        ,CampaignSource__c = source
                        ,LongUrl__c = longUrl
                        ,ShortUrl__c = shortUrl+i
                        ,Total_Url_Clicks__c = totalClicks
                    )
                );
            }
            if (isInsert && !businessCampaigns.isEmpty()) {
                insert businessCampaigns;
            }
        }

        return businessCampaigns;
    }
    public static List<UrlAnalytics__c> createUrlAnalyticswithDomain (
        Integer numberOfUrlAnalytics,
		String campaign,
		String domain,
		Integer clicks,
		Boolean isInsert
    ){
        List<UrlAnalytics__c> businessUrlAnalytics = new List<UrlAnalytics__c>();
        for (Integer i = 0; i < numberOfUrlAnalytics; i++) {
            businessUrlAnalytics.add(
                new UrlAnalytics__c(
                    campaign__c = campaign
					,clicks__c = clicks
					,Domain__c = domain
                )
            );
        }
        if (isInsert && !businessUrlAnalytics.isEmpty()) {
            insert businessUrlAnalytics;
        }
        return businessUrlAnalytics;
    }
    public static List<UrlAnalytics__c> createUrlAnalyticswithCountry (
        Integer numberOfUrlAnalytics,
		String campaign,
		String Country,
		Integer clicks,
		Boolean isInsert
    ){
        List<UrlAnalytics__c> businessUrlAnalytics = new List<UrlAnalytics__c>();
        for (Integer i = 0; i < numberOfUrlAnalytics; i++) {
            businessUrlAnalytics.add(
                new UrlAnalytics__c(
                    campaign__c = campaign
					,clicks__c = clicks
					,Country__c = Country
                )
            );
        }
        if (isInsert && !businessUrlAnalytics.isEmpty()) {
            insert businessUrlAnalytics;
        }
        return businessUrlAnalytics;
    }
    public static List<Country__c> createCountries (
        Integer numberOfCountries,
        String name,
        Boolean isInsert
    ){
        List<Country__c> countries = new List<Country__c>();
        for (Integer i = 0; i < numberOfCountries  ; i++) {
            countries.add(
                new Country__c (
                    Name = name+i
                )
            );
        }
        if (isInsert && !countries.isEmpty()) {
            insert countries;
        }
        return countries;
    }
    public static List<Domain__c> createDomains (
        Integer numberOfDomains,
        String name,
        Boolean isInsert
    ){
        List<Domain__c> domains = new List<Domain__c>();
        for (Integer i = 0; i < numberOfDomains  ; i++) {
            domains.add(
                new Domain__c (
                    Name = name+i
                )
            );
        }
        if (isInsert && !domains.isEmpty()) {
            insert domains;
        }
        return domains;
    }


}