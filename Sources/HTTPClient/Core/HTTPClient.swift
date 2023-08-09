//
//  HTTPClient.swift
//
//
//  Created by Kiefer Wiessler on 07/08/2023.
//

import Foundation

public protocol HTTPClient {
    
    var baseUrl: String { get }
    
    func httpAuthorizartionValue(for credential: String) -> String?
    
    func configureHttpRequest(_ request: inout URLRequest)

}

public extension HTTPClient {
    
    private func createRequest(_ httpMethod: HTTPMethod, url: URL?, data: Data?, credential: String?) throws -> URLRequest {
        guard let url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = data
        if let credential, let value = self.httpAuthorizartionValue(for: credential) {
            request.addValue(value, forHTTPHeaderField: "Authorization")
        }
        self.configureHttpRequest(&request)
        return request
    }
    
    @discardableResult
    func perform(_ httpMethod: HTTPMethod, url: URL?, data: Data?, credential: String?) async throws -> Data {
        let request = try self.createRequest(httpMethod, url: url, data: data, credential: credential)
        return try await Networker.shared.perform(request: request)
    }
    
    @discardableResult
    func perform(_ httpMethod: HTTPMethod, path: String, queries: [String: LosslessStringConvertible]?, data: Data?, credential: String?) async throws -> Data {
        guard var urlComponents = URLComponents(string: self.baseUrl + path) else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = queries?.map { URLQueryItem(name: $0.key, value: $0.value.description) }
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        return try await self.perform(httpMethod, url: url, data: data, credential: credential)
    }
    
    func httpAuthorizartionValue(for credential: String) -> String? {
        return nil
    }
    
    func configureHttpRequest(_ request: inout URLRequest) {
        
    }
    
}




