//
//  HTTPLogger.swift
//  
//
//  Created by Kiefer Wiessler on 07/08/2023.
//

import Foundation

public protocol HTTPLogger: AnyObject {
    
    func logHttpRequest(_ request: URLRequest)
    
    func logHttpResponse(statusCode: Int, data: Data)
    
}
