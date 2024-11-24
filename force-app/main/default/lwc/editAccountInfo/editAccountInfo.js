/**
 * @description LWC to edit account information.
 * @author Reirysson Costa
 */
import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import SUCCESS_UPDATE from '@salesforce/label/c.SuccessUpdate';
import ACCOUNT_UPDATE from '@salesforce/label/c.AccountUpdate';
import UPDATE_ACCOUNT from '@salesforce/label/c.UpdateAccount';
import FAILED_ACCOUNT from '@salesforce/label/c.FailedUpdate';
import WRONG_DATA from '@salesforce/label/c.WrongData';

const TOAST_MESSAGE_BY_ALERT = new Map([
    ["SUCCESS_ACCOUNT_FIELDS", (message) => {return {"title":SUCCESS_UPDATE, "message":ACCOUNT_UPDATE + ' ' + message, "variant":"success", "mode":"dismissable"}}],
    ["FAILED_UPDATE_ACCOUNT", (message) => {return {"title":FAILED_ACCOUNT, "message":WRONG_DATA + ' ' + message, "variant":"error", "mode":"dismissable"}}]
])

export default class EditAccountInfo extends NavigationMixin(LightningElement) {

    @api recordId;

    @track accountFieldsChanged;

    handleSubmit(event) {
        event.preventDefault();
        this.accountFieldsChanged = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(this.accountFieldsChanged);
    }

    handleSuccess(event) {
        this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get('SUCCESS_ACCOUNT_FIELDS')(this.accountFieldsChanged.Name));
        this.navigateToRecordViewPage("Account", event.detail.id);
    }

    handleError(event){
        this.showToastMessage(TOAST_MESSAGE_BY_ALERT.get('FAILED_UPDATE_ACCOUNT')((event.detail?.output?.errors[0]?.message != null) ? event.detail?.output?.errors[0]?.message : event.detail.message));
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

    UPDATE_ACCOUNT = UPDATE_ACCOUNT;

}