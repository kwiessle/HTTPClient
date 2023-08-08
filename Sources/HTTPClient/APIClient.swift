//
//  APIClient.swift
//  
//
//  Created by Kiefer Wiessler on 07/08/2023.
//

import Foundation

public protocol APIClient: HTTPClient {
    
    func encode<E: Encodable>(_ ojbect: E, with encoder: JSONEncoder) throws -> Data

    func decode<D: Decodable>(data: Data, with decoder: JSONDecoder) throws -> D
    
}

public extension APIClient {
    
    @MainActor
    func apiCall<D: Decodable>(
        _ httpMethod: HTTPMethod,
        url: URL,
        data: Data? = nil,
        credential: String? = nil
    ) async throws -> D {
        let data = try await self.perform(httpMethod, url: url, data: data, credential: credential)
        return try self.decode(data: data, with: JSONDecoder())
    }
    
    @MainActor
    func apiCall<D: Decodable>(
        _ httpMethod: HTTPMethod,
        url: URL,
        dictionary: [String: Any],
        credential: String? = nil
    ) async throws -> D {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try await self.apiCall(httpMethod, url: url, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall<D: Decodable, E: Encodable>(
        _ httpMethod: HTTPMethod,
        url: URL,
        encodable: E,
        credential: String? = nil
    ) async throws -> D {
        let data = try self.encode(encodable, with: JSONEncoder())
        return try await self.apiCall(httpMethod, url: url, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall<D: Decodable>(
        _ httpMethod: HTTPMethod,
        path: String,
        queries: [String: LosslessStringConvertible]? = nil,
        data: Data? = nil,
        credential: String? = nil
    ) async throws -> D {
        let data = try await self.perform(httpMethod, path: path, queries: queries, data: data, credential: credential)
        return try self.decode(data: data, with: JSONDecoder())
    }
    
    @MainActor
    func apiCall<D: Decodable, E: Encodable>(
        _ httpMethod: HTTPMethod,
        path: String,
        queries: [String: LosslessStringConvertible]? = nil,
        encodable: E,
        credential: String? = nil
    ) async throws -> D {
        let data = try self.encode(encodable, with: JSONEncoder())
        return try await self.apiCall(httpMethod, path: path, queries: queries, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall<D: Decodable>(
        _ httpMethod: HTTPMethod,
        path: String,
        queries: [String: LosslessStringConvertible]? = nil,
        dictionary: [String: Any],
        credential: String? = nil
    ) async throws -> D {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try await self.apiCall(httpMethod, path: path, queries: queries, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall(
        _ httpMethod: HTTPMethod,
        url: URL,
        data: Data? = nil,
        credential: String? = nil
    ) async throws {
        try await self.perform(httpMethod, url: url, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall<E: Encodable>(
        _ httpMethod: HTTPMethod,
        url: URL,
        encodable: E,
        credential: String? = nil
    ) async throws {
        let data = try self.encode(encodable, with: JSONEncoder())
        return try await self.apiCall(httpMethod, url: url, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall(
        _ httpMethod: HTTPMethod,
        url: URL,
        dictionary: [String: Any],
        credential: String? = nil
    ) async throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try await self.apiCall(httpMethod, url: url, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall(
        _ httpMethod: HTTPMethod,
        path: String,
        queries: [String: LosslessStringConvertible]? = nil,
        data: Data? = nil,
        credential: String? = nil
    ) async throws {
        try await self.perform(httpMethod, path: path, queries: queries, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall<E: Encodable>(
        _ httpMethod: HTTPMethod,
        path: String,
        queries: [String: LosslessStringConvertible]? = nil,
        encodable: E,
        credential: String? = nil
    ) async throws {
        let data = try self.encode(encodable, with: JSONEncoder())
        return try await self.apiCall(httpMethod, path: path, queries: queries, data: data, credential: credential)
    }
    
    @MainActor
    func apiCall(
        _ httpMethod: HTTPMethod,
        path: String,
        queries: [String: LosslessStringConvertible]? = nil,
        dictionary: [String: Any], credential: String? = nil) async throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try await self.apiCall(httpMethod, path: path, queries: queries, data: data, credential: credential)
    }
    
    func encode<E: Encodable>(_ ojbect: E, with encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(ojbect)
    }

    func decode<D: Decodable>(data: Data, with decoder: JSONDecoder) throws -> D {
        return try decoder.decode(D.self, from: data)
    }
    
}
