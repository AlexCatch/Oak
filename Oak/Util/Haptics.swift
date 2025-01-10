//
//  Haptics.swift
//  Oak
//
//  Created by Alex Catchpole on 02/02/2021.
//
import Foundation
import UIKit
import Dependencies

struct Haptics: Sendable {
    var generate: @Sendable (_ type: UINotificationFeedbackGenerator.FeedbackType) async -> Void
}

extension Haptics: DependencyKey {
    static var liveValue: Self {
        return Haptics { type in
            let generator = await UINotificationFeedbackGenerator()
            await generator.notificationOccurred(type)
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
