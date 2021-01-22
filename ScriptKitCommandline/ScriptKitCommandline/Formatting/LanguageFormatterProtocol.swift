//
//  LanguageFormatterProtocol.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public protocol LanguageFormatterProtocol {
    func formattedClassNameFor(_ className: String) -> String
    func formattedFunctionNameFor(_ function: FunctionAST) -> String
    func formattedTypeNameFor(_ type: TypeAST) -> TypeAST
    func formattedDocumentationFor(_ documentation: String) -> String
}

public extension LanguageFormatterProtocol {
    
    func format(_ classAST: ClassAST) -> ClassAST {
        
        let className = formattedClassNameFor(classAST.className)
        let classExtends = classAST.classExtends
        let classDocumentation = formattedDocumentationFor(classAST.classDocumentation)
        
        var classProperties: [PropertyAST] = []
        for property in classAST.classProperties ?? [] {
            let formattedProperty = formatProperty(property)
            classProperties.append(formattedProperty)
        }
        
        var instanceProperties: [PropertyAST] = []
        for property in classAST.instanceProperties ?? [] {
            let formattedProperty = formatProperty(property)
            instanceProperties.append(formattedProperty)
        }
        
        var classFunctions: [FunctionAST] = []
        for function in classAST.classFunctions ?? [] {
            let formattedFunction = formatFunction(function)
            classFunctions.append(formattedFunction)
        }
        
        var instanceFunctions: [FunctionAST] = []
        for function in classAST.instanceFunctions ?? [] {
            let formattedFunction = formatFunction(function)
            instanceFunctions.append(formattedFunction)
        }
        
        let formattedAST = ClassAST(className: className, classExtends: classExtends, classDocumentation: classDocumentation, instanceProperties: instanceProperties, instanceFunctions: instanceFunctions, classProperties: classProperties, classFunctions: classFunctions)
        return formattedAST
    }
    
    private func formatProperty(_ property: PropertyAST) -> PropertyAST {
        let propertyName = property.propertyName
        let propertyDocumentation = property.propertyDocumentation
        let propertyType = formattedTypeNameFor(property.propertyType)
        let propertyWritable = property.propertyWritable
        return PropertyAST(propertyName: propertyName, propertyDocumentation: propertyDocumentation, propertyType: propertyType, propertyWritable: propertyWritable)
    }
    
    private func formatFunction(_ function: FunctionAST) -> FunctionAST {
        let functionName = formattedFunctionNameFor(function)
        let functionDocumentation = function.functionDocumentation
        var functionArguments: [ArgumentAST] = []
        for currentArgument in function.functionArguments ?? [] {
            let argumentName = currentArgument.argumentName
            let argumentDocumentation = currentArgument.argumentDocumentation
            let argumentType = formattedTypeNameFor(currentArgument.argumentType)
            let argument = ArgumentAST(argumentName: argumentName, argumentDocumentation: argumentDocumentation, argumentType: argumentType)
            functionArguments.append(argument)
        }
        var functionReturnValue: ReturnValueAST?
        if let currentReturnValue = function.functionReturnValue {
            let returnValueDocumentation = currentReturnValue.valueDocumentation
            let returnValueType = formattedTypeNameFor(currentReturnValue.valueType)
            functionReturnValue = ReturnValueAST(valueType: returnValueType, valueDocumentation: returnValueDocumentation)
        } else {
            functionReturnValue = nil
        }
        let function = FunctionAST(functionName: functionName, functionDocumentation: functionDocumentation, functionArguments: functionArguments, functionReturnValue: functionReturnValue)
        return function
    }
    
}
