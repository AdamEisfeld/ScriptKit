//
//  BridgeUserInterface.swift
//  ScriptKitScratchpad
//
//  Created by Adam Eisfeld on 2021-01-20.
//

import Foundation
import AppKit
import SwiftUI

/**
 
 The following code has nothing to do with PhyKit. It is just a quick solution for
 reverting to AppKit/NSViewControllers instead of using SwiftUI.
 
 */

public struct ContainerViewUIKit: NSViewControllerRepresentable {
    
    public typealias NSViewControllerType = BridgeViewController
    
    public func makeNSViewController(context: Context) -> BridgeViewController {
        return ScratchPadViewController()
    }
    
    public func updateNSViewController(_ uiViewController: BridgeViewController, context: Context) {
    }
    
}

public typealias BridgeViewController = NSViewController
public typealias BridgeView = NSView
public typealias BridgeColor = NSColor
public typealias BridgeContainerView = ContainerViewUIKit

public extension NSView {
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}
