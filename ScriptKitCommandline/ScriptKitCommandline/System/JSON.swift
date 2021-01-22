//
//  JSON.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public struct JSON {
    
    static func decode<D: Decodable>(_ url: URL, to type: D.Type) throws -> D {
        let data = try Data(contentsOf: url)
        let result = try JSONDecoder().decode(D.self, from: data)
        return result
    }
    
    static func decode<D: Decodable>(_ input: [String : String], to type: D.Type) throws -> D {
        let encoded = try JSONEncoder().encode(input)
        let result = try JSONDecoder().decode(D.self, from: encoded)
        return result
    }
    
}
