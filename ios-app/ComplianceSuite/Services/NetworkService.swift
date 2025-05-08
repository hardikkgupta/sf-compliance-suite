import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://api.compliance-suite.com"
    
    private init() {}
    
    func fetchPolicies() async throws -> [CompliancePolicy] {
        guard let url = URL(string: "\(baseURL)/api/compliance/policies") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let policies = try JSONDecoder().decode([CompliancePolicy].self, from: data)
            return policies
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func syncWithServer() async throws {
        guard let url = URL(string: "\(baseURL)/api/sync") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
    
    func reportViolation(_ violation: Violation, forPolicy policyId: String) async throws {
        guard let url = URL(string: "\(baseURL)/api/compliance/policies/\(policyId)/violations") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(violation)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
    }
} 