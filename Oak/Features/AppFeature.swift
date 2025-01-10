//
//  AppFeature.swift
//  OakOTP
//
//  Created by Alex on 10/01/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature: Reducer {
    @Reducer
    enum RootPath {
        case setup
        case accounts
    }
}
