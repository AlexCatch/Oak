//
//  Window.swift
//  Oak
//
//  Created by Alex Catchpole on 04/02/2021.
//

import UIKit
import Dependencies

struct Window {
    var dismissAllSheets: (_ animated: Bool) -> Void
}

extension Window: DependencyKey {
    static var liveValue: Self {
        var window: UIWindow? {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                  let window = windowSceneDelegate.window else {
                return nil
            }
            return window
        }
        return Self { animated in
            window?.rootViewController?.dismiss(animated: animated, completion: nil)
        }
    }
}

extension DependencyValues {
    var window: Window {
        get { self[Window.self] }
        set { self[Window.self] = newValue }
    }
}
