/**
 * @File Name          : CampaignUrlBuilderController.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/9/2020, 3:05:57 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    3/4/2020   Advait Yermalkar     Initial Version
**/
public class CampaignUrlBuilderController {

    //Testing variables
    public static Boolean isNegativeTest = false;

    public Campaign newCampaign {get;set;}
    public Boolean ShowGetButton {get;set;}
    public Boolean showForm {get;set;}
    public Boolean showHelp {get;set;}
    public String clearButtonText {get;set;}
    public String helpButtonText {get;set;}


    public CampaignUrlBuilderController(ApexPages.StandardController controller){
        ShowGetButton=true;
        showForm = true;
        showHelp = false;
        clearButtonText = 'Clear';
        helpButtonText = 'Get Help!';
        newCampaign= (Campaign)controller.getRecord();
    }

    public Campaign getnewCampaign() {
        if(newCampaign == null) newCampaign = new Campaign();
        return newCampaign;
    }

    public void helpToggle(){
        if(showHelp == true){
            showHelp =false;
            helpButtonText = 'Get Help!';

        }else{
            showHelp =true;
            helpButtonText = 'Hide Help';
        }
    }

    public Pagereference clear(){
        newCampaign = new Campaign();
        ShowGetButton=true;
        showForm = true;
        return null;
    }

    public void saveCampaign(){
        clearButtonText = 'Refresh';
        System.debug(newCampaign);

        BitlyServiceResponse.ShortenResponse response =  BitlyService.shorten(newCampaign.longUrl__c);

        System.debug('>>'+response);
        if(response.status=='true'){
            newCampaign.shortUrl__c = response.link;
            if(response.message=='201'){
                try{
                    if(Test.isRunningTest() && isNegativeTest){
                        throw new DmlException();
                    }
                    insert(newCampaign);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Success '));

                }catch(DmlException e){
                    System.debug('>>> '+e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Error inserting in Url Info'));
                    return;
                }
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Success : Bitlink for this url already exists'));
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, response.message));
            return;
        }
        ShowGetButton=false;
        showForm = false;
    }

}