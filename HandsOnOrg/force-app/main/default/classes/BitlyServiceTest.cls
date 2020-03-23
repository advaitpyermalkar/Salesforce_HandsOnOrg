/**
 * @File Name          : BitlyServiceTest.cls
 * @Description        :
 * @Author             : Advait.Yermalkar@asus.com
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/9/2020, 1:03:57 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/3/2020   Advait.Yermalkar@asus.com     Initial Version
**/
@isTest
public class BitlyServiceTest {

    /**
    * @description : Creates custom settings used in all further test cases
    * @return void
    **/
    @TestSetup
    static void makeData(){
        Tokens__c newToken = new Tokens__c(
            Name = 'Bitly'
            ,AccessToken__c = '3c094a629e4ac4b658101bf0ab49ea74e49f0f5e'
            ,baseUrl__c = 'https://api-ssl.bitly.com');
        insert newToken;
    }

    /**
    * @description: TC1 : function: BitlyService Shorten()
                positive Test for new Url shortening Request.
    * @return void
    **/
    @isTest
    public static void shorten_positive200_test(){
        String longUrl = 'https://www.google.com/search?q=test+image&rlz=1C1GCEU_en-GBIN876IN876&sxsrf=ALeKk01SC5nu64FIFDgMBtJytf16HOhPXg:1582778243542&tbm=isch&source=iu&ictx=1&fir=HEgwS-yUkQRQkM%253A%252CpXc59JJPjrCBfM%252C_&vet=1&usg=AI4_-kTCJASzs2pMhLC_WdzwOCPdbp7yiQ&sa=X&ved=2ahUKEwjErdu39PDnAhV5yzgGHVonDPgQ9QEwBnoECAoQPA#imgrc=hj6en-hBZN-VPM';

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'true','http://bit.ly/32xN22d','200'
        );

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }
    /**
    * @description: TC2 : function: BitlyService Shorten()
                positive Test if the given url is already shortend.
    * @return void
    **/
    @isTest
    public static void shorten_positive201_test(){
        String longUrl = 'https://www.google.com/search?q=test+image&rlz=1C1GCEU_en-GBIN876IN876&sxsrf=ALeKk01SC5nu64FIFDgMBtJytf16HOhPXg:1582778243542&tbm=isch&source=iu&ictx=1&fir=HEgwS-yUkQRQkM%253A%252CpXc59JJPjrCBfM%252C_&vet=1&usg=AI4_-kTCJASzs2pMhLC_WdzwOCPdbp7yiQ&sa=X&ved=2ahUKEwjErdu39PDnAhV5yzgGHVonDPgQ9QEwBnoECAoQPA#imgrc=hj6en-hBZN-VPM';

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'true','http://bit.ly/32xN22d','201'
        );

        System.Test.startTest();
        BitlyServiceMockResponse.is201Test = true;
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }
    /**
    * @description: TC3 : function: BitlyService Shorten()
                negative Test for wrong Url passed.
    * @return void
    **/
    @isTest
    public static void shorten_negativeWrongUrl_test(){
        String longUrl = 'search?q=test+image&rlz=1C1GCEU'; // wrong Url

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'false','null','Response Error : INVALID_ARG_LONG_URL'
        );

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }
    /**
    * @description: TC4 : function: BitlyService Shorten()
                negative Test for Blank Url passed.
    * @return void
    **/
    @isTest
    public static void shorten_negativeBlankUrl_test(){
        String longUrl = ''; // Blank Url

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'false','null','Null/Blank String Passed'
        );

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }
    /**
    * @description: TC5 : function: BitlyService Shorten()
                negative Test for Blank Url passed.
    * @return void
    **/
    @isTest
    public static void shorten_negativeNullUrl_test(){
        String longUrl ; // Null Url

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'false','null','Null/Blank String Passed'
        );

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }
    /**
    * @description: TC6 : function: BitlyService Shorten()
                negative Test for callout Exeption.
    * @return void
    **/
    @isTest
    public static void shorten_negativeCallout_test(){
        String longUrl = 'https://www.google.com/search?q=test+image&rlz=1C1GCEU_en-GBIN876IN876&sxsrf=ALeKk01SC5nu64FIFDgMBtJytf16HOhPXg:1582778243542&tbm=isch&source=iu&ictx=1&fir=HEgwS-yUkQRQkM%253A%252CpXc59JJPjrCBfM%252C_&vet=1&usg=AI4_-kTCJASzs2pMhLC_WdzwOCPdbp7yiQ&sa=X&ved=2ahUKEwjErdu39PDnAhV5yzgGHVonDPgQ9QEwBnoECAoQPA#imgrc=hj6en-hBZN-VPM';

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'false','null','Callout Exeption : callout error'
        );

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeCalloutTest = true;
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }
    /**
    * @description: TC7 : function: BitlyService Shorten()
                negative Test for Json response Deserialization Exeption.
    * @return void
    **/
    @isTest
    public static void shorten_negativeJsonExeption_test(){
        String longUrl = 'https://www.google.com/search?q=test+image&rlz=1C1GCEU_en-GBIN876IN876&sxsrf=ALeKk01SC5nu64FIFDgMBtJytf16HOhPXg:1582778243542&tbm=isch&source=iu&ictx=1&fir=HEgwS-yUkQRQkM%253A%252CpXc59JJPjrCBfM%252C_&vet=1&usg=AI4_-kTCJASzs2pMhLC_WdzwOCPdbp7yiQ&sa=X&ved=2ahUKEwjErdu39PDnAhV5yzgGHVonDPgQ9QEwBnoECAoQPA#imgrc=hj6en-hBZN-VPM';

        BitlyServiceResponse.ShortenResponse expectedResponse = new BitlyServiceResponse.ShortenResponse(
            'false','null','JSON deserialize Error : json error'
        );

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.ShortenResponse actualResponse =  BitlyService.shorten(longUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.link, actualResponse.link, 'Check Actual Response');
        System.assertEquals(expectedResponse.message, actualResponse.message, 'Check Actual Response');
        System.assertEquals(expectedResponse.status, actualResponse.status, 'Check Actual Response');
    }


    /**
    * @description :Tc 8: getClicks positive test
    * @return void
    **/
    @isTest
    public static void getClicks_positive_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.ClickResponse clickResponse = new BitlyServiceResponse.ClickResponse();
        clickResponse.total_clicks = 27;
        clickResponse.unit_reference = '2020-03-08T16:34:59+0000';
        clickResponse.units = 30;
        clickResponse.unit = '';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(true,clickResponse,'ClickResponse');


        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.clickResponse.total_clicks, actualResponse.clickResponse.total_clicks);
        System.assertEquals(expectedResponse.clickResponse.unit, actualResponse.clickResponse.unit);
        System.assertEquals(expectedResponse.clickResponse.unit_reference, actualResponse.clickResponse.unit_reference);
        System.assertEquals(expectedResponse.clickResponse.units, actualResponse.clickResponse.units);

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description :Tc 9: passing Wrong Url to getClicks Methord
    * @return void
    **/
    @isTest
    public static void getClicks_negativeWrongUrl_test(){
        String shortUrl = 'http://bit.ly'; // Wrong Url

        BitlyServiceResponse.ErrorResponse errorResponse = new BitlyServiceResponse.ErrorResponse();
        errorResponse.message = 'NOT_FOUND';
        errorResponse.resource = 'bitlinks';
        errorResponse.description = 'What you are looking for cannot be found.';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(true,errorResponse,'ErrorResponse');


        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse.description, actualResponse.errorResponse.description);
        System.assertEquals(expectedResponse.errorResponse.errors, actualResponse.errorResponse.errors);
        System.assertEquals(expectedResponse.errorResponse.message, actualResponse.errorResponse.message);
        System.assertEquals(expectedResponse.errorResponse.resource, actualResponse.errorResponse.resource);


        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description :Tc 10: passing Blank Url to getClicks Methord
    * @return void
    **/
    @isTest
    public static void getClicks_negativeBlankUrl_test(){
        String shortUrl = ''; // Blank Url

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description :Tc 11: passing Null Url to getClicks Methord
    * @return void
    **/
    @isTest
    public static void getClicks_negativeNullUrl_test(){
        String shortUrl; // Null Url

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description :Tc 12: Call out Exeption for getclicks Methord
    * @return void
    **/
    @isTest
    public static void getClicks_negativeCallout_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Callout Exeption : callout error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeCalloutTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description :Tc 13: Json Deserialization error while sucess Response
    * @return void
    **/
    @isTest
    public static void getClicks_negativeJsonSuccess_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : json error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description :Tc 13: Json Deserialization error while Error Response
    * @return void
    **/
    @isTest
    public static void getClicks_negativeJsonError_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : json error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getClicks(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }

    /**
    * @description: Tc 14 :getCountry Methord Positive test
    * @return void
    **/
    @isTest
    public static void getCountry_positive_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.Metrics metricObj = new BitlyServiceResponse.Metrics();
        metricObj.clicks = 10;
        metricObj.value = 'DE';

        List<BitlyServiceResponse.Metrics> metrics = new List<BitlyServiceResponse.Metrics>();
        metrics.add(metricObj);

        BitlyServiceResponse.MetricResponse metricResponse = new BitlyServiceResponse.MetricResponse();
        metricResponse.metrics = metrics;
        metricResponse.unit = 'day';
        metricResponse.units = 30;
        metricResponse.facet = 'countries';
        metricResponse.unit_reference = '2020-03-08T20:57:34+0000';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(true,metricResponse,'MetricResponse');


        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.metricResponse.facet, actualResponse.metricResponse.facet);
        System.assertEquals(expectedResponse.metricResponse.unit, actualResponse.metricResponse.unit);
        System.assertEquals(expectedResponse.metricResponse.units, actualResponse.metricResponse.units);
        System.assertEquals(expectedResponse.metricResponse.unit_reference, actualResponse.metricResponse.unit_reference);
        System.assertEquals(expectedResponse.metricResponse.metrics[0].clicks, actualResponse.metricResponse.metrics[0].clicks);
        System.assertEquals(expectedResponse.metricResponse.metrics[0].value, actualResponse.metricResponse.metrics[0].value);



        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description: Tc 15 :getCountry Methord Wrong Url Passed
    * @return void
    **/
    @isTest
    public static void getCountry_negativeWrongUrl_test(){
        String shortUrl = 'http://bit.ly'; // Wrong Url

        BitlyServiceResponse.ErrorResponse errorResponse = new BitlyServiceResponse.ErrorResponse();
        errorResponse.message = 'NOT_FOUND';
        errorResponse.resource = 'bitlinks';
        errorResponse.description = 'What you are looking for cannot be found.';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(true,errorResponse,'ErrorResponse');


        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse.description, actualResponse.errorResponse.description);
        System.assertEquals(expectedResponse.errorResponse.errors, actualResponse.errorResponse.errors);
        System.assertEquals(expectedResponse.errorResponse.message, actualResponse.errorResponse.message);
        System.assertEquals(expectedResponse.errorResponse.resource, actualResponse.errorResponse.resource);


        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description: Tc 16 :getCountry Methord Blank Url Passed
    * @return void
    **/
    @isTest
    public static void getCountry_negativeBlankUrl_test(){
        String shortUrl = ''; // Blank Url

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description: Tc 17 :getCountry Methord Null Url Passed
    * @return void
    **/
    @isTest
    public static void getCountry_negativeNullUrl_test(){
        String shortUrl; // Null Url

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description: Tc 18 : exeption throen during callout
    * @return void
    **/
    @isTest
    public static void getCountry_negativeCallout_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Callout Exeption : callout error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeCalloutTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description: Tc 19 :getCountry Methord deserialize exeption in Sucess Response
    * @return void
    **/
    @isTest
    public static void getCountry_negativeJsonSuccess_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : json error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description: Tc 20 :getCountry Methord deserialize exeption in ERROR Response
    * @return void
    **/
    @isTest
    public static void getCountry_negativeJsonError_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : json error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getCountry(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }

    /**
    * @description : Tc 21 positive Testing getDomain Methords
    * @return void
    **/
    @isTest
    public static void getDomain_positive_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.Metrics metricObj = new BitlyServiceResponse.Metrics();
        metricObj.clicks = 20;
        metricObj.value = 'direct';

        List<BitlyServiceResponse.Metrics> metrics = new List<BitlyServiceResponse.Metrics>();
        metrics.add(metricObj);

        BitlyServiceResponse.MetricResponse metricResponse = new BitlyServiceResponse.MetricResponse();
        metricResponse.metrics = metrics;
        metricResponse.unit = 'day';
        metricResponse.units = 30;
        metricResponse.facet = 'referring_domains';
        metricResponse.unit_reference = '2020-03-08T21:01:47+0000';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(true,metricResponse,'MetricResponse');


        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.metricResponse.facet, actualResponse.metricResponse.facet);
        System.assertEquals(expectedResponse.metricResponse.unit, actualResponse.metricResponse.unit);
        System.assertEquals(expectedResponse.metricResponse.units, actualResponse.metricResponse.units);
        System.assertEquals(expectedResponse.metricResponse.unit_reference, actualResponse.metricResponse.unit_reference);
        System.assertEquals(expectedResponse.metricResponse.metrics[0].clicks, actualResponse.metricResponse.metrics[0].clicks);
        System.assertEquals(expectedResponse.metricResponse.metrics[0].value, actualResponse.metricResponse.metrics[0].value);



        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }

    /**
    * @description : Tc 22 wrong Url Passed
    * @return void
    **/
    @isTest
    public static void getDomain_negativeWrongUrl_test(){
        String shortUrl = 'http://bit.ly'; // Wrong Url

        BitlyServiceResponse.ErrorResponse errorResponse = new BitlyServiceResponse.ErrorResponse();
        errorResponse.message = 'NOT_FOUND';
        errorResponse.resource = 'bitlinks';
        errorResponse.description = 'What you are looking for cannot be found.';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(true,errorResponse,'ErrorResponse');


        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse.description, actualResponse.errorResponse.description);
        System.assertEquals(expectedResponse.errorResponse.errors, actualResponse.errorResponse.errors);
        System.assertEquals(expectedResponse.errorResponse.message, actualResponse.errorResponse.message);
        System.assertEquals(expectedResponse.errorResponse.resource, actualResponse.errorResponse.resource);


        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description : Tc 23 blank Url Passed
    * @return void
    **/
    @isTest
    public static void getDomain_negativeBlankUrl_test(){
        String shortUrl = ''; // Blank Url

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description : Tc 24 Null Url Passed
    * @return void
    **/
    @isTest
    public static void getDomain_negativeNullUrl_test(){
        String shortUrl; // Null Url

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description : Tc 25 Callout Exeption
    * @return void
    **/
    @isTest
    public static void getDomain_negativeCallout_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'Callout Exeption : callout error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeCalloutTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description : Tc 26  Json Deserialize Error with sucess response
    * @return void
    **/
    @isTest
    public static void getDomain_negativeJsonSuccess_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : json error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(false));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }
    /**
    * @description : Tc 27  Json Deserialize Error with error response
    * @return void
    **/
    @isTest
    public static void getDomain_negativeJsonError_test(){
        String shortUrl = 'http://bit.ly/32xN22d';

        BitlyServiceResponse.BitlyMyResponse expectedResponse = new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : json error');

        System.Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMockResponse(true));
        BitlyService.isNegativeJsonTest = true;
        BitlyServiceResponse.BitlyMyResponse actualResponse = BitlyService.getDomain(shortUrl);
        System.Test.stopTest();

        System.assertEquals(expectedResponse.errorResponse, actualResponse.errorResponse);
        System.assertEquals(expectedResponse.clickResponse, actualResponse.clickResponse);
        System.assertEquals(expectedResponse.metricResponse, actualResponse.metricResponse);
        System.assertEquals(expectedResponse.isSuccess, actualResponse.isSuccess);
        System.assertEquals(expectedResponse.status, actualResponse.status);
    }

}