//
//  FileIO.swift
//  scriptkit
//
//  Created by Adam Eisfeld on 2021-01-21.
//

import Foundation

public class FileIO {
    static func write(_ string: String, to path: String, named name: String) throws {
        let pathWithName = "\(path)/\(name)"
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        try string.write(to: URL(fileURLWithPath: pathWithName), atomically: true, encoding: .utf8)
    }
}
