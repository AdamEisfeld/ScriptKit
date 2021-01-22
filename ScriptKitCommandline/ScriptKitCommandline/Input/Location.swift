//
//  Location.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public struct Location: Codable {
    
    public let path: String
    public let pattern: String?
    
    public func urlsForBase(_ basePath: String) -> [URL] {
        let basePath = "\(basePath)/\(path)"
        
        let baseURL = URL(fileURLWithPath: basePath)
        guard let pattern = pattern else {
            return [baseURL]
        }
        var urls: [URL] = []
        let enumerator = FileManager.default.enumerator(atPath: basePath)
        while let enumeratedPath: String = enumerator?.nextObject() as? String {
            guard enumeratedPath.range(of: "/\(pattern)", options: .regularExpression) != nil else {
                continue
            }
            
            let url = URL(fileURLWithPath: "\(basePath)/\(enumeratedPath)")
            urls.append(url)
        }
        return urls
    }
    
}
