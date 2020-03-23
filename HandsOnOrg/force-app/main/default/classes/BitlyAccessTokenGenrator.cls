/**
 * @File Name          : BitlyAccessTokenGenrator.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 2/26/2020, 7:11:42 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    2/25/2020   Advait Yermalkar     Initial Version
**/
public class BitlyAccessTokenGenrator {

    public static String getAccessToken(){
        String encodingString = Credentials__c.getValues('BitlyCreds').EncodingString__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api-ssl.bitly.com/oauth/access_token');
        req.setHeader(
            'Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueof(encodingString))
            );
        req.setHeader('Content-Type','text/plain; charset=utf-8');
       	req.setHeader('Content-length', String.valueof((req.getbody()).length()));
        req.setMethod('POST');
        system.debug('>>>' + req);
        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug('>>>' + res);
        // Add status code checks for response if 200 etc
        return res.getBody();
    }
}
/*
Execute anonymous
System.debug('>>> Access Token :' + BitlyAccessTokenGenrator.getAccessToken() );


*/