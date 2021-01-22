//
//  Input.swift
//  scriptkit
//
//  Created by Adam Eisfeld on 2021-01-21.
//

import Foundation

public struct Input: Codable {
    public let schemas: [Location]
    public let swiftTemplatePath: String?
    public let javascriptTemplatePath: String?
    public let vscodeTemplatePath: String?
}
