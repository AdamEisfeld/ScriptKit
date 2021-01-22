
///////////////////////////////////////////////////////////////
// AUTOGENERATED ModularVector2Scriptable Interface
///////////////////////////////////////////////////////////////

import JavaScriptCore

/** A 2D Vector */
@objc public protocol ModularVector2Scriptable: JSExport {

    // Instance Properties
    
    /** The x position of this drawable */
    var x: Float { get set }
    
    /** The y position of this drawable */
    var y: Float { get set }
    

    // Class Functions
    
    /**
    Creates a new vector
        - Parameter x: The x component
    - Parameter y: The y component
    - Returns: (ModularVector2) A new vector*/
    static func makeVector(_ x: Float, _ y: Float) -> ModularVector2
    

}