import { LightningElement , track } from 'lwc';
import Chart from '@salesforce/resourceUrl/Chart';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

const generateRandomNumber = () => {
    return Math.round(Math.random() * 10);
};


export default class MyComponent extends LightningElement {

    @track shortUrl ='';

    handleClick(event){
        this.shortUrl = 'http://www.gogle.com';
    }

}