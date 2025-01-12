//
//  AppFeature.swift
//  OakOTP
//
//  Created by Alex on 10/01/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
enum AppFeature {
    case setup(SetupFeature)
    case accounts(AccountsFeature)
    
    static var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setup(.setupComplete):
                state = .accounts(AccountsFeature.State())
                return .none
            case .setup:
                return .none
            case .accounts:
                return .none
            }
        }
        .ifCaseLet(\.setup, action: \.setup) {
            SetupFeature()
        }
        .ifCaseLet(\.accounts, action: \.accounts) {
            AccountsFeature()
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        switch store.case {
        case .setup(let store):
            return AnyView(SetupView(store: store))
        case .accounts(let store):
            return AnyView(AccountsView(store: store))
        }
    }
}
