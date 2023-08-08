//
//  File.swift
//  
//
//  Created by Kiefer Wiessler on 07/08/2023.
//

import Foundation

extension Data {
    
    var jsonObject: [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self) as? [String: Any])
    }
    
    var jsonString: String? {
        guard !self.isEmpty,
              let jsonObject = self.jsonObject,
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }
        return jsonString
    }
}
