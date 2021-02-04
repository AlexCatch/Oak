//
//  Window.swift
//  Oak
//
//  Created by Alex Catchpole on 04/02/2021.
//

import UIKit
import Resolver

/// Allows us to perform util functions on our UIWindow instance
class Window {
    private var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    func dismissAllSheets(animated: Bool) {
        window?.rootViewController?.dismiss(animated: animated, completion: nil)
    }
}

extension Resolver {
    static func RegisterWindowUtil() {
        register { Window() }.scope(.shared)
    }
}
