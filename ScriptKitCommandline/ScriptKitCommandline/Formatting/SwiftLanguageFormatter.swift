//
//  SwiftLanguageFormatter.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public class SwiftLanguageFormatter: LanguageFormatterProtocol {
    
    private enum SwiftTypeAST: String {
        case Int
        case Float
        case Bool
        case String
    }
    
    public func formattedClassNameFor(_ className: String) -> String {
        return "\(className)Scriptable"
    }
    
    public func formattedFunctionNameFor(_ function: FunctionAST) -> String {
        return function.functionName
    }
    
    public func formattedTypeNameFor(_ type: TypeAST) -> TypeAST {
        switch type {
        case .int:
            return .custom(SwiftTypeAST.Int.rawValue)
        case .float:
            return .custom(SwiftTypeAST.Float.rawValue)
        case .bool:
            return .custom(SwiftTypeAST.Bool.rawValue)
        case .string:
            return .custom(SwiftTypeAST.String.rawValue)
        default:
            return type
        }
    }
    
    public func formattedDocumentationFor(_ documentation: String) -> String {
        return documentation.multiline(length: 100, prefix: "", suffix: "").joined(separator: "\n")
    }
    
}
