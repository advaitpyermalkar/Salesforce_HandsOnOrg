/**
 * @File Name          : BitlyServiceResponse.cls
 * @Description        : This class is genrates Response for BitlyService Functions .
 *                       The following class supports Bitly Api v4
 *                       For documentation reffer : https://dev.bitly.com/v4/
 * @Author             : Advait Yermalkar
 * @Group              :
 * @Last Modified By   : Advait Yermalkar
 * @Last Modified On   : 3/4/2020, 3:49:52 PM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    2/26/2020   Advait Yermalkar     Initial Version
**/
public class BitlyServiceResponse {

    /*
    Description : This is a custom response class.
                    provides comman response to Shorten request.
    */
    public class ShortenResponse{
        public string status;
        public string link;
        public string message;

        //constructor
        public ShortenResponse(String status , String link , String message){
            this.status = status;
            this.link = link;
            this.message = message;
        }
    }

    /*
    Description : this is a custom response class.
                provides comman response to all other Bitly requests.
    */
    public class BitlyMyResponse{
        public Boolean isSuccess;
        public MetricResponse metricResponse;
        public ErrorResponse errorResponse;
        public ClickResponse clickResponse;
        public String status;

        // Constructors
        public BitlyMyResponse(Boolean isSuccess , String status){
            if(isSuccess!=null && String.isNotBlank(status)){
                this.isSuccess = isSuccess;
                this.status = status;
            }
        }

        public BitlyMyResponse(Boolean isSuccess, MetricResponse metricResponse , String status){
            if(isSuccess!=null && String.isNotBlank(status) && metricResponse!=null){
                this.isSuccess = isSuccess;
                this.status = status;
                this.metricResponse = metricResponse;
            }
        }

        public BitlyMyResponse(Boolean isSuccess, ErrorResponse errorResponse , String status){
            if(isSuccess!=null && String.isNotBlank(status) && errorResponse!=null){
                this.isSuccess = isSuccess;
                this.status = status;
                this.errorResponse = errorResponse;
            }
        }

        public BitlyMyResponse(Boolean isSuccess, ClickResponse clickResponse , String status){
            if(isSuccess!=null && String.isNotBlank(status) && clickResponse!=null){
                this.isSuccess = isSuccess;
                this.status = status;
                this.clickResponse = clickResponse;
            }
        }
    }

    /*
    Description : stores metric response from metric bitly service
    supported bitly services
    1/countries 2/reffering_domains
    */
    public class MetricResponse{
        public Integer units;
        public String facet;
        public String unit_reference;
        public String unit;
        public List<Metrics> metrics;
    }

    /*
    Description : Subclass for MetricResponse
    */
    public class Metrics{
        public Integer clicks;
        public String value;
    }

    /*
    Description : stores All Error response from bitly service
    supported bitly services
    1/countries 2/reffering_domains 3/clicks/summary
    */
    public class ErrorResponse{
        public String message;
        public List<Errors> errors;
        public String resource;
        public String description;
    }

    /*
    Description : Subclass for ErrorResponse
    */
    public class Errors{
        public String field;
        public String message;
        public String error_code;
    }

    /*
    Description : stores All Success response from click bitly service
    supported bitly services
    1/clicks/summary
    */
    public class ClickResponse{
        public Integer units;
        public String unit;
        public Integer total_clicks;
        public String unit_reference;
    }
}