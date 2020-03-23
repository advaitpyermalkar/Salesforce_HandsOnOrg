/**
 * @File Name          : CampaignUrlBuilderControllerTest.cls
 * @Description        :
 * @Author             : Advait.Yermalkar@asus.com
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/12/2020, 9:38:00 AM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    9/3/2020   Advait.Yermalkar@asus.com     Initial Version
**/
@isTest
public class CampaignUrlBuilderControllerTest {
    @TestSetup
    static void makeData(){
        Tokens__c newToken = new Tokens__c(
            Name = 'Bitly'
            ,AccessToken__c = '3c094a629e4ac4b658101bf0ab49ea74e49f0f5e'
            ,baseUrl__c = 'https://api-ssl.bitly.com');
        insert newToken;
    }

    /**
    * @description: Tc1 Press Get Shorten url with all apropriate Data
    * @return void
    **/
    @isTest
    public static void shortenButton_positive_test(){

        Campaign campaignObj = new Campaign(
            Name = 'Test Campaign',
            Type = 'Email',
            CampaignSource__c = 'google',
            LongUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
        );

        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(campaignObj);
            CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
            customController.newCampaign = campaignObj;
            customController.saveCampaign();
        System.test.stopTest();

        System.assertEquals( 'http://bit.ly/32xN22d', customController.newCampaign.shortUrl__c);
        System.assertEquals(false, customController.ShowGetButton);
        System.assertEquals(false, customController.showForm);
    }

    /**
    * @description: Tc 2 Pass a new Long url and the resulting link gets inserted
    * @return void
    **/
    @isTest
    public static void shortenButton_positive201_test(){

        Campaign campaignObj = new Campaign(
            Name = 'Test Campaign',
            Type = 'Email',
            CampaignSource__c = 'google',
            LongUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
        );

        System.test.startTest();
            BitlyServiceMockResponse.is201Test = true;
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            ApexPages.StandardController standardController = new ApexPages.StandardController(campaignObj);
            CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
            customController.newCampaign = campaignObj;
            customController.saveCampaign();
        System.test.stopTest();

        System.assertEquals( 'http://bit.ly/32xN22d', customController.newCampaign.shortUrl__c);
        List<Campaign> actualCampaigns = new List<Campaign>([SELECT Id FROM Campaign ]);
        System.assertEquals(1, actualCampaigns.size());
        System.assertEquals(false, customController.ShowGetButton);
        System.assertEquals(false, customController.showForm);
    }

    /**
    * @description: Tc 3 Insertion Failed While 201 Success
    * @return void
    **/
    @isTest
    public static void shortenButton_negative201DmlExeption_test(){

        Campaign campaignObj = new Campaign(
            Name = 'Test Campaign',
            Type = 'Email',
            CampaignSource__c = 'google',
            LongUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
        );

        System.test.startTest();
            BitlyServiceMockResponse.is201Test = true;
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
            CampaignUrlBuilderController.isNegativeTest = true;
            ApexPages.StandardController standardController = new ApexPages.StandardController(campaignObj);
            CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
            customController.newCampaign = campaignObj;
            customController.saveCampaign();
        System.test.stopTest();

        System.assertEquals( 'http://bit.ly/32xN22d', customController.newCampaign.shortUrl__c);
        List<Campaign> actualCampaigns = new List<Campaign>([SELECT Id FROM Campaign ]);
        System.assertEquals(0, actualCampaigns.size());
        System.assertEquals(true, customController.ShowGetButton);
        System.assertEquals(true, customController.showForm);
    }

    /**
    * @description: Tc 4 Response is Error
    * @return void
    **/
    @isTest
    public static void shortenButton_negativeResponse_test(){

        Campaign campaignObj = new Campaign(
            Name = 'Test Campaign',
            Type = 'Email',
            CampaignSource__c = 'google',
            LongUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
        );

        System.test.startTest();
            System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
            ApexPages.StandardController standardController = new ApexPages.StandardController(campaignObj);
            CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
            customController.newCampaign = campaignObj;
            customController.saveCampaign();
        System.test.stopTest();

        System.assertEquals( null, customController.newCampaign.shortUrl__c);
        List<Campaign> actualCampaigns = new List<Campaign>([SELECT Id FROM Campaign ]);
        System.assertEquals(0, actualCampaigns.size());
        System.assertEquals(true, customController.ShowGetButton);
        System.assertEquals(true, customController.showForm);
    }

    /**
    * @description: TC 5 Clear methord testing
    * @return void
    **/
    @isTest
    public static void clear_positive_test(){

        Campaign campaignObj = new Campaign(
            Name = 'Test Campaign',
            Type = 'Email',
            CampaignSource__c = 'google',
            LongUrl__c = 'https://docs.google.com/forms/d/e/1FAIpQLSdtgyaVU_eHavvEVREK7IGo_aebMlM08Hgobkx6q81ydsWtFw/viewform'
        );

        System.test.startTest();
                System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
                ApexPages.StandardController standardController = new ApexPages.StandardController(campaignObj);
                CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
                customController.newCampaign = campaignObj;
                Pagereference actualPageRespone =  customController.clear();
        System.test.stopTest();

        System.assertEquals( new Campaign(), customController.newCampaign);
        System.assertEquals(true, customController.ShowGetButton);
        System.assertEquals(true, customController.showForm);
        System.assertEquals(null, actualPageRespone);
    }
    /**
    * @description: TC 6 toggleing help section test
    * @return void
    **/
    @isTest
    public static void toggle_positive_test(){

        System.test.startTest();
                System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
                ApexPages.StandardController standardController = new ApexPages.StandardController(new Campaign());
                CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
                customController.showHelp = false;
                customController.helpToggle();
        System.test.stopTest();

        System.assertEquals(true, customController.showHelp);
        System.assertEquals('Hide Help', customController.helpButtonText);
    }

    /**
    * @description: TC 7 toggleing help section test
    * @return void
    **/
    @isTest
    public static void toggle_negative_test(){

        System.test.startTest();
                System.Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
                ApexPages.StandardController standardController = new ApexPages.StandardController(new campaign());
                CampaignUrlBuilderController customController = new CampaignUrlBuilderController(standardController);
                customController.showHelp = true;
                customController.helpToggle();
        System.test.stopTest();

        System.assertEquals(false, customController.showHelp);
        System.assertEquals('Get Help!', customController.helpButtonText);
    }



}