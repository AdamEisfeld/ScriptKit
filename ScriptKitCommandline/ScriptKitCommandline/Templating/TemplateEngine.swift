//
//  MustacheFormatter.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation
import Mustache

public struct TemplateEngine {
    
    public static func templateStringFromFile(_ path: String?, base: String, fallback: String) throws -> String {
        return path != nil && !path!.isEmpty ? try String(contentsOfFile: "\(base)/\(path!)") : fallback
    }
    
    public static func serialize<E: Encodable>(_ input: E, templateString: String) -> String {
        
        var reserialized: [String : Any]
        do {
            let encoded = try JSONEncoder().encode(input)
            reserialized = try JSONSerialization.jsonObject(with: encoded, options: []) as? [String : Any] ?? [:]
        } catch {
            terminal.signalError("Unable to recode provided json - \(error)")
        }
        
        let template: Template
        do {
            template = try Template(string: templateString)
        } catch {
            terminal.signalError("Unable to create javascript template - \(error)")
        }

        template.register(StandardLibrary.each, forKey: "each")

        let additionalTags: [String : Any] = [
            "newline" : "\n"
        ]
        reserialized["tags"] = additionalTags

        let output: String
        do {
            output = try template.render(reserialized)
        } catch {
            terminal.signalError("Unable to render javascript mustache template - \(error)")
        }

        return output
        
    }

}
