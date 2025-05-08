import { LightningElement, wire, track } from 'lwc';
import validatePolicies from '@salesforce/apex/ComplianceEngine.validatePolicies';

export default class PolicyDashboard extends LightningElement {
    @track records = [];
    @track error;
    @track loading = false;
    
    connectedCallback() {
        this.loadData();
    }
    
    loadData() {
        this.loading = true;
        // Example record IDs - in real implementation, these would come from a query
        const recordIds = ['001000000000001'];
        
        validatePolicies({ recordIds: recordIds })
            .then(result => {
                this.records = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.records = [];
            })
            .finally(() => {
                this.loading = false;
            });
    }
    
    handleRefresh() {
        this.loadData();
    }
} 