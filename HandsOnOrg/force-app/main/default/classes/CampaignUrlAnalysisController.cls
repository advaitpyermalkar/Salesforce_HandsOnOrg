/**
 * @File Name          : CampaignUrlAnalysisController.cls
 * @Description        :
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/16/2020, 4:27:43 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    3/4/2020   Advait Yermalkar     Initial Version
**/
public class CampaignUrlAnalysisController {

    // Variables For Page
    @TestVisible public string selectedLink {get;set;}
    @TestVisible public List<Campaign> campaignList {get;set;}
    @TestVisible public String radio {get;set;}

    //Chart variables
    @TestVisible public String filter {get;set;}
    @TestVisible public String reportId {get;set;}
    @TestVisible public Boolean showNoReport {get;set;}

    //ThreeSpecial Variables // Not used On Page
    @TestVisible String linkHttp;
    @TestVisible String shortUrl;
    @TestVisible String currCampaignId;

    //Maps and Lists // Not used On Page
    @TestVisible Map<Id,Campaign> releventCampaignMap; //All Campaigns With Short Urls
    @TestVisible Campaign selectedCampaign; // the Campaign Which is selected in PickList

    @TestVisible Map<String,UrlAnalytics__c> byCountryRecordMap;//Map Of CountryName : UrlAnalytics
    @TestVisible Map<String,UrlAnalytics__c> byDomainRecordMap;//Map Of CountryName : UrlAnalytics

    @TestVisible Map<String,Country__c> allCountriesMap;  // Map of All Countries in UrlAnalytics__c CountryName : Country__c
    @TestVisible Map<String,Domain__c> allDomainsMap; // Map of all Domains in url Analutics CountryName : Domain__c

    @TestVisible List<Country__c> newCountriesTobeAdded; // New Countries To be added
    @TestVisible List<Domain__c> newDomainsTobeAdded; // New Countries If encountered



