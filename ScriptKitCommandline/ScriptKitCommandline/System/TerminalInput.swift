//
//  TerminalInput.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public struct TerminalInput: Codable {
    
    public let configPath: String
    public let verbosity: Terminal.LogLevel?

}
