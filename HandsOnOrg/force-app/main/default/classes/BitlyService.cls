/**
 * @File Name          : BitlyService.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait.Yermalkar@asus.com
 * @Last Modified On   : 9/3/2020, 3:04:16 am
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    2/25/2020   Advait Yermalkar     Initial Version
**/
public class BitlyService {
    //Test Variables
    public static Boolean isNegativeCalloutTest = false;
    public static Boolean isNegativeJsonTest = false;

    // Get Required Data From Custom Setting

    public static string accesstoken = Tokens__c.getvalues('Bitly').AccessToken__c;
    public static final string baseUrl = Tokens__c.getvalues('Bitly').baseUrl__c;

    // Class level Static Methords

    /**
    * @description: Uses Bitly Service and Shortens a Long URL
    * @author Advait Yermalkar | 2/26/2020
    * @param String longUrl
    * @return Map<String, String>
    **/
    public static BitlyServiceResponse.ShortenResponse shorten( String longUrl ) {
        //Input string validation
        if(String.isNotBlank( longUrl )){

            //Forming request-mapping and Json Body
            String serviceMapping = '/v4/shorten';
            String requestBody = '{"long_url": "'+ longUrl +'"}';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl + serviceMapping);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ accesstoken);
            request.setBody(requestBody);
            system.debug('>>> request : '+request );

            HttpResponse response;

            //Callout
            try{
                response = http.send(request);
                if(System.Test.isRunningTest() && isNegativeCalloutTest){
                    CalloutException ex =  new CalloutException();
                    ex.setMessage('callout error');
                    throw ex;
                }
                system.debug('>>>>>>>response '+ response.getStatusCode());
                system.debug('>>>>>>>response '+ response.getBody());

            }catch(CalloutException e){
                system.debug('>>>>>>>Callout exeption  ::' + e.getMessage());
                return new BitlyServiceResponse.ShortenResponse('false', 'null', 'Callout Exeption : '+e.getMessage());
            }

