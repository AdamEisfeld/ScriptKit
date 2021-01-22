//
//  URL+Utils.swift
//  scriptkit
//
//  Created by Adam Eisfeld on 2021-01-21.
//

import Foundation

public extension URL {
    
    func asDirectory() -> URL {
        guard pathExtension != "" else {
            return self
        }
        return self.deletingLastPathComponent()
    }
    
    func commonPathComponentsBetween(_ fromComponents: [String], _ toComponents: [String]) -> [String] {
        
        // Find number of common path components:
        var i = 0
        var output: [String] = []
        while
            i < toComponents.count &&
            i < fromComponents.count &&
            toComponents[i] == fromComponents[i] {
                output.append(toComponents[i])
                i += 1
        }
        return output
    }
    
    func resolvedComponents() -> [String] {
        return self.asDirectory().standardized.resolvingSymlinksInPath().pathComponents
    }
    
    func relativePathFrom(_ base: URL) -> String {

        let destComponents = self.resolvedComponents()
        let baseComponents = base.resolvedComponents()
        let commonComponents = commonPathComponentsBetween(baseComponents, destComponents)
        
        var relativeComponents = Array(repeating: "..", count: baseComponents.count - commonComponents.count)
        relativeComponents.append(contentsOf: destComponents[commonComponents.count...])
        return relativeComponents.joined(separator: "/")
        
    }
}
