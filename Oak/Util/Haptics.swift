//
//  Haptics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//

import UIKit
import Dependencies

struct Haptics {
    var generate: (_ type: UINotificationFeedbackGenerator.FeedbackType) -> Void
}

extension Haptics: DependencyKey {
    static var liveValue: Self {
        let generator = UINotificationFeedbackGenerator()
        return Self { type in
            generator.notificationOccurred(type)
        }
    }
    static var previewValue: Self {
        return .liveValue
    }
    static var testValue: Self {
        return .previewValue
    }
}

extension DependencyValues {
    var haptics: Haptics {
        get { self[Haptics.self] }
        set { self[Haptics.self] = newValue }
    }
}
