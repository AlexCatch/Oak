//
//  Haptics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import UIKit
import Resolver

class Haptics {
    let generator = UINotificationFeedbackGenerator()
    
    func generate(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}

extension Resolver {
    static func RegisterHapticsUtil() {
        register { Haptics() }.scope(.shared)
    }
}
