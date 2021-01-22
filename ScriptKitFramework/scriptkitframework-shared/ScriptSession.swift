//
//  ScriptSession.swift
//  ScriptKitFramework
//
//  Created by Adam Eisfeld on 2021-01-20.
//

import Foundation
import JavaScriptCore

public class ScriptResult {
    
    public let jsValue: JSValue
    
    public init(jsValue: JSValue) {
        self.jsValue = jsValue
    }
    
    public func objectAs<T: Any>(_ type: T.Type) -> T? {
        return jsValue.toObject() as? T
    }
    
}

public class ScriptSession {
    
    public typealias Function = ((_ inputs: NSDictionary)->(Any?))
    
    private let context: JSContext

    public init(javascript: String) {
        guard let context = JSContext() else {
            fatalError("Unable to create JSContext")
        }
        self.context = context
        self.context.evaluateScript(javascript)
    }

    public func appendObject(_ identifier: String, _ object: Any) {
        context.setObject(object, forKeyedSubscript: identifier as NSString)
    }
    
    public func appendSource(_ javascript: String) {
        context.evaluateScript(javascript)
    }
    
    public func registerClass(_ classType: JSExport.Type) {
        context.setObject(classType, forKeyedSubscript: String(describing: classType) as NSString)
    }
    
    @discardableResult
    public func call(_ functionName: String, withArguments arguments: [Any] = []) -> ScriptResult? {
        guard let function = context.objectForKeyedSubscript(functionName) else {
            print("Unable to find function \(functionName)")
            return nil
        }
        if let result = function.call(withArguments: arguments) {
            return ScriptResult(jsValue: result)
        }
        
        return nil
    }
    
}
