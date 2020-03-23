/**
 * @File Name          : BitlyServiceMockResponse.cls
 * @Description        :
 * @Author             : Advait.Yermalkar@asus.com
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/9/2020, 2:22:49 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    1/3/2020   Advait.Yermalkar@asus.com     Initial Version
**/
@isTest
public class BitlyServiceMockResponse implements HttpCalloutMock {

    public Boolean isNegativeTest = false;
    public static Boolean is201Test = false;

    public BitlyServiceMockResponse(Boolean isNegativeTest){
        this.isNegativeTest  = isNegativeTest;
    }

    public String shortenPosResponse = '{"created_at":"2020-02-27T04:39:40+0000","id":"bit.ly/32xN22d","link":"http://bit.ly/32xN22d","custom_bitlinks":[],"long_url":"https://www.google.com/search?q=test+image&rlz=1C1GCEU_en-GBIN876IN876&sxsrf=ALeKk01SC5nu64FIFDgMBtJytf16HOhPXg:1582778243542&tbm=isch&source=iu&ictx=1&fir=HEgwS-yUkQRQkM%253A%252CpXc59JJPjrCBfM%252C_&vet=1&usg=AI4_-kTCJASzs2pMhLC_WdzwOCPdbp7yiQ&sa=X&ved=2ahUKEwjErdu39PDnAhV5yzgGHVonDPgQ9QEwBnoECAoQPA#imgrc=hj6en-hBZN-VPM","archived":false,"tags":[],"deeplinks":[],"references":{"group":"https://api-ssl.bitly.com/v4/groups/Bk2o9FlcO5R"}}';
    public String shortenNegResponse = '{"message":"INVALID_ARG_LONG_URL","resource":"bitlinks","description":"The value provided is invalid.","errors":[{"field":"long_url","error_code":"invalid"}]}';

    public String getClicksPosResponse = '{"unit_reference":"2020-03-08T16:34:59+0000","total_clicks":27,"units":30,"unit":""}';
    public String getClicksNegResponse = '{"message":"NOT_FOUND","resource":"bitlinks","description":"What you are looking for cannot be found."}';

    public String getDomainPosResponse = '{"unit_reference":"2020-03-08T21:01:47+0000","metrics":[{"value":"direct","clicks":20}],"units":30,"unit":"day","facet":"referring_domains"}';
    public String getDomainNegResponse = '{"message":"NOT_FOUND","resource":"bitlinks","description":"What you are looking for cannot be found."}';
    public String getCountryPosResponse = '{"unit_reference":"2020-03-08T20:57:34+0000","metrics":[{"value":"DE","clicks":10}],"units":30,"unit":"day","facet":"countries"}';
    public String getCountryNegResponse =  '{"message":"NOT_FOUND","resource":"bitlinks","description":"What you are looking for cannot be found."}';




    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        switch on request.getMethod() {
            when 'POST' {
                if(!isNegativeTest && !is201Test){
                    response.setBody(shortenPosResponse);
                    response.setStatusCode(200);
                }
                else if(!isNegativeTest && is201Test){
                    response.setBody(shortenPosResponse);
                    response.setStatusCode(201);
                }
                else{
                    response.setBody(shortenNegResponse);
                    response.setStatusCode(400);
                }
            }
            when 'GET' {
                if(request.getEndpoint().contains('/clicks/summary') && !isNegativeTest){
                    response.setBody(getClicksPosResponse);
                    response.setStatusCode(200);
                }
                else if(request.getEndpoint().contains('/clicks/summary') && isNegativeTest){
                    response.setBody(getClicksNegResponse);
                    response.setStatusCode(400);
                }
                else if(request.getEndpoint().contains('/referring_domains') && !isNegativeTest){
                    response.setBody(getDomainPosResponse);
                    response.setStatusCode(200);
                }
                else if(request.getEndpoint().contains('/referring_domains') && isNegativeTest){
                    response.setBody(getDomainNegResponse);
                    response.setStatusCode(400);
                }
                else if(request.getEndpoint().contains('/countries') && !isNegativeTest){
                    response.setBody(getCountryPosResponse);
                    response.setStatusCode(200);
                }
                else if(request.getEndpoint().contains('/countries') && isNegativeTest){
                    response.setBody(getCountryNegResponse);
                    response.setStatusCode(400);
                }
            }
        }
        return response;
    }
}