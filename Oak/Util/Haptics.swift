//
//  Haptics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import UIKit

class Haptics {
    static func Generate(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
