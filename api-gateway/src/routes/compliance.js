const express = require('express');
const router = express.Router();
const jsforce = require('jsforce');
const logger = require('../utils/logger');

// Initialize Salesforce connection
const conn = new jsforce.Connection({
    loginUrl: process.env.SF_LOGIN_URL
});

// Middleware to ensure Salesforce authentication
const ensureSFAuth = async (req, res, next) => {
    try {
        if (!conn.accessToken) {
            await conn.login(
                process.env.SF_USERNAME,
                process.env.SF_PASSWORD + process.env.SF_SECURITY_TOKEN
            );
        }
        next();
    } catch (error) {
        logger.error('Salesforce authentication error:', error);
        res.status(401).json({ error: 'Authentication failed' });
    }
};

// Get compliance status for records
router.get('/status', ensureSFAuth, async (req, res) => {
    try {
        const { recordIds } = req.query;
        
        if (!recordIds) {
            return res.status(400).json({ error: 'Record IDs are required' });
        }

        const ids = recordIds.split(',');
        const results = await conn.apex.post('/ComplianceEngine/validatePolicies', { recordIds: ids });
        
        res.json(results);
    } catch (error) {
        logger.error('Error fetching compliance status:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get compliance history
router.get('/history', ensureSFAuth, async (req, res) => {
    try {
        const { recordId, startDate, endDate } = req.query;
        
        if (!recordId) {
            return res.status(400).json({ error: 'Record ID is required' });
        }

        const query = `
            SELECT Id, Name, Compliance_Status__c, Last_Check_Date__c
            FROM Compliance_History__c
            WHERE Record_Id__c = '${recordId}'
            ${startDate ? `AND Last_Check_Date__c >= ${startDate}` : ''}
            ${endDate ? `AND Last_Check_Date__c <= ${endDate}` : ''}
            ORDER BY Last_Check_Date__c DESC
        `;

        const result = await conn.query(query);
        res.json(result.records);
    } catch (error) {
        logger.error('Error fetching compliance history:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router; 