//
//  String+Utils.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public extension String {
    
    func multiline(length: Int, prefix: String = "", suffix: String = "") -> [String] {
        
        guard length < self.count else {
            return ["\(prefix)\(self)\(suffix)"]
        }
        
        var shiftedLength = length
        var start: Index
        var end: Index
        var finish: Bool = false
        var allFinished: Bool = false
        repeat {
            if shiftedLength >= self.count {
                finish = true
                allFinished = true
            } else {
                start = self.index(self.startIndex, offsetBy: shiftedLength)
                end = self.index(self.startIndex, offsetBy: shiftedLength + 1)
                if self[start..<end] == " " {
                    finish = true
                }
                shiftedLength += 1
            }
        } while !finish
        
        let trimStart = self.startIndex
        let trimEnd = self.index(self.startIndex, offsetBy: shiftedLength)
        let trimmed = String(self[trimStart..<trimEnd])
        var results = ["\(prefix)\(trimmed)\(suffix)"]
        
        if !allFinished {
            let remainingEnd = self.endIndex
            let remaining = String(self[trimEnd..<remainingEnd])
            results.append(contentsOf: remaining.multiline(length: length, prefix: prefix, suffix: suffix))
        }
        
        return results
    }
    
}
