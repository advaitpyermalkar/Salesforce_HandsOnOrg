/**
 * @File Name          : CampaignManagerController.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/3/2020, 8:33:24 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    2/27/2020   Advait Yermalkar     Initial Version
**/
public class CampaignManagerController {

    public string campaignName{get;set;}
    public string campaignSource{get;set;}
    public string campaignMedium{get;set;}

    public string longUrl{get;set;}
    public string shortUrl{get;set;}

    public CampaignManagerController(){
        campaignName = campaignSource = campaignMedium = longUrl = shortUrl = '';
    }

    public Pagereference clear(){
        campaignName = campaignSource = campaignMedium = longUrl = shortUrl = '';
        return null;
    }

    public void shorten(){
        BitlyServiceResponse.ShortenResponse response =  BitlyService.shorten(longUrl);
        System.debug('>>'+response);
        if(response.status=='true'){
            shortUrl = response.link;
            if(response.message=='201'){
                UrlInfo__c newRecord = new UrlInfo__c(
                    Name = campaignName+'_'+campaignSource+'_'+campaignMedium+'_'+System.now().date(),
                    Campaign_Medium__c = campaignMedium,
                    Campaign_Name__c = campaignName,
                    Campaign_Source__c = campaignSource,
                    LongUrl__c = longUrl,
                    ShortUrl__c	= shortUrl
                );
                try{
                    insert(newRecord);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Success '));

                }catch(DmlException e){
                    System.debug('>>> '+e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Error inserting in Url Info'));
                }
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Success : Bitlink for this url already exists'));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, response.message));
        }

    }

}