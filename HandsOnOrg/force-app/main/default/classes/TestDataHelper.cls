/**
 * @File Name          : TestDataHelper.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/16/2020, 12:40:14 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    3/16/2020   Advait Yermalkar     Initial Version
**/
public class TestDataHelper {

    public static List<Campaign> fetchAllCampaigns(){
        return  [SELECT  Id
        ,Name
        ,Shorturl__c
        ,total_url_clicks__c
        ,(
            SELECT Id,Clicks__c,Domain__r.Id,Domain__r.name,Country__r.Id,Country__r.name
            FROM UrlAnalytics__r
        )
        FROM Campaign
        ORDER BY Name];
    }

    public static List<UrlAnalytics__c> fetchUrlData(){
        return [SELECT Id,campaign__c,clicks__c,country__c,Domain__c,Country__r.Name,Domain__r.Name FROM UrlAnalytics__c];
    }

    public static List<Country__c> fetchAllCountries(){
        return [Select Id,Name FROM Country__c ORDER BY Name];
    }

    public static List<Domain__c> fetchAllDomains(){
        return [Select Id,Name FROM Domain__c ORDER BY Name];
    }
}