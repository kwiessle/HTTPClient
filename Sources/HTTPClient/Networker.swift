//
//  File.swift
//  
//
//  Created by Kiefer Wiessler on 06/08/2023.
//

import Foundation

public class Networker: HTTPLogger {
    
    public var urlSession: URLSession = .shared
    
    public static let shared: Networker = Networker()
    
    weak public var logger: HTTPLogger?
    
    private var currenLogger: HTTPLogger {
        return self.logger ?? self
    }
    
    fileprivate init() { }
    
    @discardableResult
    public func perform(request: URLRequest) async throws -> Data {
        let (data, urlResponse) = try await self.urlSession.data(for: request)
        let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? -1
        self.currenLogger.logHttpRequest(request)
        switch statusCode {
        case 200...299:
            self.currenLogger.logHttpResponse(statusCode: statusCode, data: data)
            return data
        case 400...499:
            self.currenLogger.logHttpResponse(statusCode: statusCode, data: data)
            throw self.httpError(statusCode: statusCode, data: data)
        case 500...500:
            self.currenLogger.logHttpResponse(statusCode: statusCode, data: data)
            throw self.httpError(statusCode: statusCode, data: data)
        default:
            throw URLError(.badServerResponse, userInfo: data.jsonObject ?? [:])
        }
    }
    
    public func logHttpRequest(_ request: URLRequest) {
        #if !RELEASE
        print("\n")
        print("🌐 [\(request.httpMethod!)] - \(request.url!.absoluteString)")
        if let headerFields = request.allHTTPHeaderFields {
            print("")
            headerFields.forEach({ field in
                print(field.key + ": " + field.value)
            })
        }
        if let jsonString = request.httpBody?.jsonString {
            print("\n" + jsonString)
        }
        print("")
        #endif
    }
    
    public func logHttpResponse(statusCode: Int, data: Data) {
        #if !RELEASE
        guard let jsonString = data.jsonString,
              let httpStatus = HTTPStatus(rawValue: statusCode)
        else {
            print("\nUnable to print response...\n")
            return
        }
        var emoji: String
        switch statusCode {
        case 200...299: emoji = "✅"
        case 400...599: emoji = "❌"
        default: emoji = "⁉️"
        }
        print(emoji + " [\(statusCode.description)] - \(httpStatus.message)")
        print(jsonString + "\n")
        print("")
        #endif
    }

    func httpError(statusCode code: Int, data: Data) -> NSError {
        let domain = HTTPStatus(rawValue: code)?.message ?? "Networking error"
        return NSError(domain: domain, code: code, userInfo: data.jsonObject)
    }
    
}

