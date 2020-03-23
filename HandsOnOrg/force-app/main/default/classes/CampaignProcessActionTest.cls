/**
 * @File Name          : CampaignProcessActionTest.cls
 * @Description        : test class For CampaignProcessAction
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/9/2020, 6:16:32 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    3/6/2020   Advait Yermalkar     Initial Version
**/
@isTest
public class CampaignProcessActionTest {
    @TestSetup
    static void makeData(){
        Tokens__c newToken = new Tokens__c(
            Name = 'Bitly'
            ,AccessToken__c = '3c094a629e4ac4b658101bf0ab49ea74e49f0f5e'
            ,baseUrl__c = 'https://api-ssl.bitly.com');
        insert newToken;
    }

    /*
    Tc1 : Campaign is passed - Positive Test
    */
    @isTest
    public static void getTotalClicks_positive_test(){
        Campaign newCampaign = new Campaign(
            Name = 'TestCampaign'
            ,longUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
            ,shortUrl__c = 'http://bit.ly/3clTVIJ'
            );
        insert newCampaign;
        System.assert(newCampaign.Id!=null);

        List<Campaign> campaignList = new List<Campaign>();
        campaignList.add(newCampaign);

        System.test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        CampaignProcessAction.getTotalClicks(campaignList);
        System.test.stopTest();
        List<Campaign> updatedList = new List<Campaign>([SELECT Id,total_url_clicks__c FROM Campaign WHERE Id =: newCampaign.Id LIMIT 1]);
        System.assertEquals( 27, updatedList[0].total_url_clicks__c);
    }

    /*
    Tc2 : Campaign is Not Updated - negative Test
    */
    @isTest
    public static void getTotalClicks_negative_test(){
        Campaign newCampaign = new Campaign(
            Name = 'TestCampaign'
            ,longUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
            ,shortUrl__c = 'http://bit.ly/3clTVIJ'
            );
        insert newCampaign;
        System.assert(newCampaign.Id!=null);

        List<Campaign> campaignList = new List<Campaign>();
        campaignList.add(newCampaign);

        System.test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        CampaignProcessAction.getTotalClicks(campaignList);
        System.test.stopTest();
        List<Campaign> updatedList = new List<Campaign>([SELECT Id,total_url_clicks__c FROM Campaign WHERE Id =: newCampaign.Id LIMIT 1]);
        System.assertEquals( null, updatedList[0].total_url_clicks__c);
    }



}