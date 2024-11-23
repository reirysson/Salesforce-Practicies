/**
 * @description LWC to edit account information.
 * @author Reirysson Costa
 */
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import SUCCESS_UPDATE from '@salesforce/label/c.SuccessUpdate';
import ACCOUNT_UPDATE from '@salesforce/label/c.AccountUpdate';

const TOAST_MESSAGE_BY_ALERT = new Map([
    ["SUCCESS_ACCOUNT_FIELDS", (message) => {return {"title":SUCCESS_UPDATE, "message":ACCOUNT_UPDATE + ' ' + message, "variant":"Success", "mode":"dismissable"}}]
])

export default class EditAccountInfo extends NavigationMixin(LightningElement) {

    @api recordId;

    handleSubmit(event) {
        event.preventDefault();
        let accountFieldsChanged = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(accountFieldsChanged);
        this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get('SUCCESS_ACCOUNT_FIELDS')(accountFieldsChanged.Name));
    }

    handleSuccess(event) {
        console.log('Record updated successfully:', event.detail.id);
        this.navigateToRecordViewPage("Account", event.detail.id);
    }

    navigateToRecordViewPage(object, id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
          attributes: {
            recordId: id,
            objectApiName: object,
            actionName: "view",
          },
        });
    }

    showToastMessage(object){
        const event = new ShowToastEvent({title: object.title, message: object.message, variant: object.variant, mode: object.mode});
        this.dispatchEvent(event);
    }

}