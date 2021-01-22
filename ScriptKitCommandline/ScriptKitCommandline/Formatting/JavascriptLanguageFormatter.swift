//
//  JavascriptLanguageFormatter.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public class JavascriptLanguageFormatter: LanguageFormatterProtocol {
    
    private enum JavascriptTypeAST: String {
        case number = "Number"
        case string = "String"
        case boolean = "Boolean"
        case object = "Object"
    }
    
    public func formattedClassNameFor(_ className: String) -> String {
        return className
    }
    
    public func formattedFunctionNameFor(_ function: FunctionAST) -> String {
        
        return function.functionName
        /**
         When 0 parameters, then it is functionNameCamelCased
         When 1 parameter, then it is functionNameCamelCased+FirstParameter
         When 2+ parameters, then it is functionNameCamelCasedWith+AllParameters
         */
        
        let baseSignature = function.functionName
        
        guard let functionArguments = function.functionArguments, !functionArguments.isEmpty else {
            return baseSignature
        }
        
        guard functionArguments.count > 1 else {
            return baseSignature + functionArguments.first!.argumentName.capitalized
        }
        
        let appendedSignature = "With" + functionArguments.map({$0.argumentName.capitalized}).joined()
        return baseSignature + appendedSignature
    }
    
    public func formattedTypeNameFor(_ type: TypeAST) -> TypeAST {
        switch type {
        case .int, .float:
            return .custom(JavascriptTypeAST.number.rawValue)
        case .string:
            return .custom(JavascriptTypeAST.string.rawValue)
        case .bool:
            return .custom(JavascriptTypeAST.boolean.rawValue)
        default:
            return .custom(JavascriptTypeAST.object.rawValue)
        }
    }
    
    public func formattedDocumentationFor(_ documentation: String) -> String {
        return documentation.multiline(length: 100, prefix: "* ", suffix: "").joined(separator: "\n")
    }
    
}
