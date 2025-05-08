# Salesforce Compliance & Mobility Suite

A comprehensive compliance management solution built on Salesforce, featuring real-time policy dashboards, mobile synchronization, and automated auditing capabilities.

## Architecture Overview

### Core Components

1. **Salesforce Compliance Engine**
   - Built with Apex and Lightning Web Components (LWC)
   - Real-time policy monitoring and enforcement
   - Heroku deployment for scalability

2. **Policy Dashboard (Angular Micro-frontend)**
   - Modern UI for compliance monitoring
   - Real-time data visualization
   - Integration with Salesforce via REST APIs

3. **iOS Companion App**
   - Built with Swift/SwiftUI
   - Offline data synchronization
   - Push notification support
   - Native mobile experience

4. **API Gateway (Node.js)**
   - RESTful API endpoints
   - Data synchronization between MongoDB and Salesforce
   - Authentication and authorization
   - Rate limiting and caching

5. **Data Layer**
   - MongoDB for flexible document storage
   - Salesforce for core compliance data
   - Bi-directional synchronization

6. **Testing & Monitoring**
   - Selenium for web automation
   - Appium for mobile testing
   - Splunk for observability
   - Postman for API testing

## Project Structure

```
sf-compliance-suite/
├── force-app/                    # Salesforce components
│   ├── main/default/
│   │   ├── classes/             # Apex classes
│   │   ├── lwc/                 # Lightning Web Components
│   │   └── objects/             # Custom objects
├── angular-dashboard/           # Angular micro-frontend
├── ios-app/                     # Swift/SwiftUI iOS application
├── api-gateway/                 # Node.js API gateway
├── tests/                       # Test automation
│   ├── selenium/
│   ├── appium/
│   └── postman/
└── docs/                        # Documentation
```

## Setup Instructions

### Prerequisites
- Salesforce Developer Edition org
- Node.js 16+
- MongoDB 4.4+
- Xcode 13+ (for iOS development)
- Java 11+ (for Selenium/Appium)
- Docker (for containerization)

### Installation

1. **Salesforce Setup**
   ```bash
   sfdx force:auth:web:login -a YourDevHub
   sfdx force:source:push
   ```

2. **Angular Dashboard**
   ```bash
   cd angular-dashboard
   npm install
   ng serve
   ```

3. **API Gateway**
   ```bash
   cd api-gateway
   npm install
   npm start
   ```

4. **iOS App**
   ```bash
   cd ios-app
   pod install
   open ComplianceSuite.xcworkspace
   ```

## Development Guidelines

- Follow Salesforce best practices for Apex and LWC development
- Maintain test coverage above 85%
- Use TypeScript for Angular components
- Follow Swift style guide for iOS development
- Document all API endpoints using OpenAPI/Swagger

## Testing

```bash
# Run Selenium tests
cd tests/selenium
npm test

# Run Appium tests
cd tests/appium
npm test

# Run API tests
cd tests/postman
newman run collection.json
```

## Monitoring

- Splunk dashboards for real-time monitoring
- Salesforce debug logs
- API gateway metrics
- Mobile app analytics

## License

MIT License - See LICENSE file for details 