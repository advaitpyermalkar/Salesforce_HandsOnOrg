/**
 * @File Name          : CampaignUrlAnalysisControllerTest.cls
 * @Description        : test class For CampaignUrlAnalysisController
 * @Author             : Advait.Yermalkar@asus.com
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/16/2020, 6:51:50 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    9/3/2020   Advait.Yermalkar@asus.com     Initial Version
**/
@isTest
public class CampaignUrlAnalysisControllerTest {
    @TestSetup
    static void makeData(){
        Tokens__c newToken = new Tokens__c(
            Name = 'Bitly'
            ,AccessToken__c = '3c094a629e4ac4b658101bf0ab49ea74e49f0f5e'
            ,baseUrl__c = 'https://api-ssl.bitly.com');
        insert newToken;

        List<CampaignReportId__c> campaignIdList = new List<CampaignReportId__c>{
            new CampaignReportId__c (Name = 'Click Summary Report', Id__c = '00O2w000002EKpeEAG'),
            new CampaignReportId__c (Name = 'Country Summary Report', Id__c = '00O2w000002EKpeEAG'),
            new CampaignReportId__c (Name = 'Domain Summary Report', Id__c = '00O2w000002EKpeEAG')
        };
        insert campaignIdList;
        List<Campaign> campaignList = TestDataFactory.createCampaigns(2,'Test Campaign','Email','google','http://google.com','http://bit.ly/32xN22d',0,false);
        campaignList.addAll(
            TestDataFactory.createCampaigns(1,'Odd Campaign','Email','google',null,null,null,false)
        );
        insert campaignList;
        System.assertEquals(3, campaignList.size());

        List<Country__c> countryList = TestDataFactory.createCountries(2,'Country',true);
        List<Domain__c> domainList = TestDataFactory.createDomains(2,'Domain',true);
        System.assertEquals(2, countryList.size());
        System.assertEquals(2, domainList.size());
        List<UrlAnalytics__c> urlDataList = new List<UrlAnalytics__c>();
        for(Country__c country : countryList){
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithCountry(1,campaignList[0].Id,country.Id,2,false)
            );
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithCountry(1,campaignList[0].Id,country.Id,3,false)
            );
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithCountry(1,campaignList[1].Id,country.Id,10,false)
            );
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithCountry(1,campaignList[1].Id,country.Id,5,false)
            );
        }
        for(Domain__c domain : domainList ){
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithDomain(1,campaignList[0].Id,domain.Id,14,false)
            );
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithDomain(1,campaignList[0].Id,domain.Id,3,false)
            );
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithDomain(1,campaignList[1].Id,domain.Id,9,false)
            );
            urlDataList.addAll(
                TestDataFactory.createUrlAnalyticswithDomain(1,campaignList[1].Id,domain.Id,6,false)
            );
        }
        Database.insert(urlDataList,false);
        System.assertEquals(16, urlDataList.size());
    }
    /*
    Constructor test
    */
    @isTest
    public static void constructor_positive_test(){

        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
        System.test.stopTest();

        System.assertEquals( 2 , customController.allCountriesMap.size());
        System.assertEquals( 2 , customController.allDomainsMap.size());
        System.assertEquals( 2 , customController.releventCampaignMap.size());
        System.assertEquals( 2 , customController.campaignList.size());
        System.assert(customController.showNoReport);
    }
    @isTest
    public static void changeOption_positive_test(){
        List<Campaign> campaignList = TestDataHelper.fetchAllCampaigns();
        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            customController.selectedLink = campaignList[1].Id+'|'+ campaignList[1].shortUrl__c;
            customController.changeOptions();
        System.test.stopTest();
        //List Size assertions
        System.assertEquals( 2 , customController.allCountriesMap.size());
        System.assertEquals( 2 , customController.allDomainsMap.size());
        System.assertEquals( 2 , customController.byCountryRecordMap.size());
        System.assertEquals( 2 , customController.byDomainRecordMap.size());
        System.assertEquals( 2 , customController.releventCampaignMap.size());
        System.assertEquals( 2 , customController.campaignList.size());
        System.assert(customController.showNoReport);
        //Variable Assertions
        System.assertEquals( 'bit.ly/32xN22d0' , customController.shortUrl);
        System.assertEquals( 'http://bit.ly/32xN22d0' , customController.linkHttp);
        System.assertEquals( campaignList[1].Id , customController.currCampaignId);
        System.assertEquals( campaignList[1].Id , customController.selectedCampaign.Id);
    }
    @isTest
    public static void changeOption_negative_test(){

        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            customController.changeOptions();
        System.test.stopTest();

        System.assertEquals( 2 , customController.allCountriesMap.size());
        System.assertEquals( 2 , customController.allDomainsMap.size());
        System.assertEquals( null , customController.byCountryRecordMap);
        System.assertEquals( null , customController.byDomainRecordMap);
        System.assertEquals( 2 , customController.releventCampaignMap.size());
        System.assertEquals( 2 , customController.campaignList.size());
        System.assert(customController.showNoReport);
        System.assertEquals( '' , customController.reportId );
    }
    @isTest
    public static void getLinks_positive_test(){

        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            List<SelectOption> optionList = customController.getAllLinks();
        System.test.stopTest();

        System.assertEquals(3, optionList.size());
    }
    @isTest
    public static void splitter_positive_test(){
        List<Campaign> campaignList = TestDataHelper.fetchAllCampaigns();

        System.test.startTest();
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            List<String> actualString = customController.splitter( campaignList[1].Id + '|' + campaignList[1].shorturl__c );
        System.test.stopTest();
        List<String> expectedString = new List<String>{campaignList[1].Id,'http://bit.ly/32xN22d0','bit.ly/32xN22d0' };
        System.assertEquals(expectedString, actualString);
    }
    @isTest
    public static void splitter_negative_test(){

        System.test.startTest();
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            List<String> actualString = customController.splitter( '' );
        System.test.stopTest();
        System.assertEquals(new List<String>(), actualString);
    }
    @isTest
    public static void showReports_positive_test(){
        String expectedFilter = '[{column:\'Campaign.ShortUrl__c\', operator:\'equals\', value:\'http://bit.ly/32xN22d0\'}]';
        List<Campaign> campaignList = TestDataHelper.fetchAllCampaigns();
        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            customController.selectedLink = campaignList[1].Id+'|'+ campaignList[1].shortUrl__c;
            customController.changeOptions();

            customController.radio = '1';
            customController.showReports();
            System.assertEquals(expectedFilter, customController.filter);
            System.assertEquals(CampaignReportId__c.getValues('Click Summary Report').Id__c, customController.reportId);
            System.assert(!customController.showNoReport);

            customController.radio = '2';
            customController.showReports();
            System.assertEquals(expectedFilter, customController.filter);
            System.assertEquals(CampaignReportId__c.getValues('Country Summary Report').Id__c, customController.reportId);
            System.assert(!customController.showNoReport);

            customController.radio = '3';
            customController.showReports();
            System.assertEquals(expectedFilter, customController.filter);
            System.assertEquals(CampaignReportId__c.getValues('Domain Summary Report').Id__c, customController.reportId);
            System.assert(!customController.showNoReport);

        System.test.stopTest();
    }
    @isTest
    public static void showReports_negative_test(){
        String expectedFilter = '[{column:\'Campaign.ShortUrl__c\', operator:\'equals\', value:\'http://bit.ly/32xN22d0\'}]';
        List<Campaign> campaignList = TestDataHelper.fetchAllCampaigns();
        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            customController.selectedLink = '';
            customController.changeOptions();

            customController.radio = '1';
            customController.showReports();
            System.assertEquals('', customController.reportId);
            System.assert(customController.showNoReport);

            customController.radio = '2';
            customController.showReports();
            System.assertEquals('', customController.reportId);
            System.assert(customController.showNoReport);

            customController.radio = '3';
            customController.showReports();
            System.assertEquals('', customController.reportId);
            System.assert(customController.showNoReport);

        System.test.stopTest();
    }
  /*  @isTest
    public static void updateClicks_positive_test(){
        List<Campaign> campaignList = TestDataHelper.fetchAllCampaigns();
        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
            CampaignUrlAnalysisController customController = new CampaignUrlAnalysisController(standardController);
            customController.selectedCampaign = campaignList[1];
    }*/


}