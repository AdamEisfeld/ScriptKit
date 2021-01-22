//
//  Target.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public struct Target: Codable {
    public let name: String?
    public let input: Input
    public let output: Output
}