    // Constructor
    public CampaignUrlAnalysisController(ApexPages.StandardController controller){
        System.debug('Constructor Called');
        newCountriesTobeAdded = new List<Country__c>();
        newDomainsTobeAdded = new List<Domain__c>();
        allCountriesMap = new Map<String,Country__c>();
        allDomainsMap = new Map<String,Domain__c>();
        selectedCampaign = new Campaign();
        releventCampaignMap = new Map<Id,Campaign>(
            [SELECT  Id
                    ,Name
                    ,Shorturl__c
                    ,total_url_clicks__c
                    ,(
                    SELECT Id,Clicks__c,Domain__r.Id,Domain__r.name,Country__r.Id,Country__r.name
                    FROM UrlAnalytics__r
                    )
            FROM Campaign
            WHERE shorturl__c != null]
            );

        for(Country__c countryObj :  [SELECT Id,Name FROM Country__c]){
            allCountriesMap.put(countryObj.Name,countryObj);
        }
        for(Domain__c DomainObj :  [SELECT Id,Name FROM Domain__c]){
            allDomainsMap.put(DomainObj.Name , DomainObj);
        }

        campaignList = releventCampaignMap.values();// Remove the condition to add dummy record
        showNoReport = true;
    }
    // Public Page Functions
    public void changeOptions(){
        //Extract The Info From Selected Link
        if( String.isNotBlank(selectedLink) ){

            List<String> selectedInfoList = splitter(selectedLink);
            currCampaignId = selectedInfoList[0];
            linkHttp = selectedInfoList[1];
            shortUrl = selectedInfoList[2];
            selectedCampaign = releventCampaignMap.get(currCampaignId);
            // Seprate all UrlAnalytic Records for selected Link bycountry and byDomains
            if( releventCampaignMap.get(currCampaignId).UrlAnalytics__r != null ){
                // Refresh the previous Data
                byCountryRecordMap = new Map<String,UrlAnalytics__c>();
                byDomainRecordMap = new Map<String,UrlAnalytics__c>();

                // Update the validation rule // Seprate the data
                for( UrlAnalytics__c urlDataObj : releventCampaignMap.get(currCampaignId).UrlAnalytics__r ){
                    if( urlDataObj.Domain__r.Id == null ){
                        byCountryRecordMap.put(
                            urlDataObj.Country__r.Name,
                            urlDataObj
                        );
                    }
                    else if( urlDataObj.Country__r.Id == null ){
                        byDomainRecordMap.put(
                            urlDataObj.Domain__r.Name,
                            urlDataObj
                        );
                    }
                }
            }
        }
        else{
            reportId = '';
            showNoReport = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please Select A Link'));
        }
    }
    public List<Selectoption> getAllLinks(){
        List<Selectoption> options = new List<selectoption>();
        options.add(new SelectOption('', 'Select Link'));
        for(Campaign campaignObj : campaignList){
            options.add(
                new selectOption( String.valueOf(campaignObj.Id) +'|'+ String.valueOf(campaignObj.shortUrl__c) ,
                String.valueOf(campaignObj.Name) )
                );
        }
        return options;
    }
    public void showReports(){
        // Set The report Filters
        String column ='Campaign.ShortUrl__c';
        String operator ='equals';
        String value = linkHttp;
        filter = '[{column:\''+column+'\', operator:\''+operator+'\', value:\'' + value +'\'}]';
        if( String.isNotBlank(selectedLink) ){

            switch on radio {
                when '1' {
                    // By Clicks
                    reportId = CampaignReportId__c.getValues('Click Summary Report').Id__c;
                    updateClicks(shortUrl, selectedCampaign);
                    showNoReport = false;
                }
                when '2' {
                    // By Country
                    reportId = CampaignReportId__c.getValues('Country Summary Report').Id__c;
                    updateCountry(shortUrl, currCampaignId);
                    showNoReport = false;
                }
                when '3' {
                    // By Domain
                    reportId = CampaignReportId__c.getValues('Domain Summary Report').Id__c;
                    updateDomain(shortUrl, currCampaignId);
                    showNoReport = false;
                }
            }
        }
        else{
            reportId = '';
            showNoReport = true;
        }
    }
    // Private Internal Functions
    @TestVisible
    private void updateClicks(String shortUrl ,Campaign selectedCampaign){

        BitlyServiceResponse.BitlyMyResponse response =  BitlyService.getClicks(shortUrl);

        if( response.isSuccess && (selectedCampaign.total_Url_Clicks__c != response.clickResponse.total_clicks) ){
            selectedCampaign.total_Url_Clicks__c = response.clickResponse.total_clicks;
            try{
                upsert selectedCampaign;
            }catch(DmlException e){
                System.debug('Data Updation Failed ERROR ::' + e.getMessage());
            }
        }else{
            System.debug('Error : '+ response.status );
            showNoReport = true;

        }
    }
    @TestVisible
    private void updateCountry(String shortUrl ,String campaignId){
        BitlyServiceResponse.BitlyMyResponse response= BitlyService.getCountry(shortUrl);
        if( response.isSuccess && response.status == 'MetricResponse' ){
            //Check For New Countries
            for(BitlyServiceResponse.Metrics responseData : response.metricResponse.metrics){
                if( !allCountriesMap.keySet().contains(responseData.value) ){
                    newCountriesTobeAdded.add(new Country__c(Name = responseData.value));
                }
            }

            //Insert New Countries if any
            if( !newCountriesTobeAdded.isEmpty() ){
                try{
                    insert newCountriesTobeAdded;
                    for(Country__c newCountry : newCountriesTobeAdded){
                        if(newCountry.Id != null){
                            allCountriesMap.put(newCountry.Name,newCountry);
                        }
                    }
                    newCountriesTobeAdded = new List<Country__c>();
                }
                catch(DmlException e){
                    System.debug('New Countries Cannot Be Inserted Reason:: '+ e.getMessage());
                }
            }
            //now the Countries are added or not Sill do this
            Boolean isUpsert = false;
            for( BitlyServiceResponse.Metrics responseDataObj : response.metricResponse.metrics ){
                if( byCountryRecordMap.keySet().contains(responseDataObj.value) ){
                    if( byCountryRecordMap.get(responseDataObj.value).clicks__c != responseDataObj.clicks ){
                        byCountryRecordMap.get(responseDataObj.value).clicks__c = responseDataObj.clicks;
                        isUpsert = true;
                    }
                }
                else if( allCountriesMap.keySet().contains(responseDataObj.value) ){
                    byCountryRecordMap.put(
                        responseDataObj.value,
                        new UrlAnalytics__c(
                            Campaign__c = campaignId,
                            clicks__c = responseDataObj.clicks,
                            Country__c = allCountriesMap.get(responseDataObj.value).Id
                        )
                    );
                    isUpsert = true;
                }
                System.debug('Before Upserting or not byCountryRecordMap: ' + byCountryRecordMap );
            }
            // Now Upsert the data in the urlAnalytics__c
            Integer CreatedRecords = 0;
            if(isUpsert){
            List<Database.UpsertResult> upsertResults = Database.upsert(byCountryRecordMap.values(), false);

            System.debug('UPSERT RESULT: ' + upsertResults );
                for(Database.UpsertResult resultObj : upsertResults){
                    if(resultObj.isSuccess()){
                        if(resultObj.isCreated()){
                            CreatedRecords++;
                        }
                    }
                }
                System.debug('created any Urlanalytics__c Records: ' + CreatedRecords );
            }
            System.debug('After Upserting or not byCountryRecordMap: ' + byCountryRecordMap );

        }
        else if(response.status == 'ErrorResponse'){
            System.debug('Request Error : '+ response.errorResponse.message );
            showNoReport = true;
        }
    }
    @TestVisible
    private void updateDomain(String shortUrl ,String campaignId){
        BitlyServiceResponse.BitlyMyResponse response= BitlyService.getDomain(shortUrl);
        if( response.isSuccess && response.status == 'MetricResponse' ){
            //Check For New Domains
            for(BitlyServiceResponse.Metrics responseData : response.metricResponse.metrics){
                if( !allDomainsMap.keySet().contains(responseData.value) ){
                    newDomainsTobeAdded.add(new Domain__c(Name = responseData.value));
                }
            }

            //Insert New Domains if any
            if( !newDomainsTobeAdded.isEmpty() ){
                try{
                    insert newDomainsTobeAdded;
                    for(Domain__c newDomain : newDomainsTobeAdded){
                        if(newDomain.Id != null){
                            allDomainsMap.put(newDomain.Name,newDomain);
                        }
                    }
                    newDomainsTobeAdded = new List<Domain__c>();
                }
                catch(DmlException e){
                    System.debug('New Domains Cannot Be Inserted Reason:: '+ e.getMessage());
                }
            }
            //now the Domains are added or not Sill do this
            Boolean isUpsert = false;
            for( BitlyServiceResponse.Metrics responseDataObj : response.metricResponse.metrics ){
                if( byDomainRecordMap.keySet().contains(responseDataObj.value) ){
                    if( byDomainRecordMap.get(responseDataObj.value).clicks__c != responseDataObj.clicks ){
                        byDomainRecordMap.get(responseDataObj.value).clicks__c = responseDataObj.clicks;
                        isUpsert = true;
                    }
                }
                else if( allDomainsMap.keySet().contains(responseDataObj.value) ){
                    byDomainRecordMap.put(
                        responseDataObj.value,
                        new UrlAnalytics__c(
                            Campaign__c = campaignId,
                            clicks__c = responseDataObj.clicks,
                            Domain__c = allDomainsMap.get(responseDataObj.value).Id
                        )
                    );
                    isUpsert = true;
                }
                System.debug('Before Upserting or not byDomainRecordMap: ' + byDomainRecordMap );
            }
            // Now Upsert the data in the urlAnalytics__c
            Integer CreatedRecords = 0;
            if(isUpsert){
            List<Database.UpsertResult> upsertResults = Database.upsert(byDomainRecordMap.values(), false);

            System.debug('UPSERT RESULT: ' + upsertResults );
                for(Database.UpsertResult resultObj : upsertResults){
                    if(resultObj.isSuccess()){
                        if(resultObj.isCreated()){
                            CreatedRecords++;
                        }
                    }
                }
                System.debug('created any Urlanalytics__c Records: ' + CreatedRecords );
            }
            System.debug('After Upserting or not byDomainRecordMap: ' + byDomainRecordMap );

        }
        else if(response.status == 'ErrorResponse'){
            System.debug('Request Error : '+ response.errorResponse.message );
            showNoReport = true;
        }
    }


    /**
    * @description : splits the text in list of Campaign Id and link and shorturl
    *                Example: String ==>'7i2w000000gb8LAAQ|https://bit.ly/2v43PxV'
    *                Output ==>[0]= 7i2w000000gb8LAAQ; [1]=https://bit.ly/2v43PxV [2] = bit.ly/2v43PxV
    *                Only used in this Class
    * @param String text
    * @return List<String>
    **/
    @TestVisible
    private List<String> splitter(String text){
        if(String.isNotBlank(text)){
            List<String> linksAndId = text.split('\\|',2);
            linksAndId.add(linksAndId[1].split('//',2).get(1));
            System.debug('LinkandId :: '+linksAndId);
            return linksAndId;
        }
        return new List<String>();
    }
}

/*
Filter Example
' [{column:'Campaign.ShortUrl__c', operator:'equals', value:'http://bit.ly/3clTVIJ'}] '

*/