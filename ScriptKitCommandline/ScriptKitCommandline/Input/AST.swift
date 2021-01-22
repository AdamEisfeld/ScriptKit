//
//  AST.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public enum TypeAST: Codable {
    case string
    case float
    case int
    case bool
    case custom(_ value: String)
}

extension TypeAST {

    public var stringRepresentation: String {
        switch self {
        case .string:
            return "string"
        case .float:
            return "float"
        case .int:
            return "int"
        case .bool:
            return "bool"
        case .custom(_):
            return "custom"
        }
    }
    
    private static var allSimpleValues: [TypeAST] {
        return [
            .string, .float, .int, .bool
        ]
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let decodedStringValue = try container.decode(String.self)

        var foundSimpleEnum: TypeAST? = nil
        for simpleValue in TypeAST.allSimpleValues {
            if simpleValue.stringRepresentation == decodedStringValue {
                foundSimpleEnum = simpleValue
                break
            }
        }
        
        guard foundSimpleEnum == nil else {
            self = foundSimpleEnum!
            return
        }

        self = .custom(decodedStringValue)
        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .custom(let value):
            try container.encode(value)
        default:
            try container.encode(stringRepresentation)
        }
        
    }
    
}

public struct ClassAST: Codable {
    public var className: String
    public var classExtends: String?
    public var classDocumentation: String
    public var instanceProperties: [PropertyAST]?
    public var instanceFunctions: [FunctionAST]?
    public var classProperties: [PropertyAST]?
    public var classFunctions: [FunctionAST]?
}

public struct PropertyAST: Codable {
    public var propertyName: String
    public var propertyDocumentation: String
    public var propertyType: TypeAST
    public var propertyWritable: Bool
}

public struct FunctionAST: Codable {
    public var functionName: String
    public var functionDocumentation: String
    public var functionArguments: [ArgumentAST]?
    public var functionReturnValue: ReturnValueAST?
}

public struct ArgumentAST: Codable {
    public var argumentName: String
    public var argumentDocumentation: String
    public var argumentType: TypeAST
}

public struct ReturnValueAST: Codable {
    public var valueType: TypeAST
    public var valueDocumentation: String
}