            //Validate Response
            if (response!=null){
                Map<String,Object> reponseMap = new Map<String,Object>();
                // Deserialize Response
                try{
                    reponseMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    if(System.Test.isRunningTest() && isNegativeJsonTest){
                        JSONException ex = new JSONException();
                        ex.setMessage('json error');
                        throw ex;
                    }
                }catch(JSONException e){
                    System.debug('>>>' + e.getMessage());
                    return new BitlyServiceResponse.ShortenResponse('false', 'null', 'JSON deserialize Error : '+e.getMessage());
                }

                if (response.getStatusCode() == 200)
                {
                    System.debug('>>> Link : ' + reponseMap.get('link') );
                    return new BitlyServiceResponse.ShortenResponse('true', String.valueOf(reponseMap.get('link')), '200');
                }
                else if (response.getStatusCode() == 201){
                    System.debug('>>> Link : ' + reponseMap.get('link'));
                    return new BitlyServiceResponse.ShortenResponse('true', String.valueOf(reponseMap.get('link')), '201');
                }
                else{
                    return new BitlyServiceResponse.ShortenResponse('false','null','Response Error : '+ String.valueOf(reponseMap.get('message')));
                }
            }
        }
        return new BitlyServiceResponse.ShortenResponse('false', 'null', 'Null/Blank String Passed');
    }

    /**
    * @description: Get the summary number of clicks on a pirticular short link
    * @author Advait Yermalkar | 2/26/2020
    * @param String shortUrl
    * @return BitlyServiceResponse.BitlyMyResponse
    **/
    public static BitlyServiceResponse.BitlyMyResponse getClicks( String shortUrl ) {
        if(String.isNotBlank(shortUrl)){
            //Forming request-mapping and Json Body
            String serviceMapping = '/v4/bitlinks/'  + shortUrl + '/clicks/summary';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl + serviceMapping);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ accesstoken);
            system.debug('>>> request : ' + request );

            HttpResponse response;

            //Callout
            try{
                if(System.Test.isRunningTest() && isNegativeCalloutTest){
                    CalloutException ex =  new CalloutException();
                    ex.setMessage('callout error');
                    throw ex;
                }
                response = http.send(request);
                system.debug('>>>>>>>response '+response.getStatusCode());
                system.debug('>>>>>>>response '+response.getBody());

            }catch(CalloutException e){
                system.debug('>>>>>>>Callout exeption  ::' + e.getMessage());
                return new BitlyServiceResponse.BitlyMyResponse(false,'Callout Exeption : '+e.getMessage());
            }

            //Validate Response
            if (response!=null){
                if (response.getStatusCode() == 200)
                {
                    // Deserialize Response
                    BitlyServiceResponse.ClickResponse bitlyResponse;
                    try{
                        if(System.Test.isRunningTest() && isNegativeJsonTest){
                            JSONException ex = new JSONException();
                            ex.setMessage('json error');
                            throw ex;
                        }
                        bitlyResponse = (BitlyServiceResponse.ClickResponse) System.JSON.deserialize(
                            response.getBody() , BitlyServiceResponse.ClickResponse.class
                        );
                    }catch(JSONException e){
                        System.debug('>>>' + e.getMessage());
                        return new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : '+e.getMessage());
                    }

                    System.debug('bitlyResponse : '+ bitlyResponse);
                    return new BitlyServiceResponse.BitlyMyResponse(true,bitlyResponse,'ClickResponse');
                }
                else{
                     // Deserialize Response
                     BitlyServiceResponse.ErrorResponse errorResponse;
                     try{
                        if(System.Test.isRunningTest() && isNegativeJsonTest){
                            JSONException ex = new JSONException();
                            ex.setMessage('json error');
                            throw ex;
                        }
                        errorResponse = (BitlyServiceResponse.ErrorResponse) System.JSON.deserialize(
                            response.getBody() , BitlyServiceResponse.ErrorResponse.class
                        );
                    }catch(JSONException e){
                        System.debug('>>>' + e.getMessage());
                        return new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : '+e.getMessage());
                    }
                    System.debug('errorResponse : '+ errorResponse);
                    return new BitlyServiceResponse.BitlyMyResponse(true,errorResponse,'ErrorResponse');
                }
            }
        }
        return new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');
    }

    /**
    * @description: get the clicks on bitlinks based on reffering_Domains
    * @author Advait Yermalkar | 2/26/2020
    * @param String shortUrl
    * @return BitlyServiceResponse.BitlyMyResponse
    **/
    public static BitlyServiceResponse.BitlyMyResponse getDomain( String shortUrl ) {
        if(String.isNotBlank(shortUrl)){
            //Forming request-mapping and Json Body
            String serviceMapping = '/v4/bitlinks/'  + shortUrl + '/referring_domains';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl + serviceMapping);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ accesstoken);
            system.debug('>>> request : '+request );

            HttpResponse response;

            //Callout
            try{
                response = http.send(request);
                if(System.Test.isRunningTest() && isNegativeCalloutTest){
                    CalloutException ex =  new CalloutException();
                    ex.setMessage('callout error');
                    throw ex;
                }
                system.debug('>>>>>>>response '+response.getStatusCode());
                system.debug('>>>>>>>response '+response.getBody());

            }catch(CalloutException e){
                system.debug('>>>>>>>Callout exeption  ::' + e.getMessage());
                return new BitlyServiceResponse.BitlyMyResponse(false,'Callout Exeption : '+e.getMessage());
            }

            //Validate Response
            if (response!=null){
                if (response.getStatusCode() == 200)
                {
                    // Deserialize Response
                    BitlyServiceResponse.MetricResponse bitlyResponse;
                    try{
                        if(System.Test.isRunningTest() && isNegativeJsonTest){
                            JSONException ex = new JSONException();
                            ex.setMessage('json error');
                            throw ex;
                        }
                        bitlyResponse = (BitlyServiceResponse.MetricResponse) System.JSON.deserialize(
                            response.getBody() , BitlyServiceResponse.MetricResponse.class
                        );
                    }catch(JSONException e){
                        System.debug('>>>' + e.getMessage());
                        return new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : '+e.getMessage());
                    }

                    System.debug('bitlyResponse : '+ bitlyResponse);
                    return new BitlyServiceResponse.BitlyMyResponse(true,bitlyResponse,'MetricResponse');
                }
                else{
                     // Deserialize Response
                     BitlyServiceResponse.ErrorResponse errorResponse;
                     try{
                        if(System.Test.isRunningTest() && isNegativeJsonTest){
                            JSONException ex = new JSONException();
                            ex.setMessage('json error');
                            throw ex;
                        }
                        errorResponse = (BitlyServiceResponse.ErrorResponse) System.JSON.deserialize(
                            response.getBody() , BitlyServiceResponse.ErrorResponse.class
                        );
                    }catch(JSONException e){
                        System.debug('>>>' + e.getMessage());
                        return new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : '+e.getMessage());
                    }
                    System.debug('errorResponse : '+ errorResponse);
                    return new BitlyServiceResponse.BitlyMyResponse(true,errorResponse,'ErrorResponse');
                }
            }
        }
        return new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');
    }

    /**
    * @description: get the clicks on bitlink based on country
    * @author Advait Yermalkar | 2/26/2020
    * @param String shortUrl
    * @return BitlyServiceResponse.BitlyMyResponse
    **/
    public static BitlyServiceResponse.BitlyMyResponse getCountry( String shortUrl ) {
        if(String.isNotBlank(shortUrl)){
            //Forming request-mapping and Json Body
            String serviceMapping = '/v4/bitlinks/'  + shortUrl + '/countries';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl + serviceMapping);
            request.setMethod('GET');
            request.setHeader('Content-Type','application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+ accesstoken);
            system.debug('>>> request : '+request );

            HttpResponse response;

            //Callout
            try{
                response = http.send(request);
                if(System.Test.isRunningTest() && isNegativeCalloutTest){
                    CalloutException ex =  new CalloutException();
                    ex.setMessage('callout error');
                    throw ex;
                }
                system.debug('>>>>>>>response '+response.getStatusCode());
                system.debug('>>>>>>>response '+response.getBody());

            }catch(CalloutException e){
                system.debug('>>>>>>>Callout exeption  ::' + e.getMessage());
                return new BitlyServiceResponse.BitlyMyResponse(false,'Callout Exeption : '+e.getMessage());
            }

            //Validate Response
            if (response!=null){
                if (response.getStatusCode() == 200)
                {
                    // Deserialize Response
                    BitlyServiceResponse.MetricResponse bitlyResponse;
                    try{
                        if(System.Test.isRunningTest() && isNegativeJsonTest){
                            JSONException ex = new JSONException();
                            ex.setMessage('json error');
                            throw ex;
                        }
                        bitlyResponse = (BitlyServiceResponse.MetricResponse) System.JSON.deserialize(
                            response.getBody() , BitlyServiceResponse.MetricResponse.class
                        );
                    }catch(JSONException e){
                        System.debug('>>>' + e.getMessage());
                        return new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : '+e.getMessage());
                    }

                    System.debug('bitlyResponse : '+ bitlyResponse);
                    return new BitlyServiceResponse.BitlyMyResponse(true,bitlyResponse,'MetricResponse');
                }
                else{
                     // Deserialize Response
                     BitlyServiceResponse.ErrorResponse errorResponse;
                     try{
                        if(System.Test.isRunningTest() && isNegativeJsonTest){
                            JSONException ex = new JSONException();
                            ex.setMessage('json error');
                            throw ex;
                        }
                        errorResponse = (BitlyServiceResponse.ErrorResponse) System.JSON.deserialize(
                            response.getBody() , BitlyServiceResponse.ErrorResponse.class
                        );
                    }catch(JSONException e){
                        System.debug('>>>' + e.getMessage());
                        return new BitlyServiceResponse.BitlyMyResponse(false,'JSON deserialize Error : '+e.getMessage());
                    }
                    System.debug('errorResponse : '+ errorResponse);
                    return new BitlyServiceResponse.BitlyMyResponse(true,errorResponse,'ErrorResponse');
                }
            }
        }
        return new BitlyServiceResponse.BitlyMyResponse(false,'Null/Blank String Passed');
    }

}