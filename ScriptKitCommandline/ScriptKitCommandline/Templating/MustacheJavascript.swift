//
//  MustacheJavascript.swift
//  Scripter
//
//  Created by Adam Eisfeld on 2021-01-17.
//

import Foundation

public struct MustacheJS {
    
    public static let header =
"""
///////////////////////////////////////////////////////////////
// AUTOGENERATED {{className}} Interface
///////////////////////////////////////////////////////////////
"""
    
    public static let classDefinition =
"""

/**
* @class {{className}}
* @classdesc
{{#classDocumentation}}{{classDocumentation}}{{/classDocumentation}}{{^classDocumentation}}* {{/classDocumentation}}
*/
{{#classExtends}}class {{className}} extends {{classExtends}} {}{{/classExtends}}{{^classExtends}}class {{className}} {}{{/classExtends}}
"""
    
    public static let classProperties =
"""

// Class Properties
{{#classProperties}}
/**
* @property { {{propertyType}} } {{propertyName}} {{propertyDocumentation}}
* @memberof {{className}}
* @static
*/
Object.defineProperty({{className}}, '{{propertyName}}', {
    value : new {{propertyType}}(),
    writable : {{#propertyWritable}}true{{/propertyWritable}}{{^propertyWritable}}false{{/propertyWritable}}
});
{{/classProperties}}
"""
    
    public static let instanceProperties =
"""

// Instance Properties
{{#instanceProperties}}
/**
* @property { {{propertyType}} } {{propertyName}} {{propertyDocumentation}}
* @memberof {{className}}.prototype
* @instance
*/
Object.defineProperty({{className}}.prototype, '{{propertyName}}', {
    value : new {{propertyType}}(),
    writable : {{#propertyWritable}}true{{/propertyWritable}}{{^propertyWritable}}false{{/propertyWritable}}
});
{{/instanceProperties}}
"""
    
    public static let classFunctions =
"""

// Class Functions
{{#classFunctions}}
/**
* {{functionDocumentation}}
* @memberof {{className}}
* @static
{{#functionArguments}}* @param { {{argumentType}} } {{argumentName}} {{argumentDocumentation}}{{/functionArguments}}
{{#functionReturnValue}}* @returns { {{valueType}} } {{valueDocumentation}}{{/functionReturnValue}}
*/
{{className}}.{{functionName}} = function({{# each(functionArguments) }}{{ argumentName }}{{^ @last }}, {{/}}{{/}}) {};
{{/classFunctions}}
"""
    
    public static let instanceFunctions =
"""

// Instance Functions
{{#instanceFunctions}}
/**
* {{functionDocumentation}}
* @memberof {{className}}.prototype
* @instance
{{#functionArguments}}* @param { {{argumentType}} } {{argumentName}} {{argumentDocumentation}}{{/functionArguments}}
{{#functionReturnValue}}* @returns { {{valueType}} } {{valueDocumentation}}{{/functionReturnValue}}
*/
{{className}}.{{functionName}}.prototype = function({{# each(functionArguments) }}{{ argumentName }}{{^ @last }}, {{/}}{{/}}) {};
{{/instanceFunctions}}
"""
    
}