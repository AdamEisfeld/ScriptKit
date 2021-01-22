//
//  ScratchPadViewController.swift
//  ScriptKitScratchpad
//
//  Created by Adam Eisfeld on 2021-01-20.
//

import Foundation
import ScriptKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@objcMembers public class ModularVector2: NSObject, ModularVector2Scriptable {
    
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
        super.init()
    }
    
    public static func makeVector(_ x: Float, _ y: Float) -> ModularVector2 {
        return ModularVector2(x: x, y: y)
    }
    
}

@objcMembers public class ModularColor: NSObject, ModularColorScriptable {
    
    public var r: Float
    public var g: Float
    public var b: Float
    public var a: Float
    
    public init(r: Float, g: Float, b: Float, a: Float) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        super.init()
    }
    
    public static func makeColor(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> ModularColor {
        return ModularColor(r: r, g: g, b: b, a: a)
    }
    
}

@objcMembers public class Drawable: NSObject, DrawableScriptable {
    
    public var position: ModularVector2
    public var size: ModularVector2
    public var fillColor: ModularColor
    
    public init(position: ModularVector2, size: ModularVector2, fillColor: ModularColor) {
        self.position = position
        self.size = size
        self.fillColor = fillColor
    }
    
    public static func makeDrawable(_ position: ModularVector2, _ size: ModularVector2, _ color: ModularColor) -> Drawable {
        return Drawable(position: position, size: size, fillColor: color)
    }
    
    public override var description: String {
        return "Drawable frame={\(position.x), \(position.y), \(size.x), \(size.y)} color={\(fillColor.r), \(fillColor.g), \(fillColor.b), \(fillColor.a)}"
    }
    
}

@objcMembers public class Screen: NSObject, ScreenScriptable {
    
    private let view: BridgeView
    
    public init(view: BridgeView) {
        self.view = view
        super.init()
    }
    
    public func addDrawable(_ drawable: Drawable) {
        let scriptedView = BridgeView()
        scriptedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scriptedView)
        
        scriptedView.backgroundColor = BridgeColor(red: CGFloat(drawable.fillColor.r), green: CGFloat(drawable.fillColor.g), blue: CGFloat(drawable.fillColor.b), alpha: CGFloat(drawable.fillColor.a))
        NSLayoutConstraint.activate([
            scriptedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(drawable.position.x)),
            scriptedView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(drawable.position.x)),
            scriptedView.widthAnchor.constraint(equalToConstant: CGFloat(drawable.size.x)),
            scriptedView.heightAnchor.constraint(equalToConstant: CGFloat(drawable.size.y))
        ])
    }
    
    
}

public class ScratchPadViewController: BridgeViewController {
    
    private var testView: BridgeView? = nil
    
    public override func loadView() {
        self.view = BridgeView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        let screen = Screen(view: view)
        
        let initialJavascript =
"""
function run(screen) {
    position = ModularVector2.makeVector(10, 10);
    size = ModularVector2.makeVector(100, 200);
    color = ModularColor.makeColor(51/255, 153/255, 255/255, 1);
    drawable = Drawable.makeDrawable(position, size, color);
    screen.addDrawable(drawable);
    return drawable;
}
"""
        let session = ScriptSession(javascript: initialJavascript)
        session.registerClass(ModularVector2.self)
        session.registerClass(ModularColor.self)
        session.registerClass(Drawable.self)
        let result = session.call("run", withArguments: [screen])
        if let drawable = result?.objectAs(Drawable.self) {
            print("Successfuly created \(drawable)")
        } else {
            print("Failed to create result")
        }
        
    }
    
    
}
