//
//  Terminal.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public struct Terminal {
    
    public enum LogLevel: String, Codable {
        case all
        case important
        case none
        public func logTypes() -> [LogType] {
            switch self {
            case .all:
                return [.required, .warning, .error, .message, .fluff]
            case .important:
                return [.required, .error, .warning, .message]
            case .none:
                return [.required]
            }
        }
    }
    
    public enum LogType {
        case required
        case warning
        case error
        case message
        case fluff
    }
    
    public var logLevel: LogLevel = .all
    
    public var arguments: [String : String] {
        var arguments: [String : String] = [:]
        for argument in CommandLine.arguments {
            let argumentComponents = argument.components(separatedBy: "=")
            guard argumentComponents.count == 2 else {
                continue
            }
            arguments[argumentComponents.first!] = argumentComponents.last!
        }
        return arguments
    }
    
    public func signalError(_ message: String) -> Never {
        if logLevel.logTypes().contains(.error) {
            FileHandle.standardError.write("Error: \(message)\n".data(using: .utf8)!)
        }
        exit(1)
    }
    
    public func signalSuccess(_ message: String) {
        if logLevel.logTypes().contains(.message) {
            FileHandle.standardOutput.write("\(message)\n".data(using: .utf8)!)
        }
    }
    
    public func log(_ type: LogType, _ message: String) {
        if logLevel.logTypes().contains(type) {
            FileHandle.standardOutput.write("\(message)\n".data(using: .utf8)!)
        }
    }
    
    @discardableResult
    public func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/usr/bin/env bash"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
}
