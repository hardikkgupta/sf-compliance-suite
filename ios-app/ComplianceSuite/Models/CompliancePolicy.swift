import Foundation

struct CompliancePolicy: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let status: ComplianceStatus
    let lastChecked: Date
    let violations: [Violation]
    
    enum ComplianceStatus: String, Codable {
        case compliant
        case nonCompliant
        case pending
        case error
    }
}

struct Violation: Identifiable, Codable {
    let id: String
    let description: String
    let severity: ViolationSeverity
    let detectedAt: Date
    let resolvedAt: Date?
    
    enum ViolationSeverity: String, Codable {
        case low
        case medium
        case high
        case critical
    }
}

// MARK: - Sample Data
extension CompliancePolicy {
    static let samplePolicies: [CompliancePolicy] = [
        CompliancePolicy(
            id: "1",
            name: "Data Privacy Policy",
            description: "Ensures compliance with data protection regulations",
            status: .compliant,
            lastChecked: Date(),
            violations: []
        ),
        CompliancePolicy(
            id: "2",
            name: "Security Standards",
            description: "Enforces security best practices",
            status: .nonCompliant,
            lastChecked: Date(),
            violations: [
                Violation(
                    id: "v1",
                    description: "Weak password policy",
                    severity: .high,
                    detectedAt: Date(),
                    resolvedAt: nil
                )
            ]
        ),
        CompliancePolicy(
            id: "3",
            name: "Access Control",
            description: "Manages user access and permissions",
            status: .pending,
            lastChecked: Date(),
            violations: []
        )
    ]
} 