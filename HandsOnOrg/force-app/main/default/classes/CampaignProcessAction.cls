/**
 * @File Name          : CampaignProcessAction.cls
 * @Description        : This class contains a invocable methord which is called by a Process Builder
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/9/2020, 6:18:17 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    3/6/2020   Advait Yermalkar     Initial Version
**/
public class CampaignProcessAction {

    /**
    * @description : takes Campaign and Updates total clicks on campaign.
    * @author Advait Yermalkar | 3/6/2020
    * @param List<Campaign> campaignList
    * @return void
    **/
    @InvocableMethod
    public static void getTotalClicks(List<Campaign> campaignList ){
        if(campaignList!=null && !campaignList.isEmpty() ){
            Campaign campaignObj = campaignList[0];
            String shortUrl = campaignObj.shortUrl__c;
            if(shortUrl.contains('http')){
                shortUrl = shortUrl.split('//',2).get(1);
            }
        callout(shortUrl, String.valueOf(campaignObj.id));
        }
    }

    /**
    * @description : makes a callout to bitly service and updates campaign TotalClicks
    * @author Advait Yermalkar | 3/6/2020
    * @param String Shorturl
    * @param String CampaignId
    * @return void
    **/
    @future(Callout=true)
    public static void callout(String Shorturl ,String CampaignId){
        if(String.isNotBlank(Shorturl) && String.isNotBlank(CampaignId)){
            BitlyServiceResponse.BitlyMyResponse response =  BitlyService.getClicks(shortUrl);
            System.debug(response);
            if( response.isSuccess && response.errorResponse==null ){
                Campaign updateCampaign = new Campaign(Id = CampaignId , total_url_clicks__c = response.clickResponse.total_clicks);
                Database.upsert(updateCampaign);
            }
        }
    }
}